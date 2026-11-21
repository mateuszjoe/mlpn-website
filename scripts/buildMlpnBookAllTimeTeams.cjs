/* Read-only archive reconciliation. Never connects to a database.
 * node scripts/buildMlpnBookAllTimeTeams.cjs <original-project-directory> <current-standings-json>
 */
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '../..');
const original = process.argv[2];
const currentFile = process.argv[3];
if (!original || !currentFile) throw new Error('Provide the original MLPN archive directory and a read-only 2026 standings export.');
const originalDir = path.resolve(original);
const csvFile = path.join(root, 'prezentacja-2026/materialy-robocze/wszech-czasow/kontrola-z-archiwum.csv');
const auditFile = path.join(root, 'prezentacja-2026/materialy-robocze/wszech-czasow/bilans-weryfikacja.json');
const csv = fs.readFileSync(csvFile, 'utf8').trim().split(/\r?\n/).slice(1).map(line => {
  const c = line.split(';');
  return { year: +c[0], league: c[1], sourceName: c[2], matchesConfirmed: +c[3], wonConfirmed: +c[4],
    drawnConfirmed: c[5] === '' ? null : +c[5], goalsFor: +c[6] + +c[8], goalsAgainst: +c[7],
    recoveredGoals: +c[8], recoveredPoints: +c[9], unresolvedFixtures: +c[10], note: c.slice(11).join(';') };
});
const differences = [];
const sourceFiles = [];
function ini(text) {
  const sections = {}; let current;
  for (const line of text.split(/\r?\n/)) {
    const m = line.trim().match(/^\[(.+)\]$/);
    if (m) { current = sections[m[1]] = {}; continue; }
    const eq = line.indexOf('=');
    if (current && eq > 0) current[line.slice(0, eq).trim()] = line.slice(eq + 1).trim();
  }
  return sections;
}
function num(value) { return Number.parseInt(value || '0', 10) || 0; }
const archiveRows = [];
for (const file of fs.readdirSync(path.join(originalDir, 'archiwum 2003-2017')).filter(file => /\.l98$/i.test(file))) {
  const data = ini(fs.readFileSync(path.join(originalDir, 'archiwum 2003-2017', file), 'utf8'));
  const year = +file.match(/\d{4}/)[0]; const league = file.match(/^(I+)/)[1];
  sourceFiles.push(file);
  const teams = new Map();
  for (let i = 1; i <= num(data.Options.Teams); i++) {
    const meta = data[`Team${i}`] || {};
    const sign = data.Options.MinusPoints === '1' ? -1 : 1;
    teams.set(i, { year, league, sourceName: data.Teams[i], matchesConfirmed: 0, wonConfirmed: 0, drawnConfirmed: 0,
      goalsFor: sign * num(meta.TOR1), goalsAgainst: sign * num(meta.TOR2), recoveredGoals: sign * num(meta.TOR1),
      recoveredGoalsAgainst: sign * num(meta.TOR2), recoveredPoints: sign * num(meta.SP), unresolvedFixtures: 0,
      note: meta.NOT || '', sourceLabel: file, points: sign * num(meta.SP) });
  }
  for (let round = 1; round <= num(data.Options.Rounds); round++) {
    const fixture = data[`Round${round}`] || {};
    for (let i = 1; i <= num(data.Options.Matches); i++) {
      const home = teams.get(num(fixture[`TA${i}`])); const away = teams.get(num(fixture[`TB${i}`]));
      if (!home || !away) continue;
      const gf = Number(fixture[`GA${i}`]); const ga = Number(fixture[`GB${i}`]);
      if (!Number.isFinite(gf) || !Number.isFinite(ga) || gf < 0 || ga < 0) {
        home.unresolvedFixtures++; away.unresolvedFixtures++; continue;
      }
      for (const [team, goalsFor, goalsAgainst] of [[home,gf,ga],[away,ga,gf]]) {
        team.matchesConfirmed++; team.goalsFor += goalsFor; team.goalsAgainst += goalsAgainst;
        team.wonConfirmed += Number(goalsFor > goalsAgainst); team.drawnConfirmed += Number(goalsFor === goalsAgainst);
        team.points += goalsFor > goalsAgainst ? num(data.Options.PointsForWin || '3') : goalsFor === goalsAgainst ? num(data.Options.PointsForDraw || '1') : 0;
      }
    }
  }
  for (const row of teams.values()) {
    const prior = csv.find(old => old.year === row.year && old.league === row.league && old.sourceName === row.sourceName);
    if (!prior) differences.push({ type: 'missing-csv-team', year, league, name: row.sourceName });
    else for (const key of ['matchesConfirmed','wonConfirmed','drawnConfirmed','goalsFor','goalsAgainst','unresolvedFixtures']) {
      if (row[key] !== prior[key]) differences.push({ type: 'l98-vs-csv', year, league, name: row.sourceName, field: key, original: row[key], csv: prior[key] });
    }
    archiveRows.push(row);
  }
}

