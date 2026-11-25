import tournamentArchives from './tournamentArchives.json';

export const tournamentCatalog = [
  { id: "halinow-2026", slug: "halinow-2026", name: "Turniej halowy MLPN", date: "2026-12-20", location: "Halinów", status: "upcoming", isDemo: false,
    description: "Gramy 20 grudnia w Halinowie. Uczestników, format, dokładne miejsce i godziny opublikujemy po potwierdzeniu.",
    rules: {}, groups: [], teams: [], matches: [], rulesConfirmed: false },
  ...tournamentArchives,
];
