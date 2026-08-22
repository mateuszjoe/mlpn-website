const test = require("node:test");
const assert = require("node:assert/strict");

const {
  pairKey,
  buildConstrainedSingleRoundRobin,
  verifySingleRoundRobin,
  orientAsReturnFixtures,
  buildStageSlots,
  assignRoundsToSlots,
  remapRoundRobinStage,
  assignRoundsToStableSlots,
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

test("przemapowuje pauze przez zamiane druzyn i jest idempotentny", () => {
  const teamIds = ["slimak", "tidy", "gosuansa", "detox", "pjm"];
  const baseline = buildConstrainedSingleRoundRobin({
    teamIds,
    fixedMatches: [
      { stageRound: 1, teamAId: "slimak", teamBId: "tidy", homeTeamId: "slimak" },
      { stageRound: 1, teamAId: "gosuansa", teamBId: "pjm", homeTeamId: "gosuansa" },
    ],
    byeRounds: [{ stageRound: 1, teamId: "detox" }],
    seed: 901,
  });
  const existingMatches = baseline.rounds.flatMap((round) =>
    round.matches.map((match, index) => ({
      id: `before-${round.stage_round}-${index}`,
      round: 9 + round.stage_round,
      match_date: `2026-09-${String(4 + round.stage_round).padStart(2, "0")}`,
      match_time: index === 0 ? "18:10" : "19:20",
      status: "scheduled",
      ...match,
    }))
  );
  const targetFixedMatches = [
    { stageRound: 1, teamAId: "slimak", teamBId: "tidy", homeTeamId: "slimak" },
    { stageRound: 1, teamAId: "gosuansa", teamBId: "detox", homeTeamId: "gosuansa" },
  ];
  const targetByeRounds = [{ stageRound: 1, teamId: "pjm" }];

  const first = remapRoundRobinStage({
    existingMatches,
    teamIds,
    startRound: 10,
    teamIdRemap: new Map([["detox", "pjm"], ["pjm", "detox"]]),
    fixedMatches: targetFixedMatches,
    byeRounds: targetByeRounds,
  });
  assert.equal(first.remapped, true);
  assert.equal(first.rounds[0].bye_team_id, "pjm");
  assert.equal(
    first.rounds[0].matches.some(
      (match) => pairKey(match.home_team_id, match.away_team_id) === pairKey("gosuansa", "detox")
    ),
    true
  );
  assert.equal(verifySingleRoundRobin(teamIds, first.rounds).ok, true);

  const appliedMatches = first.rounds.flatMap((round) =>
    round.matches.map((match, index) => ({
      id: `after-${round.stage_round}-${index}`,
      round: 9 + round.stage_round,
      match_date: `2026-10-${String(round.stage_round).padStart(2, "0")}`,
      match_time: index === 0 ? "18:10" : "19:20",
      status: "scheduled",
      ...match,
    }))
  );
  const second = remapRoundRobinStage({
    existingMatches: appliedMatches,
    teamIds,
    startRound: 10,
    teamIdRemap: new Map([["detox", "pjm"], ["pjm", "detox"]]),
    fixedMatches: targetFixedMatches,
    byeRounds: targetByeRounds,
  });

  assert.equal(second.remapped, false);
  assert.deepEqual(second.rounds, first.rounds);
});

test("stabilnie przypisuje piec wskazanych slotow K10 i nie dryfuje po wdrozeniu", () => {
  const rounds = [{
    stage_round: 1,
    global_round: 10,
    bye_team_id: "pjm",
    matches: [
      { home_team_id: "slimak", away_team_id: "tidy" },
      { home_team_id: "gosuansa", away_team_id: "detox" },
      { home_team_id: "faludza", away_team_id: "stm" },
      { home_team_id: "tiger", away_team_id: "joga" },
      { home_team_id: "rks", away_team_id: "rayo" },
    ],
  }];
  const existingMatches = [
    { id: "st", round: 10, match_date: "2026-09-06", match_time: "13:40", home_team_id: "slimak", away_team_id: "tidy" },
    { id: "gd", round: 15, match_date: "2026-10-11", match_time: "13:40", home_team_id: "gosuansa", away_team_id: "detox" },
    { id: "fs", round: 10, match_date: "2026-09-05", match_time: "18:10", home_team_id: "faludza", away_team_id: "stm" },
    { id: "tj", round: 10, match_date: "2026-09-07", match_time: "19:50", home_team_id: "tiger", away_team_id: "joga" },
    { id: "rr", round: 10, match_date: "2026-09-06", match_time: "16:00", home_team_id: "rks", away_team_id: "rayo" },
  ];
  const stageSlots = [{
    stage_round: 1,
    global_round: 10,
    slots: [
      { match_date: "2026-09-05", match_time: "18:10" },
      { match_date: "2026-09-06", match_time: "13:40" },
      { match_date: "2026-09-06", match_time: "14:50" },
      { match_date: "2026-09-06", match_time: "16:00" },
      { match_date: "2026-09-07", match_time: "19:50" },
    ],
  }];
  const fixedSlots = [
    { stageRound: 1, teamAId: "slimak", teamBId: "tidy", match_date: "2026-09-05", match_time: "18:10" },
    { stageRound: 1, teamAId: "gosuansa", teamBId: "detox", match_date: "2026-09-05", match_time: "20:30" },
    { stageRound: 1, teamAId: "faludza", teamBId: "stm", match_date: "2026-09-06", match_time: "13:40" },
    { stageRound: 1, teamAId: "tiger", teamBId: "joga", match_date: "2026-09-06", match_time: "14:50" },
    { stageRound: 1, teamAId: "rks", teamBId: "rayo", match_date: "2026-09-06", match_time: "16:00" },
  ];

  const first = assignRoundsToStableSlots(
    rounds,
    stageSlots,
    existingMatches,
    new Map(),
    { fixedSlots }
  );
  assert.deepEqual(
    first.rounds[0].matches
      .map((match) => `${pairKey(match.home_team_id, match.away_team_id)}@${match.match_date} ${match.match_time}`)
      .sort(),
    [
      "detox::gosuansa@2026-09-05 20:30",
      "faludza::stm@2026-09-06 13:40",
      "joga::tiger@2026-09-06 14:50",
      "rayo::rks@2026-09-06 16:00",
      "slimak::tidy@2026-09-05 18:10",
    ]
  );

  const appliedMatches = first.matches.map((match, index) => ({
    ...match,
    id: `applied-${index}`,
  }));
  const appliedSlots = [{
    stage_round: 1,
    global_round: 10,
    slots: first.matches.map((match) => ({
      match_date: match.match_date,
      match_time: match.match_time,
    })),
  }];
  const second = assignRoundsToStableSlots(
    rounds,
    appliedSlots,
    appliedMatches,
    new Map(),
    { fixedSlots }
  );

  assert.deepEqual(second, first);
});

test("zmieniona para dziedziczy slot pary zrodlowej przez odwrotne mapowanie", () => {
  const rounds = [{
    stage_round: 1,
    global_round: 13,
    bye_team_id: "stm",
    matches: [
      { home_team_id: "tidy", away_team_id: "pjm" },
      { home_team_id: "faludza", away_team_id: "detox" },
    ],
  }];
  const existingMatches = [
    { id: "source-dt", round: 13, match_date: "2026-09-26", match_time: "18:10", home_team_id: "detox", away_team_id: "tidy" },
    { id: "source-fp", round: 13, match_date: "2026-09-27", match_time: "16:00", home_team_id: "faludza", away_team_id: "pjm" },
  ];
  const stageSlots = [{
    stage_round: 1,
    global_round: 13,
    slots: [
      { match_date: "2026-09-26", match_time: "18:10" },
      { match_date: "2026-09-27", match_time: "16:00" },
    ],
  }];
  const teamIdRemap = new Map([["detox", "pjm"], ["pjm", "detox"]]);

  const first = assignRoundsToStableSlots(
    rounds,
    stageSlots,
    existingMatches,
    new Map(),
    { teamIdRemap }
  );
  const tidyPjm = first.matches.find(
    (match) => pairKey(match.home_team_id, match.away_team_id) === pairKey("tidy", "pjm")
  );
  const faludzaDetox = first.matches.find(
    (match) => pairKey(match.home_team_id, match.away_team_id) === pairKey("faludza", "detox")
  );
  assert.deepEqual(
    [tidyPjm.match_date, tidyPjm.match_time],
    ["2026-09-26", "18:10"]
  );
  assert.deepEqual(
    [faludzaDetox.match_date, faludzaDetox.match_time],
    ["2026-09-27", "16:00"]
  );

  const appliedMatches = first.matches.map((match, index) => ({
    ...match,
    id: `applied-source-slot-${index}`,
  }));
  const second = assignRoundsToStableSlots(
    rounds,
    stageSlots,
    appliedMatches,
    new Map(),
    { teamIdRemap }
  );
  assert.deepEqual(second, first);
});
