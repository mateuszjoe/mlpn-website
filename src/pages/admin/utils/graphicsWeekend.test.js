import {
  buildWeekendOptions,
  dedupeMatchesById,
  filterWeekendMatches,
  formatWeekendRange,
  getWeekendEndExclusive,
  getWeekendStart,
  isDateInWeekend,
  sortMatchesForGraphic,
} from "./graphicsWeekend";

const isCompletedStatus = (status) =>
  ["completed", "walkover_home", "walkover_away"].includes(status);

describe("graphics weekend date range", () => {
  test("maps only Friday through Monday to the same Friday", () => {
    expect(getWeekendStart("2026-10-22")).toBe(""); // Thursday
    expect(getWeekendStart("2026-10-23")).toBe("2026-10-23"); // Friday
    expect(getWeekendStart("2026-10-26")).toBe("2026-10-23"); // Monday
    expect(getWeekendStart("2026-10-27")).toBe(""); // Tuesday
  });

  test("uses UTC calendar arithmetic across the DST weekend", () => {
    expect(getWeekendEndExclusive("2026-10-23")).toBe("2026-10-27");
    expect(isDateInWeekend("2026-10-23", "2026-10-23")).toBe(true);
    expect(isDateInWeekend("2026-10-26", "2026-10-23")).toBe(true);
    expect(isDateInWeekend("2026-10-27", "2026-10-23")).toBe(false);
    expect(formatWeekendRange("2026-10-23")).toBe("23–26.10.2026");
  });

  test("formats compact ranges across month and year boundaries", () => {
    expect(formatWeekendRange("2026-10-30")).toBe("30.10–02.11.2026");
    expect(formatWeekendRange("2027-12-31")).toBe("31.12.2027–03.01.2028");
    expect(formatWeekendRange("2027-12-31", { includeYear: false })).toBe("31.12–03.01");
  });

  test("rejects malformed and impossible DATE values", () => {
    expect(getWeekendStart("2026-02-30")).toBe("");
    expect(getWeekendStart("26-10-23")).toBe("");
    expect(getWeekendEndExclusive("2026-10-24")).toBe("");
    expect(isDateInWeekend("2026-10-23T18:00:00Z", "2026-10-23")).toBe(false);
  });
});

describe("graphics weekend matches", () => {
  const matches = [
    { id: "round-12", round: 12, match_date: "2026-10-23", status: "completed" },
    { id: "round-7", round: 7, match_date: "2026-10-24", status: "walkover_home" },
    { id: "round-22", round: 22, match_date: "2026-10-25", status: "walkover_away" },
    { id: "round-13", round: 13, match_date: "2026-10-26", status: "completed" },
    { id: "scheduled", round: 12, match_date: "2026-10-25", status: "scheduled" },
    { id: "live", round: 12, match_date: "2026-10-26", status: "live" },
    { id: "thursday", round: 4, match_date: "2026-10-22", status: "completed" },
    { id: "tuesday", round: 4, match_date: "2026-10-27", status: "completed" },
    { id: "next-weekend", round: 14, match_date: "2026-10-30", status: "completed" },
    { id: "invalid-date", round: 1, match_date: "2026-02-30", status: "completed" },
  ];

  test("removes repeated view rows only when they have the same match id", () => {
    const duplicate = {
      id: "same-match",
      match_date: "2026-10-23",
      status: "completed",
      home_team_id: "home",
      away_team_id: "away",
      home_goals: 1,
      away_goals: 1,
    };
    const sameResultButDifferentMatch = { ...duplicate, id: "different-match" };
    const rowsWithoutIds = [{ match_date: "2026-10-23" }, { match_date: "2026-10-23" }];

    expect(
      dedupeMatchesById([
        duplicate,
        { ...duplicate, mvp_team_id: "other-team" },
        sameResultButDifferentMatch,
        ...rowsWithoutIds,
      ])
    ).toEqual([duplicate, sameResultButDifferentMatch, ...rowsWithoutIds]);
  });

  test("filters completed results from different rounds within Friday-Monday", () => {
    expect(filterWeekendMatches(matches, "2026-10-23", isCompletedStatus).map((match) => match.id)).toEqual([
      "round-12",
      "round-7",
      "round-22",
      "round-13",
    ]);
  });

  test("builds descending completed-result options with separate counts", () => {
    expect(buildWeekendOptions(matches, isCompletedStatus)).toEqual([
      { value: "2026-10-30", label: "30.10–02.11.2026", count: 1 },
      { value: "2026-10-23", label: "23–26.10.2026", count: 4 },
    ]);
  });

  test("sorts by league, date and time with missing calendar values last", () => {
    const rows = [
      { id: "undated", league_code: "1st", match_date: null, match_time: null },
      { id: "second-league", league_code: "2nd", match_date: "2026-10-23", match_time: "18:00" },
      { id: "later", league_code: "1st", match_date: "2026-10-24", match_time: "12:00" },
      { id: "earlier-time", league_code: "1st", match_date: "2026-10-23", match_time: "17:00" },
      { id: "later-time", league_code: "1st", match_date: "2026-10-23", match_time: "20:00" },
    ];

    expect(sortMatchesForGraphic(rows).map((match) => match.id)).toEqual([
      "earlier-time",
      "later-time",
      "later",
      "undated",
      "second-league",
    ]);
  });
});
