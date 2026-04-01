#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { createClient } = require("@supabase/supabase-js");

const BYE_ID = "__BYE__";
const DEFAULT_PRESERVE_ROUNDS = 2;

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
  const options = {
    season: "current",
    preserveRounds: DEFAULT_PRESERVE_ROUNDS,
    apply: false,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const token = argv[index];

    if (token === "--apply") {
      options.apply = true;
      continue;
    }

    if (!token.startsWith("--")) continue;

    const [rawKey, rawInlineValue] = token.split("=", 2);
    const key = rawKey.replace(/^--/, "");
    const nextValue = rawInlineValue ?? argv[index + 1];

    if (rawInlineValue == null && nextValue && !nextValue.startsWith("--")) {
      index += 1;
    }

    const value = rawInlineValue ?? nextValue;
    if (value == null) {
      throw new Error(`Missing value for ${token}`);
    }

    if (key === "league" || key === "league-name") {
      options.leagueName = value;
      continue;
    }

    if (key === "league-id") {
      options.leagueId = value;
      continue;
    }

    if (key === "season" || key === "season-name") {
      options.season = value;
      continue;
    }

    if (key === "season-id") {
      options.seasonId = value;
      continue;
    }

    if (key === "preserve-rounds") {
      options.preserveRounds = Number(value);
      continue;
    }

    throw new Error(`Unknown option: ${token}`);
  }

  if (!options.leagueName && !options.leagueId) {
    throw new Error("Provide --league \"League Name\" or --league-id <uuid>.");
  }

  if (!Number.isInteger(options.preserveRounds) || options.preserveRounds < 2) {
    throw new Error("This repair script requires --preserve-rounds >= 2.");
  }

  return options;
}

function sortMatchesBySlot(matches) {
  return [...(matches || [])].sort((left, right) => {
    const leftDate = String(left.match_date || "9999-12-31");
    const rightDate = String(right.match_date || "9999-12-31");
    if (leftDate !== rightDate) return leftDate.localeCompare(rightDate);

    const leftTime = String(left.match_time || "99:99");
    const rightTime = String(right.match_time || "99:99");
    if (leftTime !== rightTime) return leftTime.localeCompare(rightTime);

    return String(left.id).localeCompare(String(right.id), undefined, { numeric: true });
  });
}

function rotateList(list) {
  const copy = [...list];
  const last = copy[copy.length - 1];
  for (let index = copy.length - 1; index >= 2; index -= 1) {
    copy[index] = copy[index - 1];
  }
  copy[1] = last;
  return copy;
}

function generateFirstHalfFromList(baseList) {
  let list = [...baseList];
  const rounds = [];
  const effectiveCount = list.length;
  const half = effectiveCount / 2;

  for (let round = 1; round <= effectiveCount - 1; round += 1) {
    const fixtures = [];

    for (let index = 0; index < half; index += 1) {
      let homeTeamId;
      let awayTeamId;

      if (round % 2 === 0) {
        homeTeamId = list[index];
        awayTeamId = list[effectiveCount - 1 - index];
      } else {
        homeTeamId = list[effectiveCount - 1 - index];
        awayTeamId = list[index];
      }

      fixtures.push({
        home_team_id: homeTeamId,
        away_team_id: awayTeamId,
        isBye: homeTeamId === BYE_ID || awayTeamId === BYE_ID,
      });
    }

    rounds.push({ round, fixtures });
    list = rotateList(list);
  }

  return rounds;
}

function buildPairKey(teamA, teamB) {
  return [teamA, teamB].sort().join("::");
}

function getRoundMatches(matches, roundNumber) {
  return sortMatchesBySlot((matches || []).filter((match) => Number(match.round) === Number(roundNumber)));
}

function ensureRoundCoverage(teamIds, roundMatches, roundNumber) {
  const usedTeamIds = new Set();

  for (const match of roundMatches) {
    if (usedTeamIds.has(match.home_team_id) || usedTeamIds.has(match.away_team_id)) {
      throw new Error(`Round ${roundNumber} is invalid: a team appears more than once.`);
    }
    usedTeamIds.add(match.home_team_id);
    usedTeamIds.add(match.away_team_id);
  }

  const byeTeamId = teamIds.find((teamId) => !usedTeamIds.has(teamId));
  if (!byeTeamId) {
    throw new Error(`Round ${roundNumber} has no bye team. This script only supports odd team counts.`);
  }

  return byeTeamId;
}

