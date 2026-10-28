import { getLeagueRules, getPromotionRowsForLeague, getRelegationRowsForLeague } from "./leagueRules";

const teams = Array.from({ length: 10 }, (_, index) => ({ team: `Team ${index + 1}` }));
const names = (rows) => rows.map(({ team }) => team);

describe("season-specific league places", () => {
  test.each([2026, "2026"])("uses one relegation and three promotions only for season %s", (year) => {
    expect(names(getRelegationRowsForLeague(teams, "1st", year))).toEqual(["Team 10"]);
    expect(names(getPromotionRowsForLeague(teams, "3rd", year))).toEqual(["Team 1", "Team 2", "Team 3"]);
    expect(getPromotionRowsForLeague(teams, "1st", year)).toEqual([]);
    expect(getRelegationRowsForLeague(teams, "3rd", year)).toEqual([]);
  });

  test.each([2024, 2025, "2025", 2027, undefined, ""])("preserves the default rules outside the 2026 exception: %s", (year) => {
    expect(names(getRelegationRowsForLeague(teams, "1st", year))).toEqual(["Team 9", "Team 10"]);
    expect(names(getPromotionRowsForLeague(teams, "3rd", year))).toEqual(["Team 1", "Team 2"]);
  });

  test.each([2025, 2026, 2027])("leaves second-league rules unchanged in %i", (year) => {
    expect(names(getPromotionRowsForLeague(teams, "2nd", year))).toEqual(["Team 1", "Team 2"]);
    expect(names(getRelegationRowsForLeague(teams, "2nd", year))).toEqual(["Team 9", "Team 10"]);
  });

  test("selects the last active team rather than a withdrawn club and does not alter the table", () => {
    const rows = teams.map((team, index) => ({ ...team, withdrawn: index === 9 }));
    expect(names(getRelegationRowsForLeague(rows, "1st", 2026))).toEqual(["Team 9"]);
    expect(names(getRelegationRowsForLeague(rows, "1st", 2025))).toEqual(["Team 8", "Team 9"]);
    expect(rows).toHaveLength(10);
    expect(rows[9]).toEqual({ team: "Team 10", withdrawn: true });
  });

  test("skips withdrawn teams when selecting promoted clubs", () => {
    const rows = teams.map((team, index) => ({ ...team, withdrawn: index === 0 }));
    expect(names(getPromotionRowsForLeague(rows, "3rd", 2026))).toEqual(["Team 2", "Team 3", "Team 4"]);
  });

  test("does not designate places in an unknown league or an empty/withdrawn table", () => {
    expect(getLeagueRules("unknown", 2026)).toEqual({ promotionPlaces: 0, relegationPlaces: 0 });
    expect(getRelegationRowsForLeague(teams, "unknown", 2026)).toEqual([]);
    expect(getPromotionRowsForLeague([], "3rd", 2026)).toEqual([]);
    expect(getRelegationRowsForLeague([{ team: "Withdrawn", withdrawn: true }], "1st", 2026)).toEqual([]);
  });
});
