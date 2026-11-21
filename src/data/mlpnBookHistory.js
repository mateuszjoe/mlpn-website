// Podium checked against the original league archive and the 2026 gala audit.
// Source: prezentacja-2026/materialy-robocze/wszech-czasow/podium-I-ligi-2003-2026.csv
export const champions = [
  [2003, "FC Faworyt", "Zabraniec", "Pogoń Okuniew"],
  [2004, "Pętla Team", "Michałów", "FIFA Squad"],
  [2005, "Dziadki", "Pętla Team", "FC Faworyt"],
  [2006, "Dziadki", "Pętla Team", "Legioholicy"],
  [2007, "FC Faworyt", "Dziadki", "Colgate"],
  [2008, "Legioholicy", "Dziadki", "FC Faworyt"],
  [2009, "Dziadki", "Fanatycy", "Joga Finito"],
  [2010, "Legioholicy", "Colgate", "San Marino"],
  [2011, "Korsarze", "Fanatycy", "Wenus"],
  [2012, "Legioholicy", "Starszaki", "Dziadki"],
  [2013, "Fanatycy", "Elo Melo", "Legioholicy"],
  [2014, "Dziadki", "Fanatycy", "Gosuansa"],
  [2015, "Joga Finito", "Fanatycy", "Starszaki"],
  [2016, "Gold Dent", "Elo Melo", "Fanatycy"],
  [2017, "Starszaki", "Gold Dent", "Elo Melo"],
  [2018, "Legioholicy", "Gold Dent", "FC Zieloni"],
  [2019, "Legioholicy", "Starszaki", "Gold Dent"],
  [2020, "Fanatycy", "Starszaki", "Elo Melo"],
  [2021, "Starszaki", "Fanatycy", "Gold Dent"],
  [2022, "Starszaki", "PJM", "Oldrembham Forest"],
  [2023, "Starszaki", "Rebelianci", "Fanatycy"],
  [2024, "Starszaki", "Al Mar Wołomin", "Oldrembham Forest"],
  [2025, "Starszaki", "Rebelianci", "Al Mar Wołomin"],
  [2026, "Al Mar Wołomin", "Rebelianci", "Starszaki"],
].map(([year, gold, silver, bronze]) => ({ year, gold, silver, bronze })).reverse();

const medalMap = new Map();
champions.forEach(({ year, ...podium }) => {
  Object.entries(podium).forEach(([medal, team]) => {
    if (!medalMap.has(team)) {
      medalMap.set(team, { team, gold: 0, silver: 0, bronze: 0, total: 0, years: [], medalYears: [] });
    }
    const row = medalMap.get(team);
    row[medal] += 1;
    row.total += 1;
    row.medalYears.push({ year, medal });
    if (medal === "gold") row.years.push(year);
  });
});
export const medals = [...medalMap.values()].sort((a, b) =>
  b.gold - a.gold || b.silver - a.silver || b.bronze - a.bronze || a.team.localeCompare(b.team, "pl")
);