function buildCycleFromPreservedRounds(teamIds, matches, preserveRounds) {
  const adjacency = new Map();

  for (let round = 1; round <= preserveRounds; round += 1) {
    const roundMatches = getRoundMatches(matches, round);
    const byeTeamId = ensureRoundCoverage(teamIds, roundMatches, round);
    const edges = [
      ...roundMatches.map((match) => [match.home_team_id, match.away_team_id]),
      [byeTeamId, BYE_ID],
    ];

    for (const [left, right] of edges) {
      if (!adjacency.has(left)) adjacency.set(left, new Map());
      if (!adjacency.has(right)) adjacency.set(right, new Map());

      adjacency.get(left).set(round, right);
      adjacency.get(right).set(round, left);
    }
  }

  const startNode = getRoundMatches(matches, 1)[0]?.home_team_id;
  if (!startNode) {
    throw new Error("Round 1 has no matches.");
  }

  const cycle = [startNode];
  const seen = new Set([startNode]);
  let current = startNode;
  let nextRound = 1;

  while (true) {
    const nextNode = adjacency.get(current)?.get(nextRound);
    if (!nextNode) {
      throw new Error("Could not build the round-robin cycle from preserved rounds.");
    }
    if (nextNode === startNode) {
      break;
    }
    if (seen.has(nextNode)) {
      throw new Error("Preserved rounds do not form a single cycle, so the league cannot be rebuilt this way.");
    }

    cycle.push(nextNode);
    seen.add(nextNode);
    current = nextNode;
    nextRound = nextRound === 1 ? 2 : 1;
  }

  if (cycle.length !== teamIds.length + 1) {
    throw new Error("Preserved rounds do not cover all teams in one consistent cycle.");
  }

  return cycle;
}

function deriveBaseListFromCycle(cycle) {
  if (cycle.length !== 14) {
    throw new Error("This repair path currently expects 13 teams plus one BYE.");
  }

  return [
    cycle[0],
    cycle[12],
    cycle[3],
    cycle[10],
    cycle[5],
    cycle[8],
    cycle[7],
    cycle[6],
    cycle[9],
    cycle[4],
    cycle[11],
    cycle[2],
    cycle[13],
    cycle[1],
  ];
}

function buildDesiredRoundFixtures(matches, generatedFirstHalf, roundsInHalf, preserveRounds) {
  const desired = new Map();

  for (let round = 1; round <= preserveRounds; round += 1) {
    desired.set(
      round,
      getRoundMatches(matches, round).map((match) => ({
        home_team_id: match.home_team_id,
        away_team_id: match.away_team_id,
      }))
    );
  }

  for (const generatedRound of generatedFirstHalf) {
    if (generatedRound.round <= preserveRounds) continue;

    desired.set(
      generatedRound.round,
      generatedRound.fixtures
        .filter((fixture) => !fixture.isBye)
        .map((fixture) => ({
          home_team_id: fixture.home_team_id,
          away_team_id: fixture.away_team_id,
        }))
    );
  }

  for (let round = 1; round <= roundsInHalf; round += 1) {
    const firstHalfFixtures = desired.get(round);
    if (!firstHalfFixtures?.length) {
      throw new Error(`Missing first-half fixtures for round ${round}.`);
    }

    desired.set(
      round + roundsInHalf,
      firstHalfFixtures.map((fixture) => ({
        home_team_id: fixture.away_team_id,
        away_team_id: fixture.home_team_id,
      }))
    );
  }

  return desired;
}

