const scoreIsValid = value => typeof value === "number" && Number.isInteger(value) && value >= 0 && value <= 999;
const scored = match => scoreIsValid(match.homeScore) && scoreIsValid(match.awayScore);
const counts = match => ["finished", "live"].includes(match.status) && scored(match);
const teamName = (tournament, id) => tournament.teams?.find(team => team.id === id)?.name || id || "";

function addResult(row, own, other, rules) {
  row.played += 1;
  row.goalsFor += own;
  row.goalsAgainst += other;
  row.goalDifference = row.goalsFor - row.goalsAgainst;
  if (own > other) { row.won += 1; row.points += rules.pointsWin ?? 3; }
  else if (own === other) { row.drawn += 1; row.points += rules.pointsDraw ?? 1; }
  else { row.lost += 1; row.points += rules.pointsLoss ?? 0; }
}

const emptyRow = teamId => ({ teamId, played: 0, won: 0, drawn: 0, lost: 0, goalsFor: 0, goalsAgainst: 0, goalDifference: 0, points: 0, live: false });

/** Available results, including LIVE, form the displayed table. Qualification is
 * resolved separately, only when every group pairing has a final result. */
export function getGroupStandings(tournament, groupId, { includeLive = true } = {}) {
  const group = tournament.groups?.find(item => item.id === groupId);
  if (!group) return [];
  const rules = tournament.rules || {};
  const rows = new Map(group.teamIds.map(id => [id, emptyRow(id)]));
  const matches = (tournament.matches || []).filter(match => match.stage === "group" && match.groupId === groupId &&
    counts(match) && (includeLive || match.status === "finished") && rows.has(match.homeTeamId) && rows.has(match.awayTeamId) && match.homeTeamId !== match.awayTeamId);
  matches.forEach(match => {
    addResult(rows.get(match.homeTeamId), match.homeScore, match.awayScore, rules);
    addResult(rows.get(match.awayTeamId), match.awayScore, match.homeScore, rules);
    if (match.status === "live") { rows.get(match.homeTeamId).live = true; rows.get(match.awayTeamId).live = true; }
  });
  const criteria = rules.tiebreakers?.length ? rules.tiebreakers : [
    { id: "points" }, { id: "headToHead", subCriteria: [{ id: "points" }, { id: "goalDifference" }, { id: "goalsScored" }] },
    { id: "goalDifference" }, { id: "goalsScored" },
  ];
  const value = (row, id) => id === "points" ? row.points : id === "goalDifference" ? row.goalDifference : id === "goalsScored" ? row.goalsFor : 0;
  function partition(entries, compare) {
    const ordered = [...entries].sort(compare);
    const sections = [];
    ordered.forEach(row => {
      if (!sections.length || compare(sections[sections.length - 1][0], row)) sections.push([]);
      sections[sections.length - 1].push(row);
    });
    return sections;
  }
  function rank(entries, index) {
    if (entries.length < 2 || index >= criteria.length) return [entries];
    const criterion = criteria[index];
    let sections;
    if (criterion.id === "headToHead") {
      const mini = new Map(entries.map(row => [row.teamId, emptyRow(row.teamId)]));
      matches.filter(match => mini.has(match.homeTeamId) && mini.has(match.awayTeamId)).forEach(match => {
        addResult(mini.get(match.homeTeamId), match.homeScore, match.awayScore, rules);
        addResult(mini.get(match.awayTeamId), match.awayScore, match.homeScore, rules);
      });
      const subCriteria = criterion.subCriteria || [{ id: "points" }, { id: "goalDifference" }, { id: "goalsScored" }];
      sections = partition(entries, (a, b) => {
        for (const sub of subCriteria) {
          const difference = value(mini.get(b.teamId), sub.id) - value(mini.get(a.teamId), sub.id);
          if (difference) return difference;
        }
        return 0;
      });
    } else sections = partition(entries, (a, b) => value(b, criterion.id) - value(a, criterion.id));
    return sections.flatMap(section => rank(section,
      criterion.id === "headToHead" && criterion.applyRecursively && sections.length > 1 ? index : index + 1));
  }
  let position = 0;
  return rank([...rows.values()], 0).flatMap(section => section.sort((a, b) =>
    teamName(tournament, a.teamId).localeCompare(teamName(tournament, b.teamId), "pl") || a.teamId.localeCompare(b.teamId))
    .map(row => ({ ...row, position: ++position, tied: section.length > 1 })));
}

