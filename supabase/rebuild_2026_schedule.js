#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { createClient } = require("@supabase/supabase-js");

const CURRENT_SEASON_NAME = "Sezon 2026";
const TEMP_ROUND_START = 1000;
const LEAGUE_NAMES = {
  I: "I Liga",
  II: "II Liga",
  III: "III Liga",
};

const SLOT_PATTERNS = {
  [LEAGUE_NAMES.I]: [
    { dayOffset: 0, time: "19:20" },
    { dayOffset: 1, time: "17:10" },
    { dayOffset: 1, time: "18:20" },
    { dayOffset: 1, time: "19:30" },
    { dayOffset: 2, time: "21:00" },
  ],
  [LEAGUE_NAMES.II]: [
    { dayOffset: 0, time: "18:10" },
    { dayOffset: 1, time: "13:40" },
    { dayOffset: 1, time: "14:50" },
    { dayOffset: 1, time: "16:00" },
    { dayOffset: 2, time: "19:50" },
  ],
  [LEAGUE_NAMES.III]: [
    { dayOffset: 0, time: "15:50" },
    { dayOffset: 0, time: "17:00" },
    { dayOffset: 1, time: "09:00" },
    { dayOffset: 1, time: "10:10" },
    { dayOffset: 1, time: "11:20" },
    { dayOffset: 1, time: "12:30" },
  ],
};

const ROUND_TWO_FIXTURES = {
  [LEAGUE_NAMES.I]: [
    { home: "Starszaki", away: "Lider", match_date: "2026-04-11", match_time: "19:20" },
    { home: "Elo Melo", away: "Fanatycy", match_date: "2026-04-12", match_time: "18:20" },
    { home: "Al Mar Wołomin", away: "FC Zieloni", match_date: "2026-04-12", match_time: "19:30" },
    { home: "1 Warszawska Brygada Pancerna", away: "Rebelianci", match_date: "2026-04-12", match_time: "20:35" },
    { home: "Sportowe Zakapiory", away: "Oldrembham Forest", match_date: "2026-04-13", match_time: "20:30" },
  ],
  [LEAGUE_NAMES.II]: [
    { home: "Tidy Team", away: "Tiger Wołomin", match_date: "2026-04-11", match_time: "18:10" },
    { home: "RKS Pendrachy", away: "Gosuansa", match_date: "2026-04-12", match_time: "13:40" },
    { home: "PJM", away: "Joga Finito", match_date: "2026-04-12", match_time: "14:50" },
    { home: "Nankatsu", away: "STM FC", match_date: "2026-04-12", match_time: "16:00" },
    { home: "Detox", away: "Faludża", match_date: "2026-04-12", match_time: "17:10" },
  ],
  [LEAGUE_NAMES.III]: [
    { home: "FC Faworyt", away: "Huragan Poręby Nowe", match_date: "2026-04-11", match_time: "15:50" },
    { home: "Fc KSS", away: "FC Restart", match_date: "2026-04-11", match_time: "17:00" },
    { home: "Chaos Team", away: "RMB Bulls", match_date: "2026-04-12", match_time: "09:00" },
    { home: "Alchemia Futbolu", away: "Sami Swoi FC", match_date: "2026-04-12", match_time: "10:10" },
    { home: "AL-Komat", away: "TPS Azbest Wołomin", match_date: "2026-04-12", match_time: "11:20" },
    { home: "ES Chobot Meat", away: "RKS Pendrachy II", match_date: "2026-04-12", match_time: "12:30" },
  ],
};

const I_LIGA_EXTRA_CONSTRAINTS = [
  {
    round: 3,
    label: "Rebelianci vs Lider lub Al Mar",
    options: [
      ["Rebelianci", "Lider"],
      ["Lider", "Rebelianci"],
      ["Rebelianci", "Al Mar Wołomin"],
      ["Al Mar Wołomin", "Rebelianci"],
    ],
  },
  {
    round: 4,
    label: "Rebelianci vs Oldrembham",
    options: [
      ["Rebelianci", "Oldrembham Forest"],
      ["Oldrembham Forest", "Rebelianci"],
    ],
  },
];

