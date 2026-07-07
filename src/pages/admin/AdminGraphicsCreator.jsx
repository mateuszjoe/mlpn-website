import React, { useCallback, useEffect, useMemo, useRef, useState } from "react";
import {
  CalendarDays,
  ChevronDown,
  Download,
  Handshake,
  Image as ImageIcon,
  Layers,
  ListChecks,
  Loader2,
  RefreshCcw,
  Star,
  Table2,
  Trophy,
  Users,
  Vote,
} from "lucide-react";
import { supabase } from "../../lib/supabase";
import AdminAlert from "./components/AdminAlert";
import AdminFormField from "./components/AdminFormField";
import {
  drawGraphic,
  FORMATIONS,
  getFormation,
  SPONSORS_TOP,
  SPONSORS_BOTTOM,
  BRAND_LOGO_SRC,
  loadAllFrames,
  defaultFrame,
  normalizeSponsorFrame,
} from "./graphicsRenderer";

const FORMAT_OPTIONS = [
  { id: "post", label: "POST", sizeLabel: "1080 x 1080", width: 1080, height: 1080 },
  { id: "story", label: "RELACJA", sizeLabel: "1080 x 1920", width: 1080, height: 1920 },
];

const EXPORT_SCALE = 2;

function getRenderSize(format) {
  return {
    width: format.width * EXPORT_SCALE,
    height: format.height * EXPORT_SCALE,
    sizeLabel: `${format.width * EXPORT_SCALE} x ${format.height * EXPORT_SCALE}`,
  };
}

const SPONSOR_ROW_OPTIONS = [1, 2, 3, 4].map((rows) => ({
  value: String(rows),
  label: `${rows}`,
}));

const CATEGORY_OPTIONS = [
  {
    id: "round-typer",
    scope: "all",
    label: "Typer kolejki",
    title: "TYPER",
    subtitle: "Kolejka do typowania 1X2",
    icon: Vote,
  },
  {
    id: "round-preview",
    scope: "all",
    label: "Zapowiedź kolejki",
    title: "Zapowiedź kolejki",
    subtitle: "Rozpiska spotkań",
    icon: CalendarDays,
  },
  {
    id: "round-results",
    scope: "all",
    label: "Wyniki kolejki",
    title: "Wyniki kolejki",
    subtitle: "Rezultaty spotkań",
    icon: ListChecks,
  },
  {
    id: "best-eight",
    scope: "league",
    label: "Najlepsza 8semka",
    title: "Najlepsza 8semka",
    subtitle: "Drużyna okresu",
    icon: Users,
  },
  {
    id: "player-award",
    scope: "league",
    label: "Zawodnik okresu",
    title: "Zawodnik okresu",
    subtitle: "Wyróżnienie indywidualne",
    icon: Trophy,
  },
  {
    id: "player-vote",
    scope: "league",
    label: "Głosowanie",
    title: "Głosowanie",
    subtitle: "Zawodnik okresu",
    icon: Vote,
  },
  {
    id: "table-summary",
    scope: "league",
    label: "Podsumowanie tabeli",
    title: "Podsumowanie tabeli",
    subtitle: "Tabela ligi",
    icon: Table2,
  },
];

const PERIOD_OPTIONS = [
  { value: "month", label: "Miesiąc" },
  { value: "round", label: "Runda" },
  { value: "season", label: "Sezon" },
];

const MONTH_OPTIONS = [
  "Styczeń",
  "Luty",
  "Marzec",
  "Kwiecień",
  "Maj",
  "Czerwiec",
  "Lipiec",
  "Sierpień",
  "Wrzesień",
  "Październik",
  "Listopad",
  "Grudzień",
].map((month) => ({ value: month, label: month }));

const ROUND_PERIOD_OPTIONS = [
  { value: "Wiosna", label: "Wiosna" },
  { value: "Jesień", label: "Jesień" },
];

const LEAGUE_OPTIONS = [
  { value: "1st", label: "I Liga", accent: "#d71920" },
  { value: "2nd", label: "II Liga", accent: "#f8fafc" },
  { value: "3rd", label: "III Liga", accent: "#76c879" },
];

const DEFAULT_SPONSOR_OUTLINE = {
  color: "#858585",
  strength: 1,
  density: 24,
  blur: 12,
  thickness: 0.016,
};

const GRAPHICS_FORM_DRAFT_KEY = "mlpn_admin_graphics_creator_form_draft_v1";
const GRAPHICS_COLLAPSED_DRAFT_KEY = "mlpn_admin_graphics_creator_collapsed_draft_v1";

const MATCH_SELECT = [
  "id",
  "season_year",
  "league_code",
  "league_name",
  "round",
  "match_date",
  "match_time",
  "venue",
  "status",
  "home_team_id",
  "away_team_id",
  "home_team_name",
  "away_team_name",
  "home_team_abbr",
  "away_team_abbr",
  "home_team_logo",
  "away_team_logo",
  "home_goals",
  "away_goals",
].join(",");

const STANDINGS_SELECT = [
  "position",
  "team_name",
  "team_logo_url",
  "played",
  "won",
  "drawn",
  "lost",
  "goals_for",
  "goals_against",
  "points",
].join(",");

const SPONSOR_PROFILE_MARKER = "[MLPN_SPONSOR_PROFILE]";

function parseSponsorGraphicsMeta(rawDescription = "") {
  const raw = String(rawDescription || "");
  if (!raw.startsWith(SPONSOR_PROFILE_MARKER)) return {};
  try {
    const parsed = JSON.parse(raw.slice(SPONSOR_PROFILE_MARKER.length).trim());
    return parsed && typeof parsed === "object" ? parsed : {};
  } catch {
    return {};
  }
}



const imageCache = new Map();

function defaultLineup() {
  // Eight index-based slots; positions/labels come from the selected formation.
  return Array.from({ length: 8 }, () => ({ name: "", team: "", teamId: "", logoUrl: "" }));
}

function defaultCandidates() {
  return [
    { name: "", team: "", teamId: "", logoUrl: "", photoUrl: "", reaction: "❤️" },
    { name: "", team: "", teamId: "", logoUrl: "", photoUrl: "", reaction: "😂" },
    { name: "", team: "", teamId: "", logoUrl: "", photoUrl: "", reaction: "😮" },
  ];
}

function sameId(a, b) {
  return String(a || "") === String(b || "");
}

function filterPlayersByTeam(players, teamId) {
  if (!teamId) return players;
  return players.filter((player) => sameId(player.teamId, teamId));
}

function CollapsibleSection({
  title,
  icon,
  actions = null,
  children,
  cardClass,
  contentClassName = "mt-3",
  collapsed,
  onToggle,
}) {
  return (
    <div className={`rounded-2xl border p-4 ${cardClass}`}>
      <div className="flex items-center justify-between gap-3">
        <button
          type="button"
          onClick={onToggle}
          className="flex min-w-0 flex-1 items-center gap-2 text-left font-semibold"
          aria-expanded={!collapsed}
        >
          {icon}
          <span className="min-w-0 truncate">{title}</span>
        </button>
        <div className="flex shrink-0 items-center gap-2">
          {actions}
          <button
            type="button"
            onClick={onToggle}
            className="rounded-lg p-1 text-gray-400 transition-colors hover:bg-white/10 hover:text-white"
            aria-label={collapsed ? "Rozwiń sekcję" : "Zwiń sekcję"}
          >
            <ChevronDown size={18} className={`transition-transform ${collapsed ? "" : "rotate-180"}`} />
          </button>
        </div>
      </div>
      {!collapsed && <div className={contentClassName}>{children}</div>}
    </div>
  );
}

function currentMonthLabel() {
  const monthIndex = new Date().getMonth();
  return MONTH_OPTIONS[monthIndex]?.value || MONTH_OPTIONS[0].value;
}

