import React, { useEffect, useMemo, useState } from "react";
import {
  AlertTriangle,
  Ban,
  Bell,
  Calendar,
  CheckCircle2,
  Clock,
  Crown,
  Eye,
  FileText,
  Lock,
  Medal,
  Minus,
  Plus,
  Save,
  ShieldAlert,
  Trash2,
  Trophy,
  User,
  UserCheck,
  Users,
} from "lucide-react";
import { useAuth } from "../contexts/AuthContext";
import {
  deleteTyperPick,
  fetchLiveLeaderboard,
  fetchMyTyperPicks,
  fetchTyperProfiles,
  fetchWorldCupMatches,
  profileToPlayer,
  updateTyperProfileModeration,
  uploadTyperAvatar,
  upsertTyperPick,
  upsertTyperProfile,
} from "../services/typerService";
import wc2026RawMatches from "../data/wc2026Matches.json";
import teamNameAliases from "../data/teamNameAliases.json";

const STORAGE_KEY = "mlpn:world-cup-typer-prototype:v2";
const TYPER_PROFILE_STORAGE_KEY = "mlpn:typer-profile:v1";
const PUBLIC_URL = process.env.PUBLIC_URL || "";
const DAY_MS = 24 * 60 * 60 * 1000;
const PICK_WINDOW_DAYS = 3;
const PICK_WINDOW_MS = PICK_WINDOW_DAYS * DAY_MS;
const LOCK_BEFORE_KICKOFF_MS = 5 * 60 * 1000;
const MATCH_COMPLETE_AFTER_KICKOFF_MS = 2 * 60 * 60 * 1000;
const RANKING_PAGE_SIZE = 20;

// Tabela "na żywo" — czytana wprost z ESPN w przeglądarce (ESPN udostępnia CORS),
// dzięki czemu wynik aktualizuje się na bieżąco, niezależnie od cyklu syncu bazy.
const ESPN_LIVE_URL = "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.world/scoreboard";
const ESPN_LIVE_DATES = "20260611-20260720";
const LIVE_POLL_MS = 45000;
const LIVE_WINDOW_BEFORE_MS = 10 * 60 * 1000;
const LIVE_WINDOW_AFTER_MS = 3 * 60 * 60 * 1000;

const STAGE_LABELS = {
  group: "Faza grupowa",
  "1/16 finału": "1/16 finału",
  "1/8 finału": "1/8 finału",
  "ćwierćfinał": "Ćwierćfinał",
  "półfinał": "Półfinał",
  "mecz o 3. miejsce": "Mecz o 3. miejsce",
  "finał": "Finał",
};

function formatKickoff(isoValue) {
  if (!isoValue) return "Termin do ustalenia";
  const date = new Date(isoValue);
  if (Number.isNaN(date.getTime())) return "Termin do ustalenia";

  return new Intl.DateTimeFormat("pl-PL", {
    day: "numeric",
    month: "long",
    hour: "2-digit",
    minute: "2-digit",
    timeZone: "Europe/Warsaw",
  }).format(date);
}

function getKickoffMs(match) {
  const value = Date.parse(match?.kickoffAt || "");
  return Number.isFinite(value) ? value : null;
}

function hasKnownTeams(match) {
  return !!match && !team(match.home).isTbd && !team(match.away).isTbd;
}

function isMatchLockedForPicking(match, nowMs) {
  const kickoffMs = getKickoffMs(match);
  if (kickoffMs === null) return true;
  return kickoffMs <= nowMs + LOCK_BEFORE_KICKOFF_MS;
}

function isMatchInPickWindow(match, nowMs) {
  const kickoffMs = getKickoffMs(match);
  if (kickoffMs === null || !hasKnownTeams(match)) return false;
  if (match.status !== "open") return false;
  return kickoffMs > nowMs + LOCK_BEFORE_KICKOFF_MS && kickoffMs <= nowMs + PICK_WINDOW_MS;
}

function normalizeWorldCupTeam(rawTeam = {}) {
  const id = rawTeam.id || `team-${rawTeam.name || "tbd"}`;
  const name = rawTeam.name === "TBD" ? "Do ustalenia" : rawTeam.name || "Do ustalenia";
  return {
    id,
    name,
    crest: rawTeam.crest || "",
    isTbd: !rawTeam.id || rawTeam.name === "TBD",
  };
}

function normalizeWorldCupMatch(rawMatch = {}) {
  const homeTeam = normalizeWorldCupTeam(rawMatch.homeTeam);
  const awayTeam = normalizeWorldCupTeam(rawMatch.awayTeam);
  const finished = rawMatch.status === "FINISHED";
  const result =
    finished &&
    rawMatch.homeScore !== null && rawMatch.homeScore !== undefined &&
    rawMatch.awayScore !== null && rawMatch.awayScore !== undefined
      ? { home: Number(rawMatch.homeScore), away: Number(rawMatch.awayScore) }
      : null;

  return {
    id: rawMatch.id,
    stage: STAGE_LABELS[rawMatch.stage] || rawMatch.stage || "Mecz",
    rawStage: rawMatch.stage || "",
    group: rawMatch.group || null,
    matchday: rawMatch.matchday || null,
    kickoffAt: rawMatch.kickoffAt || null,
    kickoffLabel: formatKickoff(rawMatch.kickoffAt),
    home: homeTeam.id,
    away: awayTeam.id,
    homeTeam,
    awayTeam,
    status: finished ? "finished" : "open",
    result,
    knockout: rawMatch.stage && rawMatch.stage !== "group",
    duration: rawMatch.duration || "REGULAR",
    winner: rawMatch.winner || null,
  };
}

function normalizeWorldCupMatches(rawMatches) {
  return (Array.isArray(rawMatches) ? rawMatches : [])
    .map(normalizeWorldCupMatch)
    .sort((a, b) => new Date(a.kickoffAt || 0) - new Date(b.kickoffAt || 0));
}

function buildTeamById(matches) {
  return (matches || []).reduce((map, match) => {
    [match.homeTeam, match.awayTeam].forEach((entry) => {
      if (!entry?.id || map[entry.id]) return;
      map[entry.id] = entry;
    });
    return map;
  }, {});
}

const STATIC_MATCHES = normalizeWorldCupMatches(wc2026RawMatches);
let CURRENT_TEAM_BY_ID = buildTeamById(STATIC_MATCHES);

// Prawdziwa reprezentacja ma flagę (crest). Zaślepki fazy pucharowej
// ("Group A Winner", "Round of 32 1 Winner", "Semifinal 1 Loser" itp.) nie mają
// herbu — odsiewamy je z wyboru mistrza i z listy flag w avatarze.
function isRealNationalTeam(entry) {
  return !!entry && !entry.isTbd && !!entry.crest;
}

const STATIC_CHAMPION_TEAMS = Object.values(CURRENT_TEAM_BY_ID)
  .filter(isRealNationalTeam)
  .sort((a, b) => a.name.localeCompare(b.name, "pl"));

const DEFAULT_CHAMPION_ID = CURRENT_TEAM_BY_ID.t764 ? "t764" : STATIC_CHAMPION_TEAMS[0]?.id || "";

const TYPER_SPONSORS = [
  {
    id: "hamag",
    name: "Hamag Fotowoltaika",
    role: "Partner strefy typera",
    logoUrl: `${PUBLIC_URL}/loading-sponsors/190-hamag-fotowoltaika.webp`,
    scale: 1.08,
    featured: true,
  },
  {
    id: "miasto",
    name: "Miasto Sulejówek",
    role: "Partner ligi",
    logoUrl: `${PUBLIC_URL}/loading-sponsors/200-miasto-sulejowek.webp`,
    scale: 1.02,
  },
  {
    id: "superliga6",
    name: "SuperLiga6",
    role: "Partner rozgrywek",
    logoUrl: `${PUBLIC_URL}/loading-sponsors/230-superliga6.webp`,
    scale: 1.03,
  },
  {
    id: "igmat",
    name: "IGMAT Sport",
    role: "Partner sportowy",
    logoUrl: `${PUBLIC_URL}/loading-sponsors/210-igmat-sport.webp`,
    scale: 1.04,
  },
  {
    id: "isola",
    name: "Isola Ristorante",
    role: "Partner kibiców",
    logoUrl: `${PUBLIC_URL}/loading-sponsors/000-isola-ristorante.webp`,
    scale: 1.02,
  },
  {
    id: "roboexpert",
    name: "RoboExpert",
    role: "Sponsor ligi",
    logoUrl: `${PUBLIC_URL}/loading-sponsors/180-roboexpert.webp`,
    scale: 1.06,
  },
  {
    id: "sidap",
    name: "Sidap Energy",
    role: "Sponsor ligi",
    logoUrl: `${PUBLIC_URL}/loading-sponsors/160-sidap-energy.webp`,
    scale: 1.03,
  },
  {
    id: "pobudka",
    name: "Pobudka Catering",
    role: "Partner dnia meczowego",
    logoUrl: `${PUBLIC_URL}/loading-sponsors/120-pobudka-catering.webp`,
    scale: 1.02,
  },
];

const FOOTBALL_AVATAR_OPTIONS = [
  { id: "playmaker-01", label: "Piłkarz 1", bg: "#2563eb", skin: "#f2bd86", hair: "#3f2418", hairStyle: "quiff", beard: "full", jersey: "#1d4ed8", accent: "#f8fafc", pattern: "solid" },
  { id: "striker-02", label: "Piłkarz 2", bg: "#16a34a", skin: "#e9ad72", hair: "#101827", hairStyle: "short", jersey: "#facc15", accent: "#16a34a", pattern: "vertical" },
  { id: "captain-03", label: "Piłkarz 3", bg: "#dc2626", skin: "#c8895e", hair: "#3b2315", hairStyle: "buzz", beard: "stubble", jersey: "#b91c1c", accent: "#f8fafc", pattern: "sash" },
  { id: "winger-04", label: "Piłkarz 4", bg: "#0ea5e9", skin: "#f0b983", hair: "#171717", hairStyle: "long", jersey: "#38bdf8", accent: "#f8fafc", pattern: "solid" },
  { id: "midfielder-05", label: "Piłkarz 5", bg: "#1d4ed8", skin: "#7a4a31", hair: "#f5f5f4", hairStyle: "crop", jersey: "#1e3a8a", accent: "#f8fafc", pattern: "split" },
  { id: "sweeper-06", label: "Piłkarz 6", bg: "#64748b", skin: "#e8aa73", hair: "#111827", hairStyle: "spike", beard: "goatee", jersey: "#f8fafc", accent: "#dc2626", pattern: "horizontal" },
  { id: "fullback-07", label: "Piłkarz 7", bg: "#ef4444", skin: "#f4c08d", hair: "#d6a950", hairStyle: "curtain", jersey: "#dc2626", accent: "#f8fafc", pattern: "checker" },
  { id: "keeper-08", label: "Piłkarz 8", bg: "#111827", skin: "#dc9b68", hair: "#4b2e1f", hairStyle: "recede", jersey: "#0f172a", accent: "#94a3b8", pattern: "keeper" },
  { id: "forward-09", label: "Piłkarz 9", bg: "#38bdf8", skin: "#f0b07a", hair: "#4a2515", hairStyle: "side", jersey: "#7dd3fc", accent: "#f8fafc", pattern: "vertical" },
  { id: "box-to-box-10", label: "Piłkarz 10", bg: "#f97316", skin: "#8b573b", hair: "#171717", hairStyle: "mohawk", jersey: "#f97316", accent: "#111827", pattern: "sash" },
  { id: "targetman-11", label: "Piłkarz 11", bg: "#0f766e", skin: "#f1c08c", hair: "#5b351f", hairStyle: "messy", beard: "mustache", jersey: "#065f46", accent: "#facc15", pattern: "hoops" },
  { id: "regista-12", label: "Piłkarz 12", bg: "#7c3aed", skin: "#df9c66", hair: "#20110b", hairStyle: "waves", jersey: "#7c3aed", accent: "#f8fafc", pattern: "diagonal" },
  { id: "libero-13", label: "Piłkarz 13", bg: "#0f172a", skin: "#c08156", hair: "#111827", hairStyle: "bald", beard: "full", jersey: "#111827", accent: "#22c55e", pattern: "split" },
  { id: "pacey-14", label: "Piłkarz 14", bg: "#059669", skin: "#f3c39a", hair: "#c47a3b", hairStyle: "topknot", jersey: "#16a34a", accent: "#f8fafc", pattern: "solid" },
  { id: "pressing-15", label: "Piłkarz 15", bg: "#b91c1c", skin: "#9a6243", hair: "#1f2937", hairStyle: "locks", jersey: "#991b1b", accent: "#f8fafc", pattern: "checker" },
  { id: "artist-16", label: "Piłkarz 16", bg: "#0284c7", skin: "#efb47c", hair: "#111827", hairStyle: "headband", jersey: "#f8fafc", accent: "#2563eb", pattern: "hoops" },
  { id: "stopper-17", label: "Piłkarz 17", bg: "#ea580c", skin: "#d1905d", hair: "#342115", hairStyle: "short", beard: "stubble", jersey: "#ea580c", accent: "#f8fafc", pattern: "lightning" },
  { id: "youth-18", label: "Piłkarz 18", bg: "#22c55e", skin: "#f4c99b", hair: "#2f1f16", hairStyle: "fringe", jersey: "#bbf7d0", accent: "#15803d", pattern: "vertical" },
  { id: "veteran-19", label: "Piłkarz 19", bg: "#334155", skin: "#bb7b4f", hair: "#d6d3d1", hairStyle: "recede", beard: "goatee", jersey: "#475569", accent: "#f8fafc", pattern: "solid" },
  { id: "captain-20", label: "Piłkarz 20", bg: "#1d4ed8", skin: "#f0b783", hair: "#161616", hairStyle: "quiff", beard: "mustache", jersey: "#1d4ed8", accent: "#facc15", pattern: "armband" },
];

const FOOTBALL_BADGE_AVATAR_OPTIONS = [
  { id: "badge-lions", label: "Herb Lions FC", bg: "#0f172a", primary: "#2563eb", secondary: "#f8fafc", accent: "#facc15", shape: "shield", pattern: "stripes", mark: "crown", text: "FC" },
  { id: "badge-reds", label: "Herb Reds", bg: "#111827", primary: "#dc2626", secondary: "#ffffff", accent: "#111827", shape: "circle", pattern: "hoops", mark: "ball", text: "11" },
  { id: "badge-green", label: "Herb Green Town", bg: "#052e16", primary: "#16a34a", secondary: "#f8fafc", accent: "#fde047", shape: "shield", pattern: "diagonal", mark: "star", text: "GT" },
  { id: "badge-sky", label: "Herb Sky United", bg: "#082f49", primary: "#38bdf8", secondary: "#f8fafc", accent: "#ef4444", shape: "crest", pattern: "split", mark: "ball", text: "SU" },
  { id: "badge-black", label: "Herb Black Stars", bg: "#020617", primary: "#111827", secondary: "#e5e7eb", accent: "#facc15", shape: "circle", pattern: "quarters", mark: "star", text: "BS" },
  { id: "badge-gold", label: "Herb Gold FC", bg: "#451a03", primary: "#f59e0b", secondary: "#111827", accent: "#ffffff", shape: "shield", pattern: "solid", mark: "crown", text: "GF" },
  { id: "badge-river", label: "Herb River Club", bg: "#0f172a", primary: "#0ea5e9", secondary: "#ffffff", accent: "#22c55e", shape: "crest", pattern: "wave", mark: "ball", text: "RC" },
  { id: "badge-violet", label: "Herb Violet 90", bg: "#2e1065", primary: "#7c3aed", secondary: "#f8fafc", accent: "#f97316", shape: "circle", pattern: "diagonal", mark: "star", text: "90" },
  { id: "badge-north", label: "Herb North End", bg: "#172554", primary: "#1d4ed8", secondary: "#f8fafc", accent: "#22d3ee", shape: "shield", pattern: "split", mark: "ball", text: "NE" },
  { id: "badge-orange", label: "Herb Orange City", bg: "#431407", primary: "#f97316", secondary: "#ffffff", accent: "#111827", shape: "crest", pattern: "stripes", mark: "crown", text: "OC" },
  { id: "badge-royal", label: "Herb Royal Club", bg: "#1e1b4b", primary: "#4338ca", secondary: "#f8fafc", accent: "#facc15", shape: "shield", pattern: "quarters", mark: "crown", text: "RC" },
  { id: "badge-mlpn", label: "Herb MLPN", bg: "#0f172a", primary: "#ef4444", secondary: "#38bdf8", accent: "#ffffff", shape: "circle", pattern: "split", mark: "ball", text: "ML" },
];

function emptyGroupRow(teamId) {
  return { team: teamId, played: 0, pts: 0, gf: 0, ga: 0, gd: 0 };
}

function addGroupResult(row, goalsFor, goalsAgainst) {
  row.played += 1;
  row.gf += goalsFor;
  row.ga += goalsAgainst;
  row.gd = row.gf - row.ga;

  if (goalsFor > goalsAgainst) row.pts += 3;
  else if (goalsFor === goalsAgainst) row.pts += 1;
}

function buildGroupTables(matches) {
  const groups = {};

  (matches || []).forEach((match) => {
    if (!match.group || match.rawStage !== "group" || !hasKnownTeams(match)) return;

    const rows = groups[match.group] || {};
    [match.home, match.away].forEach((teamId) => {
      if (!rows[teamId]) rows[teamId] = emptyGroupRow(teamId);
    });

    if (match.result) {
      addGroupResult(rows[match.home], match.result.home, match.result.away);
      addGroupResult(rows[match.away], match.result.away, match.result.home);
    }

    groups[match.group] = rows;
  });

  return Object.fromEntries(
    Object.entries(groups).map(([group, rows]) => [
      group,
      Object.values(rows).sort(
        (a, b) =>
          b.pts - a.pts ||
          b.gd - a.gd ||
          b.gf - a.gf ||
          team(a.team).name.localeCompare(team(b.team).name, "pl")
      ),
    ])
  );
}

function getScheduleSegmentMeta(match) {
  if (match.rawStage === "group") {
    const matchday = match.matchday || 1;
    return {
      id: `group-${matchday}`,
      label: `${matchday}. kolejka`,
      eyebrow: "Faza grupowa",
      sort: matchday,
    };
  }

  const rawStage = match.rawStage || match.stage || "knockout";
  const knockoutOrder = {
    "1/16 finału": 10,
    "1/8 finału": 11,
    "ćwierćfinał": 12,
    "półfinał": 13,
    "mecz o 3. miejsce": 14,
    "finał": 15,
  };

  return {
    id: `stage-${rawStage}`,
    label: match.stage || "Faza pucharowa",
    eyebrow: "Faza pucharowa",
    sort: knockoutOrder[rawStage] || 99,
  };
}

function buildScheduleSegments(matches) {
  const segments = new Map();

  (matches || []).filter(hasKnownTeams).forEach((match) => {
    const meta = getScheduleSegmentMeta(match);
    const current = segments.get(meta.id) || { ...meta, matches: [], firstKickoffMs: Number.POSITIVE_INFINITY };
    const kickoffMs = getKickoffMs(match) ?? Number.POSITIVE_INFINITY;

    current.matches.push(match);
    current.firstKickoffMs = Math.min(current.firstKickoffMs, kickoffMs);
    segments.set(meta.id, current);
  });

  return [...segments.values()]
    .map((segment) => ({
      ...segment,
      matches: segment.matches.slice().sort((a, b) => (getKickoffMs(a) || 0) - (getKickoffMs(b) || 0)),
    }))
    .sort((a, b) => a.sort - b.sort || a.firstKickoffMs - b.firstKickoffMs);
}

function isScheduleMatchComplete(match, nowMs) {
  if (match?.result || match?.status === "finished") return true;

  const kickoffMs = getKickoffMs(match);
  if (kickoffMs === null) return false;

  return kickoffMs + MATCH_COMPLETE_AFTER_KICKOFF_MS < nowMs;
}

function isScheduleSegmentComplete(segment, nowMs) {
  const matches = segment?.matches || [];
  return matches.length > 0 && matches.every((match) => isScheduleMatchComplete(match, nowMs));
}

function getCurrentScheduleSegmentId(segments, nowMs) {
  if (!segments.length) return "";

  const firstUnfinished = segments.find((segment) => !isScheduleSegmentComplete(segment, nowMs));
  return firstUnfinished?.id || segments[segments.length - 1].id;
}

const DEFAULT_PICKS = {};

const INITIAL_PLAYERS = [];

const RULES = [
  {
    title: "Punktacja meczów",
    body: "Dokładny wynik daje 3 punkty. Trafiony rezultat 1/X/2 daje 1 punkt. Nietrafiony rezultat daje 0 punktów.",
  },
  {
    title: "Faza pucharowa",
    body: "Typ dotyczy wyniku po 90 minutach. Dogrywka i karne liczą się tylko do ustalenia awansu oraz mistrza turnieju.",
  },
  {
    title: "Bonus za awans",
    body: "W pucharach można dostać +1 punkt za właściwą drużynę awansującą, ale tylko przy trafionym remisie po 90 minutach.",
  },
  {
    title: "Nick i kultura gry",
    body: "Nick musi być kulturalny. Wulgaryzmy, obrażanie innych, treści dyskryminujące lub podszywanie się pod organizatorów mogą skutkować ostrzeżeniem, blokadą albo banem.",
  },
  {
    title: "Kary porządkowe",
    body: "Pierwsze ostrzeżenie resetuje nick. Drugie może zablokować konto do decyzji admina. Trzecie ostrzeżenie lub rażące naruszenie może oznaczać ban i wykluczenie z rankingu oraz nagrody.",
  },
];