function loadEnvFile(filePath) {
  if (!fs.existsSync(filePath)) return;

  const content = fs.readFileSync(filePath, "utf8");
  for (const rawLine of content.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) continue;

    const eqIndex = line.indexOf("=");
    if (eqIndex === -1) continue;

    const key = line.slice(0, eqIndex).trim();
    let value = line.slice(eqIndex + 1).trim();
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }

    if (!(key in process.env)) {
      process.env[key] = value;
    }
  }
}

function parseArgs(argv) {
  const seedArg = argv.find((arg) => arg.startsWith("--seed="));
  const parsedSeed = seedArg ? Number(seedArg.split("=", 2)[1]) : 20260402;

  return {
    apply: argv.includes("--apply"),
    seed: Number.isFinite(parsedSeed) ? parsedSeed : 20260402,
  };
}

function createKey(parts) {
  return parts.join("::");
}

function pairKey(teamA, teamB) {
  return [teamA, teamB].sort().join("::");
}

function parseDateSafe(dateStr) {
  const date = new Date(`${dateStr}T12:00:00`);
  return Number.isNaN(date.getTime()) ? null : date;
}

function formatDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function addDays(dateStr, days) {
  const parsed = parseDateSafe(dateStr);
  if (!parsed) {
    throw new Error(`Invalid date: ${dateStr}`);
  }
  parsed.setDate(parsed.getDate() + days);
  return formatDate(parsed);
}

function compareStrings(left, right) {
  return String(left || "").localeCompare(String(right || ""), "pl", { sensitivity: "base" });
}

function sortMatchesBySlot(matches) {
  return [...(matches || [])].sort((left, right) => {
    if (left.round !== right.round) return Number(left.round) - Number(right.round);

    const leftDate = String(left.match_date || "9999-12-31");
    const rightDate = String(right.match_date || "9999-12-31");
    if (leftDate !== rightDate) return leftDate.localeCompare(rightDate);

    const leftTime = String(left.match_time || "99:99");
    const rightTime = String(right.match_time || "99:99");
    if (leftTime !== rightTime) return leftTime.localeCompare(rightTime);

    const leftHome = String(left.home_team_name || left.home_team_id || "");
    const rightHome = String(right.home_team_name || right.home_team_id || "");
    if (leftHome !== rightHome) return compareStrings(leftHome, rightHome);

    return String(left.id || "").localeCompare(String(right.id || ""), undefined, { numeric: true });
  });
}

function buildRemainingFixtures(activeTeamIds, lockedMatches) {
  const directedMatches = new Map();

  for (const match of lockedMatches || []) {
    const homeTeamId = match?.home_team_id;
    const awayTeamId = match?.away_team_id;

    if (!activeTeamIds.includes(homeTeamId) || !activeTeamIds.includes(awayTeamId)) {
      continue;
    }

    const directionKey = createKey([homeTeamId, awayTeamId]);
    directedMatches.set(directionKey, (directedMatches.get(directionKey) || 0) + 1);
  }

  const fixtures = [];
  for (let indexA = 0; indexA < activeTeamIds.length; indexA += 1) {
    for (let indexB = indexA + 1; indexB < activeTeamIds.length; indexB += 1) {
      const homeA = activeTeamIds[indexA];
      const homeB = activeTeamIds[indexB];

      const countAB = directedMatches.get(createKey([homeA, homeB])) || 0;
      const countBA = directedMatches.get(createKey([homeB, homeA])) || 0;
      const totalPlayed = countAB + countBA;

      if (totalPlayed >= 2) {
        continue;
      }

      if (totalPlayed === 1) {
        fixtures.push(
          countAB === 1
            ? { id: createKey([homeB, homeA, "return"]), home_team_id: homeB, away_team_id: homeA }
            : { id: createKey([homeA, homeB, "return"]), home_team_id: homeA, away_team_id: homeB }
        );
        continue;
      }

      fixtures.push(
        { id: createKey([homeA, homeB, "first"]), home_team_id: homeA, away_team_id: homeB },
        { id: createKey([homeB, homeA, "second"]), home_team_id: homeB, away_team_id: homeA }
      );
    }
  }

  return fixtures;
}

function shuffleArray(items, rng = Math.random) {
  const copy = [...items];
  for (let index = copy.length - 1; index > 0; index -= 1) {
    const swapIndex = Math.floor(rng() * (index + 1));
    [copy[index], copy[swapIndex]] = [copy[swapIndex], copy[index]];
  }
  return copy;
}

