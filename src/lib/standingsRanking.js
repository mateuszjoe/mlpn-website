const DEFAULT_SCORING = {
  pointsWin: 3,
  pointsDraw: 1,
  pointsLoss: 0,
  walkoverGoalsWinner: 3,
  walkoverGoalsLoser: 0,
};

const number = (value) => Number.isFinite(Number(value)) ? Number(value) : 0;
const teamName = (row) => String(row.team || "");
const goalDifference = (row) => number(row.gf) - number(row.ga);
const compareNames = (a, b) => teamName(a).localeCompare(teamName(b), "pl");
const compareWithdrawn = (a, b) => Number(!!a.withdrawn) - Number(!!b.withdrawn);

function scoringOptions(options) {
  return Object.fromEntries(Object.entries(DEFAULT_SCORING).map(([key, fallback]) => [
    key,
    options[key] == null || !Number.isFinite(Number(options[key])) ? fallback : Number(options[key]),
  ]));
}

function validScore(value) {
  return value !== null && value !== undefined && String(value).trim() !== "" &&
    Number.isInteger(Number(value)) && Number(value) >= 0;
}

function matchScore(match, includeLive, scoring) {
  if (match.status === "walkover_home") {
    return [scoring.walkoverGoalsWinner, scoring.walkoverGoalsLoser];
  }
  if (match.status === "walkover_away") {
    return [scoring.walkoverGoalsLoser, scoring.walkoverGoalsWinner];
  }
  if (match.status !== "completed" && !(includeLive && match.status === "live")) return null;
  if (!validScore(match.homeGoals) || !validScore(match.awayGoals)) return null;
  return [Number(match.homeGoals), Number(match.awayGoals)];
}

function addMiniResult(entry, goalsFor, goalsAgainst, scoring) {
  entry.gf += goalsFor;
  entry.ga += goalsAgainst;
  entry.pts += goalsFor > goalsAgainst ? scoring.pointsWin
    : goalsFor === goalsAgainst ? scoring.pointsDraw : scoring.pointsLoss;
}

/** Rank one league using a mini-table of every club tied on league points.
 * All available direct games count; the mini-table is not recalculated for subgroups.
 * Totals come from the supplied rows and are never recomputed or mutated here.
 */
export function rankStandings(rows = [], matches = [], options = {}) {
  const { leagueId = "", includeLive = false } = options;
  const scoring = scoringOptions(options);
  const entries = (rows || []).map((row) => ({ row, pts: 0, gf: 0, ga: 0 }));
  const groups = new Map();

  for (const entry of entries) {
    const { row } = entry;
    const league = leagueId || row.league || "";
    const key = JSON.stringify([league, !!row.withdrawn, number(row.pts)]);
    if (!groups.has(key)) groups.set(key, { league, entries: [] });
    groups.get(key).entries.push(entry);
  }

  for (const group of groups.values()) {
    if (group.entries.length < 2) continue;
    const byTeam = new Map(group.entries.map((entry) => [teamName(entry.row), entry]));
    for (const match of matches || []) {
      if (group.league && match.league !== group.league) continue;
      const home = byTeam.get(match.home);
      const away = byTeam.get(match.away);
      if (!home || !away || home === away) continue;
      const score = matchScore(match, includeLive, scoring);
      if (!score) continue;
      addMiniResult(home, score[0], score[1], scoring);
      addMiniResult(away, score[1], score[0], scoring);
    }
  }

  entries.sort((a, b) =>
    compareWithdrawn(a.row, b.row) ||
    number(b.row.pts) - number(a.row.pts) ||
    b.pts - a.pts ||
    (b.gf - b.ga) - (a.gf - a.ga) ||
    b.gf - a.gf ||
    goalDifference(b.row) - goalDifference(a.row) ||
    number(b.row.gf) - number(a.row.gf) ||
    compareNames(a.row, b.row) ||
    String(a.row.teamId || a.row.team_id || "").localeCompare(String(b.row.teamId || b.row.team_id || ""))
  );
  return entries.map(({ row }, index) => ({ ...row, pos: index + 1 }));
}

const officialPosition = (row) => number(row.pos) > 0 ? number(row.pos) : Number.MAX_SAFE_INTEGER;

/** Column sorting must retain official head-to-head positions inside point ties. */
export function sortStandingsForDisplay(rows = [], sortBy = "pts", sortOrder = "desc") {
  const direction = sortOrder === "asc" ? 1 : -1;
  return [...(rows || [])].sort((a, b) => {
    const byWithdrawal = compareWithdrawn(a, b);
    if (byWithdrawal) return byWithdrawal;
    const byColumn = sortBy === "team" ? compareNames(a, b) : number(a[sortBy]) - number(b[sortBy]);
    return direction * byColumn || officialPosition(a) - officialPosition(b) || compareNames(a, b);
  });
}

function liveGoalValue(value) {
  return Math.max(0, Math.trunc(number(value)));
}

function applyLiveResultToRow(row, goalsFor, goalsAgainst, opponent, scoring) {
  row.played = number(row.played) + 1;
  row.gf = number(row.gf) + goalsFor;
  row.ga = number(row.ga) + goalsAgainst;
  if (goalsFor > goalsAgainst) {
    row.win = number(row.win) + 1;
    row.pts = number(row.pts) + scoring.pointsWin;
    row.liveResult = "W";
  } else if (goalsFor === goalsAgainst) {
    row.draw = number(row.draw) + 1;
    row.pts = number(row.pts) + scoring.pointsDraw;
    row.liveResult = "R";
  } else {
    row.loss = number(row.loss) + 1;
    row.pts = number(row.pts) + scoring.pointsLoss;
    row.liveResult = "P";
  }
  row.isLivePlaying = true;
  row.liveOpponent = opponent;
  row.liveScore = `${goalsFor} - ${goalsAgainst}`;
}

export function applyLiveFixturesToTable(rows = [], fixtures = [], leagueId = "", matches = [], options = {}) {
  const liveFixtures = (fixtures || []).filter((fixture) =>
    fixture.status === "live" && (!leagueId || fixture.league === leagueId)
  ).map((fixture) => ({
    ...fixture,
    homeGoals: liveGoalValue(fixture.homeGoals),
    awayGoals: liveGoalValue(fixture.awayGoals),
  }));

  // Preserve imported historical tables and the database's official order.
  if (!liveFixtures.length) return rows;
  const scoring = scoringOptions(options);
  const byTeam = new Map((rows || []).map((row) => [row.team, { ...row }]));
  for (const fixture of liveFixtures) {
    const home = byTeam.get(fixture.home);
    const away = byTeam.get(fixture.away);
    if (!home || !away || home === away) continue;
    applyLiveResultToRow(home, fixture.homeGoals, fixture.awayGoals, fixture.away, scoring);
    applyLiveResultToRow(away, fixture.awayGoals, fixture.homeGoals, fixture.home, scoring);
  }

  // Completed scores live in matches, not fixtures. Only LIVE totals are added above.
  return rankStandings([...byTeam.values()], [...(matches || []), ...liveFixtures], {
    ...options,
    leagueId,
    includeLive: true,
  }).map((row) => ({ ...row, liveAdjusted: !!row.isLivePlaying }));
}
