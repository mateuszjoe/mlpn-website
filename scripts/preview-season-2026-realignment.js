#!/usr/bin/env node

// READ-ONLY PREVIEW.
// This script intentionally contains no insert/update/delete/rpc calls. It reads the
// current season, computes the proposed realignment in memory, and prints a report.

const fs = require("fs");
const path = require("path");
const { createClient } = require("@supabase/supabase-js");
const {
  EDITABLE_STATUSES,
  pairKey,
  buildConstrainedSingleRoundRobin,
  verifySingleRoundRobin,
  orientAsReturnFixtures,
  buildStageSlots,
  assignRoundsToSlots,
  remapRoundRobinStage,
  assignRoundsToStableSlots,
  buildRowReusePlan,
} = require("./lib/seasonRealignmentPlanner");

const SEASON_NAME = "Sezon 2026";
const SCHEDULE_HIDDEN_MARKER = "[MLPN_SCHEDULE_HIDDEN]";
const SECOND_LEAGUE_CATCHUP_MATCH_ID = "34ca790c-9128-48ce-9c74-8c18f069e9f1";
const SECOND_LEAGUE_RETURN_MATCH_ID = "73bed1d3-7159-41be-8ec9-ae4483e81e7d";
const SECOND_LEAGUE_NANKATSU_RKS_MATCH_ID = "2a9b5cde-310b-4f5f-adb3-7986658d33d8";
const SECOND_LEAGUE_CATCHUP_OVERRIDES = {
  round: 7,
  match_date: "2026-09-02",
  match_time: "19:20",
};
const SECOND_LEAGUE_NANKATSU_RKS_WALKOVER = {
  round: 7,
  match_date: "2026-09-02",
  match_time: "18:10",
  status: "walkover_home",
  home_goals: 3,
  away_goals: 0,
  notes: null,
};
const FIRST_LEAGUE_OVERDUE_OVERRIDES = new Map([
  [
    "3b9167d4-331a-42ce-9b6e-37706b4934c0",
    { match_date: "2026-08-25", match_time: "19:40" },
  ],
  [
    "316c2f14-5539-4212-b3a2-552aa0145750",
    { match_date: "2026-08-25", match_time: "20:50" },
  ],
]);
const TEAM_NAMES = {
  oldrembham: "Oldrembham Forest",
  nankatsu: "Nankatsu",
  slimak: "FC Ślimak Halinów",
  rayo: "Rayo Vallerano",
  tidy: "Tidy Team",
  joga: "Joga Finito",
  stm: "STM FC",
  pjm: "PJM",
  rks: "RKS Pendrachy",
  detox: "Detox",
  gosuansa: "Gosuansa",
  faludza: "Faludża",
  tiger: "Tiger Wołomin",
};
const LEAGUE_PLANS = {
  first: {
    code: "1st",
    stageName: "runda rewanżowa",
    startRound: 12,
    expectedTeamCount: 10,
    seed: 202608221,
  },
  second: {
    code: "2nd",
    stageName: "runda rewanżowa",
    startRound: 10,
    expectedTeamCount: 11,
    seed: 202608222,
  },
};

function loadEnvFile(filePath) {
  if (!fs.existsSync(filePath)) return;

  for (const rawLine of fs.readFileSync(filePath, "utf8").split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) continue;
    const equalsIndex = line.indexOf("=");
    if (equalsIndex < 1) continue;

    const key = line.slice(0, equalsIndex).trim();
    let value = line.slice(equalsIndex + 1).trim();
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }
    if (!(key in process.env)) process.env[key] = value;
  }
}

function parseArgs(argv) {
  if (argv.includes("--apply")) {
    throw new Error(
      "Ten skrypt jest wylacznie podgladem i nie obsluguje --apply. Nie zapisano zadnych zmian."
    );
  }

  const unknown = argv.filter((argument) => !["--json", "--summary"].includes(argument));
  if (unknown.length > 0) {
    throw new Error(`Nieznana opcja: ${unknown.join(", ")}`);
  }

  return {
    json: argv.includes("--json"),
    summaryOnly: argv.includes("--summary"),
  };
}

function requireRow(rows, predicate, label) {
  const row = (rows || []).find(predicate);
  if (!row) throw new Error(`Nie znaleziono: ${label}.`);
  return row;
}

function requireNoError(result, label) {
  if (result.error) {
    throw new Error(`${label}: ${result.error.message}`);
  }
  return result.data || [];
}