function defaultPeriodLabel(periodType, seasonYear) {
  if (periodType === "season") return String(seasonYear || new Date().getFullYear());
  if (periodType === "round") return ROUND_PERIOD_OPTIONS[0].value;
  return currentMonthLabel();
}

function defaultForm() {
  return {
    format: "post",
    category: "round-typer",
    theme: "stadium",
    seasonYear: "",
    round: "",
    leagueCode: "1st",
    periodType: "month",
    periodLabel: defaultPeriodLabel("month"),
    title: "",
    subtitle: "",
    footerText: "mlpn.pl",
    accentColor: "#e7b23c",
    selectedTyperMatchIds: [],
    selectedSponsorIds: [],
    sponsorSelectionTouched: false,
    sponsorRows: "2",
    hitMatchId: null,
    formation: "3-3-1",
    playerName: "",
    playerTeam: "",
    playerTeamId: "",
    playerPhotoUrl: "",
    playerLogoUrl: "",
    playerCaption: "",
    lineup: defaultLineup(),
    candidates: defaultCandidates(),
  };
}

function safeReadDraft(key) {
  if (typeof window === "undefined" || !window.localStorage) return null;
  try {
    const raw = window.localStorage.getItem(key);
    if (!raw) return null;
    const parsed = JSON.parse(raw);
    return parsed && typeof parsed === "object" ? parsed : null;
  } catch {
    return null;
  }
}

function safeWriteDraft(key, value) {
  if (typeof window === "undefined" || !window.localStorage) return;
  try {
    window.localStorage.setItem(key, JSON.stringify(value));
  } catch {
    // Draft persistence is a convenience; rendering must keep working without it.
  }
}

function normalizeLineupDraft(lineup) {
  const base = defaultLineup();
  if (!Array.isArray(lineup)) return base;
  return base.map((slot, index) => ({
    ...slot,
    ...(lineup[index] && typeof lineup[index] === "object" ? lineup[index] : {}),
    teamId: String(lineup[index]?.teamId || ""),
  }));
}

function normalizeCandidatesDraft(candidates) {
  const base = defaultCandidates();
  if (!Array.isArray(candidates)) return base;
  return base.map((candidate, index) => ({
    ...candidate,
    ...(candidates[index] && typeof candidates[index] === "object" ? candidates[index] : {}),
    teamId: String(candidates[index]?.teamId || ""),
  }));
}

function loadFormDraft() {
  const base = defaultForm();
  const draft = safeReadDraft(GRAPHICS_FORM_DRAFT_KEY);
  if (!draft) return base;

  return {
    ...base,
    ...draft,
    format: FORMAT_OPTIONS.some((item) => item.id === draft.format) ? draft.format : base.format,
    category: CATEGORY_OPTIONS.some((item) => item.id === draft.category) ? draft.category : base.category,
    periodType: PERIOD_OPTIONS.some((item) => item.value === draft.periodType) ? draft.periodType : base.periodType,
    leagueCode: LEAGUE_OPTIONS.some((item) => item.value === draft.leagueCode) ? draft.leagueCode : base.leagueCode,
    formation: FORMATIONS.some((item) => item.id === draft.formation) ? draft.formation : base.formation,
    seasonYear: String(draft.seasonYear || ""),
    round: String(draft.round || ""),
    sponsorRows: SPONSOR_ROW_OPTIONS.some((item) => item.value === String(draft.sponsorRows))
      ? String(draft.sponsorRows)
      : base.sponsorRows,
    selectedTyperMatchIds: Array.isArray(draft.selectedTyperMatchIds) ? draft.selectedTyperMatchIds : base.selectedTyperMatchIds,
    selectedSponsorIds: Array.isArray(draft.selectedSponsorIds) ? draft.selectedSponsorIds : base.selectedSponsorIds,
    sponsorSelectionTouched: Boolean(draft.sponsorSelectionTouched),
    playerTeamId: String(draft.playerTeamId || ""),
    lineup: normalizeLineupDraft(draft.lineup),
    candidates: normalizeCandidatesDraft(draft.candidates),
  };
}

function loadCollapsedDraft() {
  const draft = safeReadDraft(GRAPHICS_COLLAPSED_DRAFT_KEY);
  return draft ? { sponsors: true, ...draft } : { sponsors: true };
}

function getFormat(formatId) {
  return FORMAT_OPTIONS.find((item) => item.id === formatId) || FORMAT_OPTIONS[0];
}

function getCategory(categoryId) {
  return CATEGORY_OPTIONS.find((item) => item.id === categoryId) || CATEGORY_OPTIONS[0];
}

function getLeague(leagueCode) {
  return LEAGUE_OPTIONS.find((item) => item.value === leagueCode) || LEAGUE_OPTIONS[0];
}


function romanRound(value) {
  const number = Number(value || 0);
  const map = [
    [50, "L"],
    [40, "XL"],
    [10, "X"],
    [9, "IX"],
    [5, "V"],
    [4, "IV"],
    [1, "I"],
  ];
  if (!Number.isFinite(number) || number <= 0) return "";
  let remaining = Math.min(number, 59);
  let output = "";
  for (const [arabic, roman] of map) {
    while (remaining >= arabic) {
      output += roman;
      remaining -= arabic;
    }
  }
  return output;
}


function formatShortDate(value) {
  if (!value) return "";
  const date = new Date(`${value}T12:00:00`);
  if (Number.isNaN(date.getTime())) return value;
  return new Intl.DateTimeFormat("pl-PL", {
    day: "2-digit",
    month: "2-digit",
  }).format(date);
}

function isCompletedStatus(status) {
  return ["completed", "walkover_home", "walkover_away"].includes(String(status || ""));
}

// Dominant weekend of a round (ignores single postponed fixtures far from the pack).
function roundWeekendLabel(dates) {
  const valid = dates.filter(Boolean);
  if (!valid.length) return "";
  const counts = {};
  valid.forEach((d) => {
    counts[d] = (counts[d] || 0) + 1;
  });
  const modal = Object.keys(counts).sort((a, b) => counts[b] - counts[a] || (a < b ? -1 : 1))[0];
  const modalTime = new Date(`${modal}T12:00:00`).getTime();
  const near = Object.keys(counts)
    .filter((d) => Math.abs((new Date(`${d}T12:00:00`).getTime() - modalTime) / 86400000) <= 1.5)
    .sort();
  const parts = (d) => {
    const dt = new Date(`${d}T12:00:00`);
    return { dd: String(dt.getDate()).padStart(2, "0"), mm: String(dt.getMonth() + 1).padStart(2, "0") };
  };
  const first = parts(near[0]);
  const last = parts(near[near.length - 1]);
  if (near[0] === near[near.length - 1]) return `${first.dd}.${first.mm}`;
  if (first.mm === last.mm) return `${first.dd}–${last.dd}.${last.mm}`;
  return `${first.dd}.${first.mm}–${last.dd}.${last.mm}`;
}

function isPlaceholderTeam(name) {
  return ["przerwa", "-przerwa-", "xxx", "wolne miejsce", "wolne miejsce ii"].includes(String(name || "").toLowerCase().trim());
}

function sanitizeFileName(value) {
  return String(value || "grafika")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 90) || "grafika";
}

