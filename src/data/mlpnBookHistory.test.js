import { champions, medals, historyRecords } from "./mlpnBookHistory";

test("preserves all 24 distinct podiums and 72 medals", () => {
  expect(champions.map(row => row.year)).toEqual(Array.from({ length: 24 }, (_, index) => 2026 - index));
  champions.forEach(({ gold, silver, bronze }) => expect(new Set([gold, silver, bronze]).size).toBe(3));
  expect(medals.reduce((total, row) => total + row.total, 0)).toBe(72);
  expect(medals.reduce((total, row) => total + row.gold, 0)).toBe(24);
});

test("retains the restored Dziadki history instead of dropping inactive clubs", () => {
  expect(medals.find(row => row.team === "Dziadki")).toMatchObject({
    gold: 4, silver: 2, bronze: 1, total: 7, years: [2014, 2009, 2006, 2005],
  });
});

test("counts consecutive titles separately from consecutive podium finishes", () => {
  expect(historyRecords.find(row => row.id === "history-consecutive-titles")).toMatchObject({
    holder: "Starszaki", value: 5, detail: "2021–2025",
  });
  expect(historyRecords.find(row => row.id === "history-consecutive-medals")).toMatchObject({
    holder: "Starszaki", value: 8, detail: "2019–2026",
  });
  expect(historyRecords.find(row => row.id === "history-medals")).toMatchObject({ holder: "Starszaki", value: 11 });
});

test("keeps tied results on equal ranks, including the fifth-place boundary", () => {
  const ranking = historyRecords.find(row => row.id === "history-titles").ranking;
  expect(ranking.filter(row => row.rank === 4).map(row => row.holder).sort()).toEqual(["FC Faworyt", "Fanatycy"]);
  expect(ranking.map(row => row.rank)).toEqual([1, 2, 3, 4, 4]);
});