function createSeededRng(seed) {
  let state = (Number(seed) || 1) >>> 0;
  return function next() {
    state = (state + 0x6d2b79f5) >>> 0;
    let value = Math.imul(state ^ (state >>> 15), 1 | state);
    value ^= value + Math.imul(value ^ (value >>> 7), 61 | value);
    return ((value ^ (value >>> 14)) >>> 0) / 4294967296;
  };
}

function countFixturesPerTeam(fixtures) {
  const counts = new Map();

  for (const fixture of fixtures || []) {
    counts.set(fixture.home_team_id, (counts.get(fixture.home_team_id) || 0) + 1);
    counts.set(fixture.away_team_id, (counts.get(fixture.away_team_id) || 0) + 1);
  }

  return counts;
}

function countFixturesPerPair(fixtures) {
  const counts = new Map();

  for (const fixture of fixtures || []) {
    const key = pairKey(fixture.home_team_id, fixture.away_team_id);
    counts.set(key, (counts.get(key) || 0) + 1);
  }

  return counts;
}

function fixtureScore(fixture, fixtureCountsByTeam, fixtureCountsByPair, roundsLeft, rng = Math.random) {
  const key = pairKey(fixture.home_team_id, fixture.away_team_id);
  const homeCount = fixtureCountsByTeam.get(fixture.home_team_id) || 0;
  const awayCount = fixtureCountsByTeam.get(fixture.away_team_id) || 0;
  const pairCount = fixtureCountsByPair.get(key) || 0;

  let score = pairCount * 10 + homeCount + awayCount;
  if (homeCount >= roundsLeft) score += 5;
  if (awayCount >= roundsLeft) score += 5;
  score += rng();
  return score;
}

function removeFixturesById(fixtures, fixtureIds) {
  const fixtureIdSet = new Set(fixtureIds);
  return fixtures.filter((fixture) => !fixtureIdSet.has(fixture.id));
}

function futureCapacityLooksValid(remainingFixtures, activeTeamIds, futureRounds, futureConstraintsByRound, fixtureById) {
  const expectedSlots = futureRounds.reduce((sum, roundEntry) => sum + roundEntry.count, 0);
  if (remainingFixtures.length !== expectedSlots) {
    return false;
  }

  const remainingCounts = countFixturesPerTeam(remainingFixtures);
  for (const teamId of activeTeamIds) {
    if ((remainingCounts.get(teamId) || 0) > futureRounds.length) {
      return false;
    }
  }

  const remainingIds = new Set(remainingFixtures.map((fixture) => fixture.id));
  for (const roundEntry of futureRounds) {
    const requiredOptions = futureConstraintsByRound.get(roundEntry.round) || [];
    if (!requiredOptions.length) continue;

    const hasAnyOption = requiredOptions.some((fixtureId) => remainingIds.has(fixtureId));
    if (!hasAnyOption) {
      return false;
    }
  }

  return true;
}