function resolvePublicPath(path) {
  if (!path) return "";
  if (/^https?:\/\//i.test(path) || path.startsWith("data:image/")) return path;
  const base = process.env.PUBLIC_URL || "";
  return `${base}${path.startsWith("/") ? path : `/${path}`}`;
}

function loadCanvasImage(url) {
  const safeUrl = String(url || "").trim();
  if (!safeUrl) return Promise.resolve(null);
  if (imageCache.has(safeUrl)) return imageCache.get(safeUrl);

  const promise = new Promise((resolve) => {
    const image = new Image();
    image.crossOrigin = "anonymous";
    image.onload = () => resolve(image);
    image.onerror = () => resolve(null);
    image.src = safeUrl;
  });

  imageCache.set(safeUrl, promise);
  return promise;
}


function collectLogoUrls(form, matches) {
  const urls = new Set();
  matches.forEach((match) => {
    if (match.home_team_logo) urls.add(match.home_team_logo);
    if (match.away_team_logo) urls.add(match.away_team_logo);
  });
  form.lineup.forEach((slot) => {
    if (slot.logoUrl) urls.add(slot.logoUrl);
  });
  form.candidates.forEach((candidate) => {
    if (candidate.logoUrl) urls.add(candidate.logoUrl);
    if (candidate.photoUrl) urls.add(candidate.photoUrl);
  });
  if (form.playerPhotoUrl) urls.add(form.playerPhotoUrl);
  if (form.playerLogoUrl) urls.add(form.playerLogoUrl);
  return Array.from(urls);
}



export default function AdminGraphicsCreator({ darkMode }) {
  const canvasRef = useRef(null);
  const [form, setForm] = useState(loadFormDraft);
  const [seasons, setSeasons] = useState([]);
  const [matches, setMatches] = useState([]);
  const [seasonPlayers, setSeasonPlayers] = useState([]);
  const [dbSponsors, setDbSponsors] = useState([]);
  const [standings, setStandings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [matchesLoading, setMatchesLoading] = useState(false);
  const [standingsLoading, setStandingsLoading] = useState(false);
  const [previewLoading, setPreviewLoading] = useState(false);
  const [alert, setAlert] = useState({ type: null, message: null });
  const [collapsedSections, setCollapsedSections] = useState(loadCollapsedDraft);

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const panel = darkMode ? "bg-[#101624] border-white/10" : "bg-white border-gray-200";
  const softPanel = darkMode ? "bg-white/5 border-white/10" : "bg-gray-50 border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";
  const inputClass = darkMode
    ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500 focus:border-blue-500"
    : "bg-white border-gray-300 text-gray-900 placeholder:text-gray-400 focus:border-blue-500";
  const optionStyle = darkMode ? { backgroundColor: "#1a1f2e", color: "#fff" } : {};

  const selectedFormat = useMemo(() => getFormat(form.format), [form.format]);
  const selectedRenderSize = useMemo(() => getRenderSize(selectedFormat), [selectedFormat]);
  const selectedCategory = useMemo(() => getCategory(form.category), [form.category]);
  const selectedLeague = useMemo(() => getLeague(form.leagueCode), [form.leagueCode]);
  const isLeagueCategory = selectedCategory.scope === "league";
  const isTableSummaryCategory = form.category === "table-summary";
  const isSectionCollapsed = (sectionId) => collapsedSections[sectionId] === true;
  const toggleSection = (sectionId) => {
    setCollapsedSections((current) => ({ ...current, [sectionId]: !current[sectionId] }));
  };

  useEffect(() => {
    safeWriteDraft(GRAPHICS_FORM_DRAFT_KEY, form);
  }, [form]);

  useEffect(() => {
    safeWriteDraft(GRAPHICS_COLLAPSED_DRAFT_KEY, collapsedSections);
  }, [collapsedSections]);

  const seasonMatches = useMemo(
    () => matches.filter((match) => !isPlaceholderTeam(match.home_team_name) && !isPlaceholderTeam(match.away_team_name)),
    [matches]
  );

  const rounds = useMemo(
    () => [...new Set(seasonMatches.map((match) => match.round).filter(Boolean))].sort((a, b) => Number(a) - Number(b)),
    [seasonMatches]
  );

  const roundOptions = useMemo(
    () =>
      rounds.map((round) => ({ value: String(round), label: `${romanRound(round)} kolejka` })),
    [rounds]
  );

  const roundMatches = useMemo(() => {
    const rows = seasonMatches.filter((match) => String(match.round) === String(form.round));
    if (form.category === "round-results") return rows.filter((match) => isCompletedStatus(match.status));
    return rows;
  }, [form.category, form.round, seasonMatches]);

  const renderMatches = useMemo(() => {
    if (form.category === "round-typer") {
      const selected = form.selectedTyperMatchIds.length
        ? roundMatches.filter((match) => form.selectedTyperMatchIds.includes(match.id))
        : roundMatches;
      return selected.slice(0, 5);
    }
    return roundMatches;
  }, [form.category, form.selectedTyperMatchIds, roundMatches]);

  const seasonId = useMemo(() => {
    const found = seasons.find((season) => String(season.year) === String(form.seasonYear));
    return found?.id || "";
  }, [seasons, form.seasonYear]);

  // Teams that actually play in the selected season (derived from fixtures).
  const seasonTeams = useMemo(() => {
    const map = new Map();
    matches.forEach((match) => {
      [
        [match.home_team_id, match.home_team_name, match.home_team_logo],
        [match.away_team_id, match.away_team_name, match.away_team_logo],
      ].forEach(([id, name, logo]) => {
        if (!id || isPlaceholderTeam(name) || map.has(id)) return;
        map.set(id, { id, name: name || "", logo_url: logo || "", leagueCode: match.league_code });
      });
    });
    return [...map.values()].sort((a, b) => a.name.localeCompare(b.name, "pl"));
  }, [matches]);

  // Per-league awards use only the chosen league's teams; otherwise every season team.
  const scopedTeams = useMemo(
    () => (isLeagueCategory ? seasonTeams.filter((team) => team.leagueCode === form.leagueCode) : seasonTeams),
    [seasonTeams, isLeagueCategory, form.leagueCode]
  );
  const scopedTeamIds = useMemo(() => new Set(scopedTeams.map((team) => String(team.id))), [scopedTeams]);

  // Players registered for the season, narrowed to the chosen league's teams for awards.
  const scopedPlayers = useMemo(
    () =>
      seasonPlayers
        .filter((player) => (isLeagueCategory ? scopedTeamIds.has(String(player.teamId)) : true))
        .sort((a, b) => a.name.localeCompare(b.name, "pl")),
    [seasonPlayers, isLeagueCategory, scopedTeamIds]
  );

  const availableSponsorSources = useMemo(
    () =>
      dbSponsors.length
        ? dbSponsors.map((sponsor) => ({
            id: sponsor.id,
            name: sponsor.name,
            url: sponsor.logo_url,
            featured: sponsor.category === "sponsor_tytularny",
            frame: sponsor.logoFrame,
          }))
        : [...SPONSORS_TOP, ...SPONSORS_BOTTOM].map((sponsor) => ({
            id: sponsor.id,
            name: sponsor.name,
            url: resolvePublicPath(sponsor.src),
            featured: !!sponsor.title,
          })),
    [dbSponsors]
  );

  const loadReferenceData = useCallback(async () => {
    setLoading(true);
    try {
      const [seasonRes, sponsorRes] = await Promise.all([
        supabase.from("seasons").select("id, year, name, is_current").order("year", { ascending: false }),
        supabase
          .from("sponsors")
          .select("id, name, logo_url, display_order, is_active, description")
          .or("is_active.is.true,is_active.is.null")
          .order("display_order", { ascending: true })
          .order("name", { ascending: true }),
      ]);
      if (seasonRes.error) throw seasonRes.error;

      const seasonRows = seasonRes.data || [];
      const current = seasonRows.find((season) => season.is_current) || seasonRows[0];
      setSeasons(seasonRows);
      // Partners shown on graphics = active sponsors with a logo (Isola tytularny first).
      setDbSponsors(
        (sponsorRes.data || [])
          .filter((sponsor) => sponsor.logo_url)
          .map((sponsor) => {
            const meta = parseSponsorGraphicsMeta(sponsor.description);
            return {
              ...sponsor,
              category: meta.category || "sponsor",
              logoFrame: normalizeSponsorFrame(meta.logoFrame),
            };
          })
      );
      const loadedSponsorIds = (sponsorRes.data || []).filter((sponsor) => sponsor.logo_url).map((sponsor) => sponsor.id);
      setForm((currentForm) => ({
        ...currentForm,
        seasonYear: currentForm.seasonYear || (current?.year ? String(current.year) : ""),
        periodLabel: currentForm.periodLabel || defaultPeriodLabel(currentForm.periodType, current?.year),
        selectedSponsorIds: currentForm.sponsorSelectionTouched ? currentForm.selectedSponsorIds : loadedSponsorIds,
      }));
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się wczytać danych do kreatora." });
    } finally {
      setLoading(false);
    }
  }, []);

  const loadMatches = useCallback(async (seasonYear) => {
    if (!seasonYear) {
      setMatches([]);
      return;
    }
    setMatchesLoading(true);
    try {
      const { data, error } = await supabase
        .from("v_matches")
        .select(MATCH_SELECT)
        .eq("season_year", Number(seasonYear))
        .order("round", { ascending: true })
        .order("league_code", { ascending: true })
        .order("match_date", { ascending: true, nullsFirst: false })
        .order("match_time", { ascending: true, nullsFirst: false })
        .limit(700);
      if (error) throw error;
      setMatches(data || []);
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się wczytać meczów." });
    } finally {
      setMatchesLoading(false);
    }
  }, []);

  const loadStandings = useCallback(async (seasonYear, leagueCode) => {
    if (!seasonYear || !leagueCode) {
      setStandings([]);
      return;
    }
    setStandingsLoading(true);
    try {
      const { data, error } = await supabase
        .from("v_standings")
        .select(STANDINGS_SELECT)
        .eq("season_year", Number(seasonYear))
        .eq("league_code", leagueCode)
        .order("position", { ascending: true });
      if (error) throw error;
      setStandings(data || []);
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się wczytać tabeli." });
    } finally {
      setStandingsLoading(false);
    }
  }, []);

  const loadSeasonPlayers = useCallback(async (seasonUuid) => {
    if (!seasonUuid) {
      setSeasonPlayers([]);
      return;
    }
    try {
      const { data, error } = await supabase
        .from("team_players")
        .select("team_id, teams(name, logo_url), players(id, first_name, last_name, display_name)")
        .eq("season_id", seasonUuid)
        .is("left_date", null);
      if (error) throw error;
      const seen = new Set();
      const rows = [];
      (data || []).forEach((row) => {
        const player = row.players;
        if (!player || seen.has(player.id)) return;
        const name = player.display_name || [player.first_name, player.last_name].filter(Boolean).join(" ").trim();
        if (!name) return;
        seen.add(player.id);
        rows.push({
          playerId: player.id,
          teamId: row.team_id,
          name,
          teamName: row.teams?.name || "",
          teamLogo: row.teams?.logo_url || "",
        });
      });
      setSeasonPlayers(rows);
    } catch (error) {
      setSeasonPlayers([]);
    }
  }, []);

  useEffect(() => {
    loadReferenceData();
  }, [loadReferenceData]);

  useEffect(() => {
    loadSeasonPlayers(seasonId);
  }, [seasonId, loadSeasonPlayers]);

  useEffect(() => {
    loadMatches(form.seasonYear);
  }, [form.seasonYear, loadMatches]);

  useEffect(() => {
    loadStandings(form.seasonYear, form.leagueCode);
  }, [form.seasonYear, form.leagueCode, loadStandings]);

  useEffect(() => {
    if (form.round || !rounds.length) return;
    const today = new Date().toISOString().slice(0, 10);
    const upcoming = seasonMatches.find((match) => match.match_date && match.match_date >= today);
    setForm((current) => ({
      ...current,
      round: String(upcoming?.round || rounds[0] || ""),
    }));
  }, [form.round, rounds, seasonMatches]);

  useEffect(() => {
    if (form.category !== "round-typer") return;
    setForm((current) => {
      const validIds = new Set(roundMatches.map((match) => match.id));
      const kept = current.selectedTyperMatchIds.filter((id) => validIds.has(id)).slice(0, 5);
      const selected = kept.length ? kept : roundMatches.slice(0, 5).map((match) => match.id);
      // keep the "hit" valid — default it to the first selected match
      const hitMatchId = selected.includes(current.hitMatchId) ? current.hitMatchId : null;
      return { ...current, selectedTyperMatchIds: selected, hitMatchId };
    });
  }, [form.category, form.round, roundMatches]);

  useEffect(() => {
    let cancelled = false;
    async function renderPreview() {
      const canvas = canvasRef.current;
      if (!canvas) return;
      const format = getFormat(form.format);
      const renderSize = getRenderSize(format);
      setPreviewLoading(true);

      // Partners: selected in the creator.
      const selectedSponsorIds = new Set(form.selectedSponsorIds || []);
      const partnerSources = availableSponsorSources.filter((sponsor) => selectedSponsorIds.has(sponsor.id));
      const storedFrames = loadAllFrames();

      const logoUrls = collectLogoUrls(form, renderMatches);
      standings.forEach((row) => {
        if (row.team_logo_url) logoUrls.push(row.team_logo_url);
      });

      const [sponsorImages, teamImages, brandImage] = await Promise.all([
        Promise.all(partnerSources.map(async (partner) => [partner.id, await loadCanvasImage(partner.url)])),
        Promise.all([...new Set(logoUrls)].map(async (url) => [url, await loadCanvasImage(url)])),
        loadCanvasImage(resolvePublicPath(BRAND_LOGO_SRC)),
      ]);

      const sponsorList = partnerSources.map((partner) => ({
        id: partner.id,
        name: partner.name,
        featured: partner.featured,
        frame: normalizeSponsorFrame({
          ...defaultFrame(),
          ...(storedFrames[partner.id] || {}),
          ...(partner.frame || {}),
          glow: true,
          glowAutoColor: false,
          glowColor: DEFAULT_SPONSOR_OUTLINE.color,
          glowStrength: DEFAULT_SPONSOR_OUTLINE.strength,
          glowDensity: DEFAULT_SPONSOR_OUTLINE.density,
          glowBlur: DEFAULT_SPONSOR_OUTLINE.blur,
          glowSize: DEFAULT_SPONSOR_OUTLINE.thickness,
        }),
      }));

      if (cancelled) return;
      canvas.width = renderSize.width;
      canvas.height = renderSize.height;
      const ctx = canvas.getContext("2d");
      ctx.imageSmoothingEnabled = true;
      ctx.imageSmoothingQuality = "high";
      ctx.setTransform(EXPORT_SCALE, 0, 0, EXPORT_SCALE, 0, 0);
      drawGraphic(
        ctx,
        form,
        { matches: renderMatches, standings },
        {
          sponsors: new Map(sponsorImages),
          teamLogos: new Map(teamImages),
          brand: brandImage,
          sponsorList,
        },
        format.width,
        format.height
      );
      setPreviewLoading(false);
    }

    renderPreview();
    return () => {
      cancelled = true;
    };
  }, [form, renderMatches, standings, availableSponsorSources]);

  const updateForm = (patch) => {
    setForm((current) => ({ ...current, ...patch }));
  };

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    if (name === "periodType") {
      updateForm({ periodType: value, periodLabel: defaultPeriodLabel(value, form.seasonYear) });
      return;
    }
    if (name === "seasonYear") {
      updateForm({
        seasonYear: value,
        periodLabel: form.periodType === "season" ? defaultPeriodLabel("season", value) : form.periodLabel,
      });
      return;
    }
    updateForm({ [name]: value });
  };

  const handleCategoryChange = (categoryId) => {
    const category = getCategory(categoryId);
    setForm((current) => ({
      ...current,
      category: categoryId,
      title: "",
      subtitle: "",
      leagueCode: category.scope === "league" ? current.leagueCode : current.leagueCode,
      ...(categoryId === "table-summary" ? { periodType: "season", periodLabel: "" } : {}),
    }));
  };

  const resetCreator = () => {
    setForm((current) => ({
      ...defaultForm(),
      seasonYear: current.seasonYear,
      round: current.round,
      periodLabel: defaultPeriodLabel(current.periodType || "month", current.seasonYear),
      selectedSponsorIds: availableSponsorSources.map((sponsor) => sponsor.id),
      sponsorSelectionTouched: false,
    }));
  };

  const toggleTyperMatch = (matchId) => {
    setForm((current) => {
      const exists = current.selectedTyperMatchIds.includes(matchId);
      const next = exists
        ? current.selectedTyperMatchIds.filter((id) => id !== matchId)
        : [...current.selectedTyperMatchIds, matchId].slice(0, 5);
      let hitMatchId = current.hitMatchId;
      if (!next.includes(hitMatchId)) hitMatchId = next[0] ?? null;
      return { ...current, selectedTyperMatchIds: next, hitMatchId };
    });
  };

  const setHitMatch = (matchId) => {
    setForm((current) => {
      // clicking the star again clears the hit — full freedom to pick any selected match
      if (String(current.hitMatchId) === String(matchId)) {
        return { ...current, hitMatchId: null };
      }
      // marking a match as hit also selects it (max 5)
      const selected = current.selectedTyperMatchIds.includes(matchId)
        ? current.selectedTyperMatchIds
        : [...current.selectedTyperMatchIds, matchId].slice(0, 5);
      return { ...current, selectedTyperMatchIds: selected, hitMatchId: matchId };
    });
  };

  const toggleSponsor = (sponsorId) => {
    setForm((current) => {
      const currentIds = current.selectedSponsorIds || [];
      const exists = currentIds.includes(sponsorId);
      return {
        ...current,
        sponsorSelectionTouched: true,
        selectedSponsorIds: exists
          ? currentIds.filter((id) => id !== sponsorId)
          : [...currentIds, sponsorId],
      };
    });
  };

  const selectAllSponsors = () => {
    setForm((current) => ({
      ...current,
      selectedSponsorIds: availableSponsorSources.map((sponsor) => sponsor.id),
      sponsorSelectionTouched: false,
    }));
  };

  const applyTeamToSlot = (index, teamId) => {
    const team = seasonTeams.find((item) => String(item.id) === String(teamId));
    if (!team) return;
    setForm((current) => ({
      ...current,
      lineup: current.lineup.map((slot, slotIndex) =>
        slotIndex === index ? { ...slot, team: team.name || "", teamId: String(team.id), logoUrl: team.logo_url || "" } : slot
      ),
    }));
  };

  const applyPlayerToSlot = (index, playerId) => {
    const player = seasonPlayers.find((item) => String(item.playerId) === String(playerId));
    if (!player) return;
    setForm((current) => ({
      ...current,
      lineup: current.lineup.map((slot, slotIndex) =>
        slotIndex === index
          ? { ...slot, name: player.name, team: player.teamName || slot.team, teamId: String(player.teamId || ""), logoUrl: player.teamLogo || slot.logoUrl }
          : slot
      ),
    }));
  };

  const updateLineupSlot = (index, patch) => {
    setForm((current) => ({
      ...current,
      lineup: current.lineup.map((slot, slotIndex) => (slotIndex === index ? { ...slot, ...patch } : slot)),
    }));
  };

  const applyTeamToCandidate = (index, teamId) => {
    const team = seasonTeams.find((item) => String(item.id) === String(teamId));
    if (!team) return;
    setForm((current) => ({
      ...current,
      candidates: current.candidates.map((candidate, candidateIndex) =>
        candidateIndex === index ? { ...candidate, team: team.name || "", teamId: String(team.id), logoUrl: team.logo_url || "" } : candidate
      ),
    }));
  };

  const applyPlayerToCandidate = (index, playerId) => {
    const player = seasonPlayers.find((item) => String(item.playerId) === String(playerId));
    if (!player) return;
    setForm((current) => ({
      ...current,
      candidates: current.candidates.map((candidate, candidateIndex) =>
        candidateIndex === index
          ? { ...candidate, name: player.name, team: player.teamName || candidate.team, teamId: String(player.teamId || ""), logoUrl: player.teamLogo || candidate.logoUrl }
          : candidate
      ),
    }));
  };

  const updateCandidate = (index, patch) => {
    setForm((current) => ({
      ...current,
      candidates: current.candidates.map((candidate, candidateIndex) => (candidateIndex === index ? { ...candidate, ...patch } : candidate)),
    }));
  };

  const applyPlayerTeam = (teamId) => {
    const team = seasonTeams.find((item) => String(item.id) === String(teamId));
    if (!team) return;
    updateForm({ playerTeam: team.name || "", playerTeamId: String(team.id), playerLogoUrl: team.logo_url || "" });
  };

  const applyAwardPlayer = (playerId) => {
    const player = seasonPlayers.find((item) => String(item.playerId) === String(playerId));
    if (!player) return;
    updateForm({ playerName: player.name, playerTeam: player.teamName || "", playerTeamId: String(player.teamId || ""), playerLogoUrl: player.teamLogo || "" });
  };

  const downloadGraphic = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    try {
      canvas.toBlob((blob) => {
        if (!blob) {
          setAlert({ type: "error", message: "Nie udało się wyeksportować PNG. Sprawdź logotypy wklejone z zewnętrznych adresów." });
          return;
        }
        const url = URL.createObjectURL(blob);
        const link = document.createElement("a");
        link.href = url;
        link.download = `${sanitizeFileName(["mlpn", form.category, form.format, form.round || form.leagueCode, form.seasonYear].filter(Boolean).join("-"))}.png`;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
        setAlert({ type: "success", message: "Grafika PNG została pobrana." });
      }, "image/png", 1);
    } catch {
      setAlert({ type: "error", message: "Eksport został zablokowany przez zewnętrzny obraz. Użyj logo z bazy albo lokalnego pliku." });
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-2 border-yellow-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold">Kreator grafik</h2>
          <p className={`mt-1 text-sm ${textMuted}`}>
            Dwa formaty, szablony MLPN i stałe belki sponsorów z mocniej wyeksponowaną Isolą.
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <button
            type="button"
            onClick={resetCreator}
            className={`inline-flex items-center gap-2 rounded-xl border px-4 py-2 text-sm font-medium transition-colors ${
              darkMode ? "border-white/10 bg-white/5 text-gray-200 hover:bg-white/10" : "border-gray-200 bg-white text-gray-700 hover:bg-gray-50"
            }`}
          >
            <RefreshCcw size={16} /> Reset
          </button>
          <button
            type="button"
            onClick={downloadGraphic}
            className="inline-flex items-center gap-2 rounded-xl bg-yellow-500 px-4 py-2 text-sm font-semibold text-black transition-colors hover:bg-yellow-400"
          >
            <Download size={16} /> Pobierz PNG
          </button>
        </div>
      </div>

      <AdminAlert type={alert.type} message={alert.message} onClose={() => setAlert({ type: null, message: null })} />

      <div className="grid grid-cols-1 items-start gap-5 xl:grid-cols-[minmax(360px,540px)_1fr]">
        <div className="space-y-4">
          <CollapsibleSection
            title="Format"
            icon={<ImageIcon size={18} className="text-blue-400" />}
            cardClass={card}
            collapsed={isSectionCollapsed("format")}
            onToggle={() => toggleSection("format")}
          >
            <div className="grid grid-cols-2 gap-2">
              {FORMAT_OPTIONS.map((item) => {
                const active = form.format === item.id;
                return (
                  <button
                    key={item.id}
                    type="button"
                    onClick={() => updateForm({ format: item.id })}
                    className={`rounded-xl border px-3 py-3 text-left text-sm transition-colors ${
                      active
                        ? "border-blue-400/50 bg-blue-500/10 text-blue-300"
                        : darkMode
                        ? "border-white/10 bg-white/5 text-gray-300 hover:bg-white/10"
                        : "border-gray-200 bg-white text-gray-700 hover:bg-gray-50"
                    }`}
                  >
                    <span className="block font-black">{item.label}</span>
                    <span className={`block text-xs ${active ? "text-blue-200" : textMuted}`}>{item.sizeLabel}</span>
                  </button>
                );
              })}
            </div>
          </CollapsibleSection>

          <CollapsibleSection
            title="Kategoria"
            icon={<Layers size={18} className="text-yellow-400" />}
            cardClass={card}
            collapsed={isSectionCollapsed("category")}
            onToggle={() => toggleSection("category")}
          >
            <div className={`mb-2 text-xs font-bold uppercase tracking-[0.14em] ${textMuted}`}>Cała MLPN</div>
            <div className="mb-4 grid grid-cols-1 gap-2 sm:grid-cols-3">
              {CATEGORY_OPTIONS.filter((item) => item.scope === "all").map((item) => {
                const Icon = item.icon;
                const active = form.category === item.id;
                return (
                  <button
                    key={item.id}
                    type="button"
                    onClick={() => handleCategoryChange(item.id)}
                    className={`rounded-xl border px-3 py-2 text-left text-sm transition-colors ${
                      active
                        ? "border-yellow-400/50 bg-yellow-500/10 text-yellow-400"
                        : darkMode
                        ? "border-white/10 bg-white/5 text-gray-300 hover:bg-white/10"
                        : "border-gray-200 bg-white text-gray-700 hover:bg-gray-50"
                    }`}
                  >
                    <Icon size={16} className="mb-1" />
                    <span className="block font-semibold leading-tight">{item.label}</span>
                  </button>
                );
              })}
            </div>

            <div className={`mb-2 text-xs font-bold uppercase tracking-[0.14em] ${textMuted}`}>Osobno ligi I / II / III</div>
            <div className="grid grid-cols-1 gap-2 sm:grid-cols-2">
              {CATEGORY_OPTIONS.filter((item) => item.scope === "league").map((item) => {
                const Icon = item.icon;
                const active = form.category === item.id;
                return (
                  <button
                    key={item.id}
                    type="button"
                    onClick={() => handleCategoryChange(item.id)}
                    className={`rounded-xl border px-3 py-2 text-left text-sm transition-colors ${
                      active
                        ? "border-yellow-400/50 bg-yellow-500/10 text-yellow-400"
                        : darkMode
                        ? "border-white/10 bg-white/5 text-gray-300 hover:bg-white/10"
                        : "border-gray-200 bg-white text-gray-700 hover:bg-gray-50"
                    }`}
                  >
                    <Icon size={16} className="mb-1" />
                    <span className="block font-semibold leading-tight">{item.label}</span>
                  </button>
                );
              })}
            </div>
          </CollapsibleSection>

          <CollapsibleSection
            title="Sponsorzy na grafice"
            icon={<Handshake size={18} className="text-emerald-400" />}
            cardClass={card}
            contentClassName="mt-3 space-y-3"
            collapsed={isSectionCollapsed("sponsors")}
            onToggle={() => toggleSection("sponsors")}
            actions={
              <button
                type="button"
                onClick={selectAllSponsors}
                className={`rounded-lg border px-2 py-1 text-[11px] font-semibold transition-colors ${
                  darkMode ? "border-white/10 hover:bg-white/10" : "border-gray-200 hover:bg-gray-50"
                }`}
              >
                Zaznacz wszystkich
              </button>
            }
          >
            <div className={`text-xs ${textMuted}`}>
              Wybrano {form.selectedSponsorIds.length}/{availableSponsorSources.length}.
            </div>
            <AdminFormField
              label="Wiersze sponsorów"
              name="sponsorRows"
              type="select"
              value={String(form.sponsorRows)}
              onChange={handleInputChange}
              darkMode={darkMode}
              includeEmptyOption={false}
              options={SPONSOR_ROW_OPTIONS}
            />
            <div className="grid max-h-56 grid-cols-1 gap-2 overflow-y-auto pr-1 sm:grid-cols-2">
              {availableSponsorSources.map((sponsor) => {
                const checked = form.selectedSponsorIds.includes(sponsor.id);
                return (
                  <label
                    key={sponsor.id}
                    className={`flex cursor-pointer items-center gap-2 rounded-xl border px-3 py-2 text-sm transition-colors ${
                      checked
                        ? "border-emerald-400/50 bg-emerald-500/10"
                        : darkMode
                        ? "border-white/10 bg-white/5 hover:bg-white/10"
                        : "border-gray-200 bg-white hover:bg-gray-50"
                    }`}
                  >
                    <input
                      type="checkbox"
                      checked={checked}
                      onChange={() => toggleSponsor(sponsor.id)}
                      className="h-4 w-4 accent-emerald-600"
                    />
                    <span className="min-w-0 truncate font-semibold">{sponsor.name}</span>
                  </label>
                );
              })}
            </div>
          </CollapsibleSection>

          <CollapsibleSection
            title="Dane"
            icon={<CalendarDays size={18} className="text-sky-400" />}
            cardClass={card}
            contentClassName="mt-4 space-y-4"
            collapsed={isSectionCollapsed("data")}
            onToggle={() => toggleSection("data")}
            actions={(matchesLoading || standingsLoading) ? <Loader2 size={16} className="animate-spin text-yellow-400" /> : null}
          >
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <AdminFormField
                label="Sezon"
                name="seasonYear"
                type="select"
                value={form.seasonYear}
                onChange={handleInputChange}
                darkMode={darkMode}
                includeEmptyOption={false}
                options={seasons.map((season) => ({
                  value: String(season.year),
                  label: season.name || `Sezon ${season.year}`,
                }))}
              />
              {isLeagueCategory && !isTableSummaryCategory && (
                <AdminFormField
                  label="Okres"
                  name="periodType"
                  type="select"
                  value={form.periodType}
                  onChange={handleInputChange}
                  darkMode={darkMode}
                  includeEmptyOption={false}
                  options={PERIOD_OPTIONS}
                />
              )}
              {!isLeagueCategory && (
                <AdminFormField
                  label="Kolejka"
                  name="round"
                  type="select"
                  value={String(form.round)}
                  onChange={handleInputChange}
                  darkMode={darkMode}
                  includeEmptyOption={false}
                  options={roundOptions}
                />
              )}
            </div>

            {isLeagueCategory && (
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <AdminFormField
                  label="Liga"
                  name="leagueCode"
                  type="select"
                  value={form.leagueCode}
                  onChange={handleInputChange}
                  darkMode={darkMode}
                  includeEmptyOption={false}
                  options={LEAGUE_OPTIONS.map((league) => ({ value: league.value, label: league.label }))}
                />
                {!isTableSummaryCategory && form.periodType === "month" && (
                  <AdminFormField
                    label="Miesiąc"
                    name="periodLabel"
                    type="select"
                    value={form.periodLabel}
                    onChange={handleInputChange}
                    darkMode={darkMode}
                    includeEmptyOption={false}
                    options={MONTH_OPTIONS}
                  />
                )}
                {!isTableSummaryCategory && form.periodType === "round" && (
                  <AdminFormField
                    label="Runda"
                    name="periodLabel"
                    type="select"
                    value={form.periodLabel}
                    onChange={handleInputChange}
                    darkMode={darkMode}
                    includeEmptyOption={false}
                    options={ROUND_PERIOD_OPTIONS}
                  />
                )}
                {!isTableSummaryCategory && form.periodType === "season" && (
                  <AdminFormField
                    label="Rok okresu"
                    name="periodLabel"
                    type="number"
                    value={form.periodLabel}
                    onChange={handleInputChange}
                    darkMode={darkMode}
                    placeholder="np. 2026"
                  />
                )}
              </div>
            )}

            {!isLeagueCategory && (
              <div className={`rounded-xl border px-3 py-2 text-xs ${softPanel} ${textMuted}`}>
                W tej kolejce: {roundMatches.length} spotkań. Typer pokaże maksymalnie 5 zaznaczonych meczów.
              </div>
            )}

            {(form.category === "round-preview" || form.category === "round-results") && (
              <AdminFormField
                label="Mecz-hit kolejki (opcjonalnie)"
                name="hitMatchId"
                type="select"
                value={form.hitMatchId ?? ""}
                onChange={(event) => updateForm({ hitMatchId: event.target.value || null })}
                darkMode={darkMode}
                includeEmptyOption={false}
                options={[
                  { value: "", label: "Bez hitu" },
                  ...roundMatches.map((match) => ({
                    value: String(match.id),
                    label: `${match.home_team_name} – ${match.away_team_name}`,
                  })),
                ]}
              />
            )}
          </CollapsibleSection>

          {form.category === "round-typer" && (
            <CollapsibleSection
              title="Mecze do typera"
              icon={<Vote size={18} className="text-pink-400" />}
              cardClass={card}
              contentClassName="mt-3 space-y-3"
              collapsed={isSectionCollapsed("typer-matches")}
              onToggle={() => toggleSection("typer-matches")}
              actions={<span className={`text-xs ${textMuted}`}>{form.selectedTyperMatchIds.length}/5</span>}
            >
              <div className={`text-xs ${textMuted}`}>Kliknij kafelek, aby wybrać mecz. Gwiazdką ★ oznacz „hit kolejki".</div>
              <div className="grid max-h-96 grid-cols-1 gap-2 overflow-y-auto pr-1 sm:grid-cols-2">
                {roundMatches.map((match) => {
                  const checked = form.selectedTyperMatchIds.includes(match.id);
                  const isHit = String(form.hitMatchId) === String(match.id);
                  const locked = !checked && form.selectedTyperMatchIds.length >= 5;
                  const time = match.match_time ? match.match_time.slice(0, 5) : "";
                  return (
                    <div
                      key={match.id}
                      onClick={() => !locked && toggleTyperMatch(match.id)}
                      className={`relative cursor-pointer rounded-xl border p-2 transition-colors ${
                        checked
                          ? "border-yellow-400/50 bg-yellow-500/10"
                          : darkMode
                          ? "border-white/10 bg-white/5 hover:bg-white/10"
                          : "border-gray-200 bg-white hover:bg-gray-50"
                      } ${isHit ? "ring-2 ring-yellow-400" : ""} ${locked ? "opacity-40" : ""}`}
                    >
                      <div className="flex items-center gap-2">
                        <img
                          src={resolvePublicPath(match.home_team_logo)}
                          alt=""
                          onError={(event) => {
                            event.currentTarget.style.visibility = "hidden";
                          }}
                          className="h-9 w-9 shrink-0 rounded bg-white/85 object-contain p-0.5"
                        />
                        <div className="min-w-0 flex-1 text-center">
                          <div className="truncate text-xs font-bold">
                            {(match.home_team_abbr || match.home_team_name)} – {(match.away_team_abbr || match.away_team_name)}
                          </div>
                          <div className={`text-[11px] ${textMuted}`}>
                            {[formatShortDate(match.match_date), time].filter(Boolean).join(" · ")}
                          </div>
                        </div>
                        <img
                          src={resolvePublicPath(match.away_team_logo)}
                          alt=""
                          onError={(event) => {
                            event.currentTarget.style.visibility = "hidden";
                          }}
                          className="h-9 w-9 shrink-0 rounded bg-white/85 object-contain p-0.5"
                        />
                      </div>
                      <button
                        type="button"
                        onClick={(event) => {
                          event.stopPropagation();
                          setHitMatch(match.id);
                        }}
                        title="Oznacz jako hit kolejki"
                        className={`absolute -right-1.5 -top-1.5 rounded-full border px-1.5 py-0.5 text-[10px] font-bold leading-none shadow ${
                          isHit
                            ? "border-yellow-500 bg-yellow-400 text-black"
                            : darkMode
                            ? "border-white/20 bg-[#1a1f2e] text-gray-300"
                            : "border-gray-300 bg-white text-gray-500"
                        }`}
                      >
                        ★ HIT
                      </button>
                    </div>
                  );
                })}
                {!roundMatches.length && (
                  <div className={`rounded-xl border p-3 text-sm sm:col-span-2 ${softPanel} ${textMuted}`}>Brak meczów w tej kolejce.</div>
                )}
              </div>
            </CollapsibleSection>
          )}

          {form.category === "best-eight" && (
            <CollapsibleSection
              title="Skład najlepszej 8"
              icon={<Users size={18} className="text-green-400" />}
              cardClass={card}
              contentClassName="mt-4 space-y-4"
              collapsed={isSectionCollapsed("best-eight")}
              onToggle={() => toggleSection("best-eight")}
            >
              <div className="hidden">
                <Users size={18} className="text-green-400" />
                Skład najlepszej 8
              </div>
              <div className="space-y-1">
                <label className={`block text-xs font-medium ${textMuted}`}>Formacja</label>
                <div className="flex flex-wrap gap-2">
                  {FORMATIONS.map((formation) => (
                    <button
                      key={formation.id}
                      type="button"
                      onClick={() => updateForm({ formation: formation.id })}
                      className={`rounded-lg border px-3 py-1.5 text-sm font-semibold transition-colors ${
                        form.formation === formation.id
                          ? "border-yellow-400/50 bg-yellow-500/10 text-yellow-400"
                          : darkMode
                          ? "border-white/10 bg-white/5 text-gray-300 hover:bg-white/10"
                          : "border-gray-200 bg-white text-gray-700 hover:bg-gray-50"
                      }`}
                    >
                      {formation.label}
                    </button>
                  ))}
                </div>
              </div>
              <div className={`text-xs ${textMuted}`}>
                Listy zawierają wyłącznie drużyny i zawodników z sezonu {form.seasonYear || "—"}
                {isLeagueCategory ? ` · ${selectedLeague.label}` : ""}.
              </div>
              <div className="grid grid-cols-1 gap-3">
                {form.lineup.map((slot, index) => (
                  <div key={index} className={`rounded-xl border p-3 ${softPanel}`}>
                    <div className="mb-2 flex flex-wrap items-center justify-between gap-2">
                      <span className="font-bold">{getFormation(form.formation).slots[index]?.label || `#${index + 1}`}</span>
                      <div className="flex flex-wrap gap-2">
                        <select value="" onChange={(event) => applyTeamToSlot(index, event.target.value)} className={`rounded-lg border px-2 py-1 text-xs ${inputClass}`}>
                          <option value="" style={optionStyle}>Drużyna...</option>
                          {scopedTeams.map((team) => <option key={team.id} value={team.id} style={optionStyle}>{team.name}</option>)}
                        </select>
                        <select value="" onChange={(event) => applyPlayerToSlot(index, event.target.value)} className={`rounded-lg border px-2 py-1 text-xs ${inputClass}`}>
                          <option value="" style={optionStyle}>Zawodnik...</option>
                          {filterPlayersByTeam(scopedPlayers, slot.teamId)
                            .map((player) => (
                              <option key={player.playerId} value={player.playerId} style={optionStyle}>
                                {player.name}{player.teamName ? ` · ${player.teamName}` : ""}
                              </option>
                            ))}
                        </select>
                      </div>
                    </div>
                    <div className="grid grid-cols-1 gap-2 sm:grid-cols-2">
                      <input
                        value={slot.name}
                        onChange={(event) => updateLineupSlot(index, { name: event.target.value })}
                        placeholder="Imię i nazwisko"
                        className={`rounded-xl border px-3 py-2 text-sm ${inputClass}`}
                      />
                      <input
                        value={slot.logoUrl}
                        onChange={(event) => updateLineupSlot(index, { logoUrl: event.target.value })}
                        placeholder="URL logo"
                        className={`rounded-xl border px-3 py-2 text-sm ${inputClass}`}
                      />
                    </div>
                  </div>
                ))}
              </div>
            </CollapsibleSection>
          )}

          {form.category === "player-award" && (
            <CollapsibleSection
              title="Zawodnik okresu"
              icon={<Star size={18} className="text-yellow-400" />}
              cardClass={card}
              contentClassName="mt-4 space-y-4"
              collapsed={isSectionCollapsed("player-award")}
              onToggle={() => toggleSection("player-award")}
            >
              <div className="hidden">
                <Star size={18} className="text-yellow-400" />
                Zawodnik okresu
              </div>
              <div className={`text-xs ${textMuted}`}>
                Listy zawierają wyłącznie drużyny i zawodników z sezonu {form.seasonYear || "—"}
                {isLeagueCategory ? ` · ${selectedLeague.label}` : ""}.
              </div>
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <div className="space-y-1">
                  <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Drużyna z sezonu</label>
                  <select value="" onChange={(event) => applyPlayerTeam(event.target.value)} className={`w-full rounded-xl border px-3 py-2 ${inputClass}`}>
                    <option value="" style={optionStyle}>Wybierz...</option>
                    {scopedTeams.map((team) => <option key={team.id} value={team.id} style={optionStyle}>{team.name}</option>)}
                  </select>
                </div>
                <div className="space-y-1">
                  <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Zawodnik z sezonu</label>
                  <select value="" onChange={(event) => applyAwardPlayer(event.target.value)} className={`w-full rounded-xl border px-3 py-2 ${inputClass}`}>
                    <option value="" style={optionStyle}>Wybierz zawodnika...</option>
                    {filterPlayersByTeam(scopedPlayers, form.playerTeamId).map((player) => (
                      <option key={player.playerId} value={player.playerId} style={optionStyle}>
                        {player.name}{player.teamName ? ` · ${player.teamName}` : ""}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              <AdminFormField label="Imię i nazwisko" name="playerName" value={form.playerName} onChange={handleInputChange} darkMode={darkMode} placeholder="Wybierz z listy lub wpisz ręcznie" />
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <AdminFormField label="URL zdjęcia" name="playerPhotoUrl" value={form.playerPhotoUrl} onChange={handleInputChange} darkMode={darkMode} />
                <AdminFormField label="URL logo drużyny" name="playerLogoUrl" value={form.playerLogoUrl} onChange={handleInputChange} darkMode={darkMode} />
              </div>
              <AdminFormField label="Dopisek" name="playerCaption" type="textarea" value={form.playerCaption} onChange={handleInputChange} darkMode={darkMode} />
            </CollapsibleSection>
          )}

          {form.category === "player-vote" && (
            <CollapsibleSection
              title="Kandydaci do głosowania"
              icon={<Vote size={18} className="text-pink-400" />}
              cardClass={card}
              contentClassName="mt-4 space-y-4"
              collapsed={isSectionCollapsed("player-vote")}
              onToggle={() => toggleSection("player-vote")}
            >
              <div className="hidden">
                <Vote size={18} className="text-pink-400" />
                Kandydaci do głosowania
              </div>
              <div className={`text-xs ${textMuted}`}>
                Listy zawierają wyłącznie drużyny i zawodników z sezonu {form.seasonYear || "—"}
                {isLeagueCategory ? ` · ${selectedLeague.label}` : ""}.
              </div>
              {form.candidates.map((candidate, index) => (
                <div key={index} className={`rounded-xl border p-3 ${softPanel}`}>
                  <div className="mb-2 flex flex-wrap items-center justify-between gap-2">
                    <span className="font-bold">Kandydat {index + 1}</span>
                    <div className="flex flex-wrap gap-2">
                      <select value="" onChange={(event) => applyTeamToCandidate(index, event.target.value)} className={`rounded-lg border px-2 py-1 text-xs ${inputClass}`}>
                        <option value="" style={optionStyle}>Drużyna...</option>
                        {scopedTeams.map((team) => <option key={team.id} value={team.id} style={optionStyle}>{team.name}</option>)}
                      </select>
                      <select value="" onChange={(event) => applyPlayerToCandidate(index, event.target.value)} className={`rounded-lg border px-2 py-1 text-xs ${inputClass}`}>
                        <option value="" style={optionStyle}>Zawodnik...</option>
                        {filterPlayersByTeam(scopedPlayers, candidate.teamId).map((player) => (
                          <option key={player.playerId} value={player.playerId} style={optionStyle}>
                            {player.name}{player.teamName ? ` · ${player.teamName}` : ""}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>
                  <div className="grid grid-cols-1 gap-2 sm:grid-cols-2">
                    <input value={candidate.name} onChange={(event) => updateCandidate(index, { name: event.target.value })} placeholder="Imię i nazwisko" className={`rounded-xl border px-3 py-2 text-sm ${inputClass}`} />
                    <input value={candidate.reaction} onChange={(event) => updateCandidate(index, { reaction: event.target.value })} placeholder="Reakcja" className={`rounded-xl border px-3 py-2 text-sm ${inputClass}`} />
                    <input value={candidate.photoUrl} onChange={(event) => updateCandidate(index, { photoUrl: event.target.value })} placeholder="URL zdjęcia" className={`rounded-xl border px-3 py-2 text-sm ${inputClass}`} />
                    <input value={candidate.logoUrl} onChange={(event) => updateCandidate(index, { logoUrl: event.target.value })} placeholder="URL logo drużyny" className={`rounded-xl border px-3 py-2 text-sm ${inputClass}`} />
                  </div>
                </div>
              ))}
            </CollapsibleSection>
          )}
        </div>

        <div className={`sticky top-24 rounded-2xl border p-4 ${panel}`}>
          <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
            <div>
              <div className="font-semibold">Podgląd</div>
              <div className={`text-xs ${textMuted}`}>
                {selectedFormat.label} | PNG {selectedRenderSize.sizeLabel} | {selectedCategory.label}
                {isLeagueCategory ? ` | ${selectedLeague.label}` : ""}
              </div>
            </div>
            {previewLoading && (
              <span className={`inline-flex items-center gap-2 rounded-full border px-3 py-1 text-xs ${softPanel}`}>
                <Loader2 size={14} className="animate-spin" /> Render
              </span>
            )}
          </div>
          <div className={`overflow-auto rounded-2xl border p-3 ${darkMode ? "border-white/10 bg-black/20" : "border-gray-200 bg-gray-100"}`}>
            <canvas
              ref={canvasRef}
              width={selectedRenderSize.width}
              height={selectedRenderSize.height}
              className="block h-auto w-full rounded-xl shadow-2xl"
              style={{ maxHeight: "72vh", objectFit: "contain" }}
            />
          </div>
          <div className="mt-4 flex flex-wrap items-center justify-between gap-3">
            <div className={`text-xs ${textMuted}`}>PNG renderowany lokalnie w przeglądarce.</div>
            <button
              type="button"
              onClick={downloadGraphic}
              className="inline-flex items-center gap-2 rounded-xl bg-yellow-500 px-4 py-2 text-sm font-semibold text-black transition-colors hover:bg-yellow-400"
            >
              <Download size={16} /> Pobierz
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
