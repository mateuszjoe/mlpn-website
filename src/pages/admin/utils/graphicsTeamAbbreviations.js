// Approved graphic labels for the currently playing teams. Keep full team names
// in the database and administration forms; these labels are for graphics only.
export const GRAPHIC_TEAM_ABBREVIATIONS = Object.freeze({
  "Alchemia Futbolu": "ALC",
  "AL-Komat": "ALK",
  "Al Mar Wołomin": "ALM",
  "Chaos Team": "CHA",
  Detox: "DTX",
  "ES Chobot Meat": "ECM",
  "Elo Melo": "ELM",
  Faludża: "FAL",
  Fanatycy: "FAN",
  "FC Faworyt": "FAW",
  Gosuansa: "GOS",
  "Huragan Poręby Nowe": "HPN",
  "Joga Finito": "JOG",
  "FC KSS": "KSS",
  Legioholicy: "LEG",
  Lider: "LID",
  PJM: "PJM",
  "Rayo Vallerano": "RAY",
  Rebelianci: "REB",
  "FC Restart": "RES",
  "RKS Pendrachy II": "RK2",
  "RKS Pendrachy": "RKS",
  "RMB Bulls": "RMB",
  "Sami Swoi FC": "SAM",
  "SC Halinów": "SCH",
  "FC Ślimak Halinów": "SLI",
  Starszaki: "STA",
  "STM FC": "STM",
  "Sportowe Zakapiory": "SZA",
  "Tidy Team": "TID",
  "Tiger Wołomin": "TIG",
  "TPS Azbest Wołomin": "TPS",
  "1 Warszawska Brygada Pancerna": "WBP",
  "FC Zieloni": "ZIE",
});

function normalizeLabel(value) {
  return (typeof value === "string" ? value : "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[łŁ]/g, "L")
    .toUpperCase();
}

const approvedByNormalizedName = new Map(
  Object.entries(GRAPHIC_TEAM_ABBREVIATIONS).map(([name, abbreviation]) => [
    normalizeLabel(name).replace(/[^A-Z0-9]/g, ""),
    abbreviation,
  ])
);

export function getGraphicTeamAbbreviation(teamName, fallbackAbbreviation = "") {
  const normalizedName = normalizeLabel(teamName);
  const approved = approvedByNormalizedName.get(normalizedName.replace(/[^A-Z0-9]/g, ""));
  if (approved) return approved;

  const fallback = normalizeLabel(fallbackAbbreviation).replace(/[^A-Z0-9]/g, "").slice(0, 3);
  if (fallback) return fallback;

  const words = normalizedName.match(/[A-Z0-9]+/g) || [];
  if (words.length > 1) return words.map((word) => word[0]).join("").slice(0, 3);
  return words[0]?.slice(0, 3) || "???";
}
