import {
  buildWeekendOptions,
  dedupeMatchesById,
  filterWeekendMatches,
  formatWeekendRange,
  getDefaultTyperWeekend,
  getTyperWeekendMatches,
  getWeekendFixtures,
  getWeekendMatchPage,
  getWeekendEndExclusive,
  getWeekendStart,
  isDateInWeekend,
  isTyperMatchStatus,
  normalizeWeekendStart,
  sortMatchesChronologically,
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

describe("weekend typer", () => {
  const matches = [
    { id: "friday", round: 2, league_code: "3rd", match_date: "2026-09-04", status: "scheduled" },
    { id: "saturday", round: 8, league_code: "1st", match_date: "2026-09-05", status: "live" },
    { id: "sunday", round: 12, league_code: "2nd", match_date: "2026-09-06", status: "completed" },
    { id: "monday", round: 19, match_date: "2026-09-07", status: "walkover_home" },
    { id: "walkover-away", round: 19, match_date: "2026-09-07", status: "walkover_away" },
    { id: "same-round-next-weekend", round: 2, match_date: "2026-09-11", status: "scheduled" },
    { id: "thursday", round: 2, match_date: "2026-09-03", status: "scheduled" },
    { id: "tuesday", round: 2, match_date: "2026-09-08", status: "scheduled" },
    { id: "cancelled", match_date: "2026-09-04", status: "cancelled" },
    { id: "postponed", match_date: "2026-09-05", status: "postponed" },
    { id: "unplayed", match_date: "2026-09-06", status: "unplayed" },
    { id: "undated", match_date: null, status: "scheduled" },
    { id: "invalid-date", match_date: "2026-02-30", status: "scheduled" },
  ];

  test("selects Friday-Monday across rounds and leagues, including upcoming matches", () => {
    expect(getTyperWeekendMatches(matches, "2026-09-04").map((match) => match.id)).toEqual([
      "friday", "saturday", "sunday", "monday", "walkover-away",
    ]);
    expect(getWeekendFixtures(matches, "2026-09-04").map((match) => match.id)).toEqual([
      "friday", "saturday", "sunday", "monday", "walkover-away",
    ]);
  });

  test("counts upcoming weekends using the same eligibility rules and deduplicated matches", () => {
    const uniqueMatches = dedupeMatchesById([...matches, { ...matches[0] }]);
    const options = buildWeekendOptions(uniqueMatches, isTyperMatchStatus);
    expect(options.map(({ value, count }) => ({ value, count }))).toEqual([
      { value: "2026-09-11", count: 1 },
      { value: "2026-09-04", count: 5 },
    ]);
    options.forEach((option) => {
      expect(filterWeekendMatches(uniqueMatches, option.value, isTyperMatchStatus)).toHaveLength(option.count);
    });
    // Results still exclude scheduled and live matches by default.
    expect(buildWeekendOptions(uniqueMatches).map((option) => option.count)).toEqual([3]);
  });

  test.each(["2026-09-04", "2026-09-05", "2026-09-06", "2026-09-07"])(
    "defaults to the current weekend on %s regardless of option order",
    (today) => {
      const options = ["2026-09-18", "2026-08-28", "2026-09-11", "2026-09-04"].map((value) => ({ value }));
      expect(getDefaultTyperWeekend(options, today)).toBe("2026-09-04");
    }
  );

  test("defaults to the nearest upcoming weekend or the latest archive weekend", () => {
    const options = ["2026-09-18", "2026-08-28", "2026-09-11"].map((value) => ({ value }));
    expect(getDefaultTyperWeekend(options, "2026-09-06")).toBe("2026-09-11");
    expect(getDefaultTyperWeekend(options, "2026-09-08")).toBe("2026-09-11");
    expect(getDefaultTyperWeekend(options, "2026-09-10")).toBe("2026-09-11");
    expect(getDefaultTyperWeekend(options, "2026-10-01")).toBe("2026-09-18");
    expect(getDefaultTyperWeekend([], "2026-09-06")).toBe("");
    expect(getDefaultTyperWeekend([{ value: "2026-02-30" }], "2026-09-06")).toBe("");
  });

  test("uses the Warsaw date when Monday UTC is already Tuesday in Poland", () => {
    jest.useFakeTimers().setSystemTime(new Date("2026-09-07T22:30:00Z"));
    try {
      expect(getDefaultTyperWeekend([
        { value: "2026-09-04" }, { value: "2026-09-11" },
      ])).toBe("2026-09-11");
    } finally {
      jest.useRealTimers();
    }
  });

  test("orders matches by date, time and id rather than league or round, without mutating input", () => {
    const rows = [
      { id: "saturday", league_code: "1st", round: 1, match_date: "2026-09-05", match_time: "10:00" },
      { id: "late-friday", league_code: "2nd", round: 2, match_date: "2026-09-04", match_time: "20:00" },
      { id: "b-early-friday", league_code: "3rd", round: 3, match_date: "2026-09-04", match_time: "18:00" },
      { id: "a-early-friday", league_code: "3rd", round: 4, match_date: "2026-09-04", match_time: "18:00" },
      { id: "unknown-time", match_date: "2026-09-04", match_time: null },
    ];
    const original = [...rows];
    expect(sortMatchesChronologically(rows).map((match) => match.id)).toEqual([
      "a-early-friday", "b-early-friday", "late-friday", "unknown-time", "saturday",
    ]);
    expect(rows).toEqual(original);
  });
});

describe("weekend graphic pagination and saved dates", () => {
  const chronologicalMatches = Array.from({ length: 29 }, (_, index) => ({
    id: `match-${index}`,
    match_date: `2026-09-0${4 + Math.floor(index / 8)}`,
    match_time: `${10 + (index % 8)}:00`,
    league_code: ["3rd", "2nd", "1st"][index % 3],
    round: 1 + (index % 7),
    status: "scheduled",
  }));

  test("sorts the full mixed-round weekend before splitting it into 14/14/1 matches", () => {
    const rows = [...chronologicalMatches].reverse();
    const original = [...rows];
    const selected = getWeekendFixtures(dedupeMatchesById([...rows, rows[5]]), "2026-09-04");
    const pages = [1, 2, 3].map((page) => getWeekendMatchPage(selected, page, { chronological: true }));
    expect(pages.map((page) => page.matches.length)).toEqual([14, 14, 1]);
    expect(pages.map(({ page, pageCount }) => [page, pageCount])).toEqual([[1, 3], [2, 3], [3, 3]]);
    expect(pages.flatMap((page) => page.matches)).toEqual(chronologicalMatches);
    expect(new Set(pages.flatMap((page) => page.matches.map((match) => match.id))).size).toBe(29);
    expect(rows).toEqual(original);
  });

  test.each([0, -1, "invalid", NaN, null, undefined])("clamps invalid page %s to page one", (page) => {
    expect(getWeekendMatchPage(chronologicalMatches, page).page).toBe(1);
  });

  test("clamps a saved page after the match list shrinks and supports empty weekends", () => {
    const smallerList = chronologicalMatches.slice(0, 2);
    expect(getWeekendMatchPage(smallerList, 3).page).toBe(1);
    expect(getWeekendMatchPage(smallerList, 3).matches).toHaveLength(2);
    expect(getWeekendMatchPage([], 3)).toEqual({ page: 1, pageCount: 1, matches: [] });
  });

  test("preserves the existing league/date order for results", () => {
    expect(getWeekendMatchPage(chronologicalMatches).matches).toEqual(sortMatchesForGraphic(chronologicalMatches).slice(0, 14));
  });

  test("restores only real Friday dates from saved drafts", () => {
    expect(normalizeWeekendStart("2026-09-04")).toBe("2026-09-04");
    expect(normalizeWeekendStart("2027-12-31")).toBe("2027-12-31");
    ["2026-09-05", "2026-02-30", "not-a-date", "", null, undefined, 42, {}].forEach((value) => {
      expect(normalizeWeekendStart(value)).toBe("");
    });
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