async function loadSnapshot(supabase) {
  const seasonRows = requireNoError(
    await supabase
      .from("seasons")
      .select("id, name, year, status, is_current")
      .eq("name", SEASON_NAME)
      .limit(1),
    "Nie udalo sie pobrac sezonu"
  );
  const season = requireRow(seasonRows, () => true, SEASON_NAME);

  const [leaguesResult, seasonLeaguesResult, teamsResult, seasonTeamsResult, matchesResult] =
    await Promise.all([
      supabase.from("leagues").select("id, code, name, display_order").order("display_order"),
      supabase
        .from("season_leagues")
        .select("id, season_id, league_id, total_rounds, current_round, played_rounds")
        .eq("season_id", season.id),
      supabase.from("teams").select("id, name, abbreviation, is_active").order("name"),
      supabase
        .from("season_teams")
        .select("id, season_id, league_id, team_id, joined_round, left_round, join_reason")
        .eq("season_id", season.id)
        .order("created_at"),
      supabase
        .from("matches")
        .select(
          "id, season_id, league_id, round, match_date, match_time, status, home_team_id, away_team_id, home_goals, away_goals, notes"
        )
        .eq("season_id", season.id)
        .order("league_id")
        .order("round")
        .order("match_date")
        .order("match_time"),
    ]);

  return {
    season,
    leagues: requireNoError(leaguesResult, "Nie udalo sie pobrac lig"),
    seasonLeagues: requireNoError(
      seasonLeaguesResult,
      "Nie udalo sie pobrac konfiguracji lig"
    ),
    teams: requireNoError(teamsResult, "Nie udalo sie pobrac druzyn"),
    seasonTeams: requireNoError(
      seasonTeamsResult,
      "Nie udalo sie pobrac przypisan druzyn"
    ),
    matches: requireNoError(matchesResult, "Nie udalo sie pobrac meczow"),
  };
}

async function loadRelatedMatchReferences(supabase, matchIds) {
  if (!matchIds.length) return {};

  const tableNames = [
    "match_events",
    "match_lineups",
    "match_result_edits",
    "typer_round_config_matches",
    "gallery_albums",
  ];
  const references = {};

  for (const tableName of tableNames) {
    const result = await supabase.from(tableName).select("match_id").in("match_id", matchIds);
    const rows = requireNoError(result, `Nie udalo sie sprawdzic zaleznosci ${tableName}`);
    references[tableName] = rows.map((row) => row.match_id);
  }

  return references;
}

function isActiveOnRound(seasonTeam, roundNumber) {
  const joinedRound = Number(seasonTeam.joined_round || 1);
  const leftRound = seasonTeam.left_round == null ? null : Number(seasonTeam.left_round);
  return joinedRound <= roundNumber && (leftRound == null || roundNumber < leftRound);
}

function buildBlockedTeamDates(matches) {
  const blocked = new Map();
  for (const match of matches || []) {
    if (!match.match_date) continue;
    for (const teamId of [match.home_team_id, match.away_team_id]) {
      if (!blocked.has(teamId)) blocked.set(teamId, new Set());
      blocked.get(teamId).add(match.match_date);
    }
  }
  return blocked;
}

function findCalendarConflicts(plan) {
  const protectedMatches = [
    ...(plan.preservedUnfinishedMatches || []),
    ...(plan.rowPlan.preservedMatches || []),
  ];
  const conflicts = [];

  for (const protectedMatch of protectedMatches) {
    for (const stageMatch of plan.schedule.matches) {
      const sameSlot =
        protectedMatch.match_date === stageMatch.match_date &&
        String(protectedMatch.match_time || "").slice(0, 5) ===
          String(stageMatch.match_time || "").slice(0, 5);
      const sharedTeamIds = [protectedMatch.home_team_id, protectedMatch.away_team_id]
        .filter((teamId) =>
          [stageMatch.home_team_id, stageMatch.away_team_id].includes(teamId)
        );
      const sameTeamSameDay =
        sharedTeamIds.length > 0 && protectedMatch.match_date === stageMatch.match_date;

      if (!sameSlot && !sameTeamSameDay) continue;
      conflicts.push({
        type: sameSlot ? "same_slot" : "same_team_same_day",
        protectedMatch,
        stageMatch,
        sharedTeamIds,
      });
    }
  }

  return conflicts;
}

function unique(values) {
  return [...new Set(values)];
}

function getLeagueRows(snapshot, leagueCode) {
  const league = requireRow(
    snapshot.leagues,
    (entry) => entry.code === leagueCode,
    `liga ${leagueCode}`
  );
  const seasonLeague = requireRow(
    snapshot.seasonLeagues,
    (entry) => entry.league_id === league.id,
    `konfiguracja ${league.name}`
  );

  return {
    league,
    seasonLeague,
    seasonTeams: snapshot.seasonTeams.filter((entry) => entry.league_id === league.id),
    matches: snapshot.matches.filter((entry) => entry.league_id === league.id),
  };
}