// The dump stores one INSERT statement across many lines, with escaped SQL strings.
function sqlRows(sql, table) {
  const out = [];
  const rx = new RegExp('INSERT INTO `'+table+'`(?:[^;]*?)VALUES ([\\s\\S]*?);\\r?\\n', 'g');
  for (const statement of sql.matchAll(rx)) {
    let row, token = '', quoted = false, quote, escape = false, inRow = false;
    function push() { const v = token.trim(); row.push(!quoted && v === 'NULL' ? null : !quoted && /^-?\d+(\.\d+)?$/.test(v) ? Number(v) : token); token = ''; quoted = false; }
    for (const ch of statement[1]) {
      if (escape) { token += ch === 'n' ? '\n' : ch === 'r' ? '\r' : ch === 't' ? '\t' : ch === '0' ? '\0' : ch; escape = false; continue; }
      if (quote) { if (ch === '\\') escape = true; else if (ch === quote) quote = null; else token += ch; continue; }
      if (ch === '"' || ch === "'") { quote = ch; quoted = true; continue; }
      if (ch === '(') { row = []; inRow = true; continue; }
      if (ch === ')') { push(); out.push(row); inRow = false; continue; }
      if (ch === ',' && inRow) push(); else if (inRow) token += ch;
    }
  }
  return out;
}
const sql = fs.readFileSync(path.join(originalDir, 'baza 2018-2025/backup_2026_02_22_11_06_12-3dbedda7-db.sql'), 'utf8');
const posts = new Map(sqlRows(sql, 'wp_posts').filter(row => ['joomsport_season','joomsport_team','joomsport_match'].includes(row[20])).map(row => [row[0], { title: row[5], type: row[20] }]));
const historyNames = new Map();
for(const match of sqlRows(sql, 'wp_joomsport_matches')) {
  const title=posts.get(match[0])?.title || ''; const parts=title.split(/\s+vs\.?\s+/i);
  if(parts.length!==2) continue;
  for(const [id,name] of [[match[3],parts[0]],[match[4],parts[1]]]) {
    const key=match[2]+':'+id; if(!historyNames.has(key)) historyNames.set(key,new Map());
    const counts=historyNames.get(key); counts.set(name,(counts.get(name)||0)+1);
  }
}
const wpRows = sqlRows(sql, 'wp_joomsport_season_table').map(row => {
  const season = posts.get(row[1])?.title || '';
  const year = Number(season.match(/20\d{2}/)?.[0]); const league = season.match(/^(I{1,3})\s*liga/i)?.[1];
  if (year < 2018 || year > 2025 || !league) return null;
  const stats = JSON.parse(row[4]);
  return { year, league, seasonId:row[1], latestName: posts.get(row[3])?.title, sourceId: row[0], participantId: row[3], historicalNames: [...(historyNames.get(row[1]+':'+row[3]) || new Map())].sort((a,b)=>b[1]-a[1]), position: row[5],
    matchesConfirmed: num(stats.played_chk), wonConfirmed: num(stats.win_chk), drawnConfirmed: num(stats.draw_chk),
    goalsFor: num(stats.goalscore_chk), goalsAgainst: num(stats.goalconc_chk), points: num(stats.point_chk) };
}).filter(Boolean);
const used = new Set();
for (const row of csv.filter(row => row.year >= 2018 && row.year <= 2025)) {
  const candidates = wpRows.filter(wp => !used.has(wp.sourceId) && wp.year === row.year && wp.league === row.league
    && wp.goalsFor === row.goalsFor && wp.goalsAgainst === row.goalsAgainst && wp.wonConfirmed === row.wonConfirmed && wp.matchesConfirmed === row.matchesConfirmed);
  const sameName = candidates.find(wp => wp.latestName?.toLocaleLowerCase('pl') === row.sourceName.toLocaleLowerCase('pl'));
  const wp = sameName || (candidates.length === 1 ? candidates[0] : null);
  if (!wp) { differences.push({ type: 'wp-table-unmatched', ...row }); continue; }
  used.add(wp.sourceId);
  const decodeName = name => name.replace(/&#8211;/g,'–').replace(/&amp;/g,'&');
  const historical = wp.historicalNames.filter(([name])=>!/^(-?przerwa-?|pauza|xxx|wolne miejsce(?: [IVX]+)?)$/i.test(name)).map(([name])=>decodeName(name));
  const unique = [...new Set(historical)];
  const cosmetic = unique.every(name=>name.replace(/^I Warszawska/, '1 Warszawska').replace(/ Eszkere$/, '').toLocaleLowerCase('pl')===unique[0].replace(/^I Warszawska/, '1 Warszawska').replace(/ Eszkere$/, '').toLocaleLowerCase('pl'));
  const restoredName = unique.length===1 ? unique[0] : unique.length && cosmetic ? row.sourceName : unique.length>1 ? unique.join(' / ')+' ('+row.year+')' : row.sourceName;
  archiveRows.push({ ...row, sourceName: restoredName, previousImportedName: row.sourceName, historicalNameCandidates: wp.historicalNames,
    identityUncertain: unique.length>1 && !cosmetic, drawnConfirmed: wp.drawnConfirmed, points: wp.points, position: wp.position,
    sourceLabel: `WordPress · tabela ${row.league} ligi ${row.year} · wiersz ${wp.sourceId}`, wpSourceId: wp.sourceId });
}
for (const wp of wpRows.filter(row => !used.has(row.sourceId))) differences.push({ type: 'wp-original-unmatched', ...wp });
const unresolvedSources = differences.filter(row => /unmatched|missing-csv-team/.test(row.type));
if (unresolvedSources.length) throw new Error(`Archive reconciliation failed for ${unresolvedSources.length} rows; refusing to publish a partial dataset.`);
const old2026 = csv.filter(row => row.year === 2026);
const current = JSON.parse(fs.readFileSync(currentFile, 'utf8'));
for (const row of current) {
  if (row.team_name === 'SDK Warszawa' && row.played === 0) continue;
  const league = { '1st':'I','2nd':'II','3rd':'III' }[row.league_code];
  archiveRows.push({ year:2026, league, sourceName:row.team_name, matchesConfirmed:row.played, wonConfirmed:row.won,
    drawnConfirmed:row.drawn, goalsFor:row.goals_for, goalsAgainst:row.goals_against, points:row.points, position:row.position,
    recoveredGoals:0, recoveredGoalsAgainst:0, recoveredPoints:0, unresolvedFixtures:0, note:row.left_round ? 'Drużyna wycofana; zachowano bilans tabeli.' : '',
    sourceLabel:'MLPN · oficjalna tabela · odczyt 21.11.2026' });
}
fs.writeFileSync(path.join(root,'.local/book-historical-team-names.json'),JSON.stringify(wpRows.map(({year,league,seasonId,participantId,latestName,historicalNames})=>({year,league,seasonId,teamId:participantId,latestName,historicalNames})),null,2));
fs.writeFileSync(path.join(root,'.local/book-archive-reconciliation.json'),JSON.stringify({l98Files:sourceFiles.length,l98Rows:archiveRows.filter(row=>row.year<2018).length,wpOriginalRows:wpRows.length,wpHistoricalNames:wpRows.filter(row=>row.historicalNames.length && row.latestName!==row.historicalNames[0][0]).map(({year,league,latestName,historicalNames,sourceId})=>({year,league,latestName,historicalNames,sourceId})),wpMatched:used.size,currentRows:current.length,changes2026:current.map(row=>({name:row.team_name,now:row.goals_for,old:old2026.find(old=>old.sourceName===row.team_name)?.goalsFor})).filter(row=>row.now!==row.old),differences},null,2));
fs.writeFileSync(path.join(root,'.local/book-archive-season-rows.json'),JSON.stringify(archiveRows,null,2));
console.log(JSON.stringify({l98Files:sourceFiles.length,wpOriginalRows:wpRows.length,wpMatched:used.size,rows:archiveRows.length,differences:differences.length,examples:differences.slice(0,12)},null,2));

const knownContinuities = JSON.parse(fs.readFileSync(auditFile, 'utf8')).selected_clubs;
const aliases = new Map();
const simpleKey = name => name.trim().replace(/\s+/g,' ').toLocaleLowerCase('pl');
function group(canonical, names) { for (const name of [canonical, ...names]) aliases.set(simpleKey(name), canonical); }
for (const club of knownContinuities) group(club.team === 'Impet / Hard Impet Team' ? 'Impet / Hard Impet Team' : club.team, club.aliases);
group('Gold Dent', ['Gold Dent P.T.','Gold Dent PT','Gold-Dent PT','GOLD-DENT.P.T','GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA']);
group('FC Zieloni', ['Fc Zieloni','Fc Zieloni Superparkiet_pl']);
group('PKKL', ['PKKL Sulejówek']);
group('Colgate', ['Colgate Palmolive','Colgate-Palmolive Poland']);
group('Nankatsu', ['Posch Titanium']);
group('Tęcza Pustelnik', ['Pts Lzs Tęcza Pustelnik','PTS Tęcza Pustelnik']);
group('Pianka Kuflew', ['KOMINKI SIM – Pianka Kuflew','KOMINKI SIM - Pianka Kuflew','Kominki Sim Pianka Kuflew','Pianka Kuflew Kominkisim','Pianka Kuflew Kominkisim.pl']);
group('Pan Pierożek', ['Pan Pierożek_pl','Pan Pierożek.pl','Panpierożek.pl','PanPierożek.pl']);
group('DT Galacticos', ['D.T. Galacticos']);
group('ES Chobot Meat', ['Es Chobot Meat']);
group('Rebelianci', ['Rebelianci Eszkere']);
group('1 Warszawska Brygada Pancerna', ['I Warszawska Brygada Pancerna']);
function canonical(name) { return aliases.get(simpleKey(name)) || name.replace(/^Fc\b/, 'FC'); }
const excludedRows = archiveRows.filter(row => /^(-?przerwa-?|pauza|xxx|wolne miejsce(?: [IVX]+)?)$/i.test(row.sourceName));
const seasonRows = archiveRows.filter(row => !excludedRows.includes(row)).map(row => ({ ...row,
  team:canonical(row.sourceName), leagueCode: { I:'1st',II:'2nd',III:'3rd' }[row.league],
  goalsWithout2026Withdrawn: row.goalsFor - (row.year===2026 && row.league!=='III' && row.sourceName!=='Oldrembham Forest' && row.sourceName!=='Nankatsu' && row.sourceName!=='FC Ślimak Halinów' && row.sourceName!=='Rayo Vallerano' ? 3 : 0),
}));
// Historical identity changes within one year are kept as their own combined
// ledger entry, never assigned wholesale to the current team with the reused ID.
const clubMap = new Map();
for (const row of seasonRows) {
  if (!clubMap.has(row.team)) clubMap.set(row.team,{team:row.team,goalsFor:0,goalsAgainst:0,goalsWithout2026Withdrawn:0,matchesConfirmed:0,wonConfirmed:0,years:[],sourceNames:[],leagues:[],identityUncertain:false,recoveredGoals:0,recoveredGoalsAgainst:0,unresolvedFixtures:0});
  const club = clubMap.get(row.team);
  for (const key of ['goalsFor','goalsAgainst','goalsWithout2026Withdrawn','matchesConfirmed','wonConfirmed','recoveredGoals','recoveredGoalsAgainst','unresolvedFixtures']) club[key] += row[key] || 0;
  club.years.push(row.year); club.sourceNames.push(row.sourceName); club.leagues.push(row.league);
  club.identityUncertain ||= !!row.identityUncertain;
}
const clubs = [...clubMap.values()].map(club => ({...club,years:[...new Set(club.years)].sort((a,b)=>a-b),sourceNames:[...new Set(club.sourceNames)],leagues:[...new Set(club.leagues)].sort(),seasons:new Set(club.years).size})).sort((a,b)=>b.goalsFor-a.goalsFor || a.team.localeCompare(b.team,'pl'));
for (const club of clubs) {
  club.firstYear=club.years[0]; club.lastYear=club.years.at(-1);
  club.mixedIdentity=club.identityUncertain;
  club.incomplete=club.unresolvedFixtures>0;
  club.seasonRows=seasonRows.filter(row=>row.team===club.team).sort((a,b)=>b.year-a.year).map(row=>({year:row.year,league:row.league,goalsFor:row.goalsFor,goalsAgainst:row.goalsAgainst,matchesConfirmed:row.matchesConfirmed,sourceName:row.sourceName,sourceLabel:row.sourceLabel,unresolvedFixtures:row.unresolvedFixtures,note:row.note||'',position:row.position||null}));
}
function rank(rows, limit=10) {
  const sorted=[...rows].sort((a,b)=>b.value-a.value||a.holder.localeCompare(b.holder,'pl'));
  let last, position=0;
  return sorted.map((row,index)=>{ if(row.value!==last) position=index+1; last=row.value;return {...row,rank:position}; }).filter(row=>row.rank<=limit);
}
const sourceNote = 'Wszystkie 41 ligowych plików L98 z lat 2003–2017, 277 wierszy końcowych tabel WordPress z lat 2018–2025 oraz bieżące tabele 2026. Wliczamy rozstrzygnięcia administracyjne zapisane w tabelach. Korekty bramek z 2003 i 2007 roku odczytano z oryginałów. Nazwy drużyn odtworzono dla danego sezonu, bez przenoszenia historii po ponownym użyciu identyfikatora. Niejednoznaczne zmiany w środku sezonu pozostają osobnymi wpisami.';
const recordDefs = [
  { id:'all-time-club-goals',group:'teams',label:'Najwięcej goli drużyny w historii',unit:'goli',rows:clubs.filter(club=>!club.identityUncertain).map(club=>({holder:club.team,value:club.goalsFor,detail:`${club.years[0]}–${club.years.at(-1)} · ${club.seasons} sezonów w tabelach`})) },
  { id:'all-time-club-seasons',group:'teams',label:'Najwięcej sezonów drużyny',unit:'sezonów',rows:clubs.map(club=>({holder:club.team,value:club.seasons,detail:club.years.join(', ')})) },
  { id:'all-time-team-season-goals',group:'teams',label:'Najwięcej goli drużyny w jednym sezonie',unit:'goli',rows:seasonRows.filter(row=>row.matchesConfirmed>0 && !row.identityUncertain).map(row=>({holder:row.team,value:row.goalsFor,detail:`${row.league} liga ${row.year} · bilans ${row.goalsFor}:${row.goalsAgainst}`,sourceUrl:row.year===2026?`/${row.league.length}-liga/tabela?sezon=${row.year}`:undefined})) },
  { id:'all-time-team-season-balance',group:'teams',label:'Najwyższy bilans bramkowy sezonu',unit:'bilans bramek',rows:seasonRows.filter(row=>row.matchesConfirmed>0 && !row.identityUncertain).map(row=>({holder:row.team,value:row.goalsFor-row.goalsAgainst,detail:`${row.league} liga ${row.year} · ${row.goalsFor}:${row.goalsAgainst}`,sourceUrl:row.year===2026?`/${row.league.length}-liga/tabela?sezon=${row.year}`:undefined})) },
];
const records = recordDefs.map(({rows,...record})=>{
  const ranking=rank(rows); const leaders=ranking.filter(row=>row.rank===1);
  return {...record,value:ranking[0].value,holder:leaders.length===1?ranking[0].holder:`${leaders.length} współliderów`,detail:leaders.length===1?ranking[0].detail:leaders.map(row=>row.holder).join(' · '),scope:'Cała historia · 2003–2026',leagueCode:'all',status:'archive',sourceLabel:'Oryginalne archiwum MLPN · L98, WordPress i tabele 2026',sourceNote,ranking};
});
const output = {asOf:'2026-11-21',coverage:{firstYear:2003,lastYear:2026,leagueSeasons:68,l98Files:41,wpTableRows:277,seasonRows:seasonRows.length,clubEntries:clubs.length,excludedAdministrativeRows:excludedRows.map(row=>({year:row.year,league:row.league,name:row.sourceName}))},records,clubs,seasonRows,
  methodology:[sourceNote,'Mecze potwierdzone oznaczają rozstrzygnięcia z wynikiem w archiwum lub wierszu końcowej tabeli. Brakujących protokołów 2003 nie dodajemy do tej liczby; to niepełny bilans występów.','Liczba sezonów oznacza lata obecności w archiwalnych tabelach; wycofania z zachowanym bilansem też są uwzględniane. Nie jest to klasyfikacja zawodników.','Osobne pole goalsWithout2026Withdrawn zachowuje wariant prezentacji gali, bez 19 walkowerów z wycofanymi drużynami 2026. Ranking główny konsekwentnie pokazuje bilanse tabelowe.','Nierozstrzygnięte zmiany nazwy lub przejęcia miejsca nie są automatycznie łączone. Liczba wpisów archiwum nie jest pewną liczbą odrębnych klubów.']};
fs.writeFileSync(path.join(__dirname,'../src/data/mlpnBookAllTimeTeams.json'),JSON.stringify(output,null,2)+'\n');
console.log(JSON.stringify({clubEntries:clubs.length,top:clubs.slice(0,5).map(({team,goalsFor,goalsWithout2026Withdrawn,seasons})=>({team,goalsFor,goalsWithout2026Withdrawn,seasons})),records:records.map(({label,value,holder})=>({label,value,holder}))},null,2));