function chooseRoundCombinations({
  remainingFixtures,
  availableTeamIds,
  roundCount,
  roundsLeftIncludingCurrent,
  disallowedPairKeys,
  lockedFixtureIds,
  combinationLimit = 6,
  rng = Math.random,
}) {
  const requiredFixtures = remainingFixtures.filter((fixture) => lockedFixtureIds.has(fixture.id));
  const requiredTeamIds = new Set();

  for (const fixture of requiredFixtures) {
    if (disallowedPairKeys.has(pairKey(fixture.home_team_id, fixture.away_team_id))) {
      return [];
    }
    if (requiredTeamIds.has(fixture.home_team_id) || requiredTeamIds.has(fixture.away_team_id)) {
      return [];
    }
    requiredTeamIds.add(fixture.home_team_id);
    requiredTeamIds.add(fixture.away_team_id);
  }

  if (requiredFixtures.length > roundCount) {
    return [];
  }

  const missingCount = roundCount - requiredFixtures.length;
  if (missingCount === 0) {
    return [requiredFixtures];
  }

  const fixtureCountsByTeam = countFixturesPerTeam(remainingFixtures);
  const fixtureCountsByPair = countFixturesPerPair(remainingFixtures);

  const candidateFixtures = shuffleArray(
    remainingFixtures.filter((fixture) => !lockedFixtureIds.has(fixture.id)),
    rng
  )
    .filter((fixture) => !disallowedPairKeys.has(pairKey(fixture.home_team_id, fixture.away_team_id)))
    .filter((fixture) => availableTeamIds.has(fixture.home_team_id) && availableTeamIds.has(fixture.away_team_id))
    .filter((fixture) => !requiredTeamIds.has(fixture.home_team_id) && !requiredTeamIds.has(fixture.away_team_id))
    .sort(
      (left, right) =>
        fixtureScore(right, fixtureCountsByTeam, fixtureCountsByPair, roundsLeftIncludingCurrent, rng) -
        fixtureScore(left, fixtureCountsByTeam, fixtureCountsByPair, roundsLeftIncludingCurrent, rng)
    )
    .slice(0, Math.max(24, roundCount * 12));

  const combinations = [];

  function dfs(startIndex, availableTeams, chosen) {
    if (combinations.length >= combinationLimit) {
      return;
    }

    if (chosen.length === missingCount) {
      combinations.push([...requiredFixtures, ...chosen]);
      return;
    }

    const slotsLeft = missingCount - chosen.length;
    if (Math.floor(availableTeams.size / 2) < slotsLeft) {
      return;
    }

    for (let index = startIndex; index < candidateFixtures.length; index += 1) {
      const fixture = candidateFixtures[index];
      if (!availableTeams.has(fixture.home_team_id) || !availableTeams.has(fixture.away_team_id)) {
        continue;
      }

      const nextTeams = new Set(availableTeams);
      nextTeams.delete(fixture.home_team_id);
      nextTeams.delete(fixture.away_team_id);

      chosen.push(fixture);
      dfs(index + 1, nextTeams, chosen);
      chosen.pop();

      if (combinations.length >= combinationLimit) {
        return;
      }
    }
  }

  dfs(0, new Set(availableTeamIds), []);
  return combinations;
}

function buildConstraintFixtureMap(extraRoundConstraints, fixtures) {
  const byDirection = new Map(
    fixtures.map((fixture) => [createKey([fixture.home_team_id, fixture.away_team_id]), fixture.id])
  );
  const byRound = new Map();

  for (const constraint of extraRoundConstraints || []) {
    const optionFixtureIds = constraint.options
      .map(([homeTeamId, awayTeamId]) => byDirection.get(createKey([homeTeamId, awayTeamId])))
      .filter(Boolean);

    if (!optionFixtureIds.length) {
      throw new Error(`Constraint "${constraint.label}" has no available fixtures.`);
    }

    byRound.set(Number(constraint.round), optionFixtureIds);
  }

  return byRound;
}

function attemptSchedule(spec, rng = Math.random) {
  const rounds = Object.keys(spec.roundCounts)
    .map(Number)
    .sort((a, b) => a - b)
    .map((round) => ({ round, count: spec.roundCounts[round] }));
  const futureConstraintsByRound = buildConstraintFixtureMap(spec.extraRoundConstraints, spec.fixtures);
  const fixtureById = new Map(spec.fixtures.map((fixture) => [fixture.id, fixture]));
  const lockedPreviousPairs = new Set(
    (spec.lockedRoundPairs || []).map((entry) => pairKey(entry.home_team_id, entry.away_team_id))
  );

  function scheduleRound(index, remainingFixtures, previousRoundPairKeys, planned) {
    if (index >= rounds.length) {
      return remainingFixtures.length === 0 ? planned : null;
    }

    const roundEntry = rounds[index];
    const futureRounds = rounds.slice(index + 1);
    const roundsLeftIncludingCurrent = rounds.length - index;
    const requiredOptions = futureConstraintsByRound.get(roundEntry.round) || [];
    const requiredChoices = requiredOptions.length
      ? shuffleArray(requiredOptions, rng).map((fixtureId) => new Set([fixtureId]))
      : [new Set()];

    for (const lockedFixtureIds of requiredChoices) {
      const roundCombinations = chooseRoundCombinations({
        remainingFixtures,
        availableTeamIds: new Set(spec.activeTeamIds),
        roundCount: roundEntry.count,
        roundsLeftIncludingCurrent,
        disallowedPairKeys: previousRoundPairKeys,
        lockedFixtureIds,
        rng,
      });

      for (const roundFixtures of roundCombinations) {
        const roundFixtureIds = roundFixtures.map((fixture) => fixture.id);
        const nextRemainingFixtures = removeFixturesById(remainingFixtures, roundFixtureIds);
        const nextRoundPairKeys = new Set(
          roundFixtures.map((fixture) => pairKey(fixture.home_team_id, fixture.away_team_id))
        );

        if (
          !futureCapacityLooksValid(
            nextRemainingFixtures,
            spec.activeTeamIds,
            futureRounds,
            futureConstraintsByRound,
            fixtureById
          )
        ) {
          continue;
        }

        const result = scheduleRound(
          index + 1,
          nextRemainingFixtures,
          nextRoundPairKeys,
          planned.concat(
            roundFixtures.map((fixture) => ({
              fixture_id: fixture.id,
              home_team_id: fixture.home_team_id,
              away_team_id: fixture.away_team_id,
              round: roundEntry.round,
            }))
          )
        );

        if (result) {
          return result;
        }
      }
    }

    return null;
  }

  return scheduleRound(0, [...spec.fixtures], lockedPreviousPairs, []);
}

