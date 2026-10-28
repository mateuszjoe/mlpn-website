import { compareFixturesChronologically, compareMatchesNewestFirst } from "./fixtureChronology";

describe("shared public fixture chronology", () => {
  test("chooses the earliest kick-off on the same day even when fixtures arrive in reverse order", () => {
    const fixtures = [
      { id: "evening", date: "2026-10-31", time: "18:00", round: 10 },
      { id: "afternoon", date: "2026-10-31", time: "14:30", round: 12 },
      { id: "noon", date: "2026-10-31", time: "12:00", round: 12 },
    ];
    expect([...fixtures].sort(compareFixturesChronologically).map(({ id }) => id))
      .toEqual(["noon", "afternoon", "evening"]);
  });

  test("prioritizes actual dates over round numbers and puts undated matches last", () => {
    const fixtures = [
      { id: "undated", round: 1 },
      { id: "postponed-round", date: "2026-11-02", time: "10:00", round: 4 },
      { id: "earlier-date", date: "2026-10-31", time: "18:00", round: 12 },
    ];
    expect(fixtures.sort(compareFixturesChronologically).map(({ id }) => id))
      .toEqual(["earlier-date", "postponed-round", "undated"]);
  });

  test("uses stored schedule dates and times when public schedule fields are hidden", () => {
    const fixtures = [
      { id: "unknown-time", date: "2026-10-31", round: 1 },
      { id: "hidden", scheduleDate: "2026-10-31", scheduleTime: "11:00", scheduleHidden: true },
      { id: "visible", date: "2026-10-31", time: "10:00" },
    ];
    expect(fixtures.sort(compareFixturesChronologically).map(({ id }) => id))
      .toEqual(["visible", "hidden", "unknown-time"]);
  });

  test("retains deterministic ordering for matches with identical dates and teams", () => {
    const fixtures = ["b", "a"].map((id) => ({ id, date: "2026-10-31", time: "10:00", home: "A", away: "B" }));
    expect(fixtures.sort(compareFixturesChronologically).map(({ id }) => id)).toEqual(["a", "b"]);
  });

  test("keeps recent-result ordering newest first with missing dates last", () => {
    const fixtures = [
      { id: "undated", round: 20 },
      { id: "early", date: "2026-10-31", time: "10:00" },
      { id: "late", date: "2026-10-31", time: "12:00" },
    ];
    expect(fixtures.sort(compareMatchesNewestFirst).map(({ id }) => id)).toEqual(["late", "early", "undated"]);
  });
});
