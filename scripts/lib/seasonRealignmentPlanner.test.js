const test = require("node:test");
const assert = require("node:assert/strict");

const {
  pairKey,
  buildConstrainedSingleRoundRobin,
  verifySingleRoundRobin,
  orientAsReturnFixtures,
  buildStageSlots,
  assignRoundsToSlots,
  buildRowReusePlan,
} = require("./seasonRealignmentPlanner");

test("uklada 11-zespolowa runde z wymaganym meczem i pauza", () => {
  const teamIds = Array.from({ length: 11 }, (_, index) => `team-${index + 1}`);
  const fixedMatches = [{
    stageRound: 1,
    teamAId: "team-1",
    teamBId: "team-2",
    homeTeamId: "team-1",
  }];
  const byeRounds = [{ stageRound: 8, teamId: "team-3" }];

  const result = buildConstrainedSingleRoundRobin({
    teamIds,
    fixedMatches,
    byeRounds,
    seed: 20260822,
  });
  const verification = verifySingleRoundRobin(teamIds, result.rounds);

  assert.equal(verification.ok, true, verification.errors.join("\n"));
  assert.equal(result.rounds.length, 11);
  assert.equal(result.rounds[7].bye_team_id, "team-3");
  assert.deepEqual(
    result.rounds[0].matches.find(
      (match) => pairKey(match.home_team_id, match.away_team_id) === pairKey("team-1", "team-2")
    ),
    { home_team_id: "team-1", away_team_id: "team-2" }
  );
});

test("uklada pojedyncza runde dla 10 zespolow bez pauz", () => {
  const teamIds = Array.from({ length: 10 }, (_, index) => `team-${index + 1}`);
  const result = buildConstrainedSingleRoundRobin({ teamIds, seed: 7 });
  const verification = verifySingleRoundRobin(teamIds, result.rounds);

  assert.equal(verification.ok, true, verification.errors.join("\n"));
  assert.equal(result.rounds.length, 9);
  assert.equal(result.rounds.every((round) => round.bye_team_id === null), true);
});

test("odwraca gospodarza rewanzu, ale respektuje jawne wskazanie gospodarza", () => {
  const rounds = [{
    stage_round: 1,
    bye_team_id: null,
    matches: [
      { home_team_id: "a", away_team_id: "b" },
      { home_team_id: "c", away_team_id: "d" },
    ],
  }];
  const priorMatches = [
    { round: 2, home_team_id: "a", away_team_id: "b" },
    { round: 3, home_team_id: "d", away_team_id: "c" },
  ];

  const oriented = orientAsReturnFixtures(rounds, priorMatches, [{
    stageRound: 1,
    teamAId: "a",
    teamBId: "b",
    homeTeamId: "a",
  }]);

  assert.deepEqual(oriented[0].matches[0], { home_team_id: "a", away_team_id: "b" });
  assert.deepEqual(oriented[0].matches[1], { home_team_id: "c", away_team_id: "d" });
});

test("uzupelnia niepelna kolejke i dodaje brakujaca kolejke kalendarza", () => {
  const existingMatches = [
    { round: 10, match_date: "2026-09-05", match_time: "18:10:00" },
    { round: 10, match_date: "2026-09-06", match_time: "13:40:00" },
    { round: 10, match_date: "2026-09-06", match_time: "14:50:00" },
    { round: 10, match_date: "2026-09-06", match_time: "16:00:00" },
    { round: 10, match_date: "2026-09-07", match_time: "19:50:00" },
    { round: 11, match_date: "2026-09-12", match_time: "18:10:00" },
    { round: 11, match_date: "2026-09-13", match_time: "13:40:00" },
  ];

  const slots = buildStageSlots({
    existingMatches,
    startRound: 10,
    roundCount: 3,
    matchesPerRound: 5,
  });

  assert.equal(slots.length, 3);
  assert.equal(slots.every((round) => round.slots.length === 5), true);
  assert.equal(slots[1].slots[4].match_date, "2026-09-14");
  assert.equal(slots[2].slots[0].match_date, "2026-09-19");
});