function buildLeaguePreview({
  leagueRows,
  teamIds,
  teamNameById,
  startRound,
  seed,
  fixedMatches = [],
  byeRounds = [],
  preserveMatchIds = [],
}) {
  const generated = buildConstrainedSingleRoundRobin({
    teamIds,
    fixedMatches,
    byeRounds,
    seed,
  });
  const priorMatches = leagueRows.matches.filter((match) => Number(match.round) < startRound);
  const preservedUnfinishedMatches = priorMatches.filter((match) =>
    EDITABLE_STATUSES.has(String(match.status || "scheduled"))
  );
  const preservedIdSet = new Set((preserveMatchIds || []).map(String));
  const preservedCatchups = leagueRows.matches.filter((match) =>
    preservedIdSet.has(String(match.id))
  );
  const orientedRounds = orientAsReturnFixtures(
    generated.rounds,
    [...priorMatches, ...preservedCatchups],
    fixedMatches
  );
  const verification = verifySingleRoundRobin(teamIds, orientedRounds);
  if (!verification.ok) {
    throw new Error(verification.errors.join("\n"));
  }

  const stageSlots = buildStageSlots({
    existingMatches: leagueRows.matches,
    startRound,
    roundCount: orientedRounds.length,
    matchesPerRound: Math.floor(teamIds.length / 2),
  });
  const scheduled = assignRoundsToSlots(
    orientedRounds,
    stageSlots,
    teamNameById,
    { blockedTeamDates: buildBlockedTeamDates(preservedUnfinishedMatches) }
  );
  const rowPlan = buildRowReusePlan({
    existingMatches: leagueRows.matches,
    desiredMatches: scheduled.matches,
    startRound,
    preserveMatchIds,
  });

  const plan = {
    startRound,
    finalRound: startRound + orientedRounds.length - 1,
    teamIds,
    activeTeamCount: teamIds.length,
    generationAttempt: generated.attempt,
    verification,
    schedule: scheduled,
    rowPlan,
    preservedUnfinishedMatches,
  };
  plan.calendarConflicts = findCalendarConflicts(plan);
  return plan;
}

function buildRemappedLeaguePreview({
  leagueRows,
  teamIds,
  teamNameById,
  startRound,
  teamIdRemap,
  fixedMatches,
  byeRounds,
  fixedSlots,
  preserveMatchIds = [],
}) {
  const priorMatches = leagueRows.matches.filter((match) => Number(match.round) < startRound);
  const preservedUnfinishedMatches = priorMatches.filter((match) =>
    EDITABLE_STATUSES.has(String(match.status || "scheduled"))
  );
  const remapped = remapRoundRobinStage({
    existingMatches: leagueRows.matches,
    teamIds,
    startRound,
    teamIdRemap,
    fixedMatches,
    byeRounds,
  });
  const verification = verifySingleRoundRobin(teamIds, remapped.rounds);
  if (!verification.ok) throw new Error(verification.errors.join("\n"));

  const stageSlots = buildStageSlots({
    existingMatches: leagueRows.matches,
    startRound,
    roundCount: remapped.rounds.length,
    matchesPerRound: Math.floor(teamIds.length / 2),
  });
  const scheduled = assignRoundsToStableSlots(
    remapped.rounds,
    stageSlots,
    leagueRows.matches,
    teamNameById,
    {
      blockedTeamDates: buildBlockedTeamDates(preservedUnfinishedMatches),
      fixedSlots,
      teamIdRemap,
    }
  );
  const rowPlan = buildRowReusePlan({
    existingMatches: leagueRows.matches,
    desiredMatches: scheduled.matches,
    startRound,
    preserveMatchIds,
  });

  const plan = {
    startRound,
    finalRound: startRound + remapped.rounds.length - 1,
    teamIds,
    activeTeamCount: teamIds.length,
    generationAttempt: remapped.remapped ? 1 : 0,
    verification,
    schedule: scheduled,
    rowPlan,
    preservedUnfinishedMatches,
    stableRemapApplied: remapped.remapped,
  };
  plan.calendarConflicts = findCalendarConflicts(plan);
  return plan;
}