function solveSchedule(spec) {
  const maxAttempts = 1200;

  for (let attempt = 1; attempt <= maxAttempts; attempt += 1) {
    const rng = createSeededRng((spec.seed || 1) + attempt * 9973);
    const schedule = attemptSchedule(spec, rng);
    if (schedule) {
      return {
        schedule,
        mode: `heuristic(seed=${spec.seed || 1},attempt=${attempt})`,
      };
    }
  }

  throw new Error(`No feasible schedule found for ${spec.leagueName}.`);
}

function buildRoundBaseDates(existingMatchesByLeague, leagueIdsByName) {
  const roundBaseDates = new Map();

  function firstRoundDate(leagueName, round) {
    const matches = (existingMatchesByLeague.get(leagueIdsByName.get(leagueName)) || [])
      .filter((match) => Number(match.round) === Number(round))
      .sort((left, right) => String(left.match_date).localeCompare(String(right.match_date)));

    return matches[0]?.match_date || null;
  }

  for (let round = 3; round <= 19; round += 1) {
    roundBaseDates.set(round, firstRoundDate(LEAGUE_NAMES.II, round));
  }

  for (let round = 20; round <= 22; round += 1) {
    roundBaseDates.set(round, firstRoundDate(LEAGUE_NAMES.I, round));
  }

  for (let round = 23; round <= 26; round += 1) {
    roundBaseDates.set(round, firstRoundDate(LEAGUE_NAMES.III, round));
  }

  return roundBaseDates;
}

function slotsForRound(leagueName, round, count, roundBaseDates) {
  const pattern = SLOT_PATTERNS[leagueName];
  if (!pattern) {
    throw new Error(`Missing slot pattern for ${leagueName}.`);
  }

  if (round === 2) {
    const fixedRound = ROUND_TWO_FIXTURES[leagueName];
    if (!fixedRound || fixedRound.length !== count) {
      throw new Error(`Round 2 definition for ${leagueName} does not match ${count} matches.`);
    }

    return fixedRound.map((fixture) => ({
      match_date: fixture.match_date,
      match_time: fixture.match_time,
    }));
  }

  const baseDate = roundBaseDates.get(round);
  if (!baseDate) {
    throw new Error(`Missing base date for round ${round} in ${leagueName}.`);
  }

  return pattern.slice(0, count).map((entry) => ({
    match_date: addDays(baseDate, entry.dayOffset),
    match_time: entry.time,
  }));
}

function prettyMatch(match, teamNameById) {
  const home = teamNameById.get(match.home_team_id) || match.home_team_id;
  const away = teamNameById.get(match.away_team_id) || match.away_team_id;
  return `${home} - ${away}`;
}

function buildRoundTwoLockedMatches(leagueName, teamIdByName) {
  return (ROUND_TWO_FIXTURES[leagueName] || []).map((fixture) => {
    const homeTeamId = teamIdByName.get(fixture.home);
    const awayTeamId = teamIdByName.get(fixture.away);

    if (!homeTeamId || !awayTeamId) {
      throw new Error(`Unknown team in round 2 config for ${leagueName}: ${fixture.home} / ${fixture.away}`);
    }

    return {
      round: 2,
      home_team_id: homeTeamId,
      away_team_id: awayTeamId,
      match_date: fixture.match_date,
      match_time: fixture.match_time,
      status: "scheduled",
    };
  });
}