test("buduje plan ponownego uzycia, usuniecia i dodania rekordow", () => {
  const existingMatches = [
    { id: "old-1", round: 10, match_date: "2026-09-05", match_time: "18:10", status: "scheduled", home_team_id: "b", away_team_id: "a" },
    { id: "old-2", round: 10, match_date: "2026-09-06", match_time: "13:40", status: "scheduled", home_team_id: "x", away_team_id: "y" },
  ];
  const desiredMatches = [
    { round: 10, match_date: "2026-09-05", match_time: "18:10", home_team_id: "a", away_team_id: "b" },
    { round: 10, match_date: "2026-09-06", match_time: "13:40", home_team_id: "c", away_team_id: "d" },
    { round: 11, match_date: "2026-09-12", match_time: "18:10", home_team_id: "e", away_team_id: "f" },
  ];

  const plan = buildRowReusePlan({ existingMatches, desiredMatches, startRound: 10 });

  assert.equal(plan.updates.length, 1);
  assert.equal(plan.updates[0].matchId, "old-1");
  assert.equal(plan.inserts.length, 2);
  assert.deepEqual(plan.deleteMatchIds, ["old-2"]);
  assert.equal(plan.desiredFutureCount, 3);
});

test("zachowuje wskazany zalegly mecz poza nowym etapem", () => {
  const existingMatches = [
    { id: "return", round: 14, match_date: "2026-10-04", match_time: "13:40", status: "scheduled", home_team_id: "a", away_team_id: "b" },
    { id: "catchup", round: 19, match_date: "2026-11-14", match_time: "18:10", status: "scheduled", home_team_id: "b", away_team_id: "a" },
  ];
  const desiredMatches = [
    { round: 12, match_date: "2026-09-19", match_time: "13:40", home_team_id: "a", away_team_id: "b" },
  ];

  const plan = buildRowReusePlan({
    existingMatches,
    desiredMatches,
    startRound: 10,
    preserveMatchIds: ["catchup"],
  });

  assert.equal(plan.updates.length, 1);
  assert.equal(plan.updates[0].matchId, "return");
  assert.equal(plan.preservedMatches[0].id, "catchup");
  assert.equal(plan.deleteMatchIds.length, 0);
  assert.equal(plan.inserts.length, 0);
});

test("rozpoznaje zachowany zalegly mecz po przeniesieniu przed nowy etap", () => {
  const existingMatches = [
    { id: "catchup", round: 7, match_date: "2026-09-02", match_time: "19:20", status: "scheduled", home_team_id: "b", away_team_id: "a" },
    { id: "return", round: 12, match_date: "2026-09-19", match_time: "13:40", status: "scheduled", home_team_id: "a", away_team_id: "b" },
  ];
  const desiredMatches = [
    { round: 12, match_date: "2026-09-19", match_time: "13:40", home_team_id: "a", away_team_id: "b" },
  ];

  const plan = buildRowReusePlan({
    existingMatches,
    desiredMatches,
    startRound: 10,
    preserveMatchIds: ["catchup"],
  });

  assert.equal(plan.updates.length, 1);
  assert.equal(plan.updates[0].matchId, "return");
  assert.equal(plan.preservedMatches[0].id, "catchup");
  assert.equal(plan.deleteMatchIds.length, 0);
  assert.equal(plan.inserts.length, 0);
});

test("nie przydziela druzyny na dzien jej zachowanego zaleglego meczu", () => {
  const rounds = [{
    stage_round: 1,
    bye_team_id: null,
    matches: [
      { home_team_id: "a", away_team_id: "b" },
      { home_team_id: "c", away_team_id: "d" },
    ],
  }];
  const stageSlots = [{
    stage_round: 1,
    global_round: 10,
    slots: [
      { match_date: "2026-09-05", match_time: "18:10" },
      { match_date: "2026-09-06", match_time: "13:40" },
    ],
  }];
  const blockedTeamDates = new Map([["a", new Set(["2026-09-05"])]]);

  const scheduled = assignRoundsToSlots(
    rounds,
    stageSlots,
    new Map(),
    { blockedTeamDates }
  );
  const matchA = scheduled.matches.find(
    (match) => match.home_team_id === "a" || match.away_team_id === "a"
  );

  assert.equal(matchA.match_date, "2026-09-06");
});
