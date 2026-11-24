const fs = require('node:fs');
const path = require('node:path');

const SLUGS = ['halinowcup2025', 'pucharsulejowka2025', 'pucharburmistrza2025', 'halinowcup2024', 'mlpntest'];
const repo = path.resolve(__dirname, '..');
const defaultSourceDir = path.resolve(repo, '..', '.local', 'tournify-source');
const clean = value => typeof value === 'string' ? value.trim() : '';
const score = value => value == null || value === '' ? null : (Number.isInteger(Number(value)) && Number(value) >= 0 ? Number(value) : null);
const list = value => Array.isArray(value) ? value : Object.values(value || {});
const normalize = value => clean(value).toLocaleLowerCase('pl-PL').normalize('NFKD').replace(/\p{M}/gu, '').replace(/ł/g, 'l').replace(/[^a-z0-9]/g, '');
const safeTie = criteria => list(criteria).filter(item => ['points', 'headToHead', 'goalDifference', 'goalsScored'].includes(item?.id))
  .map(item => ({ id: item.id, ...(item.id === 'headToHead' ? { applyRecursively: item.applyRecursively === true,
    subCriteria: safeTie(item.subCriteria) } : {}) }));

function civilDate(seconds, timeZone = 'Europe/Warsaw') {
  if (!Number.isFinite(Number(seconds))) return null;
  return new Intl.DateTimeFormat('sv-SE', { timeZone, year: 'numeric', month: '2-digit', day: '2-digit' }).format(new Date(Number(seconds) * 1000));
}

function localKickoff(date, time, timeZone) {
  if (!date || !/^\d{1,2}:\d{2}$/.test(String(time || ''))) return null;
  const [hour, minute] = time.split(':').map(Number);
  if (hour > 23 || minute > 59) return null;
  const nominal = Date.parse(`${date}T${String(hour).padStart(2, '0')}:${String(minute).padStart(2, '0')}:00Z`);
  // Resolve the IANA offset for the event day; summer tournaments are UTC+2,
  // winter tournaments UTC+1. Never use the execution host's local time zone.
  const parts = new Intl.DateTimeFormat('en-GB', { timeZone, timeZoneName: 'longOffset' }).formatToParts(new Date(nominal));
  const zone = parts.find(part => part.type === 'timeZoneName')?.value || 'GMT';
  const offset = zone === 'GMT' ? '+00:00' : zone.replace('GMT', '');
  return `${date}T${String(hour).padStart(2, '0')}:${String(minute).padStart(2, '0')}:00${offset}`;
}

function localLogos() {
  const result = new Map();
  for (const directory of ['', 'team-logos']) {
    const root = path.join(repo, 'public', directory);
    if (!fs.existsSync(root)) continue;
    for (const file of fs.readdirSync(root)) {
      if (!/\.(png|webp|jpe?g|svg)$/i.test(file)) continue;
      result.set(normalize(file.replace(/\.[^.]+$/, '')), `/${directory ? `${directory}/` : ''}${file}`);
    }
  }
  return result;
}

let enginePromise;
async function engine() {
  if (!enginePromise) {
    const source = fs.readFileSync(path.join(repo, 'src/lib/tournamentEngine.js'), 'utf8');
    enginePromise = import(`data:text/javascript;base64,${Buffer.from(source).toString('base64')}`);
  }
  return enginePromise;
}

function positionInPoule(team, pouleId) {
  for (const [key, value] of Object.entries(team)) {
    if (/^poule\d+(?:-\d+-.*)?$/.test(key) && value === pouleId) {
      const number = team[`numInPoule${key.slice(5)}`];
      if (number != null && Number.isInteger(Number(number))) return Number(number);
    }
  }
  return null;
}

function stageFor(poule) {
  if (!poule.bracket) return poule.singleMatch ? 'playoff' : 'group';
  if (Number(poule.bracketRound) === 8) return 'quarterfinal';
  if (Number(poule.bracketRound) === 4) return 'semifinal';
  if (Number(poule.bracketRound) === 2) return Number(poule.num) === 0 ? 'third' : 'final';
  return 'playoff';
}