function cx(...classes) {
  return classes.filter(Boolean).join(" ");
}

function team(id) {
  return CURRENT_TEAM_BY_ID[id] || { id, name: id || "Nieznana drużyna", crest: "", isTbd: true };
}

function readStoredPicks() {
  try {
    const raw = window.localStorage?.getItem(STORAGE_KEY);
    return raw ? { ...DEFAULT_PICKS, ...JSON.parse(raw) } : DEFAULT_PICKS;
  } catch {
    return DEFAULT_PICKS;
  }
}

function readStoredTyperProfiles() {
  try {
    const raw = window.localStorage?.getItem(TYPER_PROFILE_STORAGE_KEY);
    return raw ? JSON.parse(raw) : {};
  } catch {
    return {};
  }
}

function countPicks(value) {
  return Object.keys(value || {}).length;
}

function mergeRemotePicksWithLocal(remotePicks, localPicks) {
  const remote = remotePicks || {};
  const local = localPicks || {};
  const missingLocalEntries = Object.entries(local).filter(([matchId]) => !remote[matchId]);

  return {
    picks: missingLocalEntries.length ? { ...local, ...remote } : remote,
    missingLocalEntries,
  };
}

function isAutoBackfilledTyperProfile(profile) {
  return profile?.avatar?.source === "profiles-backfill";
}

function getInitials(value) {
  const fallback = "ML";
  const parts = String(value || "")
    .trim()
    .split(/\s+/)
    .filter(Boolean);

  if (parts.length === 0) return fallback;
  return parts
    .slice(0, 2)
    .map((part) => part[0])
    .join("")
    .toUpperCase();
}

function getProviderIdentityData(user, provider) {
  return user?.identities?.find((identity) => identity?.provider === provider)?.identity_data || {};
}

function getMetadataString(data, keys) {
  for (const key of keys) {
    const value = data?.[key];
    if (typeof value === "string" && value.trim()) return value.trim();
  }
  return "";
}

function getProviderAvatarUrl(user, provider) {
  const data = getProviderIdentityData(user, provider);
  const directUrl = getMetadataString(data, ["avatar_url", "picture"]);
  if (directUrl) return directUrl;

  if (typeof data?.picture?.data?.url === "string") return data.picture.data.url;

  const providerId = getMetadataString(data, ["sub", "id", "user_id"]);
  if (provider === "facebook" && providerId) {
    return `https://graph.facebook.com/${providerId}/picture?type=large`;
  }

  return "";
}

function getProviderDisplayName(user, provider) {
  const data = getProviderIdentityData(user, provider);
  return getMetadataString(data, ["full_name", "name", "display_name"]);
}

function getFirstName(value) {
  return String(value || "")
    .trim()
    .split(/\s+/)
    .filter(Boolean)[0] || "";
}

function getGoogleAvatarUrl(user) {
  return getProviderAvatarUrl(user, "google");
}

function getFacebookAvatarUrl(user) {
  return getProviderAvatarUrl(user, "facebook");
}

function getGoogleDisplayName(user) {
  return getProviderDisplayName(user, "google");
}

function getFacebookDisplayName(user) {
  return getProviderDisplayName(user, "facebook");
}

function matchResultSide(score) {
  if (!score) return null;
  if (score.home > score.away) return "home";
  if (score.home < score.away) return "away";
  return "draw";
}

function getWinnerTeamId(match) {
  const winner = String(match?.winner || "").toUpperCase();
  if (winner === "HOME_TEAM") return match.home;
  if (winner === "AWAY_TEAM") return match.away;
  if (winner && winner !== "DRAW") return match.winner;
  return "";
}

function scorePick(match, pick) {
  if (!match?.result || !pick) return null;
  const resultSide = matchResultSide(match.result);
  const pickSide = matchResultSide(pick);
  const exact = match.result.home === pick.home && match.result.away === pick.away;
  const result = !exact && resultSide === pickSide;
  const advance =
    !!match.knockout &&
    resultSide === "draw" &&
    pickSide === "draw" &&
    !!pick.advance &&
    pick.advance === getWinnerTeamId(match);
  const basePoints = exact ? 3 : result ? 1 : 0;
  const points = basePoints + (advance ? 1 : 0);
  const baseLabel = exact ? "Dokładny wynik" : result ? "Trafiony rezultat" : "Nietrafiony";

  return { points, label: advance ? `${baseLabel} + awans` : baseLabel, exact, result, advance };
}

function summarizeScoredPicks(matches, picks) {
  const items = (matches || [])
    .filter((match) => match.result && picks?.[match.id])
    .map((match) => {
      const pick = picks[match.id];
      const scored = scorePick(match, pick) || { points: 0, label: "Nietrafiony" };
      return { match, pick, scored };
    });

  return items.reduce(
    (summary, item) => {
      summary.items.push(item);
      summary.points += item.scored.points;
      if (item.scored.exact) summary.exact += 1;
      else if (item.scored.result) summary.result += 1;
      else summary.miss += 1;
      if (item.scored.advance) summary.advance += 1;
      return summary;
    },
    { items: [], points: 0, exact: 0, result: 0, advance: 0, miss: 0 }
  );
}

// --- Wyniki na żywo (ESPN) ---------------------------------------------------
// Te same zasady dopasowania co w robocie i w typerze referencyjnym: nazwa
// drużyny znormalizowana (PL->EN) + zbliżony czas gwizdka. Dzięki temu mecze
// grane o tej samej godzinie nie mylą się ze sobą.
const LIVE_KICKOFF_TOLERANCE_MS = 3 * 60 * 60 * 1000;

function normalizeTeamName(value) {
  return String(value || "")
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]/g, "");
}

function teamKeyFromName(name) {
  const raw = String(name || "").trim();
  if (!raw) return "";
  return normalizeTeamName(teamNameAliases[raw] || raw);
}

// Dopasowuje pojedynczy mecz do zdarzenia ESPN. Zwraca { event, swapped } albo null.
function matchEspnEventToMatch(match, espnEvents) {
  const homeKey = teamKeyFromName(team(match.home).name) || teamKeyFromName(match.homeTeam?.name);
  const awayKey = teamKeyFromName(team(match.away).name) || teamKeyFromName(match.awayTeam?.name);
  if (!homeKey || !awayKey) return null;

  const kickoffMs = getKickoffMs(match);
  let best = null;

  for (const event of espnEvents) {
    const sameOrder = event.homeKey === homeKey && event.awayKey === awayKey;
    const swappedOrder = event.homeKey === awayKey && event.awayKey === homeKey;
    if (!sameOrder && !swappedOrder) continue;

    const eventMs = Date.parse(event.kickoffISO || "");
    const distance =
      kickoffMs !== null && Number.isFinite(eventMs) ? Math.abs(kickoffMs - eventMs) : 0;
    if (kickoffMs !== null && Number.isFinite(eventMs) && distance > LIVE_KICKOFF_TOLERANCE_MS) continue;

    if (!best || distance < best.distance) {
      best = { event, swapped: swappedOrder && !sameOrder, distance };
    }
  }

  return best ? { event: best.event, swapped: best.swapped } : null;
}

// Mapuje wszystkie nasze mecze -> wynik na żywo z ESPN (id meczu -> { status,
// home, away, clock }). Bierzemy mecze w toku (state "in") ORAZ świeżo
// zakończone w ESPN (state "post"), żeby wynik końcowy był widoczny od razu,
// zanim robot zapisze go do bazy.
function buildLiveByMatchId(matches, espnEvents) {
  const liveByMatchId = {};

  for (const match of matches || []) {
    const matched = matchEspnEventToMatch(match, espnEvents);
    if (!matched) continue;

    const { event, swapped } = matched;
    if (event.homeScore === null || event.awayScore === null) continue;

    liveByMatchId[match.id] = {
      status: event.state === "post" ? "FINISHED" : "IN_PLAY",
      home: swapped ? event.awayScore : event.homeScore,
      away: swapped ? event.homeScore : event.awayScore,
      clock: event.clock,
    };
  }

  return liveByMatchId;
}

// getLiveResult: wynik do PODGLĄDU i RANKINGU NA ŻYWO. Mecz zakończony w bazie
// ma pierwszeństwo (jego wynik jest już w oficjalnych punktach) -> wtedy null,
// żeby nie liczyć go podwójnie. W przeciwnym razie bierzemy wynik z ESPN.
function getLiveResult(match, liveByMatchId) {
  if (!match) return null;
  if (match.result) return null; // final z bazy wygrywa (już policzony)
  const live = liveByMatchId?.[match.id];
  if (!live || live.home === null || live.away === null) return null;
  return { home: live.home, away: live.away, status: live.status };
}

// Tymczasowe punkty "na żywo" gracza z jego typów na trwających/świeżo
// zakończonych meczach (te jeszcze nieujęte w oficjalnych punktach z bazy).
function liveDeltaForPicks(matches, picks, liveByMatchId) {
  const delta = { points: 0, exact: 0, result: 0, advance: 0, count: 0 };
  if (!picks) return delta;

  for (const match of matches || []) {
    const liveResult = getLiveResult(match, liveByMatchId);
    if (!liveResult) continue;
    const pick = picks[match.id];
    if (!pick || typeof pick.home !== "number" || typeof pick.away !== "number") continue;

    const scored = scorePick({ ...match, result: { home: liveResult.home, away: liveResult.away } }, pick);
    if (!scored) continue;

    delta.points += scored.points;
    if (scored.exact) delta.exact += 1;
    else if (scored.result) delta.result += 1;
    if (scored.advance) delta.advance += 1;
    delta.count += 1;
  }

  return delta;
}

function Card({ darkMode, children, className = "" }) {
  return (
    <section
      className={cx(
        "min-w-0 rounded-2xl border p-4 e3d-card",
        darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white",
        className
      )}
    >
      {children}
    </section>
  );
}

function Pill({ darkMode, children, tone = "neutral", className = "" }) {
  const tones = {
    neutral: darkMode ? "border-white/10 bg-white/5 text-gray-200" : "border-gray-200 bg-gray-50 text-gray-700",
    good: "border-emerald-400/30 bg-emerald-400/15 text-emerald-300",
    warn: "border-amber-400/35 bg-amber-400/15 text-amber-300",
    danger: "border-red-400/35 bg-red-400/15 text-red-300",
    info: "border-sky-400/35 bg-sky-400/15 text-sky-300",
  };

  return (
    <span className={cx("inline-flex max-w-full min-w-0 items-center gap-1.5 rounded-full border px-2.5 py-1 text-xs font-bold", tones[tone], className)}>
      {children}
    </span>
  );
}

function TeamBadge({ id, align = "left", compact = false }) {
  const t = team(id);
  const initials = t.name
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0])
    .join("")
    .toUpperCase();

  return (
    <div className={cx("flex min-w-0 items-center gap-2", align === "right" && "justify-end text-right")}>
      {align === "right" && !compact && <span className="truncate font-extrabold">{t.name}</span>}
      <span className="grid h-10 w-10 shrink-0 place-items-center overflow-hidden rounded-xl border border-white/10 bg-white text-sm font-black text-gray-900 shadow-sm">
        {t.crest ? (
          <img
            src={t.crest}
            alt=""
            className="h-7 w-7 object-contain"
            style={{ filter: "drop-shadow(0 2px 3px rgba(0,0,0,0.38))" }}
            loading="lazy"
            onError={(event) => {
              event.currentTarget.style.display = "none";
            }}
          />
        ) : (
          initials || "?"
        )}
      </span>
      {align !== "right" && !compact && <span className="truncate font-extrabold">{t.name}</span>}
      {compact && <span className="truncate text-sm font-extrabold">{t.name}</span>}
    </div>
  );
}

function CompactTeamCell({ id }) {
  const t = team(id);
  const initials = t.name
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0])
    .join("")
    .toUpperCase();

  return (
    <div className="flex min-w-0 items-center gap-2">
      <span className="grid h-7 w-7 shrink-0 place-items-center overflow-hidden rounded-lg border border-white/10 bg-white text-[10px] font-black text-gray-900 shadow-sm sm:h-8 sm:w-8">
        {t.crest ? (
          <img
            src={t.crest}
            alt=""
            className="h-5 w-5 object-contain sm:h-6 sm:w-6"
            style={{ filter: "drop-shadow(0 2px 3px rgba(0,0,0,0.34))" }}
            loading="lazy"
            onError={(event) => {
              event.currentTarget.style.display = "none";
            }}
          />
        ) : (
          initials || "?"
        )}
      </span>
      <span className="truncate text-xs font-black sm:text-sm">{t.name}</span>
    </div>
  );
}

function MatchScoreLine({ id, score }) {
  const t = team(id);
  const initials = t.name
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0])
    .join("")
    .toUpperCase();

  return (
    <div className="grid min-w-0 grid-cols-[minmax(0,1fr)_auto] items-center gap-3 py-1">
      <div className="flex min-w-0 items-center gap-2">
        <span className="grid h-8 w-8 shrink-0 place-items-center overflow-hidden rounded-lg border border-white/10 bg-white text-xs font-black text-gray-900 shadow-sm">
          {t.crest ? (
            <img
              src={t.crest}
              alt=""
              className="h-6 w-6 object-contain"
              style={{ filter: "drop-shadow(0 2px 3px rgba(0,0,0,0.34))" }}
              loading="lazy"
              onError={(event) => {
                event.currentTarget.style.display = "none";
              }}
            />
          ) : (
            initials || "?"
          )}
        </span>
        <span className="truncate text-sm font-black">{t.name}</span>
      </div>
      <div className="min-w-[28px] text-right text-xl font-black tabular-nums">{score}</div>
    </div>
  );
}