function groupIsComplete(tournament, groupId) {
  const group = tournament.groups?.find(item => item.id === groupId);
  if (!group || group.teamIds.length < 2) return false;
  const matches = (tournament.matches || []).filter(match => match.stage === "group" && match.groupId === groupId);
  if (!matches.length || matches.some(match => match.status !== "finished" || !scored(match))) return false;
  const pairs = new Map();
  matches.filter(match => group.teamIds.includes(match.homeTeamId) && group.teamIds.includes(match.awayTeamId) && match.homeTeamId !== match.awayTeamId)
    .forEach(match => { const pair = [match.homeTeamId, match.awayTeamId].sort().join("|"); pairs.set(pair, (pairs.get(pair) || 0) + 1); });
  const encounters = Number(group.numEncounters) || 1;
  return pairs.size === group.teamIds.length * (group.teamIds.length - 1) / 2 && [...pairs.values()].every(count => count === encounters);
}

export function getMatchWinner(match) {
  if (!match || match.status !== "finished" || !scored(match) || !match.homeTeamId || !match.awayTeamId || match.homeTeamId === match.awayTeamId) return null;
  if (match.homeScore !== match.awayScore) return match.homeScore > match.awayScore ? match.homeTeamId : match.awayTeamId;
  if (match.stage === "group") return null;
  if (!scoreIsValid(match.homePenalties) || !scoreIsValid(match.awayPenalties) || match.homePenalties === match.awayPenalties) {
    return [match.homeTeamId, match.awayTeamId].includes(match.reportedWinnerId) ? match.reportedWinnerId : null;
  }
  return match.homePenalties > match.awayPenalties ? match.homeTeamId : match.awayTeamId;
}

/** Resolves references recursively rather than relying on stored array order. */
export function resolveTournamentMatches(tournament) {
  const input = new Map((tournament.matches || []).map(match => [match.id, match]));
  const output = new Map();
  const visiting = new Set();
  function sourceTeam(source, explicit) {
    if (!source) return explicit || null;
    if (source.type === "group") {
      if (!groupIsComplete(tournament, source.groupId)) return null;
      const row = getGroupStandings(tournament, source.groupId, { includeLive: false }).find(item => item.position === source.position);
      return row && !row.tied ? row.teamId : null;
    }
    if (!["winner", "loser"].includes(source.type)) return null;
    const match = resolve(source.matchId);
    const winner = getMatchWinner(match);
    if (!winner) return null;
    return source.type === "winner" ? winner : (winner === match.homeTeamId ? match.awayTeamId : match.homeTeamId);
  }
  function resolve(id) {
    if (output.has(id)) return output.get(id);
    const match = input.get(id);
    if (!match || visiting.has(id)) return null;
    visiting.add(id);
    const result = { ...match, homeTeamId: sourceTeam(match.homeSource, match.homeTeamId), awayTeamId: sourceTeam(match.awaySource, match.awayTeamId) };
    visiting.delete(id);
    output.set(id, result);
    return result;
  }
  return (tournament.matches || []).map(match => resolve(match.id));
}

function rankedPlayers(entries, field) {
  const sorted = entries.filter(row => row[field] > 0).sort((a, b) => b[field] - a[field] || a.name.localeCompare(b.name, "pl") || a.playerId.localeCompare(b.playerId));
  let rank = 0;
  return sorted.map((row, index) => {
    if (!index || row[field] !== sorted[index - 1][field]) rank = index + 1;
    return { ...row, rank };
  });
}