function assignRoundSlots(leagueName, roundMatches, teamNameById, roundBaseDates) {
  const round = Number(roundMatches[0]?.round);
  const slots = slotsForRound(leagueName, round, roundMatches.length, roundBaseDates);
  let orderedMatches = [...roundMatches];

  if (leagueName === LEAGUE_NAMES.I && round === 3) {
    const specialIndex = orderedMatches.findIndex(
      (match) =>
        teamNameById.get(match.home_team_id) === "Rebelianci" ||
        teamNameById.get(match.away_team_id) === "Rebelianci"
    );

    if (specialIndex >= 0) {
      const [specialMatch] = orderedMatches.splice(specialIndex, 1);
      const remaining = orderedMatches.sort((left, right) => {
        const leftKey = `${teamNameById.get(left.home_team_id)}|${teamNameById.get(left.away_team_id)}`;
        const rightKey = `${teamNameById.get(right.home_team_id)}|${teamNameById.get(right.away_team_id)}`;
        return compareStrings(leftKey, rightKey);
      });

      orderedMatches = [
        remaining[0],
        remaining[1],
        remaining[2],
        specialMatch,
        remaining[3],
      ].filter(Boolean);
    }
  } else {
    orderedMatches = orderedMatches.sort((left, right) => {
      const leftKey = `${teamNameById.get(left.home_team_id)}|${teamNameById.get(left.away_team_id)}`;
      const rightKey = `${teamNameById.get(right.home_team_id)}|${teamNameById.get(right.away_team_id)}`;
      return compareStrings(leftKey, rightKey);
    });
  }

  return orderedMatches.map((match, index) => ({
    ...match,
    match_date: slots[index].match_date,
    match_time: slots[index].match_time,
    status: "scheduled",
  }));
}