function buildVerification(teamIds, seasonMatches) {
  const directedCounts = new Map();
  const roundUsage = new Map();

  for (const match of seasonMatches) {
    const directedKey = `${match.home_team_id}::${match.away_team_id}`;
    directedCounts.set(directedKey, (directedCounts.get(directedKey) || 0) + 1);

    for (const teamId of [match.home_team_id, match.away_team_id]) {
      const usageKey = `${match.round}::${teamId}`;
      roundUsage.set(usageKey, (roundUsage.get(usageKey) || 0) + 1);
    }
  }

  let missingPairs = 0;
  let extraPairs = 0;
  let imbalancedPairs = 0;
  let roundConflicts = 0;

  for (let indexA = 0; indexA < teamIds.length; indexA += 1) {
    for (let indexB = indexA + 1; indexB < teamIds.length; indexB += 1) {
      const teamA = teamIds[indexA];
      const teamB = teamIds[indexB];
      const homeA = directedCounts.get(`${teamA}::${teamB}`) || 0;
      const homeB = directedCounts.get(`${teamB}::${teamA}`) || 0;
      const total = homeA + homeB;

      if (total < 2) missingPairs += 1;
      if (total > 2) extraPairs += 1;
      if (total === 2 && (homeA !== 1 || homeB !== 1)) {
        imbalancedPairs += 1;
      }
    }
  }

  for (const count of roundUsage.values()) {
    if (count > 1) {
      roundConflicts += 1;
    }
  }

  return { missingPairs, extraPairs, imbalancedPairs, roundConflicts };
}

async function loadSeason(supabase, options) {
  if (options.seasonId) {
    const { data, error } = await supabase
      .from("seasons")
      .select("id, name")
      .eq("id", options.seasonId)
      .single();
    if (error) throw error;
    return data;
  }

  if (options.season !== "current") {
    const { data, error } = await supabase
      .from("seasons")
      .select("id, name")
      .eq("name", options.season)
      .single();
    if (error) throw error;
    return data;
  }

  const { data, error } = await supabase
    .from("seasons")
    .select("id, name")
    .eq("is_current", true)
    .limit(1)
    .single();
  if (error) throw error;
  return data;
}

async function loadLeague(supabase, options) {
  if (options.leagueId) {
    const { data, error } = await supabase
      .from("leagues")
      .select("id, name")
      .eq("id", options.leagueId)
      .single();
    if (error) throw error;
    return data;
  }

  const { data, error } = await supabase
    .from("leagues")
    .select("id, name")
    .eq("name", options.leagueName)
    .single();
  if (error) throw error;
  return data;
}