export function getTournamentStats(tournament) {
  const matches = resolveTournamentMatches(tournament).filter(match => counts(match) && match.homeTeamId && match.awayTeamId);
  const players = new Map();
  const teams = new Map((tournament.teams || []).map(team => [team.id, team]));
  let recordedGoals = 0;
  for (const match of matches) {
    for (const event of match.events || []) {
      if (![match.homeTeamId, match.awayTeamId].includes(event.teamId)) continue;
      const player = teams.get(event.teamId)?.players?.find(item => item.id === event.playerId);
      if (!player) continue;
      const key = `${event.teamId}|${player.id}`;
      if (!players.has(key)) players.set(key, { playerId: player.id, name: player.name, teamId: event.teamId, goals: 0, assists: 0, yellow: 0, red: 0, cards: 0 });
      const row = players.get(key);
      if (event.type === "goal") { row.goals += 1; recordedGoals += 1; }
      if (event.type === "assist") row.assists += 1;
      if (event.type === "yellow") { row.yellow += 1; row.cards += 1; }
      if (event.type === "red") { row.red += 1; row.cards += 1; }
    }
  }
  const goals = matches.reduce((sum, match) => sum + match.homeScore + match.awayScore, 0);
  const rows = [...players.values()];
  return { played: matches.filter(match => match.status === "finished").length, live: matches.filter(match => match.status === "live").length,
    goals, averageGoals: matches.length ? Number((goals / matches.length).toFixed(2)) : 0,
    recordedGoals, unassignedGoals: Math.max(0, goals - recordedGoals), scorers: rankedPlayers(rows, "goals"), assists: rankedPlayers(rows, "assists"), cards: rankedPlayers(rows, "cards") };
}

function normalizeScore(value) {
  if (value == null || (typeof value === "string" && value.trim() === "")) return null;
  if (!["number", "string"].includes(typeof value) || !scoreIsValid(Number(value))) throw new Error("Wynik musi być nieujemną liczbą całkowitą.");
  return Number(value);
}

function validateMatch(tournament, match) {
  if (!["scheduled", "live", "finished"].includes(match.status)) throw new Error("Nieprawidłowy status meczu.");
  if (match.status === "scheduled") return;
  if (!match.homeTeamId || !match.awayTeamId || match.homeTeamId === match.awayTeamId) throw new Error("Najpierw muszą zostać wyłonieni obaj uczestnicy meczu.");
  if (!scored(match)) throw new Error("Podaj wynik obu drużyn.");
  const hasPenalties = match.homePenalties != null || match.awayPenalties != null;
  if (hasPenalties && (match.stage === "group" || match.homeScore !== match.awayScore || match.status !== "finished")) throw new Error("Karne można zapisać tylko przy remisie w zakończonym meczu pucharowym.");
  if (match.stage !== "group" && match.status === "finished" && match.homeScore === match.awayScore &&
      (!scoreIsValid(match.homePenalties) || !scoreIsValid(match.awayPenalties) || match.homePenalties === match.awayPenalties) &&
      ![match.homeTeamId, match.awayTeamId].includes(match.reportedWinnerId)) throw new Error("Remis w fazie pucharowej wymaga rozstrzygnięcia w rzutach karnych.");
  const eventIds = new Set();
  const goalCounts = new Map([[match.homeTeamId, 0], [match.awayTeamId, 0]]);
  const assists = new Map([[match.homeTeamId, 0], [match.awayTeamId, 0]]);
  for (const event of match.events || []) {
    if (!event.id || eventIds.has(event.id)) throw new Error("Każde zdarzenie musi mieć odrębny identyfikator.");
    eventIds.add(event.id);
    if (!["goal", "assist", "yellow", "red"].includes(event.type)) throw new Error("Nieprawidłowy typ zdarzenia.");
    if (!goalCounts.has(event.teamId)) throw new Error("Zdarzenie dotyczy drużyny, która nie gra w tym meczu.");
    if (!tournament.teams?.find(team => team.id === event.teamId)?.players?.some(player => player.id === event.playerId)) throw new Error("Wybierz zawodnika ze składu właściwej drużyny.");
    if (event.minute != null && (!Number.isInteger(event.minute) || event.minute < 0)) throw new Error("Minuta zdarzenia musi być nieujemną liczbą całkowitą.");
    if (event.type === "goal") goalCounts.set(event.teamId, goalCounts.get(event.teamId) + 1);
    if (event.type === "assist") assists.set(event.teamId, assists.get(event.teamId) + 1);
  }
  for (const [id, total] of [[match.homeTeamId, match.homeScore], [match.awayTeamId, match.awayScore]]) {
    if (goalCounts.get(id) > total) throw new Error("Zapisanych strzelców jest więcej niż bramek. Skoryguj zdarzenia razem z wynikiem.");
    if (assists.get(id) > total) throw new Error("Liczba asyst nie może przekraczać liczby bramek drużyny.");
  }
}