const sourceLabel = "Podium I ligi 2003–2026 · archiwum MLPN i audyt prezentacji gali 2026";
function rankRows(rows) {
  let rank = 0;
  return rows.map((row, index) => {
    if (index === 0 || row.value !== rows[index - 1].value) rank = index + 1;
    return { ...row, rank };
  }).filter(row => row.rank <= 5);
}
function podiumStreaks(goldOnly) {
  return medals.map(({ team }) => {
    let current = 0;
    let best = 0;
    let start;
    let bestStart;
    let bestEnd;
    let previousYear;
    [...champions].reverse().forEach(({ year, gold, silver, bronze }) => {
      const present = goldOnly ? gold === team : [gold, silver, bronze].includes(team);
      if (present) {
        current = previousYear === year - 1 ? current + 1 : 1;
        if (current === 1) start = year;
        if (current > best) { best = current; bestStart = start; bestEnd = year; }
      } else current = 0;
      previousYear = year;
    });
    return { holder: team, value: best, detail: bestStart === bestEnd ? `${bestStart}` : `${bestStart}–${bestEnd}` };
  }).filter(row => row.value > 0).sort((a, b) => b.value - a.value || a.holder.localeCompare(b.holder, "pl"));
}
const historyDefinitions = [
  {
    id: "history-titles", label: "Najwięcej mistrzostw I ligi", unit: "tytułów",
    rows: medals.filter(row => row.gold).map(row => ({ holder: row.team, value: row.gold, detail: [...row.years].sort().join(", ") })).sort((a, b) => b.value - a.value),
    sourceNote: "Liczymy wyłącznie mistrzostwa najwyższej klasy rozgrywkowej. Tytuły II i III ligi nie są dodawane do tego rankingu.",
  },
  {
    id: "history-medals", label: "Najwięcej medali I ligi", unit: "medali",
    rows: [...medals].sort((a, b) => b.total - a.total).map(row => ({ holder: row.team, value: row.total, detail: `${row.gold} złotych · ${row.silver} srebrnych · ${row.bronze} brązowych` })),
    sourceNote: "Zsumowane miejsca 1–3 w każdej z 24 edycji I ligi.",
  },
  {
    id: "history-consecutive-titles", label: "Najdłuższa seria mistrzostw", unit: "sezonów",
    rows: podiumStreaks(true), sourceNote: "Kolejne sezony zakończone mistrzostwem I ligi. Brak tytułu w danym sezonie kończy serię.",
  },
  {
    id: "history-consecutive-medals", label: "Najdłuższa seria na podium", unit: "sezonów",
    rows: podiumStreaks(false), sourceNote: "Kolejne sezony zakończone na miejscach 1–3 w I lidze.",
  },
];
export const historyRecords = historyDefinitions.map(({ rows, ...definition }) => ({
  ...definition,
  group: "teams", value: rows[0].value, holder: rows[0].holder, detail: rows[0].detail,
  scope: "I liga · 2003–2026", status: "archive", sourceLabel,
  ranking: rankRows(rows),
}));

export const stories = [
  {
    id: "dziadki", team: "Dziadki", kicker: "Cztery razy na szczycie", title: "Dziadki. Mistrzowie, których warto pamiętać",
    years: [2005, 2006, 2009, 2014],
    text: "Cztery mistrzostwa I ligi: 2005, 2006, 2009 i 2014. Do tego dwa srebra i brąz. Dziadki zajmują trzecie miejsce w klasyfikacji tytułów — ich historia jest częścią historii ligi, nawet jeśli drużyny nie ma już w obecnym terminarzu.",
    sourceLabel,
  },
  {
    id: "pkkl", team: "PKKL", kicker: "Od pierwszej edycji", title: "PKKL też ma swoje miejsce w Księdze",
    years: [2003, 2020],
    text: "Historia PKKL nie kończy się na starych plikach z 2017 roku. Tabele dawnej strony potwierdzają występy także w latach 2018–2020: razem 18 edycji i 923 gole w bilansach ligowych. PKKL Pierożek z 2021 roku pozostaje osobnym wpisem — jego dorobku nie dopisujemy automatycznie bez potwierdzenia ciągłości.",
    sourceLabel: "Oryginalne pliki ligi 2003–2017 i końcowe tabele WordPress 2018–2020",
  },
  {
    id: "starszaki", team: "Starszaki", kicker: "Pięć tytułów z rzędu", title: "Lata 2021–2025 należały do Starszaków",
    years: [2021, 2022, 2023, 2024, 2025],
    text: "Pięć kolejnych mistrzostw, sześć w całej historii i osiem sezonów z rzędu na podium w latach 2019–2026. To trzy różne rekordy jednej drużyny — każdy można prześledzić sezon po sezonie w zestawieniu medalistów.",
    sourceLabel,
  },
  {
    id: "fanatycy", team: "Fanatycy", kicker: "Jedna historia, różne nazwy", title: "Od Zakładu Mięsnego Miśko do Fanatyków",
    years: [2006, 2007, 2008, 2009],
    text: "W archiwum ten zespół znajdziemy jako Zakład Mięsny Miśko w latach 2006–2007, MBM Kebab w 2008 roku, a od 2009 jako Fanatycy. Potwierdzone zmiany nazwy łączymy w jednej historii. Podobnie brzmiące nazwy innych ekip nie wystarczają do takiego połączenia.",
    sourceLabel: "Oryginalne archiwum i komunikaty MLPN · audyt ciągłości drużyn do gali 2026",
  },
];

export const seasons = champions.map(({ year, gold }) => ({
  year,
  description: year === 2026 ? "Mistrzowie, wyróżnienia indywidualne i najlepsze ósemki trzech lig." : `Mistrz I ligi: ${gold}. Podium potwierdzone w archiwum.`,
  url: `/1-liga${year === 2026 ? "" : "/tabela"}?sezon=${year}`,
}));
