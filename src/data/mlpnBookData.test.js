import { mlpnBookData } from "./mlpnBookData";

test("every record has a unique ID, explicit scope, and a calculation source", () => {
  const { records } = mlpnBookData;
  expect(new Set(records.map(record => record.id)).size).toBe(records.length);
  records.forEach(record => {
    expect(record.scope.length).toBeGreaterThan(5);
    expect(record.sourceLabel.length).toBeGreaterThan(5);
    expect(record.sourceNote.length).toBeGreaterThan(20);
    expect(["players", "teams", "matches", "streaks"]).toContain(record.group);
    if (typeof record.value !== "number") expect(record.status).toBe("partial");
  });
});

test("rankings preserve numeric order and equal results share their rank", () => {
  mlpnBookData.records.forEach(record => {
    const ranking = record.ranking || [];
    ranking.forEach((row, index) => {
      if (index === 0) { expect(row.rank).toBe(1); return; }
      const previous = ranking[index - 1];
      expect(Number(row.value)).toBeLessThanOrEqual(Number(previous.value));
      expect(row.rank).toBe(row.value === previous.value ? previous.rank : index + 1);
    });
  });
});

test("unverified career goals stay visibly incomplete instead of becoming a zero", () => {
  expect(mlpnBookData.records.find(record => record.id === "player-career-goals")).toMatchObject({ value: "—", status: "partial", ranking: [] });
});

test("restores the whole archive instead of presenting the 2026 subset as history", () => {
  expect(mlpnBookData.records.find(record => record.id === "player-registered-seasons")).toBeUndefined();
  expect(mlpnBookData.records.find(record => record.id === "player-all-editions-2003-2026")).toMatchObject({ value:24, holder:"Kamil Szlejzer", period:"history" });
  expect(mlpnBookData.records.find(record => record.id === "match-winning-margin-2026")).toMatchObject({ value:15, period:"2026" });
  expect(mlpnBookData.records.find(record => record.id === "archive-match-margin")).toMatchObject({ value:26, period:"history" });
  expect(mlpnBookData.coverage.leagueSeasons).toBe(68);
  expect(mlpnBookData.clubs.find(club => club.team === "Dziadki")).toMatchObject({ firstYear:2004, lastYear:2015, seasons:12 });
});