function publicMatch(match, teamNameById) {
  return {
    id: match.id || null,
    round: Number(match.round),
    match_date: match.match_date,
    match_time: String(match.match_time || "").slice(0, 5),
    status: match.status,
    home_team: teamNameById.get(match.home_team_id) || match.home_team_id,
    away_team: teamNameById.get(match.away_team_id) || match.away_team_id,
  };
}

function publicPlan(plan, teamNameById) {
  return {
    startRound: plan.startRound,
    finalRound: plan.finalRound,
    activeTeamCount: plan.activeTeamCount,
    activeTeams: plan.teamIds.map((teamId) => teamNameById.get(teamId) || teamId).sort((a, b) => a.localeCompare(b, "pl")),
    generationAttempt: plan.generationAttempt,
    verification: {
      ok: plan.verification.ok,
      roundCount: plan.verification.roundCount,
      matchCount: plan.verification.matchCount,
      uniquePairCount: plan.verification.uniquePairCount,
      expectedPairCount: plan.verification.expectedPairCount,
    },
    databasePreview: {
      existingFutureRows: plan.rowPlan.existingFutureCount,
      futureRowsUsedForStage: plan.rowPlan.reusableFutureCount,
      desiredFutureRows: plan.rowPlan.desiredFutureCount,
      reusedPairRows: plan.rowPlan.reusedPairCount,
      rowsToInsert: plan.rowPlan.inserts.length,
      rowsToDelete: plan.rowPlan.deleteMatchIds.length,
      preservedCatchupRows: plan.rowPlan.preservedMatches.length,
    },
    preservedUnfinishedMatches: plan.preservedUnfinishedMatches.map((match) =>
      publicMatch(match, teamNameById)
    ),
    preservedCatchupMatches: plan.rowPlan.preservedMatches.map((match) =>
      publicMatch(match, teamNameById)
    ),
    calendarConflicts: plan.calendarConflicts.map((conflict) => ({
      type: conflict.type,
      protected_match: publicMatch(conflict.protectedMatch, teamNameById),
      stage_match: publicMatch(conflict.stageMatch, teamNameById),
      shared_teams: conflict.sharedTeamIds.map(
        (teamId) => teamNameById.get(teamId) || teamId
      ),
    })),
    rounds: plan.schedule.rounds.map((round) => ({
      stage_round: round.stage_round,
      global_round: round.global_round,
      bye_team: round.bye_team_id
        ? teamNameById.get(round.bye_team_id) || round.bye_team_id
        : null,
      matches: round.matches.map((match) => publicMatch(match, teamNameById)),
    })),
  };
}

function assertRequiredSecondLeagueConditions(secondPlan, ids) {
  const firstStageRound = secondPlan.schedule.rounds.find((round) => round.stage_round === 1);
  if (firstStageRound?.bye_team_id !== ids.pjm) {
    throw new Error("Warunek pauzy PJM w pierwszej kolejce rundy rewanzowej nie zostal spelniony.");
  }

  const requiredK10Matches = [
    [ids.slimak, ids.tidy, "2026-09-05", "18:10"],
    [ids.gosuansa, ids.detox, "2026-09-05", "20:30"],
    [ids.faludza, ids.stm, "2026-09-06", "13:40"],
    [ids.tiger, ids.joga, "2026-09-06", "14:50"],
    [ids.rks, ids.rayo, "2026-09-06", "16:00"],
  ];
  for (const [homeTeamId, awayTeamId, matchDate, matchTime] of requiredK10Matches) {
    const requiredMatch = firstStageRound?.matches.find(
      (match) =>
        match.home_team_id === homeTeamId &&
        match.away_team_id === awayTeamId
    );
    if (
      !requiredMatch ||
      requiredMatch.match_date !== matchDate ||
      String(requiredMatch.match_time || "").slice(0, 5) !== matchTime
    ) {
      throw new Error(`Nie zostal spelniony wymagany uklad K10: ${matchDate} ${matchTime}.`);
    }
  }

  const eighthStageRound = secondPlan.schedule.rounds.find((round) => round.stage_round === 8);
  if (eighthStageRound?.bye_team_id !== ids.joga) {
    throw new Error("Warunek pauzy Joga Finito w 8. kolejce rundy rewanżowej nie zostal spelniony.");
  }
}

function assertOutstandingJogaTidyPreserved(secondPlan, ids) {
  const outstanding = secondPlan.preservedUnfinishedMatches.find(
    (match) => pairKey(match.home_team_id, match.away_team_id) === pairKey(ids.joga, ids.tidy)
  );
  if (!outstanding) {
    throw new Error("Nie znaleziono zaleglego meczu Joga Finito - Tidy Team przed nowym etapem.");
  }
  return outstanding;
}

