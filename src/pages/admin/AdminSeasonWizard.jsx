import React, { useState, useEffect, useCallback, useMemo, useRef } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import {
  Check, ChevronRight, ChevronLeft, Loader2, Sparkles, Copy,
  ArrowRight, Calendar, Clock, Rocket, Eye, Settings2, X,
  Users, Search, UserPlus, UserMinus, Undo2,
} from "lucide-react";

// ── Helpers ──
const pad2 = (n) => String(n).padStart(2, "0");
const fmtDate = (d) => `${d.getFullYear()}-${pad2(d.getMonth() + 1)}-${pad2(d.getDate())}`;
const dayLabels = ["Pon", "Wt", "Śr", "Czw", "Pt", "Sob", "Nie"];
const monthLabels = ["Styczeń","Luty","Marzec","Kwiecień","Maj","Czerwiec","Lipiec","Sierpień","Wrzesień","Październik","Listopad","Grudzień"];
const roundsPerRunda = (c) => {
  if (c < 2) return 0;
  return c % 2 === 0 ? c - 1 : c;
};
const roundsForTeams = (c) => roundsPerRunda(c) * 2;

function genMonthDays(y, m) {
  const first = new Date(y, m, 1);
  const last = new Date(y, m + 1, 0);
  const pad = (first.getDay() + 6) % 7;
  const days = [];
  for (let i = 0; i < pad; i++) days.push(null);
  for (let d = 1; d <= last.getDate(); d++) days.push(new Date(y, m, d));
  return days;
}

function addDaysToDateStr(dateStr, days) {
  const d = new Date(`${dateStr}T12:00:00`);
  d.setDate(d.getDate() + days);
  return fmtDate(d);
}

function getWeekendSat(date) {
  const d = date.getDay();
  if (d === 6) return fmtDate(date);
  if (d === 0) { const s = new Date(date); s.setDate(s.getDate() - 1); return fmtDate(s); }
  if (d === 1) { const s = new Date(date); s.setDate(s.getDate() - 2); return fmtDate(s); }
  return null;
}

// Generuj sloty czasowe od startTime co (dur+brk) min
function genSlots(startTime, dur, brk, count) {
  const [h, m] = startTime.split(":").map(Number);
  let totalMin = h * 60 + m;
  const slots = [];
  for (let i = 0; i < count; i++) {
    const sh = Math.floor(totalMin / 60), sm = totalMin % 60;
    const eh = Math.floor((totalMin + dur) / 60), em = (totalMin + dur) % 60;
    slots.push({ start: `${pad2(sh)}:${pad2(sm)}`, end: `${pad2(eh)}:${pad2(em)}`, league: null });
    totalMin += dur + brk;
  }
  return slots;
}

// Opcje priorytetów rozstrzygania (alfabetycznie)
const TIEBREAKER_OPTIONS = [
  { value: "goal_diff", label: "Bilans bramkowy" },
  { value: "away_goals", label: "Bramki na wyjazdach" },
  { value: "goals_conceded", label: "Bramki stracone" },
  { value: "goals_scored", label: "Bramki strzelone" },
  { value: "fair_play", label: "Fair play (mniej kartek)" },
  { value: "alphabetical", label: "Kolejność alfabetyczna" },
  { value: "draws", label: "Liczba remisów" },
  { value: "wins", label: "Liczba wygranych" },
  { value: "head_to_head", label: "Mecze bezpośrednie" },
  { value: "points", label: "Punkty" },
];

