// Offline audit. Reads original archives and an explicit, read-only DB snapshot.
const fs = require('node:fs');
const path = require('node:path');
const { topWithTies } = require('./lib/mlpnBookTeamRecords.cjs');
const { normalize, resolveWordPressMatch } = require('./lib/mlpnBookArchiveValidation.cjs');
const root = path.resolve(__dirname, '../..');
const inputDir = path.join(root, '.local');
const archiveDir = process.argv[2];
if (!archiveDir) throw new Error('Pass the directory containing the original L98 files.');
const db = JSON.parse(fs.readFileSync(path.join(inputDir, 'book-all-matches-20261121.json')));
const wp = JSON.parse(fs.readFileSync(path.join(inputDir, 'book-wp-match-source.json')));
const leagueNames = { '1st': 'I liga', '2nd': 'II liga', '3rd': 'III liga' };
function ini(text) {
  const result = {}; let section;
  for (const line of text.split(/\r?\n/)) {
    const t = line.trim(); const s = t.match(/^\[(.+)\]$/);
    if (s) { section = result[s[1]] = {}; continue; }
    const at = t.indexOf('='); if (section && at > 0) section[t.slice(0, at)] = t.slice(at + 1);
  }
  return result;
}
function score(value) { return /^\d+$/.test(String(value)) ? Number(value) : null; }
function originalDate(round, index) {
  const epoch = Number(round[`AT${index}`]);
  if (epoch > 0) {
    const parts = Object.fromEntries(new Intl.DateTimeFormat('sv-SE', { timeZone: 'Europe/Warsaw', year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hourCycle: 'h23' }).formatToParts(new Date(epoch * 1000)).map(p => [p.type, p.value]));
    return { date: `${parts.year}-${parts.month}-${parts.day}`, time: `${parts.hour}:${parts.minute}` };
  }
  const parsed = (round.D1 || '').match(/^(\d{1,2})\.(\d{1,2})\.(\d{4})$/);
  return { date: parsed ? `${parsed[3]}-${parsed[2].padStart(2, '0')}-${parsed[1].padStart(2, '0')}` : null, time: null };
}
const original = [];
for (const file of fs.readdirSync(archiveDir).filter(file => /^(I{1,3})_liga.*\d{4}.*\.l98$/.test(file))) {
  const sections = ini(fs.readFileSync(path.join(archiveDir, file), 'utf8'));
  const year = Number(file.match(/\d{4}/)[0]);
  const league = { I: '1st', II: '2nd', III: '3rd' }[file.match(/^(I+)/)[0]];
  for (let r = 1; r <= Number(sections.Options.Rounds); r++) {
    const round = sections[`Round${r}`]; if (!round) continue;
    for (let i = 1; i <= Number(sections.Options.Matches); i++) {
      const h = round[`TA${i}`]; const a = round[`TB${i}`];
      if (!Number(h) || !Number(a)) continue;
      const home = (sections.Teams[h] || '').trim(); const away = (sections.Teams[a] || '').trim();
      const hg = score(round[`GA${i}`]); const ag = score(round[`GB${i}`]);
      const note = round[`NT${i}`] || '';
      const walkover = round[`TI${i}`] === '1' || /walkow?er|walkover/i.test(note);
      original.push({ source: file, sourceRef: `Round${r}/mecz${i}`, year, league, round: r, home, away, hg, ag, ...originalDate(round, i), status: hg == null || ag == null ? 'unknown' : walkover ? 'walkover' : 'completed', note });
    }
  }
}
const wpExcluded = [];
for (const m of wp) {
  const { home, away, status, exclude, reason } = resolveWordPressMatch(m, db);
  if (reason) wpExcluded.push({ id: m.postID, reason });
  if (exclude) continue;
  original.push({ source: 'Kopia WordPress MLPN 2018–2025', sourceRef: `mecz ${m.postID}`, year: m.year, league: m.leagueCode, home, away, hg: score(m.scoreHome), ag: score(m.scoreAway), date: /^\d{4}-\d{2}-\d{2}$/.test(m.date) && !m.date.startsWith('0000') ? m.date : null, time: m.time || null, status });
}
for (const m of db.filter(m => m.season_year === 2026)) original.push({ source: 'Protokoły MLPN 2026', sourceRef: m.id, year: 2026, league: m.league_code, round: m.round, home: m.home_team_name, away: m.away_team_name, hg: m.home_goals, ag: m.away_goals, date: m.match_date, time: m.match_time, status: m.status.startsWith('walkover') ? 'walkover' : m.status });
for (const m of original) {
  const candidates = db.filter(d => d.season_year === m.year && d.league_code === m.league && d.home_goals === m.hg && d.away_goals === m.ag && normalize(d.home_team_name) === normalize(m.home) && normalize(d.away_team_name) === normalize(m.away));
  if (candidates.length === 1) m.sourceUrl = `/mecz/${candidates[0].id}?sezon=${m.year}`;
}
const completed = original.filter(m => m.status === 'completed' && m.hg != null && m.ag != null);
const describe = m => `${leagueNames[m.league]} · ${m.year} · ${m.home} – ${m.away} ${m.hg}:${m.ag}${m.date ? ` · ${m.date}` : ''}`;
const matchDefs = [
  ['archive-match-total', 'Najwięcej goli w meczu w archiwum', 'goli', m => m.hg + m.ag],
  ['archive-match-margin', 'Największa wygrana w archiwum', 'goli przewagi', m => Math.abs(m.hg - m.ag)],
  ['archive-match-team', 'Najwięcej goli drużyny w meczu w archiwum', 'goli', m => Math.max(m.hg, m.ag)],
];
const records = matchDefs.map(([id, label, unit, metric]) => {
  const ranked = topWithTies(completed.map(m => ({ holder: `${m.home} — ${m.away}`, value: metric(m), detail: describe(m), sourceUrl: m.sourceUrl, match: m })));
  const first = ranked[0];
  return { id, group: 'matches', label, unit, value: first.value, holder: first.holder, detail: first.detail, season: first.match.year, leagueCode: first.match.league, scope: 'Zachowane wyniki · 2003–2026', status: 'partial', sourceLabel: `${first.match.source} · ${first.match.sourceRef}`, sourceUrl: first.sourceUrl, sourceNote: `Przeszukano ${completed.length} rozstrzygniętych wpisów w oryginalnych plikach ligi 2003–2017, kopii starej strony 2018–2025 i protokołach 2026. Wczesne sezony mają brakujące wyniki, dlatego jest to maksimum zachowanych wyników. Jawne walkowery pominięto; w starej bazie WordPress część wyników administracyjnych nie ma osobnego oznaczenia. Ranking pokazuje wszystkie remisy na granicy piątego miejsca.`, ranking: ranked.map(({ match, ...row }) => row) };
});
const predicates = { wins: (a,b) => a>b, draws:(a,b)=>a===b, losses:(a,b)=>a<b, winless:(a,b)=>a<=b, unbeaten:(a,b)=>a>=b };
const seasonTeams = new Map();
for (const match of original.filter(m => !['not_played','cancelled'].includes(m.status))) for (const side of ['home','away']) {
  const team = match[side]; if (!team) continue; const key = `${match.year}/${match.league}/${normalize(team)}`;
  if (!seasonTeams.has(key)) seasonTeams.set(key, []);
  seasonTeams.get(key).push({ ...match, team, gf: side === 'home' ? match.hg : match.ag, ga: side === 'home' ? match.ag : match.hg });
}
const excluded = [];
const series = Object.fromEntries(Object.keys(predicates).map(k => [k, []]));
for (const [key, matches] of seasonTeams) {
  if (matches.some(m => !m.date || m.hg == null || m.ag == null)) { excluded.push(key); continue; }
  matches.sort((a,b) => a.date.localeCompare(b.date) || (a.time || '').localeCompare(b.time || ''));
  if (matches.some((m,i) => i && m.date === matches[i-1].date && (!m.time || !matches[i-1].time || m.time === matches[i-1].time))) { excluded.push(key); continue; }
  for (const [kind, pred] of Object.entries(predicates)) {
    let current=[]; let best=[];
    for (const m of matches) { if (pred(m.gf,m.ga)) { current.push(m); if(current.length>best.length) best=[...current]; } else current=[]; }
    if(best.length) series[kind].push({ holder: best[0].team, value: best.length, detail: `${leagueNames[best[0].league]} · ${best[0].year} · ${best[0].date} – ${best.at(-1).date}`, sourceUrl: best[0].sourceUrl, season: best[0].year, leagueCode: best[0].league, games: best.map(m=>({source:m.source,ref:m.sourceRef,date:m.date,result:`${m.gf}:${m.ga}`,opponent:m.home===m.team?m.away:m.home})) });
  }
}
const seriesLabels = { wins:'Zwycięstwa z rzędu w jednym sezonie', draws:'Remisy z rzędu w jednym sezonie', losses:'Porażki z rzędu w jednym sezonie', winless:'Mecze bez zwycięstwa w jednym sezonie', unbeaten:'Mecze bez porażki w jednym sezonie' };
for(const [kind, rows] of Object.entries(series)) {
  const ranking=topWithTies(rows); const first=ranking[0];
  records.push({ id:`archive-streak-${kind}`, group:'streaks', label:seriesLabels[kind], value:first.value, unit:'meczów', holder:first.holder, detail:first.detail, season:first.season, leagueCode:first.leagueCode, scope:'Datowane protokoły · 2003–2026', status:'partial', sourceLabel:`${first.games[0].source} · kolejne datowane wyniki`, sourceUrl:first.sourceUrl, sourceNote:`Porównanie wszystkich dostępnych sezonów, ale każda seria mieści się w jednym sezonie. Liczymy kolejne rozstrzygnięte wyniki według daty, z walkowerami. Pominięto ${excluded.length} zestawień drużyna–sezon z brakującymi datami, wynikami lub niejednoznaczną kolejnością; dlatego nie jest to bezwarunkowy rekord całej historii. Serie przechodzące pomiędzy sezonami wymagają osobnego audytu ciągłości drużyn.`, ranking:ranking.map(({games,...r})=>r), evidence:ranking.map(r=>({holder:r.holder,year:r.season,games:r.games})) });
}
for (const record of records.filter(record => record.group === 'streaks')) {
  const leaders = record.ranking.filter(row => row.value === record.value);
  if (leaders.length > 1) {
    record.holder = `Ex aequo: ${leaders.length}`;
    record.detail = leaders.map(row => `${row.holder} (${row.season})`).join(' · ');
    record.season = null;
    record.leagueCode = null;
  }
}
const output = { asOf:'2026-11-21', coverage:{ originalMatches:original.length, scoredMatches:original.filter(m=>m.hg!=null&&m.ag!=null&&!['not_played','cancelled'].includes(m.status)).length, knownPlayed:completed.length, excludedSeries:excluded, wpExcluded, files:41, years:24 }, records };
fs.writeFileSync(path.join(__dirname,'../src/data/mlpnBookAllTimeMatches.json'),JSON.stringify(output,null,2)+'\n');
fs.writeFileSync(path.join(inputDir,'book-original-matches.json'),JSON.stringify(original)+'\n');
console.log(JSON.stringify(records.map(r=>({id:r.id,value:r.value,holder:r.holder,detail:r.detail})),null,2));