function TyperSponsorsShowcase({ darkMode }) {
  const [mainSponsor, ...supportSponsors] = TYPER_SPONSORS;

  return (
    <section
      className={cx(
        "relative overflow-hidden rounded-3xl border p-4 md:p-5",
        darkMode
          ? "border-emerald-300/15 bg-[linear-gradient(135deg,#071712,#0f1c2c_54%,#2a1710)] text-white"
          : "border-emerald-200 bg-[linear-gradient(135deg,#f8fffb,#eef7ff_55%,#fff5dd)] text-gray-950"
      )}
    >
      <div
        aria-hidden="true"
        className={cx(
          "absolute inset-x-0 bottom-0 h-24",
          darkMode ? "opacity-35" : "opacity-45"
        )}
        style={{
          background:
            "repeating-linear-gradient(90deg, rgba(16,185,129,0.18) 0 34px, rgba(16,185,129,0.08) 34px 68px)",
        }}
      />
      <div
        aria-hidden="true"
        className="absolute left-1/2 top-5 h-24 w-48 -translate-x-1/2 rounded-b-full border-b border-l border-r border-amber-300/25"
      />

      <div className="relative z-10 grid gap-4 xl:grid-cols-[1fr_1.4fr] xl:items-stretch">
        <div>
          <div className="flex flex-wrap items-center gap-2">
            <Pill darkMode={darkMode} tone="good">
              <Trophy size={13} /> Partnerzy Typera
            </Pill>
            <Pill darkMode={darkMode} tone="info">
              <Calendar size={13} /> Mundialowa strefa MLPN
            </Pill>
          </div>
          <h2 className="mt-3 text-2xl font-black leading-tight md:text-3xl">
            Typujemy z partnerami ligi
          </h2>
          <div className={cx("mt-2 max-w-xl text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
            Placeholdery sponsorów można później podmienić na aktywną listę z panelu. Na razie pokazujemy logotypy ligi w oprawie jak przy studiu turniejowym.
          </div>

          <div className={cx("mt-4 rounded-3xl border p-4", darkMode ? "border-amber-300/20 bg-black/20" : "border-amber-200 bg-white/80")}>
            <div className="flex items-center justify-between gap-3">
              <div>
                <div className="text-[11px] font-black uppercase tracking-[0.18em] text-amber-400">
                  {mainSponsor.role}
                </div>
                <div className="mt-1 text-xl font-black">{mainSponsor.name}</div>
              </div>
              <Medal className="shrink-0 text-amber-400" size={28} />
            </div>
            <div className="mlpn-sponsor-logo-frame mt-4 flex h-24 items-center justify-center rounded-2xl p-4">
              <img
                src={mainSponsor.logoUrl}
                alt={mainSponsor.name}
                loading="lazy"
                style={{ "--mlpn-sponsor-logo-scale": mainSponsor.scale }}
                className="mlpn-sponsor-logo-img h-full w-full object-contain"
              />
            </div>
          </div>
        </div>

        <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4 xl:grid-cols-2">
          {supportSponsors.map((sponsor, index) => (
            <div
              key={sponsor.id}
              className={cx(
                "group relative min-h-[132px] overflow-hidden rounded-2xl border p-3 transition-transform hover:-translate-y-0.5",
                darkMode ? "border-white/10 bg-white/[0.06]" : "border-white/80 bg-white/85 shadow-sm"
              )}
            >
              <div
                aria-hidden="true"
                className={cx(
                  "absolute right-3 top-3 grid h-7 w-7 place-items-center rounded-full border text-[11px] font-black",
                  darkMode ? "border-white/10 bg-black/20 text-amber-200" : "border-amber-200 bg-amber-50 text-amber-700"
                )}
              >
                {index + 1}
              </div>
              <div className="pr-9 text-[10px] font-black uppercase tracking-[0.14em] opacity-60">
                {sponsor.role}
              </div>
              <div className="mlpn-sponsor-logo-frame mt-3 flex h-16 items-center justify-center rounded-2xl p-2">
                <img
                  src={sponsor.logoUrl}
                  alt={sponsor.name}
                  loading="lazy"
                  style={{ "--mlpn-sponsor-logo-scale": sponsor.scale }}
                  className="mlpn-sponsor-logo-img h-full w-full object-contain"
                />
              </div>
              <div className="mt-2 truncate text-sm font-black">{sponsor.name}</div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

function TyperSponsorsStrip({ darkMode }) {
  return (
    <section
      className={cx(
        "overflow-hidden rounded-2xl border",
        darkMode ? "border-white/10 bg-[#0d1117] text-white" : "border-gray-200 bg-white text-gray-950"
      )}
    >
      <div className="h-1 bg-[linear-gradient(90deg,#ef4444,#facc15,#22c55e,#38bdf8)]" />
      <div className="grid gap-4 p-3 md:grid-cols-[220px_1fr] md:items-center md:p-4">
        <div className="min-w-0">
          <div className="flex items-center gap-2">
            <Trophy size={17} className="text-amber-400" />
            <div className="text-[11px] font-black uppercase tracking-[0.16em] text-amber-400">
              Partnerzy Typera
            </div>
          </div>
          <div className="mt-1 text-lg font-black leading-tight">MLPN x MŚ 2026</div>
          <div className={cx("mt-1 text-xs leading-relaxed", darkMode ? "text-gray-400" : "text-gray-600")}>
            Logotypy sponsorów ligi w strefie Typera.
          </div>
        </div>

        <div className="grid grid-cols-2 gap-2 sm:grid-cols-4 xl:grid-cols-8">
          {TYPER_SPONSORS.map((sponsor, index) => (
            <div
              key={sponsor.id}
              title={sponsor.name}
              className={cx(
                "group flex min-h-[74px] flex-col items-center justify-center rounded-xl border p-2 transition-transform hover:-translate-y-0.5",
                index === 0
                  ? darkMode
                    ? "border-amber-300/40 bg-amber-300/10"
                    : "border-amber-300 bg-amber-50"
                  : darkMode
                  ? "border-white/10 bg-white/[0.04]"
                  : "border-gray-200 bg-gray-50"
              )}
            >
              <div className="flex h-10 w-full items-center justify-center rounded-lg bg-white p-1.5 shadow-sm">
                <img
                  src={sponsor.logoUrl}
                  alt={sponsor.name}
                  loading="lazy"
                  style={{ "--mlpn-sponsor-logo-scale": sponsor.scale }}
                  className="h-full w-full object-contain"
                />
              </div>
              <div className={cx("mt-1 w-full truncate text-center text-[10px] font-black", darkMode ? "text-gray-300" : "text-gray-700")}>
                {sponsor.name}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

function TyperSponsorsBillboard({ darkMode }) {
  const [activeIndex, setActiveIndex] = useState(0);
  const activeSponsor = TYPER_SPONSORS[activeIndex] || TYPER_SPONSORS[0];

  useEffect(() => {
    const timer = window.setInterval(() => {
      setActiveIndex((current) => (current + 1) % TYPER_SPONSORS.length);
    }, 4300);

    return () => window.clearInterval(timer);
  }, []);

  return (
    <section
      className={cx(
        "relative overflow-hidden rounded-2xl border",
        darkMode
          ? "border-white/10 bg-[#10151f] text-white"
          : "border-gray-200 bg-white text-gray-950"
      )}
    >
      <div className="h-1 bg-[linear-gradient(90deg,#ef4444,#facc15,#22c55e,#38bdf8)]" />
      <div
        aria-hidden="true"
        className={cx(
          "absolute left-6 right-6 top-1 h-px",
          darkMode ? "bg-white/10" : "bg-gray-200"
        )}
      />
      <div
        aria-hidden="true"
        className={cx(
          "absolute left-10 top-1 h-5 w-px",
          darkMode ? "bg-white/15" : "bg-gray-300"
        )}
      />
      <div
        aria-hidden="true"
        className={cx(
          "absolute right-10 top-1 h-5 w-px",
          darkMode ? "bg-white/15" : "bg-gray-300"
        )}
      />

      <div className="grid gap-3 p-3 md:grid-cols-[190px_1fr_150px] md:items-center md:p-4">
        <div className="min-w-0">
          <div className="flex items-center gap-2">
            <Trophy size={17} className="text-amber-400" />
            <div className="text-[11px] font-black uppercase tracking-[0.16em] text-amber-400">
              Partnerzy Typera
            </div>
          </div>
          <div className="mt-1 text-lg font-black leading-tight">Belka reklamowa</div>
          <div className={cx("mt-1 text-xs leading-relaxed", darkMode ? "text-gray-400" : "text-gray-600")}>
            Sponsorzy ligi w rotacji, bez przewijania.
          </div>
        </div>

        <div
          className={cx(
            "relative min-h-[126px] overflow-hidden rounded-2xl border p-3",
            darkMode
              ? "border-white/10 bg-[radial-gradient(circle_at_50%_20%,rgba(56,189,248,0.16),transparent_45%),rgba(255,255,255,0.04)]"
              : "border-gray-200 bg-[radial-gradient(circle_at_50%_20%,rgba(56,189,248,0.14),transparent_45%),#f8fafc]"
          )}
        >
          <div
            aria-hidden="true"
            className="absolute inset-x-6 top-0 h-8 rounded-b-full border-b border-l border-r border-emerald-400/20"
          />
          {TYPER_SPONSORS.map((sponsor, index) => {
            const isActive = index === activeIndex;

            return (
              <div
                key={sponsor.id}
                className={cx(
                  "absolute inset-3 flex items-center justify-center transition-all duration-1000 ease-out",
                  isActive ? "opacity-100 blur-0" : "pointer-events-none opacity-0 blur-sm"
                )}
                aria-hidden={!isActive}
              >
                <div className="flex h-[96px] w-full max-w-[520px] items-center justify-center rounded-2xl border border-white/80 bg-white px-8 py-4 shadow-[0_12px_30px_rgba(15,23,42,0.13)]">
                  <img
                    src={sponsor.logoUrl}
                    alt={sponsor.name}
                    loading="lazy"
                    style={{ transform: `scale(${sponsor.scale || 1})` }}
                    className="max-h-full max-w-full object-contain"
                  />
                </div>
              </div>
            );
          })}
        </div>

        <div className="min-w-0 rounded-2xl border border-white/10 bg-black/5 p-3">
          <div className="text-[10px] font-black uppercase tracking-[0.14em] opacity-60">
            Aktualnie
          </div>
          <div className="mt-1 truncate text-sm font-black">{activeSponsor.name}</div>
          <div className={cx("mt-1 truncate text-xs", darkMode ? "text-gray-400" : "text-gray-600")}>
            {activeSponsor.role}
          </div>
          <div className="mt-3 flex flex-wrap gap-1.5">
            {TYPER_SPONSORS.map((sponsor, index) => (
              <button
                key={sponsor.id}
                type="button"
                onClick={() => setActiveIndex(index)}
                className={cx(
                  "h-2 rounded-full transition-all",
                  index === activeIndex
                    ? "w-7 bg-amber-400"
                    : darkMode
                    ? "w-2 bg-white/25 hover:bg-white/45"
                    : "w-2 bg-gray-300 hover:bg-gray-400"
                )}
                aria-label={`Pokaż sponsora ${sponsor.name}`}
              />
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

function parseEspnInt(value) {
  const number = Number.parseInt(value, 10);
  return Number.isFinite(number) ? number : null;
}

// Parsuje wszystkie zdarzenia ESPN (z kluczami drużyn do dopasowania po nazwie).
// `state`: "pre" | "in" | "post". Bierzemy "in" (live) i "post" (świeżo
// zakończone) — reszta jest pomijana wyżej tam, gdzie nie jest potrzebna.
function parseEspnEvents(data) {
  const events = Array.isArray(data?.events) ? data.events : [];
  const parsed = [];

  for (const event of events) {
    const competition = Array.isArray(event.competitions) ? event.competitions[0] : null;
    if (!competition) continue;

    const state = competition.status?.type?.state || event.status?.type?.state || "";
    const competitors = Array.isArray(competition.competitors) ? competition.competitors : [];
    const home = competitors.find((entry) => entry.homeAway === "home");
    const away = competitors.find((entry) => entry.homeAway === "away");
    if (!home || !away) continue;

    const homeName = home.team?.displayName || home.team?.name || home.team?.shortDisplayName || "?";
    const awayName = away.team?.displayName || away.team?.name || away.team?.shortDisplayName || "?";

    parsed.push({
      id: String(event.id),
      state,
      kickoffISO: competition.date || event.date || "",
      clock:
        competition.status?.type?.shortDetail ||
        competition.status?.displayClock ||
        event.status?.type?.shortDetail ||
        "LIVE",
      homeScore: parseEspnInt(home.score),
      awayScore: parseEspnInt(away.score),
      homeName,
      awayName,
      homeLogo: home.team?.logo || "",
      awayLogo: away.team?.logo || "",
      homeKey: teamKeyFromName(homeName),
      awayKey: teamKeyFromName(awayName),
    });
  }

  return parsed;
}

// Wspólny pobór wyników na żywo z ESPN. Pollujemy tylko, gdy jest mecz w oknie
// live i karta jest widoczna (oszczędność). Zwraca surowe zdarzenia + gotową
// mapę naszych meczów -> wynik na żywo (do rankingu live).
function useEspnLive(matches) {
  const [espnEvents, setEspnEvents] = useState([]);
  const [updatedAt, setUpdatedAt] = useState(null);

  useEffect(() => {
    let cancelled = false;

    async function loadLive() {
      if (typeof document !== "undefined" && document.visibilityState !== "visible") return;
      if (!hasLiveWindow(matches, Date.now())) {
        if (!cancelled) setEspnEvents((current) => (current.length ? [] : current));
        return;
      }

      try {
        const response = await fetch(`${ESPN_LIVE_URL}?dates=${ESPN_LIVE_DATES}&limit=500`, {
          headers: { accept: "application/json" },
        });
        if (!response.ok) throw new Error(`ESPN HTTP ${response.status}`);
        const data = await response.json();
        if (cancelled) return;
        setEspnEvents(parseEspnEvents(data));
        setUpdatedAt(new Date());
      } catch (error) {
        if (!cancelled) console.warn("Typer live scores:", error.message);
      }
    }

    loadLive();
    const interval = window.setInterval(loadLive, LIVE_POLL_MS);
    const onVisible = () => {
      if (document.visibilityState === "visible") loadLive();
    };
    document.addEventListener("visibilitychange", onVisible);

    return () => {
      cancelled = true;
      window.clearInterval(interval);
      document.removeEventListener("visibilitychange", onVisible);
    };
  }, [matches]);

  const liveByMatchId = useMemo(() => buildLiveByMatchId(matches, espnEvents), [matches, espnEvents]);

  return { espnEvents, liveByMatchId, updatedAt };
}

function hasLiveWindow(matches, nowMs) {
  return (matches || []).some((match) => {
    const kickoffMs = Date.parse(match?.kickoffAt || "");
    if (!Number.isFinite(kickoffMs)) return false;
    return nowMs >= kickoffMs - LIVE_WINDOW_BEFORE_MS && nowMs <= kickoffMs + LIVE_WINDOW_AFTER_MS;
  });
}

function getLivePickStatus(pick, homeScore, awayScore) {
  if (!pick || homeScore === null || awayScore === null) return null;

  if (pick.home === homeScore && pick.away === awayScore) {
    return { tone: "good", label: "Trafiony wynik" };
  }

  const liveSide = homeScore > awayScore ? "home" : homeScore < awayScore ? "away" : "draw";
  const pickSide = pick.home > pick.away ? "home" : pick.home < pick.away ? "away" : "draw";

  if (liveSide === pickSide) return { tone: "warn", label: "Dobry kierunek" };
  return { tone: "danger", label: "Pudło" };
}

function LiveScoreTeam({ name, crest, logo, align = "left" }) {
  const initials = getInitials(name);
  const imageUrl = crest || logo || "";

  return (
    <div className={cx("flex min-w-0 items-center gap-2", align === "right" && "flex-row-reverse text-right")}>
      <span className="grid h-9 w-9 shrink-0 place-items-center overflow-hidden rounded-xl border border-white/10 bg-white text-xs font-black text-gray-900 shadow-sm">
        {imageUrl ? (
          <img
            src={imageUrl}
            alt=""
            className="h-6 w-6 object-contain"
            loading="lazy"
            referrerPolicy="no-referrer"
            onError={(event) => {
              event.currentTarget.style.display = "none";
            }}
          />
        ) : (
          initials || "?"
        )}
      </span>
      <span className="truncate text-sm font-black">{name}</span>
    </div>
  );
}

function TyperLiveMatches({ matches, picks, darkMode, espnEvents, updatedAt }) {
  // Dopasowanie meczu w toku do naszego meczu PO NAZWIE + czasie (nie po samej
  // minucie gwizdka), żeby mecze grane równocześnie nie myliły się ze sobą.
  const rows = useMemo(() => {
    const liveEvents = (espnEvents || []).filter((event) => event.state === "in");

    return liveEvents.map((event) => {
      const ourMatch =
        (matches || []).find((match) => {
          const matched = matchEspnEventToMatch(match, [event]);
          return !!matched;
        }) || null;
      const matched = ourMatch ? matchEspnEventToMatch(ourMatch, [event]) : null;
      const swapped = matched?.swapped || false;

      const homeTeam = ourMatch ? team(ourMatch.home) : null;
      const awayTeam = ourMatch ? team(ourMatch.away) : null;
      const pick = ourMatch ? picks?.[ourMatch.id] : null;

      // Wynik zawsze względem orientacji naszego meczu (home = nasz gospodarz).
      const homeScore = swapped ? event.awayScore : event.homeScore;
      const awayScore = swapped ? event.homeScore : event.awayScore;

      return {
        key: event.id,
        clock: event.clock,
        homeScore,
        awayScore,
        homeName: homeTeam?.name || (swapped ? event.awayName : event.homeName),
        awayName: awayTeam?.name || (swapped ? event.homeName : event.awayName),
        homeCrest: homeTeam?.crest || "",
        awayCrest: awayTeam?.crest || "",
        homeLogo: swapped ? event.awayLogo : event.homeLogo,
        awayLogo: swapped ? event.homeLogo : event.awayLogo,
        stageLabel: ourMatch ? (ourMatch.group ? `Grupa ${ourMatch.group}` : ourMatch.stage) : "",
        pick: pick && typeof pick.home === "number" && typeof pick.away === "number" ? pick : null,
      };
    });
  }, [espnEvents, matches, picks]);

  if (!rows.length) return null;

  return (
    <section
      className={cx(
        "overflow-hidden rounded-2xl border",
        darkMode ? "border-red-400/30 bg-[#160d12] text-white" : "border-red-200 bg-white text-gray-950"
      )}
    >
      <div className="flex items-center justify-between gap-3 border-b px-4 py-3"
        style={{ borderColor: darkMode ? "rgba(248,113,113,0.25)" : "#fecaca" }}>
        <div className="flex items-center gap-2">
          <span className="relative flex h-2.5 w-2.5">
            <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-red-500 opacity-75" />
            <span className="relative inline-flex h-2.5 w-2.5 rounded-full bg-red-500" />
          </span>
          <span className="text-sm font-black uppercase tracking-[0.16em] text-red-500">Na żywo</span>
          <span className={cx("text-xs font-bold", darkMode ? "text-gray-400" : "text-gray-500")}>
            {rows.length === 1 ? "1 mecz w toku" : `${rows.length} mecze w toku`}
          </span>
        </div>
        {updatedAt && (
          <span className={cx("text-[11px] font-bold", darkMode ? "text-gray-500" : "text-gray-400")}>
            odświeżono{" "}
            {new Intl.DateTimeFormat("pl-PL", { hour: "2-digit", minute: "2-digit" }).format(updatedAt)}
          </span>
        )}
      </div>

      <div className="divide-y" style={{ borderColor: darkMode ? "rgba(255,255,255,0.06)" : "#f1f5f9" }}>
        {rows.map((row) => {
          const pickStatus = row.pick ? getLivePickStatus(row.pick, row.homeScore, row.awayScore) : null;

          return (
            <div key={row.key} className="px-4 py-3">
              <div className="grid grid-cols-[minmax(0,1fr)_auto_minmax(0,1fr)] items-center gap-3">
                <LiveScoreTeam name={row.homeName} crest={row.homeCrest} logo={row.homeLogo} align="left" />
                <div className="flex flex-col items-center">
                  <div className="flex items-center gap-1.5 text-2xl font-black tabular-nums">
                    <span>{row.homeScore ?? 0}</span>
                    <span className="opacity-40">:</span>
                    <span>{row.awayScore ?? 0}</span>
                  </div>
                  <span className="mt-0.5 rounded-full bg-red-500/15 px-2 py-0.5 text-[11px] font-black text-red-500">
                    {row.clock}
                  </span>
                </div>
                <LiveScoreTeam name={row.awayName} crest={row.awayCrest} logo={row.awayLogo} align="right" />
              </div>

              <div className="mt-2 flex flex-wrap items-center justify-between gap-2">
                <span className={cx("text-[11px] font-bold uppercase tracking-wide", darkMode ? "text-gray-500" : "text-gray-400")}>
                  {row.stageLabel}
                </span>
                {row.pick && (
                  <span className="inline-flex items-center gap-1.5 text-xs font-bold">
                    <span className={darkMode ? "text-gray-400" : "text-gray-500"}>
                      Twój typ: {row.pick.home}:{row.pick.away}
                    </span>
                    {pickStatus && <Pill darkMode={darkMode} tone={pickStatus.tone}>{pickStatus.label}</Pill>}
                  </span>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
}

function GoogleLogo({ className = "h-5 w-5" }) {
  return (
    <svg viewBox="0 0 48 48" className={className} aria-hidden="true" focusable="false">
      <path fill="#FFC107" d="M43.61 20.08H42V20H24v8h11.3c-1.65 4.66-6.08 8-11.3 8-7.18 0-13-5.82-13-13s5.82-13 13-13c3.31 0 6.33 1.25 8.62 3.29l5.66-5.66C34.68 4.27 29.66 2 24 2 11.85 2 2 11.85 2 24s9.85 22 22 22 22-9.85 22-22c0-1.34-.14-2.64-.39-3.92z" />
      <path fill="#FF3D00" d="M4.31 14.69l6.57 4.82C12.65 14.12 17.73 10 24 10c3.31 0 6.33 1.25 8.62 3.29l5.66-5.66C34.68 4.27 29.66 2 24 2 15.48 2 8.08 6.86 4.31 14.69z" />
      <path fill="#4CAF50" d="M24 46c5.55 0 10.49-2.12 14.27-5.58l-6.03-5.1C30.02 36.99 27.17 38 24 38c-5.2 0-9.62-3.31-11.29-7.94l-6.53 5.03C9.9 41.54 16.9 46 24 46z" />
      <path fill="#1976D2" d="M43.61 20.08H42V20H24v8h11.3a13.1 13.1 0 0 1-4.48 6.36l.01-.01 6.03 5.1C36.43 39.83 46 33 46 24c0-1.34-.14-2.64-.39-3.92z" />
    </svg>
  );
}

function FacebookLogo({ className = "h-5 w-5" }) {
  return (
    <svg viewBox="0 0 24 24" className={className} aria-hidden="true" focusable="false">
      <path
        fill="currentColor"
        d="M15.12 8.02h-2.02c-.35 0-.74.46-.74 1.08v1.46h2.76l-.42 2.78h-2.34V21h-3.1v-7.66H7.08v-2.78h2.18V9.34c0-2.36 1.64-4.34 3.84-4.34h2.02v3.02z"
      />
    </svg>
  );
}

function FootballBadgeAvatarGraphic({ option = {} }) {
  const bg = option.bg || "#0f172a";
  const primary = option.primary || "#2563eb";
  const secondary = option.secondary || "#f8fafc";
  const accent = option.accent || "#facc15";
  const shape = option.shape || "shield";
  const pattern = option.pattern || "solid";
  const mark = option.mark || "ball";
  const text = option.text || "FC";

  const badgeShape =
    shape === "circle" ? (
      <circle cx="50" cy="50" r="34" fill={primary} stroke={secondary} strokeWidth="5" />
    ) : shape === "crest" ? (
      <path
        d="M23 21 H77 C76 58 68 82 50 91 C32 82 24 58 23 21 Z"
        fill={primary}
        stroke={secondary}
        strokeWidth="5"
        strokeLinejoin="round"
      />
    ) : (
      <path
        d="M21 20 H79 L74 67 C71 79 61 88 50 92 C39 88 29 79 26 67 Z"
        fill={primary}
        stroke={secondary}
        strokeWidth="5"
        strokeLinejoin="round"
      />
    );

  const clipId = React.useId().replace(/:/g, "");
  const clipShape =
    shape === "circle" ? (
      <circle cx="50" cy="50" r="30" />
    ) : shape === "crest" ? (
      <path d="M27 26 H73 C72 57 65 77 50 86 C35 77 28 57 27 26 Z" />
    ) : (
      <path d="M26 25 H74 L70 64 C67 76 59 83 50 87 C41 83 33 76 30 64 Z" />
    );

  const patternLayer =
    pattern === "stripes" ? (
      <>
        <rect x="30" y="22" width="10" height="68" fill={secondary} opacity="0.96" />
        <rect x="50" y="22" width="10" height="68" fill={secondary} opacity="0.96" />
        <rect x="70" y="22" width="10" height="68" fill={secondary} opacity="0.96" />
      </>
    ) : pattern === "hoops" ? (
      <>
        <rect x="18" y="34" width="64" height="10" fill={secondary} opacity="0.96" />
        <rect x="18" y="56" width="64" height="10" fill={secondary} opacity="0.96" />
      </>
    ) : pattern === "diagonal" ? (
      <path d="M17 75 L74 18 L85 29 L28 86 Z" fill={secondary} opacity="0.96" />
    ) : pattern === "split" ? (
      <path d="M50 16 H84 V92 H50 Z" fill={secondary} opacity="0.96" />
    ) : pattern === "quarters" ? (
      <>
        <rect x="18" y="18" width="32" height="32" fill={secondary} opacity="0.96" />
        <rect x="50" y="50" width="32" height="40" fill={secondary} opacity="0.96" />
      </>
    ) : pattern === "wave" ? (
      <>
        <path d="M17 55 C30 44 42 65 55 54 C66 45 73 43 84 49 V92 H17 Z" fill={secondary} opacity="0.95" />
        <path d="M17 70 C31 58 42 78 55 67 C66 58 74 56 84 62" stroke={accent} strokeWidth="5" fill="none" opacity="0.9" />
      </>
    ) : null;

  const markLayer =
    mark === "crown" ? (
      <path d="M35 44 L42 33 L50 44 L58 33 L65 44 V54 H35 Z" fill={accent} stroke="#111827" strokeWidth="2" strokeLinejoin="round" />
    ) : mark === "star" ? (
      <path d="M50 31 L55 43 L68 44 L58 52 L61 65 L50 58 L39 65 L42 52 L32 44 L45 43 Z" fill={accent} stroke="#111827" strokeWidth="2" strokeLinejoin="round" />
    ) : (
      <g transform="translate(50 48)">
        <circle r="15" fill={accent} stroke="#111827" strokeWidth="2.5" />
        <path d="M0 -11 L10 -3 L6 10 H-6 L-10 -3 Z" fill="#111827" opacity="0.82" />
        <path d="M0 -11 V-15 M10 -3 L14 -6 M6 10 L9 14 M-6 10 L-9 14 M-10 -3 L-14 -6" stroke="#111827" strokeWidth="2" />
      </g>
    );

  return (
    <svg viewBox="0 0 100 100" className="h-full w-full" aria-hidden="true" focusable="false">
      <circle cx="50" cy="50" r="50" fill={bg} />
      <defs>
        <clipPath id={clipId}>{clipShape}</clipPath>
      </defs>
      {badgeShape}
      <g clipPath={`url(#${clipId})`}>{patternLayer}</g>
      {markLayer}
      <text
        x="50"
        y="78"
        textAnchor="middle"
        fontSize="16"
        fontWeight="900"
        fontFamily="Arial, sans-serif"
        fill={shape === "circle" && pattern === "split" ? primary : secondary}
        stroke="#111827"
        strokeWidth="0.8"
        paintOrder="stroke"
      >
        {text}
      </text>
    </svg>
  );
}

function FootballerAvatarGraphic({ option = {} }) {
  const bg = option.bg || "#2563eb";
  const skin = option.skin || "#efb47c";
  const hair = option.hair || "#111827";
  const jersey = option.jersey || "#1d4ed8";
  const accent = option.accent || "#f8fafc";
  const pattern = option.pattern || "solid";
  const hairStyle = option.hairStyle || "short";
  const beard = option.beard || "";

  const jerseyPattern =
    pattern === "vertical" ? (
      <>
        <rect x="38" y="64" width="8" height="36" fill={accent} opacity="0.95" />
        <rect x="54" y="64" width="8" height="36" fill={accent} opacity="0.95" />
      </>
    ) : pattern === "horizontal" ? (
      <>
        <rect x="23" y="72" width="54" height="8" fill={accent} opacity="0.9" />
        <rect x="21" y="88" width="58" height="8" fill={accent} opacity="0.9" />
      </>
    ) : pattern === "sash" || pattern === "diagonal" ? (
      <path d="M23 96 L75 65 L82 76 L32 100 Z" fill={accent} opacity="0.9" />
    ) : pattern === "split" ? (
      <path d="M50 60 C62 62 75 70 82 99 L50 99 Z" fill={accent} opacity="0.95" />
    ) : pattern === "checker" ? (
      <>
        <rect x="27" y="68" width="12" height="12" fill={accent} opacity="0.9" />
        <rect x="51" y="68" width="12" height="12" fill={accent} opacity="0.9" />
        <rect x="39" y="80" width="12" height="12" fill={accent} opacity="0.9" />
        <rect x="63" y="80" width="12" height="12" fill={accent} opacity="0.9" />
      </>
    ) : pattern === "hoops" ? (
      <>
        <rect x="24" y="70" width="52" height="7" fill={accent} opacity="0.9" />
        <rect x="22" y="84" width="56" height="7" fill={accent} opacity="0.9" />
      </>
    ) : pattern === "keeper" ? (
      <>
        <rect x="29" y="70" width="42" height="4" fill={accent} opacity="0.55" />
        <rect x="29" y="82" width="42" height="4" fill={accent} opacity="0.55" />
        <rect x="29" y="94" width="42" height="4" fill={accent} opacity="0.55" />
      </>
    ) : pattern === "lightning" ? (
      <path d="M56 62 L39 81 H51 L43 101 L66 75 H53 Z" fill={accent} opacity="0.95" />
    ) : pattern === "armband" ? (
      <rect x="22" y="73" width="14" height="10" rx="4" fill={accent} opacity="0.95" />
    ) : null;

  const hairShape =
    hairStyle === "bald" ? null : hairStyle === "long" ? (
      <>
        <path d="M30 39 C25 22 35 11 50 11 C67 11 75 23 70 43 C68 36 63 30 56 26 C46 34 37 36 30 39 Z" fill={hair} />
        <path d="M28 38 C19 51 25 63 33 69 C30 58 31 48 34 39 Z" fill={hair} />
        <path d="M72 38 C81 51 75 63 67 69 C70 58 69 48 66 39 Z" fill={hair} />
      </>
    ) : hairStyle === "quiff" ? (
      <path d="M28 37 C28 22 38 14 51 15 C55 8 68 12 71 25 C64 21 56 23 51 29 C44 23 34 29 28 37 Z" fill={hair} />
    ) : hairStyle === "mohawk" ? (
      <>
        <path d="M37 32 C39 18 45 10 52 8 C56 18 59 25 61 35 C54 29 45 28 37 32 Z" fill={hair} />
        <path d="M29 38 C32 27 39 21 50 22 C61 21 68 27 71 38 C62 34 39 34 29 38 Z" fill={hair} opacity="0.9" />
      </>
    ) : hairStyle === "crop" ? (
      <path d="M29 37 C30 22 38 15 50 15 C63 15 70 23 71 37 C60 30 42 30 29 37 Z" fill={hair} />
    ) : hairStyle === "buzz" || hairStyle === "recede" ? (
      <path d="M31 35 C33 24 40 18 50 18 C60 18 67 24 69 35 C58 31 42 31 31 35 Z" fill={hair} opacity={hairStyle === "recede" ? "0.78" : "1"} />
    ) : hairStyle === "curtain" ? (
      <>
        <path d="M30 38 C30 22 39 15 50 15 C45 28 38 34 30 38 Z" fill={hair} />
        <path d="M70 38 C70 22 61 15 50 15 C55 28 62 34 70 38 Z" fill={hair} />
      </>
    ) : hairStyle === "topknot" ? (
      <>
        <circle cx="50" cy="12" r="7" fill={hair} />
        <path d="M30 36 C31 23 39 18 50 18 C61 18 69 23 70 36 C58 31 42 31 30 36 Z" fill={hair} />
      </>
    ) : hairStyle === "locks" ? (
      <>
        <path d="M28 36 C30 22 39 15 50 15 C62 15 70 23 72 37 C62 31 40 31 28 36 Z" fill={hair} />
        {[26, 32, 68, 74].map((x, index) => (
          <path key={index} d={`M${x} 35 C${x - 4} 47 ${x + 2} 55 ${x - 2} 66`} stroke={hair} strokeWidth="5" strokeLinecap="round" fill="none" />
        ))}
      </>
    ) : hairStyle === "headband" ? (
      <>
        <path d="M29 36 C31 22 39 16 50 16 C61 16 69 22 71 36 C60 30 40 30 29 36 Z" fill={hair} />
        <path d="M30 30 C42 26 58 26 70 30" stroke={accent} strokeWidth="4" strokeLinecap="round" />
      </>
    ) : hairStyle === "fringe" ? (
      <>
        <path d="M29 36 C30 22 39 15 51 15 C63 15 70 22 71 36 C59 30 42 31 29 36 Z" fill={hair} />
        <path d="M38 24 C39 35 46 36 50 28 C52 36 59 36 63 27" stroke={hair} strokeWidth="8" strokeLinecap="round" fill="none" />
      </>
    ) : hairStyle === "waves" ? (
      <>
        <path d="M29 36 C31 21 39 15 50 15 C62 15 69 23 71 36 C59 31 41 31 29 36 Z" fill={hair} />
        <path d="M35 26 C41 22 48 28 54 24 C59 21 64 24 67 28" stroke="#ffffff" strokeOpacity="0.18" strokeWidth="2" fill="none" />
      </>
    ) : hairStyle === "messy" || hairStyle === "side" || hairStyle === "spike" ? (
      <path d="M28 37 C28 23 38 14 50 15 C62 14 72 23 72 37 C64 33 58 28 54 22 C47 30 38 31 28 37 Z" fill={hair} />
    ) : (
      <path d="M29 36 C30 23 39 16 50 16 C61 16 70 23 71 36 C60 31 40 31 29 36 Z" fill={hair} />
    );

  return (
    <svg viewBox="0 0 100 100" className="h-full w-full" aria-hidden="true" focusable="false">
      <circle cx="50" cy="50" r="50" fill={bg} />
      <path d="M18 101 C21 75 32 61 50 60 C68 61 79 75 82 101 Z" fill={jersey} />
      {jerseyPattern}
      <path d="M40 60 H60 V72 C55 77 45 77 40 72 Z" fill={skin} />
      <circle cx="31" cy="43" r="5" fill={skin} />
      <circle cx="69" cy="43" r="5" fill={skin} />
      <ellipse cx="50" cy="40" rx="20" ry="24" fill={skin} />
      {hairShape}
      <circle cx="42" cy="42" r="2.2" fill="#111827" />
      <circle cx="58" cy="42" r="2.2" fill="#111827" />
      <path d="M49 44 L46 54 H53" stroke="#9a5b3d" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" fill="none" opacity="0.45" />
      {beard === "full" && <path d="M32 47 C35 68 45 75 50 75 C55 75 65 68 68 47 C64 66 36 66 32 47 Z" fill={hair} opacity="0.88" />}
      {beard === "stubble" && <path d="M36 59 C43 65 57 65 64 59 C61 70 39 70 36 59 Z" fill={hair} opacity="0.35" />}
      {beard === "goatee" && <path d="M44 61 C47 67 53 67 56 61 C54 73 46 73 44 61 Z" fill={hair} opacity="0.9" />}
      {(beard === "mustache" || beard === "full" || beard === "goatee") && (
        <path d="M42 55 C46 52 49 55 50 56 C51 55 54 52 58 55" stroke={hair} strokeWidth="3" strokeLinecap="round" fill="none" />
      )}
      <path d="M43 60 C47 64 53 64 57 60" stroke="#7f1d1d" strokeWidth="2" strokeLinecap="round" fill="none" opacity="0.65" />
      <path d="M34 38 C38 34 42 34 45 37" stroke={hair} strokeWidth="2.4" strokeLinecap="round" fill="none" />
      <path d="M55 37 C59 34 63 34 66 38" stroke={hair} strokeWidth="2.4" strokeLinecap="round" fill="none" />
      <path d="M24 92 C17 82 17 72 26 69 C32 72 31 83 24 92 Z" fill={skin} />
      <path d="M76 92 C83 82 83 72 74 69 C68 72 69 83 76 92 Z" fill={skin} />
    </svg>
  );
}

function AvatarPreview({ avatar, name, size = "lg", className = "" }) {
  const sizeClass =
    size === "xs"
      ? "h-10 w-10 text-sm"
      : size === "sm"
      ? "h-12 w-12 text-base"
      : size === "xl"
      ? "h-24 w-24 text-3xl"
      : "h-16 w-16 text-xl";
  const imageUrl = ["google", "facebook", "upload"].includes(avatar?.type) ? avatar.url : "";
  const defaultOption = FOOTBALL_AVATAR_OPTIONS.find((item) => item.id === avatar?.id) || FOOTBALL_AVATAR_OPTIONS[0];
  const badgeOption = FOOTBALL_BADGE_AVATAR_OPTIONS.find((item) => item.id === avatar?.id) || FOOTBALL_BADGE_AVATAR_OPTIONS[0];
  const initials = getInitials(name);
  const [imageFailed, setImageFailed] = useState(false);

  useEffect(() => {
    setImageFailed(false);
  }, [imageUrl]);

  if (imageUrl && !imageFailed) {
    return (
      <span className={cx("block shrink-0 overflow-hidden rounded-full border-2 border-white/80 bg-white shadow-sm", sizeClass, className)}>
        <img
          src={imageUrl}
          alt=""
          className="h-full w-full object-cover"
          referrerPolicy="no-referrer"
          loading="lazy"
          onError={() => setImageFailed(true)}
        />
      </span>
    );
  }

  if (imageUrl && imageFailed) {
    return (
      <span className={cx("grid shrink-0 place-items-center rounded-full border-2 border-white/80 bg-gradient-to-br from-red-500 to-sky-500 font-black text-white shadow-sm", sizeClass, className)}>
        {initials}
      </span>
    );
  }

  if (avatar?.type === "flag") {
    const flagTeam = team(avatar.teamId || avatar.id);
    return (
      <span className={cx("grid shrink-0 place-items-center overflow-hidden rounded-full border-2 border-white/80 bg-white shadow-sm", sizeClass, className)}>
        {flagTeam.crest ? (
          <img
            src={flagTeam.crest}
            alt=""
            className="h-[72%] w-[72%] object-contain"
            style={{ filter: "drop-shadow(0 2px 3px rgba(0,0,0,0.38))" }}
          />
        ) : (
          <span className="font-black text-gray-950">{getInitials(flagTeam.name)}</span>
        )}
      </span>
    );
  }

  if (avatar?.type === "initials") {
    return (
      <span className={cx("grid shrink-0 place-items-center rounded-full border-2 border-white/80 bg-gradient-to-br from-red-500 to-sky-500 font-black text-white shadow-sm", sizeClass, className)}>
        {initials}
      </span>
    );
  }

  if (avatar?.type === "badge") {
    return (
      <span
        className={cx("grid shrink-0 place-items-center overflow-hidden rounded-full border-2 border-white/80 bg-white text-white shadow-sm", sizeClass, className)}
      >
        <FootballBadgeAvatarGraphic option={badgeOption} />
      </span>
    );
  }

  return (
    <span
      className={cx("grid shrink-0 place-items-center overflow-hidden rounded-full border-2 border-white/80 bg-white text-white shadow-sm", sizeClass, className)}
    >
      <FootballerAvatarGraphic option={defaultOption} />
    </span>
  );
}

function TyperProfileSetup({
  darkMode,
  user,
  defaultName,
  googleAvatarUrl,
  facebookAvatarUrl,
  nicknameDraft,
  setNicknameDraft,
  avatarDraft,
  setAvatarDraft,
  setupError,
  setSetupError,
  onAvatarUpload,
  onSave,
  championTeams,
  isEditing = false,
}) {
  const [avatarUploading, setAvatarUploading] = useState(false);
  const socialAvatarOptions = [
    ...(googleAvatarUrl
      ? [{ id: "google", label: "Zdjęcie z Google", avatar: { type: "google", url: googleAvatarUrl }, providerIcon: "google" }]
      : []),
    ...(facebookAvatarUrl
      ? [{ id: "facebook", label: "Zdjęcie z Facebooka", avatar: { type: "facebook", url: facebookAvatarUrl }, providerIcon: "facebook" }]
      : []),
  ];
  const graphicAvatarOptions = [
    { id: "initials", label: "Inicjały", avatar: { type: "initials" } },
    ...FOOTBALL_AVATAR_OPTIONS.map((item) => ({
      id: item.id,
      label: item.label,
      avatar: { type: "default", id: item.id },
    })),
    ...FOOTBALL_BADGE_AVATAR_OPTIONS.map((item) => ({
      id: item.id,
      label: item.label,
      avatar: { type: "badge", id: item.id },
    })),
  ];
  const circleAvatarOptions = [
    ...graphicAvatarOptions,
    ...(championTeams || []).map((item) => ({
      id: `flag-${item.id}`,
      label: item.name,
      avatar: { type: "flag", teamId: item.id },
    })),
  ];
  const isAvatarSelected = (avatar) => {
    if (!avatar?.type || avatar.type !== avatarDraft?.type) return false;
    if (avatar.type === "flag") return (avatar.teamId || avatar.id) === (avatarDraft.teamId || avatarDraft.id);
    if (avatar.id) return avatar.id === avatarDraft?.id;
    if (avatar.url) return avatar.url === avatarDraft?.url;
    return true;
  };

  const handleUpload = async (event) => {
    const file = event.target.files?.[0];
    if (!file) return;

    if (!file.type.startsWith("image/")) {
      setSetupError("Wybierz plik graficzny.");
      return;
    }

    if (file.size > 1200 * 1024) {
      setSetupError("Zdjęcie jest za duże. Na razie wybierz plik do 1,2 MB.");
      return;
    }

    setAvatarUploading(true);
    setSetupError("");

    try {
      const avatar = onAvatarUpload ? await onAvatarUpload(file) : null;
      if (avatar?.url) {
        setAvatarDraft(avatar);
        return;
      }

      const reader = new FileReader();
      reader.onload = () => {
        setSetupError("");
        setAvatarDraft({ type: "upload", url: String(reader.result || "") });
      };
      reader.onerror = () => setSetupError("Nie udało się wczytać zdjęcia.");
      reader.readAsDataURL(file);
    } catch (error) {
      setSetupError(error?.message || "Nie udało się wczytać zdjęcia.");
    } finally {
      setAvatarUploading(false);
      event.target.value = "";
    }
  };

  return (
    <div className="grid gap-4 xl:grid-cols-[1fr_340px]">
      <Card darkMode={darkMode}>
        <div className="grid gap-5 lg:grid-cols-[1fr_190px]">
          <div className="order-2 flex flex-col items-center justify-center rounded-2xl border border-white/10 bg-black/10 p-4 text-center">
            <AvatarPreview avatar={avatarDraft} name={nicknameDraft || defaultName} size="xl" />
            <div className="mt-3 text-lg font-black">{nicknameDraft.trim() || defaultName}</div>
            <div className="mt-1 text-xs font-bold opacity-70">{user?.email}</div>
          </div>

          <div className="order-1">
            <div className="flex flex-wrap items-center gap-2">
              <Pill darkMode={darkMode} tone="info">
                <UserCheck size={13} /> Profil kibica
              </Pill>
              <Pill darkMode={darkMode} tone="warn">
                <Lock size={13} /> Wymagany przed typowaniem
              </Pill>
            </div>

            <h2 className="mt-4 text-2xl font-black leading-tight md:text-3xl">
              {isEditing ? "Edytuj profil Typera" : "Ustaw nick i avatar"}
            </h2>
            <div className={cx("mt-2 max-w-2xl text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
              Nick będzie widoczny w rankingu oraz przy typach. Zdjęcie z konta społecznościowego,
              flaga, gotowy styl piłkarski albo upload są wybierane ręcznie.
            </div>

            <label className="mt-5 block">
              <span className="text-xs font-black uppercase tracking-[0.14em] opacity-70">Nick w typerze</span>
              <input
                type="text"
                value={nicknameDraft}
                onChange={(event) => {
                  setSetupError("");
                  setNicknameDraft(event.target.value);
                }}
                maxLength={28}
                className={cx(
                  "mt-2 min-h-[48px] w-full rounded-2xl border px-4 text-base font-black outline-none transition-colors",
                  darkMode
                    ? "border-white/10 bg-white/5 text-white focus:border-sky-300"
                    : "border-gray-200 bg-white text-gray-950 focus:border-sky-400"
                )}
                placeholder="np. Mati z trybun"
              />
            </label>

            <div className="mt-5">
              <div className="text-xs font-black uppercase tracking-[0.14em] opacity-70">Avatar</div>
              <div className="mt-2 grid gap-2 md:grid-cols-3">
                {socialAvatarOptions.map((item) => {
                  const selected = isAvatarSelected(item.avatar);
                  const optionPreview =
                    item.providerIcon === "facebook" ? (
                      <span className="grid h-12 w-12 shrink-0 place-items-center rounded-full border-2 border-white/80 bg-white text-blue-600 shadow-sm">
                        <FacebookLogo className="h-7 w-7" />
                      </span>
                    ) : (
                      <span className="grid h-12 w-12 shrink-0 place-items-center rounded-full border-2 border-white/80 bg-white shadow-sm">
                        <GoogleLogo className="h-6 w-6" />
                      </span>
                    );

                  return (
                    <button
                      key={item.id}
                      type="button"
                      onClick={() => {
                        setSetupError("");
                        setAvatarDraft(item.avatar);
                      }}
                      className={cx(
                        "flex min-h-[58px] items-center gap-3 rounded-2xl border p-2 text-left text-sm font-black transition-colors",
                        selected
                          ? "border-sky-300 bg-sky-400 text-black"
                          : darkMode
                          ? "border-white/10 bg-white/5 text-gray-100 hover:bg-white/10"
                          : "border-gray-200 bg-white text-gray-900 hover:bg-gray-50"
                      )}
                    >
                      {optionPreview}
                      <span className="min-w-0 truncate">{item.label}</span>
                    </button>
                  );
                })}

                <label
                  title="Własne zdjęcie"
                  aria-label="Własne zdjęcie"
                  className={cx(
                    "flex min-h-[58px] cursor-pointer items-center gap-3 rounded-2xl border p-2 text-left text-sm font-black transition-colors",
                    avatarUploading && "pointer-events-none opacity-60",
                    avatarDraft?.type === "upload"
                      ? "border-sky-300 bg-sky-400 text-black"
                      : darkMode
                      ? "border-white/10 bg-white/5 text-gray-100 hover:bg-white/10"
                      : "border-gray-200 bg-white text-gray-900 hover:bg-gray-50"
                  )}
                >
                  <span className="grid h-12 w-12 shrink-0 place-items-center rounded-full border-2 border-white/80 bg-slate-900 text-white shadow-sm">
                    <Plus size={20} />
                  </span>
                  <span className="min-w-0 truncate">{avatarUploading ? "Przesyłanie..." : "Własne zdjęcie"}</span>
                  <input type="file" accept="image/*" className="sr-only" onChange={handleUpload} disabled={avatarUploading} />
                </label>
              </div>

              <div className="mlpn-typer-scrollbar mt-3 flex max-h-[260px] flex-wrap gap-2 overflow-y-auto pr-1">
                {circleAvatarOptions.map((item) => {
                  const selected = isAvatarSelected(item.avatar);

                  return (
                    <button
                      key={item.id}
                      type="button"
                      title={item.avatar.type === "flag" ? `Flaga: ${item.label}` : item.label}
                      aria-label={item.avatar.type === "flag" ? `Flaga: ${item.label}` : item.label}
                      onClick={() => {
                        setSetupError("");
                        setAvatarDraft(item.avatar);
                      }}
                      className={cx(
                        "grid h-14 w-14 shrink-0 place-items-center rounded-full p-1 transition-transform hover:scale-105 focus:outline-none focus-visible:ring-2 focus-visible:ring-sky-400",
                        selected
                          ? "bg-sky-400/20 ring-2 ring-sky-300"
                          : darkMode
                          ? "hover:bg-white/10"
                          : "hover:bg-gray-100"
                      )}
                    >
                      <AvatarPreview avatar={item.avatar} name={nicknameDraft || defaultName} size="sm" />
                    </button>
                  );
                })}
              </div>
            </div>

            {setupError && (
              <div className="mt-4 rounded-2xl border border-red-400/30 bg-red-500/10 p-3 text-sm font-bold text-red-300">
                {setupError}
              </div>
            )}

            <div className="mt-5 flex flex-col gap-2 sm:flex-row sm:items-center">
              <button
                type="button"
                onClick={onSave}
                disabled={avatarUploading}
                className="inline-flex min-h-[46px] items-center justify-center gap-2 rounded-2xl border border-emerald-300 bg-emerald-400 px-5 text-sm font-black text-black transition-colors hover:brightness-105 disabled:cursor-wait disabled:opacity-70"
              >
                <CheckCircle2 size={17} />
                {avatarUploading ? "Przesyłanie avatara..." : "Zapisz profil i przejdź do typowania"}
              </button>
            </div>
          </div>
        </div>
      </Card>

      <div className="space-y-4">
        <Card darkMode={darkMode}>
          <div className="flex items-center gap-2 text-lg font-black">
            <ShieldAlert size={20} />
            Zasady nicku
          </div>
          <div className={cx("mt-3 text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
            Minimum 3 znaki. Bez wulgaryzmów, obrażania innych, podszywania się pod organizatorów i prowokacji.
          </div>
        </Card>

        <Card darkMode={darkMode}>
          <div className="flex items-center gap-2 text-lg font-black">
            <Trophy size={20} />
            Co dalej?
          </div>
          <div className={cx("mt-3 text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
            Po zapisie odblokujemy typy na najbliższe 3 dni oraz wybór mistrza turnieju.
          </div>
        </Card>
      </div>
    </div>
  );
}

function ScoreStepper({ value = 0, onChange, disabled, darkMode, label }) {
  return (
    <div className="grid grid-cols-[40px_54px_40px] items-center rounded-xl border border-white/10 bg-black/10 p-1">
      <button
        type="button"
        onClick={() => onChange(Math.max(0, value - 1))}
        disabled={disabled}
        className={cx(
          "grid h-9 w-9 place-items-center rounded-lg border font-black",
          disabled
            ? "cursor-not-allowed opacity-40"
            : darkMode
            ? "border-white/10 bg-white/5 hover:bg-white/10"
            : "border-gray-200 bg-white hover:bg-gray-50"
        )}
        title={`Zmniejsz ${label}`}
      >
        <Minus size={16} />
      </button>
      <div className="text-center text-2xl font-black tabular-nums">{value}</div>
      <button
        type="button"
        onClick={() => onChange(Math.min(12, value + 1))}
        disabled={disabled}
        className={cx(
          "grid h-9 w-9 place-items-center rounded-lg border font-black",
          disabled
            ? "cursor-not-allowed opacity-40"
            : darkMode
            ? "border-white/10 bg-white/5 hover:bg-white/10"
            : "border-gray-200 bg-white hover:bg-gray-50"
        )}
        title={`Zwiększ ${label}`}
      >
        <Plus size={16} />
      </button>
    </div>
  );
}

function StatusBadge({ darkMode, status }) {
  if (status === "approved") return <Pill darkMode={darkMode} tone="good"><UserCheck size={13} /> Zatwierdzony</Pill>;
  if (status === "blocked") return <Pill darkMode={darkMode} tone="danger"><Lock size={13} /> Blokada</Pill>;
  if (status === "banned") return <Pill darkMode={darkMode} tone="danger"><Ban size={13} /> Ban</Pill>;
  return <Pill darkMode={darkMode} tone="warn"><AlertTriangle size={13} /> Ostrzeżenie</Pill>;
}

function ModerationButton({ children, icon, onClick, disabled, tone = "neutral", darkMode }) {
  const colors = {
    neutral: darkMode
      ? "border-white/10 bg-white/5 text-gray-100 hover:bg-white/10"
      : "border-slate-300 bg-white text-slate-950 hover:bg-slate-50",
    warn: darkMode
      ? "border-amber-300/40 bg-amber-400/15 text-amber-100 hover:bg-amber-400/25"
      : "border-amber-300 bg-amber-100 text-amber-950 hover:bg-amber-200",
    danger: darkMode
      ? "border-red-300/40 bg-red-400/15 text-red-100 hover:bg-red-400/25"
      : "border-red-300 bg-red-100 text-red-900 hover:bg-red-200",
    good: darkMode
      ? "border-emerald-300/40 bg-emerald-400/15 text-emerald-100 hover:bg-emerald-400/25"
      : "border-emerald-300 bg-emerald-100 text-emerald-950 hover:bg-emerald-200",
  };
  const disabledColors = {
    neutral: darkMode
      ? "border-white/10 bg-white/5 text-gray-500"
      : "border-slate-200 bg-slate-100 text-slate-500",
    warn: darkMode
      ? "border-amber-500/20 bg-amber-500/10 text-amber-300/75"
      : "border-amber-200 bg-amber-50 text-amber-700",
    danger: darkMode
      ? "border-red-500/20 bg-red-500/10 text-red-300/75"
      : "border-red-200 bg-red-50 text-red-700",
    good: darkMode
      ? "border-emerald-500/20 bg-emerald-500/10 text-emerald-300/75"
      : "border-emerald-200 bg-emerald-50 text-emerald-700",
  };

  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      className={cx(
        "inline-flex min-h-[42px] items-center justify-center gap-2 whitespace-nowrap rounded-xl border px-3 text-xs font-black transition-colors",
        disabled ? `cursor-not-allowed ${disabledColors[tone]}` : colors[tone]
      )}
    >
      {icon}
      {children}
    </button>
  );
}

export default function WorldCupTyperPage({ darkMode }) {
  const { user, profile, isAdmin, signIn, signInWithProvider } = useAuth();
  const [tab, setTab] = useState("ranking");
  const [matchView, setMatchView] = useState("date");
  const [matchSegmentId, setMatchSegmentId] = useState("");
  const [rankingPage, setRankingPage] = useState(1);
  const [picks, setPicks] = useState(readStoredPicks);
  const [windowNow, setWindowNow] = useState(() => Date.now());
  const [champion, setChampion] = useState(DEFAULT_CHAMPION_ID);
  const [players, setPlayers] = useState(INITIAL_PLAYERS);
  const [typerProfiles, setTyperProfiles] = useState(readStoredTyperProfiles);
  const [nicknameDraft, setNicknameDraft] = useState("");
  const [avatarDraft, setAvatarDraft] = useState({ type: "default", id: FOOTBALL_AVATAR_OPTIONS[0].id });
  const [profileSetupOpen, setProfileSetupOpen] = useState(false);
  const [setupError, setSetupError] = useState("");
  const [adminNicknameDrafts, setAdminNicknameDrafts] = useState({});
  const [adminModerationError, setAdminModerationError] = useState("");
  const [moderationLog, setModerationLog] = useState([]);
  const [authProviderLoading, setAuthProviderLoading] = useState(null);
  const [emailAuthLoading, setEmailAuthLoading] = useState(false);
  const [emailLoginEmail, setEmailLoginEmail] = useState("");
  const [emailLoginPassword, setEmailLoginPassword] = useState("");
  const [authError, setAuthError] = useState("");
  const [, setTyperBackendReady] = useState(true);
  const [typerSyncing, setTyperSyncing] = useState(false);
  const [typerNotice, setTyperNotice] = useState("");
  const [rawWorldCupMatches, setRawWorldCupMatches] = useState(wc2026RawMatches);
  const logoUrl = `${process.env.PUBLIC_URL || ""}/logo1.png`;

  const MATCHES = useMemo(() => normalizeWorldCupMatches(rawWorldCupMatches), [rawWorldCupMatches]);
  const TEAM_BY_ID = useMemo(() => buildTeamById(MATCHES), [MATCHES]);
  CURRENT_TEAM_BY_ID = TEAM_BY_ID;

  const CHAMPION_TEAMS = useMemo(
    () =>
      Object.values(TEAM_BY_ID)
        .filter(isRealNationalTeam)
        .sort((a, b) => a.name.localeCompare(b.name, "pl")),
    [TEAM_BY_ID]
  );
  const currentDefaultChampionId = TEAM_BY_ID.t764 ? "t764" : CHAMPION_TEAMS[0]?.id || DEFAULT_CHAMPION_ID;
  const GROUP_TABLES = useMemo(() => buildGroupTables(MATCHES), [MATCHES]);
  const VISIBLE_SCHEDULE_MATCHES = useMemo(() => MATCHES.filter(hasKnownTeams), [MATCHES]);
  const HIDDEN_UNKNOWN_MATCHES_COUNT = MATCHES.length - VISIBLE_SCHEDULE_MATCHES.length;
  const MATCH_SCHEDULE_SEGMENTS = useMemo(() => buildScheduleSegments(MATCHES), [MATCHES]);

  // Wyniki na żywo z ESPN (wspólne dla tabeli "na żywo" i rankingu live).
  const { espnEvents, liveByMatchId, updatedAt: liveUpdatedAt } = useEspnLive(MATCHES);
  const liveMatchCount = useMemo(() => Object.keys(liveByMatchId).length, [liveByMatchId]);

  useEffect(() => {
    try {
      window.localStorage?.setItem(STORAGE_KEY, JSON.stringify(picks));
    } catch {
      // Prototyp działa również bez localStorage.
    }
  }, [picks]);

  useEffect(() => {
    try {
      window.localStorage?.setItem(TYPER_PROFILE_STORAGE_KEY, JSON.stringify(typerProfiles));
    } catch {
      // Avatar z uploadu moze przekroczyc limit localStorage w bardzo starych przegladarkach.
    }
  }, [typerProfiles]);

  useEffect(() => {
    const timer = window.setInterval(() => setWindowNow(Date.now()), 60 * 1000);
    return () => window.clearInterval(timer);
  }, []);

  useEffect(() => {
    let cancelled = false;

    async function loadWorldCupMatches() {
      try {
        const { matches: remoteMatches, backendReady } = await fetchWorldCupMatches();
        if (cancelled) return;

        setTyperBackendReady(backendReady);

        if (backendReady && remoteMatches.length >= 64) {
          setRawWorldCupMatches(remoteMatches);
        }
      } catch (error) {
        if (!cancelled) {
          console.warn("World Cup matches sync:", error.message);
        }
      }
    }

    loadWorldCupMatches();

    // Odświeżaj wyniki/terminarz co 2 minuty, ale tylko gdy karta jest widoczna,
    // żeby nie zużywać transferu Supabase w tle.
    const interval = window.setInterval(() => {
      if (typeof document === "undefined" || document.visibilityState === "visible") {
        loadWorldCupMatches();
      }
    }, 120000);

    const onVisible = () => {
      if (document.visibilityState === "visible") loadWorldCupMatches();
    };
    document.addEventListener("visibilitychange", onVisible);

    return () => {
      cancelled = true;
      window.clearInterval(interval);
      document.removeEventListener("visibilitychange", onVisible);
    };
  }, []);

  useEffect(() => {
    let cancelled = false;

    async function loadProfiles() {
      try {
        const { profiles, backendReady } = await fetchTyperProfiles();
        if (cancelled) return;

        setTyperBackendReady(backendReady);
        setTyperNotice("");

        if (backendReady) {
          const nextProfiles = {};
          profiles.forEach((item) => {
            nextProfiles[item.userId] = item;
          });

          const storedProfiles = readStoredTyperProfiles();
          const localProfile = user?.id ? storedProfiles[user.id] : null;
          const shouldRestoreLocalProfile =
            !!localProfile &&
            (!nextProfiles[user.id] || isAutoBackfilledTyperProfile(nextProfiles[user.id]));

          if (shouldRestoreLocalProfile) {
            nextProfiles[user.id] = localProfile;
          }

          const nextProfileList = Object.values(nextProfiles);
          setTyperProfiles(nextProfiles);
          setPlayers(
            nextProfileList.length
              ? nextProfileList.map((item) => profileToPlayer(item, currentDefaultChampionId))
              : INITIAL_PLAYERS
          );

          if (shouldRestoreLocalProfile) {
            try {
              const { profile: restoredProfile, backendReady: restoreBackendReady } = await upsertTyperProfile({
                userId: user.id,
                email: user.email || localProfile.email || "",
                nickname: localProfile.nickname,
                avatar: localProfile.avatar || { type: "default", id: FOOTBALL_AVATAR_OPTIONS[0].id },
                champion: localProfile.champion || champion || currentDefaultChampionId,
              });

              if (cancelled) return;
              setTyperBackendReady(restoreBackendReady);

              if (restoredProfile) {
                setTyperProfiles((current) => ({
                  ...current,
                  [restoredProfile.userId]: restoredProfile,
                }));
                setPlayers((current) => {
                  const restoredPlayer = profileToPlayer(restoredProfile, currentDefaultChampionId);
                  const withoutRestored = current.filter((item) => item.id !== restoredPlayer.id);
                  return [restoredPlayer, ...withoutRestored];
                });
              }
            } catch (restoreError) {
              if (!cancelled) {
                console.warn("Typer local profile restore:", restoreError.message);
              }
            }
          }
        }
      } catch (error) {
        if (cancelled) return;
        console.warn("Typer profiles sync:", error.message);
        setTyperNotice("Nie udało się pobrać rankingu z Supabase. Pokazuję lokalną wersję.");
      }
    }

    loadProfiles();

    return () => {
      cancelled = true;
    };
  }, [champion, currentDefaultChampionId, user?.email, user?.id]);

  useEffect(() => {
    if (!user?.id) return;
    let cancelled = false;

    async function loadPicks() {
      setTyperSyncing(true);
      try {
        const { picks: remotePicks, backendReady } = await fetchMyTyperPicks(user.id);
        if (cancelled) return;

        setTyperBackendReady(backendReady);
        setTyperNotice("");

        if (backendReady) {
          const localPicks = readStoredPicks();
          const { picks: nextPicks, missingLocalEntries } = mergeRemotePicksWithLocal(remotePicks, localPicks);
          setPicks(nextPicks);

          if (missingLocalEntries.length) {
            const results = await Promise.allSettled(
              missingLocalEntries.map(([matchId, pick]) => upsertTyperPick(user.id, matchId, pick))
            );
            const failedCount = results.filter(
              (result) => result.status === "rejected" || result.value?.backendReady === false
            ).length;

            if (!cancelled && failedCount > 0) {
              setTyperNotice(
                `Zachowałem lokalne typy, ale ${failedCount} z ${missingLocalEntries.length} nie zapisało się jeszcze w Supabase.`
              );
            } else if (!cancelled && countPicks(localPicks) > countPicks(remotePicks)) {
              setTyperNotice("Odtworzyłem lokalne typy w Supabase.");
            }
          }
        }
      } catch (error) {
        if (cancelled) return;
        console.warn("Typer picks sync:", error.message);
        setTyperNotice("Nie udało się pobrać typów z Supabase. Pokazuję lokalną wersję.");
      } finally {
        if (!cancelled) setTyperSyncing(false);
      }
    }

    loadPicks();

    return () => {
      cancelled = true;
    };
  }, [user?.id]);

  // Lekkie odświeżanie rankingu, żeby punkty innych graczy aktualizowały się po
  // zakończonych meczach (własne punkty liczą się i tak na bieżąco z typów).
  useEffect(() => {
    let cancelled = false;

    async function refreshRanking() {
      if (typeof document !== "undefined" && document.visibilityState !== "visible") return;
      try {
        const { profiles, backendReady } = await fetchTyperProfiles();
        if (cancelled || !backendReady) return;
        setPlayers(profiles.length ? profiles.map((item) => profileToPlayer(item)) : INITIAL_PLAYERS);
      } catch (error) {
        if (!cancelled) console.warn("Typer ranking refresh:", error.message);
      }
    }

    const interval = window.setInterval(refreshRanking, 120000);
    return () => {
      cancelled = true;
      window.clearInterval(interval);
    };
  }, []);

  const googleAvatarUrl = getGoogleAvatarUrl(user);
  const facebookAvatarUrl = getFacebookAvatarUrl(user);
  const googleDisplayName = getGoogleDisplayName(user);
  const facebookDisplayName = getFacebookDisplayName(user);
  const typerProfile = user?.id ? typerProfiles[user.id] : null;
  const accountDisplayName =
    profile?.display_name ||
    profile?.full_name ||
    profile?.name ||
    googleDisplayName ||
    facebookDisplayName ||
    getMetadataString(user?.user_metadata, ["display_name", "full_name", "name"]) ||
    "";
  const fallbackProfileName =
    getFirstName(accountDisplayName) ||
    user?.email?.split("@")[0] ||
    "Kibic MLPN";
  const profileName = typerProfile?.nickname || fallbackProfileName;
  const profileAvatar = typerProfile?.avatar || { type: "default", id: FOOTBALL_AVATAR_OPTIONS[0].id };
  const needsTyperProfile = !!user && !typerProfile;
  const scoredPickSummary = useMemo(() => summarizeScoredPicks(MATCHES, picks), [MATCHES, picks]);
  // Tymczasowe punkty zalogowanego gracza z trwających/świeżo zakończonych meczów
  // (jego typy znamy lokalnie). Reszta rankingu dostaje deltę live z RPC niżej.
  const myLiveDelta = useMemo(
    () => liveDeltaForPicks(MATCHES, picks, liveByMatchId),
    [MATCHES, picks, liveByMatchId]
  );
  const currentTyperPlayer = useMemo(() => {
    if (!user?.id || !typerProfile) return null;

    const useMatchScoring = scoredPickSummary.items.length > 0;
    const basePoints = useMatchScoring ? scoredPickSummary.points : typerProfile.points || 0;
    const baseExact = useMatchScoring ? scoredPickSummary.exact : typerProfile.exact || 0;
    const baseResult = useMatchScoring ? scoredPickSummary.result : typerProfile.result || 0;
    const baseAdvance = useMatchScoring ? scoredPickSummary.advance : typerProfile.advance || 0;

    return {
      id: `site-${user.id}`,
      userId: user.id,
      name: typerProfile.nickname,
      avatar: typerProfile.avatar,
      points: basePoints + myLiveDelta.points,
      exact: baseExact + myLiveDelta.exact,
      result: baseResult + myLiveDelta.result,
      advance: baseAdvance + myLiveDelta.advance,
      livePoints: myLiveDelta.points,
      champion: typerProfile.champion || "",
      warnings: typerProfile.warnings || 0,
      status: typerProfile.status || "approved",
      isCurrentUser: true,
    };
  }, [user?.id, typerProfile, champion, scoredPickSummary, myLiveDelta]);

  // Pełny ranking na żywo dla WSZYSTKICH graczy: RPC liczy tymczasowe punkty po
  // stronie bazy (cudze typy nie są ujawniane). Działa po wgraniu migracji 028;
  // bez niej ranking i tak działa, tylko inni gracze nie ruszają się na żywo.
  const [liveLeaderboard, setLiveLeaderboard] = useState({});
  useEffect(() => {
    let cancelled = false;

    const liveScores = MATCHES.filter((match) => getLiveResult(match, liveByMatchId)).map((match) => {
      const live = liveByMatchId[match.id];
      return { match_id: match.id, home_score: live.home, away_score: live.away };
    });

    if (!liveScores.length) {
      setLiveLeaderboard((current) => (Object.keys(current).length ? {} : current));
      return undefined;
    }

    (async () => {
      try {
        const { deltas, backendReady } = await fetchLiveLeaderboard(liveScores);
        if (cancelled || !backendReady) return;
        setLiveLeaderboard(deltas);
      } catch (error) {
        if (!cancelled) console.warn("Typer live leaderboard:", error.message);
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [MATCHES, liveByMatchId]);

  const activePlayers = useMemo(() => {
    const basePlayers = players.filter((player) => player.status !== "banned");
    const mergedPlayers = currentTyperPlayer
      ? [currentTyperPlayer, ...basePlayers.filter((player) => player.id !== currentTyperPlayer.id)]
      : basePlayers;

    // Dolicz deltę live z RPC (poza zalogowanym graczem — jego liczymy lokalnie).
    const withLive = mergedPlayers.map((player) => {
      if (player.isCurrentUser) return player;
      const delta = liveLeaderboard[player.userId];
      if (!delta || !delta.points) return player;
      return {
        ...player,
        points: (player.points || 0) + delta.points,
        exact: (player.exact || 0) + (delta.exact || 0),
        result: (player.result || 0) + (delta.result || 0),
        advance: (player.advance || 0) + (delta.advance || 0),
        livePoints: delta.points,
      };
    });

    return withLive
      .slice()
      .sort((a, b) => b.points - a.points || b.exact - a.exact || String(a.name).localeCompare(String(b.name), "pl"));
  }, [players, currentTyperPlayer, liveLeaderboard]);

  const rankingPageCount = Math.max(1, Math.ceil(activePlayers.length / RANKING_PAGE_SIZE));
  const currentRankingPage = Math.min(Math.max(rankingPage, 1), rankingPageCount);
  const rankingPageStart = (currentRankingPage - 1) * RANKING_PAGE_SIZE;
  const pagedRankingPlayers = activePlayers.slice(rankingPageStart, rankingPageStart + RANKING_PAGE_SIZE);
  const currentUserRankIndex = user?.id
    ? activePlayers.findIndex((player) => player.userId === user.id || player.isCurrentUser)
    : -1;
  const currentUserRank = currentUserRankIndex >= 0 ? currentUserRankIndex + 1 : null;
  const currentUserRankingPlayer = currentUserRankIndex >= 0 ? activePlayers[currentUserRankIndex] : null;

  useEffect(() => {
    setRankingPage((page) => Math.min(Math.max(page, 1), rankingPageCount));
  }, [rankingPageCount]);

  useEffect(() => {
    if (!user) {
      setProfileSetupOpen(false);
      setSetupError("");
      return;
    }

    if (typerProfile && !profileSetupOpen) return;
    if (!typerProfile && !profileSetupOpen) {
      setProfileSetupOpen(true);
    }

    setNicknameDraft(typerProfile?.nickname || fallbackProfileName);
    setAvatarDraft(typerProfile?.avatar || { type: "default", id: FOOTBALL_AVATAR_OPTIONS[0].id });
    setSetupError("");
  }, [user, typerProfile, profileSetupOpen, fallbackProfileName]);

  // Po zalogowaniu wczytaj zapisany typ na mistrza, żeby selektor i ranking
  // pokazywały realny wybór gracza, a nie domyślną drużynę.
  useEffect(() => {
    if (typerProfile?.champion) {
      setChampion(typerProfile.champion);
    }
  }, [typerProfile?.champion]);

  const availablePickMatches = useMemo(
    () => MATCHES.filter((match) => isMatchInPickWindow(match, windowNow)),
    [MATCHES, windowNow]
  );
  const defaultMatchSegmentId = getCurrentScheduleSegmentId(MATCH_SCHEDULE_SEGMENTS, windowNow);
  const selectedMatchSegmentId = MATCH_SCHEDULE_SEGMENTS.some((segment) => segment.id === matchSegmentId)
    ? matchSegmentId
    : defaultMatchSegmentId;
  const selectedMatchSegmentIndex = Math.max(
    0,
    MATCH_SCHEDULE_SEGMENTS.findIndex((segment) => segment.id === selectedMatchSegmentId)
  );
  const selectedMatchSegment = MATCH_SCHEDULE_SEGMENTS[selectedMatchSegmentIndex] || null;
  const selectedScheduleMatches = selectedMatchSegment?.matches || [];
  const changeMatchSegment = (direction) => {
    if (!MATCH_SCHEDULE_SEGMENTS.length) return;
    const nextIndex = Math.min(
      Math.max(selectedMatchSegmentIndex + direction, 0),
      MATCH_SCHEDULE_SEGMENTS.length - 1
    );
    setMatchSegmentId(MATCH_SCHEDULE_SEGMENTS[nextIndex].id);
  };
  const nextKnownMatch = useMemo(
    () =>
      MATCHES.find((match) => {
        const kickoffMs = getKickoffMs(match);
        return kickoffMs !== null && kickoffMs > windowNow && hasKnownTeams(match);
      }) || null,
    [MATCHES, windowNow]
  );
  const pickWindowEndLabel = formatKickoff(new Date(windowNow + PICK_WINDOW_MS).toISOString());
  const featuredMatch = availablePickMatches[0] || nextKnownMatch || VISIBLE_SCHEDULE_MATCHES[0];
  const authBusy = !!authProviderLoading || emailAuthLoading;

  const handleSocialLogin = async (provider) => {
    setAuthError("");
    setAuthProviderLoading(provider);

    try {
      await signInWithProvider(provider, { next: "#/typer" });
    } catch (error) {
      const providerLabel = provider === "facebook" ? "Facebook" : "Google";
      const message = error?.message || "";
      const lowerMessage = message.toLowerCase();
      const isProviderDisabled =
        lowerMessage.includes("provider") ||
        lowerMessage.includes("unsupported") ||
        lowerMessage.includes("not enabled");

      setAuthError(
        isProviderDisabled
          ? `Logowanie przez ${providerLabel} nie jest jeszcze aktywne w Supabase.`
          : `Nie udało się uruchomić logowania przez ${providerLabel}. Spróbuj ponownie.`
      );
      setAuthProviderLoading(null);
    }
  };

  const handleEmailLogin = async (event) => {
    event.preventDefault();
    setAuthError("");

    const email = emailLoginEmail.trim();
    if (!email || !emailLoginPassword) {
      setAuthError("Wpisz e-mail i hasło do istniejącego konta MLPN.");
      return;
    }

    setEmailAuthLoading(true);
    try {
      await signIn(email, emailLoginPassword);
      setEmailLoginPassword("");
      setTab("picks");
    } catch (error) {
      const message = error?.message || "";
      const isInvalidLogin =
        message.toLowerCase().includes("invalid") ||
        message.toLowerCase().includes("credentials") ||
        message.toLowerCase().includes("login");

      setAuthError(
        isInvalidLogin
          ? "Nie udało się zalogować. Sprawdź e-mail i hasło."
          : "Nie udało się zalogować kontem e-mail. Spróbuj ponownie."
      );
    } finally {
      setEmailAuthLoading(false);
    }
  };

  const handleAvatarUpload = async (file) => {
    if (!user?.id) return null;

    const { publicUrl, backendReady } = await uploadTyperAvatar(user.id, file);
    setTyperBackendReady(backendReady);

    if (!backendReady) {
      return null;
    }

    if (!publicUrl) return null;
    return { type: "upload", url: publicUrl };
  };

  const saveTyperProfile = async () => {
    if (!user?.id) return;

    const nickname = nicknameDraft.trim().replace(/\s+/g, " ");
    if (nickname.length < 3) {
      setSetupError("Nick musi mieć minimum 3 znaki.");
      return;
    }

    if (nickname.length > 28) {
      setSetupError("Nick może mieć maksymalnie 28 znaków.");
      return;
    }

    const avatar = avatarDraft?.type ? avatarDraft : { type: "default", id: FOOTBALL_AVATAR_OPTIONS[0].id };

    setTyperSyncing(true);
    try {
      const { profile: savedProfile, backendReady } = await upsertTyperProfile({
        userId: user.id,
        email: user.email || "",
        nickname,
        avatar,
        champion,
      });

      const nextProfile =
        savedProfile ||
        {
          userId: user.id,
          nickname,
          avatar,
          email: user.email || "",
          champion,
          status: "approved",
          warnings: 0,
          points: 0,
          exact: 0,
          result: 0,
          advance: 0,
          updatedAt: new Date().toISOString(),
        };

      setTyperBackendReady(backendReady);
      setTyperNotice("");
      setTyperProfiles((current) => ({
        ...current,
        [user.id]: nextProfile,
      }));
      if (backendReady) {
        setPlayers((current) => {
          const nextPlayer = profileToPlayer(nextProfile, champion);
          const withoutCurrent = current.filter((player) => player.id !== nextPlayer.id);
          return [nextPlayer, ...withoutCurrent];
        });
      }
      setNicknameDraft(nickname);
      setSetupError("");
      setProfileSetupOpen(false);
      setTab("picks");
    } catch (error) {
      const message = String(error?.message || "");
      if (message.toLowerCase().includes("duplicate") || message.toLowerCase().includes("unique")) {
        setSetupError("Ten nick jest już zajęty. Wybierz inny.");
      } else {
        setSetupError(message || "Nie udało się zapisać profilu typera.");
      }
    } finally {
      setTyperSyncing(false);
    }
  };

  const persistPick = async (matchId, pick) => {
    if (!user?.id || !typerProfile) return;

    try {
      const { backendReady } = await upsertTyperPick(user.id, matchId, pick);
      setTyperBackendReady(backendReady);
      setTyperNotice("");
    } catch (error) {
      console.warn("Typer pick save:", error.message);
      setTyperNotice("Nie udało się zapisać typu w Supabase. Typ zostaje lokalnie w przeglądarce.");
    }
  };

  const updatePick = (matchId, patch) => {
    let nextPick = null;
    setPicks((current) => {
      const previous = current[matchId] || { home: 0, away: 0, confirmed: false };
      nextPick = {
        ...previous,
        ...patch,
        confirmed: patch.confirmed ?? false,
      };
      const next = {
        ...current,
        [matchId]: nextPick,
      };
      return next;
    });
    if (nextPick) persistPick(matchId, nextPick);
  };

  const confirmPick = (matchId) => {
    let nextPick = null;
    setPicks((current) => ({
      ...current,
      [matchId]: (nextPick = {
        ...(current[matchId] || { home: 0, away: 0 }),
        confirmed: true,
      }),
    }));
    if (nextPick) persistPick(matchId, nextPick);
  };

  const clearPick = (matchId) => {
    setPicks((current) => {
      const next = { ...current };
      delete next[matchId];
      return next;
    });
    if (user?.id && typerProfile) {
      deleteTyperPick(user.id, matchId).then(({ backendReady }) => {
        setTyperBackendReady(backendReady);
        setTyperNotice("");
      }).catch((error) => {
        console.warn("Typer pick delete:", error.message);
        setTyperNotice("Nie udało się usunąć typu z Supabase. Został usunięty lokalnie.");
      });
    }
  };

  const updateChampion = async (teamId) => {
    setChampion(teamId);
    if (!user?.id || !typerProfile) return;

    const nextProfile = { ...typerProfile, champion: teamId };
    setTyperProfiles((current) => ({
      ...current,
      [user.id]: nextProfile,
    }));

    try {
      const { profile: savedProfile, backendReady } = await upsertTyperProfile({
        userId: user.id,
        email: user.email || typerProfile.email || "",
        nickname: typerProfile.nickname,
        avatar: typerProfile.avatar,
        champion: teamId,
      });

      setTyperBackendReady(backendReady);
      setTyperNotice("");
      if (savedProfile) {
        setTyperProfiles((current) => ({
          ...current,
          [user.id]: savedProfile,
        }));
      }
    } catch (error) {
      console.warn("Typer champion save:", error.message);
      setTyperNotice("Nie udało się zapisać mistrza w Supabase. Wybór zostaje lokalnie.");
    }
  };

  const mutatePlayer = (playerId, updater, logText) => {
    setPlayers((current) =>
      current.map((player) => (player.id === playerId ? updater(player) : player))
    );
    if (logText) setModerationLog((current) => [logText, ...current].slice(0, 8));
  };

  const persistModeration = async (player, patch, action, reason) => {
    if (!player?.userId) return;

    try {
      const { profile: savedProfile, backendReady } = await updateTyperProfileModeration(
        player.userId,
        patch,
        action,
        reason
      );

      setTyperBackendReady(backendReady);
      setTyperNotice("");

      if (savedProfile) {
        const savedPlayer = profileToPlayer(savedProfile, champion);
        setTyperProfiles((current) => ({
          ...current,
          [savedProfile.userId]: savedProfile,
        }));
        setPlayers((current) =>
          current.map((item) => (item.userId === savedProfile.userId ? savedPlayer : item))
        );
      }
    } catch (error) {
      console.warn("Typer moderation:", error.message);
      setTyperNotice("Akcja moderacji została pokazana lokalnie, ale nie zapisała się w Supabase.");
    }
  };

  const getAdminNicknameDraft = (player) => adminNicknameDrafts[player.id] ?? player.name ?? "";
  const setAdminNicknameDraft = (playerId, value) => {
    setAdminModerationError("");
    setAdminNicknameDrafts((current) => ({
      ...current,
      [playerId]: value,
    }));
  };

  const saveAdminNickname = (player) => {
    if (!isAdmin || !player || player.status === "banned") return;

    const nextName = getAdminNicknameDraft(player).trim().replace(/\s+/g, " ");
    if (nextName.length < 3) {
      setAdminModerationError("Nick musi mieć minimum 3 znaki.");
      return;
    }

    if (nextName.length > 28) {
      setAdminModerationError("Nick może mieć maksymalnie 28 znaków.");
      return;
    }

    const duplicate = players.some(
      (item) => item.id !== player.id && String(item.name).trim().toLowerCase() === nextName.toLowerCase()
    );
    if (duplicate) {
      setAdminModerationError("Ten nick jest już zajęty przez innego gracza.");
      return;
    }

    const nextStatus = player.status === "blocked" || player.status === "warning" ? "approved" : player.status;
    mutatePlayer(
      player.id,
      (current) => ({ ...current, name: nextName, status: nextStatus }),
      `${player.name}: nick zmieniony przez administratora.`
    );
    setAdminNicknameDrafts((current) => {
      const next = { ...current };
      delete next[player.id];
      return next;
    });
    setAdminModerationError("");
    persistModeration(
      player,
      { nickname: nextName, status: nextStatus },
      "reset_nick",
      "Zmiana nicku przez administratora."
    );
  };

  const warnPlayer = (player) => {
    if (!isAdmin || !player || player.status === "banned") return;

    const warnings = Number(player.warnings || 0) + 1;
    const nextStatus = warnings >= 3 ? "banned" : warnings >= 2 ? "blocked" : "warning";

    mutatePlayer(
      player.id,
      (current) => ({
        ...current,
        warnings,
        status: nextStatus,
      }),
      `${player.name} otrzymał ostrzeżenie za naruszenie zasad nicku.`
    );
    persistModeration(
      player,
      {
        warnings_count: warnings,
        status: nextStatus,
        banned_at: nextStatus === "banned" ? new Date().toISOString() : null,
      },
      "warn",
      "Ostrzeżenie za naruszenie zasad nicku."
    );
  };

  const resetNick = (player) => {
    if (!isAdmin || !player || player.status === "banned") return;

    const nextName = `Użytkownik ${String(player.userId || player.id).slice(0, 8).toUpperCase()}`;
    mutatePlayer(
      player.id,
      (current) => ({ ...current, name: nextName }),
      `${player.name}: nick zresetowany do nazwy technicznej.`
    );
    setAdminNicknameDrafts((current) => {
      const next = { ...current };
      delete next[player.id];
      return next;
    });
    setAdminModerationError("");
    persistModeration(
      player,
      { nickname: nextName, status: player.status },
      "reset_nick",
      "Reset nicku przez administratora."
    );
  };

  const banPlayer = (player) => {
    if (!isAdmin || !player) return;

    mutatePlayer(
      player.id,
      (current) => ({ ...current, status: "banned" }),
      `${player.name} został zbanowany i wykluczony z rankingu.`
    );
    persistModeration(player, { status: "banned", banned_at: new Date().toISOString() }, "ban", "Ban w typerze.");
  };

  const unbanPlayer = (player) => {
    if (!isAdmin || !player) return;

    const warnings = Math.min(Number(player.warnings || 0), 2);
    mutatePlayer(
      player.id,
      (current) => ({ ...current, status: "approved", warnings }),
      `${player.name} został odblokowany przez administratora.`
    );
    persistModeration(
      player,
      { status: "approved", warnings_count: warnings, banned_at: null },
      "unban",
      "Odblokowanie przez administratora."
    );
  };

  const tabs = [
    { id: "ranking", label: "Ranking", icon: <Medal size={16} /> },
    { id: "matches", label: "Mecze", icon: <Calendar size={16} /> },
    { id: "picks", label: "Moje typy", icon: <Save size={16} /> },
    { id: "profile", label: "Profil", icon: <User size={16} /> },
    { id: "rules", label: "Regulamin", icon: <FileText size={16} /> },
    ...(isAdmin ? [{ id: "admin", label: "Admin", icon: <ShieldAlert size={16} /> }] : []),
  ];

  useEffect(() => {
    if (tab === "admin" && !isAdmin) {
      setTab("ranking");
    }
  }, [tab, isAdmin]);

  return (
    <main className="space-y-4">
      <section
        className={cx(
          "relative overflow-hidden rounded-3xl border p-4 md:p-5 e3d-card",
          darkMode
            ? "border-white/10 bg-[radial-gradient(circle_at_top_left,rgba(23,216,255,0.20),transparent_34%),linear-gradient(135deg,#0b1628,#111827_58%,#240f16)]"
            : "border-gray-200 bg-[radial-gradient(circle_at_top_left,rgba(23,216,255,0.24),transparent_34%),linear-gradient(135deg,#ffffff,#f5f7fb_58%,#ffe9e9)]"
        )}
      >
        <div className="relative z-10 grid gap-4 lg:grid-cols-[1fr_340px] lg:items-end">
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <img src={logoUrl} alt="MLPN" className="h-14 w-14 rounded-2xl object-contain e3d-logo" />
              <div>
                <div className="text-[11px] font-black uppercase tracking-[0.2em] text-sky-300">
                  MLPN Typer
                </div>
                <h1 className="text-3xl font-black leading-tight md:text-5xl">
                  Typer MŚ 2026
                </h1>
              </div>
            </div>

            <div className={cx("max-w-3xl text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
              Gra o punkty i nagrodę od ligi. Publiczny ranking, typy meczów, wybór mistrza
              oraz emocje turnieju w jednym module.
            </div>

            <div className="flex flex-wrap gap-2">
              <Pill darkMode={darkMode} tone="good"><Trophy size={13} /> Nagroda od ligi</Pill>
              <Pill darkMode={darkMode} tone="info"><Calendar size={13} /> {MATCHES.length} meczów z terminarza</Pill>
              <Pill darkMode={darkMode} tone="info"><Users size={13} /> {activePlayers.length} graczy w rankingu</Pill>
              <Pill darkMode={darkMode} tone="warn"><Clock size={13} /> Blokada 5 min przed meczem</Pill>
            </div>
          </div>

          <div
            className={cx(
              "rounded-2xl border p-3",
              darkMode ? "border-white/10 bg-black/20" : "border-white/70 bg-white/75"
            )}
          >
            <div className="text-xs font-black uppercase tracking-[0.16em] opacity-70">
              Następny typ
            </div>
            {featuredMatch ? (
              <>
                <div className="mt-3 grid grid-cols-[1fr_auto_1fr] items-center gap-2">
                  <TeamBadge id={featuredMatch.home} align="left" />
                  <div className="text-xs font-black uppercase opacity-60">vs</div>
                  <TeamBadge id={featuredMatch.away} align="right" />
                </div>
                <div className="mt-3 flex items-center justify-between gap-2 text-xs font-bold opacity-80">
                  <span>{featuredMatch.kickoffLabel}</span>
                  <span>{featuredMatch.group ? `Grupa ${featuredMatch.group}` : featuredMatch.stage}</span>
                </div>
              </>
            ) : (
              <div className="mt-3 rounded-xl border border-white/10 bg-white/5 p-3 text-sm opacity-80">
                Brak wczytanego terminarza.
              </div>
            )}
          </div>
        </div>
      </section>

      <div className="mlpn-typer-scrollbar grid grid-cols-6 gap-1.5 sm:flex sm:gap-2 sm:overflow-x-auto sm:pb-1">
        {tabs.map((item) => (
          <button
            key={item.id}
            type="button"
            onClick={() => setTab(item.id)}
            aria-label={item.label}
            title={item.label}
            className={cx(
              "inline-flex min-h-[44px] items-center justify-center rounded-2xl border text-sm font-black transition-colors e3d-tab sm:shrink-0 sm:gap-2 sm:px-3.5",
              tab === item.id
                ? "border-red-400/40 bg-red-500 text-white"
                : darkMode
                ? "border-white/10 bg-white/5 text-gray-200 hover:bg-white/10"
                : "border-gray-200 bg-white text-gray-800 hover:bg-gray-50"
            )}
          >
            {item.icon}
            <span className="hidden sm:inline">{item.label}</span>
          </button>
        ))}
      </div>

      {(typerNotice || typerSyncing) && (
        <div
          className={cx(
            "rounded-2xl border px-4 py-3 text-sm font-bold",
            darkMode
              ? "border-sky-400/25 bg-sky-400/10 text-sky-100"
              : "border-sky-200 bg-sky-50 text-sky-900"
          )}
        >
          {typerSyncing ? "Synchronizuję typera z Supabase..." : typerNotice}
        </div>
      )}

      <TyperLiveMatches
        matches={MATCHES}
        picks={picks}
        darkMode={darkMode}
        espnEvents={espnEvents}
        updatedAt={liveUpdatedAt}
      />

      {tab === "ranking" && (
        <div className="grid gap-4 lg:grid-cols-[1fr_320px]">
          <div className="space-y-3">
            <Card darkMode={darkMode}>
              {currentUserRankingPlayer ? (
                <div className="grid gap-3 md:grid-cols-[1fr_auto] md:items-center">
                  <div className="flex min-w-0 items-center gap-3">
                    <AvatarPreview avatar={currentUserRankingPlayer.avatar} name={currentUserRankingPlayer.name} size="sm" />
                    <div className="min-w-0">
                      <div className="text-xs font-black uppercase tracking-[0.16em] opacity-60">Twoja pozycja</div>
                      <div className="mt-1 flex flex-wrap items-center gap-2">
                        <span className="text-2xl font-black tabular-nums">#{currentUserRank}</span>
                        <span className="truncate text-lg font-black">{currentUserRankingPlayer.name}</span>
                      </div>
                    </div>
                  </div>
                  <div className="grid grid-cols-4 gap-2 text-center">
                    <div>
                      <div className="text-2xl font-black tabular-nums">{currentUserRankingPlayer.points}</div>
                      <div className="text-[10px] font-black uppercase opacity-60">pkt</div>
                    </div>
                    <div>
                      <div className="text-2xl font-black tabular-nums">{currentUserRankingPlayer.exact}</div>
                      <div className="text-[10px] font-black uppercase opacity-60">dokł.</div>
                    </div>
                    <div>
                      <div className="text-2xl font-black tabular-nums">{currentUserRankingPlayer.result}</div>
                      <div className="text-[10px] font-black uppercase opacity-60">rez.</div>
                    </div>
                    <div>
                      <div className="text-2xl font-black tabular-nums">{currentUserRankingPlayer.advance}</div>
                      <div className="text-[10px] font-black uppercase opacity-60">awans</div>
                    </div>
                  </div>
                </div>
              ) : (
                <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                  <div>
                    <div className="font-black">Nie ma Cię jeszcze w rankingu</div>
                    <div className={cx("mt-1 text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                      Zaloguj się i dołącz do typera, żeby widzieć tutaj swoje miejsce i punkty.
                    </div>
                  </div>
                  <button
                    type="button"
                    onClick={() => setTab("picks")}
                    className="inline-flex min-h-[42px] items-center justify-center rounded-xl border border-emerald-300 bg-emerald-400 px-4 text-sm font-black text-black transition-colors hover:brightness-105"
                  >
                    Przejdź do typera
                  </button>
                </div>
              )}
            </Card>

            <Card darkMode={darkMode} className="overflow-hidden p-0">
              <div className="flex flex-col gap-2 border-b border-white/10 px-4 py-3 sm:flex-row sm:items-center sm:justify-between">
                <div className="flex items-center gap-2">
                  <span className="text-lg font-black">Ranking</span>
                  {liveMatchCount > 0 && (
                    <span className="inline-flex items-center gap-1.5 rounded-full bg-red-500/15 px-2 py-0.5 text-[11px] font-black uppercase tracking-wide text-red-500">
                      <span className="relative flex h-2 w-2">
                        <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-red-500 opacity-75" />
                        <span className="relative inline-flex h-2 w-2 rounded-full bg-red-500" />
                      </span>
                      Na żywo
                    </span>
                  )}
                </div>
                <Pill darkMode={darkMode} tone="info">
                  {activePlayers.length ? `${rankingPageStart + 1}-${Math.min(rankingPageStart + RANKING_PAGE_SIZE, activePlayers.length)}` : "0"} z {activePlayers.length}
                </Pill>
              </div>
              <div className="min-w-0 overflow-hidden md:mlpn-typer-scrollbar md:overflow-x-auto">
                <div className="min-w-0 md:min-w-[720px]">
                  <div className="grid grid-cols-[34px_minmax(0,1fr)_58px] gap-2 border-b border-white/10 px-3 py-3 text-[10px] font-black uppercase tracking-[0.08em] opacity-70 md:grid-cols-[52px_1fr_86px_72px_72px_72px] md:px-4 md:text-xs md:tracking-[0.12em]">
                    <div>#</div>
                    <div>Gracz</div>
                    <div className="text-right md:text-left">Pkt</div>
                    <div className="hidden md:block">Dokł.</div>
                    <div className="hidden md:block">Rez.</div>
                    <div className="hidden md:block">Awans</div>
                  </div>
                  {pagedRankingPlayers.map((player, index) => (
                    <div
                      key={player.id}
                      className={cx(
                        "grid grid-cols-[34px_minmax(0,1fr)_58px] gap-2 border-b border-white/10 px-3 py-3 last:border-b-0 md:grid-cols-[52px_1fr_86px_72px_72px_72px] md:px-4",
                        player.isCurrentUser && (darkMode ? "bg-emerald-400/10" : "bg-emerald-50"),
                        darkMode ? "hover:bg-white/[0.04]" : "hover:bg-gray-50"
                      )}
                    >
                      <div className="flex items-center font-black">{rankingPageStart + index + 1}</div>
                      <div className="flex min-w-0 items-center gap-3">
                        {player.avatar && typeof player.avatar === "object" ? (
                          <AvatarPreview avatar={player.avatar} name={player.name} size="xs" />
                        ) : (
                          <div className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-gradient-to-br from-red-500 to-sky-500 text-sm font-black text-white">
                            {player.avatar}
                          </div>
                        )}
                        <div className="min-w-0">
                          <div className="flex min-w-0 items-center gap-1.5 md:gap-2">
                            <span className="min-w-0 truncate font-black">{player.name}</span>
                            {player.isCurrentUser && (
                              <Pill darkMode={darkMode} tone="good" className="shrink-0 px-2 py-0.5">Ty</Pill>
                            )}
                            {player.isPlaceholder && (
                              <Pill darkMode={darkMode} tone="neutral" className="shrink-0 px-2 py-0.5">konto strony</Pill>
                            )}
                          </div>
                          <div className="flex min-w-0 items-center gap-1.5 text-xs opacity-70">
                            <Crown size={12} />
                            <span className="min-w-0 truncate">
                              {player.champion ? team(player.champion).name : "nie wybrano mistrza"}
                            </span>
                          </div>
                        </div>
                      </div>
                      <div className="flex items-center justify-end gap-1.5 text-xl font-black tabular-nums md:justify-start">
                        {player.points}
                        {player.livePoints > 0 && (
                          <span className="rounded-full bg-red-500/15 px-1.5 py-0.5 text-[10px] font-black text-red-500">
                            +{player.livePoints}
                          </span>
                        )}
                      </div>
                      <div className="hidden items-center tabular-nums md:flex">{player.exact}</div>
                      <div className="hidden items-center tabular-nums md:flex">{player.result}</div>
                      <div className="hidden items-center tabular-nums md:flex">{player.advance}</div>
                    </div>
                  ))}
                </div>
              </div>
              <div className="flex flex-col gap-2 border-t border-white/10 px-4 py-3 sm:flex-row sm:items-center sm:justify-between">
                <div className="text-sm font-bold opacity-70">
                  Strona {currentRankingPage} / {rankingPageCount}
                </div>
                <div className="flex gap-2">
                  <button
                    type="button"
                    disabled={currentRankingPage <= 1}
                    onClick={() => setRankingPage((page) => Math.max(1, page - 1))}
                    className={cx(
                      "min-h-[40px] rounded-xl border px-3 text-sm font-black transition-colors",
                      currentRankingPage <= 1
                        ? "cursor-not-allowed opacity-45"
                        : darkMode
                        ? "border-white/10 bg-white/5 hover:bg-white/10"
                        : "border-gray-200 bg-white hover:bg-gray-50"
                    )}
                  >
                    Poprzednia
                  </button>
                  <button
                    type="button"
                    disabled={currentRankingPage >= rankingPageCount}
                    onClick={() => setRankingPage((page) => Math.min(rankingPageCount, page + 1))}
                    className={cx(
                      "min-h-[40px] rounded-xl border px-3 text-sm font-black transition-colors",
                      currentRankingPage >= rankingPageCount
                        ? "cursor-not-allowed opacity-45"
                        : darkMode
                        ? "border-white/10 bg-white/5 hover:bg-white/10"
                        : "border-gray-200 bg-white hover:bg-gray-50"
                    )}
                  >
                    Następna
                  </button>
                </div>
              </div>
            </Card>
          </div>

          <Card darkMode={darkMode} className="overflow-hidden">
            <div className="flex items-center gap-2 text-lg font-black">
              <Eye size={19} />
              Widoczność typów
            </div>
            <div className={cx("mt-3 max-w-full break-words text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-600")}>
              Ranking jest publiczny, ale cudze typy pokazujemy dopiero po rozpoczęciu danego meczu.
              To zabezpiecza uczciwą grę i pasuje do zasad z dokumentu projektu.
            </div>
            <div className="mt-4 grid min-w-0 gap-2">
              <Pill darkMode={darkMode} tone="good" className="w-full justify-start"><CheckCircle2 size={13} className="shrink-0" /> <span className="min-w-0 truncate">Typ zawsze liczy się po autozapisie</span></Pill>
              <Pill darkMode={darkMode} tone="info" className="w-full justify-start"><Lock size={13} className="shrink-0" /> <span className="min-w-0 truncate">Cudze typy po starcie meczu</span></Pill>
              <Pill darkMode={darkMode} tone="warn" className="w-full justify-start"><AlertTriangle size={13} className="shrink-0" /> <span className="min-w-0 truncate">Ban = poza rankingiem</span></Pill>
            </div>
          </Card>
        </div>
      )}

      {tab === "matches" && (
        <div className="space-y-4">
          <Card darkMode={darkMode} className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <div className="text-xl font-black">Terminarz i tabele</div>
              <div className={cx("text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                Mecze są podzielone na kolejki i fazy. Nie pokazujemy par, w których nie znamy jeszcze drużyn.
              </div>
            </div>
            <div className="grid grid-cols-2 rounded-2xl border border-white/10 bg-black/10 p-1">
              {[
                ["date", "Terminarz"],
                ["group", "Tabele grup"],
              ].map(([id, label]) => (
                <button
                  key={id}
                  type="button"
                  onClick={() => setMatchView(id)}
                  className={cx(
                    "rounded-xl px-4 py-2 text-sm font-black",
                    matchView === id ? "bg-white text-gray-900" : darkMode ? "text-gray-200" : "text-gray-700"
                  )}
                >
                  {label}
                </button>
              ))}
            </div>
          </Card>

          {matchView === "date" && (
            <Card darkMode={darkMode} className="space-y-3">
              <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                <div>
                  <div className="text-lg font-black">
                    {selectedMatchSegment?.label || "Terminarz"}
                  </div>
                  <div className={cx("text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                    {selectedMatchSegment?.eyebrow || "Mecze"} · {selectedScheduleMatches.length} spotkań
                  </div>
                </div>
                <div className="flex flex-wrap gap-2">
                  <Pill darkMode={darkMode} tone="good">
                    {VISIBLE_SCHEDULE_MATCHES.length} znanych par
                  </Pill>
                  {HIDDEN_UNKNOWN_MATCHES_COUNT > 0 && (
                    <Pill darkMode={darkMode} tone="warn">
                      {HIDDEN_UNKNOWN_MATCHES_COUNT} ukrytych do czasu ustalenia
                    </Pill>
                  )}
                </div>
              </div>

              <div className="mlpn-typer-scrollbar flex gap-2 overflow-x-auto pb-1">
                {MATCH_SCHEDULE_SEGMENTS.map((segment) => (
                  <button
                    key={segment.id}
                    type="button"
                    onClick={() => setMatchSegmentId(segment.id)}
                    className={cx(
                      "inline-flex min-h-[42px] shrink-0 items-center rounded-xl border px-3 text-left text-xs font-black transition-colors",
                      selectedMatchSegmentId === segment.id
                        ? "border-sky-300 bg-sky-400 text-black"
                        : darkMode
                        ? "border-white/10 bg-white/5 text-gray-100 hover:bg-white/10"
                        : "border-gray-200 bg-white text-gray-800 hover:bg-gray-50"
                    )}
                  >
                    <span className="block">{segment.label}</span>
                  </button>
                ))}
              </div>

              <div className="flex items-center justify-between gap-2">
                <button
                  type="button"
                  disabled={selectedMatchSegmentIndex <= 0}
                  onClick={() => changeMatchSegment(-1)}
                  className={cx(
                    "min-h-[40px] rounded-xl border px-3 text-sm font-black transition-colors",
                    selectedMatchSegmentIndex <= 0
                      ? "cursor-not-allowed opacity-45"
                      : darkMode
                      ? "border-white/10 bg-white/5 hover:bg-white/10"
                      : "border-gray-200 bg-white hover:bg-gray-50"
                  )}
                >
                  Poprzednia
                </button>
                <div className="text-sm font-bold opacity-70">
                  {MATCH_SCHEDULE_SEGMENTS.length ? selectedMatchSegmentIndex + 1 : 0} / {MATCH_SCHEDULE_SEGMENTS.length}
                </div>
                <button
                  type="button"
                  disabled={selectedMatchSegmentIndex >= MATCH_SCHEDULE_SEGMENTS.length - 1}
                  onClick={() => changeMatchSegment(1)}
                  className={cx(
                    "min-h-[40px] rounded-xl border px-3 text-sm font-black transition-colors",
                    selectedMatchSegmentIndex >= MATCH_SCHEDULE_SEGMENTS.length - 1
                      ? "cursor-not-allowed opacity-45"
                      : darkMode
                      ? "border-white/10 bg-white/5 hover:bg-white/10"
                      : "border-gray-200 bg-white hover:bg-gray-50"
                  )}
                >
                  Następna
                </button>
              </div>
            </Card>
          )}

          {matchView === "date" ? (
            <div className="grid gap-3">
              {selectedScheduleMatches.map((match) => {
                const pick = user && !needsTyperProfile ? picks[match.id] : null;
                const scored = match.result && pick ? scorePick(match, pick) : null;

                return (
                  <Card key={match.id} darkMode={darkMode}>
                    {match.result ? (
                      <div className="grid gap-2">
                        <div className="hidden md:grid md:grid-cols-[minmax(0,1fr)_120px_minmax(0,1fr)_auto] md:items-center md:gap-4">
                          <TeamBadge id={match.home} />
                          <div className="text-center">
                            <div
                              className={cx(
                                "mx-auto inline-flex min-h-[50px] min-w-[82px] items-center justify-center rounded-2xl border px-4 text-2xl font-black tabular-nums",
                                darkMode ? "border-white/10 bg-white/10" : "border-gray-200 bg-gray-50"
                              )}
                            >
                              {match.result.home}:{match.result.away}
                            </div>
                            <div className="mt-1 text-xs font-bold opacity-70">{match.kickoffLabel}</div>
                          </div>
                          <TeamBadge id={match.away} align="right" />
                          <div className="flex justify-end">
                            <Pill darkMode={darkMode} tone="neutral">
                              {match.group ? `Grupa ${match.group}` : match.stage}
                            </Pill>
                          </div>
                        </div>

                        <div className="md:hidden">
                          <div
                            className={cx(
                              "rounded-xl border px-2 py-1.5",
                              darkMode ? "border-white/10 bg-white/[0.03]" : "border-gray-200 bg-white"
                            )}
                          >
                            <MatchScoreLine id={match.home} score={match.result.home} />
                            <MatchScoreLine id={match.away} score={match.result.away} />
                          </div>
                        </div>

                        <div className="flex flex-wrap items-center gap-1.5">
                          {pick && (
                            <Pill darkMode={darkMode} tone="info">
                              Twój typ {pick.home}:{pick.away}
                            </Pill>
                          )}
                          {scored && (
                            <Pill darkMode={darkMode} tone={scored.points > 0 ? "good" : "neutral"}>
                              {scored.label}
                            </Pill>
                          )}
                          {scored && (
                            <span className="ml-auto text-xl font-black tabular-nums">
                              {scored.points} pkt
                            </span>
                          )}
                        </div>
                      </div>
                    ) : (
                      <div className="grid gap-3 md:grid-cols-[1fr_auto_1fr_auto] md:items-center">
                        <TeamBadge id={match.home} />
                        <div className="text-center">
                          <div className="text-xs font-black uppercase tracking-[0.16em] opacity-60">vs</div>
                          <div className="text-xs font-bold opacity-70">{match.kickoffLabel}</div>
                        </div>
                        <TeamBadge id={match.away} align="right" />
                        <div className="flex flex-wrap justify-start gap-2 md:justify-end">
                          <Pill darkMode={darkMode} tone={match.status === "open" ? "good" : match.status === "locked" ? "warn" : "neutral"}>
                            {match.knockout ? "Puchar" : match.group ? `Grupa ${match.group}` : match.stage}
                          </Pill>
                        </div>
                      </div>
                    )}
                  </Card>
                );
              })}
              {selectedScheduleMatches.length === 0 && (
                <Card darkMode={darkMode}>
                  <div className="font-black">Brak ujawnionych spotkań w tej części terminarza</div>
                  <div className={cx("mt-1 text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                    Mecz pojawi się automatycznie, gdy źródło danych poda obie drużyny.
                  </div>
                </Card>
              )}
            </div>
          ) : (
            <div className="grid gap-4 lg:grid-cols-2">
              {Object.entries(GROUP_TABLES).map(([group, rows]) => (
                <Card key={group} darkMode={darkMode} className="overflow-hidden p-0">
                  <div className="border-b border-white/10 px-3 py-3 text-base font-black sm:px-4 sm:text-lg">Grupa {group}</div>
                  <div className="grid grid-cols-[minmax(0,1fr)_28px_36px_40px_48px] gap-1.5 border-b border-white/10 px-3 py-2 text-[9px] font-black uppercase opacity-60 sm:grid-cols-[minmax(0,1fr)_42px_52px_56px_66px] sm:gap-2 sm:px-4 sm:text-xs">
                    <div>Drużyna</div>
                    <div className="text-center">M</div>
                    <div className="text-center">PKT</div>
                    <div className="text-center">Róż.</div>
                    <div className="text-center">Bramki</div>
                  </div>
                  {rows.map((row) => (
                    <div key={row.team} className="grid grid-cols-[minmax(0,1fr)_28px_36px_40px_48px] items-center gap-1.5 border-b border-white/10 px-3 py-2.5 text-xs last:border-b-0 sm:grid-cols-[minmax(0,1fr)_42px_52px_56px_66px] sm:gap-2 sm:px-4 sm:text-sm">
                      <CompactTeamCell id={row.team} />
                      <div className="text-center font-bold tabular-nums">{row.played}</div>
                      <div className="text-center font-black tabular-nums">{row.pts}</div>
                      <div className="text-center font-bold tabular-nums">{row.gd > 0 ? `+${row.gd}` : row.gd}</div>
                      <div className="text-center font-bold tabular-nums">{row.gf}:{row.ga}</div>
                    </div>
                  ))}
                </Card>
              ))}
            </div>
          )}
        </div>
      )}

      {tab === "picks" && !user && (
        <div className="grid gap-4 xl:grid-cols-[1fr_340px]">
          <Card darkMode={darkMode} className="overflow-hidden">
            <div className="grid gap-5 lg:grid-cols-[1fr_auto] lg:items-center">
              <div>
                <div className="flex flex-wrap items-center gap-2">
                  <Pill darkMode={darkMode} tone="info">
                    <Clock size={13} /> Najbliższy mecz
                  </Pill>
                  <Pill darkMode={darkMode} tone="warn">
                    <Lock size={13} /> Typowanie po zalogowaniu
                  </Pill>
                </div>

                <h2 className="mt-4 text-2xl font-black leading-tight md:text-3xl">
                  Zaloguj się na stronie ligi
                </h2>
                <div className={cx("mt-2 max-w-2xl text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
                  Typuj wyniki meczów MŚ 2026, zbieraj punkty w rankingu kibiców i walcz o nagrodę od ligi.
                  Logowanie jest wspólne dla całej strony MLPN. Po zalogowaniu klikniesz „Dołącz do typera” i ustawisz nick oraz avatar tylko do rankingu Typera.
                </div>

                <div className="mt-5 grid gap-2 sm:grid-cols-2">
                  <button
                    type="button"
                    onClick={() => handleSocialLogin("google")}
                    disabled={authBusy}
                    className={cx(
                      "inline-flex min-h-[46px] items-center justify-center gap-2 rounded-2xl border px-4 text-sm font-black transition-colors",
                      authBusy
                        ? "cursor-wait opacity-60"
                        : darkMode
                        ? "border-white/10 bg-white text-gray-950 hover:bg-gray-100"
                        : "border-gray-200 bg-white text-gray-950 hover:bg-gray-50"
                    )}
                  >
                    <span className="grid h-6 w-6 place-items-center">
                      <GoogleLogo className="h-5 w-5" />
                    </span>
                    {authProviderLoading === "google" ? "Łączenie..." : "Zaloguj przez Google"}
                  </button>
                  <button
                    type="button"
                    onClick={() => handleSocialLogin("facebook")}
                    disabled={authBusy}
                    className={cx(
                      "inline-flex min-h-[46px] items-center justify-center gap-2 rounded-2xl border px-4 text-sm font-black text-white transition-colors",
                      authBusy ? "cursor-wait opacity-60" : "border-blue-500 bg-blue-600 hover:bg-blue-700"
                    )}
                  >
                    <span className="grid h-6 w-6 place-items-center text-white">
                      <FacebookLogo className="h-6 w-6" />
                    </span>
                    {authProviderLoading === "facebook" ? "Łączenie..." : "Zaloguj przez Facebook"}
                  </button>
                </div>

                <form
                  onSubmit={handleEmailLogin}
                  className={cx(
                    "mt-4 rounded-2xl border p-3",
                    darkMode ? "border-white/10 bg-black/15" : "border-gray-200 bg-gray-50"
                  )}
                >
                  <div className="text-sm font-black">Masz konto założone na e-mail?</div>
                  <div className={cx("mt-1 text-xs", darkMode ? "text-gray-400" : "text-gray-600")}>
                    To jest zwykłe logowanie do strony MLPN, nie osobne konto Typera.
                  </div>
                  <div className="mt-3 grid gap-2 sm:grid-cols-2">
                    <input
                      type="email"
                      value={emailLoginEmail}
                      onChange={(event) => setEmailLoginEmail(event.target.value)}
                      autoComplete="email"
                      className={cx(
                        "min-h-[44px] rounded-xl border px-3 text-sm font-bold outline-none transition-colors",
                        darkMode
                          ? "border-white/10 bg-white/5 text-white placeholder:text-gray-500 focus:border-sky-300"
                          : "border-gray-200 bg-white text-gray-950 placeholder:text-gray-400 focus:border-sky-400"
                      )}
                      placeholder="E-mail"
                    />
                    <input
                      type="password"
                      value={emailLoginPassword}
                      onChange={(event) => setEmailLoginPassword(event.target.value)}
                      autoComplete="current-password"
                      className={cx(
                        "min-h-[44px] rounded-xl border px-3 text-sm font-bold outline-none transition-colors",
                        darkMode
                          ? "border-white/10 bg-white/5 text-white placeholder:text-gray-500 focus:border-sky-300"
                          : "border-gray-200 bg-white text-gray-950 placeholder:text-gray-400 focus:border-sky-400"
                      )}
                      placeholder="Hasło"
                    />
                  </div>
                  <button
                    type="submit"
                    disabled={authBusy}
                    className={cx(
                      "mt-3 inline-flex min-h-[44px] w-full items-center justify-center rounded-xl border px-4 text-sm font-black transition-colors",
                      authBusy
                        ? "cursor-wait border-gray-300 bg-gray-100 text-gray-500"
                        : "border-emerald-300 bg-emerald-400 text-black hover:brightness-105"
                    )}
                  >
                    {emailAuthLoading ? "Logowanie..." : "Zaloguj kontem e-mail"}
                  </button>
                </form>

                {authError && (
                  <div className="mt-3 rounded-2xl border border-red-400/30 bg-red-500/10 p-3 text-sm font-bold text-red-300">
                    {authError}
                  </div>
                )}
              </div>

              <div className={cx("rounded-2xl border p-4", darkMode ? "border-white/10 bg-black/20" : "border-gray-200 bg-gray-50")}>
                <div className="text-xs font-black uppercase tracking-[0.16em] opacity-70">
                  Do typowania
                </div>
                {featuredMatch ? (
                  <>
                    <div className="mt-4 grid gap-3">
                      <TeamBadge id={featuredMatch.home} />
                      <div className="text-center text-xs font-black uppercase opacity-60">vs</div>
                      <TeamBadge id={featuredMatch.away} />
                    </div>
                    <div className="mt-4 grid gap-2 text-xs font-bold opacity-80">
                      <div className="flex items-center gap-2">
                        <Calendar size={14} />
                        <span>{featuredMatch.kickoffLabel}</span>
                      </div>
                      <div>{featuredMatch.group ? `Grupa ${featuredMatch.group}` : featuredMatch.stage}</div>
                    </div>
                  </>
                ) : (
                  <div className="mt-3 text-sm opacity-75">Terminarz jest jeszcze pusty.</div>
                )}
              </div>
            </div>
          </Card>

          <div className="space-y-4">
            <Card darkMode={darkMode}>
              <div className="flex items-center gap-2 text-lg font-black">
                <Trophy size={20} />
                Jak to działa?
              </div>
              <div className={cx("mt-3 grid gap-2 text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
                <div>Typy widoczne są zawsze na najbliższe 3 dni.</div>
                <div>Wynik blokuje się 5 minut przed pierwszym gwizdkiem.</div>
                <div>Punkty wpadają za dokładny wynik albo trafiony rezultat.</div>
              </div>
            </Card>

            <Card darkMode={darkMode}>
              <div className="flex items-center gap-2 text-lg font-black">
                <UserCheck size={20} />
                Konto kibica
              </div>
              <div className={cx("mt-3 text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
                Po logowaniu wybierzesz nick do rankingu. Admin może ostrzec, zresetować albo zbanować konto z wulgarnym nickiem.
              </div>
            </Card>
          </div>
        </div>
      )}

      {tab === "picks" && user && needsTyperProfile && !profileSetupOpen && (
        <div className="grid gap-4 xl:grid-cols-[1fr_340px]">
          <Card darkMode={darkMode}>
            <div className="grid gap-5 lg:grid-cols-[1fr_auto] lg:items-center">
              <div>
                <div className="flex flex-wrap items-center gap-2">
                  <Pill darkMode={darkMode} tone="good">
                    <UserCheck size={13} /> Zalogowano na stronie
                  </Pill>
                  <Pill darkMode={darkMode} tone="warn">
                    <Lock size={13} /> Nie jesteś jeszcze w typerze
                  </Pill>
                </div>
                <h2 className="mt-4 text-2xl font-black leading-tight md:text-3xl">
                  Dołącz do Typera MLPN
                </h2>
                <div className={cx("mt-2 max-w-2xl text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
                  Konto strony już działa. Żeby pojawić się w rankingu i zacząć typować, ustaw osobny nick oraz avatar widoczny tylko w module Typera.
                </div>
                <div className="mt-4 flex flex-col gap-2 sm:flex-row sm:items-center">
                  <button
                    type="button"
                    onClick={() => setProfileSetupOpen(true)}
                    className="inline-flex min-h-[46px] items-center justify-center gap-2 rounded-2xl border border-emerald-300 bg-emerald-400 px-5 text-sm font-black text-black transition-colors hover:brightness-105"
                  >
                    <Plus size={17} />
                    Dołącz do typera
                  </button>
                  <span className={cx("text-xs font-bold", darkMode ? "text-gray-400" : "text-gray-600")}>
                    Zalogowany jako {user.email || fallbackProfileName}
                  </span>
                </div>
              </div>

              <div className={cx("rounded-2xl border p-4", darkMode ? "border-white/10 bg-black/20" : "border-gray-200 bg-gray-50")}>
                <div className="text-xs font-black uppercase tracking-[0.16em] opacity-70">
                  Po dołączeniu
                </div>
                <div className="mt-3 grid gap-2 text-sm font-bold">
                  <div className="flex items-center gap-2"><Medal size={15} /> Pojawisz się w rankingu</div>
                  <div className="flex items-center gap-2"><Save size={15} /> Odblokujesz swoje typy</div>
                  <div className="flex items-center gap-2"><Crown size={15} /> Wybierzesz mistrza turnieju</div>
                </div>
              </div>
            </div>
          </Card>

          <Card darkMode={darkMode}>
            <div className="flex items-center gap-2 text-lg font-black">
              <Calendar size={20} />
              Najbliższy mecz
            </div>
            {featuredMatch ? (
              <div className="mt-4 grid gap-3 md:grid-cols-[1fr_auto_1fr] md:items-center">
                <TeamBadge id={featuredMatch.home} />
                <div className="text-center">
                  <div className="text-xs font-black uppercase opacity-60">vs</div>
                  <div className="mt-1 text-xs font-bold opacity-70">{featuredMatch.kickoffLabel}</div>
                </div>
                <TeamBadge id={featuredMatch.away} align="right" />
              </div>
            ) : (
              <div className="mt-3 text-sm opacity-75">Terminarz jest jeszcze pusty.</div>
            )}
          </Card>
        </div>
      )}

      {tab === "picks" && user && profileSetupOpen && (
        <TyperProfileSetup
          darkMode={darkMode}
          user={user}
          defaultName={fallbackProfileName}
          googleAvatarUrl={googleAvatarUrl}
          facebookAvatarUrl={facebookAvatarUrl}
          nicknameDraft={nicknameDraft}
          setNicknameDraft={setNicknameDraft}
          avatarDraft={avatarDraft}
          setAvatarDraft={setAvatarDraft}
          setupError={setupError}
          setSetupError={setSetupError}
          onAvatarUpload={handleAvatarUpload}
          onSave={saveTyperProfile}
          championTeams={CHAMPION_TEAMS}
          isEditing={profileSetupOpen && !!typerProfile}
        />
      )}

      {tab === "picks" && user && !needsTyperProfile && !profileSetupOpen && (
        <div className="grid gap-4 xl:grid-cols-[1fr_340px]">
          <div className="space-y-3">
            <Card darkMode={darkMode}>
              <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                <div>
                  <div className="flex items-center gap-2 text-lg font-black">
                    <Clock size={19} />
                    Okno typowania
                  </div>
                  <div className={cx("mt-1 text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                    Najbliższe 3 dni, do {pickWindowEndLabel}. Blokada 5 minut przed startem meczu.
                  </div>
                </div>
                <Pill darkMode={darkMode} tone={availablePickMatches.length ? "good" : "warn"}>
                  {availablePickMatches.length} meczów do typowania
                </Pill>
              </div>
            </Card>

            {availablePickMatches.length === 0 && (
              <Card darkMode={darkMode}>
                <div className="flex items-start gap-3">
                  <div className="grid h-10 w-10 shrink-0 place-items-center rounded-xl border border-white/10 bg-black/10">
                    <Calendar size={18} />
                  </div>
                  <div>
                    <div className="font-black">Brak spotkań w aktywnym oknie</div>
                    <div className={cx("mt-1 text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                      {nextKnownMatch
                        ? `Najbliższy znany mecz: ${team(nextKnownMatch.home).name} - ${team(nextKnownMatch.away).name}, ${nextKnownMatch.kickoffLabel}.`
                        : "Terminarz nie zawiera kolejnych znanych par do typowania."}
                    </div>
                  </div>
                </div>
              </Card>
            )}

            {availablePickMatches.map((match) => {
              const pick = picks[match.id] || { home: 0, away: 0, confirmed: false };
              const disabled = match.status !== "open" || isMatchLockedForPicking(match, windowNow);
              const scored = scorePick(match, pick);

              return (
                <Card key={match.id} darkMode={darkMode}>
                  <div className="grid gap-4 lg:grid-cols-[1fr_auto_1fr] lg:items-center">
                    <TeamBadge id={match.home} />
                    <div className="grid gap-2">
                      <div className="grid grid-cols-[auto_auto] justify-center gap-2">
                        <ScoreStepper
                          value={pick.home || 0}
                          disabled={disabled}
                          darkMode={darkMode}
                          label={team(match.home).name}
                          onChange={(value) => updatePick(match.id, { home: value })}
                        />
                        <ScoreStepper
                          value={pick.away || 0}
                          disabled={disabled}
                          darkMode={darkMode}
                          label={team(match.away).name}
                          onChange={(value) => updatePick(match.id, { away: value })}
                        />
                      </div>
                      <div className="text-center text-xs font-bold opacity-70">{match.kickoffLabel}</div>
                    </div>
                    <TeamBadge id={match.away} align="right" />
                  </div>

                  {match.knockout && (
                    <div className="mt-4 grid gap-2 rounded-2xl border border-white/10 bg-black/10 p-3 sm:grid-cols-[160px_1fr_1fr] sm:items-center">
                      <div className="text-xs font-black uppercase tracking-[0.14em] opacity-70">Kto awansuje</div>
                      {[match.home, match.away].map((teamId) => (
                        <button
                          key={teamId}
                          type="button"
                          disabled={disabled}
                          onClick={() => updatePick(match.id, { advance: teamId })}
                          className={cx(
                            "min-h-[44px] rounded-xl border px-3 text-sm font-black transition-colors",
                            pick.advance === teamId
                              ? "border-emerald-300 bg-emerald-400 text-black"
                              : darkMode
                              ? "border-white/10 bg-white/5 hover:bg-white/10"
                              : "border-gray-200 bg-white hover:bg-gray-50",
                            disabled && "cursor-not-allowed opacity-45"
                          )}
                        >
                          <TeamBadge id={teamId} compact />
                        </button>
                      ))}
                    </div>
                  )}

                  <div className="mt-4 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                    <div className="flex flex-wrap gap-2">
                      <Pill darkMode={darkMode} tone={disabled ? "warn" : pick.confirmed ? "good" : "info"}>
                        {disabled ? <Lock size={13} /> : pick.confirmed ? <CheckCircle2 size={13} /> : <Save size={13} />}
                        {disabled ? "Zablokowany" : pick.confirmed ? "Zatwierdzony" : "Autozapis"}
                      </Pill>
                      {scored && (
                        <Pill darkMode={darkMode} tone={scored.points > 0 ? "good" : "neutral"}>
                          {scored.points} pkt · {scored.label}
                        </Pill>
                      )}
                    </div>
                    <div className="flex gap-2">
                      <button
                        type="button"
                        disabled={disabled}
                        onClick={() => clearPick(match.id)}
                        className={cx(
                          "inline-flex min-h-[42px] items-center gap-2 rounded-xl border px-3 text-sm font-black",
                          disabled
                            ? "cursor-not-allowed opacity-45"
                            : darkMode
                            ? "border-white/10 bg-white/5 hover:bg-white/10"
                            : "border-gray-200 bg-white hover:bg-gray-50"
                        )}
                      >
                        <Trash2 size={16} />
                        Wyczyść
                      </button>
                      <button
                        type="button"
                        disabled={disabled}
                        onClick={() => confirmPick(match.id)}
                        className={cx(
                          "inline-flex min-h-[42px] items-center gap-2 rounded-xl border px-3 text-sm font-black",
                          disabled
                            ? "cursor-not-allowed opacity-45"
                            : "border-emerald-400/30 bg-emerald-400 text-black hover:brightness-110"
                        )}
                      >
                        <CheckCircle2 size={16} />
                        Zatwierdź
                      </button>
                    </div>
                  </div>
                </Card>
              );
            })}

          </div>

          <div className="space-y-4">
            <Card darkMode={darkMode}>
              <div className="flex items-center gap-2 text-lg font-black">
                <Crown size={20} />
                Mistrz turnieju
              </div>
              <div className={cx("mt-2 text-sm", darkMode ? "text-gray-400" : "text-gray-600")}>
                Wybór blokowany po zakończeniu 1. kolejki fazy grupowej.
              </div>
              <div className="mlpn-typer-scrollbar mt-4 max-h-[520px] overflow-y-auto pr-1 grid grid-cols-2 gap-2">
                {CHAMPION_TEAMS.map((item) => (
                  <button
                    key={item.id}
                    type="button"
                    onClick={() => updateChampion(item.id)}
                    className={cx(
                      "min-h-[48px] rounded-xl border px-3 text-left text-sm font-black",
                      champion === item.id
                        ? "border-sky-300 bg-sky-400 text-black"
                        : darkMode
                        ? "border-white/10 bg-white/5 hover:bg-white/10"
                        : "border-gray-200 bg-white hover:bg-gray-50"
                    )}
                  >
                    <TeamBadge id={item.id} compact />
                  </button>
                ))}
              </div>
            </Card>

            <Card darkMode={darkMode}>
              <div className="text-lg font-black">Status konta</div>
              <div className="mt-3 flex items-center gap-3">
                <AvatarPreview avatar={profileAvatar} name={profileName} size="sm" />
                <div className="min-w-0">
                  <div className="truncate font-black">{profileName}</div>
                  <div className="text-xs opacity-70">{user?.email || "konto podglądowe"}</div>
                </div>
              </div>
              <div className="mt-4 grid gap-2">
                <Pill darkMode={darkMode} tone="good"><UserCheck size={13} /> Konto zatwierdzone</Pill>
                <Pill darkMode={darkMode} tone="good"><CheckCircle2 size={13} /> Nick zgodny z regulaminem</Pill>
                <button
                  type="button"
                  onClick={() => setProfileSetupOpen(true)}
                  className={cx(
                    "mt-2 min-h-[40px] rounded-xl border px-3 text-sm font-black transition-colors",
                    darkMode ? "border-white/10 bg-white/5 hover:bg-white/10" : "border-gray-200 bg-white hover:bg-gray-50"
                  )}
                >
                  Edytuj profil typera
                </button>
              </div>
            </Card>
          </div>
        </div>
      )}

      {tab === "profile" && (
        <div className="grid gap-4 lg:grid-cols-[360px_1fr]">
          <Card darkMode={darkMode}>
            <div className="text-xl font-black">Profil kibica</div>
            <div className="mt-4 flex items-center gap-4">
              <AvatarPreview avatar={profileAvatar} name={profileName} size="xl" />
              <div className="min-w-0">
                <div className="truncate text-2xl font-black">{profileName}</div>
                <div className="text-sm opacity-70">{user?.email || "niezalogowany podgląd"}</div>
              </div>
            </div>
            <div className="mt-5 grid gap-2">
              <StatusBadge darkMode={darkMode} status="approved" />
              <Pill darkMode={darkMode} tone="info"><Bell size={13} /> Push: przypomnienia o typach</Pill>
              {user && (
                <button
                  type="button"
                  onClick={() => {
                    setProfileSetupOpen(true);
                    setTab("picks");
                  }}
                  className={cx(
                    "mt-2 min-h-[42px] rounded-xl border px-3 text-sm font-black transition-colors",
                    darkMode ? "border-white/10 bg-white/5 hover:bg-white/10" : "border-gray-200 bg-white hover:bg-gray-50"
                  )}
                >
                  {typerProfile ? "Edytuj profil typera" : "Ustaw profil typera"}
                </button>
              )}
            </div>
          </Card>

          <Card darkMode={darkMode}>
            <div className="flex items-center gap-2 text-xl font-black">
              <ShieldAlert size={20} />
              Zasady nicku
            </div>
            <div className={cx("mt-3 grid gap-3 text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
              <p>
                Nick jest widoczny w rankingu, czacie i podglądzie typów. Ma być kulturalny,
                bez wulgaryzmów, prowokacji, obrażania innych i podszywania się pod organizatorów.
              </p>
              <div className="grid gap-2 md:grid-cols-3">
                <div className="rounded-2xl border border-amber-400/25 bg-amber-400/10 p-3">
                  <div className="font-black text-amber-300">1. ostrzeżenie</div>
                  <div className="mt-1 text-xs opacity-80">Reset nicku i komunikat od admina.</div>
                </div>
                <div className="rounded-2xl border border-orange-400/25 bg-orange-400/10 p-3">
                  <div className="font-black text-orange-300">2. ostrzeżenie</div>
                  <div className="mt-1 text-xs opacity-80">Blokada do czasu decyzji administratora.</div>
                </div>
                <div className="rounded-2xl border border-red-400/25 bg-red-400/10 p-3">
                  <div className="font-black text-red-300">Ban</div>
                  <div className="mt-1 text-xs opacity-80">Wykluczenie z typowania, rankingu i nagrody.</div>
                </div>
              </div>
            </div>
          </Card>
        </div>
      )}

      {tab === "rules" && (
        <div className="grid gap-4 lg:grid-cols-[1fr_330px]">
          <Card darkMode={darkMode}>
            <div className="text-2xl font-black">Regulamin typera</div>
            <div className="mt-4 grid gap-3">
              {RULES.map((rule, index) => (
                <div key={rule.title} className={cx("rounded-2xl border p-4", darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50")}>
                  <div className="flex items-center gap-3">
                    <div className="grid h-8 w-8 shrink-0 place-items-center rounded-xl bg-red-500 text-sm font-black text-white">
                      {index + 1}
                    </div>
                    <div className="font-black">{rule.title}</div>
                  </div>
                  <div className={cx("mt-2 text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
                    {rule.body}
                  </div>
                </div>
              ))}
            </div>
          </Card>

          <Card darkMode={darkMode}>
            <div className="flex items-center gap-2 text-lg font-black">
              <Trophy size={20} />
              Nagroda
            </div>
            <div className={cx("mt-3 text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
              Typer jest grą o punkty. Organizator może przyznać nagrodę od ligi dla najlepszego
              uczestnika, ale zbanowane konta nie są brane pod uwagę.
            </div>
            <div className="mt-4 grid gap-2">
              <Pill darkMode={darkMode} tone="good"><CheckCircle2 size={13} /> Bez składek i puli pieniędzy</Pill>
              <Pill darkMode={darkMode} tone="warn"><AlertTriangle size={13} /> Decyzje admina są wiążące</Pill>
            </div>
          </Card>
        </div>
      )}

      {tab === "admin" && isAdmin && (
        <div className="grid gap-4 xl:grid-cols-[minmax(0,1fr)_340px]">
          <Card darkMode={darkMode}>
            <div className="flex flex-wrap items-center justify-between gap-3">
              <div className="flex items-center gap-2 text-xl font-black">
                <ShieldAlert size={20} />
                Moderacja graczy
              </div>
              <Pill darkMode={darkMode} tone="good">
                <UserCheck size={13} /> Pełny admin
              </Pill>
            </div>

            {adminModerationError && (
              <div className={cx("mt-3 rounded-xl border px-3 py-2 text-sm font-bold", darkMode ? "border-red-300/30 bg-red-400/10 text-red-100" : "border-red-200 bg-red-50 text-red-800")}>
                {adminModerationError}
              </div>
            )}

            <div className="mt-4 grid gap-3">
              {players.length ? (
                players.map((player) => {
                  const nicknameDraft = getAdminNicknameDraft(player);
                  const normalizedDraft = nicknameDraft.trim().replace(/\s+/g, " ");
                  const canSaveNickname =
                    player.status !== "banned" && normalizedDraft.length > 0 && normalizedDraft !== player.name;

                  return (
                    <div key={player.id} className={cx("grid gap-3 rounded-2xl border p-3 xl:grid-cols-[minmax(0,1fr)_minmax(280px,520px)] xl:items-center", darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50")}>
                      <div className="flex min-w-0 items-center gap-3">
                        {player.avatar && typeof player.avatar === "object" ? (
                          <AvatarPreview avatar={player.avatar} name={player.name} size="sm" />
                        ) : (
                          <div className="grid h-12 w-12 shrink-0 place-items-center rounded-full bg-gradient-to-br from-red-500 to-sky-500 text-sm font-black text-white">
                            {player.avatar}
                          </div>
                        )}
                        <div className="min-w-0">
                          <div className="truncate text-lg font-black">{player.name}</div>
                          <div className="mt-1 flex flex-wrap gap-1.5">
                            <StatusBadge darkMode={darkMode} status={player.status} />
                            <Pill darkMode={darkMode} tone="neutral">{player.points} pkt</Pill>
                            <Pill darkMode={darkMode} tone={player.warnings ? "warn" : "neutral"}>
                              {player.warnings || 0} ostrz.
                            </Pill>
                          </div>
                        </div>
                      </div>

                      <div className="grid min-w-0 gap-2">
                        <div className="grid gap-2 sm:grid-cols-[minmax(0,1fr)_auto]">
                          <input
                            type="text"
                            value={nicknameDraft}
                            disabled={player.status === "banned"}
                            onChange={(event) => setAdminNicknameDraft(player.id, event.target.value)}
                            className={cx(
                              "min-h-[42px] min-w-0 rounded-xl border px-3 text-sm font-black outline-none transition-colors",
                              player.status === "banned"
                                ? darkMode
                                  ? "border-white/10 bg-white/5 text-gray-500"
                                  : "border-gray-200 bg-gray-100 text-gray-500"
                                : darkMode
                                ? "border-white/10 bg-white/5 text-white focus:border-sky-300/60"
                                : "border-gray-200 bg-white text-gray-950 focus:border-sky-400"
                            )}
                          />
                          <ModerationButton darkMode={darkMode} tone="good" icon={<Save size={15} />} onClick={() => saveAdminNickname(player)} disabled={!canSaveNickname}>
                            Zapisz nick
                          </ModerationButton>
                        </div>

                        <div className="grid grid-cols-2 gap-2 sm:flex sm:flex-wrap">
                          <ModerationButton darkMode={darkMode} tone="warn" icon={<AlertTriangle size={15} />} onClick={() => warnPlayer(player)} disabled={player.status === "banned"}>
                            Ostrzeż
                          </ModerationButton>
                          <ModerationButton darkMode={darkMode} icon={<Trash2 size={15} />} onClick={() => resetNick(player)} disabled={player.status === "banned"}>
                            Resetuj
                          </ModerationButton>
                          {player.status === "banned" ? (
                            <ModerationButton darkMode={darkMode} tone="good" icon={<UserCheck size={15} />} onClick={() => unbanPlayer(player)}>
                              Odbanuj
                            </ModerationButton>
                          ) : (
                            <ModerationButton darkMode={darkMode} tone="danger" icon={<Ban size={15} />} onClick={() => banPlayer(player)}>
                              Ban
                            </ModerationButton>
                          )}
                        </div>
                      </div>
                    </div>
                  );
                })
              ) : (
                <div className={cx("rounded-2xl border p-4 text-sm font-bold", darkMode ? "border-white/10 bg-black/10 text-gray-300" : "border-gray-200 bg-gray-50 text-gray-700")}>
                  Brak graczy w typerze.
                </div>
              )}
            </div>
          </Card>

          <div className="space-y-4">
            <Card darkMode={darkMode}>
              <div className="flex items-center gap-2 text-lg font-black">
                <Lock size={19} />
                Dostęp
              </div>
              <div className={cx("mt-3 text-sm leading-relaxed", darkMode ? "text-gray-300" : "text-gray-700")}>
                Panel moderacji typera jest widoczny tylko dla kont z rolą pełnego administratora.
              </div>
            </Card>

            <Card darkMode={darkMode}>
              <div className="text-lg font-black">Historia moderacji</div>
              <div className="mt-3 grid gap-2">
                {moderationLog.map((entry, index) => (
                  <div key={`${entry}-${index}`} className={cx("rounded-xl border p-3 text-sm", darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50")}>
                    {entry}
                  </div>
                ))}
              </div>
            </Card>
          </div>
        </div>
      )}

    </main>
  );
}