async function updateMatchesInTwoStages(supabase, updates) {
  const stageOne = [...updates].map((update, index) => ({
    matchId: update.matchId,
    payload: {
      round: TEMP_ROUND_START + index,
    },
  }));

  for (const update of stageOne) {
    const { error } = await supabase
      .from("matches")
      .update(update.payload)
      .eq("id", update.matchId);

    if (error) {
      throw error;
    }
  }

  for (const update of updates) {
    const { error } = await supabase
      .from("matches")
      .update(update.payload)
      .eq("id", update.matchId);

    if (error) {
      throw error;
    }
  }
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  loadEnvFile(path.resolve(process.cwd(), ".env.local"));

  const supabaseUrl = process.env.REACT_APP_SUPABASE_URL;
  const supabaseKey = process.env.SUPABASE_SERVICE_KEY || process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!supabaseUrl || !supabaseKey) {
    throw new Error("Missing REACT_APP_SUPABASE_URL or SUPABASE_SERVICE_KEY in .env.local");
  }

  const supabase = createClient(supabaseUrl, supabaseKey, {
    auth: { persistSession: false },
  });

  const { data: seasons, error: seasonsError } = await supabase
    .from("seasons")
    .select("id, name, year, is_current")
    .order("year", { ascending: false });
  if (seasonsError) throw seasonsError;

  const season = seasons.find((entry) => entry.name === CURRENT_SEASON_NAME) || seasons.find((entry) => entry.is_current);
  if (!season) {
    throw new Error(`Season ${CURRENT_SEASON_NAME} not found.`);
  }

  const [{ data: leagues, error: leaguesError }, { data: teams, error: teamsError }, { data: seasonTeams, error: seasonTeamsError }, { data: matches, error: matchesError }] = await Promise.all([
    supabase.from("leagues").select("id, name, code, display_order").order("display_order"),
    supabase.from("teams").select("id, name, home_venue"),
    supabase
      .from("season_teams")
      .select("id, season_id, league_id, team_id, joined_round, left_round")
      .eq("season_id", season.id),
    supabase
      .from("matches")
      .select("id, season_id, league_id, round, match_date, match_time, status, home_team_id, away_team_id, venue")
      .eq("season_id", season.id)
      .order("league_id")
      .order("round")
      .order("match_date")
      .order("match_time"),
  ]);

  if (leaguesError) throw leaguesError;
  if (teamsError) throw teamsError;
  if (seasonTeamsError) throw seasonTeamsError;
  if (matchesError) throw matchesError;

  const teamNameById = new Map(teams.map((team) => [team.id, team.name]));
  const teamIdByName = new Map(teams.map((team) => [team.name, team.id]));
  const leagueIdByName = new Map(leagues.map((league) => [league.name, league.id]));
  const leagueMatches = new Map(leagues.map((league) => [league.id, matches.filter((match) => match.league_id === league.id)]));
  const roundBaseDates = buildRoundBaseDates(leagueMatches, leagueIdByName);

  const futureMatches = matches.filter((match) => Number(match.round) >= 2);
  const futureMatchIds = futureMatches.map((match) => match.id);
  if (futureMatchIds.length > 0) {
    const [{ count: lineupCount, error: lineupError }, { count: eventCount, error: eventError }, { count: typerCount, error: typerError }, { count: galleryCount, error: galleryError }] = await Promise.all([
      supabase.from("match_lineups").select("match_id", { count: "exact", head: true }).in("match_id", futureMatchIds),
      supabase.from("match_events").select("match_id", { count: "exact", head: true }).in("match_id", futureMatchIds),
      supabase.from("typer_round_config_matches").select("match_id", { count: "exact", head: true }).in("match_id", futureMatchIds),
      supabase.from("gallery_albums").select("match_id", { count: "exact", head: true }).in("match_id", futureMatchIds),
    ]);

    if (lineupError) throw lineupError;
    if (eventError) throw eventError;
    if (typerError) throw typerError;
    if (galleryError) throw galleryError;

    if ((lineupCount || 0) + (eventCount || 0) + (typerCount || 0) + (galleryCount || 0) > 0) {
      throw new Error("Future matches already have related data (lineups/events/typer/gallery). Aborting.");
    }
  }

  const schedulePlan = [];

  for (const leagueName of [LEAGUE_NAMES.I, LEAGUE_NAMES.II, LEAGUE_NAMES.III]) {
    const leagueId = leagueIdByName.get(leagueName);
    if (!leagueId) {
      throw new Error(`League ${leagueName} not found.`);
    }

    const currentLeagueMatches = leagueMatches.get(leagueId) || [];
    const lockedRoundOneMatches = currentLeagueMatches.filter((match) => Number(match.round) === 1);
    const lockedRoundTwoMatches = buildRoundTwoLockedMatches(leagueName, teamIdByName);

    const activeTeamIds = seasonTeams
      .filter((seasonTeam) => seasonTeam.league_id === leagueId)
      .filter((seasonTeam) => Number(seasonTeam.joined_round || 1) <= 2)
      .filter((seasonTeam) => seasonTeam.left_round == null || Number(seasonTeam.left_round) > 2)
      .map((seasonTeam) => seasonTeam.team_id)
      .sort((left, right) => compareStrings(teamNameById.get(left), teamNameById.get(right)));

    const lockedMatches = [...lockedRoundOneMatches, ...lockedRoundTwoMatches];
    const roundCounts = Object.fromEntries(
      Object.entries(
        currentLeagueMatches
          .filter((match) => Number(match.round) >= 3)
          .reduce((acc, match) => {
            const round = Number(match.round);
            acc[round] = (acc[round] || 0) + 1;
            return acc;
          }, {})
      ).map(([round, count]) => [Number(round), count])
    );

    const remainingFixtures = buildRemainingFixtures(activeTeamIds, lockedMatches);
    const totalRoundCapacity = Object.values(roundCounts).reduce((sum, count) => sum + count, 0);
    if (remainingFixtures.length !== totalRoundCapacity) {
      throw new Error(
        `${leagueName} has ${remainingFixtures.length} remaining fixtures but ${totalRoundCapacity} free slots in rounds 3+.`
      );
    }

    const lockedRoundPairs = lockedRoundTwoMatches.map((match) => ({
      round: 2,
      home_team_id: match.home_team_id,
      away_team_id: match.away_team_id,
    }));

    const extraRoundConstraints =
      leagueName === LEAGUE_NAMES.I
        ? I_LIGA_EXTRA_CONSTRAINTS.map((constraint) => ({
            round: constraint.round,
            label: constraint.label,
            options: constraint.options
              .map(([homeName, awayName]) => [teamIdByName.get(homeName), teamIdByName.get(awayName)])
              .filter(([homeId, awayId]) => homeId && awayId),
          }))
        : [];

    const { schedule: scheduledMatches, mode } = solveSchedule({
      leagueName,
      fixtures: remainingFixtures,
      activeTeamIds,
      roundCounts,
      extraRoundConstraints,
      lockedRoundPairs,
      seed: args.seed + schedulePlan.length * 100000,
    });

    const matchesByRound = new Map();
    for (const match of scheduledMatches) {
      if (!matchesByRound.has(match.round)) {
        matchesByRound.set(match.round, []);
      }
      matchesByRound.get(match.round).push(match);
    }

    const futureSchedule = [];
    futureSchedule.push(
      ...lockedRoundTwoMatches.map((match) => ({
        ...match,
        round: 2,
      }))
    );

    for (const round of Object.keys(roundCounts).map(Number).sort((a, b) => a - b)) {
      const roundMatches = matchesByRound.get(round) || [];
      futureSchedule.push(...assignRoundSlots(leagueName, roundMatches, teamNameById, roundBaseDates));
    }

    const targetRows = sortMatchesBySlot(currentLeagueMatches.filter((match) => Number(match.round) >= 2));
    const plannedRows = sortMatchesBySlot(futureSchedule);
    if (targetRows.length !== plannedRows.length) {
      throw new Error(`${leagueName} update count mismatch: ${targetRows.length} rows vs ${plannedRows.length} planned.`);
    }

    const venueFallback = teams.find((team) => team.home_venue)?.home_venue || "Narutowicza 10, 05-071 Sulejówek";
    const updates = plannedRows.map((plannedRow, index) => ({
      matchId: targetRows[index].id,
      payload: {
        round: plannedRow.round,
        home_team_id: plannedRow.home_team_id,
        away_team_id: plannedRow.away_team_id,
        match_date: plannedRow.match_date,
        match_time: plannedRow.match_time,
        venue: targetRows[index].venue || venueFallback,
        status: "scheduled",
        home_goals: null,
        away_goals: null,
        referee: null,
        referee_id: null,
        mvp_player_id: null,
        video_url: null,
        gallery_url: null,
        notes: null,
      },
    }));

    schedulePlan.push({
      leagueName,
      mode,
      activeTeamIds,
      updates,
      preview: plannedRows
        .filter((match) => [2, 3, 4].includes(Number(match.round)))
        .map((match) => ({
          round: match.round,
          match_date: match.match_date,
          match_time: match.match_time,
          label: prettyMatch(match, teamNameById),
        })),
    });
  }

  const roundPreview = schedulePlan.flatMap((entry) =>
    entry.preview.map((previewMatch) => ({
      league: entry.leagueName,
      ...previewMatch,
    }))
  );

  console.log(`Plan for ${season.name}`);
  for (const entry of schedulePlan) {
    console.log(`\n=== ${entry.leagueName} (${entry.mode}) ===`);
    for (const previewMatch of entry.preview) {
      console.log(`R${previewMatch.round} ${previewMatch.match_date} ${previewMatch.match_time} | ${previewMatch.label}`);
    }
  }

  if (!args.apply) {
    console.log("\nDry run complete. Re-run with --apply to save the new schedule.");
    return;
  }

  for (const entry of schedulePlan) {
    console.log(`\nApplying ${entry.leagueName}...`);
    await updateMatchesInTwoStages(supabase, entry.updates);
  }

  console.log("\nSchedule updated successfully.");

  const { data: verificationMatches, error: verificationError } = await supabase
    .from("matches")
    .select("league_id, round, match_date, match_time, home_team_id, away_team_id")
    .eq("season_id", season.id)
    .in("round", [2, 3, 4])
    .order("league_id")
    .order("round")
    .order("match_date")
    .order("match_time");
  if (verificationError) throw verificationError;

  const leagueNameById = new Map(leagues.map((league) => [league.id, league.name]));
  console.log("\nVerification R2-R4:");
  for (const match of verificationMatches || []) {
    console.log(
      `${leagueNameById.get(match.league_id)} | R${match.round} ${match.match_date} ${String(match.match_time || "").slice(0, 5)} | ${prettyMatch(match, teamNameById)}`
    );
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
