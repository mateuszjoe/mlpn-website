import { rankStandings, sortStandingsForDisplay, applyLiveFixturesToTable } from "./standingsRanking";

const row = (team, pts = 10, gf = 10, ga = 10, extra = {}) => ({ team, pts, gf, ga, league: "1st", ...extra });
const match = (home, away, homeGoals, awayGoals, extra = {}) => ({
  home, away, homeGoals, awayGoals, status: "completed", league: "1st", ...extra,
});
const names = (rows) => rows.map(({ team }) => team);
const permutations = ([head, ...tail]) => head === undefined ? [[]]
  : permutations(tail).flatMap((order) => order.map((_, index) => index).concat(order.length)
    .map((index) => [...order.slice(0, index), head, ...order.slice(index)]));

describe("league head-to-head ranking", () => {
  test("fixes both tied pairs from the reported I Liga table", () => {
    const rows = [row("Starszaki", 40, 100, 57), row("Rebelianci", 40, 85, 42),
      row("Legioholicy", 36, 80, 54), row("1 Warszawska Brygada Pancerna", 36, 58, 33)];
    const matches = [match("Starszaki", "Rebelianci", 4, 3), match("Rebelianci", "Starszaki", 4, 1),
      match("1 Warszawska Brygada Pancerna", "Legioholicy", 2, 3),
      match("Legioholicy", "1 Warszawska Brygada Pancerna", 1, 3)];
    const ranked = rankStandings(rows, matches);
    expect(names(ranked)).toEqual(["Rebelianci", "Starszaki", "1 Warszawska Brygada Pancerna", "Legioholicy"]);
    expect(ranked.map(({ pos }) => pos)).toEqual([1, 2, 3, 4]);
  });

  test("a direct win takes precedence over a much better overall goal difference", () => {
    expect(names(rankStandings([row("A", 10, 100, 1), row("B", 10, 5, 90)], [match("B", "A", 1, 0)])))
      .toEqual(["B", "A"]);
  });

  test("uses one transitive mini-table for a three-club win cycle in every input order", () => {
    const rows = [row("A", 10, 10, 20), row("B", 10, 100, 10), row("C", 10, 10, 10)];
    const matches = [match("A", "B", 4, 0), match("B", "C", 2, 0), match("C", "A", 1, 0)];
    for (const order of permutations(rows)) {
      expect(names(rankStandings(order, [...matches].reverse()))).toEqual(["A", "C", "B"]);
    }
  });

  test("breaks equal mini-table points and differences by mini-table goals scored", () => {
    const rows = [row("A"), row("B"), row("C")];
    const matches = [match("A", "B", 1, 1), match("B", "C", 2, 2), match("C", "A", 3, 3)];
    expect(names(rankStandings(rows, matches))).toEqual(["C", "A", "B"]);
  });

  test("keeps the original mini-table when only some tied clubs separate on direct points", () => {
    const rows = [row("A"), row("B", 10, 100, 1), row("C", 10, 1, 100)];
    const matches = [match("A", "B", 10, 0), match("A", "C", 1, 0), match("B", "C", 2, 2)];
    expect(names(rankStandings(rows, matches))).toEqual(["A", "C", "B"]);
  });

  test("falls back to overall goal difference, goals and name when direct results do not separate clubs", () => {
    const rows = [row("D", 10, 5, 3), row("C", 10, 6, 4), row("B", 10, 6, 4), row("A", 10, 8, 3)];
    expect(names(rankStandings(rows, []))).toEqual(["A", "B", "C", "D"]);
  });

  test("never lets a direct result overrule different league points", () => {
    expect(names(rankStandings([row("A", 12), row("B", 11)], [match("B", "A", 99, 0)])))
      .toEqual(["A", "B"]);
  });

  test("keeps a withdrawn club last and out of the active tie group's mini-table", () => {
    const rows = [row("A"), row("B"), row("Withdrawn", 10, 99, 0, { withdrawn: true })];
    const matches = [match("B", "A", 1, 0), match("A", "Withdrawn", 50, 0), match("Withdrawn", "B", 1, 0)];
    expect(names(rankStandings(rows, matches))).toEqual(["B", "A", "Withdrawn"]);
    expect(names(rankStandings([row("A", 1), row("Withdrawn", 99, 99, 0, { withdrawn: true })], [])))
      .toEqual(["A", "Withdrawn"]);
  });

  test.each(["scheduled", "postponed", "cancelled", "unplayed", "live"])("ignores %s games in the official mini-table", (status) => {
    expect(names(rankStandings([row("A"), row("B")], [match("B", "A", 99, 0, { status })])))
      .toEqual(["A", "B"]);
  });

  test.each([null, undefined, "", "bad", -1, 0.5])("does not turn an invalid completed score (%s) into a result", (score) => {
    const games = [match("B", "A", 1, score)];
    expect(names(rankStandings([row("A"), row("B")], games))).toEqual(["A", "B"]);
  });

  test("excludes results in a different league with the same club names", () => {
    expect(names(rankStandings([row("A"), row("B")], [match("B", "A", 99, 0, { league: "2nd" })])))
      .toEqual(["A", "B"]);
    expect(names(rankStandings([{ team: "A", pts: 1 }, { team: "B", pts: 1 }],
      [match("B", "A", 1, 0)], { leagueId: "2nd" }))).toEqual(["A", "B"]);
  });

  test("uses available head-to-head results before the return fixture is played", () => {
    expect(names(rankStandings([row("A"), row("B")], [match("B", "A", 1, 0),
      match("A", "B", null, null, { status: "scheduled" })]))).toEqual(["B", "A"]);
  });

  test.each(["walkover_home", "walkover_away"])("resolves %s from its direction even if score fields are stale", (status) => {
    const game = status === "walkover_home" ? match("B", "A", 0, 99, { status })
      : match("A", "B", 99, 0, { status });
    expect(names(rankStandings([row("A"), row("B")], [game]))).toEqual(["B", "A"]);
  });

  test("uses configured walkover goals and match points", () => {
    const rows = [row("A"), row("B"), row("C")];
    const matches = [match("A", "B", null, null, { status: "walkover_home" }),
      match("B", "C", 4, 0), match("C", "A", 2, 0)];
    expect(names(rankStandings(rows, matches))).toEqual(["B", "A", "C"]);
    expect(names(rankStandings(rows, matches, { walkoverGoalsWinner: 8 }))).toEqual(["A", "C", "B"]);
    expect(names(rankStandings([row("A"), row("B"), row("C")],
      [match("A", "B", 1, 0), match("B", "C", 0, 0), match("B", "C", 0, 0)],
      { pointsWin: 1, pointsDraw: 1 }))).toEqual(["C", "B", "A"]);
  });

  test("includes valid live scores only when requested", () => {
    const rows = [row("A"), row("B")];
    const games = [match("B", "A", 1, 0, { status: "live" })];
    expect(names(rankStandings(rows, games, { includeLive: true }))).toEqual(["B", "A"]);
  });

  test("does not mutate source rows, scores or totals", () => {
    const rows = Object.freeze([Object.freeze(row("A")), Object.freeze(row("B"))]);
    const games = Object.freeze([Object.freeze(match("B", "A", 1, 0))]);
    const result = rankStandings(rows, games);
    expect(result[0]).toEqual({ ...rows[1], pos: 1 });
    expect(result[0]).not.toBe(rows[1]);
    expect(rows[0].pos).toBeUndefined();
    expect(rankStandings([], [])).toEqual([]);
  });
});