function assertDeletedRowsHaveNoReferences(plans, relatedReferences) {
  const deletedIds = new Set(
    plans.flatMap((plan) => plan.rowPlan.deleteMatchIds)
  );
  const conflicts = [];

  for (const [tableName, matchIds] of Object.entries(relatedReferences)) {
    for (const matchId of matchIds) {
      if (deletedIds.has(matchId)) conflicts.push(`${tableName}:${matchId}`);
    }
  }
  if (conflicts.length > 0) {
    throw new Error(
      `Plan probowalby usunac mecze z powiazanymi danymi: ${conflicts.join(", ")}`
    );
  }
}

function referencedReusedRows(plans, relatedReferences) {
  const reusedIds = new Set(
    plans.flatMap((plan) => plan.rowPlan.updates.map((update) => update.matchId))
  );
  const result = {};
  for (const [tableName, matchIds] of Object.entries(relatedReferences)) {
    const preserved = matchIds.filter((matchId) => reusedIds.has(matchId));
    if (preserved.length > 0) result[tableName] = preserved;
  }
  return result;
}

function printTextReport(report, summaryOnly) {
  console.log("TRYB READ-ONLY: nie zapisano żadnych zmian w Supabase.");
  console.log(`Sezon: ${report.season.name}`);
  console.log("");
  console.log("Plan zmian składu:");
  for (const change of report.changes) {
    console.log(`- ${change.label}`);
  }
  console.log("");

  for (const leagueReport of report.leagues) {
    console.log(`=== ${leagueReport.name}: ${leagueReport.stageName} ===`);
    console.log(
      `Skład: ${leagueReport.plan.activeTeamCount} | kolejki globalne ${leagueReport.plan.startRound}-${leagueReport.plan.finalRound} | mecze ${leagueReport.plan.verification.matchCount}`
    );
    console.log(
      `Rekordy DB (podgląd): zachowaj ID ${leagueReport.plan.databasePreview.reusedPairRows}, dodaj ${leagueReport.plan.databasePreview.rowsToInsert}, usuń ${leagueReport.plan.databasePreview.rowsToDelete}`
    );
    if (leagueReport.plan.databasePreview.preservedCatchupRows > 0) {
      console.log(
        `Dodatkowe zaległości poza nową rundą: ${leagueReport.plan.databasePreview.preservedCatchupRows} (rekord i ID pozostają bez zmian).`
      );
    }
    console.log(
      `Weryfikacja: ${leagueReport.plan.verification.ok ? "OK" : "BŁĄD"}, unikalne pary ${leagueReport.plan.verification.uniquePairCount}/${leagueReport.plan.verification.expectedPairCount}`
    );

    if (leagueReport.plan.preservedUnfinishedMatches.length > 0) {
      console.log("Zaległe/niedokończone mecze sprzed nowego etapu — pozostają bez zmian:");
      for (const match of leagueReport.plan.preservedUnfinishedMatches) {
        console.log(
          `  K${match.round} ${match.match_date} ${match.match_time} | ${match.home_team} - ${match.away_team} [${match.status}]`
        );
      }
    }

    if (leagueReport.plan.preservedCatchupMatches.length > 0) {
      console.log("Dodatkowy zaległy mecz poza 55 spotkaniami nowej rundy:");
      for (const match of leagueReport.plan.preservedCatchupMatches) {
        console.log(
          `  K${match.round} ${match.match_date} ${match.match_time} | ${match.home_team} - ${match.away_team} [${match.status}]`
        );
      }
      console.log("  UWAGA: termin tej zaległości trzeba ustalić osobno, aby nie dublować występu drużyny w weekendzie kolejki.");
    }

    if (leagueReport.plan.calendarConflicts.length > 0) {
      console.log("Nierozwiązane kolizje terminu:");
      for (const conflict of leagueReport.plan.calendarConflicts) {
        console.log(
          `  ${conflict.protected_match.match_date} ${conflict.protected_match.match_time}: ${conflict.protected_match.home_team} - ${conflict.protected_match.away_team} koliduje z ${conflict.stage_match.home_team} - ${conflict.stage_match.away_team}`
        );
      }
    }

    if (!summaryOnly) {
      for (const round of leagueReport.plan.rounds) {
        const byeLabel = round.bye_team ? ` | pauza: ${round.bye_team}` : "";
        console.log(`\nR2 K${round.stage_round} / globalna K${round.global_round}${byeLabel}`);
        for (const match of round.matches) {
          console.log(
            `  ${match.match_date} ${match.match_time} | ${match.home_team} - ${match.away_team}`
          );
        }
      }
    }
    console.log("\n");
  }

  const referenceCount = Object.values(report.preservedRelatedRows).reduce(
    (sum, matchIds) => sum + matchIds.length,
    0
  );
  console.log(
    `Powiązane rekordy przy zachowanych ID meczów: ${referenceCount}. Powiązane rekordy przy usuwanych ID: 0.`
  );
  console.log(
    `Zaległy Joga - Tidy zachowany: K${report.requiredChecks.outstandingJogaTidy.round}, ${report.requiredChecks.outstandingJogaTidy.match_date} ${report.requiredChecks.outstandingJogaTidy.match_time}.`
  );
  console.log(
    `Brakujący mecz I rundy RKS - Nankatsu zweryfikowany jako walkower ${report.requiredChecks.nankatsuRksWalkover.home_goals}:${report.requiredChecks.nankatsuRksWalkover.away_goals}: K${report.requiredChecks.nankatsuRksWalkover.round}, ${report.requiredChecks.nankatsuRksWalkover.match_date} ${report.requiredChecks.nankatsuRksWalkover.match_time}.`
  );
  console.log(
    `Normalny rewanż PJM - STM zachowuje ID ${report.requiredChecks.stmPjmReturn.match_id}; zaległy STM - PJM zachowuje osobne ID ${report.requiredChecks.outstandingStmPjm.id} i termin ${report.requiredChecks.outstandingStmPjm.match_date} ${report.requiredChecks.outstandingStmPjm.match_time}.`
  );
  console.log(
    report.readyToApply
      ? "Plan nie ma nierozwiązanych kolizji terminów."
      : `Plan par jest poprawny, ale przed zapisem trzeba rozwiązać ${report.unresolvedCalendarConflicts.length} kolizję terminu.`
  );
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  loadEnvFile(path.resolve(process.cwd(), ".env.local"));

  const supabaseUrl = process.env.REACT_APP_SUPABASE_URL;
  const readKey = process.env.SUPABASE_SERVICE_KEY || process.env.REACT_APP_SUPABASE_ANON_KEY;
  if (!supabaseUrl || !readKey) {
    throw new Error("Brak REACT_APP_SUPABASE_URL lub klucza odczytu w .env.local.");
  }

  const supabase = createClient(supabaseUrl, readKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const snapshot = await loadSnapshot(supabase);
  const teamNameById = new Map(snapshot.teams.map((team) => [team.id, team.name]));
  const ids = Object.fromEntries(
    Object.entries(TEAM_NAMES).map(([key, name]) => [
      key,
      requireRow(snapshot.teams, (team) => team.name === name, `druzyna ${name}`).id,
    ])
  );

  const firstRows = getLeagueRows(snapshot, LEAGUE_PLANS.first.code);
  const secondRows = getLeagueRows(snapshot, LEAGUE_PLANS.second.code);
  const oldrembhamSeasonTeam = requireRow(
    firstRows.seasonTeams,
    (entry) => entry.team_id === ids.oldrembham,
    "przypisanie Oldrembham do I ligi"
  );
  const nankatsuSeasonTeam = requireRow(
    secondRows.seasonTeams,
    (entry) => entry.team_id === ids.nankatsu,
    "przypisanie Nankatsu do II ligi"
  );

  const firstTeamIds = firstRows.seasonTeams
    .filter((entry) => entry.team_id !== ids.oldrembham)
    .filter((entry) => isActiveOnRound(entry, LEAGUE_PLANS.first.startRound))
    .map((entry) => entry.team_id);
  const secondTeamIds = unique([
    ...secondRows.seasonTeams
      .filter((entry) => entry.team_id !== ids.nankatsu)
      .filter((entry) => isActiveOnRound(entry, LEAGUE_PLANS.second.startRound))
      .map((entry) => entry.team_id),
    ids.slimak,
    ids.rayo,
  ]);

  if (firstTeamIds.length !== LEAGUE_PLANS.first.expectedTeamCount) {
    throw new Error(
      `I Liga po wycofaniu Oldrembham ma ${firstTeamIds.length} aktywnych druzyn, oczekiwano ${LEAGUE_PLANS.first.expectedTeamCount}.`
    );
  }
  if (secondTeamIds.length !== LEAGUE_PLANS.second.expectedTeamCount) {
    throw new Error(
      `II Liga po zmianach ma ${secondTeamIds.length} aktywnych druzyn, oczekiwano ${LEAGUE_PLANS.second.expectedTeamCount}.`
    );
  }

  const firstPlan = buildLeaguePreview({
    leagueRows: firstRows,
    teamIds: firstTeamIds,
    teamNameById,
    startRound: LEAGUE_PLANS.first.startRound,
    seed: LEAGUE_PLANS.first.seed,
  });
  for (const [matchId, override] of FIRST_LEAGUE_OVERDUE_OVERRIDES) {
    const overdueMatch = requireRow(
      firstPlan.preservedUnfinishedMatches,
      (match) => match.id === matchId,
      `zalegly mecz I ligi ${matchId}`
    );
    Object.assign(overdueMatch, override);
  }
  firstPlan.calendarConflicts = findCalendarConflicts(firstPlan);

  const secondFixedMatches = [
    { stageRound: 1, teamAId: ids.slimak, teamBId: ids.tidy, homeTeamId: ids.slimak },
    { stageRound: 1, teamAId: ids.gosuansa, teamBId: ids.detox, homeTeamId: ids.gosuansa },
    { stageRound: 1, teamAId: ids.faludza, teamBId: ids.stm, homeTeamId: ids.faludza },
    { stageRound: 1, teamAId: ids.tiger, teamBId: ids.joga, homeTeamId: ids.tiger },
    { stageRound: 1, teamAId: ids.rks, teamBId: ids.rayo, homeTeamId: ids.rks },
  ];
  const secondByeRounds = [
    { stageRound: 1, teamId: ids.pjm },
    { stageRound: 8, teamId: ids.joga },
  ];
  const secondFixedSlots = [
    { stageRound: 1, teamAId: ids.slimak, teamBId: ids.tidy, match_date: "2026-09-05", match_time: "18:10" },
    { stageRound: 1, teamAId: ids.gosuansa, teamBId: ids.detox, match_date: "2026-09-05", match_time: "20:30" },
    { stageRound: 1, teamAId: ids.faludza, teamBId: ids.stm, match_date: "2026-09-06", match_time: "13:40" },
    { stageRound: 1, teamAId: ids.tiger, teamBId: ids.joga, match_date: "2026-09-06", match_time: "14:50" },
    { stageRound: 1, teamAId: ids.rks, teamBId: ids.rayo, match_date: "2026-09-06", match_time: "16:00" },
  ];
  const secondPlan = buildRemappedLeaguePreview({
    leagueRows: secondRows,
    teamIds: secondTeamIds,
    teamNameById,
    startRound: LEAGUE_PLANS.second.startRound,
    teamIdRemap: new Map([
      [ids.detox, ids.pjm],
      [ids.pjm, ids.detox],
    ]),
    fixedMatches: secondFixedMatches,
    byeRounds: secondByeRounds,
    fixedSlots: secondFixedSlots,
    preserveMatchIds: [
      SECOND_LEAGUE_CATCHUP_MATCH_ID,
      SECOND_LEAGUE_NANKATSU_RKS_MATCH_ID,
    ],
  });

  const preservedCatchup = requireRow(
    secondPlan.rowPlan.preservedMatches,
    (match) =>
      match.id === SECOND_LEAGUE_CATCHUP_MATCH_ID &&
      match.home_team_id === ids.stm &&
      match.away_team_id === ids.pjm,
    "zalegly pierwszy mecz STM FC - PJM"
  );
  Object.assign(preservedCatchup, SECOND_LEAGUE_CATCHUP_OVERRIDES);

  const nankatsuRksWalkover = requireRow(
    secondPlan.rowPlan.preservedMatches,
    (match) =>
      match.id === SECOND_LEAGUE_NANKATSU_RKS_MATCH_ID &&
      match.home_team_id === ids.rks &&
      match.away_team_id === ids.nankatsu,
    "zalegly pierwszy mecz RKS Pendrachy - Nankatsu"
  );
  Object.assign(nankatsuRksWalkover, SECOND_LEAGUE_NANKATSU_RKS_WALKOVER);
  secondPlan.calendarConflicts = findCalendarConflicts(secondPlan);

  const stmPjmReturn = requireRow(
    secondPlan.rowPlan.updates,
    (update) =>
      update.matchId === SECOND_LEAGUE_RETURN_MATCH_ID &&
      update.payload.home_team_id === ids.pjm &&
      update.payload.away_team_id === ids.stm,
    "normalny rewanz PJM - STM FC z zachowanym ID"
  );

  assertRequiredSecondLeagueConditions(secondPlan, ids);
  const outstandingJogaTidy = assertOutstandingJogaTidyPreserved(secondPlan, ids);

  const affectedExistingMatchIds = unique([
    ...firstRows.matches
      .filter((match) => Number(match.round) >= firstPlan.startRound)
      .map((match) => match.id),
    ...secondRows.matches
      .filter((match) => Number(match.round) >= secondPlan.startRound)
      .map((match) => match.id),
  ]);
  const relatedReferences = await loadRelatedMatchReferences(
    supabase,
    affectedExistingMatchIds
  );
  assertDeletedRowsHaveNoReferences([firstPlan, secondPlan], relatedReferences);

  const report = {
    readOnly: true,
    generatedAt: new Date().toISOString(),
    season: snapshot.season,
    changes: [
      {
        type: "withdraw",
        team: TEAM_NAMES.oldrembham,
        season_team_id: oldrembhamSeasonTeam.id,
        left_round: LEAGUE_PLANS.first.startRound,
        label: `${TEAM_NAMES.oldrembham}: wycofanie od globalnej K${LEAGUE_PLANS.first.startRound} (mechanizm left_round jak SDK)`,
      },
      {
        type: "withdraw",
        team: TEAM_NAMES.nankatsu,
        season_team_id: nankatsuSeasonTeam.id,
        left_round: LEAGUE_PLANS.second.startRound,
        label: `${TEAM_NAMES.nankatsu}: wycofanie od globalnej K${LEAGUE_PLANS.second.startRound} (mechanizm left_round jak SDK)`,
      },
      {
        type: "join",
        team: TEAM_NAMES.slimak,
        team_id: ids.slimak,
        league: secondRows.league.name,
        joined_round: LEAGUE_PLANS.second.startRound,
        join_reason: "mid_season_join",
        label: `${TEAM_NAMES.slimak}: dołącza do II ligi od globalnej K${LEAGUE_PLANS.second.startRound}`,
      },
      {
        type: "join",
        team: TEAM_NAMES.rayo,
        team_id: ids.rayo,
        league: secondRows.league.name,
        joined_round: LEAGUE_PLANS.second.startRound,
        join_reason: "mid_season_join",
        label: `${TEAM_NAMES.rayo}: dołącza do II ligi od globalnej K${LEAGUE_PLANS.second.startRound}`,
      },
    ],
    leagues: [
      {
        code: firstRows.league.code,
        name: firstRows.league.name,
        stageName: LEAGUE_PLANS.first.stageName,
        plan: publicPlan(firstPlan, teamNameById),
      },
      {
        code: secondRows.league.code,
        name: secondRows.league.name,
        stageName: LEAGUE_PLANS.second.stageName,
        plan: publicPlan(secondPlan, teamNameById),
      },
    ],
    requiredChecks: {
      secondLeagueOpeningMatch: `${TEAM_NAMES.slimak} - ${TEAM_NAMES.tidy}`,
      secondLeagueEighthRoundBye: TEAM_NAMES.joga,
      outstandingJogaTidy: publicMatch(outstandingJogaTidy, teamNameById),
      outstandingStmPjm: publicMatch(preservedCatchup, teamNameById),
      nankatsuRksWalkover: {
        ...publicMatch(nankatsuRksWalkover, teamNameById),
        home_goals: nankatsuRksWalkover.home_goals,
        away_goals: nankatsuRksWalkover.away_goals,
      },
      rescheduledFirstLeagueMatches: firstPlan.preservedUnfinishedMatches
        .filter((match) => FIRST_LEAGUE_OVERDUE_OVERRIDES.has(match.id))
        .map((match) => publicMatch(match, teamNameById)),
      stmPjmReturn: {
        match_id: stmPjmReturn.matchId,
        round: stmPjmReturn.payload.round,
        home_team: teamNameById.get(stmPjmReturn.payload.home_team_id),
        away_team: teamNameById.get(stmPjmReturn.payload.away_team_id),
      },
      futureNotesMarker: SCHEDULE_HIDDEN_MARKER,
    },
    preservedRelatedRows: referencedReusedRows(
      [firstPlan, secondPlan],
      relatedReferences
    ),
    deletionReferenceCount: 0,
  };
  report.unresolvedCalendarConflicts = report.leagues.flatMap((league) =>
    league.plan.calendarConflicts.map((conflict) => ({
      league: league.name,
      ...conflict,
    }))
  );
  report.readyToApply = report.unresolvedCalendarConflicts.length === 0;

  if (args.json) {
    console.log(JSON.stringify(report, null, 2));
  } else {
    printTextReport(report, args.summaryOnly);
  }
}

main().catch((error) => {
  console.error(`Podglad nie powiodl sie: ${error.message}`);
  process.exitCode = 1;
});
