import teamRecords from "./mlpnBookTeamRecords.json";
import playerRecords from "./mlpnBookPlayerRecords.json";
import allTimeMatches from "./mlpnBookAllTimeMatches.json";
import allTimeTeams from "./mlpnBookAllTimeTeams.json";
import allTimePlayers from "./mlpnBookAllTimePlayers.json";
import { champions, medals, historyRecords, stories, seasons } from "./mlpnBookHistory";

export const mlpnBookData = {
  asOf: "2026-11-21",
  records: [
    ...allTimeMatches.records.filter(record => record.group === "matches").map(record => ({ ...record, period: "history" })),
    ...allTimePlayers.records.map(record => ({ ...record, period: "history" })),
    ...allTimeTeams.records.map(record => ({ ...record, period: "history" })),
    ...allTimeMatches.records.filter(record => record.group !== "matches").map(record => ({ ...record, period: "history" })),
    ...historyRecords.map(record => ({ ...record, period: "history" })),
    ...playerRecords.records.filter(record => record.id === "player-career-goals").map(record => ({ ...record, period: "history" })),
    ...playerRecords.records.filter(record => record.season === 2026).map(record => ({ ...record, period: "2026" })),
    ...teamRecords.records.filter(record => record.id !== "team-goals-audited-archive").map(record => ({ ...record, period: "2026" })),
  ],
  clubs: allTimeTeams.clubs,
  coverage: allTimeTeams.coverage,
  champions, medals, stories, seasons,
  methodology: [
    { title: "Cała dostępna historia", text: "Domyślnie porównujemy lata 2003–2026, korzystając z 41 oryginalnych plików ligi, końcowych tabel starej strony z lat 2018–2025 oraz protokołów 2026. Sezon 2026 można przeglądać osobno. Podium I ligi obejmuje wszystkie 24 edycje." },
    { title: "Boisko i tabela", text: "Wyniki na boisku oraz punkty i bramki z oficjalnych tabel mogą się różnić przez walkowery lub wycofanie drużyn. Te zestawienia mają osobne opisy; szczegóły znajdziesz po rozwinięciu rekordu." },
    { title: "Sezon zawodnika", text: "Historia profilu w obecnej bazie bywa rozdzielona pomiędzy kilka wpisów i nie jest kompletnym rejestrem kariery. Rekord 24 edycji Kamila Szlejzera opiera się na źródłowym wpisie bramkowym z każdego roku, a nie na samym zgłoszeniu do kadry. Inni zawodnicy mogą mieć taki sam staż." },
    { title: "Serie i puste miejsca", text: "Historyczne serie porównujemy pomiędzy sezonami, ale każdy wynik dotyczy serii w ramach jednego sezonu. Wliczamy rozstrzygnięcia administracyjne. Puste miejsca w terminarzu nie są remisami 0:0; brak dat lub wyników wyklucza daną serię z tego porównania. Serie przechodzące pomiędzy sezonami wymagają osobnego audytu." },
    { title: "Archiwum w budowie", text: "Część historycznych protokołów jest niepełna, a wpisy strzelców bywają powielone. Dopóki ich nie zweryfikujemy, nie przedstawiamy sumy goli zawodnika z całej kariery jako pewnego rekordu." },
    { title: "Stan na 21 listopada 2026", text: "To podgląd Księgi z zapisanym zestawieniem danych. Rekordy nie aktualizują się jeszcze automatycznie. Każdy ranking zachowuje własne źródło i definicję." },
  ],
};