describe("table column sorting", () => {
  const rows = [row("B", 40, 5, 20, { pos: 1 }), row("A", 40, 100, 0, { pos: 2 }),
    row("C", 10, 3, 20, { pos: 3 }), row("Withdrawn", 99, 999, 0, { pos: 4, withdrawn: true })];

  test("keeps official head-to-head ranking in both point sort directions", () => {
    expect(names(sortStandingsForDisplay(rows))).toEqual(["B", "A", "C", "Withdrawn"]);
    expect(names(sortStandingsForDisplay(rows, "pts", "asc"))).toEqual(["C", "B", "A", "Withdrawn"]);
  });

  test("can sort a statistic or name then restore official point order", () => {
    const byGoals = sortStandingsForDisplay(rows, "gf", "desc");
    expect(names(byGoals)).toEqual(["A", "B", "C", "Withdrawn"]);
    expect(names(sortStandingsForDisplay(byGoals))).toEqual(["B", "A", "C", "Withdrawn"]);
    expect(names(sortStandingsForDisplay(rows, "team", "asc"))).toEqual(["A", "B", "C", "Withdrawn"]);
    expect(names(rows)).toEqual(["B", "A", "C", "Withdrawn"]);
  });

  test("uses official positions for equal values in other numeric columns", () => {
    expect(names(sortStandingsForDisplay(rows, "ga", "desc")).slice(0, 2)).toEqual(["B", "C"]);
  });
});

describe("LIVE table integration", () => {
  test("preserves an official or historical table unchanged without live fixtures", () => {
    const rows = [row("B", 10, 1, 100, { pos: 1 }), row("A", 10, 100, 1, { pos: 2 })];
    expect(applyLiveFixturesToTable(rows, [match("A", "B", null, null)], "1st", [])).toBe(rows);
    expect(applyLiveFixturesToTable(rows, [match("A", "B", 2, 0, { status: "live", league: "2nd" })], "1st")).toBe(rows);
  });

  test("uses completed head-to-head results when LIVE creates a point tie, without adding completed totals again", () => {
    const rows = [row("A", 40, 100, 20, { played: 15, pos: 1 }),
      row("B", 37, 50, 40, { played: 15, pos: 2 }), row("C", 0, 0, 90, { played: 15, pos: 3 })];
    const fixtures = [match("B", "A", null, null), match("B", "C", 1, 0, { status: "live" })];
    const matches = [match("B", "A", 3, 0)];
    const ranked = applyLiveFixturesToTable(rows, fixtures, "1st", matches);
    expect(names(ranked)).toEqual(["B", "A", "C"]);
    expect(ranked[0]).toMatchObject({ pts: 40, played: 16, gf: 51, ga: 40,
      win: 1, liveResult: "W", liveScore: "1 - 0", liveOpponent: "C", isLivePlaying: true, liveAdjusted: true });
    expect(ranked[1]).toMatchObject({ pts: 40, played: 15, gf: 100, ga: 20, liveAdjusted: false });
    expect(rows[1]).toMatchObject({ pts: 37, played: 15, gf: 50, ga: 40 });
  });

  test("counts the current direct match in a newly tied group's mini-table", () => {
    const ranked = applyLiveFixturesToTable([row("A", 13, 100, 0), row("B", 10, 0, 100)],
      [match("B", "A", 1, 0, { status: "live" })], "1st");
    expect(names(ranked)).toEqual(["B", "A"]);
  });

  test("treats a LIVE fixture without scores as 0:0 while preserving source data", () => {
    const fixture = Object.freeze(match("A", "B", null, null, { status: "live" }));
    const ranked = applyLiveFixturesToTable([row("A"), row("B")], [fixture], "1st", [], { pointsDraw: 2 });
    expect(ranked.map(({ pts, draw, liveScore }) => ({ pts, draw, liveScore })))
      .toEqual([{ pts: 12, draw: 1, liveScore: "0 - 0" }, { pts: 12, draw: 1, liveScore: "0 - 0" }]);
  });
});