const PATCH_FIELDS = new Set(["status", "homeScore", "awayScore", "homePenalties", "awayPenalties", "events", "kickoff", "court"]);

/** Immutable local scoring operation. A changed qualifier invalidates dependent
 * results and events, preventing an old score from being assigned to a new team. */
export function updateTournamentMatch(tournament, matchId, patch) {
  if (!patch || typeof patch !== "object" || Object.keys(patch).some(key => !PATCH_FIELDS.has(key))) throw new Error("Nieprawidłowe pola edycji meczu.");
  const matches = resolveTournamentMatches(tournament).map(match => ({ ...match, events: (match.events || []).map(event => ({ ...event })) }));
  const index = matches.findIndex(match => match.id === matchId);
  if (index < 0) throw new Error("Nie znaleziono meczu.");
  const updated = { ...matches[index], ...patch };
  // An archive may identify a shootout winner without its penalty score. It is
  // historical evidence only; changing the result cannot carry that decision on.
  if (["homeScore", "awayScore", "homePenalties", "awayPenalties", "status"].some(key =>
    Object.prototype.hasOwnProperty.call(patch, key) && String(patch[key]) !== String(matches[index][key]))) {
    updated.reportedWinnerId = null;
    updated.outcomeNote = null;
  }
  if (!Array.isArray(updated.events)) throw new Error("Zdarzenia meczu muszą być listą.");
  updated.events = updated.events.map(event => ({ ...event }));
  for (const key of ["homeScore", "awayScore", "homePenalties", "awayPenalties"]) updated[key] = normalizeScore(updated[key]);
  if (updated.status === "scheduled") Object.assign(updated, { homeScore: null, awayScore: null, homePenalties: null, awayPenalties: null, events: [] });
  if (updated.kickoff && Number.isNaN(Date.parse(updated.kickoff))) throw new Error("Podaj prawidłową datę i godzinę meczu.");
  validateMatch(tournament, updated);
  matches[index] = updated;
  const next = { ...tournament, matches };
  for (let pass = 0; pass < matches.length; pass += 1) {
    const resolved = resolveTournamentMatches(next);
    let changed = false;
    resolved.forEach((match, position) => {
      const previous = next.matches[position];
      if (match.homeTeamId !== previous.homeTeamId || match.awayTeamId !== previous.awayTeamId) {
        next.matches[position] = { ...match, status: "scheduled", homeScore: null, awayScore: null, homePenalties: null, awayPenalties: null,
          reportedWinnerId: null, outcomeNote: null, events: [] };
        changed = true;
      }
    });
    if (!changed) break;
  }
  next.status = next.matches.length && next.matches.every(match => match.status === "finished") ? "completed"
    : next.matches.some(match => ["live", "finished"].includes(match.status)) ? "live" : "upcoming";
  return next;
}