async function main() {
  loadEnvFile(path.join(process.cwd(), ".env"));
  loadEnvFile(path.join(process.cwd(), ".env.local"));

  const supabaseUrl = process.env.REACT_APP_SUPABASE_URL || process.env.VITE_SUPABASE_URL;
  const supabaseKey =
    process.env.SUPABASE_SERVICE_KEY ||
    process.env.REACT_APP_SUPABASE_ANON_KEY ||
    process.env.VITE_SUPABASE_ANON_KEY;

  if (!supabaseUrl || !supabaseKey) {
    throw new Error("Missing Supabase credentials in .env or .env.local.");
  }

  const options = parseArgs(process.argv.slice(2));
  const supabase = createClient(supabaseUrl, supabaseKey, { auth: { persistSession: false } });

  const season = await loadSeason(supabase, options);
  const league = await loadLeague(supabase, options);

  const [{ data: seasonTeams, error: seasonTeamsError }, { data: matches, error: matchesError }] =
    await Promise.all([
      supabase
        .from("season_teams")
        .select("team_id, joined_round, left_round, teams(name)")
        .eq("season_id", season.id)
        .eq("league_id", league.id)
        .order("created_at"),
      supabase
        .from("matches")
        .select(
          "id, round, match_date, match_time, status, home_team_id, away_team_id, home_goals, away_goals"
        )
        .eq("season_id", season.id)
        .eq("league_id", league.id)
        .order("round")
        .order("match_date")
        .order("match_time"),
    ]);

  if (seasonTeamsError) throw seasonTeamsError;
  if (matchesError) throw matchesError;

  const activeSeasonTeams = (seasonTeams || []).filter(
    (row) => row.left_round === null || row.left_round === undefined
  );
  const teamIds = activeSeasonTeams.map((row) => row.team_id);

  if (teamIds.length !== 13) {
    throw new Error(
      `This repair path currently supports exactly 13 active teams. Found ${teamIds.length}.`
    );
  }

  const lockedFutureMatches = (matches || []).filter(
    (match) => Number(match.round) > options.preserveRounds && !["scheduled", "postponed", "cancelled"].includes(String(match.status || "scheduled"))
  );
  if (lockedFutureMatches.length > 0) {
    const firstLockedRound = Math.min(...lockedFutureMatches.map((match) => Number(match.round) || 0));
    throw new Error(
      `Found non-editable matches after preserved rounds. First locked round: ${firstLockedRound}.`
    );
  }

  const cycle = buildCycleFromPreservedRounds(teamIds, matches || [], options.preserveRounds);
  const baseList = deriveBaseListFromCycle(cycle);
  const generatedFirstHalf = generateFirstHalfFromList(baseList);
  const roundsInHalf = generatedFirstHalf.length;
  const desiredRoundFixtures = buildDesiredRoundFixtures(
    matches || [],
    generatedFirstHalf,
    roundsInHalf,
    options.preserveRounds
  );

  const updates = [];
  const affectedMatchIds = [];
  const verificationMatches = [];
  const maxRound = Math.max(0, ...(matches || []).map((match) => Number(match.round) || 0));

  for (let round = 1; round <= roundsInHalf * 2; round += 1) {
    const roundMatches = getRoundMatches(matches || [], round);
    const desiredFixtures = desiredRoundFixtures.get(round) || [];

    if (desiredFixtures.length !== roundMatches.length) {
      throw new Error(
        `Round ${round} has ${roundMatches.length} rows in DB but ${desiredFixtures.length} desired fixtures.`
      );
    }

    if (round <= options.preserveRounds) {
      for (const match of roundMatches) {
        verificationMatches.push({
          round,
          home_team_id: match.home_team_id,
          away_team_id: match.away_team_id,
        });
      }
      continue;
    }

    for (let index = 0; index < roundMatches.length; index += 1) {
      const match = roundMatches[index];
      const desiredFixture = desiredFixtures[index];

      updates.push({
        matchId: match.id,
        targetRound: round,
        payload: {
          home_team_id: desiredFixture.home_team_id,
          away_team_id: desiredFixture.away_team_id,
          status: "scheduled",
          home_goals: null,
          away_goals: null,
          video_url: null,
          gallery_url: null,
          referee: null,
          referee_id: null,
          mvp_player_id: null,
          notes: null,
        },
      });
      affectedMatchIds.push(match.id);
      verificationMatches.push({
        round,
        home_team_id: desiredFixture.home_team_id,
        away_team_id: desiredFixture.away_team_id,
      });
    }
  }

  const verification = buildVerification(teamIds, verificationMatches);
  if (
    verification.missingPairs !== 0 ||
    verification.extraPairs !== 0 ||
    verification.imbalancedPairs !== 0 ||
    verification.roundConflicts !== 0
  ) {
    throw new Error(
      `Verification failed before apply: ${JSON.stringify(verification)}`
    );
  }

  const summary = {
    season: season.name,
    league: league.name,
    preserveRounds: options.preserveRounds,
    affectedMatches: updates.length,
    verification,
    apply: options.apply,
  };

  if (!options.apply) {
    console.log(JSON.stringify(summary, null, 2));
    return;
  }

  if (affectedMatchIds.length) {
    const { error: lineupDeleteError } = await supabase
      .from("match_lineups")
      .delete()
      .in("match_id", affectedMatchIds);
    if (lineupDeleteError) throw lineupDeleteError;

    const { error: eventDeleteError } = await supabase
      .from("match_events")
      .delete()
      .in("match_id", affectedMatchIds);
    if (eventDeleteError) throw eventDeleteError;
  }

  for (let index = 0; index < updates.length; index += 1) {
    const update = updates[index];
    const { error } = await supabase
      .from("matches")
      .update({ round: maxRound + 1000 + index + 1 })
      .eq("id", update.matchId);
    if (error) throw error;
  }

  for (const update of updates) {
    const { error } = await supabase
      .from("matches")
      .update({
        round: update.targetRound,
        ...update.payload,
      })
      .eq("id", update.matchId);
    if (error) throw error;
  }

  console.log(JSON.stringify(summary, null, 2));
}

main().catch((error) => {
  if (error?.stack) {
    console.error(error.stack);
  } else if (typeof error === "object") {
    console.error(JSON.stringify(error, null, 2));
  } else {
    console.error(String(error));
  }
  process.exit(1);
});