/** Strict sport-only allowlist. Raw exports must never enter the shipped bundle. */
async function importTournament(raw, options = {}) {
  const { resolveTournamentMatches, getMatchWinner, getTournamentStats } = await engine();
  const source = raw.tournament || {};
  const collections = raw.collections || {};
  const slug = clean(raw.slug);
  if (!/^[a-z0-9-]+$/.test(slug)) throw new Error('Invalid public tournament slug');
  const rawTeams = list(collections.teams);
  const rawPlayers = list(collections.players);
  const poules = list(collections.poules);
  const rawMatches = list(collections.matches);
  const spots = list(collections.resultSpots);
  const divisions = list(collections.divisions);
  const timeZone = clean(source.timezone) || 'Europe/Warsaw';
  const date = civilDate(source.date, timeZone);
  const sourceUrl = `${options.sourceOrigin || 'https://tournifyapp.com'}/live/${slug}`;
  const logoMap = options.logoMap || localLogos();
  const notes = [];
  const warnings = [];
  const phaseName = poule => {
    const division = divisions.find(item => String(item.id) === String(poule.division));
    return clean(division?.fases?.[Number(poule.fase)]?.name) || `Faza ${Number(poule.fase || 0) + 1}`;
  };
  const teams = rawTeams.map(item => ({ id: String(item.id), name: clean(item.name), shortName: clean(item.name), logo: logoMap.get(normalize(item.name)) || '',
    players: rawPlayers.filter(player => String(player.team) === String(item.id)).map(player => ({ id: String(player.id), name: clean(player.name),
      ...(player.number != null && score(player.number) != null ? { number: score(player.number) } : {}) })) }));
  const teamIds = new Set(teams.map(team => team.id));
  const unassignedPlayers = rawPlayers.filter(player => !teamIds.has(String(player.team)))
    .map(player => ({ id: String(player.id), name: clean(player.name), sourceTeamId: String(player.team) }));
  const pouleById = new Map(poules.map(poule => [poule.id, poule]));
  const groupPoules = poules.filter(poule => stageFor(poule) === 'group').sort((a, b) => Number(a.fase) - Number(b.fase) || Number(a.num) - Number(b.num));
  const groups = groupPoules.map(poule => {
    const destinations = spots.filter(spot => spot.fromPoule === poule.id).flatMap(spot => Object.entries(spot)
      .filter(([key, value]) => /^poule\d+$/.test(key) && value && pouleById.has(value))
      .map(([, value]) => ({ position: Number(spot.rank) + 1, playoff: stageFor(pouleById.get(value)) === 'playoff' })));
    const qualifiedPositions = [...new Set(destinations.filter(destination => !destination.playoff).map(destination => destination.position))].sort((a, b) => a - b);
    const playoffPositions = [...new Set(destinations.filter(destination => destination.playoff).map(destination => destination.position))].sort((a, b) => a - b);
    let advancing = 0;
    while (qualifiedPositions.includes(advancing + 1)) advancing += 1;
    return { id: poule.id, name: clean(poule.name), phase: Number(poule.fase || 0), phaseName: phaseName(poule),
      teamIds: rawTeams.filter(team => positionInPoule(team, poule.id) != null).sort((a, b) => positionInPoule(a, poule.id) - positionInPoule(b, poule.id)).map(team => String(team.id)),
      advancing, qualifiedPositions, playoffPositions, numEncounters: Number(poule.numEncounters) || 1 };
  });
  const dayMap = new Map(list(collections.days).map(day => [day.id, civilDate(day.date, timeZone)]));
  const playersById = new Map(rawPlayers.map(player => [player.id, player]));
  const matches = rawMatches.map(item => {
    const poule = pouleById.get(item.poule);
    if (!poule) throw new Error(`${slug}: match ${item.id} has no public group definition`);
    const participant = index => {
      const found = rawTeams.filter(team => positionInPoule(team, poule.id) === Number(index));
      if (found.length !== 1) { warnings.push({ matchId: item.id, reason: 'Nieustalony lub niejednoznaczny uczestnik', slot: index }); return null; }
      return String(found[0].id);
    };
    const homeTeamId = participant(item.team1);
    const awayTeamId = participant(item.team2);
    const homeScore = score(item.score1), awayScore = score(item.score2);
    const homePenalties = score(item.penalties1), awayPenalties = score(item.penalties2);
    const stage = stageFor(poule);
    const status = homeScore == null || awayScore == null ? 'scheduled' : 'finished';
    const reportedWinnerId = stage !== 'group' && status === 'finished' && homeScore === awayScore &&
      (item.winner === 0 || item.winner === 1) ? (item.winner === 0 ? homeTeamId : awayTeamId) : null;
    const events = [];
    const goalCounts = new Map([[homeTeamId, 0], [awayTeamId, 0]]);
    let eventProblem = false;
    list(item.goals).forEach((playerId, index) => {
      const player = playersById.get(playerId);
      if (!player || !teamIds.has(String(player.team)) || ![homeTeamId, awayTeamId].includes(String(player.team))) { eventProblem = true; return; }
      goalCounts.set(String(player.team), goalCounts.get(String(player.team)) + 1);
      events.push({ id: `${item.id}-goal-${index + 1}`, type: 'goal', teamId: String(player.team), playerId: String(player.id), minute: null });
    });
    if (goalCounts.get(homeTeamId) > homeScore || goalCounts.get(awayTeamId) > awayScore) eventProblem = true;
    if (eventProblem) warnings.push({ matchId: item.id, reason: 'Wpisy strzelców nie pasują do uczestników lub wyniku; nie włączono ich do rankingu' });
    const matchDate = dayMap.get(item.day) || date;
    return { id: String(item.id), stage, stageLabel: clean(poule.name), sourceGroupName: clean(poule.name), groupId: stage === 'group' ? poule.id : null,
      sourcePouleId: poule.id, phase: Number(poule.fase || 0), phaseName: phaseName(poule),
      homeTeamId, awayTeamId, homeScore, awayScore, homePenalties, awayPenalties, reportedWinnerId,
      ...(reportedWinnerId && (homePenalties == null || awayPenalties == null) ? { outcomeNote: 'Zwycięzca wskazany w archiwum; wynik karnych niepodany.' } : {}),
      status, ...(status === 'scheduled' ? { sourceScoreMissing: true } : {}),
      kickoff: localKickoff(matchDate, item.st, timeZone), court: clean(source.fields?.[String(item.field)]?.name) || clean(source.fields?.[String(item.field)]?.label) || 'Niepodane boisko',
      events: eventProblem ? [] : events, ...(eventProblem ? { sourceEventsUnverified: true } : {}), sourceOrder: Number(item.numInField) || 0 };
  }).sort((a, b) => String(a.kickoff || '').localeCompare(String(b.kickoff || '')) || a.sourceOrder - b.sourceOrder || a.id.localeCompare(b.id));
  const missingScores = matches.filter(match => match.sourceScoreMissing).length;
  const imported = { id: `tournify-${slug}`, slug, name: clean(source.name), date, location: clean(source.place),
    status: missingScores ? 'archived' : 'completed', isImported: true, isLocalCopy: false, isDemo: false, isTest: slug === 'mlpntest',
    description: slug === 'mlpntest' ? 'Archiwum udostępnione przez organizatora jako test. Oryginalne drużyny, wyniki i zachowane wpisy zawodników z Tournify.' : 'Oryginalne drużyny, terminarz i zachowane wyniki z archiwum Tournify.',
    sourceUrl, sourceLabel: 'Tournify', snapshotDate: options.snapshotDate || '2026-11-24', timezone: timeZone,
    formatLabel: `${teams.length} drużyn · ${new Set(groups.map(group => group.phase)).size} fazy grupowe · faza pucharowa`,
    matchMinutes: score(source.matchDuration), rules: { pointsWin: 3, pointsDraw: 1, pointsLoss: 0, tiebreakers: safeTie(source.tiebreakers), scoringSource: 'Domyślny system piłkarski Tournify: 3–1–0' },
    rulesConfirmed: true, teams, unassignedPlayers, groups, matches, sourceIncomplete: missingScores > 0, sourceNotes: notes };
  const rawMatchById = new Map(rawMatches.map(match => [match.id, match]));
  const matchesByPoule = new Map(poules.map(poule => [poule.id, matches.filter(match => match.sourcePouleId === poule.id)]));
  let resolvedDependencies = 0;
  let preservedAssignments = 0;
  for (const match of matches) {
    // Group-to-group progressions remain source assignments in this preview.
    // We retain their qualifying positions above rather than guess a mutable
    // second-stage roster without its own approved competition rules.
    if (match.stage === 'group') continue;
    const rawMatch = rawMatchById.get(match.id);
    for (const [side, index] of [['home', rawMatch.team1], ['away', rawMatch.team2]]) {
      const targetPoule = pouleById.get(match.sourcePouleId);
      const incoming = spots.filter(spot => spot[`poule${targetPoule.fase}`] === targetPoule.id && Number(spot[`numInPoule${targetPoule.fase}`]) === Number(index));
      if (incoming.length !== 1) { preservedAssignments += 1; continue; }
      const spot = incoming[0];
      const previousPoule = pouleById.get(spot.fromPoule);
      let reference;
      if (previousPoule && stageFor(previousPoule) === 'group') reference = { type: 'group', groupId: spot.fromPoule, position: Number(spot.rank) + 1 };
      else {
        const upstream = matchesByPoule.get(spot.fromPoule) || [];
        if (upstream.length === 1 && [0, 1].includes(Number(spot.rank))) reference = { type: Number(spot.rank) === 0 ? 'winner' : 'loser', matchId: upstream[0].id };
      }
      if (!reference) { preservedAssignments += 1; continue; }
      match[`${side}Source`] = reference;
      const actual = resolveTournamentMatches(imported).find(item => item.id === match.id)?.[`${side}TeamId`];
      if (actual !== match[`${side}TeamId`]) {
        delete match[`${side}Source`];
        preservedAssignments += 1;
        warnings.push({ matchId: match.id, side, reason: 'Zachowano uczestnika wskazanego w archiwum: źródłowe wyniki nie rozstrzygają obsady jednoznacznie' });
      } else resolvedDependencies += 1;
    }
  }
  const final = matches.find(match => match.stage === 'final');
  imported.championTeamId = final ? getMatchWinner(final) : null;
  const stats = getTournamentStats(imported);
  const matchDates = [...new Set(matches.map(match => match.kickoff?.slice(0, 10)).filter(Boolean))];
  imported.matchDates = matchDates;
  if (matchDates.some(day => day !== date)) notes.push(`Data nagłówka źródła: ${date}; dni w terminarzu: ${matchDates.join(', ')}. Zachowano daty z terminarza przy każdym meczu.`);
  if (missingScores) notes.push(`W źródle nie podano wyników ${missingScores} meczów. Nie zamieniono ich na 0:0.`);
  if (!rawPlayers.length) notes.push('Źródło nie zawiera list zawodników ani strzelców; dostępne są statystyki meczów i drużyn.');
  else if (stats.unassignedGoals) notes.push(`Strzelcy są zapisani tylko przy ${stats.recordedGoals} z ${stats.goals} bramek. Ranking zawodników jest niepełny.`);
  if (unassignedPlayers.length) notes.push(`Zachowano ${unassignedPlayers.length} zawodników przypisanych w źródle do drużyn, których nie ma w archiwum. Nie dopisano im fikcyjnych klubów.`);
  if (groups.some(group => group.phase > Math.min(...groups.map(item => item.phase)))) notes.push('Przejścia pomiędzy kolejnymi fazami grupowymi zachowują oryginalną obsadę z archiwum. Automatyczna korekta tych awansów nie jest jeszcze włączona w kopii testowej.');
  imported.individualStatsComplete = rawPlayers.length > 0 && stats.unassignedGoals === 0;
  imported.importSummary = { matches: matches.length, teams: teams.length, groups: groups.length, players: rawPlayers.length,
    assignedPlayers: teams.reduce((sum, team) => sum + team.players.length, 0), unassignedPlayers: unassignedPlayers.length,
    missingScores, recordedGoals: stats.recordedGoals, totalGoals: stats.goals, resolvedDependencies, preservedAssignments, warnings };
  return imported;
}

async function importAll(sourceDir = defaultSourceDir) {
  const tournaments = [];
  for (const slug of SLUGS) tournaments.push(await importTournament(JSON.parse(fs.readFileSync(path.join(sourceDir, slug, 'public-export.json'), 'utf8'))));
  return tournaments;
}

if (require.main === module) importAll(process.argv[2] || defaultSourceDir).then(tournaments => {
  fs.writeFileSync(path.join(repo, 'src/data/tournamentArchives.json'), JSON.stringify(tournaments, null, 2) + '\n');
  console.log(JSON.stringify(tournaments.map(tournament => ({ slug: tournament.slug, ...tournament.importSummary })), null, 2));
}).catch(error => { console.error(error.message); process.exitCode = 1; });

module.exports = { SLUGS, importTournament, importAll, civilDate, localKickoff, positionInPoule, stageFor };