// ══════════════════════════════════════
export default function AdminSeasonWizard({ darkMode }) {
  const [step, setStep] = useState(1);

  // ── Toast system ──
  const [toasts, setToasts] = useState([]);
  const toastIdRef = useRef(0);
  const addToast = useCallback((type, message) => {
    const id = ++toastIdRef.current;
    setToasts(prev => [...prev, { id, type, message, fading: false }]);
    setTimeout(() => setToasts(prev => prev.map(t => t.id === id ? { ...t, fading: true } : t)), 4000);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 5000);
  }, []);

  // ── Krok 1: Sezon (LOCAL) ──
  const [seasonForm, setSeasonForm] = useState({
    year: new Date().getFullYear() + 1, name: "", start_date: "",
  });

  // ── Krok 2: Zasady (LOCAL) ──
  const [matchDuration, setMatchDuration] = useState(60);
  const [breakBetween, setBreakBetween] = useState(10);
  const [rules, setRules] = useState({
    points_win: 3, points_draw: 1, points_loss: 0,
    walkover_goals_winner: 3, walkover_goals_loser: 0,
    yellow_card_suspension_threshold: 3,
  });
  const [leagueRules, setLeagueRules] = useState({}); // { leagueId: { promotion_spots, relegation_spots } }
  const [tiebreakers, setTiebreakers] = useState([
    "points", "head_to_head", "goal_diff", "goals_scored", "fair_play",
  ]);

  // ── Krok 3: Drużyny (LOCAL) ──
  const [allTeams, setAllTeams] = useState([]);
  const [leagues, setLeagues] = useState([]);
  const [teamAssignments, setTeamAssignments] = useState({});
  const [activeLeagueIdx, setActiveLeagueIdx] = useState(0);
  const [leagueTeamSearch, setLeagueTeamSearch] = useState("");

  // ── Krok 4: Składy (LOCAL) ──
  const [rosterDraft, setRosterDraft] = useState({}); // { teamId: { kept: [...], released: [...], added: [...] } }
  const [activeRosterTeamIdx, setActiveRosterTeamIdx] = useState(0);
  const [showCallUpModal, setShowCallUpModal] = useState(false);
  const [rosterLoading, setRosterLoading] = useState(false);
  const [callUpSearch, setCallUpSearch] = useState("");
  const [allPlayersForCallUp, setAllPlayersForCallUp] = useState([]);

  // ── Krok 5: Kalendarz (LOCAL) ──
  const [matchWeekends, setMatchWeekends] = useState([]);
  const [calMonth, setCalMonth] = useState(null);

  // ── Krok 6: Timeline (LOCAL) ──
  const [satStart, setSatStart] = useState("14:00");
  const [sunStart, setSunStart] = useState("14:00");
  const [monStart, setMonStart] = useState("14:00");
  const [satSlots, setSatSlots] = useState([]);
  const [sunSlots, setSunSlots] = useState([]);
  const [monSlots, setMonSlots] = useState([]);
  const [activeTile, setActiveTile] = useState(null); // leagueId aktualnie wybranego kafelka

  // ── Krok 7-9: Generowanie ──
  const [generating, setGenerating] = useState(false);
  const [genLog, setGenLog] = useState([]);
  const [createdSeasonId, setCreatedSeasonId] = useState(null);
  const [previewMatches, setPreviewMatches] = useState([]);
  const [previewLeague, setPreviewLeague] = useState("");
  const [selectedSwapMatch, setSelectedSwapMatch] = useState(null);
  const [publishing, setPublishing] = useState(false);

  // ── Tryb edycji istniejącego sezonu ──
  const [editSeasonId, setEditSeasonId] = useState(null);
  const [existingSeasons, setExistingSeasons] = useState([]);
  const [editHasResults, setEditHasResults] = useState(false);

  // ── Style ──
  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const muted = darkMode ? "text-gray-400" : "text-gray-500";
  const btnP = "px-6 py-2.5 rounded-xl bg-yellow-500 text-black font-semibold hover:bg-yellow-400 transition-colors disabled:opacity-40 disabled:cursor-not-allowed";
  const btnS = `px-4 py-2 rounded-xl border font-medium transition-colors ${darkMode ? "border-white/10 text-gray-300 hover:bg-white/5" : "border-gray-200 text-gray-700 hover:bg-gray-50"}`;

  // ── Load teams + leagues ──
  const loadBase = useCallback(async () => {
    const [{ data: t }, { data: l }, { data: es }] = await Promise.all([
      supabase.from("teams").select("id, name, abbreviation, is_active, logo_url").eq("is_active", true).order("name"),
      supabase.from("leagues").select("*").order("display_order"),
      supabase.from("seasons").select("*").order("year", { ascending: false }),
    ]);
    setAllTeams(t || []);
    setExistingSeasons(es || []);
    const lgs = l || [];
    setLeagues(lgs);
    // Domyślne zasady per liga
    const lr = {};
    for (const lg of lgs) {
      lr[lg.id] = {
        promotion_spots: lg.code === "1st" ? 0 : 2,
        relegation_spots: lg.code === "3rd" ? 0 : 2,
      };
    }
    setLeagueRules(lr);
  }, []);

  useEffect(() => { loadBase(); }, [loadBase]);

  const loadExistingSeason = async (seasonId) => {
    const { data: season } = await supabase.from("seasons").select("*").eq("id", seasonId).single();
    if (!season) { addToast("error", "Nie znaleziono sezonu"); return; }

    setEditSeasonId(seasonId);
    setSeasonForm({ year: season.year, name: season.name, start_date: season.start_date || "" });

    const { data: sl } = await supabase.from("season_leagues").select("*").eq("season_id", seasonId);
    if (sl?.length) {
      const first = sl[0];
      setRules({
        points_win: first.points_win ?? 3, points_draw: first.points_draw ?? 1, points_loss: first.points_loss ?? 0,
        walkover_goals_winner: first.walkover_goals_winner ?? 3, walkover_goals_loser: first.walkover_goals_loser ?? 0,
        yellow_card_suspension_threshold: first.yellow_card_suspension_threshold ?? 3,
      });
      const lr = {};
      for (const s of sl) lr[s.league_id] = { promotion_spots: s.promotion_spots ?? 0, relegation_spots: s.relegation_spots ?? 0 };
      setLeagueRules(lr);
    }

    const { data: st } = await supabase.from("season_teams").select("team_id, league_id").eq("season_id", seasonId);
    if (st?.length) {
      const ta = {};
      for (const s of st) ta[s.team_id] = s.league_id;
      setTeamAssignments(ta);
    }

    const { data: matches } = await supabase.from("matches")
      .select("match_date, match_time").eq("season_id", seasonId)
      .not("match_date", "is", null).order("match_date");
    if (matches?.length) {
      const saturdays = new Set();
      for (const m of matches) {
        const d = new Date(m.match_date + "T12:00:00");
        const dow = d.getDay();
        if (dow === 0) d.setDate(d.getDate() - 1);
        else if (dow === 1) d.setDate(d.getDate() - 2);
        else if (dow !== 6) continue;
        saturdays.add(fmtDate(d));
      }
      setMatchWeekends([...saturdays].sort());
      let eSat = "23:59", eSun = "23:59", eMon = "23:59";
      for (const m of matches) {
        if (!m.match_date || !m.match_time) continue;
        const dow = new Date(m.match_date + "T12:00:00").getDay();
        const tm = m.match_time.slice(0, 5);
        if (dow === 6 && tm < eSat) eSat = tm;
        if (dow === 0 && tm < eSun) eSun = tm;
        if (dow === 1 && tm < eMon) eMon = tm;
      }
      if (eSat !== "23:59") setSatStart(eSat);
      if (eSun !== "23:59") setSunStart(eSun);
      if (eMon !== "23:59") setMonStart(eMon);
    }

    const { count } = await supabase.from("matches")
      .select("*", { count: "exact", head: true })
      .eq("season_id", seasonId).not("status", "eq", "scheduled");
    setEditHasResults((count || 0) > 0);

    const sd = season.start_date || matches?.[0]?.match_date;
    if (sd) { const d = new Date(sd); setCalMonth({ year: d.getFullYear(), month: d.getMonth() }); }

    addToast("success", `Załadowano: ${season.name}`);
  };

  const resetWizard = () => {
    setEditSeasonId(null); setEditHasResults(false);
    setSeasonForm({ year: new Date().getFullYear() + 1, name: "", start_date: "" });
    setTeamAssignments({}); setMatchWeekends([]); setStep(1);
    setRosterDraft({}); setActiveRosterTeamIdx(0);
    setCreatedSeasonId(null); setGenLog([]); setPreviewMatches([]);
    setSatSlots([]); setSunSlots([]); setMonSlots([]);
  };

  const steps = [
    { num: 1, label: "Sezon" }, { num: 2, label: "Zasady" },
    { num: 3, label: "Drużyny" }, { num: 4, label: "Składy" },
    { num: 5, label: "Kalendarz" }, { num: 6, label: "Timeline" },
    { num: 7, label: "Generuj" }, { num: 8, label: "Podgląd" },
    { num: 9, label: "Publikuj" },
  ];

  const tpl = (lid) => Object.values(teamAssignments).filter(v => v === lid).length;
  // Max kolejek w jednej rundzie (po wszystkich ligach) — wyznacza granicę R1/R2
  const maxRPR = useMemo(() => Math.max(...leagues.map(l => roundsPerRunda(tpl(l.id))), 0), [leagues, teamAssignments]);
  const totalRoundsNeeded = maxRPR * 2;
  // Etykieta weekendu: R1K1, R1K2... R2K12, R2K13...
  const rundaLabel = (wkIdx) => wkIdx < maxRPR ? `R1K${wkIdx + 1}` : `R2K${wkIdx + 1}`;

  // Ile meczów per kolejkę per liga
  const matchesPerRound = (lid) => Math.floor(tpl(lid) / 2);
  const totalMatchesPerRound = leagues.reduce((s, l) => s + matchesPerRound(l.id), 0);

  // ═══ KROK 3: Drużyny ═══
  const curLeague = leagues[activeLeagueIdx] || null;
  const availTeams = allTeams.filter(t => { const a = teamAssignments[t.id]; return !a || (curLeague && a === curLeague.id); });
  const inCurLeague = curLeague ? allTeams.filter(t => teamAssignments[t.id] === curLeague.id) : [];
  const availableTeamsOutsideCurrentLeague = availTeams.filter(t => teamAssignments[t.id] !== curLeague?.id);
  const filteredAvailableTeams = useMemo(() => {
    const query = leagueTeamSearch.trim().toLowerCase();
    if (!query) return availableTeamsOutsideCurrentLeague;

    return availableTeamsOutsideCurrentLeague.filter((team) => {
      const haystack = [team.name, team.abbreviation].filter(Boolean).join(" ").toLowerCase();
      return haystack.includes(query);
    });
  }, [availableTeamsOutsideCurrentLeague, leagueTeamSearch]);

  const toggleTeam = (id) => {
    if (!curLeague) return;
    setTeamAssignments(p => { const c = { ...p }; c[id] === curLeague.id ? delete c[id] : c[id] = curLeague.id; return c; });
  };

  const importTeams = async () => {
    const { data: s } = await supabase.from("seasons").select("id, year").lt("year", parseInt(seasonForm.year)).order("year", { ascending: false }).limit(1);
    if (!s?.length) { addToast("error", "Brak poprzedniego sezonu"); return; }
    const { data: pt } = await supabase.from("season_teams").select("team_id, league_id").eq("season_id", s[0].id);
    if (!pt?.length) { addToast("error", "Brak drużyn"); return; }
    const m = {}; for (const p of pt) m[p.team_id] = p.league_id;
    setTeamAssignments(m);
    addToast("success", `Import ${pt.length} drużyn`);
  };

  // ═══ KROK 4: Składy ═══
  const assignedTeamIds = useMemo(() => Object.keys(teamAssignments), [teamAssignments]);
  const rosterTeams = useMemo(() => {
    // Pogrupuj po ligach
    const byLeague = {};
    for (const lg of leagues) byLeague[lg.id] = [];
    for (const [tid, lid] of Object.entries(teamAssignments)) {
      const team = allTeams.find(t => t.id === tid);
      if (team && byLeague[lid]) byLeague[lid].push(team);
    }
    const result = [];
    for (const lg of leagues) {
      for (const t of (byLeague[lg.id] || []).sort((a, b) => a.name.localeCompare(b.name, "pl"))) {
        result.push({ ...t, leagueId: lg.id, leagueName: lg.name });
      }
    }
    return result;
  }, [teamAssignments, allTeams, leagues]);

  const loadRosterDraft = useCallback(async () => {
    if (Object.keys(rosterDraft).length > 0 || assignedTeamIds.length === 0) return;
    setRosterLoading(true);
    try {
      // Znajdź poprzedni sezon
      const { data: prevSeasons } = await supabase.from("seasons")
        .select("id, year").lt("year", parseInt(seasonForm.year))
        .order("year", { ascending: false }).limit(1);
      const prevSid = prevSeasons?.[0]?.id;
      const draft = {};

      if (prevSid) {
        // Pobierz aktywnych graczy z poprzedniego sezonu
        const { data: tp } = await supabase.from("team_players")
          .select("id, team_id, player_id, position, shirt_number, is_captain, players(id, first_name, last_name)")
          .eq("season_id", prevSid).is("left_date", null);

        for (const tid of assignedTeamIds) {
          const teamPlayers = (tp || []).filter(p => p.team_id === tid).map(p => ({
            player_id: p.player_id,
            display_name: `${p.players?.first_name || ""} ${p.players?.last_name || ""}`.trim(),
            position: p.position,
            shirt_number: p.shirt_number,
            is_captain: p.is_captain,
            source_tp_id: p.id,
          }));
          draft[tid] = { kept: teamPlayers, released: [], added: [] };
        }
      } else {
        for (const tid of assignedTeamIds) draft[tid] = { kept: [], released: [], added: [] };
      }

      // Inicjalizuj brakujące drużyny (nowe, bez historii)
      for (const tid of assignedTeamIds) {
        if (!draft[tid]) draft[tid] = { kept: [], released: [], added: [] };
      }

      setRosterDraft(draft);

      // Pobierz wszystkich graczy do modala powołań
      const { data: ap } = await supabase.from("players")
        .select("id, first_name, last_name").order("last_name");
      setAllPlayersForCallUp(ap || []);
    } catch (err) {
      addToast("error", "Błąd ładowania kadr: " + err.message);
    } finally {
      setRosterLoading(false);
    }
  }, [rosterDraft, assignedTeamIds, seasonForm.year, addToast]);

  useEffect(() => { if (step === 4) loadRosterDraft(); }, [step, loadRosterDraft]);

  const activeRosterTeam = rosterTeams[activeRosterTeamIdx] || null;
  const activeRosterData = activeRosterTeam ? rosterDraft[activeRosterTeam.id] : null;

  const releasePlayer = (teamId, playerId) => {
    setRosterDraft(prev => {
      const t = { ...prev[teamId] };
      const fromKept = t.kept.find(p => p.player_id === playerId);
      const fromAdded = t.added.find(p => p.player_id === playerId);
      if (fromKept) {
        t.kept = t.kept.filter(p => p.player_id !== playerId);
        t.released = [...t.released, fromKept];
      } else if (fromAdded) {
        // Usuwamy dodanego — cofamy transfer
        t.added = t.added.filter(p => p.player_id !== playerId);
        // Przywróć w źródłowej drużynie jeśli był transfer
        if (fromAdded.from_team_id) {
          const src = { ...prev[fromAdded.from_team_id] };
          src.kept = [...src.kept, { ...fromAdded, from_team_id: undefined }];
          return { ...prev, [teamId]: t, [fromAdded.from_team_id]: src };
        }
      }
      return { ...prev, [teamId]: t };
    });
  };

  const restorePlayer = (teamId, playerId) => {
    setRosterDraft(prev => {
      const t = { ...prev[teamId] };
      const p = t.released.find(p => p.player_id === playerId);
      if (!p) return prev;
      t.released = t.released.filter(p => p.player_id !== playerId);
      t.kept = [...t.kept, p];
      return { ...prev, [teamId]: t };
    });
  };

  const callUpPlayer = (targetTeamId, player) => {
    setRosterDraft(prev => {
      const updated = { ...prev };
      // Sprawdź czy gracz jest w innej drużynie (transfer)
      let fromTeamId = null;
      for (const [tid, data] of Object.entries(updated)) {
        if (tid === targetTeamId) continue;
        const inKept = data.kept.find(p => p.player_id === player.id);
        const inAdded = data.added.find(p => p.player_id === player.id);
        if (inKept || inAdded) {
          fromTeamId = tid;
          const t = { ...data };
          if (inKept) {
            t.kept = t.kept.filter(p => p.player_id !== player.id);
            t.released = [...t.released, inKept];
          } else {
            t.added = t.added.filter(p => p.player_id !== player.id);
          }
          updated[tid] = t;
          break;
        }
      }

      const target = { ...updated[targetTeamId] };
      target.added = [...target.added, {
        player_id: player.id,
        display_name: `${player.first_name || ""} ${player.last_name || ""}`.trim(),
        position: null, shirt_number: null, is_captain: false,
        from_team_id: fromTeamId,
      }];
      updated[targetTeamId] = target;
      return updated;
    });
    setShowCallUpModal(false);
    setCallUpSearch("");
  };

  // Filtrowanie graczy w modalu powołań
  const callUpCandidates = useMemo(() => {
    if (!callUpSearch || callUpSearch.length < 2) return [];
    const q = callUpSearch.toLowerCase();
    // Już w bieżącej drużynie?
    const currentIds = new Set([
      ...(activeRosterData?.kept || []).map(p => p.player_id),
      ...(activeRosterData?.added || []).map(p => p.player_id),
    ]);
    return allPlayersForCallUp
      .filter(p => !currentIds.has(p.id))
      .filter(p => {
        const full = `${p.first_name} ${p.last_name}`.toLowerCase();
        return full.includes(q);
      })
      .slice(0, 20);
  }, [callUpSearch, allPlayersForCallUp, activeRosterData]);

  // Znajdź drużynę gracza w draft
  const findPlayerTeamInDraft = (playerId) => {
    for (const [tid, data] of Object.entries(rosterDraft)) {
      if (data.kept.some(p => p.player_id === playerId) || data.added.some(p => p.player_id === playerId)) {
        const team = allTeams.find(t => t.id === tid);
        return team?.name || null;
      }
    }
    return null;
  };

  // ═══ KROK 5: Kalendarz ═══
  const toggleWknd = (sat) => setMatchWeekends(p => p.includes(sat) ? p.filter(d => d !== sat) : [...p, sat].sort());
  const calDays = useMemo(() => calMonth ? genMonthDays(calMonth.year, calMonth.month) : [], [calMonth]);

  // ═══ KROK 6: Timeline ═══
  const calcSlotCount = (startTime) => {
    const latestEndMin = 22 * 60;
    const [sh, sm] = startTime.split(":").map(Number);
    const startMin = sh * 60 + sm;
    const slotLen = matchDuration + breakBetween;

    if (startMin + matchDuration > latestEndMin) return 0;

    // Przerwa liczona jest tylko miedzy meczami, nie po ostatnim.
    return Math.max(1, Math.floor((latestEndMin - startMin + breakBetween) / slotLen));
  };
  const satSlotsCount = useMemo(() => calcSlotCount(satStart), [satStart, matchDuration, breakBetween]);
  const sunSlotsCount = useMemo(() => calcSlotCount(sunStart), [sunStart, matchDuration, breakBetween]);
  const monSlotsCount = useMemo(() => calcSlotCount(monStart), [monStart, matchDuration, breakBetween]);

  // Regeneruj sloty gdy zmienią się parametry
  useEffect(() => {
    if (step === 6) {
      setSatSlots(genSlots(satStart, matchDuration, breakBetween, satSlotsCount));
      setSunSlots(genSlots(sunStart, matchDuration, breakBetween, sunSlotsCount));
      setMonSlots(genSlots(monStart, matchDuration, breakBetween, monSlotsCount));
      setActiveTile(null);
    }
  }, [step, satStart, sunStart, monStart, matchDuration, breakBetween, satSlotsCount, sunSlotsCount, monSlotsCount]);

  // Ile użyć kafelka per liga
  const tilesUsed = (lid) => {
    return satSlots.filter(s => s.league === lid).length
      + sunSlots.filter(s => s.league === lid).length
      + monSlots.filter(s => s.league === lid).length;
  };
  const tilesNeeded = (lid) => matchesPerRound(lid);

  const getDaySetter = (day) => {
    if (day === "sat") return setSatSlots;
    if (day === "sun") return setSunSlots;
    return setMonSlots;
  };

  const assignSlot = (day, idx) => {
    if (!activeTile) return;
    const lid = activeTile;
    const needed = tilesNeeded(lid);
    const used = tilesUsed(lid);
    const setter = getDaySetter(day);
    setter(prev => prev.map((s, i) => {
      if (i !== idx) return s;
      if (s.league === lid) return { ...s, league: null }; // odznacz
      if (s.league !== null) return s; // zajęty przez inną ligę
      if (used >= needed) return s; // limit wyczerpany
      return { ...s, league: lid };
    }));
  };

  const clearSlot = (day, idx) => {
    const setter = getDaySetter(day);
    setter(prev => prev.map((s, i) => i === idx ? { ...s, league: null } : s));
  };

  const allTilesAssigned = leagues.every(l => tilesUsed(l.id) >= tilesNeeded(l.id));

  // ═══ KROK 7: Generowanie ═══
  const generateSeason = async () => {
    setGenerating(true);
    setGenLog(["Start..."]);

    try {
      let sid;

      if (editSeasonId) {
        // 1. Tryb edycji — czyszczenie starych danych
        sid = editSeasonId;
        setGenLog(l => [...l, "Czyszczenie starych danych..."]);
        const { data: oldM } = await supabase.from("matches").select("id").eq("season_id", sid);
        if (oldM?.length) {
          await supabase.from("match_events").delete().in("match_id", oldM.map(m => m.id));
        }
        await supabase.from("standings").delete().eq("season_id", sid);
        await supabase.from("matches").delete().eq("season_id", sid);
        await supabase.from("team_players").delete().eq("season_id", sid);
        await supabase.from("season_teams").delete().eq("season_id", sid);
        await supabase.from("season_leagues").delete().eq("season_id", sid);
        const { error: uErr } = await supabase.from("seasons").update({
          year: parseInt(seasonForm.year),
          name: seasonForm.name || `Sezon ${seasonForm.year}`,
          start_date: seasonForm.start_date || null,
        }).eq("id", sid);
        if (uErr) throw new Error("Sezon: " + uErr.message);
        setGenLog(l => [...l, "Sezon zaktualizowany"]);
      } else {
        // 1. Nowy sezon
        setGenLog(l => [...l, "Tworzenie sezonu..."]);
        const { data: season, error: sErr } = await supabase.from("seasons").insert({
          year: parseInt(seasonForm.year),
          name: seasonForm.name || `Sezon ${seasonForm.year}`,
          status: "planned", is_current: false,
          start_date: seasonForm.start_date || null, end_date: null,
        }).select().single();
        if (sErr) throw new Error("Sezon: " + sErr.message);
        sid = season.id;
      }
      setCreatedSeasonId(sid);

      // 2. Utwórz season_leagues
      setGenLog(l => [...l, "Tworzenie lig..."]);
      const slEntries = leagues.map(lg => ({
        season_id: sid, league_id: lg.id,
        points_win: rules.points_win, points_draw: rules.points_draw, points_loss: rules.points_loss,
        walkover_goals_winner: rules.walkover_goals_winner, walkover_goals_loser: rules.walkover_goals_loser,
        walkover_points_winner: rules.points_win,
        promotion_spots: leagueRules[lg.id]?.promotion_spots ?? 0,
        relegation_spots: leagueRules[lg.id]?.relegation_spots ?? 0,
        yellow_card_suspension_threshold: rules.yellow_card_suspension_threshold,
      }));
      const { error: slErr } = await supabase.from("season_leagues").insert(slEntries);
      if (slErr) throw new Error("Ligi: " + slErr.message);

      // 3. Przypisz drużyny
      setGenLog(l => [...l, "Przypisywanie drużyn..."]);
      const stEntries = Object.entries(teamAssignments).map(([tid, lid]) => ({
        season_id: sid, league_id: lid, team_id: tid,
      }));
      const { error: stErr } = await supabase.from("season_teams").insert(stEntries);
      if (stErr) throw new Error("Drużyny: " + stErr.message);

      // 3b. Aplikuj składy z rosterDraft
      if (Object.keys(rosterDraft).length > 0) {
        setGenLog(l => [...l, "Zapisywanie kadr..."]);
        let tpInserted = 0;
        for (const [teamId, data] of Object.entries(rosterDraft)) {
          const leagueId = teamAssignments[teamId];
          if (!leagueId) continue;
          // Aktywni = kept + added
          const activePlayers = [...data.kept, ...data.added];
          if (activePlayers.length === 0) continue;
          const tpEntries = activePlayers.map(p => ({
            season_id: sid, league_id: leagueId, team_id: teamId,
            player_id: p.player_id, position: p.position,
            shirt_number: p.shirt_number, is_captain: p.is_captain || false,
          }));
          const { error: tpErr } = await supabase.from("team_players").insert(tpEntries);
          if (tpErr) setGenLog(l => [...l, `  Kadra błąd: ${tpErr.message}`]);
          else tpInserted += tpEntries.length;
        }
        setGenLog(l => [...l, `  ${tpInserted} zawodników przypisanych`]);
      }

      // 4. Generuj round-robin
      const firstDate = matchWeekends[0] || seasonForm.start_date || fmtDate(new Date());
      for (const league of leagues) {
        const count = tpl(league.id);
        if (count < 2) continue;
        setGenLog(l => [...l, `Generowanie ${league.name} (${count} drużyn)...`]);
        const { data, error } = await supabase.rpc("generate_round_robin", {
          p_season_id: sid, p_league_id: league.id, p_start_date: firstDate,
        });
        if (error) throw new Error(`${league.name}: ${error.message}`);
        setGenLog(l => [...l, `  ${data?.matches_created || 0} meczów`]);

        await supabase.rpc("initialize_standings", { p_season_id: sid, p_league_id: league.id });
      }

      // 5. Przypisz daty i godziny z timeline (uwzględniając rundy!)
      setGenLog(l => [...l, "Przypisywanie dat i godzin (rundy)..."]);

      // Zbuduj szablon slotów per liga z timeline (powtarza się co weekend)
      const leagueSlotsTemplate = {};
      for (const lg of leagues) {
        leagueSlotsTemplate[lg.id] = [];
        for (const slot of satSlots) {
          if (slot.league === lg.id) leagueSlotsTemplate[lg.id].push({ dayOffset: 0, time: slot.start });
        }
        for (const slot of sunSlots) {
          if (slot.league === lg.id) leagueSlotsTemplate[lg.id].push({ dayOffset: 1, time: slot.start });
        }
        for (const slot of monSlots) {
          if (slot.league === lg.id) leagueSlotsTemplate[lg.id].push({ dayOffset: 2, time: slot.start });
        }
      }

      // Dla każdej ligi: przypisz mecze z uwzględnieniem rund
      let updateErrors = 0;
      for (const league of leagues) {
        const slots = leagueSlotsTemplate[league.id] || [];
        if (slots.length === 0) continue;

        const rpr = roundsPerRunda(tpl(league.id)); // kolejek w jednej rundzie
        const totalR = rpr * 2;

        for (let r = 1; r <= totalR; r++) {
          // Mapowanie: kolejka → indeks weekendu
          // Runda 1: kolejka 1..rpr → weekend 0..rpr-1
          // Runda 2: kolejka rpr+1..2*rpr → weekend maxRPR..maxRPR+rpr-1
          const wkndIdx = r <= rpr ? (r - 1) : (maxRPR + r - rpr - 1);
          if (wkndIdx >= matchWeekends.length) continue;

          const satStr = matchWeekends[wkndIdx];
          const sunStr = addDaysToDateStr(satStr, 1);
          const monStr = addDaysToDateStr(satStr, 2);

          const { data: roundMatches } = await supabase.from("matches")
            .select("id").eq("season_id", sid).eq("league_id", league.id).eq("round", r);
          if (!roundMatches) continue;

          // Przypisz daty i godziny sekwencyjnie (niezawodne)
          for (let i = 0; i < roundMatches.length; i++) {
            const slot = slots[i % slots.length];
            const dateStr = slot.dayOffset === 0 ? satStr : slot.dayOffset === 1 ? sunStr : monStr;
            const { error: uErr } = await supabase.from("matches").update({
              match_date: dateStr, match_time: slot.time,
            }).eq("id", roundMatches[i].id);
            if (uErr) updateErrors++;
          }
        }

        setGenLog(l => [...l, `  ${league.name}: R1=${rpr} kol, R2=${rpr} kol`]);
      }
      if (updateErrors > 0) {
        setGenLog(l => [...l, `  UWAGA: ${updateErrors} błędów podczas przypisywania dat`]);
      }

      setGenLog(l => [...l, "Gotowe!"]);
      addToast("success", "Sezon wygenerowany!");
      setStep(8);
      await loadPreview(sid);
    } catch (err) {
      setGenLog(l => [...l, `BŁĄD: ${err.message}`]);
      addToast("error", err.message);
      // Cleanup: usuń sezon jeśli został utworzony
      if (createdSeasonId) {
        await supabase.from("standings").delete().eq("season_id", createdSeasonId);
        await supabase.from("matches").delete().eq("season_id", createdSeasonId);
        await supabase.from("team_players").delete().eq("season_id", createdSeasonId);
        await supabase.from("season_teams").delete().eq("season_id", createdSeasonId);
        await supabase.from("season_leagues").delete().eq("season_id", createdSeasonId);
        if (!editSeasonId) {
          await supabase.from("seasons").delete().eq("id", createdSeasonId);
        }
        setCreatedSeasonId(null);
      }
    } finally {
      setGenerating(false);
    }
  };

  // ═══ KROK 8: Podgląd ═══
  const loadPreview = async (sid) => {
    const { data } = await supabase.from("v_matches").select("*")
      .eq("season_id", sid || createdSeasonId)
      .order("round").order("match_date").order("match_time");
    setPreviewMatches(data || []);
    if (leagues.length > 0 && !previewLeague) setPreviewLeague(leagues[0].id);
  };

  useEffect(() => { if (step === 8 && createdSeasonId) loadPreview(); }, [step, createdSeasonId]);

  const filtered = previewMatches.filter(m => m.league_id === previewLeague);
  const grouped = useMemo(() => {
    const g = {};
    for (const m of filtered) { if (!g[m.round]) g[m.round] = []; g[m.round].push(m); }
    return g;
  }, [filtered]);

  // Swap: zamień dwa mecze (daty, godziny, runda)
  const handleMatchClick = async (matchId) => {
    if (!selectedSwapMatch) {
      setSelectedSwapMatch(matchId);
      addToast("info", "Mecz zaznaczony — kliknij inny aby zamienić pozycję");
      return;
    }
    if (selectedSwapMatch === matchId) {
      setSelectedSwapMatch(null);
      return;
    }

    const a = previewMatches.find(m => m.id === selectedSwapMatch);
    const b = previewMatches.find(m => m.id === matchId);
    if (!a || !b) return;

    // Zamień daty, godziny i rundy
    await supabase.from("matches").update({
      match_date: b.match_date, match_time: b.match_time, round: b.round,
    }).eq("id", a.id);
    await supabase.from("matches").update({
      match_date: a.match_date, match_time: a.match_time, round: a.round,
    }).eq("id", b.id);

    setSelectedSwapMatch(null);
    await loadPreview();
    addToast("success", "Mecze zamienione");
  };

  // ═══ KROK 9: Publikacja ═══
  const publish = async () => {
    setPublishing(true);
    try {
      await supabase.from("seasons").update({ is_current: false }).neq("id", createdSeasonId);
      await supabase.from("seasons").update({ status: "active", is_current: true }).eq("id", createdSeasonId);
      addToast("success", "Sezon opublikowany!");
    } catch (err) { addToast("error", err.message); }
    finally { setPublishing(false); }
  };

  // ═══ RENDER ═══
  const leagueColors = ["bg-blue-500", "bg-green-500", "bg-orange-500"];
  const leagueTextColors = ["text-blue-400", "text-green-400", "text-orange-400"];

  return (
    <div className="space-y-6">

      {/* Pasek kroków */}
      <div className="flex flex-wrap items-center gap-1.5">
        {steps.map((s, i) => (
          <React.Fragment key={s.num}>
            <button onClick={() => s.num < step && setStep(s.num)} disabled={s.num > step}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-colors ${
                s.num === step ? "bg-yellow-500 text-black"
                  : s.num < step ? darkMode ? "bg-green-500/20 text-green-400" : "bg-green-100 text-green-700"
                    : darkMode ? "bg-white/5 text-gray-500" : "bg-gray-100 text-gray-400"
              }`}>
              {s.num < step ? <Check size={12} /> : <span className="w-4 text-center">{s.num}</span>}
              <span className="hidden md:inline">{s.label}</span>
            </button>
            {i < steps.length - 1 && <ChevronRight size={12} className={darkMode ? "text-gray-600" : "text-gray-300"} />}
          </React.Fragment>
        ))}
      </div>

      {/* ═══ KROK 1: SEZON ═══ */}
      {step === 1 && (
        <div className={`rounded-2xl border p-6 ${card}`}>
          {/* Edycja istniejącego sezonu */}
          {existingSeasons.length > 0 && !editSeasonId && (
            <div className={`mb-6 pb-6 border-b ${darkMode ? "border-white/10" : "border-gray-200"}`}>
              <h3 className="font-semibold mb-3">Edytuj istniejący sezon</h3>
              <div className="space-y-1 max-h-48 overflow-y-auto">
                {existingSeasons.map(s => (
                  <button key={s.id} onClick={() => loadExistingSeason(s.id)}
                    className={`flex items-center justify-between w-full px-3 py-2 rounded-lg text-sm text-left transition-colors ${darkMode ? "hover:bg-white/5" : "hover:bg-gray-50"}`}>
                    <span>
                      <span className="font-medium">{s.name}</span>
                      <span className={`ml-2 text-xs ${muted}`}>{s.year}</span>
                    </span>
                    <span className={`text-xs px-2 py-0.5 rounded-full ${
                      s.status === "active" ? "bg-green-500/20 text-green-400" :
                      s.status === "completed" ? "bg-blue-500/20 text-blue-400" :
                      darkMode ? "bg-white/10 text-gray-400" : "bg-gray-100 text-gray-500"
                    }`}>{s.status === "active" ? "Aktywny" : s.status === "completed" ? "Zakończony" : s.status === "planned" ? "Planowany" : s.status}</span>
                  </button>
                ))}
              </div>
            </div>
          )}

          {editSeasonId && (
            <div className={`mb-4 flex items-center justify-between px-3 py-2 rounded-xl text-sm ${darkMode ? "bg-blue-500/10 text-blue-300 border border-blue-500/30" : "bg-blue-50 text-blue-800 border border-blue-200"}`}>
              <span>Edytujesz sezon. Regenerowanie usunie stare mecze i terminy.</span>
              <button onClick={resetWizard} className="ml-3 underline hover:no-underline text-xs">Anuluj</button>
            </div>
          )}

          <h2 className="text-xl font-bold mb-4">{editSeasonId ? "Edytuj sezon" : "Nowy sezon"}</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 max-w-2xl">
            <AdminFormField label="Rok" name="year" type="number" value={seasonForm.year}
              onChange={e => setSeasonForm(f => ({ ...f, year: e.target.value, name: `Sezon ${e.target.value}` }))} darkMode={darkMode} required />
            <AdminFormField label="Nazwa" name="name" value={seasonForm.name || `Sezon ${seasonForm.year}`}
              onChange={e => setSeasonForm(f => ({ ...f, name: e.target.value }))} darkMode={darkMode} />
            <AdminFormField label="Data startu" name="start_date" type="date" value={seasonForm.start_date}
              onChange={e => setSeasonForm(f => ({ ...f, start_date: e.target.value }))} darkMode={darkMode} />
          </div>
          <p className={`text-xs mt-2 ${muted}`}>Sezon zostanie zapisany w bazie dopiero po pomyślnym wygenerowaniu.</p>
          <div className="mt-6">
            <button onClick={() => {
              if (seasonForm.start_date) {
                const d = new Date(seasonForm.start_date);
                setCalMonth({ year: d.getFullYear(), month: d.getMonth() });
              } else setCalMonth({ year: new Date().getFullYear(), month: new Date().getMonth() });
              setStep(2);
            }} className={btnP} disabled={!seasonForm.year}>Dalej: Zasady</button>
          </div>
        </div>
      )}

      {/* ═══ KROK 2: ZASADY ═══ */}
      {step === 2 && (
        <div className={`rounded-2xl border p-6 ${card}`}>
          <h2 className="text-xl font-bold mb-4">Zasady rozgrywek</h2>
          <div className="space-y-6">

            <div>
              <h3 className="font-semibold mb-3">Czas gry</h3>
              <div className="grid grid-cols-2 gap-3 max-w-sm">
                <AdminFormField label="Czas meczu (min)" name="dur" type="number" darkMode={darkMode}
                  value={matchDuration} onChange={e => setMatchDuration(parseInt(e.target.value) || 60)} min={30} max={120} />
                <AdminFormField label="Przerwa między meczami (min)" name="brk" type="number" darkMode={darkMode}
                  value={breakBetween} onChange={e => setBreakBetween(parseInt(e.target.value) || 10)} min={0} max={60} />
              </div>
            </div>

            <div>
              <h3 className="font-semibold mb-3">Punktacja</h3>
              <div className="grid grid-cols-3 gap-3 max-w-md">
                <AdminFormField label="Wygrana" name="pw" type="number" darkMode={darkMode} value={rules.points_win}
                  onChange={e => setRules(r => ({ ...r, points_win: parseInt(e.target.value) || 0 }))} />
                <AdminFormField label="Remis" name="pd" type="number" darkMode={darkMode} value={rules.points_draw}
                  onChange={e => setRules(r => ({ ...r, points_draw: parseInt(e.target.value) || 0 }))} />
                <AdminFormField label="Przegrana" name="pl" type="number" darkMode={darkMode} value={rules.points_loss}
                  onChange={e => setRules(r => ({ ...r, points_loss: parseInt(e.target.value) || 0 }))} />
              </div>
            </div>

            <div>
              <h3 className="font-semibold mb-3">Walkower</h3>
              <div className="grid grid-cols-2 gap-3 max-w-xs">
                <AdminFormField label="Bramki zwycięzcy" name="ww" type="number" darkMode={darkMode} value={rules.walkover_goals_winner}
                  onChange={e => setRules(r => ({ ...r, walkover_goals_winner: parseInt(e.target.value) || 0 }))} />
                <AdminFormField label="Bramki przegranego" name="wl" type="number" darkMode={darkMode} value={rules.walkover_goals_loser}
                  onChange={e => setRules(r => ({ ...r, walkover_goals_loser: parseInt(e.target.value) || 0 }))} />
              </div>
            </div>

            <div>
              <h3 className="font-semibold mb-3">Karty</h3>
              <div className="max-w-xs">
                <AdminFormField label="Żółte karty do pauzy" name="yc" type="number" darkMode={darkMode} value={rules.yellow_card_suspension_threshold}
                  onChange={e => setRules(r => ({ ...r, yellow_card_suspension_threshold: parseInt(e.target.value) || 3 }))} />
              </div>
            </div>

            {/* Kolejność rozstrzygania */}
            <div>
              <h3 className="font-semibold mb-3">Kolejność rozstrzygania pozycji w tabeli</h3>
              <div className="space-y-2 max-w-md">
                {tiebreakers.map((tb, idx) => (
                  <div key={idx} className="flex items-center gap-3">
                    <span className={`text-sm font-bold w-6 text-center ${muted}`}>{idx + 1}.</span>
                    <select value={tb}
                      onChange={e => {
                        const newVal = e.target.value;
                        setTiebreakers(prev => {
                          const copy = [...prev];
                          copy[idx] = newVal;
                          return copy;
                        });
                      }}
                      className={`flex-1 px-3 py-2 rounded-xl border outline-none text-sm ${
                        darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-300 text-gray-900"
                      }`}
                    >
                      {TIEBREAKER_OPTIONS.map(opt => (
                        <option key={opt.value} value={opt.value}
                          style={darkMode ? { backgroundColor: "#1a1f2e", color: "#fff" } : {}}
                        >{opt.label}</option>
                      ))}
                    </select>
                  </div>
                ))}
              </div>
            </div>

            {/* Awanse i spadki */}
            <div>
              <h3 className="font-semibold mb-3">Awanse i spadki</h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {leagues.map(lg => (
                  <div key={lg.id} className={`rounded-xl border p-3 ${darkMode ? "border-white/10" : "border-gray-200"}`}>
                    <div className="font-semibold text-sm mb-2">{lg.name}</div>
                    <div className="grid grid-cols-2 gap-2">
                      <AdminFormField label="Awanse" name="pr" type="number" darkMode={darkMode}
                        value={leagueRules[lg.id]?.promotion_spots ?? 0}
                        onChange={e => setLeagueRules(p => ({ ...p, [lg.id]: { ...p[lg.id], promotion_spots: parseInt(e.target.value) || 0 } }))} />
                      <AdminFormField label="Spadki" name="re" type="number" darkMode={darkMode}
                        value={leagueRules[lg.id]?.relegation_spots ?? 0}
                        onChange={e => setLeagueRules(p => ({ ...p, [lg.id]: { ...p[lg.id], relegation_spots: parseInt(e.target.value) || 0 } }))} />
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>

          <div className="mt-6 flex gap-3">
            <button onClick={() => setStep(1)} className={btnS}><span className="flex items-center gap-1"><ChevronLeft size={16} /> Wstecz</span></button>
            <button onClick={() => { setStep(3); setActiveLeagueIdx(0); }} className={btnP}>Dalej: Drużyny</button>
          </div>
        </div>
      )}

      {/* ═══ KROK 3: DRUŻYNY ═══ */}
      {step === 3 && (
        <div className={`rounded-2xl border p-6 ${card}`}>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold">Przypisz drużyny</h2>
            <button onClick={importTeams} className={btnS}><span className="flex items-center gap-2"><Copy size={16} /> Import</span></button>
          </div>

          <div className="flex gap-2 mb-4">
            {leagues.map((lg, idx) => {
              const c = tpl(lg.id);
              return (
                <button key={lg.id} onClick={() => { setActiveLeagueIdx(idx); setLeagueTeamSearch(""); }}
                  className={`flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-semibold transition-colors ${
                    idx === activeLeagueIdx ? "bg-yellow-500 text-black"
                      : c >= 2 ? darkMode ? "bg-green-500/20 text-green-400" : "bg-green-100 text-green-700"
                        : darkMode ? "bg-white/5 text-gray-400" : "bg-gray-100 text-gray-500"
                  }`}>
                  {c >= 2 && idx !== activeLeagueIdx && <Check size={14} />} {lg.name}
                  <span className={`text-xs px-1.5 py-0.5 rounded-full ${idx === activeLeagueIdx ? "bg-black/20" : darkMode ? "bg-white/10" : "bg-gray-200"}`}>{c}</span>
                </button>
              );
            })}
          </div>

          {curLeague && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className={`rounded-xl border p-4 [&>h3:first-child]:hidden ${darkMode ? "border-white/10" : "border-gray-200"}`}>
                <h3 className={`text-sm font-semibold mb-3 ${muted}`}>Dostępne ({availTeams.filter(t => teamAssignments[t.id] !== curLeague.id).length})</h3>
                <div className="flex items-center justify-between gap-3 mb-3">
                  <h3 className={`text-sm font-semibold ${muted}`}>Dostepne ({filteredAvailableTeams.length})</h3>
                  <span className={`text-[11px] ${muted}`}>wszystkich: {availableTeamsOutsideCurrentLeague.length}</span>
                </div>
                <div className="relative mb-3">
                  <Search size={16} className={`absolute left-3 top-1/2 -translate-y-1/2 ${muted}`} />
                  <input
                    type="text"
                    value={leagueTeamSearch}
                    onChange={e => setLeagueTeamSearch(e.target.value)}
                    placeholder="Szukaj druzyny..."
                    className={`w-full pl-9 pr-4 py-2.5 rounded-xl border text-sm outline-none ${
                      darkMode ? "bg-white/5 border-white/10 text-white placeholder-gray-500" : "bg-gray-50 border-gray-300 text-gray-900 placeholder-gray-400"
                    }`}
                  />
                </div>
                <div className="space-y-1 max-h-96 overflow-y-auto">
                  {filteredAvailableTeams.map(t => (
                    <button key={t.id} onClick={() => toggleTeam(t.id)}
                      className={`flex items-center gap-3 w-full px-3 py-2 rounded-lg text-left ${darkMode ? "hover:bg-white/10" : "hover:bg-gray-100"}`}>
                      {t.logo_url ? <img src={t.logo_url} alt="" className="w-7 h-7 object-contain rounded" />
                        : <div className={`w-7 h-7 rounded flex items-center justify-center text-xs font-bold ${darkMode ? "bg-gray-700" : "bg-gray-200"}`}>{(t.abbreviation || "?").slice(0,2)}</div>}
                      <span className="text-sm font-medium flex-1">{t.name}</span>
                      <ArrowRight size={14} className={muted} />
                    </button>
                  ))}
                  {filteredAvailableTeams.length === 0 && (
                    <div className={`px-3 py-6 text-center text-sm ${muted}`}>
                      {leagueTeamSearch.trim() ? "Brak druzyn pasujacych do wyszukiwania." : "Brak dostepnych druzyn."}
                    </div>
                  )}
                </div>
              </div>
              <div className={`rounded-xl border p-4 ${darkMode ? "border-yellow-500/30 bg-yellow-500/5" : "border-yellow-300 bg-yellow-50"}`}>
                <h3 className="text-sm font-semibold mb-1">{curLeague.name}</h3>
                <p className={`text-xs mb-3 ${muted}`}>{inCurLeague.length} drużyn = {roundsPerRunda(inCurLeague.length)} kol/runda × 2 = {roundsForTeams(inCurLeague.length)} kolejek</p>
                <div className="space-y-1 max-h-96 overflow-y-auto">
                  {inCurLeague.map((t, i) => (
                    <button key={t.id} onClick={() => toggleTeam(t.id)}
                      className={`flex items-center gap-3 w-full px-3 py-2 rounded-lg text-left ${darkMode ? "hover:bg-white/10 bg-white/5" : "hover:bg-yellow-100 bg-white"}`}>
                      <span className={`text-xs font-bold w-5 text-center ${muted}`}>{i+1}</span>
                      {t.logo_url ? <img src={t.logo_url} alt="" className="w-7 h-7 object-contain rounded" />
                        : <div className={`w-7 h-7 rounded flex items-center justify-center text-xs font-bold ${darkMode ? "bg-gray-700" : "bg-gray-200"}`}>{(t.abbreviation || "?").slice(0,2)}</div>}
                      <span className="text-sm font-medium flex-1">{t.name}</span>
                      <span className="text-red-400 text-xs">✕</span>
                    </button>
                  ))}
                </div>
              </div>
            </div>
          )}

          <div className="grid grid-cols-3 gap-3 mt-4">
            {leagues.map(l => <div key={l.id} className={`rounded-lg p-2 text-center text-xs ${tpl(l.id)>=2 ? darkMode?"bg-green-500/10 text-green-400":"bg-green-50 text-green-700" : darkMode?"bg-red-500/10 text-red-400":"bg-red-50 text-red-700"}`}>{l.name}: {tpl(l.id)} = {roundsPerRunda(tpl(l.id))} × 2 = {roundsForTeams(tpl(l.id))} kol.</div>)}
          </div>

          <div className="mt-6 flex gap-3">
            <button onClick={() => setStep(2)} className={btnS}><span className="flex items-center gap-1"><ChevronLeft size={16} /> Wstecz</span></button>
            <button onClick={() => setStep(4)} className={btnP} disabled={leagues.some(l => tpl(l.id) < 2)}>Dalej: Składy</button>
          </div>
        </div>
      )}

      {/* ═══ KROK 4: SKŁADY ═══ */}
      {step === 4 && (
        <div className={`rounded-2xl border p-6 ${card}`}>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold flex items-center gap-2"><Users size={22} /> Składy drużyn</h2>
            <span className={`text-sm ${muted}`}>{rosterTeams.length} drużyn</span>
          </div>

          {rosterLoading ? (
            <div className="flex items-center justify-center py-12 gap-3">
              <Loader2 size={24} className="animate-spin text-yellow-500" />
              <span className={muted}>Ładowanie kadr z poprzedniego sezonu...</span>
            </div>
          ) : (
            <>
              {/* Zakładki drużyn */}
              <div className="flex flex-wrap gap-1.5 mb-4">
                {rosterTeams.map((t, idx) => {
                  const data = rosterDraft[t.id];
                  const total = (data?.kept?.length || 0) + (data?.added?.length || 0);
                  const hasReleased = (data?.released?.length || 0) > 0;
                  const hasAdded = (data?.added?.length || 0) > 0;
                  const isActive = idx === activeRosterTeamIdx;
                  return (
                    <button key={t.id} onClick={() => setActiveRosterTeamIdx(idx)}
                      className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-colors ${
                        isActive ? "bg-yellow-500 text-black"
                          : total > 0 ? darkMode ? "bg-green-500/20 text-green-400" : "bg-green-100 text-green-700"
                            : darkMode ? "bg-white/5 text-gray-500" : "bg-gray-100 text-gray-400"
                      }`}>
                      {t.logo_url ? <img src={t.logo_url} alt="" className="w-5 h-5 object-contain rounded" /> : null}
                      <span className="hidden md:inline">{t.name}</span>
                      <span className="md:hidden">{(t.abbreviation || t.name).slice(0, 3)}</span>
                      <span className={`text-[10px] px-1 rounded-full ${isActive ? "bg-black/20" : darkMode ? "bg-white/10" : "bg-gray-200"}`}>{total}</span>
                      {hasReleased && <span className="w-1.5 h-1.5 rounded-full bg-red-400" title="Zwolnieni" />}
                      {hasAdded && <span className="w-1.5 h-1.5 rounded-full bg-blue-400" title="Nowi" />}
                    </button>
                  );
                })}
              </div>

              {/* Liga aktualnej drużyny */}
              {activeRosterTeam && (
                <p className={`text-xs mb-3 ${muted}`}>{activeRosterTeam.leagueName} — {activeRosterTeam.name}</p>
              )}

              {/* Lista zawodników */}
              {activeRosterData && (
                <div className={`rounded-xl border ${darkMode ? "border-white/10" : "border-gray-200"}`}>
                  {/* Aktywni (kept + added) */}
                  {[...activeRosterData.kept, ...activeRosterData.added].length === 0 && activeRosterData.released.length === 0 && (
                    <p className={`text-center py-6 text-sm ${muted}`}>Brak zawodników w kadrze</p>
                  )}

                  {[...activeRosterData.kept.map(p => ({ ...p, _type: "kept" })),
                    ...activeRosterData.added.map(p => ({ ...p, _type: "added" }))
                  ].map((p, i) => (
                    <div key={p.player_id} className={`flex items-center gap-3 px-4 py-2.5 border-b last:border-b-0 ${darkMode ? "border-white/5" : "border-gray-100"} ${
                      p._type === "added" ? darkMode ? "bg-blue-500/5" : "bg-blue-50/50" : ""
                    }`}>
                      <span className={`text-xs font-bold w-5 text-center ${muted}`}>{i + 1}</span>
                      <span className="flex-1 text-sm font-medium">
                        {p.display_name}
                        {p.is_captain && <span className="ml-1 text-yellow-500 text-xs font-bold">C</span>}
                      </span>
                      {p.shirt_number && <span className={`text-xs ${muted}`}>#{p.shirt_number}</span>}
                      {p.position && <span className={`text-xs px-1.5 py-0.5 rounded ${darkMode ? "bg-white/5" : "bg-gray-100"} ${muted}`}>{p.position}</span>}
                      {p._type === "added" && (
                        <span className={`text-[10px] px-1.5 py-0.5 rounded-full font-semibold ${darkMode ? "bg-blue-500/20 text-blue-400" : "bg-blue-100 text-blue-700"}`}>
                          {p.from_team_id ? "TRANSFER" : "NOWY"}
                        </span>
                      )}
                      <button onClick={() => releasePlayer(activeRosterTeam.id, p.player_id)}
                        className="p-1.5 rounded-lg hover:bg-red-500/20 text-red-400 text-xs flex items-center gap-1" title="Zwolnij">
                        <UserMinus size={14} />
                        <span className="hidden sm:inline">Zwolnij</span>
                      </button>
                    </div>
                  ))}

                  {/* Zwolnieni */}
                  {activeRosterData.released.length > 0 && (
                    <>
                      <div className={`px-4 py-2 text-xs font-semibold ${darkMode ? "bg-red-500/10 text-red-400" : "bg-red-50 text-red-700"}`}>
                        Zwolnieni ({activeRosterData.released.length})
                      </div>
                      {activeRosterData.released.map(p => (
                        <div key={p.player_id} className={`flex items-center gap-3 px-4 py-2 border-b last:border-b-0 opacity-50 ${darkMode ? "border-white/5" : "border-gray-100"}`}>
                          <span className="flex-1 text-sm line-through">{p.display_name}</span>
                          {p.shirt_number && <span className={`text-xs ${muted}`}>#{p.shirt_number}</span>}
                          <button onClick={() => restorePlayer(activeRosterTeam.id, p.player_id)}
                            className="p-1.5 rounded-lg hover:bg-green-500/20 text-green-400 text-xs flex items-center gap-1" title="Przywróć">
                            <Undo2 size={14} />
                            <span className="hidden sm:inline">Przywróć</span>
                          </button>
                        </div>
                      ))}
                    </>
                  )}
                </div>
              )}

              {/* Przycisk powołaj */}
              {activeRosterTeam && (
                <button onClick={() => { setShowCallUpModal(true); setCallUpSearch(""); }}
                  className={`mt-4 w-full px-4 py-3 rounded-xl border-2 border-dashed text-sm font-semibold flex items-center justify-center gap-2 transition-colors ${
                    darkMode ? "border-white/10 text-gray-400 hover:border-blue-500/50 hover:text-blue-400 hover:bg-blue-500/5"
                      : "border-gray-200 text-gray-500 hover:border-blue-300 hover:text-blue-600 hover:bg-blue-50"
                  }`}>
                  <UserPlus size={18} /> Powołaj zawodnika
                </button>
              )}

              {/* Modal powołania */}
              {showCallUpModal && activeRosterTeam && (
                <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm" onClick={() => setShowCallUpModal(false)}>
                  <div className={`w-full max-w-md mx-4 rounded-2xl border p-6 shadow-2xl ${darkMode ? "bg-gray-900 border-white/10" : "bg-white border-gray-200"}`}
                    onClick={e => e.stopPropagation()}>
                    <div className="flex items-center justify-between mb-4">
                      <h3 className="text-lg font-bold flex items-center gap-2"><UserPlus size={20} /> Powołaj do: {activeRosterTeam.name}</h3>
                      <button onClick={() => setShowCallUpModal(false)} className="p-1 rounded-lg hover:bg-white/10"><X size={18} /></button>
                    </div>

                    {/* Wyszukiwarka */}
                    <div className="relative mb-4">
                      <Search size={16} className={`absolute left-3 top-1/2 -translate-y-1/2 ${muted}`} />
                      <input type="text" placeholder="Szukaj zawodnika..." value={callUpSearch}
                        onChange={e => setCallUpSearch(e.target.value)} autoFocus
                        className={`w-full pl-9 pr-4 py-2.5 rounded-xl border text-sm outline-none ${
                          darkMode ? "bg-white/5 border-white/10 text-white placeholder-gray-500" : "bg-gray-50 border-gray-300 text-gray-900"
                        }`} />
                    </div>

                    {/* Wyniki */}
                    <div className="max-h-64 overflow-y-auto space-y-1">
                      {callUpSearch.length < 2 && (
                        <p className={`text-center py-4 text-sm ${muted}`}>Wpisz min. 2 znaki aby wyszukać</p>
                      )}
                      {callUpSearch.length >= 2 && callUpCandidates.length === 0 && (
                        <p className={`text-center py-4 text-sm ${muted}`}>Nie znaleziono zawodników</p>
                      )}
                      {callUpCandidates.map(p => {
                        const currentTeam = findPlayerTeamInDraft(p.id);
                        return (
                          <button key={p.id} onClick={() => callUpPlayer(activeRosterTeam.id, p)}
                            className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-left transition-colors ${
                              darkMode ? "hover:bg-white/10" : "hover:bg-gray-100"
                            }`}>
                            <span className="flex-1 text-sm font-medium">{p.first_name} {p.last_name}</span>
                            {currentTeam && (
                              <span className={`text-[10px] px-1.5 py-0.5 rounded-full font-semibold ${
                                darkMode ? "bg-orange-500/20 text-orange-400" : "bg-orange-100 text-orange-700"
                              }`}>
                                {currentTeam} → Transfer
                              </span>
                            )}
                            {!currentTeam && (
                              <span className={`text-[10px] px-1.5 py-0.5 rounded-full ${darkMode ? "bg-green-500/20 text-green-400" : "bg-green-100 text-green-700"}`}>
                                Wolny
                              </span>
                            )}
                          </button>
                        );
                      })}
                    </div>
                  </div>
                </div>
              )}
            </>
          )}

          <div className="mt-6 flex gap-3">
            <button onClick={() => setStep(3)} className={btnS}><span className="flex items-center gap-1"><ChevronLeft size={16} /> Wstecz</span></button>
            <button onClick={() => {
              if (seasonForm.start_date) {
                const d = new Date(seasonForm.start_date);
                setCalMonth({ year: d.getFullYear(), month: d.getMonth() });
              } else if (!calMonth) setCalMonth({ year: new Date().getFullYear(), month: new Date().getMonth() });
              setStep(5);
            }} className={btnP}>Dalej: Kalendarz</button>
          </div>
        </div>
      )}

      {/* ═══ KROK 5: KALENDARZ ═══ */}
      {step === 5 && calMonth && (
        <div className={`rounded-2xl border p-6 ${card}`}>
          <h2 className="text-xl font-bold mb-2">Wybierz terminy kolejek</h2>
          <p className={`text-sm mb-4 ${muted}`}>
            Kliknij w blok kolejki (sob+nie+pon), aby oznaczyć go jako termin.
            Potrzebujesz <strong>{totalRoundsNeeded}</strong> terminów kolejki ({maxRPR} kol. × 2 rundy).
            Wybrano: <strong className={matchWeekends.length >= totalRoundsNeeded ? "text-green-400" : "text-orange-400"}>{matchWeekends.length}</strong>.
            {maxRPR > 0 && <><br/>Runda 1: terminy 1–{maxRPR} • Runda 2: terminy {maxRPR+1}–{maxRPR*2}</>}
          </p>

          <div className="flex items-center justify-between mb-4">
            <button onClick={() => setCalMonth(p => { const m=p.month-1; return m<0 ? {year:p.year-1,month:11} : {...p,month:m}; })} className={btnS}><ChevronLeft size={16} /></button>
            <span className="text-lg font-bold">{monthLabels[calMonth.month]} {calMonth.year}</span>
            <button onClick={() => setCalMonth(p => { const m=p.month+1; return m>11 ? {year:p.year+1,month:0} : {...p,month:m}; })} className={btnS}><ChevronRight size={16} /></button>
          </div>

          <div className="grid grid-cols-7 gap-1">
            {dayLabels.map(d => <div key={d} className={`text-center text-xs font-semibold py-2 ${d==="Sob"||d==="Nie"||d==="Pon" ? "text-yellow-500" : muted}`}>{d}</div>)}
            {calDays.map((day, i) => {
              if (!day) return <div key={`p${i}`} />;
              const ds = fmtDate(day);
              const sat = getWeekendSat(day);
              const isWknd = sat !== null;
              const sel = isWknd && matchWeekends.includes(sat);
              const wkIdx = sel ? matchWeekends.indexOf(sat) : -1;
              const past = ds < fmtDate(new Date());
              const isSat = day.getDay() === 6;
              return (
                <button key={ds} onClick={() => !past && isWknd && toggleWknd(sat)} disabled={past || !isWknd}
                  className={`relative p-2 rounded-lg text-sm font-medium min-h-[48px] transition-all ${
                    sel ? "bg-yellow-500 text-black ring-2 ring-yellow-400/50"
                      : isWknd ? darkMode ? "bg-yellow-500/10 text-yellow-300 hover:bg-yellow-500/20" : "bg-yellow-50 text-yellow-700 hover:bg-yellow-100"
                        : darkMode ? "bg-white/[0.02] text-gray-600" : "bg-gray-50/50 text-gray-400"
                  } ${(past||!isWknd) ? "opacity-30 cursor-not-allowed" : "cursor-pointer"}`}>
                  <span>{day.getDate()}</span>
                  {sel && isSat && wkIdx >= 0 && <span className={`absolute bottom-0.5 right-1 text-[10px] font-bold ${wkIdx >= maxRPR ? "text-cyan-300" : ""}`}>{rundaLabel(wkIdx)}</span>}
                </button>
              );
            })}
          </div>

          {matchWeekends.length > 0 && (
            <div className="mt-4 flex flex-wrap gap-2 items-center">
              {matchWeekends.map((sat, i) => {
                const d = new Date(`${sat}T12:00:00`);
                const s = new Date(`${sat}T12:00:00`); s.setDate(s.getDate()+1);
                const m = new Date(`${sat}T12:00:00`); m.setDate(m.getDate()+2);
                const isR2 = i >= maxRPR;
                return <React.Fragment key={sat}>
                  {i === maxRPR && maxRPR > 0 && (
                    <span className={`px-2 py-0.5 text-[10px] font-bold rounded ${darkMode ? "bg-cyan-500/20 text-cyan-400" : "bg-cyan-100 text-cyan-700"}`}>RUNDA 2 →</span>
                  )}
                  <button onClick={() => toggleWknd(sat)}
                    className={`px-2.5 py-1 rounded-lg text-xs font-medium ${
                      isR2
                        ? darkMode ? "bg-cyan-500/20 text-cyan-400 hover:bg-red-500/20 hover:text-red-400" : "bg-cyan-100 text-cyan-800 hover:bg-red-100 hover:text-red-700"
                        : darkMode ? "bg-yellow-500/20 text-yellow-400 hover:bg-red-500/20 hover:text-red-400" : "bg-yellow-100 text-yellow-800 hover:bg-red-100 hover:text-red-700"
                    }`}>
                    {rundaLabel(i)}: {d.getDate()}.{pad2(d.getMonth()+1)}-{s.getDate()}.{pad2(s.getMonth()+1)}-{m.getDate()}.{pad2(m.getMonth()+1)} ✕
                  </button>
                </React.Fragment>;
              })}
            </div>
          )}

          <div className="mt-6 flex gap-3">
            <button onClick={() => setStep(4)} className={btnS}><span className="flex items-center gap-1"><ChevronLeft size={16} /> Wstecz</span></button>
            <button onClick={() => setStep(6)} className={btnP} disabled={matchWeekends.length < totalRoundsNeeded}>Dalej: Timeline</button>
          </div>
        </div>
      )}

      {/* ═══ KROK 6: TIMELINE ═══ */}
      {step === 6 && (
        <div className={`rounded-2xl border p-6 ${card}`}>
          <h2 className="text-xl font-bold mb-2">Rozkład kolejki meczowej</h2>
          <p className={`text-sm mb-4 ${muted}`}>
            Ustaw godziny startowe dla soboty, niedzieli i poniedziałku, potem kliknij kafelek ligi i przypisz go do slotu na osi czasu.
            Każdy mecz = {matchDuration} min + {breakBetween} min przerwy.
          </p>

          {/* Godziny startu */}
          <div className="flex flex-wrap gap-6 mb-6">
            <div className="flex items-center gap-2">
              <span className="text-sm font-medium">Sobota od:</span>
              <input type="time" value={satStart} onChange={e => setSatStart(e.target.value)}
                className={`px-2 py-1 rounded-lg border text-sm ${darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-300 text-gray-900"}`} />
            </div>
            <div className="flex items-center gap-2">
              <span className="text-sm font-medium">Niedziela od:</span>
              <input type="time" value={sunStart} onChange={e => setSunStart(e.target.value)}
                className={`px-2 py-1 rounded-lg border text-sm ${darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-300 text-gray-900"}`} />
            </div>
            <div className="flex items-center gap-2">
              <span className="text-sm font-medium">Poniedziałek od:</span>
              <input type="time" value={monStart} onChange={e => setMonStart(e.target.value)}
                className={`px-2 py-1 rounded-lg border text-sm ${darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-300 text-gray-900"}`} />
            </div>
          </div>

          {/* Kafelki lig */}
          <div className="flex gap-3 mb-6">
            {leagues.map((lg, idx) => {
              const needed = tilesNeeded(lg.id);
              const used = tilesUsed(lg.id);
              const isActive = activeTile === lg.id;
              return (
                <button key={lg.id}
                  onClick={() => setActiveTile(isActive ? null : lg.id)}
                  className={`flex items-center gap-2 px-4 py-2.5 rounded-xl font-semibold text-sm transition-all ${
                    isActive ? `${leagueColors[idx]} text-white ring-2 ring-white/50 scale-105`
                      : used >= needed ? darkMode ? "bg-green-500/20 text-green-400" : "bg-green-100 text-green-700"
                        : darkMode ? "bg-white/5 text-gray-300 hover:bg-white/10" : "bg-gray-100 text-gray-700 hover:bg-gray-200"
                  }`}>
                  <span className={`w-3 h-3 rounded-full ${leagueColors[idx]}`} />
                  {lg.name}
                  <span className={`text-xs px-1.5 py-0.5 rounded-full ${
                    used >= needed ? "bg-green-500/30" : isActive ? "bg-white/20" : darkMode ? "bg-white/10" : "bg-gray-200"
                  }`}>{used}/{needed}</span>
                </button>
              );
            })}
          </div>

          {activeTile && <p className={`text-xs mb-4 ${muted}`}>Kliknij w pusty slot aby przypisać ligę. Kliknij zajęty slot tej ligi aby usunąć.</p>}

          {/* Timeline sobota */}
          <div className="space-y-4">
            {[{ label: "SOBOTA", slots: satSlots, day: "sat" }, { label: "NIEDZIELA", slots: sunSlots, day: "sun" }, { label: "PONIEDZIAŁEK", slots: monSlots, day: "mon" }].map(({ label, slots, day }) => (
              <div key={day}>
                <h3 className="font-semibold text-sm mb-2">{label}</h3>
                <div className="flex flex-wrap gap-2">
                  {slots.map((slot, idx) => {
                    const lgIdx = slot.league ? leagues.findIndex(l => l.id === slot.league) : -1;
                    const lgName = lgIdx >= 0 ? leagues[lgIdx].name : null;
                    const isEmpty = slot.league === null;
                    const isActiveLg = slot.league === activeTile;

                    return (
                      <button key={idx}
                        onClick={() => {
                          if (isActiveLg) clearSlot(day, idx);
                          else if (isEmpty && activeTile) assignSlot(day, idx);
                        }}
                        className={`flex flex-col items-center px-3 py-2 rounded-xl border min-w-[80px] transition-all ${
                          isEmpty
                            ? activeTile
                              ? darkMode ? "border-dashed border-yellow-500/50 bg-yellow-500/5 hover:bg-yellow-500/15 cursor-pointer" : "border-dashed border-yellow-400 bg-yellow-50 hover:bg-yellow-100 cursor-pointer"
                              : darkMode ? "border-white/10 bg-white/[0.02]" : "border-gray-200 bg-gray-50"
                            : isActiveLg
                              ? `${leagueColors[lgIdx]} text-white border-transparent cursor-pointer hover:opacity-80`
                              : `${leagueColors[lgIdx]}/20 ${leagueTextColors[lgIdx]} border-transparent`
                        }`}
                      >
                        <span className="text-[10px] font-medium">{slot.start}</span>
                        <span className="text-xs font-bold mt-0.5">
                          {lgName || (activeTile ? "+" : "—")}
                        </span>
                        <span className="text-[10px]">{slot.end}</span>
                      </button>
                    );
                  })}
                </div>
              </div>
            ))}
          </div>

          <div className="mt-6 flex gap-3">
            <button onClick={() => setStep(5)} className={btnS}><span className="flex items-center gap-1"><ChevronLeft size={16} /> Wstecz</span></button>
            <button onClick={() => setStep(7)} className={btnP} disabled={!allTilesAssigned}>Dalej: Generuj</button>
          </div>
        </div>
      )}

      {/* ═══ KROK 7: GENERUJ ═══ */}
      {step === 7 && (
        <div className={`rounded-2xl border p-6 ${card}`}>
          <h2 className="text-xl font-bold mb-4">Generuj sezon</h2>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-3 mb-6">
            {leagues.map((lg, idx) => {
              const c = tpl(lg.id);
              return (
                <div key={lg.id} className={`rounded-xl border p-4 text-center ${darkMode ? "border-white/10" : "border-gray-200"}`}>
                  <div className="font-bold">{lg.name}</div>
                  <div className={`text-2xl font-black mt-1 ${leagueTextColors[idx]}`}>{c} drużyn</div>
                  <div className={`text-sm ${muted}`}>{roundsPerRunda(c)} kol/runda × 2 = {roundsForTeams(c)} kol. • {roundsForTeams(c) * matchesPerRound(lg.id)} meczów</div>
                </div>
              );
            })}
          </div>

          <div className={`rounded-xl border p-4 mb-6 text-sm ${darkMode ? "border-white/10" : "border-gray-200"}`}>
            <div className="grid grid-cols-2 gap-2">
              <div><span className={muted}>Terminów kolejki:</span> <strong>{matchWeekends.length}</strong></div>
              <div><span className={muted}>Mecz:</span> <strong>{matchDuration} min + {breakBetween} min</strong></div>
            </div>
          </div>

          {genLog.length > 0 && (
            <div className={`rounded-xl border p-3 mb-4 font-mono text-xs max-h-40 overflow-y-auto ${darkMode ? "border-white/10 bg-black/30" : "border-gray-200 bg-gray-50"}`}>
              {genLog.map((l, i) => <div key={i} className={l.startsWith("BŁĄD") ? "text-red-400" : muted}>{l}</div>)}
            </div>
          )}

          {editSeasonId && editHasResults && (
            <div className={`rounded-xl border p-3 mb-4 text-sm ${darkMode ? "border-red-500/30 bg-red-500/10 text-red-300" : "border-red-200 bg-red-50 text-red-800"}`}>
              <strong>Uwaga:</strong> Ten sezon ma rozegrane mecze z wynikami. Regenerowanie usunie WSZYSTKIE wyniki i zdarzenia meczówe!
            </div>
          )}

          <button onClick={generateSeason} disabled={generating}
            className="px-8 py-4 rounded-2xl bg-gradient-to-r from-yellow-500 to-orange-500 text-black font-black text-lg hover:from-yellow-400 hover:to-orange-400 transition-all disabled:opacity-40 flex items-center gap-3">
            {generating ? <><Loader2 size={24} className="animate-spin" /> Generowanie...</> : <><Sparkles size={24} /> {editSeasonId ? "REGENERUJ SEZON" : "GENERUJ SEZON"}</>}
          </button>

          <div className="mt-4">
            <button onClick={() => setStep(6)} className={btnS}><span className="flex items-center gap-1"><ChevronLeft size={16} /> Wstecz</span></button>
          </div>
        </div>
      )}

      {/* ═══ KROK 8: PODGLĄD ═══ */}
      {step === 8 && (
        <div className={`rounded-2xl border p-6 ${card}`}>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold">Podgląd terminarza</h2>
            <div className="flex gap-2">
              {leagues.map(lg => (
                <button key={lg.id} onClick={() => { setPreviewLeague(lg.id); setSelectedSwapMatch(null); }}
                  className={`px-3 py-1.5 rounded-lg text-xs font-semibold ${previewLeague===lg.id ? "bg-yellow-500 text-black" : darkMode ? "bg-white/5 text-gray-400" : "bg-gray-100 text-gray-600"}`}>{lg.name}</button>
              ))}
            </div>
          </div>

          {Object.keys(grouped).length === 0 ? <p className={muted}>Brak meczów.</p> : (
            <div className="space-y-4 max-h-[600px] overflow-y-auto">
              {Object.entries(grouped).map(([round, matches]) => (
                <div key={round} className={`rounded-xl border ${darkMode ? "border-white/10" : "border-gray-200"}`}>
                  <div className={`px-4 py-2 font-semibold text-sm ${darkMode ? "bg-white/5" : "bg-gray-50"} rounded-t-xl flex justify-between`}>
                    <span>{parseInt(round) <= roundsPerRunda(tpl(previewLeague)) ? "R1" : "R2"} Kolejka {round}</span>
                    <span className={muted}>{matches[0]?.match_date || "—"}</span>
                  </div>
                  <div className={`divide-y ${darkMode ? "divide-white/5" : "divide-gray-100"}`}>
                    {matches.map(m => {
                      const isSelected = selectedSwapMatch === m.id;
                      return (
                        <button key={m.id} onClick={() => handleMatchClick(m.id)}
                          className={`w-full px-4 py-2.5 flex items-center gap-2 text-sm text-left transition-all ${
                            isSelected
                              ? darkMode ? "bg-blue-500/20 ring-1 ring-blue-500/50" : "bg-blue-100 ring-1 ring-blue-300"
                              : selectedSwapMatch
                                ? darkMode ? "hover:bg-yellow-500/10 cursor-pointer" : "hover:bg-yellow-50 cursor-pointer"
                                : darkMode ? "hover:bg-white/5 cursor-pointer" : "hover:bg-gray-50 cursor-pointer"
                          }`}>
                          <div className="flex-1 flex items-center gap-2 min-w-0">
                            <span className="font-medium text-right w-28 truncate">{m.home_team_name}</span>
                            <span className={`text-xs ${muted}`}>vs</span>
                            <span className="font-medium w-28 truncate">{m.away_team_name}</span>
                          </div>
                          <span className={`text-xs ${muted}`}>{m.match_date || "—"}</span>
                          <span className={`text-xs ${muted}`}>{(m.match_time || "—").slice(0, 5)}</span>
                          {isSelected && <span className="text-xs font-bold text-blue-400">Wybrany</span>}
                        </button>
                      );
                    })}
                  </div>
                </div>
              ))}
            </div>
          )}

          <div className="mt-6 flex gap-3">
            <button onClick={() => setStep(9)} className={btnP}>Dalej: Publikuj</button>
          </div>
        </div>
      )}

      {/* ═══ KROK 9: PUBLIKACJA ═══ */}
      {step === 9 && (
        <div className={`rounded-2xl border p-6 ${card}`}>
          <h2 className="text-xl font-bold mb-4">Publikuj sezon</h2>
          <div className={`rounded-xl border p-6 text-center mb-6 ${darkMode ? "border-white/10" : "border-gray-200"}`}>
            <div className="text-4xl mb-3">🏆</div>
            <h3 className="text-lg font-bold mb-2">{seasonForm.name || `Sezon ${seasonForm.year}`}</h3>
            <div className={`text-sm space-y-1 ${muted}`}>
              {leagues.map(l => <p key={l.id}>{l.name}: {tpl(l.id)} drużyn, {roundsPerRunda(tpl(l.id))} kol/runda × 2 = {roundsForTeams(tpl(l.id))} kol.</p>)}
              <p className="mt-2">{matchWeekends[0] || "—"} → {matchWeekends.length ? addDaysToDateStr(matchWeekends[matchWeekends.length-1], 2) : "—"}</p>
            </div>
          </div>
          <div className={`rounded-xl border p-4 mb-6 ${darkMode ? "border-yellow-500/20 bg-yellow-500/5" : "border-yellow-200 bg-yellow-50"}`}>
            <p className={`text-sm ${darkMode ? "text-yellow-300" : "text-yellow-800"}`}>
              Sezon stanie się <strong>aktywny</strong> i <strong>bieżący</strong>.
            </p>
          </div>
          <div className="flex gap-3">
            <button onClick={() => setStep(8)} className={btnS}><span className="flex items-center gap-1"><ChevronLeft size={16} /> Podgląd</span></button>
            <button onClick={publish} disabled={publishing}
              className="px-8 py-4 rounded-2xl bg-gradient-to-r from-green-500 to-emerald-500 text-white font-black text-lg hover:from-green-400 hover:to-emerald-400 disabled:opacity-40 flex items-center gap-3">
              {publishing ? <><Loader2 size={24} className="animate-spin" /> Publikowanie...</> : <><Rocket size={24} /> PUBLIKUJ SEZON</>}
            </button>
          </div>
        </div>
      )}

      {/* ═══ FLOATING TOASTS ═══ */}
      {toasts.length > 0 && (
        <div className="fixed bottom-6 right-6 z-50 space-y-2 pointer-events-none" style={{ maxWidth: 360 }}>
          {toasts.map(t => (
            <div key={t.id}
              className={`pointer-events-auto flex items-center gap-2 px-4 py-3 rounded-xl shadow-lg text-sm font-medium transition-all duration-500 ${
                t.fading ? "opacity-0 translate-x-8" : "opacity-100 translate-x-0"
              } ${
                t.type === "success" ? "bg-green-500 text-white"
                  : t.type === "error" ? "bg-red-500 text-white"
                    : "bg-blue-500 text-white"
              }`}
            >
              <span className="flex-1">{t.message}</span>
              <button onClick={() => setToasts(prev => prev.filter(x => x.id !== t.id))} className="opacity-60 hover:opacity-100">
                <X size={14} />
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
