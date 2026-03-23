import React, { useEffect, useMemo, useState, useRef } from "react";
import {
  Sun,
  Moon,
  Trophy,
  Calendar,
  Users,
  BarChart3,
  FileText,
  Target,
  Vote,
  UserPlus,
  ArrowLeft,
  ChevronRight,
  ChevronLeft,
  ChevronsLeft,
  ChevronsRight,
  Phone,
  Mail,
  Video,
  Images,
  Menu,
  X,
  Settings,
  LogIn,
  LogOut,
} from "lucide-react";
import { useAuth } from "./contexts/AuthContext";
import AdminPanel from "./pages/admin/AdminPanel";
import { useMLPNData } from "./hooks/useMLPNData";
import {
  fetchMatchDetails,
  fetchMatchGallery,
  fetchTeamProfile,
  fetchTeamRoster,
  fetchTeamHistory,
  fetchPlayerProfile,
  fetchTeamsDirectory,
  fetchPlayersDirectory,
} from "./services/supabaseQueries";

/* =========================================
   DRUŻYNY (legacy - dane teraz z Supabase)
   ========================================= */
const LEAGUES = [
  {
    id: "1st",
    name: "I Liga",
    teams: [
      "Starszaki",
      "Rebelianci",
      "Al Mar Wołomin",
      "Oldrembham Forest",
      "Elo Melo",
      "Legioholicy",
      "Fanatycy",
      "Sportowe Zakapiory",
      "Tiger Wołomin",
      "Tęcza Pustelnik",
    ],
  },
  {
    id: "2nd",
    name: "II Liga",
    teams: [
      "FC Zieloni",
      "1 Warszawska Brygada Pancerna",
      "Tidy Team",
      "Gosuansa",
      "Lider",
      "Detox",
      "PJM",
      "Joga Finito",
      "SC Halinów",
      "Nankatsu",
    ],
  },
  {
    id: "3rd",
    name: "III Liga",
    teams: [
      "STM FC",
      "Faludża",
      "FC Faworyt",
      "Alchemia Futbolu",
      "Chaos Team",
      "FC KSS",
      "AL-Komat",
      "Hard Impet Team",
      "Huragan",
      "ES Chobot Meat",
    ],
  },
];

// Pula historycznych drużyn MLPN (które grały w różnych latach)
const HISTORICAL_TEAMS = {
  "1st": [
    "Starszaki", "Rebelianci", "Al Mar Wołomin", "Oldrembham Forest", 
    "Elo Melo", "Legioholicy", "Fanatycy", "Sportowe Zakapiory", 
    "Tiger Wołomin", "Tęcza Pustelnik"
  ],
  "2nd": [
    "FC Zieloni", "1 Warszawska Brygada Pancerna", "Tidy Team", "Gosuansa", 
    "Lider", "Detox", "PJM", "Joga Finito", "SC Halinów", "Nankatsu"
  ],
  "3rd": [
    "STM FC", "Faludża", "FC Faworyt", "Alchemia Futbolu", "Chaos Team",
    "FC KSS", "AL-Komat", "Hard Impet Team", "Huragan", "ES Chobot Meat"
  ]
};

// Funkcja generująca skład lig dla danego sezonu
function getLeaguesForSeason(season, baseLeagues) {
  // Dla sezonu 2025 (aktualny) używamy podstawowego składu
  if (season === 2025) {
    return baseLeagues;
  }
  
  // Dla starszych sezonów (2022-2024) - losowe składy z puli 30 drużyn
  const seed = hashString(`season_teams_${season}`);
  const rng = mulberry32(seed);
  
  const leagues = JSON.parse(JSON.stringify(baseLeagues)); // deep copy
  
  leagues.forEach(lg => {
    const pool = HISTORICAL_TEAMS[lg.id] || lg.teams;
    
    // Shuffluj pulę
    const shuffled = [...pool];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(rng() * (i + 1));
      [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }
    
    // Wybierz 10 drużyn
    lg.teams = shuffled.slice(0, 10);
  });
  
  return leagues;
}

/* =========================================
   MAPA HERBÓW (public/)
   ========================================= */
const PU = process.env.PUBLIC_URL || "";
const logoByTeam = {
  // I liga
  Starszaki: `${PU}/starszaki.png`,
  Rebelianci: `${PU}/Rebelianci.png`,
  "Al Mar Wołomin": `${PU}/almar wolomin.png`,
  "Oldrembham Forest": `${PU}/oldrembham forest.png`,
  "Elo Melo": `${PU}/elo melo.png`,
  Legioholicy: `${PU}/legioholicy.png`,
  Fanatycy: `${PU}/fanatycy.png`,
  "Sportowe Zakapiory": `${PU}/Sportowe Zakapiory.png`,
  "Tiger Wołomin": `${PU}/tiger wolomin.png`,
  "Tęcza Pustelnik": `${PU}/tecza pustelnik.png`,

  // II liga
  "FC Zieloni": `${PU}/fc zieloni.png`,
  "1 Warszawska Brygada Pancerna": `${PU}/1 Warszawska Brygada Pancerna.png`,
  "Tidy Team": `${PU}/tidy team.png`,
  Gosuansa: `${PU}/gosuansa.png`,
  Lider: `${PU}/lider.png`,
  Detox: `${PU}/detox.png`,
  PJM: `${PU}/pjm.png`,
  "Joga Finito": `${PU}/joga finito.png`,
  "SC Halinów": `${PU}/sc halinow.png`,
  Nankatsu: `${PU}/nankatsu.png`,

  // III liga
  "STM FC": `${PU}/STM FC.png`,
  Faludża: `${PU}/faludza.png`,
  "FC Faworyt": `${PU}/fc faworyt.png`,
  "Alchemia Futbolu": `${PU}/alchemia futbolu.png`,
  "Chaos Team": `${PU}/chaos team.png`,
  "FC KSS": `${PU}/fc kss.png`,
  "AL-Komat": `${PU}/Al-Komat.png`,
  "Hard Impet Team": `${PU}/hard impet team.png`,
  Huragan: `${PU}/huragan.png`,
  "ES Chobot Meat": `${PU}/ES CHOBOT MEAT.png`,
};

let activeTeamLogoRegistry = { ...logoByTeam };

function createTeamLogoRegistry({ standings, fixtures, matches }) {
  const map = { ...logoByTeam };

  for (const entry of Object.values(standings?.teamStats || {})) {
    if (entry?.team && entry?.logoUrl) {
      map[entry.team] = entry.logoUrl;
    }
  }

  for (const fixture of fixtures || []) {
    if (fixture?.home && fixture?.homeLogoUrl) {
      map[fixture.home] = fixture.homeLogoUrl;
    }
    if (fixture?.away && fixture?.awayLogoUrl) {
      map[fixture.away] = fixture.awayLogoUrl;
    }
  }

  for (const match of matches || []) {
    if (match?.home && match?.homeLogoUrl) {
      map[match.home] = match.homeLogoUrl;
    }
    if (match?.away && match?.awayLogoUrl) {
      map[match.away] = match.awayLogoUrl;
    }
  }

  return map;
}

const LEAGUE_CONTEXT_TO_SLUG = {
  "1st": "1-liga",
  "2nd": "2-liga",
  "3rd": "3-liga",
};

const LEAGUE_SLUG_TO_CONTEXT = Object.fromEntries(
  Object.entries(LEAGUE_CONTEXT_TO_SLUG).map(([context, slug]) => [slug, context])
);

const HOME_SECTION_TO_SLUG = {
  home: "",
  news: "aktualnosci",
  typer: "typer",
  polls: "ankiety",
  free: "wolni-zawodnicy",
  "teams-db": "baza-druzyn",
  "players-db": "baza-zawodnikow",
};

const HOME_SLUG_TO_SECTION = Object.fromEntries(
  Object.entries(HOME_SECTION_TO_SLUG)
    .filter(([, slug]) => slug)
    .map(([section, slug]) => [slug, section])
);

const LEAGUE_SECTION_TO_SLUG = {
  home: "",
  table: "tabela",
  calendar: "kalendarz",
  gallery: "galerie",
  teams: "druzyny",
  players: "statystyki",
};

const LEAGUE_SLUG_TO_SECTION = Object.fromEntries(
  Object.entries(LEAGUE_SECTION_TO_SLUG)
    .filter(([, slug]) => slug)
    .map(([section, slug]) => [slug, section])
);

const INFO_SECTION_TO_SLUG = {
  about: "o-nas",
  regulations: "regulamin-ligi",
  sponsors: "sponsorzy",
  rodo: "rodo",
  privacy: "polityka-prywatnosci",
  contact: "kontakt",
};

const INFO_SLUG_TO_SECTION = Object.fromEntries(
  Object.entries(INFO_SECTION_TO_SLUG).map(([section, slug]) => [slug, section])
);

const HOME_SECTIONS = new Set(Object.keys(HOME_SECTION_TO_SLUG));
const LEAGUE_SECTIONS = new Set(Object.keys(LEAGUE_SECTION_TO_SLUG));
const INFO_SECTIONS = new Set(Object.keys(INFO_SECTION_TO_SLUG));
const APP_CONTEXTS = new Set([
  "home",
  "tournaments",
  "info",
  "admin",
  ...Object.keys(LEAGUE_CONTEXT_TO_SLUG),
]);

function normalizeContext(context) {
  return APP_CONTEXTS.has(context) ? context : "home";
}

function normalizeSectionForContext(context, section) {
  if (context === "home") return HOME_SECTIONS.has(section) ? section : "home";
  if (context === "info") return INFO_SECTIONS.has(section) ? section : "about";
  if (LEAGUE_SECTIONS.has(section) && LEAGUE_CONTEXT_TO_SLUG[context]) return section;
  if (LEAGUE_CONTEXT_TO_SLUG[context]) return "home";
  if (context === "admin") return section || "dashboard";
  return section || "home";
}

function parseRoundParam(value) {
  const parsed = Number.parseInt(value, 10);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
}

function parseHashRoute(hash) {
  const rawHash = String(hash || "").replace(/^#/, "");
  const normalizedHash = rawHash.replace(/^\/+/, "");
  const [pathPart, queryPart = ""] = normalizedHash.split("?");
  const segments = pathPart
    .split("/")
    .filter(Boolean)
    .map((segment) => {
      try {
        return decodeURIComponent(segment);
      } catch {
        return segment;
      }
    });
  const params = new URLSearchParams(queryPart);
  const season = parseRoundParam(params.get("sezon") || params.get("season"));
  const round = parseRoundParam(params.get("kolejka") || params.get("round"));
  const inlineMatchId = params.get("mecz") || params.get("match") || null;
  const rawContext = params.get("ctx");
  const rawSection = params.get("sekcja") || params.get("section");

  if (segments[0] === "druzyna" && segments[1]) {
    const context = normalizeContext(rawContext || "home");
    return {
      activeContext: context,
      activeSection: normalizeSectionForContext(context, rawSection || "home"),
      selectedTeam: segments[1],
      selectedMatchId: null,
      selectedPlayerId: null,
      matchViewMode: "inline",
      round,
      season,
    };
  }

  if (segments[0] === "zawodnik" && segments[1]) {
    const context = normalizeContext(rawContext || "home");
    return {
      activeContext: context,
      activeSection: normalizeSectionForContext(context, rawSection || "home"),
      selectedTeam: null,
      selectedMatchId: null,
      selectedPlayerId: segments[1],
      matchViewMode: "inline",
      round,
      season,
    };
  }

  if (segments[0] === "mecz" && segments[1]) {
    const context = normalizeContext(rawContext || "home");
    return {
      activeContext: context,
      activeSection: normalizeSectionForContext(context, rawSection || "home"),
      selectedTeam: null,
      selectedMatchId: segments[1],
      selectedPlayerId: null,
      matchViewMode: "page",
      round,
      season,
    };
  }

  if (segments[0] === "turnieje") {
    return {
      activeContext: "tournaments",
      activeSection: "home",
      selectedTeam: null,
      selectedMatchId: null,
      selectedPlayerId: null,
      matchViewMode: "inline",
      round: null,
      season,
    };
  }

  if (segments[0] === "info") {
    const infoSection = INFO_SLUG_TO_SECTION[segments[1]] || "about";
    return {
      activeContext: "info",
      activeSection: infoSection,
      selectedTeam: null,
      selectedMatchId: null,
      selectedPlayerId: null,
      matchViewMode: "inline",
      round: null,
      season,
    };
  }

  if (segments[0] === "admin") {
    return {
      activeContext: "admin",
      activeSection: "dashboard",
      selectedTeam: null,
      selectedMatchId: null,
      selectedPlayerId: null,
      matchViewMode: "inline",
      round: null,
      season,
    };
  }

  const leagueContext = LEAGUE_SLUG_TO_CONTEXT[segments[0]];
  if (leagueContext) {
    const leagueSection = LEAGUE_SLUG_TO_SECTION[segments[1]] || "home";
    return {
      activeContext: leagueContext,
      activeSection: leagueSection,
      selectedTeam: null,
      selectedMatchId: inlineMatchId,
      selectedPlayerId: null,
      matchViewMode: "inline",
      round,
      season,
    };
  }

  const homeSection = HOME_SLUG_TO_SECTION[segments[0]] || "home";
  return {
    activeContext: "home",
    activeSection: homeSection,
    selectedTeam: null,
    selectedMatchId: inlineMatchId,
    selectedPlayerId: null,
    matchViewMode: "inline",
    round: null,
    season,
  };
}

function buildHashRoute({
  activeContext,
  activeSection,
  selectedTeam,
  selectedMatchId,
  selectedPlayerId,
  matchViewMode,
  round,
  currentSeason,
}) {
  const params = new URLSearchParams();
  if (currentSeason) params.set("sezon", String(currentSeason));

  const baseContext = normalizeContext(activeContext);
  const baseSection = normalizeSectionForContext(baseContext, activeSection);

  if (LEAGUE_CONTEXT_TO_SLUG[baseContext] && round) {
    params.set("kolejka", String(round));
  }

  const detailContext = baseContext;
  const detailSection = baseSection;
  if (detailContext !== "home" || detailSection !== "home") {
    params.set("ctx", detailContext);
    params.set("sekcja", detailSection);
  }

  let path = "";

  if (selectedPlayerId) {
    path = `/zawodnik/${encodeURIComponent(selectedPlayerId)}`;
  } else if (selectedTeam) {
    path = `/druzyna/${encodeURIComponent(selectedTeam)}`;
  } else if (selectedMatchId && matchViewMode === "page") {
    path = `/mecz/${encodeURIComponent(selectedMatchId)}`;
  } else if (baseContext === "tournaments") {
    path = "/turnieje";
  } else if (baseContext === "info") {
    path = `/info/${INFO_SECTION_TO_SLUG[baseSection] || INFO_SECTION_TO_SLUG.about}`;
  } else if (baseContext === "admin") {
    path = "/admin";
  } else if (LEAGUE_CONTEXT_TO_SLUG[baseContext]) {
    const leaguePath = LEAGUE_CONTEXT_TO_SLUG[baseContext];
    const sectionPath = LEAGUE_SECTION_TO_SLUG[baseSection] || "";
    path = sectionPath ? `/${leaguePath}/${sectionPath}` : `/${leaguePath}`;
    if (selectedMatchId && matchViewMode !== "page") {
      params.set("mecz", selectedMatchId);
    }
  } else {
    const homePath = HOME_SECTION_TO_SLUG[baseSection] || "";
    path = homePath ? `/${homePath}` : "/";
    if (selectedMatchId && matchViewMode !== "page") {
      params.set("mecz", selectedMatchId);
    }
  }

  const queryString = params.toString();
  return `#${path}${queryString ? `?${queryString}` : ""}`;
}

/* =========================================
   SKRÓTY 3-literowe drużyn (konsekwentnie w całym serwisie)
   ========================================= */
function normalizeNameForAbbr(name) {
  return name
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-zA-Z0-9\s]/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function baseAbbrFromName(name) {
  const clean = normalizeNameForAbbr(name);
  const parts = clean.split(" ").filter(Boolean);
  if (parts.length >= 3) {
    return (parts[0][0] + parts[1][0] + parts[2][0]).toUpperCase();
  }
  if (parts.length === 2) {
    const a = parts[0];
    const b = parts[1];
    return (a[0] + b[0] + (b[1] || a[1] || "X")).toUpperCase();
  }
  const s = parts[0] || "XXX";
  const letters = s.replace(/[^A-Za-z0-9]/g, "").toUpperCase();
  return (letters + "XXX").slice(0, 3);
}

function makeUniqueAbbrMap(leagues) {
  const used = new Set();
  const map = {};
  const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  const allTeams = [];
  for (const lg of leagues) for (const t of lg.teams) allTeams.push(t);

  for (const team of allTeams) {
    const clean = normalizeNameForAbbr(team);
    let abbr = baseAbbrFromName(team);

    if (used.has(abbr)) {
      const seed = hashString("abbr|" + clean);
      const rng = mulberry32(seed);
      const a0 = abbr[0];
      const a1 = abbr[1];
      let tries = 0;
      while (used.has(abbr) && tries < 80) {
        const ch = alphabet[Math.floor(rng() * alphabet.length)];
        abbr = (a0 + a1 + ch).toUpperCase();
        tries++;
      }
      // ostatecznie: domknij z hasha
      if (used.has(abbr)) {
        const h = hashString("abbr2|" + clean)
          .toString(36)
          .toUpperCase();
        const only = h.replace(/[^A-Z]/g, "A");
        abbr = (a0 + a1 + only[0]).toUpperCase();
      }
    }

    used.add(abbr);
    map[team] = abbr;
  }
  return map;
}

function displayTeamName(team) {
  const normalizedTeam =
    typeof team === "string"
      ? team
      : typeof team?.team === "string"
      ? team.team
      : typeof team?.name === "string"
      ? team.name
      : "";
  // Domyślnie pełna nazwa drużyny. Jedyny wyjątek: 1 Warszawska Brygada Pancerna.
  if (normalizedTeam === "1 Warszawska Brygada Pancerna") return "I WBP";
  // Skróty drużynowe pisane wielkimi literami
  const abbreviations = ['fc', 'sc', 'stm', 'es', 'ks', 'lks', 'aks', 'gks', 'mks', 'rks', 'wks', 'bks', 'uks', 'ts'];
  return normalizedTeam.replace(/\b\w+\b/g, (word) => {
    if (abbreviations.includes(word.toLowerCase())) return word.toUpperCase();
    return word;
  });
}

/* =========================================
   Forma drużyny z tooltipem: wynik + skrót rywala (ostatnie 5 rozegranych)
   ========================================= */
function getTeamFormDotsWithTooltips(team, recentMatches) {
  const last5 = [...(recentMatches || [])].slice(0, 5).reverse(); // od najstarszego do najnowszego
  return last5.map((m) => {
    const isHome = m.home === team;
    const gf = isHome ? m.homeGoals : m.awayGoals;
    const ga = isHome ? m.awayGoals : m.homeGoals;
    const opp = isHome ? m.away : m.home;
    const v = gf > ga ? "W" : gf === ga ? "R" : "P";
    const title = `${gf}:${ga} ${displayTeamName(opp)}`;
    return { v, title };
  });
}

/* =========================================
   RNG deterministyczny (żeby dane były stałe)
   ========================================= */
function hashString(s) {
  let h = 2166136261;
  for (let i = 0; i < s.length; i++) {
    h ^= s.charCodeAt(i);
    h = Math.imul(h, 16777619);
  }
  return h >>> 0;
}
function mulberry32(seed) {
  return function () {
    let t = (seed += 0x6d2b79f5);
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
function pick(rng, arr) {
  return arr[Math.floor(rng() * arr.length)];
}

/* =========================================
   Round-robin schedule (flexible team count)
   ========================================= */
function generateSingleRoundRobin(teamNames) {
  // circle method
  const teams = [...teamNames];
  const n = teams.length;
  if (n % 2 !== 0) teams.push("BYE");
  const rounds = n - 1;
  const half = n / 2;
  const list = [...teams];

  const schedule = [];
  for (let r = 0; r < rounds; r++) {
    const pairings = [];
    for (let i = 0; i < half; i++) {
      const a = list[i];
      const b = list[n - 1 - i];
      if (a !== "BYE" && b !== "BYE") {
        // naprzemiennie dom/wyjazd
        const home = r % 2 === 0 ? a : b;
        const away = r % 2 === 0 ? b : a;
        pairings.push({ home, away });
      }
    }
    schedule.push(pairings);

    // rotate (keep first fixed)
    const fixed = list[0];
    const rest = list.slice(1);
    rest.unshift(rest.pop());
    for (let i = 1; i < n; i++) list[i] = rest[i - 1];
    list[0] = fixed;
  }
  return schedule; // [round][matches]
}

function generateDoubleRoundRobin(teamNames) {
  const firstHalf = generateSingleRoundRobin(teamNames); // first half rounds
  const secondHalf = firstHalf.map((round) =>
    round.map((m) => ({ home: m.away, away: m.home }))
  );
  return [...firstHalf, ...secondHalf]; // double round-robin
}

/* =========================================
   FIKCYJNA BAZA ZAWODNIKÓW (10/os na drużynę)
   ========================================= */
const FIRST_NAMES = [
  "Kuba",
  "Olek",
  "Bartek",
  "Mati",
  "Kacper",
  "Szymon",
  "Wojtek",
  "Paweł",
  "Dawid",
  "Patryk",
  "Arek",
  "Rafał",
  "Michał",
  "Adrian",
  "Daniel",
  "Igor",
  "Maks",
  "Filip",
  "Hubert",
  "Artur",
];
const LAST_NAMES = [
  "Kowalski",
  "Nowak",
  "Wiśniewski",
  "Wójcik",
  "Krawczyk",
  "Mazur",
  "Zieliński",
  "Szymański",
  "Dąbrowski",
  "Lewandowski",
  "Kamiński",
  "Jankowski",
  "Woźniak",
  "Kozłowski",
  "Czarnecki",
  "Kubiak",
  "Pawlak",
  "Michalski",
  "Król",
  "Górski",
];
const POSITIONS = [
  "BR",
  "OBR",
  "OBR",
  "POM",
  "POM",
  "POM",
  "NAP",
  "NAP",
  "OBR",
  "POM",
];

function buildPlayers() {
  const players = [];
  const byTeam = {};
  for (const lg of LEAGUES) {
    for (const team of lg.teams) {
      const seed = hashString("players|" + team);
      const rng = mulberry32(seed);
      byTeam[team] = [];
      for (let i = 0; i < 10; i++) {
        const fn = pick(rng, FIRST_NAMES);
        const ln = pick(rng, LAST_NAMES);
        const age = 18 + Math.floor(rng() * 18);
        const pos = POSITIONS[i] || pick(rng, POSITIONS);
        const number = 1 + Math.floor(rng() * 99);
        const foot = rng() < 0.7 ? "Prawa" : "Lewa";
        const city =
          rng() < 0.6 ? "Sulejówek" : rng() < 0.8 ? "Halinów" : "Wołomin";

        const p = {
          id: `${team}__p${i + 1}`,
          team,
          name: `${fn} ${ln}`,
          age,
          pos,
          number,
          foot,
          city,
        };
        players.push(p);
        byTeam[team].push(p);
      }
    }
  }
  return { players, playersByTeam: byTeam };
}

/* =========================================
   TERMNARZ + WYNIKI + ZDARZENIA (spójne)
   ========================================= */
function buildSeasonData(playersByTeam, season, seasonLeagues) {
  const allFixtures = [];
  const allMatches = []; // completed matches with results/events

  // Data rozpoczęcia sezonu - dynamiczna dla każdego roku
  const startDate = new Date(`${season}-04-05T00:00:00`); // sobota, początek sezonu wiosennego
  const timeSlots = ["14:30", "15:30", "16:30", "17:30", "18:30"];

  // Dla sezonów archiwalnych (< 2025) wszystkie mecze rozegrane
  // Dla sezonu 2025 (aktualny) niektóre mecze rozegrane
  const playedRounds = season < 2025 ? TOTAL_ROUNDS : PLAYED_ROUNDS;

  for (const lg of seasonLeagues) {
    const rounds = generateDoubleRoundRobin(lg.teams); // generates rounds based on team count
    const maxRounds = Math.min(rounds.length, TOTAL_ROUNDS); // don't exceed available rounds
    
    for (let r = 1; r <= maxRounds; r++) {
      const roundMatches = rounds[r - 1];
      if (!roundMatches) continue; // skip if round doesn't exist
      
      for (let i = 0; i < roundMatches.length; i++) {
        const { home, away } = roundMatches[i];
        const date = new Date(startDate);
        date.setDate(date.getDate() + (r - 1) * 7);
        const dateStr = date.toISOString().slice(0, 10);

        // Dodaj season do ID aby każdy sezon miał unikalne wyniki
        const fixtureId = `${season}__${lg.id}__R${r}__${home}__vs__${away}`;
        const mediaRng = mulberry32(hashString("media|" + fixtureId));
        const hasVideo = mediaRng() < 0.95; // 95% meczów ma video
        const hasGallery = mediaRng() < 0.1; // 10% meczów ma galerię

        const fixture = {
          id: fixtureId,
          league: lg.id,
          round: r,
          date: dateStr,
          time: timeSlots[i % timeSlots.length],
          venue: rngVenue(hashString(lg.id + "|" + home + "|" + away)),
          home,
          away,
          videoUrl: hasVideo
            ? `https://example.com/video/${encodeURIComponent(fixtureId)}`
            : null,
          galleryUrl: hasGallery
            ? `https://example.com/gallery/${encodeURIComponent(fixtureId)}`
            : null,
        };
        allFixtures.push(fixture);

        if (r <= playedRounds) {
          const match = simulateMatch(fixture, playersByTeam);
          allMatches.push(match);
        }
      }
    }
  }

  return { fixtures: allFixtures, matches: allMatches };
}

function rngVenue(seed) {
  // Wszystkie rozgrywki na jednym obiekcie
  return "Narutowicza 10, 05-071 Sulejówek";
}

function simulateMatch(fix, playersByTeam) {
  const seed = hashString(
    `match|${fix.league}|${fix.round}|${fix.home}|${fix.away}`
  );
  const rng = mulberry32(seed);

  // Wynik (0-5) z lekkim biasem home
  const baseHome = rng() * 4.2 + 0.3;
  const baseAway = rng() * 3.8;
  const homeGoals = clampInt(Math.round(baseHome - rng() * 1.2), 0, 6);
  const awayGoals = clampInt(Math.round(baseAway - rng() * 1.2), 0, 6);

  // Zdarzenia: bramki i kartki (bez minut)
  const events = [];

  const homePlayers = playersByTeam[fix.home] || [];
  const awayPlayers = playersByTeam[fix.away] || [];

  function scorer(teamPlayers) {
    // preferuj NAP/POM
    const prefer = teamPlayers.filter(
      (p) => p.pos === "NAP" || p.pos === "POM"
    );
    return prefer.length ? pick(rng, prefer) : pick(rng, teamPlayers);
  }

  function assister(teamPlayers, scorerId) {
    const others = teamPlayers.filter((p) => p.id !== scorerId);
    if (!others.length) return null;
    return rng() < 0.75 ? pick(rng, others) : null; // 75% szans na asystę
  }

  for (let g = 0; g < homeGoals; g++) {
    const s = scorer(homePlayers);
    const isPenalty = rng() < 0.15; // 15% goli z karnego
    const a = isPenalty ? null : assister(homePlayers, s?.id);
    events.push({
      type: "GOAL",
      team: fix.home,
      playerId: s?.id,
      playerName: s?.name,
      assistId: a?.id || null,
      assistName: a?.name || null,
      penalty: isPenalty,
      note: isPenalty ? "karny" : (a ? "z asystą" : "bez asysty"),
    });
  }

  for (let g = 0; g < awayGoals; g++) {
    const s = scorer(awayPlayers);
    const isPenalty = rng() < 0.15; // 15% goli z karnego
    const a = isPenalty ? null : assister(awayPlayers, s?.id);
    events.push({
      type: "GOAL",
      team: fix.away,
      playerId: s?.id,
      playerName: s?.name,
      assistId: a?.id || null,
      assistName: a?.name || null,
      penalty: isPenalty,
      note: isPenalty ? "karny" : (a ? "z asystą" : "bez asysty"),
    });
  }

  // Kartki
  const yellowCount = clampInt(Math.floor(rng() * 5), 0, 4); // 0-4
  const redCount = rng() < 0.15 ? 1 : 0; // czasem 1 czerwona

  for (let i = 0; i < yellowCount; i++) {
    const t = rng() < 0.5 ? fix.home : fix.away;
    const pl = pick(rng, t === fix.home ? homePlayers : awayPlayers);
    events.push({
      type: "YELLOW",
      team: t,
      playerId: pl?.id,
      playerName: pl?.name,
      note: "żółta kartka",
    });
  }
  for (let i = 0; i < redCount; i++) {
    const t = rng() < 0.5 ? fix.home : fix.away;
    const pl = pick(rng, t === fix.home ? homePlayers : awayPlayers);
    events.push({
      type: "RED",
      team: t,
      playerId: pl?.id,
      playerName: pl?.name,
      note: "czerwona kartka",
    });
  }

  // shuffle events (żeby nie były najpierw same gole jednych)
  shuffleDeterministic(events, hashString("evshuffle|" + fix.id));

  // MVP meczu - preferuj strzelców, asystentów, lub losowy zawodnik z lepszej drużyny
  let mvp = null;
  const goalScorers = events.filter(e => e.type === "GOAL");
  const assisters = events.filter(e => e.type === "GOAL" && e.assistId);
  
  if (goalScorers.length > 0) {
    // Wybierz losowego strzelca
    const mvpEvent = pick(rng, goalScorers);
    mvp = {
      playerId: mvpEvent.playerId,
      playerName: mvpEvent.playerName,
      team: mvpEvent.team
    };
  } else if (assisters.length > 0) {
    // Jeśli brak goli ale są asysty, wybierz asystenta
    const mvpEvent = pick(rng, assisters);
    mvp = {
      playerId: mvpEvent.assistId,
      playerName: mvpEvent.assistName,
      team: mvpEvent.team
    };
  } else {
    // Brak goli - wybierz losowego zawodnika z drużyny która wygrała (lub remis = losowo)
    let mvpTeam = homeGoals > awayGoals ? fix.home : (awayGoals > homeGoals ? fix.away : (rng() < 0.5 ? fix.home : fix.away));
    const mvpTeamPlayers = playersByTeam[mvpTeam] || [];
    const mvpPlayer = pick(rng, mvpTeamPlayers);
    if (mvpPlayer) {
      mvp = {
        playerId: mvpPlayer.id,
        playerName: mvpPlayer.name,
        team: mvpTeam
      };
    }
  }

  // Sędzia - losowany z listy
  const referee = REFEREES[Math.floor(rng() * REFEREES.length)];

  // Skład meczu - zawodnicy którzy występowali w zdarzeniach + kilku dodatkowych
  const homeLineup = [];
  const awayLineup = [];
  
  // Dodaj zawodników z events
  events.forEach(e => {
    if (e.team === fix.home && e.playerId) {
      if (!homeLineup.find(p => p.id === e.playerId)) {
        const player = homePlayers.find(p => p.id === e.playerId);
        if (player) homeLineup.push(player);
      }
    } else if (e.team === fix.away && e.playerId) {
      if (!awayLineup.find(p => p.id === e.playerId)) {
        const player = awayPlayers.find(p => p.id === e.playerId);
        if (player) awayLineup.push(player);
      }
    }
  });
  
  // Dodaj asystentów
  events.forEach(e => {
    if (e.type === "GOAL" && e.assistId) {
      if (e.team === fix.home && !homeLineup.find(p => p.id === e.assistId)) {
        const player = homePlayers.find(p => p.id === e.assistId);
        if (player) homeLineup.push(player);
      } else if (e.team === fix.away && !awayLineup.find(p => p.id === e.assistId)) {
        const player = awayPlayers.find(p => p.id === e.assistId);
        if (player) awayLineup.push(player);
      }
    }
  });
  
  // Uzupełnij do minimum 7 zawodników
  while (homeLineup.length < 7 && homeLineup.length < homePlayers.length) {
    const availablePlayers = homePlayers.filter(p => !homeLineup.find(l => l.id === p.id));
    if (availablePlayers.length > 0) {
      homeLineup.push(pick(rng, availablePlayers));
    } else {
      break;
    }
  }
  
  while (awayLineup.length < 7 && awayLineup.length < awayPlayers.length) {
    const availablePlayers = awayPlayers.filter(p => !awayLineup.find(l => l.id === p.id));
    if (availablePlayers.length > 0) {
      awayLineup.push(pick(rng, availablePlayers));
    } else {
      break;
    }
  }

  const hasVideo = rng() < 0.95; // 95% meczów ma video
  const hasGallery = rng() < 0.1; // 10% ma galerię
  const videoUrl = hasVideo
    ? `https://example.com/video/${encodeURIComponent(fix.id)}`
    : null;
  const galleryUrl = hasGallery
    ? `https://example.com/gallery/${encodeURIComponent(fix.id)}`
    : null;

  return {
    ...fix,
    played: true,
    homeGoals,
    awayGoals,
    events,
    mvp,
    referee,
    homeLineup,
    awayLineup,
    videoUrl,
    galleryUrl,
  };
}

function shuffleDeterministic(arr, seed) {
  const rng = mulberry32(seed);
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(rng() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
}
function clampInt(v, min, max) {
  return Math.max(min, Math.min(max, v));
}

/* =========================================
   STATYSTYKI (spójne z wynikami i zdarzeniami)
   ========================================= */
function computeAllStats(LEAGUES, matches, players, season = 2025) {
  const teamAbbrMap = makeUniqueAbbrMap(LEAGUES);

  // player stats
  const playerStats = {};
  for (const p of players) {
    playerStats[p.id] = {
      playerId: p.id,
      name: p.name,
      team: p.team,
      goals: 0,
      assists: 0,
      yellow: 0,
      red: 0,
    };
  }

  // team stats (per league)
  const teamStats = {}; // team -> record
  for (const lg of LEAGUES) {
    for (const t of lg.teams) {
      teamStats[t] = {
        team: t,
        league: lg.id,
        played: 0,
        win: 0,
        draw: 0,
        loss: 0,
        gf: 0,
        ga: 0,
        pts: 0,
        lastResults: [], // W/R/P
        streakUnbeaten: 0,
        streakWins: 0,
        streakWinless: 0,
      };
    }
  }

  // helper: add match to team
  function addTeamMatch(team, isHome, goalsFor, goalsAgainst, resultLetter) {
    const ts = teamStats[team];
    ts.played++;
    ts.gf += goalsFor;
    ts.ga += goalsAgainst;
    ts.lastResults.push(resultLetter);
    if (resultLetter === "W") {
      ts.win++;
      ts.pts += 3;
    } else if (resultLetter === "R") {
      ts.draw++;
      ts.pts += 1;
    } else {
      ts.loss++;
    }
  }

  // process matches sorted by round (important for streaks)
  const sorted = [...matches].sort(
    (a, b) => a.league.localeCompare(b.league) || a.round - b.round
  );

  for (const m of sorted) {
    const homeRes =
      m.homeGoals > m.awayGoals ? "W" : m.homeGoals === m.awayGoals ? "R" : "P";
    const awayRes =
      m.awayGoals > m.homeGoals ? "W" : m.homeGoals === m.awayGoals ? "R" : "P";

    addTeamMatch(m.home, true, m.homeGoals, m.awayGoals, homeRes);
    addTeamMatch(m.away, false, m.awayGoals, m.homeGoals, awayRes);

    // events -> player stats
    for (const ev of m.events) {
      if (!ev.playerId) continue;
      const ps = playerStats[ev.playerId];
      if (!ps) continue;

      if (ev.type === "GOAL") {
        ps.goals += 1;
        if (ev.assistId && playerStats[ev.assistId]) {
          playerStats[ev.assistId].assists += 1;
        }
      } else if (ev.type === "YELLOW") {
        ps.yellow += 1;
      } else if (ev.type === "RED") {
        ps.red += 1;
      }
    }
  }

  // compute current streaks from lastResults
  for (const t in teamStats) {
    const arr = teamStats[t].lastResults;
    // current streaks from end
    let unbeaten = 0;
    for (let i = arr.length - 1; i >= 0; i--) {
      if (arr[i] !== "P") unbeaten++;
      else break;
    }
    let wins = 0;
    for (let i = arr.length - 1; i >= 0; i--) {
      if (arr[i] === "W") wins++;
      else break;
    }
    let winless = 0;
    for (let i = arr.length - 1; i >= 0; i--) {
      if (arr[i] !== "W") winless++;
      else break;
    }
    teamStats[t].streakUnbeaten = unbeaten;
    teamStats[t].streakWins = wins;
    teamStats[t].streakWinless = winless;

    // keep only last 5 for form display with match details
    const last5Matches = sorted
      .filter((m) => m.home === t || m.away === t)
      .slice(-5);

    teamStats[t].form5 = last5Matches.map((m) => {
      const isHome = m.home === t;
      const opponent = isHome ? m.away : m.home;
      const result = isHome
        ? m.homeGoals > m.awayGoals
          ? "W"
          : m.homeGoals === m.awayGoals
          ? "R"
          : "P"
        : m.awayGoals > m.homeGoals
        ? "W"
        : m.homeGoals === m.awayGoals
        ? "R"
        : "P";
      return {
        result,
        opponent,
        score: `${m.homeGoals}:${m.awayGoals}`,
      };
    });
  }

  // league tables
  const tableByLeague = {};
  for (const lg of LEAGUES) {
    // Check if we have real data for this season and league
    const realData = getSeasonData(season, lg.id);
    
    if (realData && Array.isArray(realData)) {
      // Use REAL data from MLPN
      tableByLeague[lg.id] = realData.map((team, idx) => {
        const teamData = {
          team: team.name,
          league: lg.id,
          played: team.played,
          win: team.won,
          draw: team.drawn,
          loss: team.lost,
          gf: team.goalsFor,
          ga: team.goalsAgainst,
          pts: team.points,
          pos: idx + 1,
          lastResults: [], // Real match results not available yet
          streakUnbeaten: 0,
          streakWins: 0,
          streakWinless: 0,
          form5: []
        };
        
        // Also populate teamStats for this team
        teamStats[team.name] = teamData;
        
        return teamData;
      });
    } else {
      // Use calculated data from simulated matches
      const rows = lg.teams.map((t) => teamStats[t]);
      rows.sort(
        (a, b) =>
          b.pts - a.pts ||
          b.gf - b.ga - (a.gf - a.ga) ||
          b.gf - a.gf ||
          a.team.localeCompare(b.team)
      );
      tableByLeague[lg.id] = rows.map((r, idx) => ({ ...r, pos: idx + 1 }));
    }
  }

  // top lists
  const playersArray = Object.values(playerStats);
  const topScorers = [...playersArray]
    .sort((a, b) => b.goals - a.goals || b.assists - a.assists)
    .slice(0, 20);
  const topAssists = [...playersArray]
    .sort((a, b) => b.assists - a.assists || b.goals - a.goals)
    .slice(0, 20);
  const topYellow = [...playersArray]
    .sort((a, b) => b.yellow - a.yellow || b.red - a.red)
    .slice(0, 20);
  const topRed = [...playersArray]
    .sort((a, b) => b.red - a.red || b.yellow - a.yellow)
    .slice(0, 20);

  return {
    teamStats,
    tableByLeague,
    playerStats,
    topScorers,
    topAssists,
    topYellow,
    topRed,
  };
}

/* =========================================
   NEWS / ANKIETY / WOLNI ZAWODNICY
   ========================================= */
function buildNews(seed = 12345, players = [], fixtures = []) {
  const rng = mulberry32(seed);

  // deterministyczna lista pauz (żeby nie skakało po odświeżeniu)
  const pool = [...players];
  const suspCount = 6; // ilu "pauzuje" w tej kolejce (demo)
  const suspended = [];
  while (suspended.length < suspCount && pool.length) {
    const idx = Math.floor(rng() * pool.length);
    suspended.push(pool.splice(idx, 1)[0]);
  }

  // komunikat o zmianie godziny dla konkretnego meczu (demo, ale z linkami)
  const upcomingRound = CURRENT_ROUND;
  const upcoming = fixtures.filter((f) => f.round === upcomingRound);
  const pickFix = upcoming.length
    ? upcoming[Math.floor(rng() * upcoming.length)]
    : null;

  return [
    {
      id: "news_pause",
      date: "2025-01-20",
      category: "pauza",
      title: `Pauzy – kolejka ${CURRENT_ROUND}`,
      suspended: suspended.map((p) => ({
        playerId: p.id,
        name: p.name,
        team: p.team,
      })),
    },
    {
      id: "news_comm",
      date: "2025-01-19",
      category: "komunikat",
      title: `Zmiana organizacyjna – kolejka ${CURRENT_ROUND}`,
      fixtureId: pickFix?.id || null,
      home: pickFix?.home || null,
      away: pickFix?.away || null,
      body: pickFix
        ? `Korekta godziny spotkania. Sprawdź szczegóły meczu w kalendarzu.`
        : `Korekta godzin w kilku spotkaniach – sprawdzaj kalendarz.`,
    },
    {
      id: "news_important",
      date: "2025-01-18",
      category: "ważne",
      title: "WAŻNE: wyposażenie i porządek na boisku",
      body: "Ochraniacze obowiązkowe. Szanujemy czas sędziego i przeciwnika – mniej gadania, więcej grania.",
      // dla linków: pokażemy przykładowo 1-2 drużyny (klikane) – w UI
      teamsHint: ["Starszaki", "Rebelianci"],
    },
  ];
}

function buildPolls() {
  return [
    {
      id: "poll_1",
      title: "Kto wygra I ligę?",
      options: ["Starszaki", "Rebelianci", "Al Mar Wołomin", "Ktoś inny"],
      status: "active",
      endDate: "2025-02-10",
      endTime: "20:00",
    },
    {
      id: "poll_2",
      title: "Bramka kolejki (13)",
      options: [
        "Wolej po rogu",
        "Szpica z dystansu",
        "Główka po dośrodkowaniu",
        "Solowa akcja",
      ],
      status: "active",
      endDate: "2025-02-08",
      endTime: "18:30",
    },
    {
      id: "poll_3",
      title: "Kto zrobi największy progres w rundzie wiosennej?",
      options: ["Elo Melo", "Lider", "Chaos Team", "Huragan"],
      status: "active",
      endDate: "2025-02-15",
      endTime: "19:00",
    },
    {
      id: "poll_4",
      title: "Najlepszy transfer rundy jesiennej?",
      options: ["Transfer A", "Transfer B", "Transfer C", "Transfer D"],
      status: "archived",
      endDate: "2025-01-20",
      endTime: "20:00",
    },
    {
      id: "poll_5",
      title: "MVP października?",
      options: ["Zawodnik A", "Zawodnik B", "Zawodnik C"],
      status: "archived",
      endDate: "2024-11-01",
      endTime: "23:59",
    },
  ];
}

function buildFreeAgents() {
  // Wolni zawodnicy nie mają profili (bez ID) — pokazujemy tylko rozwijane kafelki.
  return [
    {
      name: "Łukasz Bury",
      age: 29,
      positions: ["P", "N"],
      region: "Sulejówek / okolice",
      experience:
        "Środkowy pomocnik z doświadczeniem ligowym, mocny odbiór i przegląd pola — szuka drużyny od zaraz.",
      contact: {
        phone: "6xx xxx xxx",
        email: "lukasz.bury@example.com",
        instagram: "@lukasz_bury",
        facebook: "facebook.com/lukaszbury",
      },
    },
    {
      name: "Kamil Norek",
      age: 24,
      positions: ["N", "P"],
      region: "Halinów / Wesoła",
      experience:
        "Napastnik, szybki start do piłki i pressing — najlepiej czuje się w grze z kontry.",
      contact: {
        phone: "6xx xxx xxx",
        email: "kamil.norek@example.com",
        instagram: "@kamil_norek",
        facebook: "facebook.com/kamilnorek",
      },
    },
    {
      name: "Michał Wrona",
      age: 33,
      positions: ["O", "P"],
      region: "Wołomin",
      experience:
        "Obrońca z dużą kulturą gry, grał też na '6' — poukładany, spokojny, czyta grę.",
      contact: {
        phone: "6xx xxx xxx",
        email: "michal.wrona@example.com",
        instagram: "@michal_wrona",
        facebook: "facebook.com/michalwrona",
      },
    },
    {
      name: "Szymon Kulesza",
      age: 21,
      positions: ["BR"],
      region: "Wesoła",
      experience:
        "Bramkarz, dobry refleks i gra nogami — dostępny w tygodniu, w weekendy zależnie od grafiku.",
      contact: {
        phone: "6xx xxx xxx",
        email: "szymon.kulesza@example.com",
        instagram: "@szymon_kulesza",
        facebook: "facebook.com/szymonkulesza",
      },
    },
    {
      name: "Patryk Domański",
      age: 27,
      positions: ["P"],
      region: "Mińsk Maz.",
      experience:
        "Pomocnik box-to-box, dużo biegania i asekuracji — lubi grać na intensywności.",
      contact: {
        phone: "6xx xxx xxx",
        email: "patryk.domanski@example.com",
        instagram: "@patryk_domanski",
        facebook: "facebook.com/patrykdomanski",
      },
    },
    {
      name: "Bartek Lis",
      age: 19,
      positions: ["N", "P"],
      region: "Sulejówek",
      experience:
        "Młody napastnik, dynamiczny i odważny w dryblingu — szuka minut i regularnej gry.",
      contact: {
        phone: "6xx xxx xxx",
        email: "bartek.lis@example.com",
        instagram: "@bartek_lis",
        facebook: "facebook.com/barteklis",
      },
    },
  ];
}

/* =========================================
   TURNIEJE (4 fikcyjne)
   ========================================= */
function buildTournaments() {
  const tournaments = [
    {
      id: "t1",
      name: "Turniej Sierpniowy I",
      date: "2024-08-10",
      location: "Orlik – Sulejówek",
    },
    {
      id: "t2",
      name: "Turniej Sierpniowy II",
      date: "2024-08-24",
      location: "Orlik – Sulejówek",
    },
    {
      id: "t3",
      name: "Turniej Grudniowy I",
      date: "2024-12-07",
      location: "Hala sportowa – Halinów",
    },
    {
      id: "t4",
      name: "Turniej Grudniowy II",
      date: "2024-12-21",
      location: "Hala sportowa – Halinów",
    },
  ];

  const leagueTeams = LEAGUES.flatMap((lg) => lg.teams);
  const nonLeagueTeams = [
    "FC Warriors",
    "Błyskawica",
    "Grom United",
    "Stalowi",
    "Orły FC",
    "Tytani",
    "Sokół",
    "Młode Wilki",
    "Imperium",
    "Feniks",
    "Sparta",
    "Legion",
  ];

  const allPotentialTeams = [...leagueTeams, ...nonLeagueTeams];

  return tournaments.map((t) => {
    const rng = mulberry32(hashString("tournament|" + t.id));
    const selected = [];
    const pool = [...allPotentialTeams];

    for (let i = 0; i < 16 && pool.length > 0; i++) {
      const idx = Math.floor(rng() * pool.length);
      selected.push(pool.splice(idx, 1)[0]);
    }

    const groups = [[], [], [], []];
    selected.forEach((team, i) => groups[i % 4].push(team));

    const groupMatches = [];
    groups.forEach((grp, gIdx) => {
      for (let i = 0; i < grp.length; i++) {
        for (let j = i + 1; j < grp.length; j++) {
          groupMatches.push({
            group: gIdx + 1,
            home: grp[i],
            away: grp[j],
            homeGoals: Math.floor(rng() * 6),
            awayGoals: Math.floor(rng() * 6),
          });
        }
      }
    });

    const groupTables = groups.map((grp, gIdx) => {
      const standings = grp.map((team) => ({
        team,
        played: 0,
        win: 0,
        draw: 0,
        loss: 0,
        gf: 0,
        ga: 0,
        pts: 0,
      }));

      groupMatches
        .filter((m) => m.group === gIdx + 1)
        .forEach((m) => {
          const homeTeam = standings.find((s) => s.team === m.home);
          const awayTeam = standings.find((s) => s.team === m.away);
          homeTeam.played++;
          awayTeam.played++;
          homeTeam.gf += m.homeGoals;
          homeTeam.ga += m.awayGoals;
          awayTeam.gf += m.awayGoals;
          awayTeam.ga += m.homeGoals;
          if (m.homeGoals > m.awayGoals) {
            homeTeam.win++;
            homeTeam.pts += 3;
            awayTeam.loss++;
          } else if (m.homeGoals < m.awayGoals) {
            awayTeam.win++;
            awayTeam.pts += 3;
            homeTeam.loss++;
          } else {
            homeTeam.draw++;
            awayTeam.draw++;
            homeTeam.pts++;
            awayTeam.pts++;
          }
        });

      standings.sort(
        (a, b) => b.pts - a.pts || b.gf - b.ga - (a.gf - a.ga) || b.gf - a.gf
      );
      return standings;
    });

    // Ćwierćfinaliści: 2 najlepsze drużyny z każdej grupy
    // Grupy: A=0, B=1, C=2, D=3
    const A1 = groupTables[0][0]; // Grupa A, 1. miejsce
    const A2 = groupTables[0][1]; // Grupa A, 2. miejsce
    const B1 = groupTables[1][0];
    const B2 = groupTables[1][1];
    const C1 = groupTables[2][0];
    const C2 = groupTables[2][1];
    const D1 = groupTables[3][0];
    const D2 = groupTables[3][1];

    // Pary ćwierćfinałowe: A1-B2, B1-A2, C1-D2, D1-C2
    // Taka struktura zapewnia że drużyny z tej samej grupy spotkają się max w finale
    const qfPairs = [
      { home: A1.team, away: B2.team },
      { home: B1.team, away: A2.team },
      { home: C1.team, away: D2.team },
      { home: D1.team, away: C2.team },
    ];

    const qf = qfPairs.map((pair) => {
      const homeGoals = Math.floor(rng() * 6);
      const awayGoals = Math.floor(rng() * 6);
      return {
        stage: "QF",
        home: pair.home,
        away: pair.away,
        homeGoals,
        awayGoals,
        winner: homeGoals > awayGoals ? pair.home : pair.away,
      };
    });

    const sf = [];
    for (let i = 0; i < 2; i++) {
      const home = qf[i * 2].winner;
      const away = qf[i * 2 + 1].winner;
      const homeGoals = Math.floor(rng() * 6);
      const awayGoals = Math.floor(rng() * 6);
      sf.push({
        stage: "SF",
        home,
        away,
        homeGoals,
        awayGoals,
        winner: homeGoals > awayGoals ? home : away,
        loser: homeGoals > awayGoals ? away : home,
      });
    }

    const thirdPlace = {
      stage: "3rd",
      home: sf[0].loser,
      away: sf[1].loser,
      homeGoals: Math.floor(rng() * 6),
      awayGoals: Math.floor(rng() * 6),
    };
    thirdPlace.winner =
      thirdPlace.homeGoals > thirdPlace.awayGoals
        ? thirdPlace.home
        : thirdPlace.away;

    const final = {
      stage: "Final",
      home: sf[0].winner,
      away: sf[1].winner,
      homeGoals: Math.floor(rng() * 6),
      awayGoals: Math.floor(rng() * 6),
    };
    final.winner = final.homeGoals > final.awayGoals ? final.home : final.away;

    // Nagrody indywidualne - losowe z uczestników
    const mvpIdx = Math.floor(rng() * selected.length);
    const scorerIdx = Math.floor(rng() * selected.length);
    const gkIdx = Math.floor(rng() * selected.length);

    // Symulujemy statystyki
    const topScorerGoals = 6 + Math.floor(rng() * 5); // 6-10 bramek
    const gkCleanSheets = 2 + Math.floor(rng() * 3); // 2-4 czyste konta

    return {
      ...t,
      groups,
      groupMatches,
      groupTables,
      playoffs: [...qf, ...sf, thirdPlace, final],
      champion: final.winner,
      runnerUp: final.homeGoals > final.awayGoals ? final.away : final.home,
      thirdPlace: thirdPlace.winner,
      mvp: { name: "Jan Kowalski", team: selected[mvpIdx] },
      topScorer: {
        name: "Adam Nowak",
        team: selected[scorerIdx],
        goals: topScorerGoals,
      },
      bestGK: {
        name: "Piotr Lis",
        team: selected[gkIdx],
        cleanSheets: gkCleanSheets,
      },
    };
  });
}

/* =========================================
   UI: małe helpery (logo, linki, 3D)
   ========================================= */

function SeasonNavigation({
  currentSeason,
  availableSeasons,
  onSeasonChange,
  darkMode,
  minSeason,
}) {
  const currentIndex = availableSeasons.indexOf(currentSeason);
  // Oblicz pierwszy dostępny indeks (uwzględniając minSeason)
  const firstIndex = minSeason ? availableSeasons.findIndex(y => y >= minSeason) : 0;
  const lastIndex = availableSeasons.length - 1;

  const canGoPrev = currentIndex > firstIndex;
  const canGoNext = currentIndex < lastIndex;
  const canJumpFirst = canGoPrev;
  const canJumpLast = canGoNext;

  const btnClass = (enabled) => classNames(
    "w-7 h-7 sm:w-8 sm:h-8 rounded-lg border flex items-center justify-center e3d-btn transition-colors shrink-0",
    enabled
      ? darkMode
        ? "bg-white/5 border-white/10 hover:bg-white/15 hover:border-white/20"
        : "bg-black/5 border-black/10 hover:bg-black/10 hover:border-black/20"
      : "opacity-30 cursor-not-allowed"
  );

  return (
    <div className="flex items-center gap-1 text-xs sm:text-sm max-w-full overflow-x-auto pb-1">
      <button
        onClick={() => canJumpFirst && onSeasonChange(availableSeasons[firstIndex])}
        disabled={!canJumpFirst}
        className={btnClass(canJumpFirst)}
        style={{ minWidth: 28, minHeight: 28 }}
        title={canJumpFirst ? `Pierwszy sezon (${availableSeasons[firstIndex]})` : ""}
      >
        <ChevronsLeft size={14} strokeWidth={2.5} />
      </button>
      <button
        onClick={() => canGoPrev && onSeasonChange(availableSeasons[currentIndex - 1])}
        disabled={!canGoPrev}
        className={btnClass(canGoPrev)}
        style={{ minWidth: 28, minHeight: 28 }}
        title={canGoPrev ? `Poprzedni sezon (${availableSeasons[currentIndex - 1]})` : "Brak starszych sezonów"}
      >
        <ChevronLeft size={14} strokeWidth={2.5} />
      </button>

      <div
        className={classNames(
          "px-3 sm:px-4 py-1 rounded-lg border text-xs sm:text-sm font-bold min-w-[58px] sm:min-w-[60px] text-center shrink-0",
          darkMode
            ? "bg-white/5 border-white/10 text-gray-200"
            : "bg-black/5 border-black/10 text-gray-700"
        )}
      >
        {currentSeason}
      </div>

      <button
        onClick={() => canGoNext && onSeasonChange(availableSeasons[currentIndex + 1])}
        disabled={!canGoNext}
        className={btnClass(canGoNext)}
        style={{ minWidth: 28, minHeight: 28 }}
        title={canGoNext ? `Następny sezon (${availableSeasons[currentIndex + 1]})` : "To jest aktualny sezon"}
      >
        <ChevronRight size={14} strokeWidth={2.5} />
      </button>
      <button
        onClick={() => canJumpLast && onSeasonChange(availableSeasons[lastIndex])}
        disabled={!canJumpLast}
        className={btnClass(canJumpLast)}
        style={{ minWidth: 28, minHeight: 28 }}
        title={canJumpLast ? `Najnowszy sezon (${availableSeasons[lastIndex]})` : ""}
      >
        <ChevronsRight size={14} strokeWidth={2.5} />
      </button>
    </div>
  );
}

function classNames(...xs) {
  return xs.filter(Boolean).join(" ");
}

function TeamLogo({
  team,
  darkMode,
  size = 40,
  onClick,
  src,
  framed = false,
  imgScale = 0.96,
}) {
  const [imgFailed, setImgFailed] = useState(false);
  const resolvedSrc = src || activeTeamLogoRegistry[team] || logoByTeam[team] || "";
  const logoFilter = [
    darkMode
      ? "drop-shadow(0 0 1.5px rgba(255,255,255,0.98)) drop-shadow(0 0 4px rgba(255,255,255,0.55))"
      : "",
    !framed ? "drop-shadow(0 6px 12px rgba(0,0,0,0.35))" : "",
  ]
    .filter(Boolean)
    .join(" ");

  useEffect(() => {
    setImgFailed(false);
  }, [resolvedSrc, team]);

  return (
    <button
      onClick={onClick}
      className={classNames(
        "relative grid place-items-center hover:scale-[1.02] active:scale-[0.98]",
        framed
          ? "rounded-2xl border overflow-hidden e3d-card bg-white border-gray-200"
          : "rounded-none border-0 bg-transparent overflow-visible shadow-none"
      )}
      style={{
        width: size,
        height: size,
        minWidth: size,
        minHeight: size,
        maxWidth: size,
        maxHeight: size,
        padding: 0,
        flex: "0 0 auto",
      }}
      title={team}
    >
      {resolvedSrc && !imgFailed ? (
        <img
          src={encodeURI(resolvedSrc)}
          alt={team}
          className="object-contain e3d-logo"
          style={{
            width: `${imgScale * 100}%`,
            height: `${imgScale * 100}%`,
            filter: logoFilter || undefined,
          }}
          onError={() => setImgFailed(true)}
        />
      ) : (
        <svg
          viewBox="0 0 24 24"
          className={classNames(framed ? "opacity-50" : "opacity-70")}
          style={{
            width: framed ? "60%" : "88%",
            height: framed ? "60%" : "88%",
            filter: darkMode
              ? "drop-shadow(0 0 1.5px rgba(255,255,255,0.95)) drop-shadow(0 0 4px rgba(255,255,255,0.45))"
              : undefined,
          }}
          fill="#6b7280"
        >
          <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z"/>
        </svg>
      )}
    </button>
  );
}

function TeamLink({ team, onClick, className = "" }) {
  return (
    <button
      onClick={onClick}
      className={classNames(
        "text-left hover:underline truncate min-w-0",
        className
      )}
    >
      {team}
    </button>
  );
}

function LeagueLink({ leagueId, leagueName, onClick, className = "" }) {
  return (
    <button
      onClick={onClick}
      className={classNames("hover:underline font-bold", className)}
      title={`Przejdź do ${leagueName}`}
    >
      {leagueName}
    </button>
  );
}

function FormDot({ v, title, small = false }) {
  // kolorystyczna ikonka formy — BEZ LITEREK
  // W = wygrana (zielona), R = remis (żółta), P = przegrana (czerwona), ? = nadchodzący mecz (szara)
  const sizeClass = small ? "w-4 h-4" : "w-6 h-6";
  const textClass = small ? "text-[8px]" : "text-[9px]";
  if (v === "?") {
    return (
      <span
        title={title}
        className={classNames(
          sizeClass,
          textClass,
          "rounded-full e3d-dot bg-gray-400/50 flex items-center justify-center font-bold text-white cursor-help"
        )}
      >
        ?
      </span>
    );
  }
  const base =
    v === "W" ? "bg-emerald-400" : v === "R" ? "bg-yellow-300" : "bg-rose-400";
  return (
    <span
      title={title}
      className={classNames(sizeClass, "rounded-full e3d-dot", base)}
    />
  );
}

function MobileLeagueScrollableTable({
  rows,
  darkMode,
  openTeam,
  showForm = true,
  getRowBg,
}) {
  const leftColumnWidth = showForm ? 136 : 126;
  const headerHeight = "h-8";
  const rowHeight = "h-[46px]";
  const statColumns = [
    { key: "played", label: "M", width: "w-8" },
    { key: "win", label: "W", width: "w-8" },
    { key: "draw", label: "R", width: "w-8" },
    { key: "loss", label: "P", width: "w-8" },
    { key: "gf", label: "BZ", width: "w-9" },
    { key: "ga", label: "BS", width: "w-9" },
    { key: "gd", label: "+/-", width: "w-10" },
    { key: "pts", label: "PKT", width: "w-11" },
  ];

  if (showForm) {
    statColumns.push({ key: "form", label: "FORMA", width: "w-[92px]" });
  }

  const renderStatCell = (row, column) => {
    if (column.key === "gd") {
      const gd = row.gf - row.ga;
      return (
        <span className={classNames(gd > 0 ? "text-emerald-400" : gd < 0 ? "text-rose-400" : "")}>
          {gd > 0 ? "+" : ""}
          {gd}
        </span>
      );
    }

    if (column.key === "form") {
      return (
        <div className="flex items-center justify-start gap-1">
          {(row.form5 || []).map((f, i) => (
            <FormDot
              key={`${row.team}-form-${i}`}
              v={f.result}
              title={`${f.score} ${displayTeamName(f.opponent)}`}
              small
            />
          ))}
          {row.nextOpponent && (
            <FormDot
              v="?"
              title={`Następny mecz: ${displayTeamName(row.nextOpponent)}`}
              small
            />
          )}
        </div>
      );
    }

    return row[column.key] ?? "";
  };

  return (
    <div className="md:hidden w-full max-w-full overflow-hidden rounded-xl border border-white/10">
      <div className="flex w-full">
        <div
          className={classNames(
            "shrink-0 border-r",
            darkMode ? "bg-[#0b1220] border-white/10" : "bg-white border-gray-200"
          )}
          style={{ width: leftColumnWidth }}
        >
          <div
            className={classNames(
              headerHeight,
              "grid grid-cols-[12px_16px_minmax(0,1fr)] gap-1 items-center px-2 text-[8px] font-bold uppercase tracking-wide border-b",
              darkMode ? "text-gray-300 border-white/10" : "text-gray-600 border-gray-200"
            )}
          >
            <div>#</div>
            <div></div>
            <div>Drużyna</div>
          </div>

          {rows.map((row) => {
            const position = row.displayPos ?? row.pos;
            const rowBg = getRowBg?.(position) || "";
            return (
              <div
                key={`mobile-fixed-${row.team}-${position}`}
                className={classNames(
                  rowHeight,
                  "grid grid-cols-[12px_16px_minmax(0,1fr)] gap-1 items-center px-2 border-b overflow-hidden",
                  darkMode ? "border-white/10 text-gray-100" : "border-gray-100 text-gray-700",
                  rowBg
                )}
              >
                <div className="font-extrabold text-[10px] leading-none">{position}</div>
                <TeamLogo
                  team={row.team}
                  darkMode={darkMode}
                  size={8}
                  onClick={() => openTeam(row.team)}
                />
                <button
                  onClick={() => openTeam(row.team)}
                  className="font-bold hover:underline truncate text-[9px] leading-tight text-left min-w-0 block w-full"
                >
                  {displayTeamName(row.team)}
                </button>
              </div>
            );
          })}
        </div>

        <div className="min-w-0 flex-1 overflow-x-auto overscroll-x-contain touch-pan-x">
          <div className="min-w-max">
            <div
                className={classNames(
                  headerHeight,
                  "flex items-center gap-0 px-1 text-[8px] font-bold uppercase tracking-wide border-b",
                  darkMode ? "text-gray-300 border-white/10 bg-black/20" : "text-gray-600 border-gray-200 bg-gray-50"
                )}
              >
              {statColumns.map((column) => (
                <div
                  key={column.key}
                    className={classNames(
                      "shrink-0 text-center",
                      column.width,
                      column.key === "form" ? "text-left pl-1" : ""
                    )}
                >
                  {column.label}
                </div>
              ))}
            </div>

            {rows.map((row) => {
              const position = row.displayPos ?? row.pos;
              const rowBg = getRowBg?.(position) || "";
              return (
                <div
                  key={`mobile-scroll-${row.team}-${position}`}
                  className={classNames(
                    rowHeight,
                    "flex items-center gap-0 px-1 border-b",
                    darkMode ? "border-white/10 text-gray-100" : "border-gray-100 text-gray-700",
                    rowBg
                  )}
                >
                  {statColumns.map((column) => (
                    <div
                      key={`${row.team}-${column.key}`}
                      className={classNames(
                        "shrink-0 text-center font-semibold text-[9px]",
                        column.width,
                        column.key === "pts" ? "font-black" : "",
                        column.key === "form" ? "text-left font-normal pl-1" : ""
                      )}
                    >
                      {renderStatCell(row, column)}
                    </div>
                  ))}
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}

function ScorePill({ homeGoals, awayGoals, darkMode, onClick, date, time, status }) {
  const statusKey = String(status || "").toLowerCase();
  const isWalkover = status?.startsWith('walkover');
  const statusOnlyLabel =
    statusKey === "unplayed"
      ? "Nierozegrany"
      : statusKey === "postponed"
        ? "Przełożony"
        : statusKey === "cancelled"
          ? "Odwołany"
          : statusKey === "scheduled"
            ? "Zaplanowany"
            : null;
  const showStatusOnly = !!statusOnlyLabel;
  const cls = isWalkover
    ? darkMode
      ? "bg-orange-500/10 border-orange-500/30"
      : "bg-orange-50 border-orange-300"
    : darkMode
      ? "bg-white/5 border-white/10"
      : "bg-black/5 border-black/10";
  return (
    <button
      onClick={onClick}
      className={classNames("px-4 py-1.5 rounded-xl border e3d-pill", cls)}
      title="Kliknij: szczegóły meczu"
    >
      <div
        className={classNames(
          "font-extrabold",
          showStatusOnly ? "text-xs sm:text-sm" : "text-lg"
        )}
      >
        {showStatusOnly ? statusOnlyLabel : `${homeGoals} : ${awayGoals}`}
      </div>
      {isWalkover ? (
        <div className={classNames(
          "text-[10px] font-bold mt-0.5",
          darkMode ? "text-orange-400" : "text-orange-600"
        )}>
          Walkower
        </div>
      ) : (date || time) ? (
        <div
          className={classNames(
            "text-[10px] font-normal mt-0.5",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          {date && time ? `${date} • ${time}` : (time || date)}
        </div>
      ) : null}
    </button>
  );
}

function fixtureCenterLabel(f) {
  const statusKey = String(f?.status || "").toLowerCase();
  if (statusKey === "unplayed") return "Nierozegrany";
  if (statusKey === "postponed") return "Przełożony";
  if (statusKey === "cancelled") return "Odwołany";
  if (f?.date && f?.time) return `${f.date} • ${f.time}`;
  if (f?.date) return f.date;
  if (f?.time) return f.time;
  return "Zaplanowany";
}

function fixtureCenterTimeLabel(f) {
  const statusKey = String(f?.status || "").toLowerCase();
  if (statusKey === "unplayed") return "Nierozegrany";
  if (statusKey === "postponed") return "Przełożony";
  if (statusKey === "cancelled") return "Odwołany";
  if (f?.time) return f.time;
  return "Godzina TBD";
}

function fixtureDateHeaderParts(dateStr) {
  if (!dateStr) {
    return {
      weekday: "Termin do ustalenia",
      date: "",
    };
  }
  const [y, m, d] = String(dateStr).split("-").map(Number);
  if (!y || !m || !d) {
    return {
      weekday: "Termin",
      date: String(dateStr),
    };
  }
  const dt = new Date(y, m - 1, d);
  const weekday = dt.toLocaleDateString("pl-PL", { weekday: "long" });
  const datePart = dt.toLocaleDateString("pl-PL", {
    day: "numeric",
    month: "long",
    year: "numeric",
  });
  return {
    weekday: `${weekday.charAt(0).toUpperCase()}${weekday.slice(1)}`,
    date: datePart,
  };
}

function compactDateLabel(dateStr) {
  if (!dateStr) return "";
  const [y, m, d] = String(dateStr).split("-").map(Number);
  if (!y || !m || !d) return String(dateStr);
  return `${pad2(d)}.${pad2(m)}`;
}

function MobileFlashscoreMatchRow({
  darkMode,
  homeTeam,
  awayTeam,
  homeLogoSrc,
  awayLogoSrc,
  onOpenHome,
  onOpenAway,
  onOpenMatch,
  leftPrimary,
  leftSecondary,
  rightPrimaryTop,
  rightPrimaryBottom,
  isScore,
  videoUrl,
  galleryUrl,
  onOpenGallery,
  galleryCount = 0,
}) {
  const hasMedia = !!videoUrl || !!galleryUrl || !!onOpenGallery;

  return (
    <div
      className={classNames(
        "md:hidden rounded-xl border px-3 py-2.5",
        darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-white"
      )}
    >
      <div className="grid grid-cols-[54px_minmax(0,1fr)_44px] gap-3 items-start">
        <button
          type="button"
          onClick={onOpenMatch}
          className="min-h-[52px] text-left flex flex-col justify-center"
          title="Szczegóły meczu"
        >
          <div
            className={classNames(
              "font-black leading-none",
              isScore ? "text-sm" : "text-[15px]",
              darkMode ? "text-white" : "text-gray-900"
            )}
          >
            {leftPrimary}
          </div>
          {leftSecondary ? (
            <div
              className={classNames(
                "mt-1 text-[10px] font-semibold leading-none",
                darkMode ? "text-gray-400" : "text-gray-500"
              )}
            >
              {leftSecondary}
            </div>
          ) : null}
        </button>

        <div className="min-w-0 space-y-2">
          <div className="grid grid-cols-[24px_minmax(0,1fr)] gap-2 items-center min-w-0">
            <TeamLogo
              team={homeTeam}
              src={homeLogoSrc}
              darkMode={darkMode}
              size={22}
              onClick={onOpenHome}
            />
            <button
              type="button"
              onClick={onOpenHome}
              className="min-w-0 text-left text-sm font-extrabold leading-tight truncate hover:underline"
            >
              {displayTeamName(homeTeam)}
            </button>
          </div>

          <div className="grid grid-cols-[24px_minmax(0,1fr)] gap-2 items-center min-w-0">
            <TeamLogo
              team={awayTeam}
              src={awayLogoSrc}
              darkMode={darkMode}
              size={22}
              onClick={onOpenAway}
            />
            <button
              type="button"
              onClick={onOpenAway}
              className="min-w-0 text-left text-sm font-extrabold leading-tight truncate hover:underline"
            >
              {displayTeamName(awayTeam)}
            </button>
          </div>
        </div>

        <button
          type="button"
          onClick={onOpenMatch}
          className={classNames(
            "min-h-[52px] rounded-lg px-1 flex flex-col items-end justify-center",
            isScore
              ? ""
              : darkMode
              ? "border border-white/10 bg-white/5"
              : "border border-gray-200 bg-gray-50"
          )}
          title="Szczegóły meczu"
        >
          {isScore ? (
            <>
              <div className="text-lg font-black leading-none">{rightPrimaryTop}</div>
              <div className="mt-2 text-lg font-black leading-none">{rightPrimaryBottom}</div>
            </>
          ) : (
            <div
              className={classNames(
                "text-xl font-black leading-none",
                darkMode ? "text-gray-300" : "text-gray-700"
              )}
            >
              ›
            </div>
          )}
        </button>
      </div>

      {hasMedia && (
        <div className="mt-2 pl-[66px]">
          <MediaIcons
            darkMode={darkMode}
            videoUrl={videoUrl}
            galleryUrl={galleryUrl}
            onOpenGallery={onOpenGallery}
            galleryCount={galleryCount}
            size={14}
          />
        </div>
      )}
    </div>
  );
}

function MediaIcons({
  darkMode,
  videoUrl,
  galleryUrl,
  onOpenGallery,
  galleryCount = 0,
  size = 18,
  className = "",
}) {
  const hasGallery = !!onOpenGallery || !!galleryUrl;
  if (!videoUrl && !hasGallery) return null;
  const baseBtn = classNames(
    "p-2 rounded-xl border inline-flex items-center justify-center e3d-btn",
    darkMode
      ? "bg-white/5 border-white/10 hover:bg-white/10"
      : "bg-black/5 border-black/10 hover:bg-black/10"
  );
  return (
    <div className={classNames("flex items-center gap-2", className)}>
      {videoUrl && (
        <a
          href={videoUrl}
          target="_blank"
          rel="noreferrer"
          className={baseBtn}
          title="Nagranie wideo"
        >
          <Video size={size} className="e3d-ico" />
        </a>
      )}
      {hasGallery && (
        onOpenGallery ? (
          <button
            type="button"
            onClick={onOpenGallery}
            className={baseBtn}
            title={galleryCount ? `Galeria zdjęć (${galleryCount})` : "Galeria zdjęć"}
          >
            <Images size={size} className="e3d-ico" />
          </button>
        ) : (
          <a
            href={galleryUrl}
            target="_blank"
            rel="noreferrer"
            className={baseBtn}
            title="Galeria zdjęć"
          >
            <Images size={size} className="e3d-ico" />
          </a>
        )
      )}
    </div>
  );
}

function VideoIcon({
  darkMode,
  videoUrl,
  played = false,
  size = 16,
  galleryUrl,
  hasGallery = false,
  galleryCount = 0,
  onOpenGallery,
}) {
  // Ikona kamery zawsze widoczna
  // Jeśli mecz rozegrany (played=true) i jest link - aktywna
  // Jeśli mecz rozegrany i brak linku - szara nieaktywna
  // Jeśli mecz nierozegrany - szara nieaktywna

  const hasVideo = !!videoUrl;
  const isActive = played && hasVideo;
  const galleryActive = hasGallery || !!galleryUrl || !!onOpenGallery;

  const baseBtn = classNames(
    "p-1.5 rounded-lg border inline-flex items-center justify-center",
    isActive
      ? darkMode
        ? "bg-white/5 border-white/10 hover:bg-white/10"
        : "bg-black/5 border-black/10 hover:bg-black/10"
      : darkMode
      ? "bg-white/5 border-white/10 opacity-30 cursor-not-allowed"
      : "bg-black/5 border-black/10 opacity-30 cursor-not-allowed"
  );

  return (
    <div className="flex items-center gap-1">
      {isActive ? (
        <a
          href={videoUrl}
          target="_blank"
          rel="noreferrer"
          className={baseBtn}
          title="Nagranie wideo"
        >
          <Video size={size} />
        </a>
      ) : (
        <div
          className={baseBtn}
          title={played ? "Brak nagrania" : "Mecz nierozegrany"}
        >
          <Video size={size} />
        </div>
      )}

      {galleryActive &&
        (onOpenGallery ? (
          <button
            type="button"
            onClick={onOpenGallery}
            className={classNames(
              "p-1.5 rounded-lg border inline-flex items-center justify-center",
              darkMode
                ? "bg-white/5 border-white/10 hover:bg-white/10"
                : "bg-black/5 border-black/10 hover:bg-black/10"
            )}
            title={galleryCount ? `Galeria zdjęć (${galleryCount})` : "Galeria zdjęć"}
          >
            <Images size={size} />
          </button>
        ) : (
          <a
            href={galleryUrl}
            target="_blank"
            rel="noreferrer"
            className={classNames(
              "p-1.5 rounded-lg border inline-flex items-center justify-center",
              darkMode
                ? "bg-white/5 border-white/10 hover:bg-white/10"
                : "bg-black/5 border-black/10 hover:bg-black/10"
            )}
            title="Galeria zdjęć"
          >
            <Images size={size} />
          </a>
        ))}
    </div>
  );
}

/* =========================================
   INFO PAGE - Informacje o lidze
   ========================================= */
function InfoPage({ darkMode, activeTab = "about", setActiveTab }) {
  return (
    <Card darkMode={darkMode} className="p-0">
      <div className="mx-auto w-full max-w-5xl px-5 py-6 md:px-8 md:py-8">
        {activeTab === "about" && <AboutPage darkMode={darkMode} />}
        {activeTab === "regulations" && <RegulationsPage darkMode={darkMode} />}
        {activeTab === "sponsors" && <SponsorsPage darkMode={darkMode} />}
        {activeTab === "rodo" && <RodoPage darkMode={darkMode} />}
        {activeTab === "privacy" && <PrivacyPage darkMode={darkMode} />}
        {activeTab === "contact" && <ContactPage darkMode={darkMode} />}
      </div>
    </Card>
  );
}

/* About Page */
function AboutPage({ darkMode }) {
  return (
    <div className="space-y-6 max-w-4xl">
      <div>
        <h1 className="text-3xl font-extrabold mb-4">
          O Miejskiej Lidze Piłki Nożnej w Sulejówku
        </h1>
        <div
          className={classNames(
            "text-sm mb-4",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Pasja • Sportowa rywalizacja • Społeczność
        </div>
      </div>

      <div className="space-y-4">
        <section>
          <h2 className="text-2xl font-bold mb-3">📜 Historia</h2>
          <p
            className={classNames(
              "leading-relaxed",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Miejska Liga Piłki Nożnej w Sulejówku (MLPN) została założona w 2018
            roku z myślą o stworzeniu platformy dla lokalnych pasjonatów piłki
            nożnej. Od tamtej pory rozwinęliśmy się w największą amatorską ligę
            piłkarską w regionie, zrzeszając dziesiątki drużyn i setki
            zawodników.
          </p>
          <p
            className={classNames(
              "leading-relaxed mt-3",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Rozgrywki odbywają się w systemie trzech lig (I, II, III),
            zapewniając odpowiedni poziom sportowy dla każdego zespołu. Nasza
            liga to nie tylko mecze - to społeczność, przyjaźnie i wspólna pasja
            do futbolu.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-bold mb-3">🎯 Misja i Wizja</h2>
          <div className="space-y-3">
            <div
              className={classNames(
                "p-4 rounded-xl",
                darkMode ? "bg-white/5" : "bg-gray-100"
              )}
            >
              <h3 className="font-bold mb-2">Nasza Misja</h3>
              <p
                className={classNames(
                  darkMode ? "text-gray-300" : "text-gray-700"
                )}
              >
                Promowanie aktywności fizycznej, zdrowej rywalizacji sportowej
                oraz budowanie lokalnej społeczności wokół piłki nożnej. Chcemy,
                aby każdy mieszkaniec Sulejówka mógł znaleźć swoje miejsce na
                boisku.
              </p>
            </div>

            <div
              className={classNames(
                "p-4 rounded-xl",
                darkMode ? "bg-white/5" : "bg-gray-100"
              )}
            >
              <h3 className="font-bold mb-2">Nasza Wizja</h3>
              <p
                className={classNames(
                  darkMode ? "text-gray-300" : "text-gray-700"
                )}
              >
                Być wzorem dla innych lig amatorskich, łącząc profesjonalną
                organizację z przyjazną atmosferą. Rozwijać bazę sportową w
                Sulejówku i wychowywać kolejne pokolenia piłkarzy.
              </p>
            </div>
          </div>
        </section>

        <section>
          <h2 className="text-2xl font-bold mb-3">🏆 Osiągnięcia</h2>
          <ul
            className={classNames(
              "list-disc list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>Ponad 30 drużyn w rozgrywkach</li>
            <li>Setki rozegranych meczów każdego sezonu</li>
            <li>Profesjonalne nagrania wideo meczów (95% meczów nagrywane)</li>
            <li>
              System trzech lig zapewniający rywalizację na każdym poziomie
            </li>
            <li>
              Aktywna społeczność na social media (Facebook, Instagram, YouTube)
            </li>
            <li>Wsparcie lokalnych sponsorów i partnerów</li>
          </ul>
        </section>

        <section>
          <h2 className="text-2xl font-bold mb-3">🏛️ Organizator</h2>
          <div
            className={classNames(
              "p-4 rounded-xl",
              darkMode ? "bg-white/5" : "bg-gray-100"
            )}
          >
            <p
              className={classNames(
                "font-bold mb-2",
                darkMode ? "text-white" : "text-gray-900"
              )}
            >
              Stowarzyszenie Liga Miejska
            </p>
            <p
              className={classNames(
                "text-sm",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              Wpisane do Krajowego Rejestru Sądowego prowadzonego przez Sąd
              Rejonowy w Warszawie, XXI Wydział Gospodarczy pod numerem KRS
              000022287
            </p>
            <p
              className={classNames(
                "text-sm mt-2",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              <strong>Siedziba:</strong> ul. Reymonta 1, 05-070 Sulejówek
            </p>
          </div>
        </section>
      </div>
    </div>
  );
}

/* Regulations Page */
function RegulationsPage({ darkMode }) {
  return (
    <div className="space-y-6 max-w-4xl">
      <div>
        <h1 className="text-3xl font-extrabold mb-4">Regulamin Ligi MLPN</h1>
        <div
          className={classNames(
            "text-sm mb-4",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Zasady rozgrywek i fair play
        </div>
      </div>

      <div className="space-y-6">
        <section>
          <h2 className="text-xl font-bold mb-3">§1 Postanowienia ogólne</h2>
          <ol
            className={classNames(
              "list-decimal list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>Liga działa w oparciu o niniejszy regulamin</li>
            <li>
              Udział w rozgrywkach jest dobrowolny i wymaga akceptacji
              regulaminu
            </li>
            <li>
              Wszystkie drużyny zobowiązane są do przestrzegania zasad fair play
            </li>
          </ol>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">§2 System rozgrywek</h2>
          <ol
            className={classNames(
              "list-decimal list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>
              Liga składa się z trzech poziomów rozgrywkowych: I Liga, II Liga,
              III Liga
            </li>
            <li>Każda liga składa się z 10-12 drużyn</li>
            <li>Rozgrywki prowadzone są systemem rundowym (każdy z każdym)</li>
            <li>Sezon składa się z rundy jesiennej i wiosennej</li>
            <li>Zwycięzca I Ligi zostaje Mistrzem MLPN</li>
          </ol>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">§3 Awanse i spadki</h2>
          <ol
            className={classNames(
              "list-decimal list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>
              <strong>III Liga:</strong> 2 najlepsze drużyny awansują do II Ligi
            </li>
            <li>
              <strong>II Liga:</strong> 2 najlepsze drużyny awansują do I Ligi,
              2 najsłabsze spadają do III Ligi
            </li>
            <li>
              <strong>I Liga:</strong> 2 najsłabsze drużyny spadają do II Ligi
            </li>
            <li>W przypadku równej liczby punktów decyduje bilans bramkowy</li>
          </ol>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">§4 Przepisy gry</h2>
          <ol
            className={classNames(
              "list-decimal list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>Mecze rozgrywane są według przepisów FIFA</li>
            <li>Format: 7+1 (7 zawodników + bramkarz)</li>
            <li>Czas gry: 2 x 35 minut</li>
            <li>Bramkarz może rozgrywać piłkę ręką tylko w polu bramkowym</li>
            <li>
              Bramki zdobyte z połowy boiska liczą się podwójnie (opcjonalnie)
            </li>
          </ol>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">§5 Kary i sankcje</h2>
          <ol
            className={classNames(
              "list-decimal list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>
              <strong>Żółta kartka:</strong> ostrzeżenie, 3 żółte = 1 mecz pauzy, a każda kolejna żółta kartka = kolejna pauza
            </li>
            <li>
              <strong>Czerwona kartka (bezpośrednia):</strong> minimum 1 mecz
              pauzy
            </li>
            <li>
              <strong>Czerwona kartka (brutalny faul):</strong> minimum 3 mecze
              pauzy
            </li>
            <li>
              Komisja ligi może wydłużyć karę w przypadku szczególnie naganych
              zachowań
            </li>
            <li>Walkower za niestawienie się na mecz: 0:3 dla przeciwnika</li>
          </ol>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">§6 Obowiązki drużyn</h2>
          <ol
            className={classNames(
              "list-decimal list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>
              Stawienie się na mecz z odpowiednim wyprzedzeniem (min. 15 minut)
            </li>
            <li>Posiadanie jednolitych strojów z numerami</li>
            <li>Przestrzeganie zasad fair play</li>
            <li>Szacunek dla sędziego, przeciwników i kibiców</li>
            <li>Terminowe opłacanie wpisowego</li>
          </ol>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">§7 Postanowienia końcowe</h2>
          <ol
            className={classNames(
              "list-decimal list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>Regulamin wchodzi w życie z chwilą jego ogłoszenia</li>
            <li>Zmiany regulaminu wymagają zatwierdzenia przez Zarząd Ligi</li>
            <li>W sprawach nieuregulowanych decyduje Komisja Ligi</li>
          </ol>
        </section>

        <div
          className={classNames(
            "mt-6 p-4 rounded-xl text-center",
            darkMode ? "bg-green-500/10" : "bg-green-50"
          )}
        >
          <p
            className={classNames(
              "font-bold",
              darkMode ? "text-green-400" : "text-green-700"
            )}
          >
            Szczegółowy regulamin dostępny jest na stronie mlpn.pl lub u
            organizatorów
          </p>
        </div>
      </div>
    </div>
  );
}

/* Sponsors Page */
function SponsorsPage({ darkMode }) {
  const sponsors = [
    {
      name: "Jadłostacja Sulejówek",
      logo: "/jadlostacja.png",
      desc: "Restauracja serwująca domowe obiady i smaczne dania na dowóz. Wspiera nas od początku istnienia ligi!",
      website:
        "https://www.facebook.com/p/Jadłostacja-Sulejówek-100039844490108/?locale=pl_PL",
    },
    {
      name: "Osłony do Okien",
      logo: "/oslonydookien.png",
      desc: "Kompleksowe rozwiązania w zakresie osłon okiennych - żaluzje, rolety, markizy i moskitiery.",
      website: "https://oslonydookien.pl",
    },
    {
      name: "Pa-El Fasady",
      logo: "/paelfasady.png",
      desc: "Profesjonalne usługi elewacyjne i tynkarskie. Tworzymy piękne i trwałe fasady budynków.",
      website: "https://www.facebook.com/profile.php?id=100063629406941",
    },
    {
      name: "RoboExpert",
      logo: "/roboexpert.png",
      desc: "Eksperci w dziedzinie robotyki, automatyki przemysłowej i innowacyjnych rozwiązań technologicznych.",
      website: "https://www.roboexpert.pl",
    },
    {
      name: "SzwagierKop",
      logo: "/szwagierkop.png",
      desc: "Profesjonalne usługi koparko-ładowarką. Prace ziemne, wyburzenia i transport.",
      website: "https://szwagierkop.pl",
    },
    {
      name: "Nasze Stroje",
      logo: "/naszestroje.png",
      desc: "Producent sportowej odzieży i strojów drużynowych. Twoje drużyny - nasze stroje!",
      website: "https://naszestroje.pl",
    },
  ];

  return (
    <div className="space-y-6 max-w-4xl">
      <div>
        <h1 className="text-3xl font-extrabold mb-4">
          Nasi Partnerzy i Sponsorzy
        </h1>
        <p
          className={classNames(
            "leading-relaxed",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Dziękujemy wszystkim firmom i osobom, które wspierają rozwój Miejskiej
          Ligi Piłki Nożnej w Sulejówku. Bez Waszego wsparcia nie bylibyśmy w
          stanie organizować rozgrywek na takim poziomie!
        </p>
      </div>

      <div className="grid md:grid-cols-2 gap-4">
        {sponsors.map((sponsor, idx) => (
          <div
            key={idx}
            className={classNames(
              "p-6 rounded-2xl border",
              darkMode
                ? "bg-white/5 border-white/10"
                : "bg-white border-gray-200"
            )}
          >
            <div className="flex items-start gap-4">
              <div
                className={classNames(
                  "w-24 h-24 rounded-xl flex items-center justify-center flex-shrink-0 p-2",
                  darkMode ? "bg-white/10" : "bg-gray-100"
                )}
              >
                <img
                  src={sponsor.logo}
                  alt={sponsor.name}
                  className="w-full h-full object-contain"
                />
              </div>

              <div className="flex-1">
                <h3 className="font-extrabold text-lg mb-2">{sponsor.name}</h3>
                <p
                  className={classNames(
                    "text-sm mb-3",
                    darkMode ? "text-gray-400" : "text-gray-600"
                  )}
                >
                  {sponsor.desc}
                </p>
                {sponsor.website !== "#" && (
                  <a
                    href={sponsor.website}
                    target="_blank"
                    rel="noreferrer"
                    className={classNames(
                      "text-sm font-bold hover:underline",
                      darkMode ? "text-green-400" : "text-green-600"
                    )}
                  >
                    Odwiedź stronę →
                  </a>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>

      <div
        className={classNames(
          "p-6 rounded-2xl text-center",
          darkMode ? "bg-green-500/10" : "bg-green-50"
        )}
      >
        <h3 className="font-bold text-xl mb-2">Zostań sponsorem!</h3>
        <p
          className={classNames(
            "mb-4",
            darkMode ? "text-gray-300" : "text-gray-700"
          )}
        >
          Chcesz wesprzeć lokalny sport i promować swoją firmę? Skontaktuj się z
          nami!
        </p>
        <a
          href="mailto:kontakt@mlpn.pl"
          className={classNames(
            "inline-block px-6 py-3 rounded-xl font-bold",
            darkMode
              ? "bg-green-500 text-white hover:bg-green-600"
              : "bg-green-600 text-white hover:bg-green-700"
          )}
        >
          Napisz do nas
        </a>
      </div>
    </div>
  );
}

/* RODO Page */
function RodoPage({ darkMode }) {
  return (
    <div className="space-y-6 max-w-4xl">
      <div>
        <h1 className="text-3xl font-extrabold mb-4">
          RODO - Ochrona Danych Osobowych
        </h1>
        <div
          className={classNames(
            "text-sm mb-4",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Zgodnie z Rozporządzeniem Parlamentu Europejskiego i Rady (UE)
          2016/679 (RODO)
        </div>
      </div>

      <div className="space-y-6">
        <section>
          <h2 className="text-xl font-bold mb-3">Administrator danych</h2>
          <p
            className={classNames(
              "leading-relaxed",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Administratorem Twoich danych osobowych jest{" "}
            <strong>Stowarzyszenie Liga Miejska</strong> z siedzibą w Sulejówku
            (05-070), ul. Reymonta 1, KRS 000022287.
          </p>
          <p
            className={classNames(
              "leading-relaxed mt-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Kontakt:{" "}
            <a href="mailto:kontakt@mlpn.pl" className="underline">
              kontakt@mlpn.pl
            </a>
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">Jakie dane przetwarzamy?</h2>
          <ul
            className={classNames(
              "list-disc list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>Imię i nazwisko zawodników</li>
            <li>Adres e-mail (kapitanów drużyn)</li>
            <li>Numer telefonu kontaktowego</li>
            <li>Zdjęcia i nagrania z meczów</li>
            <li>Statystyki sportowe</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">Cel przetwarzania danych</h2>
          <ul
            className={classNames(
              "list-disc list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>Organizacja rozgrywek ligowych</li>
            <li>Prowadzenie statystyk i tabeli</li>
            <li>Komunikacja z drużynami</li>
            <li>Dokumentacja meczów (foto, wideo)</li>
            <li>Promocja ligi w mediach społecznościowych</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">Podstawa prawna</h2>
          <p
            className={classNames(
              "leading-relaxed",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Dane przetwarzane są na podstawie:
          </p>
          <ul
            className={classNames(
              "list-disc list-inside space-y-2 mt-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>
              Zgody osoby, której dane dotyczą (art. 6 ust. 1 lit. a RODO)
            </li>
            <li>
              Realizacji umowy/uczestnictwa w rozgrywkach (art. 6 ust. 1 lit. b
              RODO)
            </li>
            <li>
              Prawnie uzasadnionego interesu administratora (art. 6 ust. 1 lit.
              f RODO)
            </li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">Twoje prawa</h2>
          <p
            className={classNames(
              "leading-relaxed mb-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Masz prawo do:
          </p>
          <ul
            className={classNames(
              "list-disc list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>Dostępu do swoich danych</li>
            <li>Sprostowania danych</li>
            <li>Usunięcia danych ("prawo do bycia zapomnianym")</li>
            <li>Ograniczenia przetwarzania</li>
            <li>Przenoszenia danych</li>
            <li>Wniesienia sprzeciwu wobec przetwarzania</li>
            <li>Cofnięcia zgody w dowolnym momencie</li>
            <li>Wniesienia skargi do organu nadzorczego (UODO)</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">
            Okres przechowywania danych
          </h2>
          <p
            className={classNames(
              "leading-relaxed",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Dane przechowujemy przez okres niezbędny do realizacji celów, dla
            których zostały zebrane, lub do momentu cofnięcia zgody. Dane
            archiwalne (wyniki, statystyki) mogą być przechowywane przez czas
            nieokreślony w celach historycznych.
          </p>
        </section>

        <div
          className={classNames(
            "mt-6 p-4 rounded-xl",
            darkMode ? "bg-blue-500/10" : "bg-blue-50"
          )}
        >
          <p
            className={classNames(
              "font-bold mb-2",
              darkMode ? "text-blue-400" : "text-blue-700"
            )}
          >
            Masz pytania dotyczące ochrony danych?
          </p>
          <p
            className={classNames(
              "text-sm",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Skontaktuj się z nami:{" "}
            <a href="mailto:kontakt@mlpn.pl" className="underline">
              kontakt@mlpn.pl
            </a>
          </p>
        </div>
      </div>
    </div>
  );
}

/* Privacy Policy Page */
function PrivacyPage({ darkMode }) {
  return (
    <div className="space-y-6 max-w-4xl">
      <div>
        <h1 className="text-3xl font-extrabold mb-4">Polityka Prywatności</h1>
        <div
          className={classNames(
            "text-sm mb-4",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Informacje o przetwarzaniu danych i wykorzystywaniu plików cookies
        </div>
      </div>

      <div className="space-y-6">
        <section>
          <h2 className="text-xl font-bold mb-3">1. Informacje ogólne</h2>
          <p
            className={classNames(
              "leading-relaxed",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Niniejsza Polityka Prywatności określa zasady przetwarzania i
            ochrony danych osobowych przekazanych przez Użytkowników w związku z
            korzystaniem ze strony internetowej MLPN oraz uczestnictwem w
            rozgrywkach.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">2. Pliki cookies</h2>
          <p
            className={classNames(
              "leading-relaxed mb-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Nasza strona używa plików cookies (ciasteczek) w następujących
            celach:
          </p>
          <ul
            className={classNames(
              "list-disc list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>Zapamiętywanie preferencji użytkownika (tryb ciemny/jasny)</li>
            <li>Analiza ruchu na stronie (Google Analytics)</li>
            <li>Umożliwienie funkcjonowania elementów interaktywnych</li>
          </ul>
          <p
            className={classNames(
              "leading-relaxed mt-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Możesz w każdej chwili usunąć pliki cookies w ustawieniach swojej
            przeglądarki.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">3. Zewnętrzne usługi</h2>
          <p
            className={classNames(
              "leading-relaxed mb-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Korzystamy z następujących usług zewnętrznych:
          </p>
          <ul
            className={classNames(
              "list-disc list-inside space-y-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>
              <strong>YouTube</strong> - odtwarzanie nagrań meczów
            </li>
            <li>
              <strong>Facebook</strong> - wtyczki społecznościowe
            </li>
            <li>
              <strong>Instagram</strong> - galerie zdjęć
            </li>
          </ul>
          <p
            className={classNames(
              "leading-relaxed mt-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Te usługi mogą gromadzić własne dane zgodnie ze swoimi politykami
            prywatności.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">
            4. Nagrania wideo i zdjęcia
          </h2>
          <p
            className={classNames(
              "leading-relaxed",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Mecze są nagrywane i publikowane na YouTube oraz w social media.
            Przystępując do rozgrywek, wyrażasz zgodę na przetwarzanie swojego
            wizerunku w celach dokumentacyjnych i promocyjnych ligi.
          </p>
          <p
            className={classNames(
              "leading-relaxed mt-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Jeśli chcesz usunąć swój wizerunek z publikacji, skontaktuj się z
            nami.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">5. Bezpieczeństwo danych</h2>
          <p
            className={classNames(
              "leading-relaxed",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Stosujemy odpowiednie środki techniczne i organizacyjne zapewniające
            bezpieczeństwo przetwarzanych danych osobowych, w szczególności
            zabezpieczamy dane przed dostępem osób nieuprawnionych, utratą czy
            uszkodzeniem.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">
            6. Kontakt w sprawie prywatności
          </h2>
          <p
            className={classNames(
              "leading-relaxed",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            W przypadku pytań dotyczących przetwarzania danych osobowych,
            prosimy o kontakt:
          </p>
          <ul
            className={classNames(
              "list-disc list-inside space-y-2 mt-2",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            <li>
              E-mail:{" "}
              <a href="mailto:kontakt@mlpn.pl" className="underline">
                kontakt@mlpn.pl
              </a>
            </li>
            <li>Adres: ul. Reymonta 1, 05-070 Sulejówek</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-bold mb-3">
            7. Zmiany Polityki Prywatności
          </h2>
          <p
            className={classNames(
              "leading-relaxed",
              darkMode ? "text-gray-300" : "text-gray-700"
            )}
          >
            Zastrzegamy sobie prawo do wprowadzania zmian w Polityce
            Prywatności. O wszelkich zmianach poinformujemy na stronie
            internetowej.
          </p>
        </section>

        <div
          className={classNames(
            "mt-6 p-4 rounded-xl text-center text-sm",
            darkMode ? "bg-white/5" : "bg-gray-100"
          )}
        >
          <p
            className={classNames(darkMode ? "text-gray-400" : "text-gray-600")}
          >
            Ostatnia aktualizacja: Luty 2025
          </p>
        </div>
      </div>
    </div>
  );
}

/* Contact Page */
function ContactPage({ darkMode }) {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    subject: "",
    message: "",
  });
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    // W prawdziwej implementacji wysłałbyś dane do backendu
    setSubmitted(true);
    setTimeout(() => {
      setSubmitted(false);
      setFormData({ name: "", email: "", subject: "", message: "" });
    }, 3000);
  };

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  return (
    <div className="space-y-6 max-w-4xl">
      <div>
        <h1 className="text-3xl font-extrabold mb-4">Kontakt</h1>
        <p
          className={classNames(
            "leading-relaxed",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Masz pytania? Chcesz dołączyć do ligi? Skontaktuj się z nami!
        </p>
      </div>

      <div className="grid md:grid-cols-2 gap-6">
        {/* Contact Info */}
        <div className="space-y-4">
          <div
            className={classNames(
              "p-4 rounded-xl",
              darkMode ? "bg-white/5" : "bg-gray-100"
            )}
          >
            <h3 className="font-bold mb-3 flex items-center gap-2">
              <span>📧</span> E-mail
            </h3>
            <a
              href="mailto:kontakt@mlpn.pl"
              className={classNames(
                "hover:underline",
                darkMode ? "text-green-400" : "text-green-600"
              )}
            >
              kontakt@mlpn.pl
            </a>
          </div>

          <div
            className={classNames(
              "p-4 rounded-xl",
              darkMode ? "bg-white/5" : "bg-gray-100"
            )}
          >
            <h3 className="font-bold mb-3 flex items-center gap-2">
              <span>📞</span> Telefon
            </h3>
            <a
              href="tel:517611687"
              className={classNames(
                "hover:underline",
                darkMode ? "text-green-400" : "text-green-600"
              )}
            >
              517 611 687
            </a>
            <p
              className={classNames(
                "text-sm mt-1",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              Łukasz Świstak (Organizator)
            </p>
          </div>

          <div
            className={classNames(
              "p-4 rounded-xl",
              darkMode ? "bg-white/5" : "bg-gray-100"
            )}
          >
            <h3 className="font-bold mb-3 flex items-center gap-2">
              <span>📍</span> Adres
            </h3>
            <p
              className={classNames(
                darkMode ? "text-gray-300" : "text-gray-700"
              )}
            >
              ul. Reymonta 1<br />
              05-070 Sulejówek
            </p>
          </div>

          <div
            className={classNames(
              "p-4 rounded-xl",
              darkMode ? "bg-white/5" : "bg-gray-100"
            )}
          >
            <h3 className="font-bold mb-3">Social Media</h3>
            <div className="flex gap-3">
              <a
                href="https://www.facebook.com/MLPN-w-Sulej%C3%B3wku-475269012595910/"
                target="_blank"
                rel="noreferrer"
                className={classNames(
                  "w-12 h-12 rounded-full flex items-center justify-center transition-transform hover:scale-105 text-[#1877F2]",
                  darkMode
                    ? "bg-blue-500/20 hover:bg-blue-500/30"
                    : "bg-blue-100 hover:bg-blue-200"
                )}
                title="Facebook"
              >
                <SocialBrandIcon brand="facebook" className="w-5 h-5" />
              </a>
              <a
                href="https://www.instagram.com/mlpn_sulejowek/"
                target="_blank"
                rel="noreferrer"
                className={classNames(
                  "w-12 h-12 rounded-full flex items-center justify-center transition-transform hover:scale-105 text-[#E4405F]",
                  darkMode
                    ? "bg-pink-500/20 hover:bg-pink-500/30"
                    : "bg-pink-100 hover:bg-pink-200"
                )}
                title="Instagram"
              >
                <SocialBrandIcon brand="instagram" className="w-5 h-5" />
              </a>
              <a
                href="https://www.youtube.com/@MLPN_YT"
                target="_blank"
                rel="noreferrer"
                className={classNames(
                  "w-12 h-12 rounded-full flex items-center justify-center transition-transform hover:scale-105 text-[#FF0033]",
                  darkMode
                    ? "bg-red-500/20 hover:bg-red-500/30"
                    : "bg-red-100 hover:bg-red-200"
                )}
                title="YouTube"
              >
                <SocialBrandIcon brand="youtube" className="w-5 h-5" />
              </a>
            </div>
          </div>
        </div>

        {/* Contact Form */}
        <div>
          <div
            className={classNames(
              "p-6 rounded-2xl",
              darkMode ? "bg-white/5" : "bg-white border border-gray-200"
            )}
          >
            <h3 className="font-bold text-xl mb-4">Formularz kontaktowy</h3>

            {submitted ? (
              <div className="py-8 text-center">
                <div className="text-5xl mb-3">✉️</div>
                <p
                  className={classNames(
                    "font-bold",
                    darkMode ? "text-green-400" : "text-green-600"
                  )}
                >
                  Wiadomość wysłana!
                </p>
                <p
                  className={classNames(
                    "text-sm mt-2",
                    darkMode ? "text-gray-400" : "text-gray-600"
                  )}
                >
                  Odpowiemy najszybciej jak to możliwe.
                </p>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-4">
                <div>
                  <label className="block text-sm font-bold mb-2">
                    Imię i nazwisko
                  </label>
                  <input
                    type="text"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                    required
                    className={classNames(
                      "w-full px-4 py-2 rounded-lg border",
                      darkMode
                        ? "bg-white/5 border-white/10 focus:border-green-500"
                        : "bg-white border-gray-300 focus:border-green-500"
                    )}
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold mb-2">E-mail</label>
                  <input
                    type="email"
                    name="email"
                    value={formData.email}
                    onChange={handleChange}
                    required
                    className={classNames(
                      "w-full px-4 py-2 rounded-lg border",
                      darkMode
                        ? "bg-white/5 border-white/10 focus:border-green-500"
                        : "bg-white border-gray-300 focus:border-green-500"
                    )}
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold mb-2">Temat</label>
                  <input
                    type="text"
                    name="subject"
                    value={formData.subject}
                    onChange={handleChange}
                    required
                    className={classNames(
                      "w-full px-4 py-2 rounded-lg border",
                      darkMode
                        ? "bg-white/5 border-white/10 focus:border-green-500"
                        : "bg-white border-gray-300 focus:border-green-500"
                    )}
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold mb-2">
                    Wiadomość
                  </label>
                  <textarea
                    name="message"
                    value={formData.message}
                    onChange={handleChange}
                    required
                    rows={6}
                    className={classNames(
                      "w-full px-4 py-2 rounded-lg border resize-none",
                      darkMode
                        ? "bg-white/5 border-white/10 focus:border-green-500"
                        : "bg-white border-gray-300 focus:border-green-500"
                    )}
                  />
                </div>

                <button
                  type="submit"
                  className={classNames(
                    "w-full px-6 py-3 rounded-lg font-bold",
                    darkMode
                      ? "bg-green-500 hover:bg-green-600 text-white"
                      : "bg-green-600 hover:bg-green-700 text-white"
                  )}
                >
                  Wyślij wiadomość
                </button>
              </form>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

/* =========================================
   APP
   ========================================= */
export default function App() {
  const { user, hasAdminAccess, signOut } = useAuth();
  const isApplyingRouteRef = useRef(false);
  const routeReadyRef = useRef(false);
  const [darkMode, setDarkMode] = useState(() => {
    const saved = localStorage.getItem('mlpn-darkMode');
    return saved !== null ? saved === 'true' : false;
  });
  const [activeContext, setActiveContext] = useState("home"); // home | 1st | 2nd | 3rd | tournaments | info | admin
  const [activeSection, setActiveSection] = useState("home"); // home/news/typer/polls/free | table/calendar/teams/players
  const prevContextRef = useRef(activeContext);

  // Zapisz motyw do localStorage
  useEffect(() => {
    localStorage.setItem('mlpn-darkMode', String(darkMode));
  }, [darkMode]);

  // === DANE Z SUPABASE ===
  const {
    loading: dataLoading,
    error: dataError,
    availableSeasons,
    currentSeason,
    setCurrentSeason,
    seasonStatus,
    currentRound,
    playedRounds: _playedRounds,
    totalRounds: _totalRounds,
    totalRoundsByLeague,
    playedRoundsByLeague,
    currentLeagues,
    fixtures: rawFixtures,
    matches: rawMatches,
    stats,
    players,
    playersByTeam,
    news,
    polls,
    freeAgents,
    tournaments,
    typerConfig,
    seasonSummary,
    matchGalleries,
    defaultSeason,
    refreshData,
  } = useMLPNData();

  // Odśwież dane po wyjściu z panelu admina
  useEffect(() => {
    if (prevContextRef.current === "admin" && activeContext !== "admin") {
      refreshData();
    }
    prevContextRef.current = activeContext;
  }, [activeContext, refreshData]);

  const [round, setRound] = useState(1);
  const [routeSeasonRequest, setRouteSeasonRequest] = useState(null);

  useEffect(() => {
    const requestedSeason = routeSeasonRequest;
    if (!requestedSeason || !availableSeasons?.length) return;
    if (!availableSeasons.includes(requestedSeason)) {
      setRouteSeasonRequest(null);
      return;
    }
    if (currentSeason !== requestedSeason) {
      setCurrentSeason(requestedSeason);
    }
    setRouteSeasonRequest(null);
  }, [availableSeasons, currentSeason, routeSeasonRequest, setCurrentSeason]);

  // Utrzymuj kolejkę w dozwolonym zakresie, ale nie nadpisuj ręcznego wyboru.
  React.useEffect(() => {
    if (!currentRound) return;
    const fallbackRound = currentRound || 1;
    const leagueMax = totalRoundsByLeague[activeContext] || fallbackRound;

    setRound((prev) => {
      if (!prev) return Math.min(fallbackRound, leagueMax);
      if (prev < 1 || prev > leagueMax) {
        return Math.min(fallbackRound, leagueMax);
      }
      return prev;
    });
  }, [activeContext, currentRound, totalRoundsByLeague]);

  // "routing" wewnętrzny
  const [selectedTeam, setSelectedTeam] = useState(null); // team name
  const [selectedMatchId, setSelectedMatchId] = useState(null);
  const [selectedPlayerId, setSelectedPlayerId] = useState(null);
  const [matchViewMode, setMatchViewMode] = useState("inline");

  // Historia nawigacji - stos poprzednich widoków
  const [navigationHistory, setNavigationHistory] = useState([]);

  // Mobile menu
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [galleryOverlay, setGalleryOverlay] = useState({
    open: false,
    loading: false,
    album: null,
    currentIndex: 0,
  });

  useEffect(() => {
    const applyRouteState = (route) => {
      isApplyingRouteRef.current = true;

      const nextContext = normalizeContext(route.activeContext || "home");
      const nextSection = normalizeSectionForContext(
        nextContext,
        route.activeSection || (nextContext === "info" ? "about" : "home")
      );

      setRouteSeasonRequest(route.season || null);

      setActiveContext(nextContext);
      setActiveSection(nextSection);
      setSelectedTeam(route.selectedTeam || null);
      setSelectedMatchId(route.selectedMatchId || null);
      setSelectedPlayerId(route.selectedPlayerId || null);
      setMatchViewMode(route.matchViewMode === "page" ? "page" : "inline");
      setMobileMenuOpen(false);

      if (
        route.selectedTeam ||
        route.selectedPlayerId ||
        (route.selectedMatchId && route.matchViewMode === "page")
      ) {
        setNavigationHistory([
          {
            activeContext: nextContext,
            activeSection: nextSection,
            selectedTeam: null,
            selectedMatchId: null,
            selectedPlayerId: null,
            round: route.round || 1,
          },
        ]);
      } else {
        setNavigationHistory([]);
      }

      if (route.round) {
        setRound(route.round);
      }

      requestAnimationFrame(() => {
        isApplyingRouteRef.current = false;
      });
    };

    applyRouteState(parseHashRoute(window.location.hash));
    routeReadyRef.current = true;

    const handleHashChange = () => {
      applyRouteState(parseHashRoute(window.location.hash));
    };

    window.addEventListener("hashchange", handleHashChange);
    return () => window.removeEventListener("hashchange", handleHashChange);
  }, []);

  useEffect(() => {
    if (!galleryOverlay.open) return undefined;
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    return () => {
      document.body.style.overflow = previousOverflow;
    };
  }, [galleryOverlay.open]);

  const matchGalleriesByMatchId = useMemo(() => {
    const map = {};
    for (const album of matchGalleries || []) {
      if (album?.matchId) {
        map[album.matchId] = album;
      }
    }
    return map;
  }, [matchGalleries]);

  const fixtures = useMemo(
    () =>
      (rawFixtures || []).map((fixture) => {
        const galleryAlbum = matchGalleriesByMatchId[fixture.id] || null;
        return {
          ...fixture,
          galleryAlbum,
          hasGallery: !!galleryAlbum || !!fixture.galleryUrl,
          galleryCount: galleryAlbum?.photoCount || 0,
          galleryCoverUrl: galleryAlbum?.coverUrl || "",
        };
      }),
    [rawFixtures, matchGalleriesByMatchId]
  );

  const matches = useMemo(
    () =>
      (rawMatches || []).map((match) => {
        const galleryAlbum = matchGalleriesByMatchId[match.id] || null;
        return {
          ...match,
          galleryAlbum,
          hasGallery: !!galleryAlbum || !!match.galleryUrl,
          galleryCount: galleryAlbum?.photoCount || 0,
          galleryCoverUrl: galleryAlbum?.coverUrl || "",
        };
      }),
    [rawMatches, matchGalleriesByMatchId]
  );

  activeTeamLogoRegistry = useMemo(
    () => createTeamLogoRegistry({ standings: stats, fixtures, matches }),
    [stats, fixtures, matches]
  );

  const teamAbbrMap = useMemo(() => makeUniqueAbbrMap(currentLeagues), [currentLeagues]);

  // Upcoming round fixtures (typer)
  const typerMatches = useMemo(() => {
    const playedIds = new Set((matches || []).map((m) => m.id));

    if (typerConfig?.matchIds?.length) {
      const fixtureById = new Map((fixtures || []).map((f) => [f.id, f]));
      const configured = typerConfig.matchIds
        .map((id) => fixtureById.get(id))
        .filter(Boolean)
        .filter((f) => !playedIds.has(f.id));

      if (configured.length > 0) return configured;
    }

    // Mecze z bieżącej kolejki (niezagrane)
    const upcoming = fixtures.filter(
      (f) => f.round === currentRound && !matches.find(m => m.id === f.id)
    );
    if (upcoming.length === 0) return [];
    // Weź do 5 meczów: 2 z 1st, 2 z 2nd, 1 z 3rd
    const pick = (lgId, count) => upcoming.filter(x => x.league === lgId).slice(0, count);
    return [
      ...pick("1st", 2),
      ...pick("2nd", 2),
      ...pick("3rd", 1),
    ];
  }, [fixtures, matches, currentRound, typerConfig]);

  // map match by id (played only)
  const matchById = useMemo(() => {
    const m = {};
    for (const x of matches) m[x.id] = x;
    return m;
  }, [matches]);

  const matchMetaById = useMemo(() => {
    const map = {};
    for (const fixture of fixtures) {
      map[fixture.id] = fixture;
    }
    for (const match of matches) {
      map[match.id] = { ...(map[match.id] || {}), ...match };
    }
    return map;
  }, [fixtures, matches]);

  const closeGalleryOverlay = () => {
    setGalleryOverlay({
      open: false,
      loading: false,
      album: null,
      currentIndex: 0,
    });
  };

  const openGalleryCarousel = (album, initialIndex = 0) => {
    if (!album?.photos?.length) return;
    const safeIndex = Math.min(
      Math.max(initialIndex, 0),
      Math.max(album.photos.length - 1, 0)
    );
    setGalleryOverlay({
      open: true,
      loading: false,
      album,
      currentIndex: safeIndex,
    });
  };

  const openMatchGallery = async (matchRef, initialIndex = 0) => {
    const matchId = typeof matchRef === "string" ? matchRef : matchRef?.id;
    if (!matchId) return;

    const summary = matchGalleriesByMatchId[matchId];
    const legacyUrl = typeof matchRef === "object" ? matchRef?.galleryUrl : null;

    if (!summary && legacyUrl) {
      window.open(legacyUrl, "_blank", "noopener,noreferrer");
      return;
    }

    if (!summary) return;

    const matchMeta = matchMetaById[matchId] || {};
    setGalleryOverlay({
      open: true,
      loading: true,
      album: {
        ...summary,
        home: matchMeta.home,
        away: matchMeta.away,
        league: matchMeta.league,
        date: matchMeta.date,
        score:
          matchMeta.homeGoals != null && matchMeta.awayGoals != null
            ? `${matchMeta.homeGoals}:${matchMeta.awayGoals}`
            : null,
      },
      currentIndex: Math.max(initialIndex, 0),
    });

    try {
      const fullAlbum = await fetchMatchGallery(matchId);
      if (!fullAlbum?.photos?.length) {
        closeGalleryOverlay();
        return;
      }

      openGalleryCarousel(
        {
          ...summary,
          ...fullAlbum,
          home: matchMeta.home,
          away: matchMeta.away,
          league: matchMeta.league,
          date: matchMeta.date,
          score:
            matchMeta.homeGoals != null && matchMeta.awayGoals != null
              ? `${matchMeta.homeGoals}:${matchMeta.awayGoals}`
              : null,
        },
        initialIndex
      );
    } catch (err) {
      console.error("Nie udało się otworzyć galerii meczu:", err);
      closeGalleryOverlay();
    }
  };

  // menu
  const homeMenu = [
    {
      id: "news",
      label: "Aktualności",
      icon: <FileText size={18} className="e3d-ico" />,
    },
    {
      id: "typer",
      label: "Typer",
      icon: <Target size={18} className="e3d-ico" />,
    },
    {
      id: "polls",
      label: "Ankiety",
      icon: <Vote size={18} className="e3d-ico" />,
    },
    {
      id: "free",
      label: "Wolni zawodnicy",
      icon: <UserPlus size={18} className="e3d-ico" />,
    },
    {
      id: "teams-db",
      label: "Baza drużyn",
      icon: <Users size={18} className="e3d-ico" />,
    },
    {
      id: "players-db",
      label: "Baza zawodników",
      icon: <BarChart3 size={18} className="e3d-ico" />,
    },
  ];

  const leagueMenu = [
    {
      id: "home",
      label: "Główna",
      icon: <Trophy size={18} className="e3d-ico" />,
    },
    {
      id: "table",
      label: "Tabela",
      icon: <Trophy size={18} className="e3d-ico" />,
    },
    {
      id: "calendar",
      label: "Kalendarz",
      icon: <Calendar size={18} className="e3d-ico" />,
    },
    {
      id: "gallery",
      label: "Galerie",
      icon: <Images size={18} className="e3d-ico" />,
    },
    {
      id: "teams",
      label: "Drużyny",
      icon: <Users size={18} className="e3d-ico" />,
    },
    {
      id: "players",
      label: "Statystyki",
      icon: <BarChart3 size={18} className="e3d-ico" />,
    },
  ];

  const infoMenu = [
    {
      id: "about",
      label: "O nas",
      icon: <FileText size={18} className="e3d-ico" />,
    },
    {
      id: "regulations",
      label: "Regulamin Ligi",
      icon: <FileText size={18} className="e3d-ico" />,
    },
    {
      id: "sponsors",
      label: "Sponsorzy",
      icon: <Trophy size={18} className="e3d-ico" />,
    },
    {
      id: "rodo",
      label: "RODO",
      icon: <FileText size={18} className="e3d-ico" />,
    },
    {
      id: "privacy",
      label: "Polityka Prywatności",
      icon: <FileText size={18} className="e3d-ico" />,
    },
    {
      id: "contact",
      label: "Kontakt",
      icon: <Mail size={18} className="e3d-ico" />,
    },
  ];

  const menu =
    activeContext === "home"
      ? homeMenu
      : activeContext === "tournaments"
      ? []
      : activeContext === "info"
      ? infoMenu
      : activeContext === "admin"
      ? []
      : leagueMenu;

  // Funkcja zapisująca aktualny stan do historii przed zmianą
  const saveToHistory = () => {
    setNavigationHistory((prev) => [
      ...prev,
      {
        activeContext,
        activeSection,
        selectedTeam,
        selectedMatchId,
        selectedPlayerId,
        round,
      },
    ]);
  };

  // Funkcja cofania do poprzedniego widoku
  const goBack = () => {
    if (navigationHistory.length === 0) {
      // Jeśli brak historii, wróć do strony głównej
      goHome();
      return;
    }

    const previous = navigationHistory[navigationHistory.length - 1];
    setNavigationHistory((prev) => prev.slice(0, -1));

    setActiveContext(previous.activeContext);
    setActiveSection(previous.activeSection);
    setSelectedTeam(previous.selectedTeam);
    setSelectedMatchId(previous.selectedMatchId);
    setSelectedPlayerId(previous.selectedPlayerId);
    setRound(previous.round);
  };

  // helpers navigation
  const goHome = () => {
    setActiveContext("home");
    setActiveSection("home");
    setSelectedTeam(null);
    setSelectedMatchId(null);
    setSelectedPlayerId(null);
    setNavigationHistory([]); // Czyść historię przy powrocie do domu
    // Przywróć bieżący sezon - strona główna zawsze pokazuje aktualne dane
    if (defaultSeason && currentSeason !== defaultSeason) {
      setCurrentSeason(defaultSeason);
    }
  };

  const handleUserSignOut = async () => {
    setMobileMenuOpen(false);
    await signOut();
    goHome();
  };

  const openTeam = (team) => {
    saveToHistory();
    setSelectedMatchId(null);
    setSelectedPlayerId(null);
    setSelectedTeam(team);
  };

  const openMatchInline = (matchId) => {
    // Nie zapisujemy do historii - to tylko rozwinięcie inline
    setMatchViewMode("inline");
    setSelectedTeam(null);
    setSelectedPlayerId(null);
    setSelectedMatchId((prev) => {
      const next = prev === matchId ? null : matchId;
      if (next) {
        setTimeout(() => {
          const el = document.getElementById(`details-${next}`);
          if (el) {
            const rect = el.getBoundingClientRect();
            const viewportHeight = window.innerHeight;

            // Sprawdź czy dolna krawędź elementu jest poniżej widoku
            if (rect.bottom > viewportHeight) {
              // Przewiń tak, aby dolna krawędź była widoczna
              el.scrollIntoView({ behavior: "smooth", block: "end" });
            }
            // Jeśli element jest już w pełni widoczny - nie rób nic
          }
        }, 100);
      }
      return next;
    });
  };

  const openMatchPage = (matchId) => {
    saveToHistory();
    setMatchViewMode("page");
    setSelectedTeam(null);
    setSelectedPlayerId(null);
    setSelectedMatchId(matchId);
    setTimeout(() => {
      window.scrollTo({ top: 0, behavior: "smooth" });
    }, 0);
  };

  const openPlayer = (playerId) => {
    saveToHistory();
    setSelectedTeam(null);
    setSelectedMatchId(null);
    setSelectedPlayerId(playerId);
  };

  const goToLeague = (leagueId) => {
    saveToHistory();
    setActiveContext(leagueId);
    setActiveSection("home");
    setSelectedTeam(null);
    setSelectedMatchId(null);
    setSelectedPlayerId(null);
  };

  const closeDetail = () => {
    setMatchViewMode("inline");
    setSelectedTeam(null);
    setSelectedMatchId(null);
    setSelectedPlayerId(null);
  };

  const LEAGUE_NAMES = { "1st": "I Liga", "2nd": "II Liga", "3rd": "III Liga" };
  const leagueName = (id) => LEAGUE_NAMES[id] || currentLeagues.find((l) => l.id === id)?.name || id;

  // pick active league table
  const activeTable = useMemo(() => {
    if (activeContext === "home") return null;
    return stats.tableByLeague[activeContext] || [];
  }, [activeContext, stats.tableByLeague]);

  // Calendar fixtures for active league + chosen round
  const calendarFixtures = useMemo(() => {
    if (activeContext === "home") return [];
    return fixtures.filter(
      (f) => f.league === activeContext && f.round === round
    );
  }, [fixtures, activeContext, round]);

  useEffect(() => {
    if (!routeReadyRef.current || isApplyingRouteRef.current) return;

    const nextHash = buildHashRoute({
      activeContext,
      activeSection,
      selectedTeam,
      selectedMatchId,
      selectedPlayerId,
      matchViewMode,
      round,
      currentSeason,
    });

    if (window.location.hash === nextHash) return;

    window.history.replaceState(
      null,
      "",
      `${window.location.pathname}${window.location.search}${nextHash}`
    );
  }, [
    activeContext,
    activeSection,
    selectedTeam,
    selectedMatchId,
    selectedPlayerId,
    matchViewMode,
    round,
    currentSeason,
  ]);

  const activeLeagueGalleries = useMemo(() => {
    if (!["1st", "2nd", "3rd"].includes(activeContext)) return [];

    return (matchGalleries || [])
      .map((gallery) => {
        const meta = matchMetaById[gallery.matchId];
        if (!meta || meta.league !== activeContext) return null;
        return {
          ...gallery,
          home: meta.home,
          away: meta.away,
          league: meta.league,
          date: meta.date,
          time: meta.time,
          score:
            meta.homeGoals != null && meta.awayGoals != null
              ? `${meta.homeGoals}:${meta.awayGoals}`
              : null,
        };
      })
      .filter(Boolean)
      .sort((a, b) => String(b.publishedAt || b.date || "").localeCompare(String(a.publishedAt || a.date || "")));
  }, [activeContext, matchGalleries, matchMetaById]);

  // For "match card": if played -> show score from matches
  function getPlayedMatch(fix) {
    return matchById[fix.id] || null;
  }

  // render main "page"
  const renderPage = () => {
    // details have priority
    if (selectedPlayerId) {
      return (
        <PlayerProfile
          darkMode={darkMode}
          playerId={selectedPlayerId}
          openTeam={openTeam}
          onBack={goBack}
        />
      );
    }

    if (selectedMatchId && matchViewMode === "page") {
      const played = matchById[selectedMatchId];
      if (played) {
        return (
          <div className="space-y-3">
            <BackHeader
              darkMode={darkMode}
              title="Szczegóły meczu"
              onBack={goBack}
            />
            <MatchDetails
              darkMode={darkMode}
              match={played}
              openTeam={openTeam}
              goToLeague={goToLeague}
              openGallery={openMatchGallery}
            />
          </div>
        );
      }

      const fixture = fixtures.find((f) => f.id === selectedMatchId);
      if (!fixture) {
        return (
          <div className="space-y-3">
            <BackHeader
              darkMode={darkMode}
              title="Szczegóły meczu"
              onBack={goBack}
            />
            <Card darkMode={darkMode}>
              <div className={darkMode ? "text-gray-300" : "text-gray-700"}>
                Brak danych spotkania.
              </div>
            </Card>
          </div>
        );
      }

      return (
        <UpcomingMatchDetails
          darkMode={darkMode}
          fixture={fixture}
          stats={stats}
          matches={matches}
          playersByTeam={playersByTeam}
          openTeam={openTeam}
          openPlayer={openPlayer}
          onBack={goBack}
        />
      );
    }

    if (selectedTeam) {
      return (
        <TeamProfile
          darkMode={darkMode}
          team={selectedTeam}
          leagueId={currentLeagues.find((l) => l.teams.includes(selectedTeam))?.id}
          teamRow={stats.teamStats[selectedTeam]}
          recentMatches={getTeamRecentMatches(selectedTeam, matches)}
          fixtures={fixtures}
          matches={matches}
          openMatch={openMatchInline}
          onBack={goBack}
          openTeam={openTeam}
          openPlayer={openPlayer}
          currentSeason={currentSeason}
        />
      );
    }

    /* Match details are now inline (expanded in lists). */

    // admin context
    if (activeContext === "admin") {
      return <AdminPanel darkMode={darkMode} goHome={goHome} />;
    }

    // tournaments context
    if (activeContext === "tournaments") {
      return (
        <TournamentsPage
          darkMode={darkMode}
          tournaments={tournaments}
          openTeam={openTeam}
        />
      );
    }

    // info context
    if (activeContext === "info") {
      return (
        <InfoPage
          darkMode={darkMode}
          activeTab={activeSection}
          setActiveTab={setActiveSection}
        />
      );
    }

    // normal pages
    if (activeContext === "home") {
      switch (activeSection) {
        case "news":
          return (
            <NewsPage
              darkMode={darkMode}
              news={news}
              openTeam={openTeam}
              openMatch={openMatchPage}
            />
          );
        case "typer":
          return (
            <TyperPage
              darkMode={darkMode}
              typerMatches={typerMatches}
              typerConfig={typerConfig}
              teamStats={stats?.teamStats}
              matches={matches}
              openTeam={openTeam}
              goToLeague={goToLeague}
              currentLeagues={currentLeagues}
              currentRound={currentRound}
            />
          );
        case "polls":
          return <PollsPage darkMode={darkMode} polls={polls} />;
        case "free":
          return (
            <FreePlayersPage darkMode={darkMode} freeAgents={freeAgents} />
          );
        case "teams-db":
          return (
            <HomeTeamsDatabasePage
              darkMode={darkMode}
              openTeam={openTeam}
            />
          );
        case "players-db":
          return (
            <HomePlayersDatabasePage
              darkMode={darkMode}
              openPlayer={openPlayer}
            />
          );
        default:
          return (
            <HomePageErrorBoundary
              darkMode={darkMode}
              resetKey={`${currentSeason || "none"}:${activeContext}:${activeSection}:${selectedMatchId || "no-match"}`}
            >
              <HomeDashboard
                darkMode={darkMode}
                fixtures={fixtures}
                matches={matches}
                stats={stats}
                news={news}
                polls={polls}
                typerMatches={typerMatches}
                openTeam={openTeam}
                openMatch={openMatchInline}
                openGallery={openMatchGallery}
                expandedMatchId={selectedMatchId}
                playersByTeam={playersByTeam}
                openPlayer={openPlayer}
                currentLeagues={currentLeagues}
                goToLeague={goToLeague}
                setHomeSection={setActiveSection}
                currentRound={currentRound}
                playedRounds={_playedRounds}
                seasonStatus={seasonStatus}
                seasonSummary={seasonSummary}
                currentSeason={currentSeason}
              />
            </HomePageErrorBoundary>
          );
      }
    }

    // league context
    switch (activeSection) {
      case "home":
        return (
          <LeagueHomePage
            darkMode={darkMode}
            leagueId={activeContext}
            leagueName={leagueName(activeContext)}
            table={activeTable}
            matches={matches}
            fixtures={fixtures}
            openTeam={openTeam}
            openMatch={openMatchInline}
            openGallery={openMatchGallery}
            expandedMatchId={selectedMatchId}
            matchById={matchById}
            playersByTeam={playersByTeam}
            openPlayer={openPlayer}
            stats={stats}
            currentSeason={currentSeason}
            availableSeasons={availableSeasons}
            onSeasonChange={setCurrentSeason}
            seasonSummary={seasonSummary}
            seasonStatus={seasonStatus}
            currentRound={currentRound}
            playedRounds={_playedRounds}
            totalRounds={_totalRounds}
            totalRoundsByLeague={totalRoundsByLeague}
            playedRoundsByLeague={playedRoundsByLeague}
          />
        );
      case "table":
        return (
          <LeagueTablePage
            darkMode={darkMode}
            leagueName={leagueName(activeContext)}
            table={activeTable}
            openTeam={openTeam}
            currentSeason={currentSeason}
            availableSeasons={availableSeasons}
            onSeasonChange={setCurrentSeason}
            leagueId={activeContext}
          />
        );
      case "calendar":
        return (
          <CalendarPage
            darkMode={darkMode}
            leagueId={activeContext}
            leagueName={leagueName(activeContext)}
            round={round}
            setRound={setRound}
            fixtures={calendarFixtures}
            leagueTeams={currentLeagues.find((l) => l.id === activeContext)?.teams || []}
            getPlayedMatch={getPlayedMatch}
            openTeam={openTeam}
            openMatch={openMatchInline}
            openGallery={openMatchGallery}
            expandedMatchId={selectedMatchId}
            stats={stats}
            matches={matches}
            playersByTeam={playersByTeam}
            openPlayer={openPlayer}
            goToLeague={goToLeague}
            currentSeason={currentSeason}
            availableSeasons={availableSeasons}
            onSeasonChange={setCurrentSeason}
          />
        );
      case "gallery":
        return (
          <LeagueGalleryPage
            darkMode={darkMode}
            leagueId={activeContext}
            leagueName={leagueName(activeContext)}
            galleries={activeLeagueGalleries}
            currentSeason={currentSeason}
            availableSeasons={availableSeasons}
            onSeasonChange={setCurrentSeason}
            onOpenCarousel={openGalleryCarousel}
          />
        );
      case "teams":
        return (
          <TeamsPage
            darkMode={darkMode}
            leagueId={activeContext}
            leagueName={leagueName(activeContext)}
            teams={currentLeagues.find((l) => l.id === activeContext)?.teams || []}
            openTeam={openTeam}
            goToLeague={goToLeague}
            currentSeason={currentSeason}
            availableSeasons={availableSeasons}
            onSeasonChange={setCurrentSeason}
          />
        );
      case "players":
        return (
          <StatsPage
            darkMode={darkMode}
            leagueId={activeContext}
            leagueName={leagueName(activeContext)}
            stats={stats}
            openTeam={openTeam}
            openPlayer={openPlayer}
            goToLeague={goToLeague}
            currentSeason={currentSeason}
            availableSeasons={availableSeasons}
            onSeasonChange={setCurrentSeason}
          />
        );
      default:
        return (
          <LeagueHomePage
            darkMode={darkMode}
            leagueId={activeContext}
            leagueName={leagueName(activeContext)}
            table={activeTable}
            matches={matches}
            fixtures={fixtures}
            openTeam={openTeam}
            openMatch={openMatchInline}
            openGallery={openMatchGallery}
            expandedMatchId={selectedMatchId}
            matchById={matchById}
            playersByTeam={playersByTeam}
            openPlayer={openPlayer}
            stats={stats}
            currentSeason={currentSeason}
            availableSeasons={availableSeasons}
            onSeasonChange={setCurrentSeason}
            seasonSummary={seasonSummary}
            seasonStatus={seasonStatus}
            currentRound={currentRound}
            playedRounds={_playedRounds}
            totalRounds={_totalRounds}
            totalRoundsByLeague={totalRoundsByLeague}
            playedRoundsByLeague={playedRoundsByLeague}
          />
        );
    }
  };

  // === Ekran ładowania / błędu ===
  if (dataLoading && !currentSeason) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center">
        <div className="text-center">
          <div className="w-10 h-10 border-2 border-yellow-500 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <div className="text-gray-400 text-sm">Ładowanie danych MLPN...</div>
        </div>
      </div>
    );
  }

  if (dataError && !currentSeason) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center">
        <div className="text-center max-w-md mx-auto p-6">
          <div className="text-4xl mb-4">⚠️</div>
          <div className="text-white text-lg mb-2">Błąd połączenia</div>
          <div className="text-gray-400 text-sm mb-4">{dataError}</div>
          <button
            onClick={() => window.location.reload()}
            className="px-4 py-2 bg-yellow-600 text-white rounded hover:bg-yellow-500 transition"
          >
            Spróbuj ponownie
          </button>
        </div>
      </div>
    );
  }

  return (
    <div
      className={classNames(
        "min-h-screen flex flex-col mlpn-shell",
        darkMode
          ? "mlpn-dark bg-[#0a0e1a] text-white"
          : "mlpn-light bg-gray-50 text-gray-900"
      )}
    >
      <style>{CSS}</style>

      {/* TOP NAV */}
      <nav
        className={classNames(
          "fixed inset-x-0 top-0 z-[9999] flex items-center justify-between px-4 md:px-6 py-3 border-b mlpn-topnav",
          darkMode
            ? "bg-[#0f1420] border-gray-800"
            : "bg-gradient-to-r from-[#10203e]/95 via-[#1b315c]/95 to-[#1f3f7a]/95 border-white/10"
        )}
      >
        {/* Mobile: Hamburger */}
        <button
          type="button"
          onClick={() => setMobileMenuOpen((v) => !v)}
          className={classNames(
            "md:hidden w-11 h-11 shrink-0 inline-flex items-center justify-center leading-none rounded-2xl e3d-btn",
            darkMode ? "bg-gray-800" : "bg-gray-200"
          )}
          aria-label="Toggle menu"
          aria-expanded={mobileMenuOpen}
        >
          {mobileMenuOpen ? (
            <X size={20} className="block e3d-ico" />
          ) : (
            <Menu size={20} className="block e3d-ico" />
          )}
        </button>

        {/* Logo MLPN */}
        <button
          onClick={goHome}
          className="flex items-center gap-2 md:gap-3 group"
        >
          <img
            src={darkMode ? `${PU}/logo2.png` : `${PU}/logo1.png`}
            alt="MLPN"
            className="h-8 md:h-10 w-auto e3d-logo"
          />
          <div className="text-left">
            <div className={classNames(
              "text-sm md:text-base font-bold leading-tight group-hover:underline",
              darkMode ? "text-white" : "text-white"
            )}>
              MLPN
            </div>
            <div className={classNames(
              "text-[9px] md:text-[10px]",
              darkMode ? "text-gray-400" : "text-white/70"
            )}>
              SULEJÓWEK
            </div>
          </div>
        </button>

        {/* Desktop menu + Dark toggle */}
        <div className="flex items-center gap-2">
          {/* Menu główne - tylko desktop */}
          <div className="hidden md:flex items-center gap-2">
            {[
              { label: "Strona główna", ctx: "home" },
              { label: "Turnieje", ctx: "tournaments" },
              { label: "I Liga", ctx: "1st" },
              { label: "II Liga", ctx: "2nd" },
              { label: "III Liga", ctx: "3rd" },
              { label: "Info", ctx: "info" },
            ].map((b) => {
              const has3rd = currentLeagues.some(l => l.id === '3rd');
              const isDisabled = b.ctx === '3rd' && !has3rd;
              return (
                <button
                  key={b.ctx}
                  disabled={isDisabled}
                  onClick={() => {
                    if (isDisabled) return;
                    setSelectedTeam(null);
                    setSelectedMatchId(null);
                    setActiveContext(b.ctx);
                    if (b.ctx === "home" || b.ctx === "tournaments") {
                      setActiveSection(b.ctx);
                    } else if (b.ctx === "info") {
                      setActiveSection("about");
                    } else {
                      setActiveSection("home");
                    }
                    setMobileMenuOpen(false);
                  }}
                  className={classNames(
                    "px-3 py-2 text-sm rounded e3d-tab whitespace-nowrap",
                    isDisabled
                      ? (darkMode ? "text-gray-600 opacity-40 cursor-not-allowed" : "text-white/40 opacity-70 cursor-not-allowed")
                      : activeContext === b.ctx
                      ? "text-green-400 bg-green-500/10"
                      : darkMode
                      ? "text-gray-400 hover:text-white"
                      : "text-white/85 hover:text-white hover:bg-white/5"
                  )}
                  title={isDisabled ? "III Liga nie istniała w tym sezonie" : b.label}
                >
                  {b.label}
                </button>
              );
            })}
            {user && hasAdminAccess && (
              <button
                onClick={() => {
                  setSelectedTeam(null);
                  setSelectedMatchId(null);
                  setSelectedPlayerId(null);
                  setActiveContext("admin");
                  setActiveSection("dashboard");
                  setMobileMenuOpen(false);
                }}
                className={classNames(
                  "p-2 rounded e3d-tab",
                  activeContext === "admin"
                    ? "text-yellow-400 bg-yellow-500/10"
                    : darkMode
                    ? "text-gray-500 hover:text-yellow-400"
                    : "text-white/70 hover:text-yellow-300 hover:bg-white/5"
                )}
                title="Panel admina"
              >
                <Settings size={16} />
              </button>
            )}
            {user ? (
              <button
                onClick={handleUserSignOut}
                className={classNames(
                  "p-2 rounded e3d-tab",
                  darkMode
                    ? "text-gray-500 hover:text-red-400"
                    : "text-white/70 hover:text-red-300 hover:bg-white/5"
                )}
                title="Wyloguj się"
              >
                <LogOut size={16} />
              </button>
            ) : (
              <button
                onClick={() => {
                  setSelectedTeam(null);
                  setSelectedMatchId(null);
                  setSelectedPlayerId(null);
                  setActiveContext("admin");
                  setActiveSection("dashboard");
                  setMobileMenuOpen(false);
                }}
                className={classNames(
                  "p-2 rounded e3d-tab",
                  activeContext === "admin"
                    ? "text-yellow-400 bg-yellow-500/10"
                    : darkMode
                    ? "text-gray-500 hover:text-yellow-400"
                    : "text-white/70 hover:text-yellow-300 hover:bg-white/5"
                )}
                title="Zaloguj sie"
              >
                <LogIn size={16} />
              </button>
            )}
          </div>

          {/* Dark mode toggle */}
          <button
            type="button"
            onClick={() => setDarkMode((v) => !v)}
            className={classNames(
              "w-11 h-11 shrink-0 inline-flex items-center justify-center leading-none rounded-2xl e3d-btn",
              darkMode ? "bg-gray-800" : "bg-white/10 border border-white/10 text-white hover:bg-white/15"
            )}
            aria-label="Toggle theme"
          >
            {darkMode ? (
              <Sun size={18} className="block e3d-ico" />
            ) : (
              <Moon size={18} className="block e3d-ico" />
            )}
          </button>
        </div>
      </nav>

      {/* Mobile Menu Drawer */}
      <div
        className={classNames(
          "mlpn-mobile-menu-layer md:hidden fixed inset-0 z-[10010] transition-[visibility] duration-200",
          mobileMenuOpen ? "visible" : "invisible pointer-events-none"
        )}
      >
        <button
          type="button"
          aria-label="Zamknij menu"
          onClick={() => setMobileMenuOpen(false)}
          className={classNames(
            "mlpn-mobile-menu-backdrop absolute inset-0 transition-opacity duration-200",
            mobileMenuOpen ? "opacity-100 bg-black/60 backdrop-blur-[2px]" : "opacity-0"
          )}
        />
        <div
          className={classNames(
            "mlpn-mobile-menu-panel absolute left-3 right-3 top-[78px] bottom-3 overflow-y-auto rounded-[28px] border shadow-[0_24px_80px_rgba(0,0,0,0.45)] transition-all duration-200",
            mobileMenuOpen ? "translate-y-0 opacity-100" : "-translate-y-4 opacity-0",
            darkMode
              ? "bg-[#0d1117] border-white/10"
              : "bg-gradient-to-b from-[#10203e] via-[#1b315c] to-[#1f3f7a] border-white/10"
          )}
          onClick={(e) => e.stopPropagation()}
        >
            <div
              className="px-4 py-4 border-b flex items-center justify-between gap-3"
              style={{
                borderColor: darkMode
                  ? "rgba(255,255,255,0.1)"
                  : "rgba(255,255,255,0.12)",
              }}
            >
              <div>
                <div className="text-[11px] uppercase tracking-[0.18em] text-white/65 font-bold">
                  MLPN
                </div>
                <div className="font-bold text-white">Menu</div>
              </div>
              <button
                type="button"
                onClick={() => setMobileMenuOpen(false)}
                className="w-11 h-11 rounded-2xl bg-white/10 text-white flex items-center justify-center"
                aria-label="Zamknij menu"
              >
                <X size={20} />
              </button>
            </div>

            {/* Mobile main menu */}
            <div
              className="p-4 border-b"
              style={{
                borderColor: darkMode
                  ? "rgba(255,255,255,0.1)"
                  : "rgba(255,255,255,0.12)",
              }}
            >
              <div className={classNames("font-bold mb-3", darkMode ? "text-white" : "text-white")}>Menu Główne</div>
              {[
                { label: "Strona główna", ctx: "home" },
                { label: "Turnieje", ctx: "tournaments" },
                { label: "I Liga", ctx: "1st" },
                { label: "II Liga", ctx: "2nd" },
                { label: "III Liga", ctx: "3rd" },
                { label: "Info", ctx: "info" },
              ].map((b) => {
                const has3rd = currentLeagues.some(l => l.id === '3rd');
                const isDisabled = b.ctx === '3rd' && !has3rd;
                return (
                  <button
                    key={b.ctx}
                    disabled={isDisabled}
                    onClick={() => {
                      if (isDisabled) return;
                      setSelectedTeam(null);
                      setSelectedMatchId(null);
                      setActiveContext(b.ctx);
                      if (b.ctx === "home" || b.ctx === "tournaments") {
                        setActiveSection(b.ctx);
                      } else if (b.ctx === "info") {
                        setActiveSection("about");
                      } else {
                        setActiveSection("home");
                      }
                      setMobileMenuOpen(false);
                    }}
                    className={classNames(
                      "w-full text-left px-3 py-3 rounded-xl mb-1",
                      isDisabled
                        ? (darkMode ? "text-gray-600 opacity-40 cursor-not-allowed" : "text-white/40 opacity-70 cursor-not-allowed")
                        : activeContext === b.ctx
                        ? "bg-green-500/10 text-green-400 font-bold"
                        : darkMode
                        ? "text-gray-400 hover:bg-white/5"
                        : "text-white/85 hover:bg-white/5"
                    )}
                  >
                    {b.label}
                  </button>
                );
              })}
              {user && hasAdminAccess && (
                <button
                  onClick={() => {
                    setSelectedTeam(null);
                    setSelectedMatchId(null);
                    setSelectedPlayerId(null);
                    setActiveContext("admin");
                    setActiveSection("dashboard");
                    setMobileMenuOpen(false);
                  }}
                  className={classNames(
                    "w-full text-left px-3 py-3 rounded-xl mb-1 flex items-center gap-2",
                    activeContext === "admin"
                      ? "bg-yellow-500/10 text-yellow-400 font-bold"
                      : "text-yellow-500/70 hover:bg-yellow-500/10"
                  )}
                >
                  <Settings size={14} />
                  Admin
                </button>
              )}
              {user ? (
                <button
                  onClick={handleUserSignOut}
                  className="w-full text-left px-3 py-3 rounded-xl mb-1 flex items-center gap-2 text-red-400/70 hover:bg-red-500/10"
                >
                  <LogOut size={14} />
                  Wyloguj się
                </button>
              ) : (
                <button
                  onClick={() => {
                    setSelectedTeam(null);
                    setSelectedMatchId(null);
                    setSelectedPlayerId(null);
                    setActiveContext("admin");
                    setActiveSection("dashboard");
                    setMobileMenuOpen(false);
                  }}
                  className={classNames(
                    "w-full text-left px-3 py-3 rounded-xl mb-1 flex items-center gap-2",
                    activeContext === "admin"
                      ? "bg-yellow-500/10 text-yellow-400 font-bold"
                      : "text-yellow-500/70 hover:bg-yellow-500/10"
                  )}
                >
                  <LogIn size={14} />
                  Zaloguj sie
                </button>
              )}
            </div>

            {/* Mobile sidebar menu (context-specific) */}
            {menu.length > 0 && (
              <div className="p-4">
                <div className={classNames(
                  "font-bold mb-3 text-sm",
                  darkMode ? "text-gray-400" : "text-white/65"
                )}>
                  {activeContext === "home" && "Strona główna"}
                  {activeContext === "1st" && "I Liga"}
                  {activeContext === "2nd" && "II Liga"}
                  {activeContext === "3rd" && "III Liga"}
                  {activeContext === "info" && "Informacje"}
                </div>
                {menu.map((item) => (
                  <button
                    key={item.id}
                    onClick={() => {
                      setSelectedTeam(null);
                      setSelectedMatchId(null);
                      setSelectedPlayerId(null);
                      setActiveSection(item.id);
                      setMobileMenuOpen(false);
                    }}
                    className={classNames(
                      "w-full flex items-center gap-3 px-3 py-3 rounded-xl mb-1",
                      activeSection === item.id
                        ? "bg-green-500/10 text-green-400"
                        : darkMode
                        ? "text-gray-400 hover:bg-white/5"
                        : "text-white/85 hover:bg-white/5"
                    )}
                  >
                    <span className="shrink-0">{item.icon}</span>
                    {item.label}
                  </button>
                ))}
              </div>
            )}
        </div>
      </div>

      {/* LAYOUT */}
      <div className="flex flex-1 items-start pt-[64px] md:pt-[72px]">
        {/* SIDEBAR - ukryty w trybie admin */}
        {activeContext !== "admin" && <aside
          className={classNames(
            "hidden md:flex md:flex-col md:fixed md:left-0 md:top-[72px] md:bottom-0 md:w-56 md:z-30 border-r",
            darkMode
              ? "bg-[#0d1117] border-gray-800"
              : "bg-gradient-to-b from-[#10203e]/95 via-[#1b315c]/95 to-[#1f3f7a]/95 border-white/10"
          )}
        >
          {/* Menu - scrollowalna sekcja */}
          <div className="flex-1 overflow-y-auto p-4">
            {menu.map((item) => (
              <button
                key={item.id}
                onClick={() => {
                  setSelectedTeam(null);
                  setSelectedMatchId(null);
                  setSelectedPlayerId(null); // Reset również profilu zawodnika
                  setActiveSection(item.id);
                }}
                className={classNames(
                  "w-full flex items-center gap-3 px-3 py-2 rounded mb-1 e3d-item",
                  activeSection === item.id
                    ? "bg-green-500/10 text-green-400"
                    : darkMode
                    ? "text-gray-400 hover:bg-white/5"
                    : "text-white/85 hover:bg-white/5"
                )}
              >
                <span className="shrink-0">{item.icon}</span>
                {item.label}
              </button>
            ))}
          </div>
          
          {/* Sponsor tytularny - przyklejony do dołu */}
          <div className={classNames(
            "px-4 pb-6 pt-4 border-t",
            darkMode ? "border-gray-800" : "border-white/10"
          )}>
            <div className="space-y-3">
              <div className={classNames(
                "text-[9px] font-bold tracking-wide uppercase text-center",
                darkMode ? "text-gray-500" : "text-white/55"
              )}>
                Sponsor tytularny
              </div>
              <a
                href="https://www.facebook.com/isolaristorante" 
                target="_blank"
                rel="noreferrer"
                className="block hover:opacity-80 transition-opacity"
              >
                <img
                  src={`${PU}/isola.png`}
                  alt="Isola Ristorante"
                  className="w-full h-auto object-contain"
                />
              </a>
              <div className="flex justify-center">
                <img
                  src={darkMode ? `${PU}/logo2big.webp` : `${PU}/logo1big.webp`}
                  alt="MLPN"
                  className="w-40 h-auto object-contain opacity-80"
                />
              </div>
            </div>
          </div>
        </aside>}

        {/* CONTENT */}
        <main className="flex-1 w-full min-w-0 max-w-full overflow-x-hidden p-3 sm:p-4 md:p-6 md:ml-56 md:max-w-[1600px] mx-auto">
          {/* round jump only on calendar and league context */}
          {activeContext !== "home" &&
            activeSection === "calendar" &&
            !selectedTeam &&
            !selectedMatchId && (() => {
              const maxRound = totalRoundsByLeague[activeContext] || _totalRounds;
              return (
              <div className="flex items-center gap-4 mb-4">
                <button
                  onClick={() => setRound((r) => Math.max(1, r - 1))}
                  disabled={round <= 1}
                  className={classNames(
                    "px-3 py-2 rounded e3d-btn",
                    round <= 1 ? "opacity-30 cursor-not-allowed" : "",
                    darkMode
                      ? "bg-white/5 hover:bg-white/10"
                      : "bg-black/5 hover:bg-black/10"
                  )}
                >
                  <ChevronLeft size={18} className="e3d-ico" />
                </button>
                <div className="font-semibold">Kolejka {round}</div>
                <button
                  onClick={() => setRound((r) => Math.min(maxRound, r + 1))}
                  disabled={round >= maxRound}
                  className={classNames(
                    "px-3 py-2 rounded e3d-btn",
                    round >= maxRound ? "opacity-30 cursor-not-allowed" : "",
                    darkMode
                      ? "bg-white/5 hover:bg-white/10"
                      : "bg-black/5 hover:bg-black/10"
                  )}
                >
                  <ChevronRight size={18} className="e3d-ico" />
                </button>
              </div>
              );
            })()}

          <PageRenderErrorBoundary
            darkMode={darkMode}
            resetKey={`${activeContext}:${activeSection}:${currentSeason || "no-season"}:${selectedTeam || "no-team"}:${selectedMatchId || "no-match"}:${selectedPlayerId || "no-player"}`}
          >
            <PageRenderer renderPage={renderPage} />
          </PageRenderErrorBoundary>
        </main>
      </div>

      <MatchGalleryOverlay
        darkMode={darkMode}
        overlay={galleryOverlay}
        onClose={closeGalleryOverlay}
        onIndexChange={(nextIndex) =>
          setGalleryOverlay((prev) => ({ ...prev, currentIndex: nextIndex }))
        }
      />

      {/* FOOTER */}
      <Footer
        darkMode={darkMode}
        setActiveContext={setActiveContext}
        setActiveSection={setActiveSection}
      />
    </div>
  );
}

/* =========================================
   FOOTER
   ========================================= */
function SocialBrandIcon({ brand, className = "" }) {
  const common = {
    fill: "currentColor",
    className,
    viewBox: "0 0 24 24",
    "aria-hidden": "true",
  };

  if (brand === "facebook") {
    return (
      <svg {...common}>
        <path d="M24 12.073C24 5.405 18.627 0 12 0S0 5.405 0 12.073c0 6.019 4.388 11.01 10.125 11.927v-8.438H7.078v-3.49h3.047V9.41c0-3.017 1.792-4.685 4.533-4.685 1.313 0 2.686.236 2.686.236v2.963H15.83c-1.491 0-1.956.929-1.956 1.883v2.265h3.328l-.532 3.49h-2.796V24C19.612 23.083 24 18.092 24 12.073z" />
      </svg>
    );
  }

  if (brand === "instagram") {
    return (
      <svg {...common}>
        <path d="M7.75 2h8.5A5.75 5.75 0 0 1 22 7.75v8.5A5.75 5.75 0 0 1 16.25 22h-8.5A5.75 5.75 0 0 1 2 16.25v-8.5A5.75 5.75 0 0 1 7.75 2zm0 1.75A4 4 0 0 0 3.75 7.75v8.5a4 4 0 0 0 4 4h8.5a4 4 0 0 0 4-4v-8.5a4 4 0 0 0-4-4h-8.5zm8.88 1.31a1.06 1.06 0 1 1 0 2.12 1.06 1.06 0 0 1 0-2.12zM12 6.75A5.25 5.25 0 1 1 6.75 12 5.26 5.26 0 0 1 12 6.75zm0 1.75A3.5 3.5 0 1 0 15.5 12 3.5 3.5 0 0 0 12 8.5z" />
      </svg>
    );
  }

  return (
    <svg {...common}>
      <path d="M23.5 6.2a3 3 0 0 0-2.11-2.12C19.53 3.5 12 3.5 12 3.5s-7.53 0-9.39.58A3 3 0 0 0 .5 6.2 31.2 31.2 0 0 0 0 12a31.2 31.2 0 0 0 .5 5.8 3 3 0 0 0 2.11 2.12c1.86.58 9.39.58 9.39.58s7.53 0 9.39-.58a3 3 0 0 0 2.11-2.12A31.2 31.2 0 0 0 24 12a31.2 31.2 0 0 0-.5-5.8zM9.75 15.8V8.2L16.5 12l-6.75 3.8z" />
    </svg>
  );
}

function Footer({ darkMode, setActiveContext, setActiveSection }) {
  const handleInfoClick = (tab) => {
    setActiveContext("info");
    setActiveSection(tab);
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  return (
    <footer
      className={classNames(
        "border-t mt-12",
        darkMode ? "bg-[#0d1117] border-gray-800" : "bg-white border-gray-200"
      )}
    >
      <div className="max-w-7xl mx-auto px-6 py-12">
        <div className="grid md:grid-cols-4 gap-8">
          {/* Quick Links */}
          <div>
            <h3 className="font-bold text-lg mb-4">Szybkie linki</h3>
            <ul className="space-y-2">
              <li>
                <button
                  onClick={() => handleInfoClick("about")}
                  className={classNames(
                    "hover:underline",
                    darkMode
                      ? "text-gray-400 hover:text-white"
                      : "text-gray-600 hover:text-gray-900"
                  )}
                >
                  O nas
                </button>
              </li>
              <li>
                <button
                  onClick={() => handleInfoClick("regulations")}
                  className={classNames(
                    "hover:underline",
                    darkMode
                      ? "text-gray-400 hover:text-white"
                      : "text-gray-600 hover:text-gray-900"
                  )}
                >
                  Regulamin Ligi
                </button>
              </li>
              <li>
                <button
                  onClick={() => handleInfoClick("sponsors")}
                  className={classNames(
                    "hover:underline",
                    darkMode
                      ? "text-gray-400 hover:text-white"
                      : "text-gray-600 hover:text-gray-900"
                  )}
                >
                  Sponsorzy
                </button>
              </li>
              <li>
                <button
                  onClick={() => handleInfoClick("rodo")}
                  className={classNames(
                    "hover:underline",
                    darkMode
                      ? "text-gray-400 hover:text-white"
                      : "text-gray-600 hover:text-gray-900"
                  )}
                >
                  RODO
                </button>
              </li>
              <li>
                <button
                  onClick={() => handleInfoClick("privacy")}
                  className={classNames(
                    "hover:underline",
                    darkMode
                      ? "text-gray-400 hover:text-white"
                      : "text-gray-600 hover:text-gray-900"
                  )}
                >
                  Polityka Prywatności
                </button>
              </li>
            </ul>
          </div>

          {/* Kontakt */}
          <div>
            <h3 className="font-bold text-lg mb-4">Kontakt</h3>
            <ul
              className={classNames(
                "space-y-2 text-sm",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              <li className="flex items-start gap-2">
                <span>📧</span>
                <a href="mailto:kontakt@mlpn.pl" className="hover:underline">
                  kontakt@mlpn.pl
                </a>
              </li>
              <li className="flex items-start gap-2">
                <span>📞</span>
                <a href="tel:517611687" className="hover:underline">
                  517 611 687
                </a>
              </li>
              <li className="flex items-start gap-2">
                <span>📍</span>
                <span>
                  ul. Reymonta 1<br />
                  05-070 Sulejówek
                </span>
              </li>
            </ul>
          </div>

          {/* Social Media */}
          <div>
            <h3 className="font-bold text-lg mb-4">Social Media</h3>
            <div className="flex gap-3">
              <a
                href="https://www.facebook.com/MLPN-w-Sulej%C3%B3wku-475269012595910/"
                target="_blank"
                rel="noreferrer"
                className={classNames(
                  "w-12 h-12 rounded-full flex items-center justify-center transition-transform hover:scale-110 text-[#1877F2]",
                  darkMode
                    ? "bg-blue-500/20 hover:bg-blue-500/30"
                    : "bg-blue-100 hover:bg-blue-200"
                )}
                title="Facebook"
              >
                <SocialBrandIcon brand="facebook" className="w-5 h-5" />
              </a>
              <a
                href="https://www.instagram.com/mlpn_sulejowek/"
                target="_blank"
                rel="noreferrer"
                className={classNames(
                  "w-12 h-12 rounded-full flex items-center justify-center text-2xl transition-transform hover:scale-110 text-[#E4405F]",
                  darkMode
                    ? "bg-pink-500/20 hover:bg-pink-500/30"
                    : "bg-pink-100 hover:bg-pink-200"
                )}
                title="Instagram"
              >
                <SocialBrandIcon brand="instagram" className="w-5 h-5" />
              </a>
              <a
                href="https://www.youtube.com/@MLPN_YT"
                target="_blank"
                rel="noreferrer"
                className={classNames(
                  "w-12 h-12 rounded-full flex items-center justify-center text-2xl transition-transform hover:scale-110 text-[#FF0033]",
                  darkMode
                    ? "bg-red-500/20 hover:bg-red-500/30"
                    : "bg-red-100 hover:bg-red-200"
                )}
                title="YouTube"
              >
                <SocialBrandIcon brand="youtube" className="w-5 h-5" />
              </a>
            </div>
            <button
              onClick={() => handleInfoClick("contact")}
              className={classNames(
                "mt-4 text-sm font-bold hover:underline",
                darkMode ? "text-green-400" : "text-green-600"
              )}
            >
              Formularz kontaktowy →
            </button>
          </div>

          {/* Logo i informacje */}
          <div>
            <div className="flex items-center gap-2 mb-4">
              <img
                src={darkMode ? `${PU}/logo2.png` : `${PU}/logo1.png`}
                alt="MLPN"
                className="h-12 w-auto"
              />
              <div>
                <div className="font-bold">MLPN</div>
                <div className="text-xs text-gray-400">Sulejówek</div>
              </div>
            </div>
            <p
              className={classNames(
                "text-xs leading-relaxed",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              Miejska Liga Piłki Nożnej w Sulejówku - promujemy lokalny sport i
              integrujemy społeczność od 2018 roku.
            </p>
          </div>
        </div>

        {/* Bottom bar */}
        <div
          className={classNames(
            "mt-8 pt-8 border-t text-center text-sm",
            darkMode
              ? "border-gray-800 text-gray-400"
              : "border-gray-200 text-gray-600"
          )}
        >
          <p>
            © {new Date().getFullYear()} Stowarzyszenie Liga Miejska. Wszystkie
            prawa zastrzeżone.
          </p>
          <p className="mt-2 text-xs">
            KRS 000022287 | ul. Reymonta 1, 05-070 Sulejówek
          </p>
        </div>
      </div>
    </footer>
  );
}

/* =========================================
   PAGES / COMPONENTS (w jednym pliku)
   ========================================= */

function Card({ darkMode, children, className = "" }) {
  return (
    <div
      className={classNames(
        "p-4 rounded-2xl border",
        darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200",
        "e3d-card",
        className
      )}
    >
      {children}
    </div>
  );
}

function BackHeader({ darkMode, title, onBack }) {
  return (
    <div className="flex items-center gap-3">
      <button
        onClick={onBack}
        className={classNames(
          "px-3 py-2 rounded e3d-btn",
          darkMode
            ? "bg-white/5 hover:bg-white/10"
            : "bg-black/5 hover:bg-black/10"
        )}
      >
        <ArrowLeft size={18} className="e3d-ico" />
      </button>
      <div>
        <div className="text-2xl font-extrabold">{title}</div>
        <div
          className={classNames(
            "text-sm",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Wszystko klikalne – to jest testowa baza
        </div>
      </div>
    </div>
  );
}

function LeagueHomePage({
  darkMode,
  leagueId,
  leagueName,
  table,
  matches,
  fixtures,
  openTeam,
  openMatch,
  openGallery,
  expandedMatchId,
  matchById,
  playersByTeam,
  openPlayer,
  stats,
  currentSeason,
  availableSeasons,
  onSeasonChange,
  seasonSummary,
  seasonStatus,
  currentRound,
  playedRounds,
  totalRounds,
  totalRoundsByLeague,
  playedRoundsByLeague,
}) {
  const isArchived = seasonStatus === 'completed';
  const isExcludedFromUpcoming = (status) =>
    status === "cancelled" || status === "unplayed" || status === "postponed";
  const leagueTotalRounds = totalRoundsByLeague?.[leagueId] || totalRounds;
  const leaguePlayedRounds = playedRoundsByLeague?.[leagueId] || playedRounds;

  // Znajdź najbliższy NIEZAGRANY mecz
  const upcomingMatch = useMemo(() => {
    if (isArchived) return null;
    // Jeśli wszystkie kolejki w tej lidze rozegrane — brak upcoming
    if (leaguePlayedRounds >= leagueTotalRounds && leagueTotalRounds > 0) return null;
    // Filtruj mecze które NIE zostały jeszcze rozegrane
    const upcoming = fixtures
      .filter((f) => f.league === leagueId && !matchById[f.id])
      .filter((f) => !isExcludedFromUpcoming(f.status))
      .sort((a, b) => {
        // null daty na koniec (sortuj jako 'zzzz')
        const dateCompare = (a.date || 'zzzz').localeCompare(b.date || 'zzzz');
        if (dateCompare !== 0) return dateCompare;
        return a.round - b.round;
      });
    return upcoming[0] || null;
  }, [fixtures, leagueId, isArchived, matchById, leaguePlayedRounds, leagueTotalRounds]);

  const upcomingPlayedMatch = upcomingMatch
    ? matchById[upcomingMatch.id]
    : null;
  const isUpcomingExpanded =
    upcomingMatch && expandedMatchId === upcomingMatch.id;

  // Ostatnie rozegrane mecze w tej lidze
  const recentMatches = useMemo(() => {
    return matches
      .filter((m) => m.league === leagueId)
      .sort((a, b) => b.round - a.round)
      .slice(0, 6);
  }, [matches, leagueId]);

  // Tabela - wszystkie drużyny (bez limitu)
  const simpleTable = table;

  // Podsumowanie sezonu dla sezonów archiwalnych
  const leagueSummary = seasonSummary?.[leagueId];

  // Najlepsi zawodnicy dla sezonów archiwalnych
  const seasonBest = useMemo(() => {
    if (!isArchived || !stats) return null;
    
    // Tylko zawodnicy z tej ligi
    const allPlayers = Object.values(stats.playerStats).filter(p => {
      const team = p.team;
      const teamInLeague = table.find(t => t.team === team);
      return !!teamInLeague;
    });
    
    if (allPlayers.length === 0) return null;
    
    // MVP - najwyższa suma punktów (gole*3 + asysty*2 - żółte - czerwone*3)
    const mvp = [...allPlayers]
      .map(p => ({ 
        ...p, 
        score: p.goals * 3 + p.assists * 2 - p.yellow - p.red * 3 
      }))
      .sort((a, b) => b.score - a.score)[0];
    
    // Król strzelców - najwięcej goli
    const topScorer = [...allPlayers]
      .sort((a, b) => b.goals - a.goals)[0];
    
    // Najlepszy asystent - najwięcej asyst
    const topAssister = [...allPlayers]
      .sort((a, b) => b.assists - a.assists)[0];
    
    // Najlepszy bramkarz - GK z najmniej straconymi bramkami
    const goalkeepers = allPlayers.filter(p => {
      // Znajdź zawodnika w playersByTeam
      const teamPlayers = playersByTeam[p.team] || [];
      const player = teamPlayers.find(pl => pl.id === p.playerId);
      return player && player.pos === "GK";
    });
    
    const topGoalkeeper = goalkeepers.length > 0 ? [...goalkeepers]
      .map(p => ({
        ...p,
        goalsAgainst: stats.teamStats[p.team]?.ga || 999
      }))
      .sort((a, b) => a.goalsAgainst - b.goalsAgainst)[0] : null;
    
    return { mvp, topScorer, topAssister, topGoalkeeper };
  }, [isArchived, stats, table, playersByTeam]);

  // Funkcja określająca kolor tła dla pozycji
  const getPositionBg = (pos) => {
    const tableLength = table.length;
    const lastPos = tableLength; // ostatnie miejsce
    const secondLastPos = tableLength - 1; // przedostatnie miejsce

    // I Liga: spadek z ostatnich 2 miejsc (czerwone)
    if (leagueId === "1st") {
      if (pos >= secondLastPos)
        return darkMode ? "bg-red-500/20" : "bg-red-100";
    }
    // II Liga: awans miejsca 1-2 (zielone), spadek ostatnie 2 miejsca (czerwone)
    if (leagueId === "2nd") {
      if (pos <= 2) return darkMode ? "bg-green-500/20" : "bg-green-100";
      if (pos >= secondLastPos)
        return darkMode ? "bg-red-500/20" : "bg-red-100";
    }
    // III Liga: awans miejsca 1-2 (zielone)
    if (leagueId === "3rd") {
      if (pos <= 2) return darkMode ? "bg-green-500/20" : "bg-green-100";
    }
    return "";
  };

  return (
    <div className="space-y-4">
      <div className="flex flex-col items-start gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <div className="text-xl sm:text-2xl font-extrabold">{leagueName}</div>
          <div
            className={classNames(
              "text-sm leading-snug",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            Sezon {leaguePlayedRounds}/{leagueTotalRounds} kolejek
          </div>
        </div>
        <div className="w-full sm:w-auto self-stretch sm:self-auto">
          <SeasonNavigation
            currentSeason={currentSeason}
            availableSeasons={availableSeasons}
            onSeasonChange={onSeasonChange}
            darkMode={darkMode}
            minSeason={leagueId === '3rd' ? 2007 : undefined}
          />
        </div>
      </div>

      {/* WIDOK ARCHIWALNY SEZONU - Tabela + Kafle */}
      {isArchived && (
        <div className="grid lg:grid-cols-2 gap-4">
          {/* LEWA STRONA: Tabela ze szczegółowymi statystykami */}
          <Card darkMode={darkMode}>
            <div className="font-extrabold mb-3 text-lg">Tabela końcowa sezonu {currentSeason}</div>

            <MobileLeagueScrollableTable
              rows={table}
              darkMode={darkMode}
              openTeam={openTeam}
              showForm={false}
              getRowBg={getPositionBg}
            />

            {/* Nagłówki kolumn - bez Formy */}
            <div
              className={classNames(
                "hidden md:block px-2 pb-2 text-[10px] font-bold",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              <div className="grid grid-cols-[30px_30px_1fr_35px_35px_35px_35px_45px_45px_40px] gap-1 items-center">
                <div className="text-center">#</div>
                <div></div>
                <div>Drużyna</div>
                <div className="text-center">M</div>
                <div className="text-center">W</div>
                <div className="text-center">R</div>
                <div className="text-center">P</div>
                <div className="text-center">B+</div>
                <div className="text-center">B-</div>
                <div className="text-center">PKT</div>
              </div>
            </div>

            <div className="space-y-1">
              {table.map((r) => (
                <div
                  key={r.team}
                  className={classNames(
                    "hidden md:block p-1.5 rounded-lg border",
                    getPositionBg(r.pos),
                    darkMode
                      ? "border-white/10 bg-black/10 hover:bg-white/5"
                      : "border-gray-200 bg-gray-50 hover:bg-white"
                  )}
                >
                  <div className="grid grid-cols-[30px_30px_1fr_35px_35px_35px_35px_45px_45px_40px] gap-1 items-center text-xs">
                    <div className="text-center font-extrabold">
                      {r.pos}
                    </div>
                    <TeamLogo
                      team={r.team}
                      darkMode={darkMode}
                      size={24}
                      onClick={() => openTeam(r.team)}
                    />
                    <button
                      onClick={() => openTeam(r.team)}
                      className="font-bold hover:underline truncate text-left min-w-0 block w-full"
                    >
                      {displayTeamName(r.team)}
                    </button>
                    <div className="text-center">{r.played}</div>
                    <div className="text-center">{r.win}</div>
                    <div className="text-center">{r.draw}</div>
                    <div className="text-center">{r.loss}</div>
                    <div className="text-center font-semibold">{r.gf}</div>
                    <div className="text-center">{r.ga}</div>
                    <div className="text-center font-black">{r.pts}</div>
                  </div>
                </div>
              ))}
            </div>
          </Card>

          {/* PRAWA STRONA: Kafle wyróżnień */}
          <div className="space-y-3">
            {/* DRUŻYNY - 4 kafle w siatce 2x2 */}
            <div className="grid grid-cols-2 gap-3">
              {/* MISTRZ (1 miejsce) */}
              {table[0] && (
                <Card
                  darkMode={darkMode}
                  className={classNames(
                    "p-4 text-center relative overflow-hidden border-2",
                    darkMode ? "bg-gradient-to-b from-yellow-500/15 to-transparent border-yellow-500/40" : "bg-gradient-to-b from-yellow-100 to-yellow-50 border-yellow-400/50"
                  )}
                >
                  <div className="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-1/2 w-32 h-32 rounded-full bg-yellow-500/10 blur-2xl pointer-events-none" />
                  <div className={classNames(
                    "font-black text-xs mb-3 flex items-center justify-center gap-1",
                    darkMode ? "text-yellow-400" : "text-yellow-600"
                  )}>
                    <Trophy size={14} strokeWidth={2.5} />
                    MISTRZ
                  </div>
                  <div className="relative">
                    <div className={classNames(
                      "absolute inset-0 rounded-full blur-lg",
                      darkMode ? "bg-yellow-500/20" : "bg-yellow-400/20"
                    )} style={{ transform: 'scale(1.2)' }} />
                    <TeamLogo
                      team={table[0].team}
                      darkMode={darkMode}
                      size={80}
                      onClick={() => openTeam(table[0].team)}
                      className="relative z-10 mx-auto mb-3 drop-shadow-[0_0_16px_rgba(234,179,8,0.3)] hover:scale-110 transition-transform cursor-pointer"
                    />
                  </div>
                  <button
                    onClick={() => openTeam(table[0].team)}
                    className="font-bold text-sm hover:underline"
                  >
                    {displayTeamName(table[0].team)}
                  </button>
                </Card>
              )}

              {/* 2 MIEJSCE (awans) */}
              {table[1] && leagueId !== "1st" && (
                <Card 
                  darkMode={darkMode}
                  className={classNames(
                    "p-4 text-center relative overflow-hidden",
                    darkMode ? "bg-green-500/10 border-green-500/30" : "bg-green-50 border-green-200"
                  )}
                >
                  <div className={classNames(
                    "font-black text-xs mb-3 flex items-center justify-center gap-1",
                    darkMode ? "text-green-400" : "text-green-700"
                  )}>
                    <span className="text-lg">↑</span>
                    AWANS
                  </div>
                  <div className="relative">
                    <TeamLogo
                      team={table[1].team}
                      darkMode={darkMode}
                      size={80}
                      onClick={() => openTeam(table[1].team)}
                      className="mx-auto mb-3 drop-shadow-[0_8px_16px_rgba(0,0,0,0.3)] hover:scale-110 transition-transform cursor-pointer"
                    />
                  </div>
                  <button
                    onClick={() => openTeam(table[1].team)}
                    className="font-bold text-sm hover:underline"
                  >
                    {displayTeamName(table[1].team)}
                  </button>
                </Card>
              )}

              {/* PRZEDOSTATNIE MIEJSCE (spadek) */}
              {table.length >= 2 && table[table.length - 2] && leagueId !== "3rd" && (
                <Card 
                  darkMode={darkMode}
                  className={classNames(
                    "p-4 text-center relative overflow-hidden",
                    darkMode ? "bg-red-500/10 border-red-500/30" : "bg-red-50 border-red-200"
                  )}
                >
                  <div className={classNames(
                    "font-black text-xs mb-3 flex items-center justify-center gap-1",
                    darkMode ? "text-red-400" : "text-red-700"
                  )}>
                    <span className="text-lg">↓</span>
                    SPADEK
                  </div>
                  <div className="relative">
                    <TeamLogo
                      team={table[table.length - 2].team}
                      darkMode={darkMode}
                      size={80}
                      onClick={() => openTeam(table[table.length - 2].team)}
                      className="mx-auto mb-3 drop-shadow-[0_8px_16px_rgba(0,0,0,0.3)] hover:scale-110 transition-transform cursor-pointer"
                    />
                  </div>
                  <button
                    onClick={() => openTeam(table[table.length - 2].team)}
                    className="font-bold text-sm hover:underline"
                  >
                    {displayTeamName(table[table.length - 2].team)}
                  </button>
                </Card>
              )}

              {/* OSTATNIE MIEJSCE (spadek) */}
              {table.length >= 1 && table[table.length - 1] && leagueId !== "3rd" && (
                <Card 
                  darkMode={darkMode}
                  className={classNames(
                    "p-4 text-center relative overflow-hidden",
                    darkMode ? "bg-red-500/10 border-red-500/30" : "bg-red-50 border-red-200"
                  )}
                >
                  <div className={classNames(
                    "font-black text-xs mb-3 flex items-center justify-center gap-1",
                    darkMode ? "text-red-400" : "text-red-700"
                  )}>
                    <span className="text-lg">↓</span>
                    SPADEK
                  </div>
                  <div className="relative">
                    <TeamLogo
                      team={table[table.length - 1].team}
                      darkMode={darkMode}
                      size={80}
                      onClick={() => openTeam(table[table.length - 1].team)}
                      className="mx-auto mb-3 drop-shadow-[0_8px_16px_rgba(0,0,0,0.3)] hover:scale-110 transition-transform cursor-pointer"
                    />
                  </div>
                  <button
                    onClick={() => openTeam(table[table.length - 1].team)}
                    className="font-bold text-sm hover:underline"
                  >
                    {displayTeamName(table[table.length - 1].team)}
                  </button>
                </Card>
              )}
            </div>

            {/* ZAWODNICY - 4 kafle w siatce 2x2 */}
            {seasonBest && (
              <div className="grid grid-cols-2 gap-3">
                {/* MVP SEZONU */}
                {seasonBest.mvp && (
                  <Card darkMode={darkMode} className="p-4 text-center">
                    <div className="font-black text-xs mb-2">⭐ MVP SEZONU</div>
                    <div className={classNames(
                      "w-20 h-20 rounded-full mx-auto mb-2 flex items-center justify-center text-3xl font-black",
                      darkMode ? "bg-white/10" : "bg-gray-200"
                    )}>
                      {seasonBest.mvp.name.charAt(0)}
                    </div>
                    <div className="font-bold text-sm">
                      {seasonBest.mvp.name.split(' ')[0].charAt(0)}. {seasonBest.mvp.name.split(' ').slice(1).join(' ')}
                    </div>
                    <div className="flex items-center gap-1 text-xs justify-center mt-1">
                      <span className={darkMode ? "text-gray-400" : "text-gray-600"}>
                        {displayTeamName(seasonBest.mvp.team)}
                      </span>
                      <TeamLogo
                        team={seasonBest.mvp.team}
                        darkMode={darkMode}
                        size={16}
                      />
                    </div>
                    <div className={classNames(
                      "text-[10px] mt-2",
                      darkMode ? "text-gray-500" : "text-gray-500"
                    )}>
                      {seasonBest.mvp.goals}G {seasonBest.mvp.assists}A
                    </div>
                  </Card>
                )}

                {/* KRÓL STRZELCÓW */}
                {seasonBest.topScorer && (
                  <Card darkMode={darkMode} className="p-4 text-center">
                    <div className="font-black text-xs mb-2">⚽ KRÓL STRZELCÓW</div>
                    <div className={classNames(
                      "w-20 h-20 rounded-full mx-auto mb-2 flex items-center justify-center text-3xl font-black",
                      darkMode ? "bg-white/10" : "bg-gray-200"
                    )}>
                      {seasonBest.topScorer.name.charAt(0)}
                    </div>
                    <div className="font-bold text-sm">
                      {seasonBest.topScorer.name.split(' ')[0].charAt(0)}. {seasonBest.topScorer.name.split(' ').slice(1).join(' ')}
                    </div>
                    <div className="flex items-center gap-1 text-xs justify-center mt-1">
                      <span className={darkMode ? "text-gray-400" : "text-gray-600"}>
                        {displayTeamName(seasonBest.topScorer.team)}
                      </span>
                      <TeamLogo
                        team={seasonBest.topScorer.team}
                        darkMode={darkMode}
                        size={16}
                      />
                    </div>
                    <div className={classNames(
                      "text-[10px] mt-2 font-bold",
                      darkMode ? "text-green-400" : "text-green-600"
                    )}>
                      {seasonBest.topScorer.goals} GOLI
                    </div>
                  </Card>
                )}

                {/* NAJLEPSZY ASYSTENT */}
                {seasonBest.topAssister && (
                  <Card darkMode={darkMode} className="p-4 text-center">
                    <div className="font-black text-xs mb-2">🎯 ASYSTENT</div>
                    <div className={classNames(
                      "w-20 h-20 rounded-full mx-auto mb-2 flex items-center justify-center text-3xl font-black",
                      darkMode ? "bg-white/10" : "bg-gray-200"
                    )}>
                      {seasonBest.topAssister.name.charAt(0)}
                    </div>
                    <div className="font-bold text-sm">
                      {seasonBest.topAssister.name.split(' ')[0].charAt(0)}. {seasonBest.topAssister.name.split(' ').slice(1).join(' ')}
                    </div>
                    <div className="flex items-center gap-1 text-xs justify-center mt-1">
                      <span className={darkMode ? "text-gray-400" : "text-gray-600"}>
                        {displayTeamName(seasonBest.topAssister.team)}
                      </span>
                      <TeamLogo
                        team={seasonBest.topAssister.team}
                        darkMode={darkMode}
                        size={16}
                      />
                    </div>
                    <div className={classNames(
                      "text-[10px] mt-2 font-bold",
                      darkMode ? "text-blue-400" : "text-blue-600"
                    )}>
                      {seasonBest.topAssister.assists} ASYST
                    </div>
                  </Card>
                )}

                {/* NAJLEPSZY BRAMKARZ */}
                {seasonBest.topGoalkeeper && (
                  <Card darkMode={darkMode} className="p-4 text-center">
                    <div className="font-black text-xs mb-2">🧤 BRAMKARZ</div>
                    <div className={classNames(
                      "w-20 h-20 rounded-full mx-auto mb-2 flex items-center justify-center text-3xl font-black",
                      darkMode ? "bg-white/10" : "bg-gray-200"
                    )}>
                      {seasonBest.topGoalkeeper.name.charAt(0)}
                    </div>
                    <div className="font-bold text-sm">
                      {seasonBest.topGoalkeeper.name.split(' ')[0].charAt(0)}. {seasonBest.topGoalkeeper.name.split(' ').slice(1).join(' ')}
                    </div>
                    <div className="flex items-center gap-1 text-xs justify-center mt-1">
                      <span className={darkMode ? "text-gray-400" : "text-gray-600"}>
                        {displayTeamName(seasonBest.topGoalkeeper.team)}
                      </span>
                      <TeamLogo
                        team={seasonBest.topGoalkeeper.team}
                        darkMode={darkMode}
                        size={16}
                      />
                    </div>
                    <div className={classNames(
                      "text-[10px] mt-2 font-bold",
                      darkMode ? "text-yellow-400" : "text-yellow-600"
                    )}>
                      {seasonBest.topGoalkeeper.goalsAgainst} STRACONYCH
                    </div>
                  </Card>
                )}
              </div>
            )}
          </div>
        </div>
      )}

      {/* Karta mistrza gdy wszystkie mecze rozegrane i brak nadchodzącego */}
      {!isArchived && !upcomingMatch && leaguePlayedRounds >= leagueTotalRounds && table[0] && (
        <div
          className={classNames(
            "relative overflow-hidden rounded-2xl border-2 p-8 text-center e3d-card",
            darkMode
              ? "bg-gradient-to-b from-yellow-500/20 via-yellow-500/5 to-transparent border-yellow-500/50"
              : "bg-gradient-to-b from-yellow-100 via-yellow-50 to-white border-yellow-400/60"
          )}
        >
          {/* Złote dekoracyjne kółka w tle */}
          <div className="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-1/2 w-64 h-64 rounded-full bg-yellow-500/10 blur-3xl pointer-events-none" />

          <div className={classNames(
            "flex items-center justify-center gap-2 font-black text-sm tracking-widest mb-5",
            darkMode ? "text-yellow-400" : "text-yellow-600"
          )}>
            <Trophy size={20} strokeWidth={2.5} />
            <span>MISTRZ — {leagueName} {currentSeason}</span>
            <Trophy size={20} strokeWidth={2.5} />
          </div>

          <div className="relative inline-block">
            <div className={classNames(
              "absolute inset-0 rounded-full blur-xl",
              darkMode ? "bg-yellow-500/30" : "bg-yellow-400/30"
            )} style={{ transform: 'scale(1.3)' }} />
            <TeamLogo
              team={table[0].team}
              darkMode={darkMode}
              size={128}
              onClick={() => openTeam(table[0].team)}
              className="relative z-10 drop-shadow-[0_0_24px_rgba(234,179,8,0.4)] hover:scale-110 transition-transform cursor-pointer"
            />
          </div>

          <button
            onClick={() => openTeam(table[0].team)}
            className="font-black text-3xl mt-4 hover:underline block mx-auto tracking-tight"
          >
            {displayTeamName(table[0].team)}
          </button>

          <div className={classNames(
            "text-lg font-semibold mt-2",
            darkMode ? "text-yellow-400" : "text-yellow-600"
          )}>
            {table[0].pts} pkt • {table[0].win}W {table[0].draw}R {table[0].loss}P • {table[0].gf}:{table[0].ga}
          </div>
        </div>
      )}

      {/* Kafel najbliższego spotkania */}
      {upcomingMatch && (
        <>
          <Card
            darkMode={darkMode}
            className="p-3 sm:p-4"
          >
            <div className={classNames(
              "font-black text-xs sm:text-sm mb-2",
              darkMode ? "text-blue-300" : "text-blue-700"
            )}>
              NAJBLIŻSZE SPOTKANIE
            </div>

            <div className="hidden sm:grid grid-cols-[60px_minmax(0,1fr)_auto_minmax(0,1fr)_60px] gap-3 items-center">
              <TeamLogo
                team={upcomingMatch.home}
                darkMode={darkMode}
                size={60}
                onClick={() => openTeam(upcomingMatch.home)}
              />

              <div className="font-extrabold text-xl truncate">
                <TeamLink
                  team={displayTeamName(upcomingMatch.home)}
                  onClick={() => openTeam(upcomingMatch.home)}
                  className="e3d-link"
                />
              </div>

              <div className="flex items-center gap-2 justify-center flex-shrink-0">
                <VideoIcon
                  darkMode={darkMode}
                  videoUrl={
                    upcomingPlayedMatch?.videoUrl || upcomingMatch.videoUrl
                  }
                  played={!!upcomingPlayedMatch}
                  galleryUrl={upcomingPlayedMatch?.galleryUrl || upcomingMatch.galleryUrl}
                  hasGallery={!!(upcomingPlayedMatch?.hasGallery || upcomingMatch.hasGallery)}
                  galleryCount={upcomingPlayedMatch?.galleryCount || upcomingMatch.galleryCount || 0}
                  onOpenGallery={
                    upcomingPlayedMatch?.hasGallery || upcomingMatch.hasGallery
                      ? () => openGallery?.(upcomingPlayedMatch || upcomingMatch)
                      : undefined
                  }
                  size={18}
                />
                <button
                  onClick={() => openMatch(upcomingMatch.id)}
                  className={classNames(
                    "px-6 py-3 rounded-2xl border font-black text-xl e3d-pill whitespace-nowrap",
                    darkMode
                      ? "bg-white/5 border-white/10 hover:bg-white/10"
                      : "bg-black/5 border-black/10 hover:bg-black/10"
                  )}
                  title="Kliknij aby rozwinąć szczegóły"
                >
                  {upcomingMatch.date || "Termin do ustalenia"}
                </button>
              </div>

              <div className="font-extrabold text-xl text-right truncate">
                <TeamLink
                  team={displayTeamName(upcomingMatch.away)}
                  onClick={() => openTeam(upcomingMatch.away)}
                  className="e3d-link"
                />
              </div>

              <TeamLogo
                team={upcomingMatch.away}
                darkMode={darkMode}
                size={60}
                onClick={() => openTeam(upcomingMatch.away)}
              />
            </div>

            <div className="sm:hidden space-y-2">
              <div className="grid grid-cols-[24px_minmax(0,1fr)_auto] gap-x-2 items-center">
                <TeamLogo
                  team={upcomingMatch.home}
                  darkMode={darkMode}
                  size={24}
                  onClick={() => openTeam(upcomingMatch.home)}
                />
                <button
                  onClick={() => openTeam(upcomingMatch.home)}
                  className="font-extrabold text-[12px] truncate text-left hover:underline min-w-0"
                >
                  {displayTeamName(upcomingMatch.home)}
                </button>
                <button
                  onClick={() => openMatch(upcomingMatch.id)}
                  className={classNames(
                    "min-w-[98px] px-2.5 py-2 rounded-xl border font-black text-[11px] text-center e3d-pill whitespace-nowrap",
                    darkMode
                      ? "bg-white/5 border-white/10 hover:bg-white/10"
                      : "bg-black/5 border-black/10 hover:bg-black/10"
                  )}
                  title="Kliknij aby rozwinąć szczegóły"
                >
                  {upcomingMatch.date || "Termin"}
                </button>
              </div>

              <div className="grid grid-cols-[24px_minmax(0,1fr)_auto] gap-x-2 items-center">
                <TeamLogo
                  team={upcomingMatch.away}
                  darkMode={darkMode}
                  size={24}
                  onClick={() => openTeam(upcomingMatch.away)}
                />
                <button
                  onClick={() => openTeam(upcomingMatch.away)}
                  className="font-extrabold text-[12px] truncate text-left hover:underline min-w-0"
                >
                  {displayTeamName(upcomingMatch.away)}
                </button>
                <div className="min-w-[98px] flex items-center justify-center gap-2">
                  <div className={classNames("text-[11px] font-semibold", darkMode ? "text-gray-300" : "text-gray-700")}>
                    {upcomingMatch.time || "--:--"}
                  </div>
                  <VideoIcon
                    darkMode={darkMode}
                    videoUrl={
                      upcomingPlayedMatch?.videoUrl || upcomingMatch.videoUrl
                    }
                    played={!!upcomingPlayedMatch}
                    galleryUrl={upcomingPlayedMatch?.galleryUrl || upcomingMatch.galleryUrl}
                    hasGallery={!!(upcomingPlayedMatch?.hasGallery || upcomingMatch.hasGallery)}
                    galleryCount={upcomingPlayedMatch?.galleryCount || upcomingMatch.galleryCount || 0}
                    onOpenGallery={
                      upcomingPlayedMatch?.hasGallery || upcomingMatch.hasGallery
                        ? () => openGallery?.(upcomingPlayedMatch || upcomingMatch)
                        : undefined
                    }
                    size={14}
                  />
                </div>
              </div>
            </div>

            <div
              className={classNames(
                "mt-2 text-[11px] text-center",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              Kolejka {upcomingMatch.round}
            </div>
          </Card>

          {isUpcomingExpanded && (
            <div id={`details-${upcomingMatch.id}`}>
              {upcomingPlayedMatch ? (
                <MatchDetailsInline
                  darkMode={darkMode}
                  match={upcomingPlayedMatch}
                  openTeam={openTeam}
                  openPlayer={openPlayer}
                  openGallery={openGallery}
                />
              ) : (
                <UpcomingMatchDetailsInline
                  darkMode={darkMode}
                  fixture={upcomingMatch}
                  stats={stats}
                  matches={matches}
                  playersByTeam={playersByTeam}
                  openTeam={openTeam}
                  openPlayer={openPlayer}
                />
              )}
            </div>
          )}
        </>
      )}

      {/* WIDOK AKTUALNEGO SEZONU - Tabela + Ostatnie mecze */}
      {!isArchived && (
        <div className="grid lg:grid-cols-2 gap-4">
        {/* Lewa strona: Tabela */}
        <Card darkMode={darkMode}>
          <div className="font-extrabold mb-3 text-lg">Tabela ligowa</div>

          <MobileLeagueScrollableTable
            rows={simpleTable}
            darkMode={darkMode}
            openTeam={openTeam}
            showForm
            getRowBg={getPositionBg}
          />

          {/* Nagłówki kolumn */}
          <div
            className={classNames(
              "hidden md:block px-2 pb-2 text-xs font-bold",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            <div className="grid grid-cols-[40px_40px_1fr_60px_100px] gap-2 items-center">
              <div className="text-center">#</div>
              <div></div>
              <div>Drużyna</div>
              <div className="text-right">Pkt</div>
              <div className="text-center">Forma</div>
            </div>
          </div>

          <div className="space-y-2">
            {simpleTable.map((r) => (
              <div
                key={r.team}
                className={classNames(
                  "hidden md:block p-2 rounded-xl border",
                  getPositionBg(r.pos),
                  darkMode
                    ? "border-white/10 bg-black/10 hover:bg-white/5"
                    : "border-gray-200 bg-gray-50 hover:bg-white"
                )}
              >
                <div className="grid grid-cols-[40px_40px_1fr_60px_100px] gap-2 items-center">
                  <div className="text-center font-extrabold text-sm">
                    {r.pos}
                  </div>
                  <TeamLogo
                    team={r.team}
                    darkMode={darkMode}
                    size={36}
                    onClick={() => openTeam(r.team)}
                  />
                  <button
                    onClick={() => openTeam(r.team)}
                    className="font-bold hover:underline truncate text-sm text-left min-w-0 block w-full"
                  >
                    {displayTeamName(r.team)}
                  </button>
                  <div className="font-black text-lg text-right">{r.pts}</div>
                  <div className="flex gap-1 justify-center">
                    {(r.form5 || []).map((f, i) => (
                      <FormDot
                        key={i}
                        v={f.result}
                        title={`${f.score} ${displayTeamName(f.opponent)}`}
                      />
                    ))}
                    {r.nextOpponent && (
                      <FormDot v="?" title={`Następny mecz: ${displayTeamName(r.nextOpponent)}`} />
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </Card>

        {/* Prawa strona: Ostatnie mecze */}
        <Card darkMode={darkMode}>
          <div className="font-extrabold mb-3 text-lg">Ostatnie spotkania</div>
          <div className="space-y-2">
            {recentMatches.map((m) => {
              const isExpanded = expandedMatchId === m.id;
              return (
                <React.Fragment key={m.id}>
                  <div
                    className={classNames(
                      "p-2 rounded-xl border",
                      darkMode
                        ? "border-white/10 bg-black/10"
                        : "border-gray-200 bg-gray-50"
                    )}
                  >
                    <div className="grid grid-cols-[minmax(0,1fr)_240px_minmax(0,1fr)] gap-2 items-center">
                      <div className="flex items-center gap-2 justify-start min-w-0">
                        <TeamLogo
                          team={m.home}
                          darkMode={darkMode}
                          size={32}
                          onClick={() => openTeam(m.home)}
                        />
                        <button
                          onClick={() => openTeam(m.home)}
                          className="font-bold hover:underline truncate text-sm min-w-0"
                        >
                          {displayTeamName(m.home)}
                        </button>
                      </div>

                      <div className="flex items-center justify-center gap-2 min-w-0">
                        <VideoIcon
                          darkMode={darkMode}
                          videoUrl={m.videoUrl}
                          played={true}
                          galleryUrl={m.galleryUrl}
                          hasGallery={m.hasGallery}
                          galleryCount={m.galleryCount}
                          onOpenGallery={m.hasGallery ? () => openGallery?.(m) : undefined}
                          size={14}
                        />
                        <div className="justify-self-center">
                          <ScorePill
                            homeGoals={m.homeGoals}
                            awayGoals={m.awayGoals}
                            darkMode={darkMode}
                            onClick={() => openMatch(m.id)}
                            date={m.date}
                            time={m.time}
                            status={m.status}
                          />
                        </div>
                      </div>

                      <div className="flex items-center gap-2 justify-end min-w-0">
                        <button
                          onClick={() => openTeam(m.away)}
                          className="font-bold hover:underline truncate text-sm text-right min-w-0"
                        >
                          {displayTeamName(m.away)}
                        </button>
                        <TeamLogo
                          team={m.away}
                          darkMode={darkMode}
                          size={32}
                          onClick={() => openTeam(m.away)}
                        />
                      </div>
                    </div>
                  </div>

                  {isExpanded && (
                    <div id={`details-${m.id}`}>
                      <MatchDetailsInline
                        darkMode={darkMode}
                        match={m}
                        openTeam={openTeam}
                        openPlayer={openPlayer}
                        openGallery={openGallery}
                      />
                    </div>
                  )}
                </React.Fragment>
              );
            })}
          </div>
        </Card>
      </div>
      )}
    </div>
  );
}

function LeagueTablePage({
  darkMode,
  leagueName,
  table,
  openTeam,
  currentSeason,
  availableSeasons,
  onSeasonChange,
  leagueId,
}) {
  const [sortBy, setSortBy] = useState("pts"); // pts, played, win, draw, loss, gf, ga, team
  const [sortOrder, setSortOrder] = useState("desc"); // asc/desc

  const sortedTable = useMemo(() => {
    const copy = [...table];
    copy.sort((a, b) => {
      let valA, valB;

      if (sortBy === "team") {
        return sortOrder === "asc"
          ? a.team.localeCompare(b.team)
          : b.team.localeCompare(a.team);
      }

      valA = a[sortBy] || 0;
      valB = b[sortBy] || 0;

      if (sortOrder === "desc") {
        return valB - valA || b.pts - a.pts || a.team.localeCompare(b.team);
      } else {
        return valA - valB || b.pts - a.pts || a.team.localeCompare(b.team);
      }
    });
    return copy.map((r, idx) => ({ ...r, displayPos: idx + 1 }));
  }, [table, sortBy, sortOrder]);

  const handleSort = (column) => {
    if (sortBy === column) {
      setSortOrder(sortOrder === "desc" ? "asc" : "desc");
    } else {
      setSortBy(column);
      setSortOrder("desc");
    }
  };

  const SortButton = ({ column, label }) => (
    <button
      onClick={() => handleSort(column)}
      className="hover:underline flex items-center gap-1"
    >
      {label}
      {sortBy === column && (
        <span className="text-xs">{sortOrder === "desc" ? "↓" : "↑"}</span>
      )}
    </button>
  );

  // Funkcja określająca kolor tła dla pozycji
  const getPositionBg = (pos) => {
    const tableLength = sortedTable.length;
    const lastPos = tableLength; // ostatnie miejsce
    const secondLastPos = tableLength - 1; // przedostatnie miejsce

    // I Liga: spadek z ostatnich 2 miejsc (czerwone)
    if (leagueId === "1st") {
      if (pos >= secondLastPos)
        return darkMode ? "bg-red-500/20" : "bg-red-100";
    }
    // II Liga: awans miejsca 1-2 (zielone), spadek ostatnie 2 miejsca (czerwone)
    if (leagueId === "2nd") {
      if (pos <= 2) return darkMode ? "bg-green-500/20" : "bg-green-100";
      if (pos >= secondLastPos)
        return darkMode ? "bg-red-500/20" : "bg-red-100";
    }
    // III Liga: awans miejsca 1-2 (zielone)
    if (leagueId === "3rd") {
      if (pos <= 2) return darkMode ? "bg-green-500/20" : "bg-green-100";
    }
    return "";
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between gap-4">
        <div className="text-2xl font-extrabold">{leagueName}</div>
        <SeasonNavigation
          currentSeason={currentSeason}
          availableSeasons={availableSeasons}
          onSeasonChange={onSeasonChange}
          darkMode={darkMode}
        />
      </div>

      <div
        className={classNames(
          "rounded-2xl border overflow-hidden",
          darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white"
        )}
      >
        <MobileLeagueScrollableTable
          rows={sortedTable}
          darkMode={darkMode}
          openTeam={openTeam}
          showForm
          getRowBg={getPositionBg}
        />

        <div
          className={classNames(
            "hidden md:block px-4 py-3 text-xs font-bold tracking-wide",
            darkMode ? "text-gray-300 bg-black/20" : "text-gray-600 bg-gray-50"
          )}
        >
          <div className="grid grid-cols-[48px_1fr_60px_60px_60px_60px_70px_70px_50px_60px_190px] gap-2">
            <div>#</div>
            <div>Drużyna</div>
            <div>M</div>
            <div>W</div>
            <div>R</div>
            <div>P</div>
            <div>BZ</div>
            <div>BS</div>
            <div>+/-</div>
            <div>PKT</div>
            <div>FORMA</div>
          </div>
        </div>

        {sortedTable.map((r) => (
          <div
            key={r.team}
            className={classNames(
              "hidden md:block px-4 py-3 border-t",
              getPositionBg(r.displayPos),
              darkMode
                ? "border-white/10 hover:bg-white/5"
                : "border-gray-100 hover:bg-gray-50"
            )}
          >
            <div className="grid grid-cols-[48px_1fr_60px_60px_60px_60px_70px_70px_50px_60px_190px] gap-2 items-center">
              <div className="font-extrabold">{r.displayPos}</div>

              <div className="flex items-center gap-3">
                <TeamLogo
                  team={r.team}
                  darkMode={darkMode}
                  size={42}
                  onClick={() => openTeam(r.team)}
                />
                <div className="font-extrabold">
                  <TeamLink
                    team={r.team}
                    onClick={() => openTeam(r.team)}
                    className="e3d-link"
                  />
                </div>
              </div>

              <div>{r.played}</div>
              <div>{r.win}</div>
              <div>{r.draw}</div>
              <div>{r.loss}</div>
              <div className="font-bold">{r.gf}</div>
              <div className="font-bold">{r.ga}</div>
              <div className={r.gf - r.ga > 0 ? "text-emerald-400" : r.gf - r.ga < 0 ? "text-rose-400" : ""}>{r.gf - r.ga > 0 ? '+' : ''}{r.gf - r.ga}</div>
              <div className="font-extrabold">{r.pts}</div>

              <div className="flex gap-2">
                {(r.form5 || []).map((f, i) => (
                  <FormDot
                    key={i}
                    v={f.result}
                    title={`${f.score} ${displayTeamName(f.opponent)}`}
                  />
                ))}
                {r.nextOpponent && (
                  <FormDot v="?" title={`Następny mecz: ${displayTeamName(r.nextOpponent)}`} />
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function CalendarPage({
  darkMode,
  leagueId,
  leagueName,
  round,
  fixtures,
  leagueTeams,
  getPlayedMatch,
  openTeam,
  openMatch,
  openGallery,
  expandedMatchId,
  stats,
  matches,
  playersByTeam,
  openPlayer,
  goToLeague,
  currentSeason,
  availableSeasons,
  onSeasonChange,
}) {
  const groupedFixtures = useMemo(() => {
    const sortedFixtures = [...(fixtures || [])].sort((a, b) => {
      const dateCompare = String(a?.date || "").localeCompare(String(b?.date || ""));
      if (dateCompare !== 0) return dateCompare;

      const timeCompare = String(a?.time || "").localeCompare(String(b?.time || ""));
      if (timeCompare !== 0) return timeCompare;

      return String(a?.home || "").localeCompare(String(b?.home || ""));
    });

    const groups = [];
    let currentKey = null;
    let currentItems = [];

    sortedFixtures.forEach((f) => {
      const key = f?.date || "__no_date__";
      if (key !== currentKey) {
        if (currentItems.length) {
          groups.push({ key: currentKey, date: currentKey === "__no_date__" ? null : currentKey, items: currentItems });
        }
        currentKey = key;
        currentItems = [f];
      } else {
        currentItems.push(f);
      }
    });

    if (currentItems.length) {
      groups.push({ key: currentKey, date: currentKey === "__no_date__" ? null : currentKey, items: currentItems });
    }

    return groups;
  }, [fixtures]);

  const byeTeam = useMemo(() => {
    const teams = (leagueTeams || []).filter(Boolean);
    if (teams.length < 3 || teams.length % 2 === 0) return null;

    const scheduledTeams = new Set();
    for (const fixture of fixtures || []) {
      if (fixture?.home) scheduledTeams.add(fixture.home);
      if (fixture?.away) scheduledTeams.add(fixture.away);
    }

    const missingTeams = teams.filter((team) => !scheduledTeams.has(team));
    return missingTeams.length === 1 ? missingTeams[0] : null;
  }, [leagueTeams, fixtures]);

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between gap-4">
        <div>
          <div className="text-2xl font-extrabold">
            <LeagueLink
              leagueId={leagueId}
              leagueName={leagueName}
              onClick={() => goToLeague(leagueId)}
            />
          </div>
          <div
            className={classNames(
              "text-sm",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            Kalendarz • kolejka {round}
          </div>
        </div>
        <SeasonNavigation
          currentSeason={currentSeason}
          availableSeasons={availableSeasons}
          onSeasonChange={onSeasonChange}
          darkMode={darkMode}
        />
      </div>

      {byeTeam && (
        <div
          className={classNames(
            "px-4 py-3 rounded-2xl border flex items-center justify-between gap-3",
            darkMode
              ? "border-yellow-500/30 bg-yellow-500/10 text-yellow-200"
              : "border-yellow-200 bg-yellow-50 text-yellow-900"
          )}
        >
          <div className="text-sm font-medium">
            W tej kolejce pauzuje:
            {" "}
            <button onClick={() => openTeam(byeTeam)} className="font-black underline underline-offset-2">
              {displayTeamName(byeTeam)}
            </button>
          </div>
          <span className="text-xs font-black uppercase tracking-[0.12em]">Pauza</span>
        </div>
      )}

      <div className="grid gap-3">
        {groupedFixtures.map((group) => {
          const header = fixtureDateHeaderParts(group.date);
          return (
          <div key={group.key} className="space-y-2">
            <div
              className={classNames(
                "px-3 py-2.5 rounded-xl border shadow-sm",
                darkMode
                  ? "bg-gradient-to-r from-blue-500/20 via-cyan-400/8 to-transparent border-blue-300/20"
                  : "bg-gradient-to-r from-blue-50 via-cyan-50 to-white border-blue-200"
              )}
            >
              <div className="flex items-center gap-3">
                <div
                  className={classNames(
                    "w-1.5 self-stretch rounded-full",
                    darkMode ? "bg-cyan-300/80" : "bg-blue-500"
                  )}
                />
                <div className="min-w-0">
                  <div
                    className={classNames(
                      "text-[11px] font-black uppercase tracking-[0.14em]",
                      darkMode ? "text-cyan-200" : "text-blue-700"
                    )}
                  >
                    {header.weekday}
                  </div>
                  {header.date ? (
                    <div
                      className={classNames(
                        "text-base sm:text-lg font-black leading-tight",
                        darkMode ? "text-white" : "text-gray-900"
                      )}
                    >
                      {header.date}
                    </div>
                  ) : null}
                </div>
              </div>
            </div>

            <div className="space-y-3">
              {group.items.map((f) => {
                const m = getPlayedMatch(f);
                const played = !!m;
                const isExpanded = expandedMatchId === f.id;
                return (
                  <React.Fragment key={f.id}>
                    <Card
                      darkMode={darkMode}
                      className={classNames(
                        "p-3",
                        darkMode ? "bg-black/10" : "bg-white"
                      )}
                    >
                      <MobileFlashscoreMatchRow
                        darkMode={darkMode}
                        homeTeam={f.home}
                        awayTeam={f.away}
                        homeLogoSrc={f.homeLogoUrl}
                        awayLogoSrc={f.awayLogoUrl}
                        onOpenHome={() => openTeam(f.home)}
                        onOpenAway={() => openTeam(f.away)}
                        onOpenMatch={() => openMatch(played ? m.id : f.id)}
                        leftPrimary={fixtureCenterTimeLabel(f)}
                        leftSecondary={played ? compactDateLabel(f.date) : ""}
                        rightPrimaryTop={played ? m.homeGoals : null}
                        rightPrimaryBottom={played ? m.awayGoals : null}
                        isScore={played}
                        videoUrl={played ? m?.videoUrl : null}
                        galleryUrl={played ? m?.galleryUrl : null}
                        onOpenGallery={
                          played && (m?.hasGallery || f.hasGallery)
                            ? () => openGallery?.(m || f)
                            : undefined
                        }
                        galleryCount={played ? (m?.galleryCount || f.galleryCount || 0) : 0}
                      />

                      <div className="hidden md:grid grid-cols-[44px_minmax(0,1fr)_auto_auto_20px_minmax(0,1fr)_44px] gap-2 items-center">
                        <TeamLogo
                          team={f.home}
                          src={f.homeLogoUrl}
                          darkMode={darkMode}
                          size={44}
                          onClick={() => openTeam(f.home)}
                        />

                        <TeamLink
                          team={f.home}
                          onClick={() => openTeam(f.home)}
                          className="e3d-link font-extrabold truncate"
                        />

                        <VideoIcon
                          darkMode={darkMode}
                          videoUrl={m?.videoUrl || f.videoUrl}
                          played={played}
                          galleryUrl={m?.galleryUrl || f.galleryUrl}
                          hasGallery={!!(m?.hasGallery || f.hasGallery)}
                          galleryCount={m?.galleryCount || f.galleryCount || 0}
                          onOpenGallery={
                            m?.hasGallery || f.hasGallery
                              ? () => openGallery?.(m || f)
                              : undefined
                          }
                          size={20}
                        />

                        {played ? (
                          <ScorePill
                            homeGoals={m.homeGoals}
                            awayGoals={m.awayGoals}
                            darkMode={darkMode}
                            onClick={() => openMatch(m.id)}
                            time={f.time || m.time}
                            status={m.status}
                          />
                        ) : (
                          <button
                            onClick={() => openMatch(f.id)}
                            className={classNames(
                              "px-4 py-2 rounded-xl border text-sm font-bold e3d-pill whitespace-nowrap",
                              darkMode
                                ? "bg-white/5 border-white/10"
                                : "bg-black/5 border-black/10"
                            )}
                            title="Szczegóły meczu"
                          >
                            {fixtureCenterTimeLabel(f)}
                          </button>
                        )}

                        <div className="w-5"></div>

                        <TeamLink
                          team={f.away}
                          onClick={() => openTeam(f.away)}
                          className="e3d-link font-extrabold text-right truncate"
                        />

                        <TeamLogo
                          team={f.away}
                          src={f.awayLogoUrl}
                          darkMode={darkMode}
                          size={44}
                          onClick={() => openTeam(f.away)}
                        />
                      </div>

                      <div
                        className={classNames(
                          "hidden md:flex mt-2 items-center gap-2 text-xs",
                          darkMode ? "text-gray-400" : "text-gray-600"
                        )}
                      >
                        <span className="font-semibold">{leagueName}</span>
                      </div>
                    </Card>

                    {isExpanded && m && (
                      <div id={`details-${f.id}`}>
                        <MatchDetailsInline
                          darkMode={darkMode}
                          match={m}
                          openTeam={openTeam}
                          openPlayer={openPlayer}
                          openGallery={openGallery}
                        />
                      </div>
                    )}

                    {isExpanded && !m && (
                      <div id={`details-${f.id}`}>
                        <UpcomingMatchDetailsInline
                          darkMode={darkMode}
                          fixture={f}
                          stats={stats}
                          matches={matches}
                          playersByTeam={playersByTeam}
                          openTeam={openTeam}
                          openPlayer={openPlayer}
                        />
                      </div>
                    )}
                  </React.Fragment>
                );
              })}
            </div>
          </div>
        )})}
      </div>
    </div>
  );
}

function formatGalleryDate(dateStr) {
  if (!dateStr) return "Termin nieznany";
  const [y, m, d] = String(dateStr).split("-").map(Number);
  if (!y || !m || !d) return String(dateStr);
  return new Date(y, m - 1, d).toLocaleDateString("pl-PL", {
    day: "2-digit",
    month: "long",
    year: "numeric",
  });
}

function LeagueGalleryPage({
  darkMode,
  leagueId,
  leagueName,
  galleries,
  currentSeason,
  availableSeasons,
  onSeasonChange,
  onOpenCarousel,
}) {
  const [selectedGallery, setSelectedGallery] = useState(null);
  const [loadingGalleryId, setLoadingGalleryId] = useState(null);
  const [galleryError, setGalleryError] = useState(null);

  useEffect(() => {
    setSelectedGallery(null);
    setLoadingGalleryId(null);
    setGalleryError(null);
  }, [leagueId, currentSeason, galleries]);

  async function openGalleryTiles(gallerySummary) {
    if (!gallerySummary?.matchId) return;
    setLoadingGalleryId(gallerySummary.id);
    setGalleryError(null);

    try {
      const fullAlbum = await fetchMatchGallery(gallerySummary.matchId);
      if (!fullAlbum?.photos?.length) {
        setGalleryError("Ta galeria nie zawiera jeszcze zdjęć.");
        return;
      }

      setSelectedGallery({
        ...gallerySummary,
        ...fullAlbum,
      });
    } catch (err) {
      console.error("Nie udało się załadować galerii ligi:", err);
      setGalleryError("Nie udało się załadować zdjęć tej galerii.");
    } finally {
      setLoadingGalleryId(null);
    }
  }

  if (selectedGallery) {
    return (
      <div className="space-y-4">
        <div className="flex items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <button
              type="button"
              onClick={() => setSelectedGallery(null)}
              className={classNames(
                "px-3 py-2 rounded e3d-btn",
                darkMode ? "bg-white/5 hover:bg-white/10" : "bg-black/5 hover:bg-black/10"
              )}
            >
              <ArrowLeft size={18} className="e3d-ico" />
            </button>
            <div>
              <div className="text-2xl font-extrabold">
                {displayTeamName(selectedGallery.home)} - {displayTeamName(selectedGallery.away)}
              </div>
              <div className={classNames("text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                {leagueName} • {formatGalleryDate(selectedGallery.date)} •{" "}
                {selectedGallery.score || "bez podanego wyniku"} • {selectedGallery.photoCount} zdjęć
              </div>
            </div>
          </div>

          <SeasonNavigation
            currentSeason={currentSeason}
            availableSeasons={availableSeasons}
            onSeasonChange={onSeasonChange}
            darkMode={darkMode}
          />
        </div>

        <Card darkMode={darkMode}>
          <div className="font-extrabold mb-3">Zdjęcia z meczu</div>
          <div className={classNames("text-sm mb-4", darkMode ? "text-gray-400" : "text-gray-600")}>
            Kliknij dowolne zdjęcie, aby otworzyć karuzelę z powiększeniem i miniaturkami.
          </div>

          <div className="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">
            {selectedGallery.photos.map((photo, index) => (
              <button
                type="button"
                key={photo.id || `${selectedGallery.id}-${index}`}
                onClick={() => onOpenCarousel(selectedGallery, index)}
                className={classNames(
                  "group overflow-hidden rounded-2xl border text-left",
                  darkMode
                    ? "border-white/10 bg-black/10 hover:bg-white/5"
                    : "border-gray-200 bg-gray-50 hover:bg-white"
                )}
              >
                <div className="aspect-[4/3] overflow-hidden bg-black/10">
                  <img
                    src={photo.url}
                    alt={photo.caption || `${selectedGallery.title || "Galeria"} #${index + 1}`}
                    className="w-full h-full object-cover transition-transform duration-200 group-hover:scale-[1.03]"
                  />
                </div>
                <div className="px-3 py-2">
                  <div className="font-bold text-sm">Zdjęcie {index + 1}</div>
                  <div className={classNames("text-xs truncate", darkMode ? "text-gray-400" : "text-gray-600")}>
                    {photo.caption || "Otwórz w karuzeli"}
                  </div>
                </div>
              </button>
            ))}
          </div>
        </Card>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between gap-4">
        <div>
          <div className="text-2xl font-extrabold">{leagueName}</div>
          <div className={classNames("text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
            Galerie meczowe • sezon {currentSeason}
          </div>
        </div>

        <SeasonNavigation
          currentSeason={currentSeason}
          availableSeasons={availableSeasons}
          onSeasonChange={onSeasonChange}
          darkMode={darkMode}
        />
      </div>

      {galleryError && (
        <Card darkMode={darkMode}>
          <div className={darkMode ? "text-rose-300" : "text-rose-700"}>
            {galleryError}
          </div>
        </Card>
      )}

      {galleries.length === 0 ? (
        <Card darkMode={darkMode}>
          <div className={classNames("text-center py-6", darkMode ? "text-gray-400" : "text-gray-600")}>
            Brak opublikowanych galerii meczowych w tej lidze.
          </div>
        </Card>
      ) : (
        <div className="grid xl:grid-cols-2 gap-4">
          {galleries.map((gallery) => {
            const isLoading = loadingGalleryId === gallery.id;
            return (
              <button
                type="button"
                key={gallery.id}
                onClick={() => openGalleryTiles(gallery)}
                className={classNames(
                  "overflow-hidden rounded-2xl border text-left transition-transform hover:-translate-y-0.5",
                  darkMode
                    ? "border-white/10 bg-black/10 hover:bg-white/5"
                    : "border-gray-200 bg-white hover:bg-gray-50"
                )}
              >
                <div className="grid md:grid-cols-[220px_minmax(0,1fr)]">
                  <div className="aspect-[4/3] md:aspect-auto bg-black/10">
                    {gallery.coverUrl ? (
                      <img
                        src={gallery.coverUrl}
                        alt={gallery.title || ""}
                        className="w-full h-full object-cover"
                      />
                    ) : (
                      <div className={classNames(
                        "w-full h-full flex items-center justify-center",
                        darkMode ? "text-gray-500" : "text-gray-400"
                      )}>
                        <Images size={28} />
                      </div>
                    )}
                  </div>

                  <div className="p-4 space-y-3 min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      <span className={classNames(
                        "px-2.5 py-1 rounded-full text-[11px] font-black border",
                        darkMode
                          ? "bg-cyan-500/10 border-cyan-400/20 text-cyan-200"
                          : "bg-cyan-50 border-cyan-200 text-cyan-700"
                      )}>
                        {leagueName}
                      </span>
                      <span className={classNames(
                        "px-2.5 py-1 rounded-full text-[11px] font-bold border",
                        darkMode
                          ? "bg-white/5 border-white/10 text-gray-300"
                          : "bg-gray-50 border-gray-200 text-gray-700"
                      )}>
                        {gallery.photoCount} zdjęć
                      </span>
                    </div>

                    <div>
                      <div className="text-xl font-extrabold leading-tight">
                        {displayTeamName(gallery.home)} - {displayTeamName(gallery.away)}
                      </div>
                      <div className={classNames("text-sm mt-1", darkMode ? "text-gray-400" : "text-gray-600")}>
                        {formatGalleryDate(gallery.date)}
                        {gallery.score ? ` • wynik ${gallery.score}` : ""}
                      </div>
                    </div>

                    <div className={classNames("text-sm", darkMode ? "text-gray-300" : "text-gray-700")}>
                      {gallery.title || "Galeria meczowa"}
                    </div>

                    <div className={classNames("text-xs", darkMode ? "text-gray-500" : "text-gray-500")}>
                      {isLoading ? "Ładowanie zdjęć..." : "Otwórz galerię w układzie kafelków"}
                    </div>
                  </div>
                </div>
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
}

function MatchGalleryOverlay({ darkMode, overlay, onClose, onIndexChange }) {
  const album = overlay?.album || null;
  const photos = album?.photos || [];
  const currentIndex = Math.min(
    Math.max(overlay?.currentIndex || 0, 0),
    Math.max(photos.length - 1, 0)
  );
  const currentPhoto = photos[currentIndex] || null;

  useEffect(() => {
    if (!overlay?.open) return undefined;

    const handleKeyDown = (event) => {
      if (event.key === "Escape") {
        onClose();
      } else if (event.key === "ArrowLeft" && photos.length > 1) {
        event.preventDefault();
        onIndexChange((currentIndex - 1 + photos.length) % photos.length);
      } else if (event.key === "ArrowRight" && photos.length > 1) {
        event.preventDefault();
        onIndexChange((currentIndex + 1) % photos.length);
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [currentIndex, onClose, onIndexChange, overlay?.open, photos.length]);

  if (!overlay?.open) return null;

  return (
    <div
      className="fixed inset-0 z-[10020] bg-black/80 backdrop-blur-sm flex items-center justify-center p-3 sm:p-5"
      onClick={onClose}
    >
      <div
        className={classNames(
          "w-full max-w-6xl rounded-[28px] border overflow-hidden",
          darkMode ? "bg-[#0b111a] border-white/10" : "bg-white border-gray-200"
        )}
        onClick={(e) => e.stopPropagation()}
      >
        <div
          className={classNames(
            "px-4 py-3 border-b flex items-start justify-between gap-4",
            darkMode ? "border-white/10" : "border-gray-200"
          )}
        >
          <div className="min-w-0">
            <div className="text-lg font-extrabold truncate">
              {album?.home && album?.away
                ? `${displayTeamName(album.home)} - ${displayTeamName(album.away)}`
                : album?.title || "Galeria meczowa"}
            </div>
            <div className={classNames("text-sm mt-1", darkMode ? "text-gray-400" : "text-gray-600")}>
              {album?.date ? formatGalleryDate(album.date) : ""}
              {album?.score ? ` • wynik ${album.score}` : ""}
              {photos.length ? ` • ${currentIndex + 1}/${photos.length}` : ""}
            </div>
          </div>

          <button
            type="button"
            onClick={onClose}
            className={classNames(
              "p-2 rounded-xl border",
              darkMode
                ? "bg-white/5 border-white/10 hover:bg-white/10"
                : "bg-gray-50 border-gray-200 hover:bg-gray-100"
            )}
            title="Zamknij galerię"
          >
            <X size={18} />
          </button>
        </div>

        <div className="p-3 sm:p-4">
          {overlay.loading ? (
            <div className="h-[60vh] flex items-center justify-center">
              <div className={classNames("text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                Ładowanie galerii...
              </div>
            </div>
          ) : currentPhoto ? (
            <div className="space-y-4">
              <div className="relative rounded-2xl overflow-hidden bg-black">
                <div className="h-[58vh] sm:h-[68vh] flex items-center justify-center">
                  <img
                    src={currentPhoto.url}
                    alt={currentPhoto.caption || `${album?.title || "Galeria"} ${currentIndex + 1}`}
                    className="max-w-full max-h-full object-contain"
                  />
                </div>

                {photos.length > 1 && (
                  <>
                    <button
                      type="button"
                      onClick={() => onIndexChange((currentIndex - 1 + photos.length) % photos.length)}
                      className="absolute left-3 top-1/2 -translate-y-1/2 w-11 h-11 rounded-full border border-white/15 bg-black/45 text-white flex items-center justify-center hover:bg-black/60"
                      title="Poprzednie zdjęcie"
                    >
                      <ChevronLeft size={22} />
                    </button>
                    <button
                      type="button"
                      onClick={() => onIndexChange((currentIndex + 1) % photos.length)}
                      className="absolute right-3 top-1/2 -translate-y-1/2 w-11 h-11 rounded-full border border-white/15 bg-black/45 text-white flex items-center justify-center hover:bg-black/60"
                      title="Następne zdjęcie"
                    >
                      <ChevronRight size={22} />
                    </button>
                  </>
                )}
              </div>

              <div className={classNames("text-sm min-h-[20px]", darkMode ? "text-gray-300" : "text-gray-700")}>
                {currentPhoto.caption || ""}
              </div>

              {photos.length > 1 && (
                <div className="flex gap-2 overflow-x-auto pb-1">
                  {photos.map((photo, index) => (
                    <button
                      type="button"
                      key={photo.id || `thumb-${index}`}
                      onClick={() => onIndexChange(index)}
                      className={classNames(
                        "shrink-0 rounded-xl overflow-hidden border-2 transition-colors",
                        index === currentIndex
                          ? darkMode
                            ? "border-cyan-300"
                            : "border-blue-500"
                          : darkMode
                          ? "border-white/10"
                          : "border-gray-200"
                      )}
                      title={`Przejdź do zdjęcia ${index + 1}`}
                    >
                      <img
                        src={photo.url}
                        alt={photo.caption || `Miniatura ${index + 1}`}
                        className="w-20 h-14 sm:w-24 sm:h-16 object-cover"
                      />
                    </button>
                  ))}
                </div>
              )}
            </div>
          ) : (
            <div className={classNames("h-[40vh] flex items-center justify-center", darkMode ? "text-gray-400" : "text-gray-600")}>
              Brak zdjęć do wyświetlenia.
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

function normalizeSearchKey(v) {
  return (v || "")
    .toString()
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-z0-9]+/g, "");
}

function HomeTeamsDatabasePage({ darkMode, openTeam }) {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [rows, setRows] = useState([]);
  const [query, setQuery] = useState("");
  const [hideInactive, setHideInactive] = useState(true);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        setLoading(true);
        setError("");
        const data = await fetchTeamsDirectory();
        if (!cancelled) setRows(data);
      } catch (err) {
        if (!cancelled) {
          console.error("Błąd ładowania bazy drużyn:", err);
          setError("Nie udalo sie zaladowac bazy druzyn.");
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const filtered = useMemo(() => {
    const q = normalizeSearchKey(query);
    return rows.filter((row) => {
      if (hideInactive && !row.isActive) return false;
      if (!q) return true;
      const hay = normalizeSearchKey(
        `${row.name} ${row.abbreviation || ""} ${row.district || ""}`
      );
      return hay.includes(q);
    });
  }, [rows, query, hideInactive]);

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <div className="text-2xl font-extrabold">Baza drużyn</div>
          <div
            className={classNames(
              "text-sm",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            Wyszukaj druzyne i kliknij, aby otworzyc profil.
          </div>
        </div>
        <div
          className={classNames(
            "text-sm font-bold px-3 py-2 rounded-xl border",
            darkMode
              ? "border-white/10 bg-white/5 text-gray-200"
              : "border-gray-200 bg-white text-gray-700"
          )}
        >
          {filtered.length} / {rows.length}
        </div>
      </div>

      <Card darkMode={darkMode}>
        <div className="flex flex-col md:flex-row gap-3 md:items-center">
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Szukaj drużyny (nazwa, skrót, dzielnica)"
            className={classNames(
              "w-full md:flex-1 rounded-xl border px-3 py-2 outline-none",
              darkMode
                ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500"
                : "bg-white border-gray-200 text-gray-900 placeholder:text-gray-400"
            )}
          />
          <label
            className={classNames(
              "flex items-center gap-2 text-sm font-semibold select-none",
              darkMode ? "text-gray-200" : "text-gray-700"
            )}
          >
            <input
              type="checkbox"
              checked={hideInactive}
              onChange={(e) => setHideInactive(e.target.checked)}
            />
            Ukryj nieaktywne
          </label>
        </div>
      </Card>

      <Card darkMode={darkMode}>
        {loading ? (
          <div className={classNames("py-8 text-center", darkMode ? "text-gray-400" : "text-gray-500")}>
            Ładowanie bazy drużyn...
          </div>
        ) : error ? (
          <div className="py-8 text-center text-rose-400 font-semibold">{error}</div>
        ) : filtered.length === 0 ? (
          <div className={classNames("py-8 text-center", darkMode ? "text-gray-400" : "text-gray-500")}>
            Brak wynikow dla podanej frazy.
          </div>
        ) : (
          <div className="grid sm:grid-cols-2 xl:grid-cols-3 gap-3">
            {filtered.map((t) => (
              <button
                key={t.id}
                onClick={() => openTeam(t.name)}
                className={classNames(
                  "p-3 rounded-2xl border flex items-center gap-3 text-left e3d-card",
                  darkMode
                    ? "border-white/10 bg-black/10 hover:bg-white/5"
                    : "border-gray-200 bg-gray-50 hover:bg-white"
                )}
              >
                <TeamLogo
                  team={t.name}
                  darkMode={darkMode}
                  size={50}
                  onClick={() => openTeam(t.name)}
                />
                <div className="min-w-0">
                  <div className="font-extrabold truncate">{t.name}</div>
                  <div
                    className={classNames(
                      "text-xs mt-1 flex flex-wrap gap-x-2 gap-y-1",
                      darkMode ? "text-gray-400" : "text-gray-600"
                    )}
                  >
                    {t.abbreviation && <span>{t.abbreviation}</span>}
                    {t.district && <span>{t.district}</span>}
                    {!t.isActive && <span className="text-rose-400">Nieaktywna</span>}
                  </div>
                </div>
              </button>
            ))}
          </div>
        )}
      </Card>
    </div>
  );
}

function HomePlayersDatabasePage({ darkMode, openPlayer }) {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [rows, setRows] = useState([]);
  const [query, setQuery] = useState("");
  const [hideInactive, setHideInactive] = useState(true);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        setLoading(true);
        setError("");
        const data = await fetchPlayersDirectory();
        if (!cancelled) setRows(data);
      } catch (err) {
        if (!cancelled) {
          console.error("Błąd ładowania bazy zawodników:", err);
          setError("Nie udało się załadować bazy zawodników.");
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const filtered = useMemo(() => {
    const q = normalizeSearchKey(query);
    return rows.filter((row) => {
      if (hideInactive && !row.isActive) return false;
      if (!q) return true;
      const hay = normalizeSearchKey(
        `${row.name} ${row.firstName || ""} ${row.lastName || ""} ${row.position || ""} ${row.city || ""}`
      );
      return hay.includes(q);
    });
  }, [rows, query, hideInactive]);

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <div className="text-2xl font-extrabold">Baza zawodników</div>
          <div
            className={classNames(
              "text-sm",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            Kliknij zawodnika, aby otworzyc jego karte.
          </div>
        </div>
        <div
          className={classNames(
            "text-sm font-bold px-3 py-2 rounded-xl border",
            darkMode
              ? "border-white/10 bg-white/5 text-gray-200"
              : "border-gray-200 bg-white text-gray-700"
          )}
        >
          {filtered.length} / {rows.length}
        </div>
      </div>

      <Card darkMode={darkMode}>
        <div className="flex flex-col md:flex-row gap-3 md:items-center">
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Szukaj zawodnika (imię, nazwisko, pozycja, miasto)"
            className={classNames(
              "w-full md:flex-1 rounded-xl border px-3 py-2 outline-none",
              darkMode
                ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500"
                : "bg-white border-gray-200 text-gray-900 placeholder:text-gray-400"
            )}
          />
          <label
            className={classNames(
              "flex items-center gap-2 text-sm font-semibold select-none",
              darkMode ? "text-gray-200" : "text-gray-700"
            )}
          >
            <input
              type="checkbox"
              checked={hideInactive}
              onChange={(e) => setHideInactive(e.target.checked)}
            />
            Ukryj nieaktywnych
          </label>
        </div>
      </Card>

      <Card darkMode={darkMode}>
        {loading ? (
          <div className={classNames("py-8 text-center", darkMode ? "text-gray-400" : "text-gray-500")}>
            Ładowanie bazy zawodników...
          </div>
        ) : error ? (
          <div className="py-8 text-center text-rose-400 font-semibold">{error}</div>
        ) : filtered.length === 0 ? (
          <div className={classNames("py-8 text-center", darkMode ? "text-gray-400" : "text-gray-500")}>
            Brak wynikow dla podanej frazy.
          </div>
        ) : (
          <div className="space-y-2">
            <div
              className={classNames(
                "hidden md:grid grid-cols-[1.2fr_120px_90px_90px_90px_90px_90px] gap-2 px-2 py-2 text-xs font-bold tracking-wide",
                darkMode ? "text-gray-300" : "text-gray-600"
              )}
            >
              <div>Zawodnik</div>
              <div>Pozycja</div>
              <div className="text-right">Rocz.</div>
              <div className="text-right">M</div>
              <div className="text-right">G</div>
              <div className="text-right">A</div>
              <div className="text-right">Kartki</div>
            </div>

            {filtered.map((p) => (
              <button
                key={p.id}
                onClick={() => openPlayer?.(p.id)}
                className={classNames(
                  "w-full text-left px-2 py-3 rounded-xl border e3d-card",
                  darkMode
                    ? "border-white/10 hover:bg-white/5"
                    : "border-gray-200 hover:bg-gray-50"
                )}
              >
                <div className="md:hidden space-y-1">
                  <div className="font-extrabold">{p.name}</div>
                  <div className={classNames("text-sm", darkMode ? "text-gray-300" : "text-gray-700")}>
                    {p.position || "Brak pozycji"}{p.birthYear ? ` • ${p.birthYear}` : ""}
                  </div>
                  <div className={classNames("text-xs", darkMode ? "text-gray-400" : "text-gray-600")}>
                    M {p.totals.appearances} • G {p.totals.goals} • A {p.totals.assists} •
                    Z {p.totals.yellowCards} / C {p.totals.redCards}
                    {!p.isActive ? " • Nieaktywny" : ""}
                  </div>
                </div>

                <div className="hidden md:grid grid-cols-[1.2fr_120px_90px_90px_90px_90px_90px] gap-2 items-center">
                  <div className="min-w-0">
                    <div className="font-extrabold truncate">{p.name}</div>
                    <div className={classNames("text-xs truncate", darkMode ? "text-gray-400" : "text-gray-600")}>
                      {p.city || "—"} {!p.isActive ? "• Nieaktywny" : ""}
                    </div>
                  </div>
                  <div className="font-semibold truncate">{p.position || "—"}</div>
                  <div className="text-right font-semibold">{p.birthYear || "—"}</div>
                  <div className="text-right font-extrabold">{p.totals.appearances}</div>
                  <div className="text-right font-extrabold">{p.totals.goals}</div>
                  <div className="text-right font-extrabold">{p.totals.assists}</div>
                  <div className="text-right font-semibold">
                    {p.totals.yellowCards}/{p.totals.redCards}
                  </div>
                </div>
              </button>
            ))}
          </div>
        )}
      </Card>
    </div>
  );
}

function TeamsPage({
  darkMode,
  leagueId,
  leagueName,
  teams,
  openTeam,
  goToLeague,
  currentSeason,
  availableSeasons,
  onSeasonChange,
}) {
  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between gap-4">
        <div>
          <div className="text-2xl font-extrabold">
            <LeagueLink
              leagueId={leagueId}
              leagueName={leagueName}
              onClick={() => goToLeague(leagueId)}
            />
          </div>
          <div
            className={classNames(
              "text-sm",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            Drużyny (kliknij: profil)
          </div>
        </div>
        <SeasonNavigation
          currentSeason={currentSeason}
          availableSeasons={availableSeasons}
          onSeasonChange={onSeasonChange}
          darkMode={darkMode}
        />
      </div>

      {true && (
        <Card darkMode={darkMode}>
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-3">
            {teams.map((t) => (
              <button
                key={t}
                onClick={() => openTeam(t)}
                className={classNames(
                  "p-3 rounded-2xl border flex items-center gap-3 text-left e3d-card",
                  darkMode
                    ? "border-white/10 bg-black/10 hover:bg-white/5"
                    : "border-gray-200 bg-gray-50 hover:bg-white"
                )}
              >
                <TeamLogo
                  team={t}
                  darkMode={darkMode}
                  size={52}
                  onClick={() => openTeam(t)}
                />
                <div className="font-extrabold">{t}</div>
              </button>
            ))}
          </div>
        </Card>
      )}
    </div>
  );
}

function TeamStatsTable({ darkMode, teamRows, openTeam }) {
  const [sortBy, setSortBy] = useState("pts"); // gf, ga, streakUnbeaten, streakWins, streakWinless, pts, played, team
  const [sortOrder, setSortOrder] = useState("desc");

  const sortedRows = useMemo(() => {
    const copy = [...teamRows];
    copy.sort((a, b) => {
      if (sortBy === "team") {
        return sortOrder === "asc"
          ? a.team.localeCompare(b.team)
          : b.team.localeCompare(a.team);
      }

      const valA = a[sortBy] || 0;
      const valB = b[sortBy] || 0;

      if (sortOrder === "desc") {
        return valB - valA || b.pts - a.pts || a.team.localeCompare(b.team);
      } else {
        return valA - valB || b.pts - a.pts || a.team.localeCompare(b.team);
      }
    });
    return copy;
  }, [teamRows, sortBy, sortOrder]);

  const handleSort = (column) => {
    if (sortBy === column) {
      setSortOrder(sortOrder === "desc" ? "asc" : "desc");
    } else {
      setSortBy(column);
      setSortOrder("desc");
    }
  };

  const SortButton = ({ column, label, align = "text-left" }) => {
    const justifyClass =
      align === "text-right"
        ? "justify-end"
        : align === "text-center"
        ? "justify-center"
        : "justify-start";
    return (
      <button
        onClick={() => handleSort(column)}
        className={classNames(
          "hover:underline flex items-center gap-1",
          align,
          justifyClass
        )}
      >
        {label}
        {sortBy === column && (
          <span className="text-xs">{sortOrder === "desc" ? "↓" : "↑"}</span>
        )}
      </button>
    );
  };

  return (
    <>
      <div
        className={classNames(
          "px-2 py-2 text-xs font-bold tracking-wide",
          darkMode ? "text-gray-300" : "text-gray-600"
        )}
      >
        <div className="grid grid-cols-[1fr_90px_90px_90px_90px_120px_120px_120px] gap-2">
          <SortButton column="team" label="Drużyna" />
          <SortButton column="gf" label="BZ" align="text-right" />
          <SortButton column="ga" label="BS" align="text-right" />
          <SortButton
            column="streakUnbeaten"
            label="Bez por."
            align="text-right"
          />
          <SortButton column="streakWins" label="Seria W" align="text-right" />
          <SortButton
            column="streakWinless"
            label="Bez wygr."
            align="text-right"
          />
          <SortButton column="pts" label="Pkt" align="text-right" />
          <SortButton column="played" label="M" align="text-right" />
        </div>
      </div>

      {sortedRows.map((t) => (
        <div
          key={t.team}
          className={classNames(
            "px-2 py-3 border-t",
            darkMode ? "border-white/10" : "border-gray-100"
          )}
        >
          <div className="grid grid-cols-[1fr_90px_90px_90px_90px_120px_120px_120px] gap-2 items-center">
            <div className="flex items-center gap-3">
              <TeamLogo
                team={t.team}
                darkMode={darkMode}
                size={40}
                onClick={() => openTeam(t.team)}
              />
              <div className="font-extrabold">
                <TeamLink
                  team={t.team}
                  onClick={() => openTeam(t.team)}
                  className="e3d-link"
                />
              </div>
            </div>
            <div className="text-right font-extrabold">{t.gf}</div>
            <div className="text-right font-extrabold">{t.ga}</div>
            <div className="text-right font-extrabold">{t.streakUnbeaten}</div>
            <div className="text-right font-extrabold">{t.streakWins}</div>
            <div className="text-right font-extrabold">{t.streakWinless}</div>
            <div className="text-right font-extrabold">{t.pts}</div>
            <div className="text-right font-bold">{t.played}</div>
          </div>
        </div>
      ))}
    </>
  );
}

function StatsPage({
  darkMode,
  leagueName,
  stats,
  leagueId,
  openTeam,
  openPlayer,
  goToLeague,
  currentSeason,
  availableSeasons,
  onSeasonChange,
}) {
  const [tab, setTab] = useState("scorers"); // scorers/assists/yellow/red/teams

  const rowsForLeague = (list) =>
    list.filter((x) => (x.league ? x.league === leagueId : stats.teamStats[x.team]?.league === leagueId));

  const scorers = rowsForLeague(stats.topScorers);
  const assists = rowsForLeague(stats.topAssists);
  const yellow = rowsForLeague(stats.topYellow);
  const red = rowsForLeague(stats.topRed);

  const teamRows = stats.tableByLeague[leagueId] || [];

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between gap-4">
        <div>
          <div className="text-2xl font-extrabold">
            <LeagueLink
              leagueId={leagueId}
              leagueName={leagueName}
              onClick={() => goToLeague(leagueId)}
            />
          </div>
          <div
            className={classNames(
              "text-sm",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            Statystyki (spójne z wynikami i zdarzeniami)
          </div>
        </div>
        <SeasonNavigation
          currentSeason={currentSeason}
          availableSeasons={availableSeasons}
          onSeasonChange={onSeasonChange}
          darkMode={darkMode}
        />
      </div>

      <div className="flex flex-wrap gap-2">
        {[
          { id: "scorers", label: "Strzelcy" },
          { id: "assists", label: "Asysty" },
          { id: "yellow", label: "Żółte" },
          { id: "red", label: "Czerwone" },
          { id: "teams", label: "Drużyny" },
        ].map((b) => (
          <button
            key={b.id}
            onClick={() => setTab(b.id)}
            className={classNames(
              "px-3 py-2 rounded-xl border text-sm font-bold e3d-tab",
              tab === b.id
                ? "text-green-400 bg-green-500/10 border-green-500/20"
                : darkMode
                ? "bg-white/5 border-white/10 hover:bg-white/10 text-gray-200"
                : "bg-black/5 border-black/10 hover:bg-black/10 text-gray-900"
            )}
          >
            {b.label}
          </button>
        ))}
      </div>

      {tab !== "teams" ? (
        (tab === "scorers" ? scorers : tab === "assists" ? assists : tab === "yellow" ? yellow : red).length === 0 ? (
          <Card darkMode={darkMode}>
            <div className={classNames("text-center py-8", darkMode ? "text-gray-400" : "text-gray-500")}>
              Brak statystyk zawodników dla tego sezonu
            </div>
          </Card>
        ) :
        <Card darkMode={darkMode}>
          <div
            className={classNames(
              "px-2 py-2 text-xs font-bold tracking-wide",
              darkMode ? "text-gray-300" : "text-gray-600"
            )}
          >
            <div className="grid grid-cols-[60px_1fr_1fr_90px] gap-2">
              <div>#</div>
              <div>Zawodnik</div>
              <div>Drużyna</div>
              <div className="text-right">
                {tab === "scorers"
                  ? "Gole"
                  : tab === "assists"
                  ? "Asysty"
                  : tab === "yellow"
                  ? "Żółte"
                  : "Czerwone"}
              </div>
            </div>
          </div>

          {(tab === "scorers"
            ? scorers
            : tab === "assists"
            ? assists
            : tab === "yellow"
            ? yellow
            : red
          ).map((p, idx) => (
            <div
              key={p.playerId}
              className={classNames(
                "px-2 py-3 border-t",
                darkMode ? "border-white/10" : "border-gray-100"
              )}
            >
              <div className="grid grid-cols-[60px_1fr_1fr_90px] gap-2 items-center">
                <div className="font-extrabold">{idx + 1}</div>
                <button
                  onClick={() => openPlayer?.(p.playerId)}
                  className="font-bold hover:underline text-left"
                  title="Profil zawodnika"
                >
                  {p.name}
                </button>
                <div className="flex items-center gap-3">
                  <TeamLogo
                    team={p.team}
                    darkMode={darkMode}
                    size={40}
                    onClick={() => openTeam(p.team)}
                  />
                  <div className="font-extrabold">
                    <TeamLink
                      team={p.team}
                      onClick={() => openTeam(p.team)}
                      className="e3d-link"
                    />
                  </div>
                </div>
                <div className="text-right font-extrabold">
                  {tab === "scorers"
                    ? p.goals
                    : tab === "assists"
                    ? p.assists
                    : tab === "yellow"
                    ? p.yellow
                    : p.red}
                </div>
              </div>
            </div>
          ))}
        </Card>
      ) : (
        <Card darkMode={darkMode}>
          <TeamStatsTable
            darkMode={darkMode}
            teamRows={teamRows}
            openTeam={openTeam}
          />
        </Card>
      )}
    </div>
  );
}

function LiveMatchDetails({
  darkMode,
  fixture,
  playersByTeam,
  openTeam,
  openPlayer,
}) {
  // Symulujemy mecz w trakcie z zdarzeniami (2:1)
  const homeTeamPlayers = playersByTeam?.[fixture.home] || [];
  const awayTeamPlayers = playersByTeam?.[fixture.away] || [];

  // Tworzenie realistycznych zdarzeń (60' gry)
  const liveEvents = useMemo(() => {
    const rng = mulberry32(hashString(`live|${fixture.id}`));
    const events = [];

    // 2 bramki gospodarzy
    if (homeTeamPlayers.length >= 2) {
      events.push({
        type: "GOAL",
        team: fixture.home,
        playerName:
          homeTeamPlayers[Math.floor(rng() * homeTeamPlayers.length)]?.name ||
          "Zawodnik 1",
        playerId:
          homeTeamPlayers[Math.floor(rng() * homeTeamPlayers.length)]?.id ||
          "p1",
        minute: 12,
      });
      events.push({
        type: "GOAL",
        team: fixture.home,
        playerName:
          homeTeamPlayers[Math.floor(rng() * homeTeamPlayers.length)]?.name ||
          "Zawodnik 2",
        playerId:
          homeTeamPlayers[Math.floor(rng() * homeTeamPlayers.length)]?.id ||
          "p2",
        minute: 48,
      });
    }

    // 1 bramka gości
    if (awayTeamPlayers.length >= 1) {
      events.push({
        type: "GOAL",
        team: fixture.away,
        playerName:
          awayTeamPlayers[Math.floor(rng() * awayTeamPlayers.length)]?.name ||
          "Zawodnik 3",
        playerId:
          awayTeamPlayers[Math.floor(rng() * awayTeamPlayers.length)]?.id ||
          "p3",
        minute: 34,
      });
    }

    // Kilka kartek
    if (homeTeamPlayers.length >= 1) {
      events.push({
        type: "YELLOW",
        team: fixture.home,
        playerName:
          homeTeamPlayers[Math.floor(rng() * homeTeamPlayers.length)]?.name ||
          "Zawodnik 4",
        playerId:
          homeTeamPlayers[Math.floor(rng() * homeTeamPlayers.length)]?.id ||
          "p4",
        minute: 28,
      });
    }

    if (awayTeamPlayers.length >= 2) {
      events.push({
        type: "YELLOW",
        team: fixture.away,
        playerName:
          awayTeamPlayers[Math.floor(rng() * awayTeamPlayers.length)]?.name ||
          "Zawodnik 5",
        playerId:
          awayTeamPlayers[Math.floor(rng() * awayTeamPlayers.length)]?.id ||
          "p5",
        minute: 41,
      });
    }

    return events;
  }, [fixture, homeTeamPlayers, awayTeamPlayers]);

  // Grupowanie zdarzeń per zawodnik
  const getEventsPerPlayer = (teamEvents) => {
    const playerEvents = {};
    teamEvents.forEach((e) => {
      if (!playerEvents[e.playerName]) {
        playerEvents[e.playerName] = {
          playerName: e.playerName,
          playerId: e.playerId,
          goals: 0,
          yellows: 0,
          reds: 0,
        };
      }
      if (e.type === "GOAL") playerEvents[e.playerName].goals++;
      else if (e.type === "YELLOW") playerEvents[e.playerName].yellows++;
      else if (e.type === "RED") playerEvents[e.playerName].reds++;
    });
    return Object.values(playerEvents);
  };

  const homeEvents = liveEvents.filter((e) => e.team === fixture.home);
  const awayEvents = liveEvents.filter((e) => e.team === fixture.away);

  const homePlayerEvents = getEventsPerPlayer(homeEvents);
  const awayPlayerEvents = getEventsPerPlayer(awayEvents);

  const EventIcons = ({ player }) => (
    <div className="flex items-center gap-1">
      {player.goals > 0 && (
        <span className="text-sm">
          ⚽{player.goals > 1 ? `×${player.goals}` : ""}
        </span>
      )}
      {player.yellows > 0 && player.reds > 0 && (
        <span className="text-sm">🟨🟥</span>
      )}
      {player.reds > 0 && player.yellows === 0 && (
        <span className="text-sm">🟥</span>
      )}
      {player.yellows > 0 && player.reds === 0 && (
        <span className="text-sm">
          🟨{player.yellows > 1 ? `×${player.yellows}` : ""}
        </span>
      )}
    </div>
  );

  return (
    <Card darkMode={darkMode} className="mt-3">
      <div className="grid lg:grid-cols-2 gap-3">
        {/* Gospodarze */}
        <div className="space-y-3">
          <div className="font-extrabold text-sm">
            {displayTeamName(fixture.home)}
          </div>
          {homePlayerEvents.length === 0 ? (
            <div
              className={classNames(
                "text-xs",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              Brak zdarzeń.
            </div>
          ) : (
            <div className="space-y-1.5">
              {homePlayerEvents.map((player, idx) => (
                <div
                  key={idx}
                  className={classNames(
                    "p-2 rounded-lg border flex items-center justify-between gap-2",
                    darkMode
                      ? "border-white/10 bg-black/10"
                      : "border-gray-200 bg-gray-50"
                  )}
                >
                  <button
                    onClick={() => openPlayer && openPlayer(player.playerId)}
                    className="font-bold text-sm hover:underline"
                  >
                    {player.playerName}
                  </button>
                  <EventIcons player={player} />
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Goście */}
        <div className="space-y-3">
          <div className="font-extrabold text-sm">
            {displayTeamName(fixture.away)}
          </div>
          {awayPlayerEvents.length === 0 ? (
            <div
              className={classNames(
                "text-xs",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              Brak zdarzeń.
            </div>
          ) : (
            <div className="space-y-1.5">
              {awayPlayerEvents.map((player, idx) => (
                <div
                  key={idx}
                  className={classNames(
                    "p-2 rounded-lg border flex items-center justify-between gap-2",
                    darkMode
                      ? "border-white/10 bg-black/10"
                      : "border-gray-200 bg-gray-50"
                  )}
                >
                  <button
                    onClick={() => openPlayer && openPlayer(player.playerId)}
                    className="font-bold text-sm hover:underline"
                  >
                    {player.playerName}
                  </button>
                  <EventIcons player={player} />
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </Card>
  );
}

function sortMatchParticipantRows(rows) {
  return (rows || [])
    .slice()
    .sort((a, b) => {
      const numberA = a.number ?? Number.MAX_SAFE_INTEGER;
      const numberB = b.number ?? Number.MAX_SAFE_INTEGER;
      if (numberA !== numberB) return numberA - numberB;
      return String(a.playerName || "").localeCompare(String(b.playerName || ""), "pl");
    });
}

function buildMatchParticipants(match, lineups, events) {
  const buckets = {
    home: new Map(),
    away: new Map(),
  };

  const resolveTeamKey = (teamName, teamId) => {
    if (teamName && teamName === match.home) return "home";
    if (teamName && teamName === match.away) return "away";
    if (teamId && teamId === match.homeTeamId) return "home";
    if (teamId && teamId === match.awayTeamId) return "away";
    return null;
  };

  const ensurePlayer = (teamKey, playerData) => {
    if (!teamKey || !playerData?.playerId) return null;
    if (!buckets[teamKey].has(playerData.playerId)) {
      buckets[teamKey].set(playerData.playerId, {
        playerId: playerData.playerId,
        playerName: playerData.playerName || "Bez nazwy",
        pos: playerData.pos || "",
        number: playerData.number ?? null,
        goals: 0,
        assists: 0,
        yellows: 0,
        reds: 0,
      });
    }

    const current = buckets[teamKey].get(playerData.playerId);
    if (!current.playerName && playerData.playerName) current.playerName = playerData.playerName;
    if (!current.pos && playerData.pos) current.pos = playerData.pos;
    if (current.number == null && playerData.number != null) current.number = playerData.number;
    return current;
  };

  for (const lineup of lineups || []) {
    const teamKey = resolveTeamKey(lineup.team, lineup.teamId);
    ensurePlayer(teamKey, {
      playerId: lineup.id,
      playerName: lineup.name,
      pos: lineup.pos,
      number: lineup.number,
    });
  }

  for (const event of events || []) {
    const teamKey = resolveTeamKey(event.team, event.teamId);
    const player = ensurePlayer(teamKey, {
      playerId: event.playerId,
      playerName: event.playerName,
    });
    if (!player) continue;

    if (event.type === "GOAL") player.goals += 1;
    if (event.type === "YELLOW") player.yellows += 1;
    if (event.type === "RED") player.reds += 1;

    if (event.type === "GOAL" && event.assistId) {
      const assistPlayer = ensurePlayer(teamKey, {
        playerId: event.assistId,
        playerName: event.assistName,
      });
      if (assistPlayer) assistPlayer.assists += 1;
    }
  }

  return {
    home: sortMatchParticipantRows(Array.from(buckets.home.values())),
    away: sortMatchParticipantRows(Array.from(buckets.away.values())),
  };
}

function MatchPlayerEventIcons({ player }) {
  return (
    <div className="flex items-center gap-1.5 flex-wrap justify-end">
      {player.goals > 0 && (
        <span className="text-sm">
          ⚽{player.goals > 1 ? `×${player.goals}` : ""}
        </span>
      )}
      {player.assists > 0 && (
        <span className="text-sm">
          👟{player.assists > 1 ? `×${player.assists}` : ""}
        </span>
      )}
      {player.yellows > 0 && (
        <span className="text-sm">
          🟨{player.yellows > 1 ? `×${player.yellows}` : ""}
        </span>
      )}
      {player.reds > 0 && (
        <span className="text-sm">
          🟥{player.reds > 1 ? `×${player.reds}` : ""}
        </span>
      )}
    </div>
  );
}

function MatchDetailsInline({ darkMode, match, openTeam, openPlayer, openGallery }) {
  const [details, setDetails] = useState({
    events: match.events || [],
    lineups: [...(match.homeLineup || []), ...(match.awayLineup || [])],
  });
  const [detailsLoading, setDetailsLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    fetchMatchDetails(match.id).then(details => {
      if (!cancelled) {
        setDetails({
          events: details.events || [],
          lineups: details.lineups || [],
        });
        setDetailsLoading(false);
      }
    }).catch(() => {
      if (!cancelled) setDetailsLoading(false);
    });
    return () => { cancelled = true; };
  }, [match.id]);

  const leagueName =
    ({ "1st": "I Liga", "2nd": "II Liga", "3rd": "III Liga" }[match.league] || match.league);
  const participants = useMemo(
    () => buildMatchParticipants(match, details.lineups, details.events),
    [match, details]
  );

  const SectionTitle = ({ children }) => (
    <div
      className={classNames(
        "font-extrabold mb-2 text-sm",
        darkMode ? "text-white" : "text-gray-900"
      )}
    >
      {children}
    </div>
  );

  const Empty = ({ children }) => (
    <div
      className={classNames(
        "text-xs",
        darkMode ? "text-gray-400" : "text-gray-600"
      )}
    >
      {children}
    </div>
  );

  if (detailsLoading) {
    return (
      <Card darkMode={darkMode} className="mt-2">
        <div className={classNames("text-sm text-center py-4", darkMode ? "text-gray-400" : "text-gray-500")}>
          Ładowanie szczegółów meczu...
        </div>
      </Card>
    );
  }

  return (
    <Card darkMode={darkMode} className="mt-2">
      <div
        className={classNames(
          "text-xs mb-3 pb-2 border-b",
          darkMode
            ? "text-gray-400 border-white/10"
            : "text-gray-600 border-gray-200"
        )}
      >
        <span className="font-semibold">{leagueName}</span>
        <span> • </span>
        <span className="font-semibold">Kolejka {match.round}</span>
        <span> • </span>
        <span className="font-semibold">
          {match.date} {match.time}
        </span>
        <MediaIcons
          darkMode={darkMode}
          videoUrl={match.videoUrl}
          galleryUrl={match.galleryUrl}
          galleryCount={match.galleryCount}
          onOpenGallery={
            match.hasGallery ? () => openGallery?.(match) : undefined
          }
          className="ml-2"
        />
      </div>

      <div className="grid lg:grid-cols-2 gap-3">
        {/* Lewa kolumna - drużyna gospodarzy */}
        <div className="space-y-3">
          <SectionTitle>{displayTeamName(match.home)}</SectionTitle>
          {participants.home.length === 0 ? (
            <Empty>Brak skladu meczu.</Empty>
          ) : (
            <div className="space-y-1.5">
              {participants.home.map((player) => (
                <div
                  key={player.playerId}
                  className={classNames(
                    "p-2 rounded-lg border flex items-center justify-between gap-2",
                    darkMode
                      ? "border-white/10 bg-black/10"
                      : "border-gray-200 bg-gray-50"
                  )}
                >
                  <button
                    onClick={() => openPlayer && openPlayer(player.playerId)}
                    className="font-bold text-sm hover:underline"
                  >
                    {player.number != null ? `${player.number}. ` : ""}{player.playerName}
                  </button>
                  <MatchPlayerEventIcons player={player} />
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Prawa kolumna - drużyna gości */}
        <div className="space-y-3">
          <SectionTitle>{displayTeamName(match.away)}</SectionTitle>
          {participants.away.length === 0 ? (
            <Empty>Brak skladu meczu.</Empty>
          ) : (
            <div className="space-y-1.5">
              {participants.away.map((player) => (
                <div
                  key={player.playerId}
                  className={classNames(
                    "p-2 rounded-lg border flex items-center justify-between gap-2",
                    darkMode
                      ? "border-white/10 bg-black/10"
                      : "border-gray-200 bg-gray-50"
                  )}
                >
                  <button
                    onClick={() => openPlayer && openPlayer(player.playerId)}
                    className="font-bold text-sm hover:underline"
                  >
                    {player.number != null ? `${player.number}. ` : ""}{player.playerName}
                  </button>
                  <MatchPlayerEventIcons player={player} />
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* MVP meczu - kompaktowa wersja */}
      {match.mvp && (
        <div className={classNames(
          "mt-3 pt-3 border-t flex items-center gap-2",
          darkMode ? "border-white/10" : "border-gray-200"
        )}>
          <div className={classNames(
            "px-2 py-1 rounded-lg border font-black text-xs",
            darkMode ? "bg-amber-500/20 border-amber-500/30 text-amber-200" : "bg-amber-100 border-amber-300 text-amber-900"
          )}>
            ⭐ MVP
          </div>
          {match.mvp.team && (
            <TeamLogo
              team={match.mvp.team}
              darkMode={darkMode}
              size={24}
              onClick={() => openTeam(match.mvp.team)}
            />
          )}
          <button
            onClick={() => match.mvp.playerId && openPlayer && openPlayer(match.mvp.playerId)}
            className="font-bold text-sm hover:underline"
          >
            {match.mvp.playerName}
          </button>
        </div>
      )}
    </Card>
  );
}

function MatchDetails({ darkMode, match, onBack, openTeam, goToLeague, openGallery }) {
  const [details, setDetails] = useState({
    events: match.events || [],
    lineups: [...(match.homeLineup || []), ...(match.awayLineup || [])],
  });
  const [detailsLoading, setDetailsLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    fetchMatchDetails(match.id).then(details => {
      if (!cancelled) {
        setDetails({
          events: details.events || [],
          lineups: details.lineups || [],
        });
        setDetailsLoading(false);
      }
    }).catch(() => {
      if (!cancelled) setDetailsLoading(false);
    });
    return () => { cancelled = true; };
  }, [match.id]);

  const leagueName =
    ({ "1st": "I Liga", "2nd": "II Liga", "3rd": "III Liga" }[match.league] || match.league);

  const participants = useMemo(
    () => buildMatchParticipants(match, details.lineups, details.events),
    [match, details]
  );

  const goals = details.events.filter((e) => e.type === "GOAL");
  const cards = details.events.filter(
    (e) => e.type === "YELLOW" || e.type === "RED"
  );

  const goalsHome = goals.filter((g) => g.team === match.home);
  const goalsAway = goals.filter((g) => g.team === match.away);

  const cardsHome = cards.filter((c) => c.team === match.home);
  const cardsAway = cards.filter((c) => c.team === match.away);

  const Header = () => (
    <Card darkMode={darkMode}>
      <div className="flex items-center justify-between gap-3">
        <div className="flex items-center gap-3">
          <TeamLogo
            team={match.home}
            darkMode={darkMode}
            size={56}
            onClick={() => openTeam(match.home)}
          />
          <div className="font-extrabold text-lg">
            <TeamLink
              team={displayTeamName(match.home)}
              onClick={() => openTeam(match.home)}
              className="e3d-link"
            />
          </div>
        </div>

        <div
          className={classNames(
            "px-5 py-2 rounded-2xl border font-black text-2xl e3d-pill",
            darkMode
              ? "bg-white/5 border-white/10"
              : "bg-black/5 border-black/10"
          )}
        >
          {match.homeGoals} : {match.awayGoals}
        </div>

        <div className="flex items-center gap-3">
          <div className="font-extrabold text-lg text-right">
            <TeamLink
              team={displayTeamName(match.away)}
              onClick={() => openTeam(match.away)}
              className="e3d-link"
            />
          </div>
          <TeamLogo
            team={match.away}
            darkMode={darkMode}
            size={56}
            onClick={() => openTeam(match.away)}
          />
        </div>
      </div>

      <div
        className={classNames(
          "mt-2 flex flex-wrap gap-2 text-xs",
          darkMode ? "text-gray-400" : "text-gray-600"
        )}
      >
        <span className="font-semibold">
          <LeagueLink
            leagueId={match.league}
            leagueName={leagueName}
            onClick={() => goToLeague && goToLeague(match.league)}
          />
        </span>
        <span>•</span>
        <span className="font-semibold">Kolejka {match.round}</span>
        <span>•</span>
        <span className="font-semibold">
          {match.date} {match.time}
        </span>

        <MediaIcons
          darkMode={darkMode}
          videoUrl={match.videoUrl}
          galleryUrl={match.galleryUrl}
          galleryCount={match.galleryCount}
          onOpenGallery={
            match.hasGallery ? () => openGallery?.(match) : undefined
          }
        />
      </div>
    </Card>
  );

  const SectionTitle = ({ children }) => (
    <div
      className={classNames(
        "font-extrabold mb-2",
        darkMode ? "text-white" : "text-gray-900"
      )}
    >
      {children}
    </div>
  );

  const Empty = ({ children }) => (
    <div className={darkMode ? "text-gray-400" : "text-gray-600"}>
      {children}
    </div>
  );

  const GoalItem = ({ g }) => (
    <div
      className={classNames(
        "p-2 rounded-xl border",
        darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"
      )}
    >
      <div className="font-bold">
        {g.playerName}
        {g.penalty && (
          <span className={classNames(
            "ml-2 text-xs px-1.5 py-0.5 rounded border font-black",
            darkMode ? "bg-blue-500/20 border-blue-500/30 text-blue-200" : "bg-blue-100 border-blue-300 text-blue-900"
          )}>
            KARNY
          </span>
        )}
      </div>
      <div
        className={classNames(
          "text-xs",
          darkMode ? "text-gray-400" : "text-gray-600"
        )}
      >
        {g.penalty ? "Rzut karny" : (g.assistName ? `Asysta: ${g.assistName}` : "Brak asysty")}
      </div>
    </div>
  );

  const CardItem = ({ c }) => (
    <div
      className={classNames(
        "p-2 rounded-xl border flex items-center justify-between gap-2",
        darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"
      )}
    >
      <div className="font-bold">{c.playerName}</div>
      <div
        className={classNames(
          "text-xs font-black px-2 py-1 rounded-full border e3d-pill",
          c.type === "RED"
            ? "bg-rose-400/30 border-rose-500/30 text-rose-200"
            : "bg-yellow-300/30 border-yellow-500/30 text-yellow-100"
        )}
      >
        {c.type === "RED" ? "CZERW." : "ŻÓŁTA"}
      </div>
    </div>
  );

  if (detailsLoading) {
    return (
      <div className="space-y-4">
        <Header />
        <Card darkMode={darkMode}>
          <div className={classNames("text-sm text-center py-6", darkMode ? "text-gray-400" : "text-gray-500")}>
            Ładowanie szczegółów meczu...
          </div>
        </Card>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {onBack && (
        <BackHeader
          darkMode={darkMode}
          title="Szczegóły spotkania"
          onBack={onBack}
        />
      )}

      <Card darkMode={darkMode}>
        <div className="flex items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <TeamLogo
              team={match.home}
              darkMode={darkMode}
              size={56}
              onClick={() => openTeam(match.home)}
            />
            <div className="font-extrabold text-lg">
              <TeamLink
                team={displayTeamName(match.home)}
                onClick={() => openTeam(match.home)}
                className="e3d-link"
              />
            </div>
          </div>

          <div
            className={classNames(
              "px-5 py-2 rounded-2xl border font-black text-2xl e3d-pill",
              darkMode
                ? "bg-white/5 border-white/10"
                : "bg-black/5 border-black/10"
            )}
          >
            {match.homeGoals} : {match.awayGoals}
          </div>

          <div className="flex items-center gap-3">
            <div className="font-extrabold text-lg text-right">
              <TeamLink
                team={displayTeamName(match.away)}
                onClick={() => openTeam(match.away)}
                className="e3d-link"
              />
            </div>
            <TeamLogo
              team={match.away}
              darkMode={darkMode}
              size={56}
              onClick={() => openTeam(match.away)}
            />
          </div>
        </div>

        <div
          className={classNames(
            "mt-2 flex flex-wrap gap-2 text-xs items-center",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          <span className="font-semibold">{leagueName}</span>
          <span>•</span>
          <span className="font-semibold">Kolejka {match.round}</span>
          <span>•</span>
          <span className="font-semibold">
            {match.date} {match.time}
          </span>
          {match.referee && (
            <>
              <span>•</span>
              <span className="font-semibold">Sędzia: {match.referee}</span>
            </>
          )}
          <MediaIcons
            darkMode={darkMode}
            videoUrl={match.videoUrl}
            galleryUrl={match.galleryUrl}
            galleryCount={match.galleryCount}
            onOpenGallery={
              match.hasGallery ? () => openGallery?.(match) : undefined
            }
            className="ml-2"
          />
        </div>
      </Card>

      {/* Bramki i kartki w układzie lewa/prawa strona */}
      <div className="grid lg:grid-cols-2 gap-3">
        {/* Lewa kolumna - drużyna gospodarzy */}
        <Card darkMode={darkMode}>
          <SectionTitle>{displayTeamName(match.home)} – bramki</SectionTitle>
          {goalsHome.length === 0 ? (
            <Empty>Brak bramek.</Empty>
          ) : (
            <div className="space-y-2">
              {goalsHome.map((g, idx) => (
                <GoalItem key={idx} g={g} />
              ))}
            </div>
          )}

          <div className="mt-4">
            <SectionTitle>{displayTeamName(match.home)} – kartki</SectionTitle>
            {cardsHome.length === 0 ? (
              <Empty>Brak kartek.</Empty>
            ) : (
              <div className="space-y-2">
                {cardsHome.map((c, idx) => (
                  <CardItem key={idx} c={c} />
                ))}
              </div>
            )}
          </div>
        </Card>

        {/* Prawa kolumna - drużyna gości */}
        <Card darkMode={darkMode}>
          <SectionTitle>{displayTeamName(match.away)} – bramki</SectionTitle>
          {goalsAway.length === 0 ? (
            <Empty>Brak bramek.</Empty>
          ) : (
            <div className="space-y-2">
              {goalsAway.map((g, idx) => (
                <GoalItem key={idx} g={g} />
              ))}
            </div>
          )}

          <div className="mt-4">
            <SectionTitle>{displayTeamName(match.away)} – kartki</SectionTitle>
            {cardsAway.length === 0 ? (
              <Empty>Brak kartek.</Empty>
            ) : (
              <div className="space-y-2">
                {cardsAway.map((c, idx) => (
                  <CardItem key={idx} c={c} />
                ))}
              </div>
            )}
          </div>
        </Card>
      </div>

      {/* MVP meczu */}
      {match.mvp && (
        <Card darkMode={darkMode}>
          <div className="flex items-center gap-4">
            <div className={classNames(
              "px-3 py-1.5 rounded-xl border font-black text-xs",
              darkMode ? "bg-amber-500/20 border-amber-500/30 text-amber-200" : "bg-amber-100 border-amber-300 text-amber-900"
            )}>
              ⭐ MVP MECZU
            </div>
            <div className="flex items-center gap-3">
              {match.mvp.team && (
                <TeamLogo
                  team={match.mvp.team}
                  darkMode={darkMode}
                  size={40}
                  onClick={() => openTeam(match.mvp.team)}
                />
              )}
              <div>
                <div className="font-extrabold text-lg">{match.mvp.playerName}</div>
                {match.mvp.team && (
                  <div className={classNames(
                    "text-sm",
                    darkMode ? "text-gray-400" : "text-gray-600"
                  )}>
                    <TeamLink
                      team={displayTeamName(match.mvp.team)}
                      onClick={() => openTeam(match.mvp.team)}
                      className="e3d-link"
                    />
                  </div>
                )}
              </div>
            </div>
          </div>
        </Card>
      )}

      {/* Uczestnicy meczu */}
      {(participants.home.length > 0 || participants.away.length > 0) && (
        <div className="grid lg:grid-cols-2 gap-3">
          {participants.home.length > 0 && (
            <Card darkMode={darkMode}>
              <SectionTitle>Uczestnicy – {displayTeamName(match.home)}</SectionTitle>
              <div className="space-y-1.5">
                {participants.home.map((player) => (
                  <div
                    key={player.playerId}
                    className={classNames(
                      "p-2 rounded-lg border flex items-center justify-between gap-3",
                      darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"
                    )}
                  >
                    <div>
                      <div className="font-bold text-sm">
                        {player.number != null ? `${player.number}. ` : ""}{player.playerName}
                      </div>
                      <div className={classNames(
                        "text-xs",
                        darkMode ? "text-gray-400" : "text-gray-600"
                      )}>
                        {player.pos || "Bez pozycji"}
                      </div>
                    </div>
                    <MatchPlayerEventIcons player={player} />
                  </div>
                ))}
              </div>
            </Card>
          )}

          {participants.away.length > 0 && (
            <Card darkMode={darkMode}>
              <SectionTitle>Uczestnicy – {displayTeamName(match.away)}</SectionTitle>
              <div className="space-y-1.5">
                {participants.away.map((player) => (
                  <div
                    key={player.playerId}
                    className={classNames(
                      "p-2 rounded-lg border flex items-center justify-between gap-3",
                      darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"
                    )}
                  >
                    <div>
                      <div className="font-bold text-sm">
                        {player.number != null ? `${player.number}. ` : ""}{player.playerName}
                      </div>
                      <div className={classNames(
                        "text-xs",
                        darkMode ? "text-gray-400" : "text-gray-600"
                      )}>
                        {player.pos || "Bez pozycji"}
                      </div>
                    </div>
                    <MatchPlayerEventIcons player={player} />
                  </div>
                ))}
              </div>
            </Card>
          )}
        </div>
      )}
    </div>
  );
}
function TeamProfile({
  darkMode,
  team,
  leagueId,
  teamRow,
  recentMatches,
  fixtures,
  matches,
  openMatch,
  onBack,
  openTeam,
  openPlayer,
  currentSeason,
}) {
  const leagueName = ({ "1st": "I Liga", "2nd": "II Liga", "3rd": "III Liga" }[leagueId] || leagueId);

  const [teamData, setTeamData] = useState(null);
  const [roster, setRoster] = useState([]);
  const [history, setHistory] = useState([]);
  const [rosterLoading, setRosterLoading] = useState(true);
  const [showFullSchedule, setShowFullSchedule] = useState(false);

  useEffect(() => {
    let cancelled = false;
    Promise.all([
      fetchTeamProfile(team),
      fetchTeamRoster(team, currentSeason),
      fetchTeamHistory(team),
    ]).then(([td, rs, hs]) => {
      if (!cancelled) {
        setTeamData(td);
        setRoster(rs);
        setHistory(hs);
        setRosterLoading(false);
      }
    }).catch(() => { if (!cancelled) setRosterLoading(false); });
    return () => { cancelled = true; };
  }, [team, currentSeason]);

  const positionNames = { BR: "BR", OBR: "OBR", POM: "POM", NAP: "NAP" };
  const positionOrder = { BR: 0, OBR: 1, POM: 2, NAP: 3 };
  const sortedRoster = [...roster].sort((a, b) => (positionOrder[a.pos] ?? 9) - (positionOrder[b.pos] ?? 9));
  const teamSchedule = useMemo(
    () => getTeamScheduleEntries(team, fixtures, matches),
    [team, fixtures, matches]
  );
  const recentSchedule = useMemo(
    () => [...teamSchedule]
      .filter((item) => item.played)
      .sort((a, b) => teamScheduleSortKey(b, "desc").localeCompare(teamScheduleSortKey(a, "desc")) || b.round - a.round)
      .slice(0, 5),
    [teamSchedule]
  );
  const upcomingSchedule = useMemo(
    () => [...teamSchedule]
      .filter((item) => !item.played && item.status !== "cancelled")
      .sort((a, b) => teamScheduleSortKey(a).localeCompare(teamScheduleSortKey(b)) || a.round - b.round)
      .slice(0, 5),
    [teamSchedule]
  );
  const fullSchedule = useMemo(
    () => [...teamSchedule]
      .sort((a, b) => a.round - b.round || teamScheduleSortKey(a).localeCompare(teamScheduleSortKey(b))),
    [teamSchedule]
  );

  const scheduleStatusLabel = (item) => {
    if (item.played) return `${item.homeGoals} : ${item.awayGoals}`;
    if (item.status === "postponed") return "Przełożony";
    if (item.status === "unplayed") return "Nierozegrany";
    if (item.status === "cancelled") return "Odwołany";
    return item.time || "Termin";
  };

  return (
    <div className="space-y-4">
      {onBack && (
        <BackHeader
          darkMode={darkMode}
          title={`Profil drużyny: ${team}`}
          onBack={onBack}
        />
      )}

      <Card darkMode={darkMode}>
        <div className="flex items-start gap-4">
          {/* Zdjęcie drużyny po lewej */}
          <div className="flex-shrink-0">
            <div
              className={classNames(
                "w-40 h-40 rounded-2xl border-2 flex items-center justify-center e3d-card",
                darkMode
                  ? "bg-white/5 border-white/10"
                  : "bg-gray-100 border-gray-300"
              )}
              title="Zdjęcie drużyny"
            >
              <svg
                className={classNames(
                  "w-28 h-28",
                  darkMode ? "text-white/20" : "text-gray-400"
                )}
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5s-3 1.34-3 3 1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z" />
              </svg>
            </div>
          </div>

          {/* Dane drużyny */}
          <div className="flex-1 min-w-0">
            <div className="flex items-start justify-between gap-3">
              <div className="flex items-center gap-3 min-w-0">
                <TeamLogo
                  team={team}
                  darkMode={darkMode}
                  size={64}
                  onClick={() => openTeam(team)}
                />
                <div className="min-w-0">
                  <div className="text-2xl font-extrabold truncate">{team}</div>
                  <div
                    className={classNames(
                      "text-sm",
                      darkMode ? "text-gray-400" : "text-gray-600"
                    )}
                  >
                    {leagueName}
                  </div>

                  {/* Rok założenia i lokalizacja */}
                  <div
                    className={classNames(
                      "mt-1 text-xs flex gap-3",
                      darkMode ? "text-gray-400" : "text-gray-600"
                    )}
                  >
                    {teamData?.founded_year && (
                      <span>
                        Rok zał.: <b>{teamData.founded_year}</b>
                      </span>
                    )}
                    {teamData?.district && (
                      <span>
                        Lokalizacja: <b>{teamData.district}</b>
                      </span>
                    )}
                  </div>
                </div>
              </div>
            </div>

            <div
              className={classNames(
                "mt-3 flex flex-wrap gap-2 text-xs",
                darkMode ? "text-gray-300" : "text-gray-700"
              )}
            >
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                M: <b>{teamRow?.played ?? 0}</b>
              </span>
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                Pkt: <b>{teamRow?.pts ?? 0}</b>
              </span>
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                BZ/BS:{" "}
                <b>
                  {teamRow?.gf ?? 0}/{teamRow?.ga ?? 0}
                </b>
              </span>
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                Bez por.: <b>{teamRow?.streakUnbeaten ?? 0}</b>
              </span>
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                Seria W: <b>{teamRow?.streakWins ?? 0}</b>
              </span>
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                Bez wygr.: <b>{teamRow?.streakWinless ?? 0}</b>
              </span>
            </div>
          </div>
        </div>

        <div className="mt-3 flex gap-2">
          {getTeamFormDotsWithTooltips(team, recentMatches).map((d, i) => (
            <FormDot key={i} v={d.v} title={d.title} />
          ))}
        </div>
      </Card>

      <div className="grid lg:grid-cols-2 gap-3">
        <Card darkMode={darkMode}>
          <div className="font-extrabold mb-2">
            Kadra ({rosterLoading ? '...' : sortedRoster.length} zawodników)
          </div>
          {rosterLoading ? (
            <div className={classNames("text-sm py-4 text-center", darkMode ? "text-gray-400" : "text-gray-500")}>
              Ładowanie kadry...
            </div>
          ) : sortedRoster.length === 0 ? (
            <div className={darkMode ? "text-gray-400" : "text-gray-600"}>
              Brak danych o kadrze na sezon {currentSeason}.
            </div>
          ) : (
            <div className="space-y-2">
              {sortedRoster.map((p) => (
                <div
                  key={p.id}
                  className={classNames(
                    "p-2 rounded-xl border flex items-center justify-between gap-3",
                    darkMode
                      ? "border-white/10 bg-black/10"
                      : "border-gray-200 bg-gray-50"
                  )}
                >
                  <div className="font-bold flex items-center gap-2 min-w-0">
                    {p.number && (
                      <span
                        className={classNames(
                          "inline-block w-8 text-center px-2 py-1 rounded-lg border e3d-pill flex-shrink-0",
                          darkMode
                            ? "border-white/10 bg-white/5"
                            : "border-black/10 bg-black/5"
                        )}
                      >
                        {p.number}
                      </span>
                    )}
                    <button
                      onClick={() => openPlayer(p.id)}
                      className="font-extrabold hover:underline truncate"
                      title="Profil zawodnika"
                    >
                      {p.isCaptain ? '(C) ' : ''}{p.name}
                    </button>
                  </div>
                  <div
                    className={classNames(
                      "text-xs font-semibold flex-shrink-0 flex items-center gap-1",
                      darkMode ? "text-gray-400" : "text-gray-600"
                    )}
                  >
                    <span>{positionNames[p.pos] || p.pos}</span>
                    {p.goals > 0 && <span>⚽{p.goals > 1 ? `×${p.goals}` : ''}</span>}
                    {p.assists > 0 && <span>👟{p.assists > 1 ? `×${p.assists}` : ''}</span>}
                    {p.yellowCards > 0 && <span>🟨{p.yellowCards > 1 ? `×${p.yellowCards}` : ''}</span>}
                    {p.redCards > 0 && <span>🟥</span>}
                  </div>
                </div>
              ))}
            </div>
          )}
        </Card>

        <Card darkMode={darkMode}>
          <button
            onClick={() => setShowFullSchedule((prev) => !prev)}
            className="w-full text-left"
          >
            <div className="flex items-center justify-between gap-3 mb-3">
              <div>
                <div className="font-extrabold">Terminarz</div>
                <div className={classNames("text-xs mt-0.5", darkMode ? "text-gray-400" : "text-gray-600")}>
                  5 ostatnich i 5 najbliższych spotkań. Kliknij, aby {showFullSchedule ? "zwinąć" : "otworzyć"} pełny terminarz sezonu.
                </div>
              </div>
              <div
                className={classNames(
                  "px-3 py-1 rounded-full border text-xs font-black e3d-pill",
                  darkMode ? "border-white/10 bg-white/5" : "border-black/10 bg-black/5"
                )}
              >
                {showFullSchedule ? "Zwiń" : "Otwórz"}
              </div>
            </div>

            {teamSchedule.length === 0 ? (
              <div className={darkMode ? "text-gray-400" : "text-gray-600"}>
                Brak spotkań tej drużyny w sezonie {currentSeason}.
              </div>
            ) : (
              <div className="grid gap-3 md:grid-cols-2">
                <div
                  className={classNames(
                    "rounded-xl border p-3",
                    darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"
                  )}
                >
                  <div className="font-bold mb-2">Ostatnie 5</div>
                  {recentSchedule.length === 0 ? (
                    <div className={classNames("text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                      Brak rozegranych spotkań.
                    </div>
                  ) : (
                    <div className="space-y-2">
                      {recentSchedule.map((item) => (
                        <div
                          key={item.id}
                          className={classNames(
                            "grid grid-cols-[56px_minmax(0,1fr)_auto] gap-2 items-center text-sm",
                            darkMode ? "text-gray-200" : "text-gray-800"
                          )}
                        >
                          <span className={darkMode ? "text-gray-400" : "text-gray-600"}>
                            {formatShortFixtureDate(item.date)}
                          </span>
                          <span className="font-bold truncate">{displayTeamName(item.opponent)}</span>
                          <span className="font-black">{item.homeGoals} : {item.awayGoals}</span>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

                <div
                  className={classNames(
                    "rounded-xl border p-3",
                    darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"
                  )}
                >
                  <div className="font-bold mb-2">Najbliższe 5</div>
                  {upcomingSchedule.length === 0 ? (
                    <div className={classNames("text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                      Brak zaplanowanych spotkań.
                    </div>
                  ) : (
                    <div className="space-y-2">
                      {upcomingSchedule.map((item) => (
                        <div
                          key={item.id}
                          className={classNames(
                            "grid grid-cols-[56px_minmax(0,1fr)_auto] gap-2 items-center text-sm",
                            darkMode ? "text-gray-200" : "text-gray-800"
                          )}
                        >
                          <span className={darkMode ? "text-gray-400" : "text-gray-600"}>
                            {formatShortFixtureDate(item.date)}
                          </span>
                          <span className="font-bold truncate">{displayTeamName(item.opponent)}</span>
                          <span className="font-black text-xs">{scheduleStatusLabel(item)}</span>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </div>
            )}
          </button>
        </Card>
      </div>

      {showFullSchedule && (
        <Card darkMode={darkMode}>
          <div className="flex items-center justify-between gap-3 mb-3">
            <div>
              <div className="font-extrabold">Pełny terminarz</div>
              <div className={classNames("text-xs mt-0.5", darkMode ? "text-gray-400" : "text-gray-600")}>
                Wszystkie spotkania drużyny {displayTeamName(team)} w sezonie {currentSeason}.
              </div>
            </div>
            <button
              onClick={() => setShowFullSchedule(false)}
              className={classNames(
                "px-3 py-1 rounded-full border text-xs font-black e3d-pill",
                darkMode ? "border-white/10 bg-white/5" : "border-black/10 bg-black/5"
              )}
            >
              Zwiń
            </button>
          </div>

          {fullSchedule.length === 0 ? (
            <div className={darkMode ? "text-gray-400" : "text-gray-600"}>
              Brak spotkań do pokazania.
            </div>
          ) : (
            <div className="space-y-2">
              {fullSchedule.map((item) => {
                const header = fixtureDateHeaderParts(item.date);
                return (
                  <div
                    key={item.id}
                    className={classNames(
                      "rounded-xl border p-3",
                      darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"
                    )}
                  >
                    <div className="flex items-center justify-between gap-3 mb-2">
                      <div className={classNames("text-xs font-black uppercase tracking-[0.12em]", darkMode ? "text-cyan-200" : "text-blue-700")}>
                        Kolejka {item.round}
                      </div>
                      <div className={classNames("text-xs", darkMode ? "text-gray-400" : "text-gray-600")}>
                        {header.date ? `${header.weekday} • ${header.date}` : header.weekday}
                        {item.time ? ` • ${item.time}` : ""}
                      </div>
                    </div>

                    <div className="grid grid-cols-[minmax(0,1fr)_120px_minmax(0,1fr)] gap-3 items-center">
                      <div className="flex items-center gap-2 min-w-0">
                        <TeamLogo
                          team={item.home}
                          darkMode={darkMode}
                          size={40}
                          onClick={() => openTeam(item.home)}
                        />
                        <div className="min-w-0 flex-1">
                          <TeamLink
                            team={item.home}
                            onClick={() => openTeam(item.home)}
                            className="font-bold e3d-link block w-full truncate"
                          />
                        </div>
                      </div>

                      <div className="flex justify-center">
                        <button
                          onClick={() => openMatch(item.id)}
                          className={classNames(
                            "w-[120px] px-2 py-1.5 rounded-xl border e3d-pill font-extrabold text-center",
                            darkMode ? "bg-white/5 border-white/10" : "bg-black/5 border-black/10"
                          )}
                          title="Kliknij: szczegóły meczu"
                        >
                          {item.played ? `${item.homeGoals} : ${item.awayGoals}` : scheduleStatusLabel(item)}
                        </button>
                      </div>

                      <div className="flex items-center justify-end gap-2 min-w-0">
                        <div className="min-w-0 flex-1">
                          <TeamLink
                            team={item.away}
                            onClick={() => openTeam(item.away)}
                            className="font-bold text-right e3d-link block w-full truncate"
                          />
                        </div>
                        <TeamLogo
                          team={item.away}
                          darkMode={darkMode}
                          size={40}
                          onClick={() => openTeam(item.away)}
                        />
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </Card>
      )}

      {/* Historia drużyny */}
      {history.length > 0 && (
        <Card darkMode={darkMode}>
          <div className="font-extrabold mb-3">Historia drużyny</div>

          <div
            className={classNames(
              "rounded-2xl border overflow-hidden",
              darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white"
            )}
          >
            <div
              className={classNames(
                "px-4 py-3 text-xs font-bold tracking-wide",
                darkMode
                  ? "text-gray-300 bg-black/20"
                  : "text-gray-600 bg-gray-50"
              )}
            >
              <div className="grid grid-cols-[120px_1fr_120px] gap-4">
                <div>Sezon</div>
                <div>Liga</div>
                <div className="text-center">Miejsce</div>
              </div>
            </div>

            {history.map((r, idx) => (
              <div
                key={idx}
                className={classNames(
                  "px-4 py-3 border-t",
                  darkMode
                    ? "border-white/10 hover:bg-white/5"
                    : "border-gray-100 hover:bg-gray-50"
                )}
              >
                <div className="grid grid-cols-[120px_1fr_120px] gap-4 items-center">
                  <div className="font-bold">{r.season}</div>
                  <div className="font-extrabold flex items-center gap-2">
                    {r.league}
                    {r.champion && <span title="Mistrz">🏆</span>}
                    {r.promoted && <span title="Awans">⬆️</span>}
                    {r.relegated && <span title="Spadek">⬇️</span>}
                  </div>
                  <div className="text-center font-black text-lg">
                    {r.position || '—'}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </Card>
      )}
    </div>
  );
}

function buildCareerHistory(player, allTeams) {
  const seed = hashString("career|" + player.id);
  const rng = mulberry32(seed);

  const seasons = ["2020", "2021", "2022", "2023", "2024", "2025"];
  const teamsPool = allTeams.filter((t) => t !== player.team);

  const rows = [];
  // pick 1-2 previous clubs + current
  const prevCount = 1 + Math.floor(rng() * 2); // 1..2
  const pickedPrev = [];
  const pool = [...teamsPool];
  while (pickedPrev.length < prevCount && pool.length) {
    const idx = Math.floor(rng() * pool.length);
    pickedPrev.push(pool.splice(idx, 1)[0]);
  }

  const clubs = [...pickedPrev, player.team];
  const startSeasonIdx = Math.max(0, seasons.length - clubs.length);

  for (let i = 0; i < clubs.length; i++) {
    const season = seasons[startSeasonIdx + i] || seasons[seasons.length - 1];
    const team = clubs[i];

    const played = 3 + Math.floor(rng() * 16); // 3..18
    const goals = Math.floor(rng() * Math.min(played, 10));
    const assists = Math.floor(rng() * Math.min(played, 10));
    const yellow = Math.floor(rng() * 5);
    const red = rng() < 0.08 ? 1 : 0;

    rows.push({ season, team, played, goals, assists, yellow, red });
  }

  // posortuj malejąco po sezonie (aktualny na górze)
  rows.sort((a, b) => seasons.indexOf(b.season) - seasons.indexOf(a.season));
  return rows;
}

function buildTeamHistory(team, currentLeague) {
  const history = [];
  
  // Sezony historyczne z prawdziwymi danymi (bez 2025 - jest w trakcie)
  const historicalSeasons = [2024, 2023, 2022];
  
  for (const season of historicalSeasons) {
    const seasonData = getTeamHistoryForSeason(team, season);
    
    if (seasonData) {
      // Mamy prawdziwe dane dla tej drużyny w tym sezonie
      history.push({
        season: seasonData.season,
        league: seasonData.league,
        position: seasonData.position,
        points: seasonData.points,
        played: seasonData.played
      });
    }
    // Jeśli brak danych - nie dodawaj tego sezonu do historii
  }
  
  // Sezon 2025 jest aktualny - NIE dodawaj go do historii jako zakończony
  // (będzie widoczny jako aktualny sezon w głównym widoku)
  
  return history;
}

function PlayerProfile({ darkMode, playerId, openTeam, onBack }) {
  const [player, setPlayer] = useState(null);
  const [career, setCareer] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    setLoading(true);
    fetchPlayerProfile(playerId).then(({ player: p, career: c }) => {
      if (!cancelled) {
        setPlayer(p);
        setCareer(c);
        setLoading(false);
      }
    }).catch(() => { if (!cancelled) setLoading(false); });
    return () => { cancelled = true; };
  }, [playerId]);

  const totals = useMemo(() => {
    return career.reduce(
      (acc, r) => {
        acc.appearances += r.appearances;
        acc.goals += r.goals;
        acc.assists += r.assists;
        acc.yellowCards += r.yellowCards;
        acc.redCards += r.redCards;
        return acc;
      },
      { appearances: 0, goals: 0, assists: 0, yellowCards: 0, redCards: 0 }
    );
  }, [career]);

  const currentTeam = career.length > 0 ? career[0].team : '';
  const positionNames = { BR: "Bramkarz", OBR: "Obrońca", POM: "Pomocnik", NAP: "Napastnik" };
  const currentYear = new Date().getFullYear();

  if (loading) {
    return (
      <div className="space-y-4">
        {onBack && <BackHeader darkMode={darkMode} title="Profil zawodnika" onBack={onBack} />}
        <Card darkMode={darkMode}>
          <div className={classNames("text-sm text-center py-6", darkMode ? "text-gray-400" : "text-gray-500")}>
            Ładowanie profilu zawodnika...
          </div>
        </Card>
      </div>
    );
  }

  if (!player) {
    return (
      <div className="space-y-4">
        {onBack && <BackHeader darkMode={darkMode} title="Profil zawodnika" onBack={onBack} />}
        <Card darkMode={darkMode}>
          <div className={darkMode ? "text-gray-300" : "text-gray-700"}>
            Brak danych zawodnika.
          </div>
        </Card>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {onBack && (
        <BackHeader
          darkMode={darkMode}
          title="Profil zawodnika"
          onBack={onBack}
        />
      )}

      <Card darkMode={darkMode}>
        <div className="flex items-start gap-4">
          {/* Zdjęcie zawodnika po lewej */}
          <div className="flex-shrink-0">
            <div
              className={classNames(
                "w-24 h-24 rounded-2xl border-2 flex items-center justify-center e3d-card",
                darkMode
                  ? "bg-white/5 border-white/10"
                  : "bg-gray-100 border-gray-300"
              )}
              title="Zdjęcie zawodnika"
            >
              <svg
                className={classNames(
                  "w-16 h-16",
                  darkMode ? "text-white/20" : "text-gray-400"
                )}
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z" />
              </svg>
            </div>
          </div>

          {/* Dane zawodnika */}
          <div className="flex-1 min-w-0">
            <div className="text-2xl font-extrabold truncate">
              {player.display_name}
            </div>
            <div
              className={classNames(
                "text-sm font-semibold",
                darkMode ? "text-gray-300" : "text-gray-700"
              )}
            >
              {positionNames[player.position] || player.position}
              {player.birth_year ? ` • ${currentYear - player.birth_year} lat` : ''}
              {player.city ? ` • ${player.city}` : ''}
              {player.preferred_foot ? ` • ${player.preferred_foot} noga` : ''}
            </div>

            <div
              className={classNames(
                "mt-3 flex flex-wrap gap-2 text-xs",
                darkMode ? "text-gray-300" : "text-gray-700"
              )}
            >
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                Występy: <b>{totals.appearances}</b>
              </span>
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                Bramki: <b>{totals.goals}</b>
              </span>
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                Asysty: <b>{totals.assists}</b>
              </span>
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                Żółte: <b>{totals.yellowCards}</b>
              </span>
              <span
                className={classNames(
                  "px-3 py-1 rounded-full border e3d-pill",
                  darkMode
                    ? "border-white/10 bg-white/5"
                    : "border-black/10 bg-black/5"
                )}
              >
                Czerwone: <b>{totals.redCards}</b>
              </span>
            </div>
          </div>

          {/* Logo klubu po prawej */}
          {currentTeam && (
            <div className="flex-shrink-0 flex flex-col items-center gap-2">
              <TeamLogo
                team={currentTeam}
                darkMode={darkMode}
                size={72}
                onClick={() => openTeam(currentTeam)}
              />
              <button
                onClick={() => openTeam(currentTeam)}
                className="text-xs font-extrabold hover:underline text-center"
                title="Profil drużyny"
              >
                {displayTeamName(currentTeam)}
              </button>
            </div>
          )}
        </div>
      </Card>

      {career.length > 0 && (
        <Card darkMode={darkMode}>
          <div className="font-extrabold mb-3">Historia kariery</div>

          <div
            className={classNames(
              "rounded-2xl border overflow-hidden",
              darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white"
            )}
          >
            <div
              className={classNames(
                "px-4 py-3 text-xs font-bold tracking-wide",
                darkMode
                  ? "text-gray-300 bg-black/20"
                  : "text-gray-600 bg-gray-50"
              )}
            >
              <div className="grid grid-cols-[80px_1fr_60px_60px_60px_60px_60px] gap-2">
                <div>Sezon</div>
                <div>Drużyna</div>
                <div className="text-right">M</div>
                <div className="text-right">G</div>
                <div className="text-right">A</div>
                <div className="text-right">Ż</div>
                <div className="text-right">C</div>
              </div>
            </div>

            {career.map((r, idx) => (
              <div
                key={idx}
                className={classNames(
                  "px-4 py-3 border-t",
                  darkMode
                    ? "border-white/10 hover:bg-white/5"
                    : "border-gray-100 hover:bg-gray-50"
                )}
              >
                <div className="grid grid-cols-[80px_1fr_60px_60px_60px_60px_60px] gap-2 items-center">
                  <div className="font-bold">{r.season}</div>
                  <div className="flex items-center gap-2 min-w-0">
                    <TeamLogo
                      team={r.team}
                      darkMode={darkMode}
                      size={32}
                      onClick={() => openTeam(r.team)}
                    />
                    <button
                      onClick={() => openTeam(r.team)}
                      className="font-extrabold hover:underline text-left truncate min-w-0"
                      title="Profil drużyny"
                    >
                      {displayTeamName(r.team)}
                    </button>
                  </div>
                  <div className="text-right font-extrabold">{r.appearances}</div>
                  <div className="text-right font-extrabold">{r.goals}</div>
                  <div className="text-right font-extrabold">{r.assists}</div>
                  <div className="text-right font-extrabold">{r.yellowCards}</div>
                  <div className="text-right font-extrabold">{r.redCards}</div>
                </div>
              </div>
            ))}

            <div
              className={classNames(
                "px-4 py-3 border-t",
                darkMode
                  ? "border-white/10 bg-black/20"
                  : "border-gray-200 bg-gray-50"
              )}
            >
              <div className="grid grid-cols-[80px_1fr_60px_60px_60px_60px_60px] gap-2 items-center">
                <div className="font-extrabold">RAZEM</div>
                <div className="font-bold opacity-70">Cała kariera</div>
                <div className="text-right font-extrabold">{totals.appearances}</div>
                <div className="text-right font-extrabold">{totals.goals}</div>
                <div className="text-right font-extrabold">{totals.assists}</div>
                <div className="text-right font-extrabold">{totals.yellowCards}</div>
                <div className="text-right font-extrabold">{totals.redCards}</div>
              </div>
            </div>
          </div>
        </Card>
      )}
    </div>
  );
}

function TournamentBracket({ darkMode, playoffs, champion }) {
  const [selectedPhase, setSelectedPhase] = useState(3); // 1=QF, 2=SF, 3=Final

  // Rozdzielamy mecze według stage
  const qf = playoffs.filter((m) => m.stage === "QF"); // 4 mecze
  const sf = playoffs.filter((m) => m.stage === "SF"); // 2 mecze
  const thirdPlace = playoffs.find((m) => m.stage === "3rd");
  const final = playoffs.find((m) => m.stage === "Final");

  const MatchRow = ({ match, label }) => (
    <div
      className={classNames(
        "p-3 rounded-xl border",
        darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"
      )}
    >
      <div className="grid grid-cols-[40px_minmax(0,1fr)_60px_minmax(0,1fr)_40px] gap-2 items-center text-sm">
        <TeamLogo team={match.home} darkMode={darkMode} size={40} />
        <div
          className={classNames(
            "truncate",
            match.homeGoals > match.awayGoals && "font-black"
          )}
        >
          {match.home}
        </div>
        <div
          className={classNames(
            "text-center font-black text-lg",
            darkMode ? "text-white" : "text-black"
          )}
        >
          {match.homeGoals} : {match.awayGoals}
        </div>
        <div
          className={classNames(
            "truncate text-right",
            match.awayGoals > match.homeGoals && "font-black"
          )}
        >
          {match.away}
        </div>
        <TeamLogo team={match.away} darkMode={darkMode} size={40} />
      </div>
      {label && (
        <div
          className={classNames(
            "text-xs mt-2 text-center",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          {label}
        </div>
      )}
    </div>
  );

  return (
    <Card darkMode={darkMode}>
      <div className="font-extrabold mb-4">Faza Pucharowa</div>

      {/* Zakładki faz */}
      <div className="flex gap-2 mb-4">
        {[
          { id: 1, label: "FAZA 1", desc: "Ćwierćfinały" },
          { id: 2, label: "FAZA 2", desc: "Półfinały" },
          { id: 3, label: "FAZA 3", desc: "Finał" },
        ].map((phase) => (
          <button
            key={phase.id}
            onClick={() => setSelectedPhase(phase.id)}
            className={classNames(
              "flex-1 px-4 py-2 rounded-xl border font-bold e3d-btn",
              selectedPhase === phase.id
                ? "bg-blue-500 text-white border-blue-600"
                : darkMode
                ? "bg-white/5 border-white/10 hover:bg-white/10 text-gray-300"
                : "bg-black/5 border-black/10 hover:bg-black/10 text-gray-700"
            )}
          >
            {phase.label}
          </button>
        ))}
      </div>

      {/* Zawartość wybranej fazy */}
      {selectedPhase === 1 && (
        <div className="space-y-3">
          <div
            className={classNames(
              "text-sm font-bold mb-3",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            Ćwierćfinały
          </div>
          <MatchRow match={qf[0]} label="Ćwierćfinał 1 (A1 vs B2)" />
          <MatchRow match={qf[1]} label="Ćwierćfinał 2 (B1 vs A2)" />
          <MatchRow match={qf[2]} label="Ćwierćfinał 3 (C1 vs D2)" />
          <MatchRow match={qf[3]} label="Ćwierćfinał 4 (D1 vs C2)" />
        </div>
      )}

      {selectedPhase === 2 && (
        <div className="space-y-3">
          <div
            className={classNames(
              "text-sm font-bold mb-3",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            Półfinały
          </div>
          <MatchRow match={sf[0]} label="Półfinał 1" />
          <MatchRow match={sf[1]} label="Półfinał 2" />
        </div>
      )}

      {selectedPhase === 3 && (
        <div className="space-y-3">
          <div
            className={classNames(
              "text-sm font-bold mb-3",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            Finały
          </div>

          <div
            className={classNames(
              "p-4 rounded-xl border-2",
              darkMode
                ? "border-yellow-400/40 bg-yellow-400/10"
                : "border-yellow-500/40 bg-yellow-100"
            )}
          >
            <div className="text-center font-black mb-3">🏆 FINAŁ</div>
            <div className="grid grid-cols-[40px_minmax(0,1fr)_60px_minmax(0,1fr)_40px] gap-2 items-center">
              <TeamLogo team={final.home} darkMode={darkMode} size={40} />
              <div
                className={classNames(
                  "truncate",
                  final.homeGoals > final.awayGoals && "font-black"
                )}
              >
                {final.home}
              </div>
              <div
                className={classNames(
                  "text-center font-black text-2xl",
                  darkMode ? "text-white" : "text-black"
                )}
              >
                {final.homeGoals} : {final.awayGoals}
              </div>
              <div
                className={classNames(
                  "truncate text-right",
                  final.awayGoals > final.homeGoals && "font-black"
                )}
              >
                {final.away}
              </div>
              <TeamLogo team={final.away} darkMode={darkMode} size={40} />
            </div>
          </div>

          {thirdPlace && (
            <>
              <div
                className={classNames(
                  "text-sm font-bold mt-4 mb-3",
                  darkMode ? "text-gray-400" : "text-gray-600"
                )}
              >
                O 3. miejsce
              </div>
              <MatchRow match={thirdPlace} label="🥉 Mecz o 3. miejsce" />
            </>
          )}

          {/* Zwycięzca */}
          <div
            className={classNames(
              "mt-6 p-4 rounded-2xl border-2 text-center",
              darkMode
                ? "border-yellow-400/60 bg-yellow-400/20"
                : "border-yellow-500/60 bg-yellow-100"
            )}
          >
            <div className="text-sm font-black mb-1">🏆 ZWYCIĘZCA TURNIEJU</div>
            <div className="text-xl font-extrabold">{champion}</div>
          </div>
        </div>
      )}
    </Card>
  );
}

function TournamentsPage({ darkMode, tournaments, openTeam }) {
  const [selectedTournament, setSelectedTournament] = useState(null);

  if (selectedTournament) {
    const t = tournaments.find((x) => x.id === selectedTournament);
    if (!t) return null;

    return (
      <div className="space-y-4">
        <BackHeader
          darkMode={darkMode}
          title={t.name}
          onBack={() => setSelectedTournament(null)}
        />

        {/* 1. Podstawowe informacje */}
        <Card darkMode={darkMode}>
          <div
            className={classNames(
              "text-sm",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            <div>
              <b>Data:</b> {t.date}
            </div>
            <div>
              <b>Lokalizacja:</b> {t.location}
            </div>
            <div>
              <b>Format:</b> 6 vs 6, halowe, 4 grupy po 4 drużyny
            </div>
          </div>
        </Card>

        {/* 2. Drzewko + MVP obok */}
        <div className="grid lg:grid-cols-[1fr_300px] gap-4">
          <TournamentBracket
            darkMode={darkMode}
            playoffs={t.playoffs}
            champion={t.champion}
          />

          {/* MVP pionowo - kwadratowe */}
          <div className="flex flex-col gap-3">
            {/* MVP */}
            <Card
              darkMode={darkMode}
              className="aspect-square flex items-center justify-center"
            >
              <div className="text-center p-4">
                <div className="text-4xl mb-2">🏆</div>
                <div className="font-extrabold text-xs mb-1">MVP TURNIEJU</div>
                <div className="font-bold text-base">{t.mvp.name}</div>
                <div
                  className={classNames(
                    "text-xs mt-1",
                    darkMode ? "text-gray-400" : "text-gray-600"
                  )}
                >
                  {t.mvp.team}
                </div>
              </div>
            </Card>

            {/* Król strzelców */}
            <Card
              darkMode={darkMode}
              className="aspect-square flex items-center justify-center"
            >
              <div className="text-center p-4">
                <div className="text-4xl mb-2">⚽</div>
                <div className="font-extrabold text-xs mb-1">
                  KRÓL STRZELCÓW
                </div>
                <div className="font-bold text-base">{t.topScorer.name}</div>
                <div
                  className={classNames(
                    "text-xs mt-1",
                    darkMode ? "text-gray-400" : "text-gray-600"
                  )}
                >
                  {t.topScorer.team}
                </div>
                <div className="font-black text-green-400 mt-1 text-sm">
                  {t.topScorer.goals} bramek
                </div>
              </div>
            </Card>

            {/* Najlepszy bramkarz */}
            <Card
              darkMode={darkMode}
              className="aspect-square flex items-center justify-center"
            >
              <div className="text-center p-4">
                <div className="text-4xl mb-2">🧤</div>
                <div className="font-extrabold text-xs mb-1">
                  NAJLEPSZY BRAMKARZ
                </div>
                <div className="font-bold text-base">{t.bestGK.name}</div>
                <div
                  className={classNames(
                    "text-xs mt-1",
                    darkMode ? "text-gray-400" : "text-gray-600"
                  )}
                >
                  {t.bestGK.team}
                </div>
                <div className="font-black text-blue-400 mt-1 text-sm">
                  {t.bestGK.cleanSheets} czyste konta
                </div>
              </div>
            </Card>
          </div>
        </div>

        {/* 3. Tabele grupowe */}
        <div className="grid lg:grid-cols-2 gap-3">
          {t.groupTables.map((grp, gIdx) => {
            const groupLetter = String.fromCharCode(65 + gIdx); // A, B, C, D
            return (
              <Card key={gIdx} darkMode={darkMode}>
                <div className="font-extrabold mb-3">Grupa {groupLetter}</div>

                <div
                  className={classNames(
                    "rounded-2xl border overflow-hidden",
                    darkMode
                      ? "border-white/10 bg-white/5"
                      : "border-gray-200 bg-white"
                  )}
                >
                  {/* Nagłówki kolumn */}
                  <div
                    className={classNames(
                      "grid grid-cols-[40px_1fr_40px_40px_40px_50px] gap-2 px-3 py-2 text-xs font-extrabold border-b",
                      darkMode
                        ? "bg-black/30 border-white/10 text-gray-300"
                        : "bg-gray-100 border-gray-200 text-gray-700"
                    )}
                  >
                    <div className="text-center">#</div>
                    <div>Drużyna</div>
                    <div className="text-center">W</div>
                    <div className="text-center">R</div>
                    <div className="text-center">P</div>
                    <div className="text-center">Pkt</div>
                  </div>

                  {/* Wiersze drużyn */}
                  {grp.map((team, idx) => (
                    <div
                      key={idx}
                      className={classNames(
                        "grid grid-cols-[40px_1fr_40px_40px_40px_50px] gap-2 px-3 py-2 text-sm items-center border-b last:border-b-0",
                        darkMode
                          ? "border-white/5 hover:bg-white/5"
                          : "border-gray-100 hover:bg-gray-50"
                      )}
                    >
                      <div className="text-center font-bold">{idx + 1}</div>
                      <button
                        onClick={() => openTeam(team.team)}
                        className="font-bold hover:underline text-left truncate"
                      >
                        {team.team}
                      </button>
                      <div className="text-center">{team.win}</div>
                      <div className="text-center">{team.draw}</div>
                      <div className="text-center">{team.loss}</div>
                      <div className="text-center font-black">{team.pts}</div>
                    </div>
                  ))}
                </div>
              </Card>
            );
          })}
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div>
        <div className="text-2xl font-extrabold">Turnieje</div>
        <div
          className={classNames(
            "text-sm",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Format 6 vs 6 halowe • 4 grupy po 4 drużyny • Faza pucharowa
        </div>
      </div>

      {tournaments.length === 0 ? (
        <Card darkMode={darkMode}>
          <div className={classNames("text-center py-8", darkMode ? "text-gray-400" : "text-gray-500")}>
            Brak turniejów
          </div>
        </Card>
      ) : <div className="grid lg:grid-cols-2 gap-3">
        {tournaments.map((t) => (
          <Card key={t.id} darkMode={darkMode}>
            <button
              onClick={() => setSelectedTournament(t.id)}
              className="w-full text-left"
            >
              <div className="font-extrabold text-lg mb-2">{t.name}</div>
              <div
                className={classNames(
                  "text-sm",
                  darkMode ? "text-gray-400" : "text-gray-600"
                )}
              >
                <div>📅 {t.date}</div>
                <div>📍 {t.location}</div>
                <div className="mt-2 font-bold text-green-400">
                  🏆 Zwycięzca: {t.champion}
                </div>
              </div>
            </button>
          </Card>
        ))}
      </div>}
    </div>
  );
}

class HomePageErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error, info) {
    console.error("Błąd renderowania strony głównej:", error, info);
  }

  componentDidUpdate(prevProps) {
    if (
      this.state.hasError &&
      (prevProps.resetKey !== this.props.resetKey ||
        prevProps.darkMode !== this.props.darkMode)
    ) {
      this.setState({ hasError: false });
    }
  }

  render() {
    if (this.state.hasError) {
      const { darkMode } = this.props;
      return (
        <Card darkMode={darkMode}>
          <div className="space-y-3 text-center py-6">
            <div className="text-xl font-extrabold">Strona główna chwilowo nie mogła się załadować</div>
            <div className={classNames("text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
              Odśwież widok albo wróć tutaj ponownie. Zabezpieczyłem ekran, żeby aplikacja nie przechodziła już w czarne tło.
            </div>
            <button
              type="button"
              onClick={() => window.location.reload()}
              className={classNames(
                "mx-auto px-4 py-2 rounded-xl border font-bold e3d-btn",
                darkMode
                  ? "bg-white/5 border-white/10 hover:bg-white/10"
                  : "bg-white border-gray-200 hover:bg-gray-50"
              )}
            >
              Odśwież stronę
            </button>
          </div>
        </Card>
      );
    }

    return this.props.children;
  }
}

class PageRenderErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error, info) {
    console.error("Błąd renderowania widoku:", error, info);
  }

  componentDidUpdate(prevProps) {
    if (this.state.hasError && prevProps.resetKey !== this.props.resetKey) {
      this.setState({ hasError: false });
    }
  }

  render() {
    if (this.state.hasError) {
      const { darkMode } = this.props;
      return (
        <Card darkMode={darkMode}>
          <div className="space-y-3 text-center py-6">
            <div className="text-xl font-extrabold">Ten widok chwilowo nie mógł się załadować</div>
            <div className={classNames("text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
              Zabezpieczyłem stronę, żeby błąd nie kończył się już pustym czarnym ekranem.
            </div>
            <button
              type="button"
              onClick={() => window.location.reload()}
              className={classNames(
                "mx-auto px-4 py-2 rounded-xl border font-bold e3d-btn",
                darkMode
                  ? "bg-white/5 border-white/10 hover:bg-white/10"
                  : "bg-white border-gray-200 hover:bg-gray-50"
              )}
            >
              Odśwież stronę
            </button>
          </div>
        </Card>
      );
    }

    return this.props.children;
  }
}

function PageRenderer({ renderPage }) {
  return renderPage();
}

function HomeDashboard({
  darkMode,
  fixtures = [],
  matches = [],
  stats = {},
  news = [],
  polls = [],
  typerMatches = [],
  openTeam,
  openMatch,
  openGallery,
  expandedMatchId,
  playersByTeam,
  openPlayer,
  currentLeagues = [],
  goToLeague,
  setHomeSection,
  currentRound,
  playedRounds,
  seasonStatus,
  seasonSummary,
  currentSeason,
}) {
  const isCompleted = seasonStatus === 'completed';
  const isActiveSeason = seasonStatus === 'active' || seasonStatus === 'in_progress';
  const leagueLabel = (id) => ({ "1st": "I Liga", "2nd": "II Liga", "3rd": "III Liga" }[id] || id);
  const isExcludedFromProgress = (status) => status === "cancelled" || status === "unplayed";
  const isExcludedFromUpcoming = (status) =>
    status === "cancelled" || status === "unplayed" || status === "postponed";
  const safeStats = stats || {};
  const safeNews = Array.isArray(news)
    ? news.filter((item) => item && typeof item === "object")
    : [];
  const safePolls = Array.isArray(polls)
    ? polls.filter((item) => item && typeof item === "object")
    : [];
  const safeTyperMatches = Array.isArray(typerMatches)
    ? typerMatches.filter((item) => item && typeof item === "object")
    : [];
  const tableByLeague = safeStats.tableByLeague || {};
  const topScorers = Array.isArray(safeStats.topScorers) ? safeStats.topScorers : [];
  const topAssists = Array.isArray(safeStats.topAssists) ? safeStats.topAssists : [];
  const topYellow = Array.isArray(safeStats.topYellow) ? safeStats.topYellow : [];

  // last results (global) and upcoming
  const lastMatches = useMemo(() => {
    const sorted = [...matches].sort((a, b) => b.round - a.round);
    return sorted.slice(0, 6);
  }, [matches]);

  const upcoming = useMemo(() => {
    if (isCompleted) return [];
    return fixtures
      .filter((f) => f.round === currentRound)
      .filter((f) => !isExcludedFromUpcoming(f.status))
      .slice(0, 6);
  }, [fixtures, isCompleted, currentRound]);

  const matchById = useMemo(() => {
    const m = {};
    for (const x of matches) m[x.id] = x;
    return m;
  }, [matches]);

  const latestNews = useMemo(
    () =>
      safeNews.slice(0, 4).map((item) => ({
        ...item,
        title: typeof item.title === "string" ? item.title : "",
        body: typeof item.body === "string" ? item.body : "",
        category: typeof item.category === "string" ? item.category : "",
        date: typeof item.date === "string" ? item.date : "",
      })),
    [safeNews]
  );

  const quickStats = useMemo(() => {
    const totalGoals = (matches || []).reduce(
      (sum, m) => sum + (m.homeGoals || 0) + (m.awayGoals || 0),
      0
    );
    const totalTeams = (currentLeagues || []).reduce(
      (acc, lg) => acc + ((lg.teams || []).length || 0),
      0
    );
    const countableFixtures = (fixtures || []).filter((f) => !isExcludedFromProgress(f.status));
    return [
      { label: "Mecze", value: matches.length, sub: countableFixtures.length ? `z ${countableFixtures.length}` : "sezon" },
      { label: "Gole", value: totalGoals, sub: matches.length ? `${(totalGoals / Math.max(matches.length, 1)).toFixed(1)} / mecz` : "brak" },
      { label: "Drużyny", value: totalTeams, sub: `${currentLeagues.length} ligi` },
      { label: "Strzelcy", value: topScorers.length || 0, sub: "aktywny ranking" },
    ];
  }, [matches, fixtures, currentLeagues, topScorers]);

  const leagueOverview = useMemo(() => {
    return (currentLeagues || []).map((lg) => {
      const table = tableByLeague[lg.id] || [];
      const leader = table[0] || null;
      const top3 = table.slice(0, 3);
      const topScorer = topScorers.find((p) => p.league === lg.id);
      const leagueFixturesAll = (fixtures || []).filter((f) => f.league === lg.id);
      const leagueFixtures = leagueFixturesAll.filter((f) => !isExcludedFromProgress(f.status));
      const leagueMatches = (matches || []).filter((m) => m.league === lg.id);
      const nextMatch = leagueFixturesAll
        .filter((f) => !matchById[f.id])
        .filter((f) => !isExcludedFromUpcoming(f.status))
        .sort((a, b) => (a.round - b.round) || (a.date || "").localeCompare(b.date || ""))[0] || null;
      const playedPct = leagueFixtures.length ? Math.round((leagueMatches.length / leagueFixtures.length) * 100) : 0;
      return { ...lg, table, leader, top3, topScorer, leagueFixtures, leagueMatches, nextMatch, playedPct };
    });
  }, [currentLeagues, tableByLeague, topScorers, fixtures, matches, matchById]);

  const globalLeaders = useMemo(() => ([
    topScorers[0]
      ? { key: "g", title: "Top strzelec", value: topScorers[0].goals, suffix: "goli", row: topScorers[0] }
      : null,
    topAssists[0]
      ? { key: "a", title: "Top asystent", value: topAssists[0].assists, suffix: "asyst", row: topAssists[0] }
      : null,
    topYellow[0]
      ? { key: "y", title: "Najwięcej kartek", value: topYellow[0].yellow, suffix: "żółtych", row: topYellow[0] }
      : null,
  ].filter(Boolean)), [topScorers, topAssists, topYellow]);

  const openHomeTab = (tab) => {
    if (typeof setHomeSection === "function") setHomeSection(tab);
  };

  const heroUpcoming = !isCompleted ? upcoming[0] || null : null;
  const heroRecent = lastMatches[0] || null;
  const latestPoll = useMemo(() => {
    const all = safePolls;
    return all.find((p) => p?.active) || all[0] || null;
  }, [safePolls]);
  const heroTyperMatches = useMemo(() => safeTyperMatches.slice(0, 5), [safeTyperMatches]);
  const [heroTyperPicks, setHeroTyperPicks] = useState({});
  const [heroTyperSubmitted, setHeroTyperSubmitted] = useState(false);
  const heroTyperKey = useMemo(() => heroTyperMatches.map((m) => m.id).join("|"), [heroTyperMatches]);
  const heroTyperAnimationTimers = useRef([]);
  const clearHeroTyperAnimationTimers = () => {
    heroTyperAnimationTimers.current.forEach((timer) => clearTimeout(timer));
    heroTyperAnimationTimers.current = [];
  };
  useEffect(() => {
    setHeroTyperPicks({});
    setHeroTyperSubmitted(false);
    setHeroTyperAnimatingPick(null);
    setHeroTyperCardPhase("idle");
    clearHeroTyperAnimationTimers();
  }, [heroTyperKey]);
  const heroCardRef = useRef(null);

  const latestPollOptions = useMemo(
    () =>
      Array.isArray(latestPoll?.options)
        ? latestPoll.options.filter((option) => typeof option === "string" && option.trim())
        : [],
    [latestPoll]
  );
  const [heroPollCounts, setHeroPollCounts] = useState([]);
  const [heroPollVoteIdx, setHeroPollVoteIdx] = useState(null);
  useEffect(() => {
    if (!latestPollOptions.length) {
      setHeroPollCounts([]);
      setHeroPollVoteIdx(null);
      return;
    }
    setHeroPollCounts(latestPollOptions.map(() => 8 + Math.floor(Math.random() * 30)));
    setHeroPollVoteIdx(null);
  }, [latestPoll?.id, latestPollOptions.length]);

  const heroSlides = useMemo(() => {
    const slides = [];

    slides.push({
      kind: "typer",
      key: "typer",
      kicker: "Typer",
      title: heroTyperMatches.length
        ? `Typowanie kolejki ${currentRound || "?"}`
        : "Typer MLPN",
      body: heroTyperMatches.length
        ? `${heroTyperMatches.length} meczów czeka na typy. Wejdź i obstaw najbliższe spotkania.`
        : "Sprawdź typer i oddaj typy na najbliższe spotkania.",
      meta: heroTyperMatches[0]
        ? `${displayTeamName(heroTyperMatches[0].home)} vs ${displayTeamName(heroTyperMatches[0].away)}`
        : "Panel typowania",
      ctaLabel: "Otwórz typer",
      onClick: () => openHomeTab("typer"),
    });

    if (heroRecent) {
      slides.push({
        kind: "recent",
        key: `recent-${heroRecent.id}`,
        kicker: "Ostatni wynik",
        title: `${heroRecent.homeGoals}:${heroRecent.awayGoals}`,
        body: `${displayTeamName(heroRecent.home)} vs ${displayTeamName(heroRecent.away)}`,
        meta: `${heroRecent.date || "--"} • kolejka ${heroRecent.round || "-"}`,
        ctaLabel: "Szczegóły meczu",
        onClick: () => openMatch?.(heroRecent.id),
      });
    }

    if (latestNews?.[0]) {
      const n = latestNews[0];
      slides.push({
        kind: "news",
        key: `news-${n.id}`,
        kicker: "Aktualność",
        title: n.title || "Najnowsza aktualność",
        body: (n.body || "").replace(/\s+/g, " ").slice(0, 140) || "Kliknij, aby przejść do listy aktualności.",
        meta: `${n.date || ""}${n.category ? ` • ${n.category}` : ""}`.trim(),
        ctaLabel: "Przejdź do aktualności",
        onClick: () => openHomeTab("news"),
      });
    }

    if (latestPoll) {
      slides.push({
        kind: "poll",
        key: `poll-${latestPoll.id}`,
        kicker: "Ankieta",
        title: typeof latestPoll.question === "string" ? latestPoll.question : "Ostatnia ankieta",
        body: latestPollOptions.length
          ? `Opcje: ${latestPollOptions.slice(0, 3).join(" • ")}${latestPollOptions.length > 3 ? "..." : ""}`
          : "Kliknij, aby zagłosować lub zobaczyć wyniki.",
        meta: latestPoll.active ? "Aktywna ankieta" : "Archiwum ankiet",
        ctaLabel: "Otwórz ankiety",
        onClick: () => openHomeTab("polls"),
      });
    }

    if (heroUpcoming) {
      slides.push({
        kind: "upcoming",
        key: `upcoming-${heroUpcoming.id}`,
        kicker: "Najbliższy mecz",
        title: `${displayTeamName(heroUpcoming.home)} vs ${displayTeamName(heroUpcoming.away)}`,
        body: "Nadchodzące spotkanie w bieżącej kolejce.",
        meta: `${heroUpcoming.date || "--"} • ${heroUpcoming.time || "--:--"} • kolejka ${heroUpcoming.round || "-"}`,
        ctaLabel: "Szczegóły meczu",
        onClick: () => openMatch?.(heroUpcoming.id),
      });
    }

    return slides.filter(Boolean);
  }, [heroTyperMatches, currentRound, heroRecent, latestNews, latestPoll, latestPollOptions, heroUpcoming]);

  const [heroSlideIndex, setHeroSlideIndex] = useState(0);
  useEffect(() => {
    setHeroSlideIndex(0);
  }, [heroSlides.length, heroUpcoming?.id, heroRecent?.id, latestNews?.[0]?.id, latestPoll?.id, currentRound]);

  const activeHeroSlide = heroSlides[heroSlideIndex] || null;
  const activeHeroKey = activeHeroSlide?.key || "";
  const heroSlideButtonDefs = [
    { kind: "news", label: "Aktualności" },
    { kind: "typer", label: "Typer" },
    { kind: "poll", label: "Ankiety" },
    { kind: "recent", label: "Ostatni mecz" },
    { kind: "upcoming", label: "Najbliższy mecz" },
  ];
  const hasHeroSlideKind = (kind) =>
    heroSlides.some((s) => s.key === kind || s.key.startsWith(`${kind}-`));
  const isHeroKindActive = (kind) =>
    activeHeroKey === kind || activeHeroKey.startsWith(`${kind}-`);
  const focusHeroSlide = (kind) => {
    const idx = heroSlides.findIndex(
      (s) => s.key === kind || s.key.startsWith(`${kind}-`)
    );
    if (idx >= 0) setHeroSlideIndex(idx);
  };
  const prevHeroSlide = () => {
    if (!heroSlides.length) return;
    setHeroSlideIndex((prev) => (prev - 1 + heroSlides.length) % heroSlides.length);
  };
  const nextHeroSlide = () => {
    if (!heroSlides.length) return;
    setHeroSlideIndex((prev) => (prev + 1) % heroSlides.length);
  };

  const activeHeroKind = activeHeroSlide?.kind || (activeHeroSlide?.key ? String(activeHeroSlide.key).split("-")[0] : null);
  const heroPollIsArchived = !!latestPoll && (latestPoll.status === "archived" || latestPoll.active === false);
  const heroPollTotalVotes = heroPollCounts.reduce((a, b) => a + b, 0);
  const heroPollShowResults = heroPollVoteIdx !== null || heroPollIsArchived;

  const voteInHeroPoll = (idx) => {
    if (!latestPollOptions.length || heroPollIsArchived) return;
    setHeroPollCounts((prev) => {
      const next = prev.length ? [...prev] : latestPollOptions.map(() => 0);
      if (heroPollVoteIdx !== null && next[heroPollVoteIdx] > 0) next[heroPollVoteIdx] -= 1;
      next[idx] = (next[idx] || 0) + 1;
      return next;
    });
    setHeroPollVoteIdx(idx);
  };

  const selectHeroTyperPickInstant = (matchId, value) => {
    setHeroTyperSubmitted(false);
    setHeroTyperPicks((prev) => ({ ...prev, [matchId]: value }));
  };
  const heroTyperAllPicked = heroTyperMatches.length > 0 && heroTyperMatches.every((m) => heroTyperPicks[m.id]);
  const heroTyperAnsweredCount = heroTyperMatches.filter((m) => heroTyperPicks[m.id]).length;
  const heroTyperCurrentIndex = useMemo(() => {
    if (!heroTyperMatches.length) return -1;
    const nextIdx = heroTyperMatches.findIndex((m) => !heroTyperPicks[m.id]);
    return nextIdx === -1 ? heroTyperMatches.length - 1 : nextIdx;
  }, [heroTyperMatches, heroTyperPicks]);
  const heroTyperCurrentMatch =
    heroTyperCurrentIndex >= 0 ? heroTyperMatches[heroTyperCurrentIndex] : null;
  const heroTyperProgressStep = heroTyperAllPicked
    ? heroTyperMatches.length
    : Math.min(heroTyperAnsweredCount + 1, heroTyperMatches.length || 1);
  const [showHeroFloatingNav, setShowHeroFloatingNav] = useState(false);
  const [heroTyperAnimatingPick, setHeroTyperAnimatingPick] = useState(null);
  const [heroTyperCardPhase, setHeroTyperCardPhase] = useState("idle");
  const heroTyperMobileActivePick = useMemo(() => {
    if (
      heroTyperAnimatingPick &&
      heroTyperCurrentMatch &&
      heroTyperAnimatingPick.matchId === heroTyperCurrentMatch.id
    ) {
      return heroTyperAnimatingPick?.value ?? null;
    }
    if (!heroTyperCurrentMatch) return null;
    return heroTyperPicks[heroTyperCurrentMatch.id] ?? null;
  }, [heroTyperAnimatingPick, heroTyperCurrentMatch, heroTyperPicks]);
  const heroTyperMobileBusy = heroTyperCardPhase !== "idle" || !!heroTyperAnimatingPick;

  const selectHeroTyperPickAnimated = (matchId, value) => {
    if (!heroTyperCurrentMatch || heroTyperCurrentMatch.id !== matchId || heroTyperMobileBusy) {
      return;
    }

    clearHeroTyperAnimationTimers();
    setHeroTyperSubmitted(false);
    setHeroTyperAnimatingPick({ matchId, value });
    setHeroTyperCardPhase("selected");

    heroTyperAnimationTimers.current.push(
      setTimeout(() => {
        setHeroTyperCardPhase("exit");
      }, 220)
    );

    heroTyperAnimationTimers.current.push(
      setTimeout(() => {
        setHeroTyperPicks((prev) => ({ ...prev, [matchId]: value }));
        setHeroTyperAnimatingPick(null);
        setHeroTyperCardPhase("enter");
      }, 470)
    );

    heroTyperAnimationTimers.current.push(
      setTimeout(() => {
        setHeroTyperCardPhase("idle");
      }, 560)
    );
  };

  useEffect(() => () => clearHeroTyperAnimationTimers(), []);

  useEffect(() => {
    const updateHeroFloatingNav = () => {
      const el = heroCardRef.current;
      if (!el || typeof window === "undefined" || window.innerWidth >= 1024 || heroSlides.length <= 1) {
        setShowHeroFloatingNav(false);
        return;
      }

      const rect = el.getBoundingClientRect();
      const isVisible = rect.top < window.innerHeight * 0.65 && rect.bottom > 120;
      setShowHeroFloatingNav(isVisible);
    };

    updateHeroFloatingNav();
    window.addEventListener("scroll", updateHeroFloatingNav, { passive: true });
    window.addEventListener("resize", updateHeroFloatingNav);
    return () => {
      window.removeEventListener("scroll", updateHeroFloatingNav);
      window.removeEventListener("resize", updateHeroFloatingNav);
    };
  }, [heroSlides.length]);

  return (
    <div className="space-y-4">
      <div className="grid xl:grid-cols-[1.35fr_0.95fr] gap-3">
        <Card darkMode={darkMode} className="mlpn-home-hero p-0 overflow-hidden">
          <div ref={heroCardRef} className="relative p-4 lg:p-6 min-h-[340px] h-auto lg:min-h-[540px] lg:h-[600px]">
            {heroSlides.length > 1 && showHeroFloatingNav && (
              <div className="pointer-events-none fixed inset-y-0 left-0 right-0 z-[10005] lg:hidden">
                <button
                  type="button"
                  onClick={prevHeroSlide}
                  className="pointer-events-auto absolute left-2 top-1/2 -translate-y-1/2 w-9 h-9 rounded-full border border-white/10 bg-black/20 text-white/80 hover:bg-white/10 transition-colors flex items-center justify-center text-lg font-black"
                  title="Poprzedni slajd"
                >
                  ‹
                </button>
                <button
                  type="button"
                  onClick={nextHeroSlide}
                  className="pointer-events-auto absolute right-2 top-1/2 -translate-y-1/2 w-9 h-9 rounded-full border border-white/10 bg-black/20 text-white/80 hover:bg-white/10 transition-colors flex items-center justify-center text-lg font-black"
                  title="Następny slajd"
                >
                  ›
                </button>
              </div>
            )}

            <div className="lg:hidden space-y-3">
              <div>
                <div className="text-[11px] font-black tracking-[0.2em] uppercase text-white/80 mb-2">
                  MLPN Match Center
                </div>
                <div className="text-3xl font-black leading-none text-white">
                  Sportowy pulpit ligi
                </div>
              </div>

              <div className="grid grid-cols-2 gap-2">
                {heroSlideButtonDefs
                  .filter((b) => hasHeroSlideKind(b.kind))
                  .map((b) => (
                    <button
                      key={`hero-mobile-btn-${b.kind}`}
                      type="button"
                      onClick={() => focusHeroSlide(b.kind)}
                      className={classNames(
                        "px-3 py-2.5 rounded-2xl border text-sm font-bold text-left transition-colors",
                        isHeroKindActive(b.kind)
                          ? "bg-white text-gray-900 border-white"
                          : "text-white border-white/20 bg-black/20 hover:bg-white/10"
                      )}
                    >
                      {b.label}
                    </button>
                  ))}
              </div>

              {activeHeroSlide ? (
                <div className="rounded-[26px] border border-white/15 bg-black/20 p-4 space-y-3">
                  <div>
                    <div className="text-[11px] uppercase tracking-[0.16em] font-black text-sky-200">
                      {activeHeroSlide.kicker}
                    </div>
                    <div className="mt-1 text-2xl font-black text-white leading-tight">
                      {activeHeroSlide.title}
                    </div>
                    {activeHeroKind !== "typer" && (
                      <div className="mt-2 text-sm text-white/85 leading-relaxed">
                        {activeHeroSlide.body}
                      </div>
                    )}
                    {activeHeroKind !== "typer" && activeHeroSlide.meta && (
                      <div className="mt-2 text-xs text-white/70">
                        {activeHeroSlide.meta}
                      </div>
                    )}
                  </div>

                  {activeHeroKind === "typer" && (
                    <div className="space-y-2">
                      {heroTyperMatches.length === 0 ? (
                        <div className="rounded-2xl border border-white/10 bg-white/5 px-3 py-4 text-sm text-white/75">
                          Brak meczów do typowania.
                        </div>
                      ) : (
                        <>
                          {heroTyperCurrentMatch && (
                            <div
                              key={`hero-mobile-typer-${heroTyperCurrentMatch.id}`}
                              className={classNames(
                                "rounded-2xl border border-white/10 bg-white/5 p-3 transition-[opacity,transform,filter] duration-300 ease-out",
                                heroTyperCardPhase === "selected" && "ring-1 ring-emerald-300/60 bg-emerald-400/10",
                                heroTyperCardPhase === "exit" && "opacity-0 translate-y-3 scale-[0.98] blur-[1px]",
                                heroTyperCardPhase === "enter" && "opacity-0 -translate-y-3 scale-[0.98]",
                                heroTyperCardPhase === "idle" && "opacity-100 translate-y-0 scale-100"
                              )}
                            >
                              <div className="flex items-start gap-3 min-w-0">
                                <TeamLogo
                                  team={heroTyperCurrentMatch.home}
                                  darkMode={true}
                                  size={46}
                                  framed={false}
                                  imgScale={0.92}
                                  onClick={() => openTeam?.(heroTyperCurrentMatch.home)}
                                />
                                <button
                                  type="button"
                                  onClick={() => openTeam?.(heroTyperCurrentMatch.home)}
                                  className="min-w-0 pt-1 text-left text-base font-black text-white leading-tight hover:underline"
                                >
                                  {displayTeamName(heroTyperCurrentMatch.home)}
                                </button>
                              </div>

                              <div className="mt-3 grid grid-cols-3 gap-2">
                                {["1", "X", "2"].map((pick) => (
                                  <button
                                    key={`hero-mobile-pick-${heroTyperCurrentMatch.id}-${pick}`}
                                    type="button"
                                    disabled={heroTyperMobileBusy}
                                    onClick={() => selectHeroTyperPickAnimated(heroTyperCurrentMatch.id, pick)}
                                    className={classNames(
                                      "py-2.5 rounded-xl border text-lg font-black transition-all duration-200",
                                      heroTyperMobileActivePick === pick
                                        ? "bg-emerald-400 text-black border-emerald-300 scale-[1.03] shadow-[0_0_0_1px_rgba(110,231,183,0.35),0_14px_24px_rgba(16,185,129,0.22)]"
                                        : "bg-white/5 text-white border-white/15 hover:bg-white/10"
                                    )}
                                  >
                                    {pick}
                                  </button>
                                ))}
                              </div>

                              <div className="mt-3 flex items-end justify-end gap-3 min-w-0">
                                <button
                                  type="button"
                                  onClick={() => openTeam?.(heroTyperCurrentMatch.away)}
                                  className="min-w-0 pb-1 text-right text-base font-black text-white leading-tight hover:underline"
                                >
                                  {displayTeamName(heroTyperCurrentMatch.away)}
                                </button>
                                <TeamLogo
                                  team={heroTyperCurrentMatch.away}
                                  darkMode={true}
                                  size={46}
                                  framed={false}
                                  imgScale={0.92}
                                  onClick={() => openTeam?.(heroTyperCurrentMatch.away)}
                                />
                              </div>
                            </div>
                          )}

                          <div className="flex items-center justify-between gap-3 pt-1">
                            <div className="text-[11px] text-white/75 leading-relaxed">
                              {heroTyperSubmitted
                                ? "Typy zapisane lokalnie."
                                : heroTyperAllPicked
                                ? `Masz komplet typów ${heroTyperMatches.length}/${heroTyperMatches.length}.`
                                : `Uzupełnij typy ${heroTyperProgressStep}/${heroTyperMatches.length}.`}
                            </div>
                            <button
                              type="button"
                              disabled={!heroTyperAllPicked}
                              onClick={() => setHeroTyperSubmitted(true)}
                              className={classNames(
                                "shrink-0 px-3 py-2 rounded-xl border text-xs font-black transition-colors",
                                heroTyperAllPicked
                                  ? "bg-emerald-400 text-black border-emerald-300 hover:brightness-110"
                                  : "bg-white/5 text-white/50 border-white/10 cursor-not-allowed"
                              )}
                            >
                              Wyślij
                            </button>
                          </div>
                        </>
                      )}
                    </div>
                  )}

                  {activeHeroKind === "poll" && latestPoll && latestPollOptions.length > 0 && (
                    <div className="space-y-2">
                      {latestPollOptions.slice(0, 4).map((opt, idx) => {
                        const count = heroPollCounts[idx] || 0;
                        const pct = heroPollTotalVotes ? Math.round((count / heroPollTotalVotes) * 100) : 0;
                        const chosen = heroPollVoteIdx === idx;
                        return (
                          <button
                            key={`hero-mobile-poll-opt-${idx}`}
                            type="button"
                            onClick={() => voteInHeroPoll(idx)}
                            disabled={heroPollIsArchived}
                            className={classNames(
                              "w-full relative overflow-hidden rounded-2xl border px-3 py-3 text-left transition-colors",
                              chosen
                                ? "border-emerald-300/60 bg-emerald-400/15"
                                : "border-white/10 bg-white/5 hover:bg-white/10",
                              heroPollIsArchived && "cursor-not-allowed"
                            )}
                          >
                            {heroPollShowResults && (
                              <div
                                className="absolute inset-y-0 left-0 bg-white/10"
                                style={{ width: `${pct}%` }}
                              />
                            )}
                            <div className="relative flex items-center justify-between gap-3">
                              <span className="text-sm font-semibold text-white">{opt}</span>
                              {heroPollShowResults && (
                                <span className="text-xs font-black text-white">{pct}%</span>
                              )}
                            </div>
                          </button>
                        );
                      })}
                    </div>
                  )}

                  {activeHeroSlide.onClick && activeHeroKind !== "typer" && (
                    <button
                      type="button"
                      onClick={activeHeroSlide.onClick}
                      className="w-full rounded-2xl border border-white/20 bg-white/10 px-4 py-3 text-sm font-black text-white transition-colors hover:bg-white/15"
                    >
                      {activeHeroSlide.ctaLabel || "Otwórz"}
                    </button>
                  )}
                </div>
              ) : (
                <div className="rounded-[26px] border border-white/10 bg-black/15 p-4 text-sm text-white/75">
                  Brak tematów do wyświetlenia.
                </div>
              )}

              {heroSlides.length > 1 && (
                <div className="flex items-center justify-center gap-2">
                  <div className="flex items-center justify-center gap-2">
                    {heroSlides.map((slide, idx) => (
                      <button
                        key={`hero-mobile-slide-dot-${slide.key}`}
                        type="button"
                        onClick={() => setHeroSlideIndex(idx)}
                        className={classNames(
                          "h-3 rounded-full transition-all",
                          idx === heroSlideIndex ? "w-10 bg-white" : "w-3 bg-white/35 hover:bg-white/55"
                        )}
                        title={slide.kicker}
                      />
                    ))}
                  </div>
                </div>
              )}
            </div>

            <div className="hidden lg:grid gap-2 items-start">
              <div className="grid lg:grid-cols-[1fr_360px] gap-3 items-start">
                <div>
                  <div className="text-[11px] font-black tracking-[0.2em] uppercase text-white/80 mb-2">
                    MLPN Match Center
                  </div>
                  <div className="text-3xl lg:text-4xl font-black leading-none text-white">
                    Sportowy pulpit ligi
                  </div>

                  <div className="mt-4 flex flex-wrap gap-2">
                    {heroSlideButtonDefs
                      .filter((b) => hasHeroSlideKind(b.kind))
                      .map((b) => (
                        <button
                          key={`hero-btn-${b.kind}`}
                          type="button"
                          onClick={() => focusHeroSlide(b.kind)}
                          className={classNames(
                            "px-4 py-2 rounded-xl border text-sm font-bold transition-colors",
                            isHeroKindActive(b.kind)
                              ? "bg-white text-gray-900 border-white"
                              : "text-white border-white/20 bg-black/20 hover:bg-white/10"
                          )}
                        >
                          {b.label}
                        </button>
                      ))}
                  </div>
                </div>

                {activeHeroSlide ? (
                  <div className="min-w-0 rounded-2xl border border-white/10 bg-black/15 p-2.5 self-start">
                    <div className="text-[11px] uppercase tracking-[0.16em] font-black text-sky-200">
                      {activeHeroSlide.kicker}
                    </div>
                    <div className="mt-1 text-lg lg:text-xl font-black text-white leading-tight break-words">
                      {activeHeroSlide.title}
                    </div>
                    <div className="mt-1 text-xs lg:text-sm text-white/85">
                      {activeHeroSlide.body}
                    </div>
                    {activeHeroSlide.meta && (
                      <div className="mt-1.5 text-[11px] text-white/70">
                        {activeHeroSlide.meta}
                      </div>
                    )}
                  </div>
                ) : (
                  <div />
                )}
              </div>

                <div className="min-h-[380px] h-auto lg:h-[440px] grid grid-rows-[1fr_auto] gap-2">
                  {activeHeroSlide ? (
                    <>
                      <div className="min-h-0 overflow-hidden">
                      {activeHeroKind === "typer" && (
                        <div className="h-full rounded-2xl border border-white/15 bg-black/20 p-2.5 overflow-hidden">
                          {heroTyperMatches.length === 0 ? (
                            <div className="text-sm text-white/80">Brak meczów do typowania.</div>
                          ) : (
                            <div className="h-full grid grid-rows-[1fr_auto] gap-1.5">
                              <div className="space-y-1.5">
                              {heroTyperMatches.map((m) => (
                                <div
                                  key={`hero-typer-${m.id}`}
                                  className="grid grid-cols-[1fr_auto_1fr] items-center gap-2 rounded-xl border border-white/10 bg-white/5 px-2 py-1.5"
                                >
                                  <div className="flex items-center gap-2 min-w-0">
                                    <TeamLogo team={m.home} darkMode={true} size={18} onClick={() => openTeam?.(m.home)} />
                                    <span className="text-[11px] font-bold text-white truncate">{displayTeamName(m.home)}</span>
                                  </div>
                                  <div className="flex items-center gap-1">
                                    {["1", "X", "2"].map((pick) => (
                                      <button
                                        key={`hero-pick-${m.id}-${pick}`}
                                        type="button"
                                        onClick={() => selectHeroTyperPickInstant(m.id, pick)}
                                        className={classNames(
                                          "w-6 h-6 rounded-md border text-[10px] font-black transition-colors",
                                          heroTyperPicks[m.id] === pick
                                            ? "bg-emerald-400 text-black border-emerald-300"
                                            : "bg-white/5 text-white border-white/15 hover:bg-white/10"
                                        )}
                                        title={`Typ ${pick}`}
                                      >
                                        {pick}
                                      </button>
                                    ))}
                                  </div>
                                  <div className="flex items-center justify-end gap-2 min-w-0">
                                    <span className="text-[11px] font-bold text-white truncate text-right">{displayTeamName(m.away)}</span>
                                    <TeamLogo team={m.away} darkMode={true} size={18} onClick={() => openTeam?.(m.away)} />
                                  </div>
                                </div>
                              ))}
                              </div>
                              <div className="flex items-center justify-between gap-2 pt-0.5">
                                <div className="text-[11px] text-white/80">
                                  {heroTyperSubmitted
                                    ? "Typy zapisane lokalnie w kaflu (podgląd)."
                                    : heroTyperAllPicked
                                    ? "Komplet typów zaznaczony."
                                    : `Uzupełnij typy (${Object.keys(heroTyperPicks).length}/${heroTyperMatches.length}).`}
                                </div>
                                <button
                                  type="button"
                                  disabled={!heroTyperAllPicked}
                                  onClick={() => setHeroTyperSubmitted(true)}
                                  className={classNames(
                                    "px-2.5 py-1 rounded-xl border text-[11px] font-black transition-colors",
                                    heroTyperAllPicked
                                      ? "bg-emerald-400 text-black border-emerald-300 hover:brightness-110"
                                      : "bg-white/5 text-white/50 border-white/10 cursor-not-allowed"
                                  )}
                                >
                                  Wyślij typy
                                </button>
                              </div>
                            </div>
                          )}
                        </div>
                      )}

                      {activeHeroKind === "poll" && latestPoll && latestPollOptions.length > 0 && (
                        <div className="h-full rounded-2xl border border-white/15 bg-black/20 p-2.5 space-y-2">
                          {latestPollOptions.slice(0, 4).map((opt, idx) => {
                            const count = heroPollCounts[idx] || 0;
                            const pct = heroPollTotalVotes ? Math.round((count / heroPollTotalVotes) * 100) : 0;
                            const chosen = heroPollVoteIdx === idx;
                            return (
                              <button
                                key={`hero-poll-opt-${idx}`}
                                type="button"
                                onClick={() => voteInHeroPoll(idx)}
                                disabled={heroPollIsArchived}
                                className={classNames(
                                  "w-full relative overflow-hidden rounded-xl border px-3 py-2 text-left transition-colors",
                                  chosen
                                    ? "border-emerald-300/60 bg-emerald-400/15"
                                    : "border-white/10 bg-white/5 hover:bg-white/10",
                                  heroPollIsArchived && "cursor-not-allowed"
                                )}
                              >
                                {heroPollShowResults && (
                                  <div
                                    className="absolute inset-y-0 left-0 bg-white/10"
                                    style={{ width: `${pct}%` }}
                                  />
                                )}
                                <div className="relative flex items-center justify-between gap-2">
                                  <span className="text-sm font-semibold text-white truncate">{opt}</span>
                                  {heroPollShowResults && (
                                    <span className="text-xs font-black text-white">{pct}%</span>
                                  )}
                                </div>
                              </button>
                            );
                          })}
                          <div className="text-[11px] text-white/75">
                            {heroPollIsArchived
                              ? "Ankieta zakończona."
                              : heroPollVoteIdx !== null
                              ? "Głos oddany. Możesz zmienić odpowiedź klikając inną opcję."
                              : "Kliknij odpowiedź, aby zagłosować bezpośrednio z kafla."}
                          </div>
                        </div>
                      )}
                      {activeHeroKind !== "typer" && !(activeHeroKind === "poll" && latestPoll && latestPollOptions.length > 0) && (
                        <div className="h-full rounded-2xl border border-white/15 bg-black/15 p-4 flex items-center justify-center text-white/80 text-sm">
                          Wybierz slajd „Typer” lub „Ankiety”, aby skorzystać z interaktywnej zawartości bezpośrednio w kaflu.
                        </div>
                      )}
                      </div>

                      <div className="h-10 px-1 flex items-center justify-between gap-3 border-t border-white/10 pt-0">
                        {heroSlides.length > 1 ? (
                          <>
                            <button
                              type="button"
                              onClick={prevHeroSlide}
                              className="w-8 h-8 rounded-full border border-white/20 bg-black/20 text-white hover:bg-white/10 transition-colors flex items-center justify-center font-black"
                              title="Poprzedni slajd"
                            >
                              ‹
                            </button>

                            <div className="flex items-center justify-center gap-2">
                              {heroSlides.map((slide, idx) => (
                                <button
                                  key={`hero-slide-dot-${slide.key}`}
                                  type="button"
                                  onClick={() => setHeroSlideIndex(idx)}
                                  className={classNames(
                                    "h-2 rounded-full transition-all",
                                    idx === heroSlideIndex ? "w-8 bg-white" : "w-2 bg-white/35 hover:bg-white/55"
                                  )}
                                  title={slide.kicker}
                                />
                              ))}
                            </div>

                            <button
                              type="button"
                              onClick={nextHeroSlide}
                              className="w-8 h-8 rounded-full border border-white/20 bg-black/20 text-white hover:bg-white/10 transition-colors flex items-center justify-center font-black"
                              title="Następny slajd"
                            >
                              ›
                            </button>
                          </>
                        ) : (
                          <div className="w-full" />
                        )}
                      </div>
                    </>
                  ) : (
                    <div className="text-sm text-white/85">Brak tematów do wyświetlenia.</div>
                  )}
                </div>
              </div>
            </div>
        </Card>

        <div className="grid gap-3">
          <Card darkMode={darkMode} className="p-0 overflow-hidden">
            <div
              className={classNames(
                "px-4 pt-4 pb-2 border-b",
                darkMode ? "border-white/10" : "border-gray-200"
              )}
            >
              <div className="text-lg font-extrabold">Szybkie liczby</div>
              <div
                className={classNames(
                  "text-xs",
                  darkMode ? "text-gray-400" : "text-gray-600"
                )}
              >
                Bieżący podgląd sezonu
              </div>
            </div>
            <div className="grid grid-cols-2 gap-2 p-3">
              {quickStats.map((item) => (
                <div
                  key={item.label}
                  className={classNames(
                    "rounded-xl border p-3",
                    darkMode
                      ? "bg-black/10 border-white/10"
                      : "bg-gray-50 border-gray-200"
                  )}
                >
                  <div
                    className={classNames(
                      "text-[10px] uppercase tracking-[0.18em] font-black",
                      darkMode ? "text-gray-400" : "text-gray-500"
                    )}
                  >
                    {item.label}
                  </div>
                  <div className="text-2xl font-black leading-none mt-2">
                    {item.value}
                  </div>
                  <div
                    className={classNames(
                      "text-xs mt-1",
                      darkMode ? "text-gray-400" : "text-gray-600"
                    )}
                  >
                    {item.sub}
                  </div>
                </div>
              ))}
            </div>
          </Card>

          <Card darkMode={darkMode} className="p-0 overflow-hidden">
            <div
              className={classNames(
                "px-4 pt-4 pb-2 border-b",
                darkMode ? "border-white/10" : "border-gray-200"
              )}
            >
              <div className="text-lg font-extrabold">Liderzy sezonu</div>
              <div
                className={classNames(
                  "text-xs",
                  darkMode ? "text-gray-400" : "text-gray-600"
                )}
              >
                Najmocniejsze nazwiska na teraz
              </div>
            </div>
            <div className="p-3 space-y-2">
              {globalLeaders.length === 0 && (
                <div
                  className={classNames(
                    "text-sm text-center py-4",
                    darkMode ? "text-gray-400" : "text-gray-600"
                  )}
                >
                  Brak danych liderów
                </div>
              )}
              {globalLeaders.map((leader) => (
                <div
                  key={leader.key}
                  className={classNames(
                    "rounded-xl border p-3",
                    darkMode
                      ? "bg-black/10 border-white/10"
                      : "bg-white border-gray-200"
                  )}
                >
                  <div className="flex items-center justify-between gap-2">
                    <div className="min-w-0">
                      <div
                        className={classNames(
                          "text-[10px] uppercase tracking-[0.18em] font-black",
                          darkMode ? "text-gray-400" : "text-gray-500"
                        )}
                      >
                        {leader.title}
                      </div>
                      <button
                        onClick={() =>
                          leader.row?.playerId && openPlayer?.(leader.row.playerId)
                        }
                        className="font-bold text-sm hover:underline truncate block text-left"
                      >
                        {leader.row?.name || "-"}
                      </button>
                      <button
                        onClick={() => leader.row?.team && openTeam?.(leader.row.team)}
                        className={classNames(
                          "text-xs hover:underline truncate block text-left",
                          darkMode ? "text-gray-300" : "text-gray-700"
                        )}
                      >
                        {leader.row?.team ? displayTeamName(leader.row.team) : "-"}{" "}
                        {leader.row?.league ? `• ${leagueLabel(leader.row.league)}` : ""}
                      </button>
                    </div>
                    <div className="text-right">
                      <div className="text-3xl font-black leading-none">
                        {leader.value}
                      </div>
                      <div
                        className={classNames(
                          "text-[10px] uppercase tracking-[0.15em]",
                          darkMode ? "text-gray-400" : "text-gray-500"
                        )}
                      >
                        {leader.suffix}
                      </div>
                    </div>
                  </div>
                </div>
              ))}
              <div className="grid grid-cols-2 gap-2 pt-1">
                <button
                  onClick={() => goToLeague?.("1st")}
                  className={classNames(
                    "px-3 py-2 rounded-xl border text-sm font-bold e3d-btn",
                    darkMode
                      ? "bg-white/5 border-white/10 hover:bg-white/10"
                      : "bg-white border-gray-200 hover:bg-gray-50"
                  )}
                >
                  Tabele lig
                </button>
                <button
                  onClick={() => openHomeTab("news")}
                  className={classNames(
                    "px-3 py-2 rounded-xl border text-sm font-bold e3d-btn",
                    darkMode
                      ? "bg-white/5 border-white/10 hover:bg-white/10"
                      : "bg-white border-gray-200 hover:bg-gray-50"
                  )}
                >
                  Komunikaty
                </button>
              </div>
            </div>
          </Card>
        </div>
      </div>

      <div className="hidden">
      <div>
        <div className="text-2xl font-extrabold">Strona główna</div>
        <div
          className={classNames(
            "text-sm",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          {isCompleted
            ? `Podsumowanie sezonu ${currentSeason}`
            : `Stan ligi: po ${playedRounds} kolejkach \u2022 Najbli\u017csza: ${currentRound}`
          }
        </div>
      </div>

      {/* WIDOK ZAMKNIĘTEGO SEZONU */}
      </div>
      {isCompleted && (
        <div className="grid lg:grid-cols-2 gap-3">
          {/* Mistrzowie lig */}
          <Card darkMode={darkMode}>
            <div className="font-extrabold mb-3 text-lg">Mistrzowie lig</div>
            <div className="space-y-3">
              {currentLeagues.map((lg) => {
                const champion = (tableByLeague[lg.id] || [])[0];
                if (!champion) return null;
                return (
                  <div
                    key={lg.id}
                    className={classNames(
                      "p-4 rounded-xl border-2 flex items-center gap-4 relative overflow-hidden",
                      darkMode
                        ? "border-yellow-500/40 bg-gradient-to-r from-yellow-500/10 to-transparent"
                        : "border-yellow-400/50 bg-gradient-to-r from-yellow-100 to-yellow-50"
                    )}
                  >
                    <div className="relative flex-shrink-0">
                      <div className={classNames(
                        "absolute inset-0 rounded-full blur-md",
                        darkMode ? "bg-yellow-500/20" : "bg-yellow-400/20"
                      )} style={{ transform: 'scale(1.2)' }} />
                      <TeamLogo
                        team={champion.team}
                        darkMode={darkMode}
                        size={64}
                        onClick={() => openTeam(champion.team)}
                        className="relative z-10 drop-shadow-[0_0_12px_rgba(234,179,8,0.3)] hover:scale-110 transition-transform cursor-pointer"
                      />
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className={classNames(
                        "text-[10px] font-black flex items-center gap-1",
                        darkMode ? "text-yellow-400" : "text-yellow-600"
                      )}>
                        <Trophy size={12} strokeWidth={2.5} />
                        {lg.name} — MISTRZ
                      </div>
                      <button
                        onClick={() => openTeam(champion.team)}
                        className="font-bold text-base hover:underline truncate block"
                      >
                        {displayTeamName(champion.team)}
                      </button>
                      <div className={classNames(
                        "text-xs font-medium",
                        darkMode ? "text-yellow-400/70" : "text-yellow-700/70"
                      )}>
                        {champion.pts} pkt • {champion.win}W {champion.draw}R {champion.loss}P
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </Card>

          {/* Wyróżnienia sezonu */}
          <Card darkMode={darkMode}>
            <div className="font-extrabold mb-3 text-lg">Wyróżnienia sezonu</div>
            <div className="space-y-3">
              {/* Król strzelców */}
              {topScorers[0] && (
                <div
                  className={classNames(
                    "p-3 rounded-xl border flex items-center gap-3",
                    darkMode
                      ? "border-emerald-500/30 bg-emerald-500/5"
                      : "border-emerald-200 bg-emerald-50"
                  )}
                >
                  <div className={classNames(
                    "w-14 h-14 rounded-full flex items-center justify-center text-2xl font-black flex-shrink-0",
                    darkMode ? "bg-emerald-500/20 text-emerald-400" : "bg-emerald-100 text-emerald-700"
                  )}>
                    {topScorers[0].goals}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className={classNames(
                      "text-[10px] font-black",
                      darkMode ? "text-emerald-400" : "text-emerald-600"
                    )}>
                      KRÓL STRZELCÓW
                    </div>
                    <div className="font-bold text-sm truncate">
                      {topScorers[0].name}
                    </div>
                    <div className="flex items-center gap-1">
                      <span className={classNames(
                        "text-xs",
                        darkMode ? "text-gray-400" : "text-gray-600"
                      )}>
                        {displayTeamName(topScorers[0].team)}
                      </span>
                      <TeamLogo
                        team={topScorers[0].team}
                        darkMode={darkMode}
                        size={16}
                        onClick={() => openTeam(topScorers[0].team)}
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* Najlepszy asystent */}
              {topAssists[0] && (
                <div
                  className={classNames(
                    "p-3 rounded-xl border flex items-center gap-3",
                    darkMode
                      ? "border-blue-500/30 bg-blue-500/5"
                      : "border-blue-200 bg-blue-50"
                  )}
                >
                  <div className={classNames(
                    "w-14 h-14 rounded-full flex items-center justify-center text-2xl font-black flex-shrink-0",
                    darkMode ? "bg-blue-500/20 text-blue-400" : "bg-blue-100 text-blue-700"
                  )}>
                    {topAssists[0].assists}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className={classNames(
                      "text-[10px] font-black",
                      darkMode ? "text-blue-400" : "text-blue-600"
                    )}>
                      NAJLEPSZY ASYSTENT
                    </div>
                    <div className="font-bold text-sm truncate">
                      {topAssists[0].name}
                    </div>
                    <div className="flex items-center gap-1">
                      <span className={classNames(
                        "text-xs",
                        darkMode ? "text-gray-400" : "text-gray-600"
                      )}>
                        {displayTeamName(topAssists[0].team)}
                      </span>
                      <TeamLogo
                        team={topAssists[0].team}
                        darkMode={darkMode}
                        size={16}
                        onClick={() => openTeam(topAssists[0].team)}
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* Najlepsza obrona */}
              {currentLeagues.length > 0 && (() => {
                // Drużyna z najmniejszą liczbą straconych bramek (z I Ligi)
                const firstLeague = tableByLeague['1st'] || tableByLeague[currentLeagues[0]?.id] || [];
                const bestDefense = [...firstLeague].sort((a, b) => a.ga - b.ga)[0];
                if (!bestDefense) return null;
                return (
                  <div
                    className={classNames(
                      "p-3 rounded-xl border flex items-center gap-3",
                      darkMode
                        ? "border-sky-500/30 bg-sky-500/5"
                        : "border-sky-200 bg-sky-50"
                    )}
                  >
                    <TeamLogo
                      team={bestDefense.team}
                      darkMode={darkMode}
                      size={56}
                      onClick={() => openTeam(bestDefense.team)}
                    />
                    <div className="flex-1 min-w-0">
                      <div className={classNames(
                        "text-[10px] font-black",
                        darkMode ? "text-sky-400" : "text-sky-600"
                      )}>
                        NAJLEPSZA OBRONA (I Liga)
                      </div>
                      <button
                        onClick={() => openTeam(bestDefense.team)}
                        className="font-bold text-sm hover:underline truncate block"
                      >
                        {displayTeamName(bestDefense.team)}
                      </button>
                      <div className={classNames(
                        "text-xs",
                        darkMode ? "text-gray-400" : "text-gray-600"
                      )}>
                        {bestDefense.ga} straconych bramek w {bestDefense.played} meczach
                      </div>
                    </div>
                  </div>
                );
              })()}
            </div>
          </Card>
        </div>
      )}

      {/* WIDOK BIEŻĄCEGO SEZONU */}
      {!isCompleted && (
        <div className="grid lg:grid-cols-2 gap-3">
          <Card darkMode={darkMode}>
            <div className="font-extrabold mb-2">
              Najbliższe mecze (kolejka {currentRound})
            </div>
            <div className="space-y-2">
              {upcoming.length === 0 && (
                <div className={classNames(
                  "text-sm text-center py-4",
                  darkMode ? "text-gray-500" : "text-gray-400"
                )}>
                  Brak zaplanowanych meczów
                </div>
              )}
              {upcoming.map((f) => {
                const playedMatch = matchById[f.id];
                const isExpanded = expandedMatchId === f.id;
                const upcomingDate = fixtureDateHeaderParts(f.date);
                return (
                  <React.Fragment key={f.id}>
                    <div
                      className={classNames(
                        "p-2 rounded-xl border",
                        darkMode
                          ? "border-white/10 bg-black/10"
                          : "border-gray-200 bg-gray-50"
                      )}
                    >
                      <div className="md:hidden space-y-2">
                        <div
                          className={classNames(
                            "text-[11px] font-semibold px-1",
                            darkMode ? "text-gray-400" : "text-gray-600"
                          )}
                        >
                          {upcomingDate.weekday
                            ? `${upcomingDate.weekday}, ${upcomingDate.date || f.date || "Termin do ustalenia"}`
                            : (upcomingDate.date || f.date || "Termin do ustalenia")}
                        </div>

                        <MobileFlashscoreMatchRow
                          darkMode={darkMode}
                          homeTeam={f.home}
                          awayTeam={f.away}
                          onOpenHome={() => openTeam(f.home)}
                          onOpenAway={() => openTeam(f.away)}
                          onOpenMatch={() => openMatch(f.id)}
                          leftPrimary={fixtureCenterTimeLabel(f)}
                          leftSecondary={leagueName}
                          rightPrimaryTop={null}
                          rightPrimaryBottom={null}
                          isScore={false}
                          videoUrl={playedMatch?.videoUrl || f.videoUrl}
                          galleryUrl={playedMatch?.galleryUrl || f.galleryUrl}
                          onOpenGallery={
                            playedMatch?.hasGallery || f.hasGallery
                              ? () => openGallery?.(playedMatch || f)
                              : undefined
                          }
                          galleryCount={playedMatch?.galleryCount || f.galleryCount || 0}
                        />
                      </div>

                      <div className="hidden md:grid grid-cols-[40px_minmax(0,1fr)_240px_minmax(0,1fr)_40px] gap-2 items-center">
                        <TeamLogo
                          team={f.home}
                          darkMode={darkMode}
                          size={40}
                          onClick={() => openTeam(f.home)}
                        />

                        <TeamLink
                          team={f.home}
                          onClick={() => openTeam(f.home)}
                          className="font-bold e3d-link truncate"
                        />

                        <div className="flex items-center gap-2 justify-center flex-shrink-0">
                          <VideoIcon
                            darkMode={darkMode}
                            videoUrl={playedMatch?.videoUrl || f.videoUrl}
                            played={!!playedMatch}
                            galleryUrl={playedMatch?.galleryUrl || f.galleryUrl}
                            hasGallery={!!(playedMatch?.hasGallery || f.hasGallery)}
                            galleryCount={playedMatch?.galleryCount || f.galleryCount || 0}
                            onOpenGallery={
                              playedMatch?.hasGallery || f.hasGallery
                                ? () => openGallery?.(playedMatch || f)
                                : undefined
                            }
                            size={16}
                          />
                          <button
                            onClick={() => openMatch(f.id)}
                            className={classNames(
                              "px-3 py-1 rounded-xl border text-xs font-bold e3d-pill whitespace-nowrap",
                              darkMode
                                ? "bg-white/5 border-white/10"
                                : "bg-black/5 border-black/10"
                            )}
                            title="Szczegóły meczu"
                          >
                            {fixtureCenterLabel(f)}
                          </button>
                        </div>

                        <TeamLink
                          team={f.away}
                          onClick={() => openTeam(f.away)}
                          className="font-bold e3d-link text-right truncate"
                        />

                        <TeamLogo
                          team={f.away}
                          darkMode={darkMode}
                          size={40}
                          onClick={() => openTeam(f.away)}
                        />
                      </div>
                    </div>
                    {isExpanded && playedMatch && (
                      <div id={`details-${f.id}`}>
                        <MatchDetailsInline
                          darkMode={darkMode}
                          match={playedMatch}
                          openTeam={openTeam}
                          openPlayer={openPlayer}
                          openGallery={openGallery}
                        />
                      </div>
                    )}

                    {isExpanded && !playedMatch && (
                      <div id={`details-${f.id}`}>
                        <UpcomingMatchDetailsInline
                          darkMode={darkMode}
                          fixture={f}
                          stats={stats}
                          matches={matches}
                          playersByTeam={playersByTeam}
                          openTeam={openTeam}
                          openPlayer={openPlayer}
                        />
                      </div>
                    )}
                  </React.Fragment>
                );
              })}
            </div>
          </Card>

          <Card darkMode={darkMode}>
            <div className="font-extrabold mb-2">Ostatnie wyniki</div>
            <div className="space-y-2">
              {lastMatches.length === 0 && (
                <div className={classNames(
                  "text-sm text-center py-4",
                  darkMode ? "text-gray-500" : "text-gray-400"
                )}>
                  Brak rozegranych meczów
                </div>
              )}
              {lastMatches.map((m) => {
                const isExpanded = expandedMatchId === m.id;
                const resultDate = fixtureDateHeaderParts(m.date);
                return (
                  <React.Fragment key={m.id}>
                    <div
                      className={classNames(
                        "p-2 rounded-xl border",
                        darkMode
                          ? "border-white/10 bg-black/10"
                          : "border-gray-200 bg-gray-50"
                      )}
                    >
                      <div className="md:hidden space-y-2">
                        <div
                          className={classNames(
                            "text-[11px] font-semibold px-1",
                            darkMode ? "text-gray-400" : "text-gray-600"
                          )}
                        >
                          {resultDate.weekday
                            ? `${resultDate.weekday}, ${resultDate.date || m.date || ""}`
                            : (resultDate.date || m.date || "")}
                        </div>

                        <MobileFlashscoreMatchRow
                          darkMode={darkMode}
                          homeTeam={m.home}
                          awayTeam={m.away}
                          onOpenHome={() => openTeam(m.home)}
                          onOpenAway={() => openTeam(m.away)}
                          onOpenMatch={() => openMatch(m.id)}
                          leftPrimary={m.time || "—"}
                          leftSecondary={compactDateLabel(m.date)}
                          rightPrimaryTop={m.homeGoals}
                          rightPrimaryBottom={m.awayGoals}
                          isScore={true}
                          videoUrl={m.videoUrl}
                          galleryUrl={m.galleryUrl}
                          onOpenGallery={m.hasGallery ? () => openGallery?.(m) : undefined}
                          galleryCount={m.galleryCount}
                        />
                      </div>

                      <div className="hidden md:grid grid-cols-[40px_minmax(0,1fr)_auto_minmax(0,1fr)_40px] gap-2 items-center">
                        <TeamLogo
                          team={m.home}
                          darkMode={darkMode}
                          size={40}
                          onClick={() => openTeam(m.home)}
                        />

                        <TeamLink
                          team={m.home}
                          onClick={() => openTeam(m.home)}
                          className="font-bold e3d-link truncate"
                        />

                        <div className="flex items-center justify-center gap-2 min-w-0">
                          <VideoIcon
                            darkMode={darkMode}
                            videoUrl={m.videoUrl}
                            played={true}
                            galleryUrl={m.galleryUrl}
                            hasGallery={m.hasGallery}
                            galleryCount={m.galleryCount}
                            onOpenGallery={m.hasGallery ? () => openGallery?.(m) : undefined}
                            size={16}
                          />
                          <div className="justify-self-center">
                            <ScorePill
                              homeGoals={m.homeGoals}
                              awayGoals={m.awayGoals}
                              darkMode={darkMode}
                              onClick={() => openMatch(m.id)}
                              date={m.date}
                              time={m.time}
                              status={m.status}
                            />
                          </div>
                        </div>

                        <TeamLink
                          team={m.away}
                          onClick={() => openTeam(m.away)}
                          className="font-bold e3d-link text-right truncate"
                        />

                        <TeamLogo
                          team={m.away}
                          darkMode={darkMode}
                          size={40}
                          onClick={() => openTeam(m.away)}
                        />
                      </div>
                    </div>
                    {isExpanded && (
                      <div id={`details-${m.id}`}>
                        <MatchDetailsInline
                          darkMode={darkMode}
                          match={m}
                          openTeam={openTeam}
                          openPlayer={openPlayer}
                          openGallery={openGallery}
                        />
                      </div>
                    )}
                  </React.Fragment>
                );
              })}
            </div>
          </Card>
        </div>
      )}

      <div className="grid xl:grid-cols-[1.2fr_1.8fr] gap-3">
        <Card darkMode={darkMode}>
          <div className="flex items-center justify-between gap-2 mb-3">
            <div>
              <div className="text-xl font-extrabold">Aktualności MLPN</div>
              <div
                className={classNames(
                  "text-xs",
                  darkMode ? "text-gray-400" : "text-gray-600"
                )}
              >
                Szybki podgląd najnowszych wpisów
              </div>
            </div>
            <button
              onClick={() => openHomeTab("news")}
              className={classNames(
                "px-3 py-2 rounded-xl border text-xs font-bold e3d-btn",
                darkMode
                  ? "bg-white/5 border-white/10 hover:bg-white/10"
                  : "bg-white border-gray-200 hover:bg-gray-50"
              )}
            >
              Wszystkie newsy
            </button>
          </div>

          <div className="space-y-2">
            {latestNews.length === 0 && (
              <div
                className={classNames(
                  "text-sm text-center py-6",
                  darkMode ? "text-gray-400" : "text-gray-500"
                )}
              >
                Brak aktualności
              </div>
            )}
            {latestNews.map((n) => (
              <div
                key={n.id}
                className={classNames(
                  "rounded-xl border p-3",
                  darkMode
                    ? "border-white/10 bg-black/10"
                    : "border-gray-200 bg-white"
                )}
              >
                <div className="flex items-start justify-between gap-2">
                  <div className="min-w-0">
                    <div className="font-bold truncate">{n.title}</div>
                    <div
                      className={classNames(
                        "text-xs mt-1",
                        darkMode ? "text-gray-400" : "text-gray-600"
                      )}
                    >
                      {n.date} • {n.category || "komunikat"}
                    </div>
                  </div>
                  {n.fixtureId && (
                    <button
                      onClick={() => openMatch?.(n.fixtureId)}
                      className={classNames(
                        "px-2 py-1 rounded-lg border text-[11px] font-bold e3d-pill whitespace-nowrap",
                        darkMode
                          ? "bg-white/5 border-white/10"
                          : "bg-black/5 border-black/10"
                      )}
                    >
                      Mecz
                    </button>
                  )}
                </div>
                {n.body && (
                  <div
                    className={classNames(
                      "text-xs mt-2 line-clamp-2",
                      darkMode ? "text-gray-300" : "text-gray-700"
                    )}
                  >
                    {n.body}
                  </div>
                )}
              </div>
            ))}
          </div>
        </Card>

        <div>
          <div className="mb-2">
            <div className="text-2xl font-extrabold">Ligi - dashboard</div>
            <div
              className={classNames(
                "text-sm",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              Mini tabela, lider ligi i postep rozgrywek
            </div>
          </div>

          <div className="grid lg:grid-cols-2 gap-3">
            {leagueOverview.map((lg) => (
              <Card key={lg.id} darkMode={darkMode} className="overflow-hidden">
                <div
                  className={classNames(
                    "rounded-xl border p-3 mb-3",
                    darkMode
                      ? "border-white/10 bg-white/5"
                      : "border-gray-200 bg-gray-50"
                  )}
                >
                  <div className="flex items-center justify-between gap-2">
                    <button
                      onClick={() => goToLeague?.(lg.id)}
                      className="text-lg font-extrabold hover:underline"
                    >
                      {leagueLabel(lg.id)}
                    </button>
                    <span
                      className={classNames(
                        "text-xs font-bold",
                        darkMode ? "text-gray-300" : "text-gray-700"
                      )}
                    >
                      {lg.playedPct}%
                    </span>
                  </div>

                  <div
                    className={classNames(
                      "text-xs mt-1",
                      darkMode ? "text-gray-400" : "text-gray-600"
                    )}
                  >
                    {lg.leagueMatches.length} / {lg.leagueFixtures.length} meczów
                  </div>

                  <div
                    className={classNames(
                      "mt-2 h-2 rounded-full overflow-hidden",
                      darkMode ? "bg-white/10" : "bg-gray-200"
                    )}
                  >
                    <div
                      className={classNames(
                        "h-full rounded-full",
                        lg.id === "1st"
                          ? "bg-rose-400"
                          : lg.id === "2nd"
                          ? "bg-blue-400"
                          : "bg-emerald-400"
                      )}
                      style={{ width: `${lg.playedPct}%` }}
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  {lg.top3.map((r) => (
                    <div
                      key={r.team}
                      className={classNames(
                        "p-2 rounded-xl border flex items-center justify-between gap-2",
                        darkMode
                          ? "border-white/10 bg-black/10"
                          : "border-gray-200 bg-white"
                      )}
                    >
                      <div className="flex items-center gap-2 min-w-0">
                        <div
                          className={classNames(
                            "w-6 h-6 rounded-lg border text-xs font-extrabold flex items-center justify-center flex-shrink-0",
                            darkMode
                              ? "bg-white/5 border-white/10"
                              : "bg-gray-50 border-gray-200"
                          )}
                        >
                          {r.pos}
                        </div>
                        <TeamLogo
                          team={r.team}
                          darkMode={darkMode}
                          size={30}
                          onClick={() => openTeam(r.team)}
                        />
                        <TeamLink
                          team={displayTeamName(r.team)}
                          onClick={() => openTeam(r.team)}
                          className="font-bold e3d-link text-sm truncate"
                        />
                      </div>
                      <div className="font-extrabold">{r.pts}</div>
                    </div>
                  ))}

                  {lg.topScorer && (
                    <div
                      className={classNames(
                        "mt-2 p-3 rounded-xl border",
                        darkMode
                          ? "border-white/10 bg-black/10"
                          : "border-gray-200 bg-white"
                      )}
                    >
                      <div
                        className={classNames(
                          "text-[10px] uppercase tracking-wider font-black",
                          darkMode ? "text-gray-400" : "text-gray-500"
                        )}
                      >
                        Lider strzelcow
                      </div>
                      <div className="flex items-center justify-between gap-2 mt-1">
                        <button
                          onClick={() => openPlayer?.(lg.topScorer.playerId)}
                          className="font-bold hover:underline text-left truncate"
                        >
                          {lg.topScorer.name}
                        </button>
                        <span className="font-extrabold">
                          {lg.topScorer.goals}
                        </span>
                      </div>
                      <button
                        onClick={() => openTeam(lg.topScorer.team)}
                        className={classNames(
                          "text-xs mt-1 hover:underline",
                          darkMode ? "text-gray-300" : "text-gray-700"
                        )}
                      >
                        {displayTeamName(lg.topScorer.team)}
                      </button>
                    </div>
                  )}

                  {lg.nextMatch && (
                    <button
                      onClick={() => openMatch(lg.nextMatch.id)}
                      className={classNames(
                        "w-full mt-1 p-3 rounded-xl border text-left",
                        darkMode
                          ? "border-white/10 bg-white/5 hover:bg-white/10"
                          : "border-gray-200 bg-gray-50 hover:bg-white"
                      )}
                    >
                      <div
                        className={classNames(
                          "text-[10px] uppercase tracking-wider font-black",
                          darkMode ? "text-gray-400" : "text-gray-500"
                        )}
                      >
                        Najbliższy mecz
                      </div>
                      <div className="font-bold text-sm mt-1 truncate">
                        {displayTeamName(lg.nextMatch.home)} vs{" "}
                        {displayTeamName(lg.nextMatch.away)}
                      </div>
                      <div
                        className={classNames(
                          "text-xs mt-1",
                          darkMode ? "text-gray-400" : "text-gray-600"
                        )}
                      >
                        {lg.nextMatch.date} • {lg.nextMatch.time || "--:--"} •
                        {" "}kolejka {lg.nextMatch.round}
                      </div>
                    </button>
                  )}
                </div>
              </Card>
            ))}
          </div>
        </div>
      </div>

      <div className="hidden grid lg:grid-cols-3 gap-3">
        {currentLeagues.map((lg) => (
          <Card key={lg.id} darkMode={darkMode}>
            <div className="font-extrabold mb-2">{lg.name} – TOP 3</div>
            <div className="space-y-2">
              {(tableByLeague[lg.id] || []).slice(0, 3).map((r) => (
                <div
                  key={r.team}
                  className={classNames(
                    "p-2 rounded-xl border flex items-center justify-between gap-3",
                    darkMode
                      ? "border-white/10 bg-black/10"
                      : "border-gray-200 bg-gray-50"
                  )}
                >
                  <div className="flex items-center gap-2">
                    <div className="w-7 text-center font-extrabold">
                      {r.pos}
                    </div>
                    <TeamLogo
                      team={r.team}
                      darkMode={darkMode}
                      size={38}
                      onClick={() => openTeam(r.team)}
                    />
                    <TeamLink
                      team={r.team}
                      onClick={() => openTeam(r.team)}
                      className="font-bold e3d-link"
                    />
                  </div>
                  <div className="font-extrabold">{r.pts} pkt</div>
                </div>
              ))}
            </div>
          </Card>
        ))}
      </div>
    </div>
  );
}

function NewsPage({ darkMode, news, openTeam, openMatch, openPlayer }) {
  const [openId, setOpenId] = useState(null);

  const catMeta = (cat) => {
    if (cat === "pauza")
      return {
        label: "pauza",
        cls: "bg-yellow-300 text-black border-yellow-400/40",
        icon: "⏸",
      };
    if (cat === "ważne")
      return {
        label: "ważne",
        cls: "bg-rose-400 text-black border-rose-500/40",
        icon: "⚠",
      };
    return {
      label: "komunikat",
      cls: "bg-sky-300 text-black border-sky-400/40",
      icon: "ℹ",
    };
  };

  return (
    <div className="space-y-4">
      <div>
        <div className="text-2xl font-extrabold">Aktualności</div>
        <div
          className={classNames(
            "text-sm",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Belki z tytułem • klik = rozwiń • klik ponownie = zwiń
        </div>
      </div>

      {news.length === 0 ? (
        <Card darkMode={darkMode}>
          <div className={classNames("text-center py-8", darkMode ? "text-gray-400" : "text-gray-500")}>
            Brak aktualności
          </div>
        </Card>
      ) : <div className="grid gap-3">
        {news.map((p) => {
          const meta = catMeta(p.category);
          const isOpen = openId === p.id;

          return (
            <Card
              key={p.id}
              darkMode={darkMode}
              className="p-0 overflow-hidden"
            >
              {/* BELKA */}
              <button
                onClick={() => setOpenId(isOpen ? null : p.id)}
                className={classNames(
                  "w-full px-4 py-3 flex items-center justify-between gap-3 text-left",
                  darkMode ? "hover:bg-white/5" : "hover:bg-gray-50"
                )}
              >
                <div className="min-w-0">
                  <div className="font-extrabold truncate">{p.title}</div>
                  <div
                    className={classNames(
                      "text-xs mt-1",
                      darkMode ? "text-gray-400" : "text-gray-600"
                    )}
                  >
                    {p.date}
                  </div>
                </div>

                <span
                  className={classNames(
                    "shrink-0 px-3 py-1 rounded-full border text-xs font-black e3d-pill",
                    meta.cls
                  )}
                  title={meta.label}
                >
                  {meta.icon} {meta.label}
                </span>
              </button>

              {/* TREŚĆ */}
              {isOpen && (
                <div
                  className={classNames(
                    "px-4 pb-4",
                    darkMode ? "text-gray-200" : "text-gray-800"
                  )}
                >
                  {p.category === "pauza" ? (
                    <div className="space-y-2">
                      <div
                        className={classNames(
                          "text-sm font-bold",
                          darkMode ? "text-gray-300" : "text-gray-700"
                        )}
                      >
                        Lista pauzujących:
                      </div>

                      <div className="grid sm:grid-cols-2 gap-2">
                        {(p.suspended || []).map((s) => (
                          <div
                            key={s.playerId}
                            className={classNames(
                              "p-2 rounded-xl border",
                              darkMode
                                ? "border-white/10 bg-black/10"
                                : "border-gray-200 bg-gray-50"
                            )}
                          >
                            <div className="flex items-center justify-between gap-2">
                              <button
                                onClick={() => openPlayer(s.playerId)}
                                className="font-extrabold underline"
                              >
                                {s.name}
                              </button>
                              <button
                                onClick={() => openTeam(s.team)}
                                className="text-xs font-extrabold underline"
                              >
                                {displayTeamName(s.team)}
                              </button>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  ) : (
                    <div className="space-y-3">
                      <div>{p.body}</div>

                      {/* Linki (hiperłącza) – gdzie się da */}
                      {p.fixtureId && p.home && p.away && (
                        <div className="flex flex-wrap items-center gap-2 text-sm">
                          <span className="opacity-70">Mecz:</span>
                          <button
                            onClick={() => openTeam(p.home)}
                            className="font-extrabold underline"
                          >
                            {displayTeamName(p.home)}
                          </button>
                          <span className="opacity-70">vs</span>
                          <button
                            onClick={() => openTeam(p.away)}
                            className="font-extrabold underline"
                          >
                            {displayTeamName(p.away)}
                          </button>
                          <span className="opacity-70">•</span>
                          <button
                            onClick={() => openMatch(p.fixtureId)}
                            className="font-extrabold underline"
                          >
                            Szczegóły meczu
                          </button>
                        </div>
                      )}

                      {Array.isArray(p.teamsHint) && p.teamsHint.length > 0 && (
                        <div className="flex flex-wrap items-center gap-2 text-sm">
                          <span className="opacity-70">Dotyczy m.in.:</span>
                          {p.teamsHint.map((t) => (
                            <button
                              key={t}
                              onClick={() => openTeam(t)}
                              className="font-extrabold underline"
                            >
                              {displayTeamName(t)}
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                  )}
                </div>
              )}
            </Card>
          );
        })}
      </div>}
    </div>
  );
}

function TyperPage({
  darkMode,
  typerMatches,
  typerConfig,
  teamStats,
  matches,
  openTeam,
  goToLeague,
  currentLeagues,
  currentRound,
}) {
  const [picks, setPicks] = useState({}); // matchId -> "1"/"X"/"2"
  const [submitted, setSubmitted] = useState(false);
  const [othersDist, setOthersDist] = useState(null); // { matchId: { '1': pct, 'X': pct, '2': pct, total } }

  const selectPick = (id, v) => {
    setSubmitted(false);
    setOthersDist(null);
    setPicks((prev) => ({ ...prev, [id]: v }));
  };

  const allPicked = typerMatches.every((m) => picks[m.id]);

  const recentMap = useMemo(() => {
    const m = {};
    // precompute last matches per team for tooltipy formy
    for (const lg of currentLeagues) {
      for (const t of lg.teams) {
        m[t] = getTeamRecentMatches(t, matches || []);
      }
    }
    return m;
  }, [matches, currentLeagues]);

  const formDots = (team) =>
    getTeamFormDotsWithTooltips(team, recentMap[team] || []);

  const buildOthersDistribution = () => {
    // Symulacja "innych użytkowników" – deterministyczna losowość per mecz.
    const out = {};
    for (const m of typerMatches) {
      const rng = mulberry32(hashString(`typer|${currentRound}|${m.id}`));
      const c1 = 20 + Math.floor(rng() * 180);
      const cx = 10 + Math.floor(rng() * 120);
      const c2 = 20 + Math.floor(rng() * 180);
      const total = c1 + cx + c2;
      const p1 = Math.round((c1 / total) * 100);
      const px = Math.round((cx / total) * 100);
      const p2 = Math.max(0, 100 - p1 - px); // domknij do 100
      out[m.id] = { 1: p1, X: px, 2: p2 };
    }
    return out;
  };

  return (
    <div className="space-y-4">
      <div>
        <div className="text-2xl font-extrabold">
          {typerConfig?.title || `Typer kolejki ${currentRound}`}
        </div>
        <div
          className={classNames(
            "text-sm",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          {typerConfig?.description || "5 meczów • typowanie 1X2 • nagroda: bon 30 zł do Jadłostacji"}
        </div>
      </div>

      <Card darkMode={darkMode}>
        <div className="grid gap-1.5">
          {typerMatches.map((m) => (
            <div
              key={m.id}
              className={classNames(
                "p-1.5 rounded-lg border",
                darkMode
                  ? "border-white/10 bg-black/10"
                  : "border-gray-200 bg-gray-50"
              )}
            >
              <div className="md:hidden space-y-3 p-1">
                <div className="flex items-center justify-between gap-2">
                  <LeagueLink
                    leagueId={m.league}
                    leagueName={
                      ({ "1st": "I Liga", "2nd": "II Liga", "3rd": "III Liga" }[m.league] || m.league)
                    }
                    onClick={() => goToLeague(m.league)}
                    className="text-xs"
                  />
                  <div
                    className={classNames(
                      "text-[11px] px-2.5 py-1 rounded-full border font-semibold",
                      darkMode
                        ? "bg-white/5 border-white/10 text-gray-300"
                        : "bg-black/5 border-black/10 text-gray-700"
                    )}
                  >
                    {m.date}{m.time ? ` • ${m.time}` : ""}
                  </div>
                </div>

                <div className="space-y-2">
                  <div className="rounded-2xl border border-transparent px-1 py-1.5">
                    <div className="flex items-center gap-3 min-w-0">
                      <TeamLogo
                        team={m.home}
                        darkMode={darkMode}
                        size={42}
                        onClick={() => openTeam(m.home)}
                      />
                      <button
                        type="button"
                        onClick={() => openTeam(m.home)}
                        className="min-w-0 text-left text-sm font-bold leading-tight hover:underline"
                      >
                        {displayTeamName(m.home)}
                      </button>
                    </div>
                    {!submitted && (
                      <div className="mt-2 flex gap-0.5 pl-[54px]">
                        {getTeamFormDotsWithTooltips(m.home, matches)
                          .slice(0, 5)
                          .map((d, i) => (
                            <FormDot key={i} v={d.v} title={d.title} />
                          ))}
                      </div>
                    )}
                  </div>

                  <div
                    className={classNames(
                      "text-[10px] font-black uppercase tracking-[0.18em] text-center",
                      darkMode ? "text-gray-400" : "text-gray-500"
                    )}
                  >
                    vs
                  </div>

                  <div className="rounded-2xl border border-transparent px-1 py-1.5">
                    <div className="flex items-center justify-end gap-3 min-w-0">
                      <button
                        type="button"
                        onClick={() => openTeam(m.away)}
                        className="min-w-0 text-right text-sm font-bold leading-tight hover:underline"
                      >
                        {displayTeamName(m.away)}
                      </button>
                      <TeamLogo
                        team={m.away}
                        darkMode={darkMode}
                        size={42}
                        onClick={() => openTeam(m.away)}
                      />
                    </div>
                    {!submitted && (
                      <div className="mt-2 flex justify-end gap-0.5 pr-[54px]">
                        {getTeamFormDotsWithTooltips(m.away, matches)
                          .slice(0, 5)
                          .map((d, i) => (
                            <FormDot key={i} v={d.v} title={d.title} />
                          ))}
                      </div>
                    )}
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-2">
                  {[
                    { k: "1", label: "1" },
                    { k: "X", label: "X" },
                    { k: "2", label: "2" },
                  ].map((b) => (
                    <button
                      key={`mobile-${b.k}-${m.id}`}
                      onClick={() => selectPick(m.id, b.k)}
                      className={classNames(
                        "min-h-[52px] rounded-xl border font-bold text-base e3d-dot",
                        picks[m.id] === b.k
                          ? "bg-green-400 text-black border-green-500/40"
                          : darkMode
                          ? "bg-white/5 border-white/10 hover:bg-white/10 text-white"
                          : "bg-black/5 border-black/10 hover:bg-black/10 text-gray-900"
                      )}
                    >
                      <div>{b.label}</div>
                      {submitted && othersDist?.[m.id] && (
                        <div
                          className={classNames(
                            "text-[10px] font-normal leading-none mt-0.5",
                            picks[m.id] === b.k
                              ? "text-black/70"
                              : darkMode
                              ? "text-gray-400"
                              : "text-gray-500"
                          )}
                        >
                          {othersDist[m.id][b.k]}%
                        </div>
                      )}
                    </button>
                  ))}
                </div>
              </div>

              <div className="hidden md:block">
                <div className="grid grid-cols-[36px_minmax(0,1fr)_auto_minmax(0,1fr)_36px] gap-1.5 items-center">
                  <TeamLogo
                    team={m.home}
                    darkMode={darkMode}
                    size={36}
                    onClick={() => openTeam(m.home)}
                  />

                  <TeamLink
                    team={m.home}
                    onClick={() => openTeam(m.home)}
                    className="font-semibold text-xs e3d-link truncate"
                  />

                  <div
                    className={classNames(
                      "text-xs px-1.5 py-0.5 rounded-full border e3d-pill flex items-center gap-1 whitespace-nowrap",
                      darkMode
                        ? "bg-white/5 border-white/10"
                        : "bg-black/5 border-black/10"
                    )}
                  >
                    <LeagueLink
                      leagueId={m.league}
                      leagueName={
                        ({ "1st": "I Liga", "2nd": "II Liga", "3rd": "III Liga" }[m.league] || m.league)
                      }
                      onClick={() => goToLeague(m.league)}
                      className="text-xs"
                    />
                    <span>•</span>
                    <span className="font-semibold">{m.date}</span>
                  </div>

                  <TeamLink
                    team={m.away}
                    onClick={() => openTeam(m.away)}
                    className="font-semibold text-xs e3d-link text-right truncate"
                  />

                  <TeamLogo
                    team={m.away}
                    darkMode={darkMode}
                    size={36}
                    onClick={() => openTeam(m.away)}
                  />
                </div>

                {!submitted && (
                  <div className="mt-1 flex items-center justify-between px-1">
                    <div className="flex gap-0.5">
                      {getTeamFormDotsWithTooltips(m.home, matches)
                        .slice(0, 5)
                        .map((d, i) => (
                          <FormDot key={i} v={d.v} title={d.title} />
                        ))}
                    </div>
                    <div className="flex gap-0.5">
                      {getTeamFormDotsWithTooltips(m.away, matches)
                        .slice(0, 5)
                        .map((d, i) => (
                          <FormDot key={i} v={d.v} title={d.title} />
                        ))}
                    </div>
                  </div>
                )}

                <div className="mt-1 flex items-center justify-center gap-1.5">
                  {[
                    { k: "1", label: "1" },
                    { k: "X", label: "X" },
                    { k: "2", label: "2" },
                  ].map((b) => (
                    <button
                      key={b.k}
                      onClick={() => selectPick(m.id, b.k)}
                      className={classNames(
                        "w-12 py-1 rounded-lg border font-bold text-sm e3d-dot",
                        picks[m.id] === b.k
                          ? "bg-green-400 text-black border-green-500/40"
                          : darkMode
                          ? "bg-white/5 border-white/10 hover:bg-white/10 text-white"
                          : "bg-black/5 border-black/10 hover:bg-black/10 text-gray-900"
                      )}
                    >
                      <div>{b.label}</div>
                      {submitted && othersDist?.[m.id] && (
                        <div
                          className={classNames(
                            "text-[10px] font-normal leading-none mt-0.5",
                            picks[m.id] === b.k
                              ? "text-black/70"
                              : darkMode
                              ? "text-gray-400"
                              : "text-gray-500"
                          )}
                        >
                          {othersDist[m.id][b.k]}%
                        </div>
                      )}
                    </button>
                  ))}
                </div>
              </div>
            </div>
          ))}
        </div>

        <div className="mt-4 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          <div
            className={classNames(
              "text-xs",
              darkMode ? "text-gray-400" : "text-gray-600"
            )}
          >
            {allPicked
              ? "Masz komplet typów."
              : "Uzupełnij wszystkie typy, żeby wysłać."}
          </div>
          <button
            disabled={!allPicked}
            onClick={() => {
              setSubmitted(true);
              setOthersDist(buildOthersDistribution());
            }}
            className={classNames(
              "w-full sm:w-auto px-4 py-3 sm:py-2 rounded-xl font-extrabold border e3d-btn",
              allPicked
                ? "bg-green-400 text-black border-green-500/40 hover:brightness-110"
                : darkMode
                ? "bg-white/5 text-gray-500 border-white/10 cursor-not-allowed"
                : "bg-black/5 text-gray-400 border-black/10 cursor-not-allowed"
            )}
          >
            Wyślij typy
          </button>
        </div>

        {submitted && (
          <div
            className={classNames(
              "mt-3 p-3 rounded-xl border font-bold e3d-pill",
              darkMode
                ? "border-white/10 bg-white/5 text-green-300"
                : "border-black/10 bg-black/5 text-green-700"
            )}
          >
            Zapisano (symulacja). Typy są lokalnie w stanie komponentu.
          </div>
        )}
      </Card>
    </div>
  );
}

function PollsPage({ darkMode, polls }) {
  const [tab, setTab] = useState("new"); // new | voted | archived
  const [userVotes, setUserVotes] = useState({}); // pollId -> optionIndex
  const [processedVotes, setProcessedVotes] = useState(new Set()); // ankiety po zakończonej animacji
  const [counts, setCounts] = useState(() => {
    const obj = {};
    for (const p of polls)
      obj[p.id] = p.votes || p.options.map(() => 0);
    return obj;
  });
  const [collapsingPolls, setCollapsingPolls] = useState(new Set()); // animacja zwijania

  const vote = (pollId, idx) => {
    const alreadyVoted = userVotes[pollId] !== undefined;

    if (alreadyVoted) {
      // Zmiana głosu - odejmij stary, dodaj nowy
      setCounts((prev) => {
        const next = { ...prev };
        next[pollId] = [...next[pollId]];
        next[pollId][userVotes[pollId]] -= 1;
        next[pollId][idx] += 1;
        return next;
      });
    } else {
      // Nowy głos - dodaj i oznacz jako przetworzoną
      setCounts((prev) => {
        const next = { ...prev };
        next[pollId] = [...next[pollId]];
        next[pollId][idx] += 1;
        return next;
      });

      // Zacznij zanikanie po 2s
      setTimeout(() => {
        setCollapsingPolls((prev) => new Set([...prev, pollId]));

        // Po 1.5s animacji oznacz jako przetworzoną
        setTimeout(() => {
          setCollapsingPolls((prev) => {
            const next = new Set(prev);
            next.delete(pollId);
            return next;
          });
          setProcessedVotes((prev) => new Set([...prev, pollId]));
        }, 1500);
      }, 2000);
    }

    setUserVotes((prev) => ({ ...prev, [pollId]: idx }));
  };

  // Filtrowanie ankiet - użyj processedVotes dla podziału na Nowe/Zagłosowane
  const activePolls = polls.filter((p) => p.status === "active");
  const archivedPolls = polls.filter((p) => p.status === "archived");

  const newPolls = activePolls.filter((p) => !processedVotes.has(p.id));
  const votedPolls = activePolls.filter((p) => processedVotes.has(p.id));

  let displayPolls = [];
  if (tab === "new") displayPolls = newPolls;
  else if (tab === "voted") displayPolls = votedPolls;
  else if (tab === "archived") displayPolls = archivedPolls;

  return (
    <div className="space-y-4">
      <div>
        <div className="text-2xl font-extrabold">Ankiety</div>
        <div
          className={classNames(
            "text-sm",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Zagłosuj w ankietach • Zobacz wyniki po oddaniu głosu
        </div>
      </div>

      {/* Zakładki */}
      <div className="flex gap-2">
        {[
          { id: "new", label: "Nowe", count: newPolls.length },
          { id: "voted", label: "Zagłosowane", count: votedPolls.length },
          { id: "archived", label: "Archiwalne", count: archivedPolls.length },
        ].map((t) => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            className={classNames(
              "px-4 py-2 rounded-xl border font-bold e3d-btn",
              tab === t.id
                ? "bg-green-400 text-black border-green-500/40"
                : darkMode
                ? "bg-white/5 border-white/10 hover:bg-white/10 text-gray-300"
                : "bg-black/5 border-black/10 hover:bg-black/10 text-gray-700"
            )}
          >
            {t.label} ({t.count})
          </button>
        ))}
      </div>

      {/* Lista ankiet */}
      <div className="grid gap-3">
        {displayPolls.length === 0 && (
          <Card darkMode={darkMode}>
            <div
              className={classNames(
                "text-center py-8",
                darkMode ? "text-gray-400" : "text-gray-600"
              )}
            >
              {tab === "new" && "Brak nowych ankiet"}
              {tab === "voted" && "Nie zagłosowałeś jeszcze w żadnej ankiecie"}
              {tab === "archived" && "Brak archiwalnych ankiet"}
            </div>
          </Card>
        )}

        {displayPolls.map((p) => {
          const total = (counts[p.id] || []).reduce((a, b) => a + b, 0);
          const hasVoted = userVotes[p.id] !== undefined;
          const isArchived = p.status === "archived";
          const showResults = hasVoted || isArchived;
          const isCollapsing = collapsingPolls.has(p.id);

          return (
            <Card
              key={p.id}
              darkMode={darkMode}
              className={classNames(
                "transition-opacity duration-[1500ms]",
                isCollapsing && "opacity-0"
              )}
            >
              <div className="flex items-start justify-between gap-3 mb-2">
                <div className="font-extrabold">{p.title}</div>
                {isArchived && (
                  <span
                    className={classNames(
                      "px-2 py-1 rounded-lg text-xs font-bold",
                      darkMode
                        ? "bg-white/10 text-gray-400"
                        : "bg-gray-200 text-gray-600"
                    )}
                  >
                    ZAKOŃCZONA
                  </span>
                )}
              </div>

              {/* Data zakończenia */}
              <div
                className={classNames(
                  "text-xs mb-3",
                  darkMode ? "text-gray-400" : "text-gray-600"
                )}
              >
                {isArchived ? "Zakończona: " : "Głosowanie do: "}
                <b>
                  {p.endDate} • {p.endTime}
                </b>
              </div>

              {/* Statystyki ogólne */}
              {!showResults && (
                <div
                  className={classNames(
                    "mb-3 text-sm",
                    darkMode ? "text-gray-400" : "text-gray-600"
                  )}
                >
                  Głosów oddanych: <b>{total}</b>
                </div>
              )}

              <div className="space-y-2">
                {p.options.map((opt, idx) => {
                  const c = counts[p.id]?.[idx] || 0;
                  const pct = total ? Math.round((c / total) * 100) : 0;
                  const chosen = userVotes[p.id] === idx;

                  return (
                    <button
                      key={idx}
                      onClick={() => !isArchived && vote(p.id, idx)}
                      disabled={isArchived}
                      className={classNames(
                        "w-full text-left p-3 rounded-2xl border e3d-card relative overflow-hidden",
                        chosen
                          ? "bg-green-400/20 border-green-500/30"
                          : darkMode
                          ? "bg-black/10 border-white/10 hover:bg-white/5"
                          : "bg-gray-50 border-gray-200 hover:bg-white",
                        isArchived && "cursor-not-allowed opacity-70"
                      )}
                    >
                      {/* Pasek tła (tylko gdy showResults) */}
                      {showResults && (
                        <div
                          className={classNames(
                            "absolute inset-0 transition-all duration-500",
                            darkMode ? "bg-white/5" : "bg-black/5"
                          )}
                          style={{ width: `${pct}%` }}
                        />
                      )}

                      {/* Treść */}
                      <div className="relative flex items-center justify-between gap-3">
                        <div className="font-bold">{opt}</div>
                        {showResults && (
                          <div className="font-extrabold">{pct}%</div>
                        )}
                      </div>
                    </button>
                  );
                })}
              </div>

              {/* Info o możliwości zmiany głosu */}
              {hasVoted && !isArchived && (
                <div
                  className={classNames(
                    "mt-3 text-xs text-center",
                    darkMode ? "text-gray-400" : "text-gray-600"
                  )}
                >
                  Możesz zmienić swój głos klikając inną odpowiedź
                </div>
              )}
            </Card>
          );
        })}
      </div>
    </div>
  );
}

function FreePlayersPage({ darkMode, freeAgents }) {
  const [openName, setOpenName] = useState(null);

  const toggle = (name) => setOpenName((prev) => (prev === name ? null : name));

  const chipCls = darkMode
    ? "border-white/10 bg-white/5 text-gray-200"
    : "border-black/10 bg-black/5 text-gray-900";

  const label = (p) => {
    // BR, O, P, N – wielokrotny wybór
    return (p.positions || []).join(" • ");
  };

  return (
    <div className="space-y-4">
      <div>
        <div className="text-2xl font-extrabold">Wolni zawodnicy</div>
        <div
          className={classNames(
            "text-sm",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          Rozwijane kafelki – bez profili i bez ID
        </div>
      </div>

      {freeAgents.length === 0 ? (
        <Card darkMode={darkMode}>
          <div className={classNames("text-center py-8", darkMode ? "text-gray-400" : "text-gray-500")}>
            Brak wolnych zawodników
          </div>
        </Card>
      ) : <Card darkMode={darkMode}>
        <div className="grid lg:grid-cols-2 gap-3">
          {freeAgents.map((p) => {
            const isOpen = openName === p.name;
            return (
              <div
                key={p.name}
                className={classNames(
                  "rounded-2xl border overflow-hidden e3d-card",
                  darkMode
                    ? "border-white/10 bg-black/10"
                    : "border-gray-200 bg-gray-50"
                )}
              >
                <button
                  onClick={() => toggle(p.name)}
                  className="w-full p-3 text-left flex items-start justify-between gap-3"
                >
                  <div>
                    <div className="font-extrabold">{p.name}</div>
                    <div
                      className={classNames(
                        "mt-1 text-sm font-semibold",
                        darkMode ? "text-gray-300" : "text-gray-700"
                      )}
                    >
                      {p.age} lat • {label(p)}
                    </div>
                    <div
                      className={classNames(
                        "mt-1 text-xs",
                        darkMode ? "text-gray-400" : "text-gray-600"
                      )}
                    >
                      Rejon: <span className="font-bold">{p.region}</span>
                    </div>
                  </div>

                  <div
                    className={classNames(
                      "shrink-0 px-3 py-1 rounded-full border text-xs font-bold e3d-pill",
                      chipCls
                    )}
                  >
                    {isOpen ? "Zwiń" : "Rozwiń"}
                  </div>
                </button>

                {isOpen && (
                  <div
                    className={classNames(
                      "p-3 border-t",
                      darkMode ? "border-white/10" : "border-gray-200"
                    )}
                  >
                    <div
                      className={classNames(
                        "text-sm",
                        darkMode ? "text-gray-200" : "text-gray-800"
                      )}
                    >
                      {p.experience}
                    </div>

                    <div className="mt-3 grid gap-2">
                      <div
                        className={classNames(
                          "px-3 py-2 rounded-xl border text-sm e3d-pill",
                          chipCls
                        )}
                      >
                        Telefon:{" "}
                        <span className="font-extrabold">
                          {p.contact?.phone || "—"}
                        </span>
                      </div>
                      <div
                        className={classNames(
                          "px-3 py-2 rounded-xl border text-sm e3d-pill",
                          chipCls
                        )}
                      >
                        E-mail:{" "}
                        <span className="font-extrabold">
                          {p.contact?.email || "—"}
                        </span>
                      </div>
                      <div
                        className={classNames(
                          "px-3 py-2 rounded-xl border text-sm e3d-pill",
                          chipCls
                        )}
                      >
                        Instagram:{" "}
                        <span className="font-extrabold">
                          {p.contact?.instagram || "—"}
                        </span>
                      </div>
                      <div
                        className={classNames(
                          "px-3 py-2 rounded-xl border text-sm e3d-pill",
                          chipCls
                        )}
                      >
                        Facebook:{" "}
                        <span className="font-extrabold">
                          {p.contact?.facebook || "—"}
                        </span>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </Card>}
    </div>
  );
}

/* =========================================
   UTIL: recent matches for team
   ========================================= */
function getTeamRecentMatches(team, matches) {
  const list = matches.filter((m) => m.home === team || m.away === team);
  list.sort((a, b) => b.round - a.round);
  return list.slice(0, 6);
}

function teamScheduleSortKey(item, mode = "asc") {
  const fallbackDate = mode === "asc" ? "9999-12-31" : "0000-01-01";
  const fallbackTime = mode === "asc" ? "23:59" : "00:00";
  return `${item?.date || fallbackDate} ${item?.time || fallbackTime}`;
}

function getTeamScheduleEntries(team, fixtures, matches) {
  const playedById = new Map((matches || []).map((match) => [match.id, match]));

  return (fixtures || [])
    .filter((fixture) => fixture.home === team || fixture.away === team)
    .map((fixture) => {
      const playedMatch = playedById.get(fixture.id);
      const isHome = fixture.home === team;

      return {
        ...fixture,
        played: !!playedMatch,
        homeGoals: playedMatch?.homeGoals ?? null,
        awayGoals: playedMatch?.awayGoals ?? null,
        opponent: isHome ? fixture.away : fixture.home,
      };
    });
}

function formatShortFixtureDate(dateStr) {
  if (!dateStr) return "Termin";
  const [year, month, day] = String(dateStr).split("-");
  if (!year || !month || !day) return String(dateStr);
  return `${day}.${month}`;
}

/* =========================================
   CSS: 3D + dopalacze (działa niezależnie)
   ========================================= */

function UpcomingMatchDetailsInline({
  darkMode,
  fixture,
  stats,
  matches,
  playersByTeam,
  openTeam,
  openPlayer,
}) {
  const home = fixture.home;
  const away = fixture.away;

  const table = stats?.tableByLeague?.[fixture.league] || [];
  const posOf = (team) => table.find((r) => r.team === team)?.pos || "—";
  const formOf = (team) => (stats?.teamStats?.[team]?.form5 || []).slice(0, 5);

  const topScorerOf = (team) => {
    const arr = Object.values(stats?.playerStats || {}).filter(
      (p) => p.team === team
    );
    if (!arr.length) return null;
    arr.sort(
      (a, b) =>
        (b.goals || 0) - (a.goals || 0) || (b.assists || 0) - (a.assists || 0)
    );
    return arr[0];
  };

  const captainOf = (team) => {
    const arr = playersByTeam?.[team] || [];
    if (!arr.length) return null;
    const rng = mulberry32(hashString("captain|" + team));
    return arr[Math.floor(rng() * arr.length)];
  };

  const h2hLast5 = (() => {
    const list = (matches || []).filter(
      (m) =>
        (m.home === home && m.away === away) ||
        (m.home === away && m.away === home)
    );
    list.sort((a, b) => b.round - a.round);
    return list.slice(0, 5);
  })();

  const homeScorer = topScorerOf(home);
  const awayScorer = topScorerOf(away);
  const homeCaptain = captainOf(home);
  const awayCaptain = captainOf(away);

  return (
    <Card darkMode={darkMode} className="mt-3">
      <div className="grid lg:grid-cols-2 gap-4">
        {/* Lewa kolumna - gospodarze */}
        <div className="space-y-3">
          <div className="font-extrabold text-lg flex items-center justify-between">
            <span>{displayTeamName(home)}</span>
            <span className={darkMode ? "text-gray-400" : "text-gray-600"}>
              Miejsce: {posOf(home)}
            </span>
          </div>

          {/* Forma */}
          <div>
            <div className="text-sm font-bold mb-1">Forma (ostatnie 5):</div>
            <div className="flex gap-1">
              {formOf(home).map((f, i) => (
                <FormDot
                  key={i}
                  v={f.result}
                  title={`${f.score} ${displayTeamName(f.opponent)}`}
                />
              ))}
            </div>
          </div>

          {/* Najlepszy strzelec */}
          {homeScorer && (
            <div>
              <div className="text-sm font-bold mb-1">Najlepszy strzelec:</div>
              <button
                onClick={() => openPlayer(homeScorer.id)}
                className="text-sm hover:underline"
              >
                {homeScorer.name} ({homeScorer.goals || 0} goli)
              </button>
            </div>
          )}

          {/* Kapitan */}
          {homeCaptain && (
            <div>
              <div className="text-sm font-bold mb-1">Kapitan:</div>
              <button
                onClick={() => openPlayer(homeCaptain.id)}
                className="text-sm hover:underline"
              >
                {homeCaptain.name}
              </button>
            </div>
          )}
        </div>

        {/* Prawa kolumna - goście */}
        <div className="space-y-3">
          <div className="font-extrabold text-lg flex items-center justify-between">
            <span>{displayTeamName(away)}</span>
            <span className={darkMode ? "text-gray-400" : "text-gray-600"}>
              Miejsce: {posOf(away)}
            </span>
          </div>

          {/* Forma */}
          <div>
            <div className="text-sm font-bold mb-1">Forma (ostatnie 5):</div>
            <div className="flex gap-1">
              {formOf(away).map((f, i) => (
                <FormDot
                  key={i}
                  v={f.result}
                  title={`${f.score} ${displayTeamName(f.opponent)}`}
                />
              ))}
            </div>
          </div>

          {/* Najlepszy strzelec */}
          {awayScorer && (
            <div>
              <div className="text-sm font-bold mb-1">Najlepszy strzelec:</div>
              <button
                onClick={() => openPlayer(awayScorer.id)}
                className="text-sm hover:underline"
              >
                {awayScorer.name} ({awayScorer.goals || 0} goli)
              </button>
            </div>
          )}

          {/* Kapitan */}
          {awayCaptain && (
            <div>
              <div className="text-sm font-bold mb-1">Kapitan:</div>
              <button
                onClick={() => openPlayer(awayCaptain.id)}
                className="text-sm hover:underline"
              >
                {awayCaptain.name}
              </button>
            </div>
          )}
        </div>
      </div>

      {/* H2H */}
      {h2hLast5.length > 0 && (
        <div
          className="mt-4 pt-4 border-t"
          style={{
            borderColor: darkMode ? "rgba(255,255,255,0.1)" : "rgba(0,0,0,0.1)",
          }}
        >
          <div className="font-bold mb-2">Ostatnie bezpośrednie pojedynki:</div>
          <div className="space-y-1">
            {h2hLast5.map((m) => (
              <div
                key={m.id}
                className={classNames(
                  "px-2 py-1 rounded text-sm flex items-center justify-between",
                  darkMode ? "bg-white/5" : "bg-black/5"
                )}
              >
                <span>{displayTeamName(m.home)}</span>
                <span className="font-bold">
                  {m.homeGoals}:{m.awayGoals}
                </span>
                <span>{displayTeamName(m.away)}</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </Card>
  );
}

function UpcomingMatchDetails({
  darkMode,
  fixture,
  inline = false,
  stats,
  matches,
  playersByTeam,
  onBack,
  openTeam,
  openPlayer,
}) {
  const leagueName =
    ({ "1st": "I Liga", "2nd": "II Liga", "3rd": "III Liga" }[fixture.league] || fixture.league);

  const home = fixture.home;
  const away = fixture.away;

  const homeRow = stats?.teamStats?.[home];
  const awayRow = stats?.teamStats?.[away];

  const table = stats?.tableByLeague?.[fixture.league] || [];

  const posOf = (team) => table.find((r) => r.team === team)?.pos || "—";

  const formOf = (team) => (stats?.teamStats?.[team]?.form5 || []).slice(0, 5);

  const topScorerOf = (team) => {
    const arr = Object.values(stats?.playerStats || {}).filter(
      (p) => p.team === team
    );
    if (!arr.length) return null;
    arr.sort(
      (a, b) =>
        (b.goals || 0) - (a.goals || 0) ||
        (b.assists || 0) - (a.assists || 0) ||
        a.name.localeCompare(b.name)
    );
    return arr[0];
  };

  const captainOf = (team) => {
    const arr = playersByTeam?.[team] || [];
    if (!arr.length) return null;
    const rng = mulberry32(hashString("captain|" + team));
    const idx = Math.floor(rng() * arr.length);
    return arr[idx];
  };

  const last5MatchesOf = (team) =>
    getTeamRecentMatches(team, matches || []).slice(0, 5);

  const h2hLast5 = (() => {
    const list = (matches || []).filter(
      (m) =>
        (m.home === home && m.away === away) ||
        (m.home === away && m.away === home)
    );
    list.sort((a, b) => b.round - a.round);
    return list.slice(0, 5);
  })();

  const renderLast5 = (team) => {
    const list = last5MatchesOf(team);
    if (!list.length) {
      return (
        <div className={darkMode ? "text-gray-400" : "text-gray-600"}>
          Brak rozegranych meczów.
        </div>
      );
    }
    return (
      <div className="space-y-2">
        {list.map((m) => {
          const isHome = m.home === team;
          const opp = isHome ? m.away : m.home;
          const score = `${m.homeGoals}:${m.awayGoals}`;
          const res =
            (isHome && m.homeGoals > m.awayGoals) ||
            (!isHome && m.awayGoals > m.homeGoals)
              ? "W"
              : m.homeGoals === m.awayGoals
              ? "R"
              : "P";
          return (
            <div
              key={m.id}
              className={classNames(
                "p-2 rounded-xl border flex items-center justify-between gap-3",
                darkMode
                  ? "border-white/10 bg-black/10"
                  : "border-gray-200 bg-gray-50"
              )}
            >
              <div className="flex items-center gap-2 min-w-0">
                <FormDot v={res} title={`${score} ${displayTeamName(opp)}`} />
                <button
                  onClick={() => openTeam(opp)}
                  className="font-bold underline truncate"
                  title={displayTeamName(opp)}
                >
                  {displayTeamName(opp)}
                </button>
              </div>
              <div
                className={classNames(
                  "px-3 py-1 rounded-xl border text-xs font-bold e3d-pill",
                  darkMode
                    ? "bg-white/5 border-white/10"
                    : "bg-black/5 border-black/10"
                )}
              >
                {score}
              </div>
            </div>
          );
        })}
      </div>
    );
  };

  const renderTeamBox = (team) => {
    const top = topScorerOf(team);
    const cap = captainOf(team);

    return (
      <Card darkMode={darkMode} className="p-4">
        <div className="flex items-center justify-between gap-3">
          <div className="flex items-center gap-3 min-w-0">
            <TeamLogo
              team={team}
              darkMode={darkMode}
              size={56}
              onClick={() => openTeam(team)}
            />
            <div className="min-w-0">
              <div className="text-lg font-extrabold truncate">
                <TeamLink
                  team={displayTeamName(team)}
                  onClick={() => openTeam(team)}
                  className="e3d-link"
                />
              </div>
              <div
                className={classNames(
                  "text-xs",
                  darkMode ? "text-gray-400" : "text-gray-600"
                )}
              >
                Miejsce w tabeli: <b>{posOf(team)}</b>
              </div>
            </div>
          </div>

          <div className="flex gap-2">
            {formOf(team).map((v, i) => (
              <FormDot key={i} v={v} />
            ))}
          </div>
        </div>

        <div className="mt-3 grid gap-2">
          <div
            className={classNames(
              "p-3 rounded-xl border",
              darkMode
                ? "border-white/10 bg-white/5"
                : "border-black/10 bg-black/5"
            )}
          >
            <div className="text-xs font-bold opacity-70">
              Najlepszy strzelec
            </div>
            <div className="font-extrabold">
              {top ? (
                <span>
                  <button
                    onClick={() => openPlayer?.(top.playerId)}
                    className="font-extrabold hover:underline"
                    title="Profil zawodnika"
                  >
                    {top.name}
                  </button>
                  <span className="opacity-80"> ({top.goals} goli)</span>
                </span>
              ) : (
                "Brak danych"
              )}
            </div>
          </div>

          <div
            className={classNames(
              "p-3 rounded-xl border",
              darkMode
                ? "border-white/10 bg-white/5"
                : "border-black/10 bg-black/5"
            )}
          >
            <div className="text-xs font-bold opacity-70">Kapitan</div>
            <div className="font-extrabold">
              {cap ? (
                <span>
                  <button
                    onClick={() => openPlayer?.(cap.id)}
                    className="font-extrabold hover:underline"
                    title="Profil zawodnika"
                  >
                    {cap.name}
                  </button>
                  <span className="opacity-80"> (#{cap.number})</span>
                </span>
              ) : (
                "Brak danych"
              )}
            </div>
          </div>
        </div>

        <div className="mt-4">
          <div className="font-extrabold mb-2">Ostatnie 5 spotkań</div>
          {renderLast5(team)}
        </div>
      </Card>
    );
  };

  return (
    <div className="space-y-4">
      {onBack && (
        <BackHeader
          darkMode={darkMode}
          title="Szczegóły meczu (przedmeczówe)"
          onBack={onBack}
        />
      )}

      <Card darkMode={darkMode}>
        <div className="flex items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <TeamLogo
              team={home}
              darkMode={darkMode}
              size={56}
              onClick={() => openTeam(home)}
            />
            <div className="font-extrabold text-lg">
              <TeamLink
                team={displayTeamName(home)}
                onClick={() => openTeam(home)}
                className="e3d-link"
              />
            </div>
          </div>

          <div
            className={classNames(
              "px-5 py-2 rounded-2xl border font-black text-sm e3d-pill",
              darkMode
                ? "bg-white/5 border-white/10"
                : "bg-black/5 border-black/10"
            )}
          >
            {fixture.date} {fixture.time}
          </div>

          <div className="flex items-center gap-3">
            <div className="font-extrabold text-lg text-right">
              <TeamLink
                team={displayTeamName(away)}
                onClick={() => openTeam(away)}
                className="e3d-link"
              />
            </div>
            <TeamLogo
              team={away}
              darkMode={darkMode}
              size={56}
              onClick={() => openTeam(away)}
            />
          </div>
        </div>

        <div
          className={classNames(
            "mt-2 flex flex-wrap gap-2 text-xs items-center",
            darkMode ? "text-gray-400" : "text-gray-600"
          )}
        >
          <span className="font-semibold">{leagueName}</span>
          <span>•</span>
          <span className="font-semibold">Kolejka {fixture.round}</span>
          <MediaIcons
            darkMode={darkMode}
            videoUrl={fixture.videoUrl}
            galleryUrl={fixture.galleryUrl}
            className="ml-2"
          />
        </div>
      </Card>

      <div className="grid lg:grid-cols-2 gap-3">
        {renderTeamBox(home)}
        {renderTeamBox(away)}
      </div>

      <Card darkMode={darkMode}>
        <div className="font-extrabold mb-2">
          Bezpośrednie pojedynki (ostatnie 5)
        </div>
        {h2hLast5.length === 0 ? (
          <div className={darkMode ? "text-gray-400" : "text-gray-600"}>
            Brak bezpośrednich meczów w bazie.
          </div>
        ) : (
          <div className="space-y-2">
            {h2hLast5.map((m) => (
              <div
                key={m.id}
                className={classNames(
                  "p-2 rounded-xl border flex items-center justify-between gap-3",
                  darkMode
                    ? "border-white/10 bg-black/10"
                    : "border-gray-200 bg-gray-50"
                )}
              >
                <div className="flex items-center gap-2 min-w-0">
                  <button
                    onClick={() => openTeam(m.home)}
                    className="font-bold underline truncate"
                    title={displayTeamName(m.home)}
                  >
                    {displayTeamName(m.home)}
                  </button>
                  <span
                    className={darkMode ? "text-gray-400" : "text-gray-600"}
                  >
                    vs
                  </span>
                  <button
                    onClick={() => openTeam(m.away)}
                    className="font-bold underline truncate"
                    title={displayTeamName(m.away)}
                  >
                    {displayTeamName(m.away)}
                  </button>
                </div>
                <div
                  className={classNames(
                    "px-3 py-1 rounded-xl border text-xs font-bold e3d-pill",
                    darkMode
                      ? "bg-white/5 border-white/10"
                      : "bg-black/5 border-black/10"
                  )}
                >
                  {m.homeGoals}:{m.awayGoals}
                </div>
              </div>
            ))}
          </div>
        )}
      </Card>
    </div>
  );
}

const CSS = `
/* 3D base */
.e3d-card{
  box-shadow:
    0 10px 26px rgba(0,0,0,.35),
    inset 0 1px 0 rgba(255,255,255,.10);
  transform: translateZ(0);
}
.e3d-btn{
  box-shadow:
    0 10px 22px rgba(0,0,0,.28),
    inset 0 1px 0 rgba(255,255,255,.12);
}
.e3d-tab{
  box-shadow:
    0 6px 14px rgba(0,0,0,.22),
    inset 0 1px 0 rgba(255,255,255,.10);
}
.e3d-item{
  box-shadow:
    0 8px 16px rgba(0,0,0,.18),
    inset 0 1px 0 rgba(255,255,255,.08);
}
.e3d-pill{
  box-shadow:
    0 10px 18px rgba(0,0,0,.22),
    inset 0 1px 0 rgba(255,255,255,.14);
}
.e3d-logo{
  filter:
    drop-shadow(0 10px 10px rgba(0,0,0,.40))
    drop-shadow(0 2px 0 rgba(255,255,255,.10));
}
.e3d-ico{
  filter:
    drop-shadow(0 6px 6px rgba(0,0,0,.45))
    drop-shadow(0 1px 0 rgba(255,255,255,.10));
}
.e3d-dot{
  box-shadow:
    0 10px 18px rgba(0,0,0,.30),
    inset 0 2px 0 rgba(255,255,255,.35),
    inset 0 -3px 6px rgba(0,0,0,.25);
}
.e3d-bar{
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,.35),
    0 6px 12px rgba(0,0,0,.25);
}
.e3d-link{
  text-shadow: 0 2px 12px rgba(0,0,0,.35);
}

/* poprawki czytelności dla jasnego */
@media (prefers-color-scheme: light){
  .e3d-card, .e3d-btn, .e3d-tab, .e3d-item, .e3d-pill{
    box-shadow:
      0 12px 26px rgba(0,0,0,.12),
      inset 0 1px 0 rgba(255,255,255,.55);
  }
  .e3d-logo, .e3d-ico{
    filter:
      drop-shadow(0 10px 12px rgba(0,0,0,.20))
      drop-shadow(0 1px 0 rgba(255,255,255,.40));
  }
}

/* Mobile optimizations */
@media (max-width: 768px) {
  /* Mniejsze shadows na mobile */
  .e3d-card, .e3d-btn, .e3d-tab, .e3d-item, .e3d-pill {
    box-shadow:
      0 4px 12px rgba(0,0,0,.20),
      inset 0 1px 0 rgba(255,255,255,.08);
  }
  
  /* Touch-friendly - większe obszary klikalne */
  button, a {
    min-height: 44px;
    min-width: 44px;
  }
  
  /* Zmniejsz padding w kartach */
  .e3d-card {
    padding: 12px !important;
  }
}
`;
