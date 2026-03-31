import React, { useState, useEffect, useCallback, useMemo } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminModal from "./components/AdminModal";
import AdminAlert from "./components/AdminAlert";
import {
  Calendar,
  Zap,
  Save,
  RefreshCw,
  Loader2,
  MessageSquareText,
  GripVertical,
  Users,
  ArrowLeftRight,
} from "lucide-react";
import {
  buildSafeRegenerationBatches,
  buildRegenerationPlan,
  formatLockedRounds,
  isEditableScheduleStatus,
} from "./utils/scheduleRegeneration";
import {
  buildEffectiveDayRuleMap,
  getGuidelineRounds,
  parseScheduleGuidelines,
  ruleToLabel,
  scoreGuidelineSlotPreference,
  validatePlanAgainstGuidelines,
} from "./utils/scheduleGuidelines";
import {
  assignMatchesToAllowedSlots,
  getDayKeyFromDate,
} from "./utils/scheduleAssignment";
import {
  buildMidSeasonSchedulePlan,
  buildRoundSwapUpdates,
  getSuggestedStructureRound,
  isSeasonTeamActiveOnRound,
} from "./utils/seasonScheduleAdjustments";

export default function AdminSchedule({ darkMode }) {
  const [seasons, setSeasons] = useState([]);
  const [leagues, setLeagues] = useState([]);
  const [matches, setMatches] = useState([]);
  const [leagueSeasonTeams, setLeagueSeasonTeams] = useState([]);
  const [teamCatalog, setTeamCatalog] = useState([]);
  const [selectedSeason, setSelectedSeason] = useState("");
  const [selectedLeague, setSelectedLeague] = useState("");
  const [loading, setLoading] = useState(true);
  const [loadingLeagueTeams, setLoadingLeagueTeams] = useState(false);
  const [generating, setGenerating] = useState(false);
  const [alert, setAlert] = useState({ type: null, message: null });
  const [startDate, setStartDate] = useState("");
  const [editedMatches, setEditedMatches] = useState({});
  const [regeneratingFuture, setRegeneratingFuture] = useState(false);
  const [showReshuffleModal, setShowReshuffleModal] = useState(false);
  const [reshuffleNotes, setReshuffleNotes] = useState("");
  const [draggedMatchId, setDraggedMatchId] = useState(null);
  const [dropTargetMatchId, setDropTargetMatchId] = useState(null);
  const [swappingMatches, setSwappingMatches] = useState(false);
  const [showTeamManagerModal, setShowTeamManagerModal] = useState(false);
  const [removeTeamId, setRemoveTeamId] = useState("");
  const [removeFromRound, setRemoveFromRound] = useState("");
  const [addTeamId, setAddTeamId] = useState("");
  const [addFromRound, setAddFromRound] = useState("");
  const [applyingTeamChange, setApplyingTeamChange] = useState(false);
  const [showRoundSwapModal, setShowRoundSwapModal] = useState(false);
  const [roundSwapScope, setRoundSwapScope] = useState("league");
  const [draggedRoundNumber, setDraggedRoundNumber] = useState(null);
  const [dropTargetRoundNumber, setDropTargetRoundNumber] = useState(null);
  const [swappingRounds, setSwappingRounds] = useState(false);

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const leagueTeams = useMemo(() => {
    const byId = new Map();

    for (const match of matches) {
      if (match?.home_team_id && !byId.has(match.home_team_id)) {
        byId.set(match.home_team_id, { id: match.home_team_id, name: match.home_team_name });
      }
      if (match?.away_team_id && !byId.has(match.away_team_id)) {
        byId.set(match.away_team_id, { id: match.away_team_id, name: match.away_team_name });
      }
    }

    return [...byId.values()];
  }, [matches]);

  const teamNames = useMemo(
    () => new Map(leagueTeams.map((team) => [team.id, team.name])),
    [leagueTeams]
  );

  const parsedReshuffleGuidelines = useMemo(
    () => parseScheduleGuidelines(reshuffleNotes, leagueTeams),
    [reshuffleNotes, leagueTeams]
  );

  const parsedReshuffleLabels = useMemo(
    () => parsedReshuffleGuidelines.rules.map((rule) => ruleToLabel(rule, teamNames)),
    [parsedReshuffleGuidelines, teamNames]
  );

  const matchesById = useMemo(
    () => new Map(matches.map((match) => [String(match.id), match])),
    [matches]
  );

  const selectedLeagueMeta = useMemo(
    () => leagues.find((league) => league.id === selectedLeague) || null,
    [leagues, selectedLeague]
  );

  const highestRound = useMemo(
    () => Math.max(0, ...matches.map((match) => Number(match.round) || 0)),
    [matches]
  );

  const roundSwapTiles = useMemo(() => {
    const roundGroups = {};

    for (const match of matches) {
      if (!roundGroups[match.round]) {
        roundGroups[match.round] = [];
      }
      roundGroups[match.round].push(match);
    }

    return Object.entries(roundGroups)
      .map(([roundNumber, roundMatches]) => {
        const scheduledMatches = [...(roundMatches || [])].sort((left, right) => {
          const leftDate = String(left.match_date || "9999-12-31");
          const rightDate = String(right.match_date || "9999-12-31");
          if (leftDate !== rightDate) return leftDate.localeCompare(rightDate);

          const leftTime = String(left.match_time || "99:99");
          const rightTime = String(right.match_time || "99:99");
          return leftTime.localeCompare(rightTime);
        });

        const firstMatch = scheduledMatches[0] || null;
        const lastMatch = scheduledMatches[scheduledMatches.length - 1] || null;
        const isLocked = scheduledMatches.some((match) => !isEditableScheduleStatus(match.status));

        return {
          round: Number(roundNumber),
          matchCount: scheduledMatches.length,
          firstDate: firstMatch?.match_date || "",
          firstTime: firstMatch?.match_time || "",
          lastDate: lastMatch?.match_date || "",
          lastTime: lastMatch?.match_time || "",
          isLocked,
        };
      })
      .sort((left, right) => left.round - right.round);
  }, [matches]);

  const suggestedStructureRound = useMemo(
    () => getSuggestedStructureRound(matches),
    [matches]
  );

  const hasPendingEdits = useMemo(
    () => Object.keys(editedMatches).length > 0,
    [editedMatches]
  );

  const activeTeamsAtRemoveRound = useMemo(() => {
    const effectiveRound = Number(removeFromRound) || suggestedStructureRound;
    return leagueSeasonTeams.filter((seasonTeam) => isSeasonTeamActiveOnRound(seasonTeam, effectiveRound));
  }, [leagueSeasonTeams, removeFromRound, suggestedStructureRound]);

  const availableTeamsForAddition = useMemo(() => {
    return (teamCatalog || []).filter(
      (team) => !leagueSeasonTeams.some((seasonTeam) => seasonTeam.team_id === team.id)
    );
  }, [teamCatalog, leagueSeasonTeams]);

  function formatRoundDateLabel(dateStr) {
    if (!dateStr) return "Bez daty";

    try {
      return new Intl.DateTimeFormat("pl-PL", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
      }).format(new Date(`${dateStr}T12:00:00`));
    } catch {
      return dateStr;
    }
  }

  function formatRoundWindowLabel(tile) {
    if (!tile?.firstDate) return "Brak przypisanych terminow";

    const firstDateLabel = formatRoundDateLabel(tile.firstDate);
    const lastDateLabel = formatRoundDateLabel(tile.lastDate || tile.firstDate);
    const firstTime = tile.firstTime ? ` ${tile.firstTime}` : "";
    const lastTime = tile.lastTime ? ` ${tile.lastTime}` : "";

    if (tile.firstDate === tile.lastDate) {
      return `${firstDateLabel}${firstTime}${tile.lastTime && tile.lastTime !== tile.firstTime ? ` - ${tile.lastTime}` : ""}`;
    }

    return `${firstDateLabel}${firstTime} -> ${lastDateLabel}${lastTime}`;
  }

  const loadBase = useCallback(async () => {
    const [{ data: seasonsData }, { data: leaguesData }] = await Promise.all([
      supabase.from("seasons").select("*").order("year", { ascending: false }),
      supabase.from("leagues").select("*").order("display_order"),
    ]);

    setSeasons(seasonsData || []);
    setLeagues(leaguesData || []);

    if (seasonsData?.length) setSelectedSeason(seasonsData[0].id);
    if (leaguesData?.length) setSelectedLeague(leaguesData[0].id);
    setLoading(false);
  }, []);

  useEffect(() => {
    loadBase();
  }, [loadBase]);

  useEffect(() => {
    if (selectedSeason && selectedLeague) {
      loadMatches();
    }
  }, [selectedSeason, selectedLeague]);

  useEffect(() => {
    if (selectedSeason && selectedLeague) {
      loadLeagueTeams();
    }
  }, [selectedSeason, selectedLeague]);

  async function loadMatches() {
    const { data } = await supabase
      .from("v_matches")
      .select("*")
      .eq("season_id", selectedSeason)
      .eq("league_id", selectedLeague)
      .order("round")
      .order("match_date")
      .order("match_time");

    setMatches(data || []);
    setEditedMatches({});
  }

  async function loadLeagueTeams() {
    setLoadingLeagueTeams(true);

    try {
      const [{ data: seasonTeamRows, error: seasonTeamsError }, { data: allTeamsRows, error: allTeamsError }] = await Promise.all([
        supabase
          .from("season_teams")
          .select(`
            id,
            season_id,
            league_id,
            team_id,
            joined_round,
            left_round,
            join_reason,
            teams (
              id,
              name,
              abbreviation,
              logo_url
            )
          `)
          .eq("season_id", selectedSeason)
          .eq("league_id", selectedLeague)
          .order("created_at"),
        supabase
          .from("teams")
          .select("id, name, abbreviation, logo_url, is_active")
          .eq("is_active", true)
          .order("name"),
      ]);

      if (seasonTeamsError) throw seasonTeamsError;
      if (allTeamsError) throw allTeamsError;

      setLeagueSeasonTeams(
        (seasonTeamRows || []).map((row) => ({
          ...row,
          team: Array.isArray(row.teams) ? row.teams[0] : row.teams,
        }))
      );
      setTeamCatalog(allTeamsRows || []);
    } catch (error) {
      setAlert({ type: "error", message: `Nie udalo sie zaladowac druzyn ligi: ${error.message}` });
    } finally {
      setLoadingLeagueTeams(false);
    }
  }

  function sortMatchesBySchedule(matchList) {
    return [...matchList].sort((left, right) => {
      const roundDiff = Number(left.round ?? 0) - Number(right.round ?? 0);
      if (roundDiff !== 0) return roundDiff;

      const leftDate = left.match_date || "9999-12-31";
      const rightDate = right.match_date || "9999-12-31";
      if (leftDate !== rightDate) return leftDate.localeCompare(rightDate);

      const leftTime = left.match_time || "99:99";
      const rightTime = right.match_time || "99:99";
      if (leftTime !== rightTime) return leftTime.localeCompare(rightTime);

      return String(left.id).localeCompare(String(right.id), undefined, { numeric: true });
    });
  }

  function getVisibleMatchValue(match, field) {
    return editedMatches[match.id]?.[field] ?? match[field] ?? "";
  }

  function applyMatchUpdatesLocally(updates) {
    const updatesById = new Map(
      updates.map((update) => [String(update.matchId), update.payload])
    );

    setMatches((prev) =>
      sortMatchesBySchedule(
        prev.map((match) => {
          const patch = updatesById.get(String(match.id));
          return patch ? { ...match, ...patch } : match;
        })
      )
    );
  }

  function clearEditedMatches(matchIds) {
    setEditedMatches((prev) => {
      const next = { ...prev };
      matchIds.forEach((matchId) => {
        delete next[matchId];
      });
      return next;
    });
  }

  function getLeagueSeasonTeamName(seasonTeam) {
    return seasonTeam?.team?.name || seasonTeam?.teams?.name || "Nieznana druzyna";
  }

  async function persistMatchPayloadUpdates(updates) {
    if (!updates?.length) return;

    const results = await Promise.all(
      updates.map((update) =>
        supabase
          .from("matches")
          .update(update.payload)
          .eq("id", update.matchId)
      )
    );

    const failedResult = results.find((result) => result.error);
    if (failedResult?.error) {
      throw failedResult.error;
    }
  }

  function openTeamManagerModal() {
    if (!selectedSeason || !selectedLeague || matches.length === 0) {
      setAlert({ type: "error", message: "Najpierw wybierz lige z istniejacym terminarzem." });
      return;
    }

    const defaultRound = String(suggestedStructureRound || 1);
    setRemoveFromRound(defaultRound);
    setAddFromRound(defaultRound);
    setRemoveTeamId("");
    setAddTeamId("");
    setShowTeamManagerModal(true);
  }

  function openRoundSwapModal() {
    if (!selectedSeason || !selectedLeague || matches.length === 0) {
      setAlert({ type: "error", message: "Najpierw wybierz lige z istniejacym terminarzem." });
      return;
    }

    setRoundSwapScope("league");
    setDraggedRoundNumber(null);
    setDropTargetRoundNumber(null);
    setShowRoundSwapModal(true);
  }

  function prepareSeasonTeamsAfterChange(mode, teamId, effectiveRound) {
    if (mode === "remove") {
      const targetSeasonTeam = leagueSeasonTeams.find((seasonTeam) => seasonTeam.team_id === teamId);

      if (!targetSeasonTeam) {
        throw new Error("Nie znaleziono druzyny w tej lidze.");
      }
      if (!isSeasonTeamActiveOnRound(targetSeasonTeam, effectiveRound)) {
        throw new Error("Ta druzyna nie jest aktywna w wybranej kolejce.");
      }

      return {
        teamName: getLeagueSeasonTeamName(targetSeasonTeam),
        nextSeasonTeams: leagueSeasonTeams.map((seasonTeam) =>
          seasonTeam.team_id === teamId
            ? { ...seasonTeam, left_round: effectiveRound }
            : seasonTeam
        ),
        dbChange: {
          kind: "update",
          rowId: targetSeasonTeam.id,
          payload: { left_round: effectiveRound },
        },
      };
    }

    const existingSeasonTeam = leagueSeasonTeams.find((seasonTeam) => seasonTeam.team_id === teamId);
    if (existingSeasonTeam) {
      throw new Error("Ta druzyna jest juz przypisana do tego sezonu. Dodawanie obsluguje tylko nowe druzyny.");
    }

    const catalogTeam = teamCatalog.find((team) => team.id === teamId);
    if (!catalogTeam) {
      throw new Error("Nie znaleziono wybranej druzyny.");
    }

    return {
      teamName: catalogTeam.name,
      nextSeasonTeams: [
        ...leagueSeasonTeams,
        {
          season_id: selectedSeason,
          league_id: selectedLeague,
          team_id: teamId,
          joined_round: effectiveRound,
          left_round: null,
          join_reason: "mid_season_join",
          team: catalogTeam,
        },
      ],
      dbChange: {
        kind: "insert",
        payload: {
          season_id: selectedSeason,
          league_id: selectedLeague,
          team_id: teamId,
          joined_round: effectiveRound,
          left_round: null,
          join_reason: "mid_season_join",
        },
      },
    };
  }

  async function applyLeagueTeamChange(mode) {
    if (hasPendingEdits) {
      setAlert({ type: "error", message: "Najpierw zapisz reczne zmiany terminow meczow." });
      return;
    }

    const effectiveRound = Number(mode === "remove" ? removeFromRound : addFromRound);
    const teamId = mode === "remove" ? removeTeamId : addTeamId;

    if (!teamId || !effectiveRound) {
      setAlert({ type: "error", message: "Wybierz druzyne i kolejke startowa." });
      return;
    }

    let preparedChange;
    let plan;

    try {
      preparedChange = prepareSeasonTeamsAfterChange(mode, teamId, effectiveRound);
      plan = buildMidSeasonSchedulePlan({
        matches,
        seasonTeams: preparedChange.nextSeasonTeams,
        startRound: effectiveRound,
      });
    } catch (error) {
      setAlert({ type: "error", message: error.message });
      return;
    }

    setApplyingTeamChange(true);

    try {
      if (preparedChange.dbChange.kind === "update") {
        const { error } = await supabase
          .from("season_teams")
          .update(preparedChange.dbChange.payload)
          .eq("id", preparedChange.dbChange.rowId);
        if (error) throw error;
      } else {
        const { error } = await supabase
          .from("season_teams")
          .insert(preparedChange.dbChange.payload);
        if (error) throw error;

        const { error: standingsError } = await supabase.rpc("initialize_standings", {
          p_season_id: selectedSeason,
          p_league_id: selectedLeague,
        });
        if (standingsError) throw standingsError;
      }

      if (plan.deletedMatchIds.length) {
        const { error: lineupError } = await supabase
          .from("match_lineups")
          .delete()
          .in("match_id", plan.deletedMatchIds);
        if (lineupError) throw lineupError;

        const { error: eventError } = await supabase
          .from("match_events")
          .delete()
          .in("match_id", plan.deletedMatchIds);
        if (eventError) throw eventError;

        const { error: deleteMatchesError } = await supabase
          .from("matches")
          .delete()
          .in("id", plan.deletedMatchIds);
        if (deleteMatchesError) throw deleteMatchesError;
      }

      if (plan.inserts.length) {
        const { error: insertMatchesError } = await supabase
          .from("matches")
          .insert(
            plan.inserts.map((match) => ({
              season_id: selectedSeason,
              league_id: selectedLeague,
              ...match,
            }))
          );
        if (insertMatchesError) throw insertMatchesError;
      }

      const { error: seasonLeagueError } = await supabase
        .from("season_leagues")
        .update({ total_rounds: plan.finalRound })
        .eq("season_id", selectedSeason)
        .eq("league_id", selectedLeague);
      if (seasonLeagueError) throw seasonLeagueError;

      await Promise.all([loadMatches(), loadLeagueTeams()]);

      setShowTeamManagerModal(false);
      setAlert({
        type: "success",
        message:
          mode === "remove"
            ? `Druzyna ${preparedChange.teamName} nie gra od kolejki ${effectiveRound}. Przebudowalem przyszly terminarz ligi ${selectedLeagueMeta?.name || ""}.`
            : `Dodalem ${preparedChange.teamName} od kolejki ${effectiveRound} i przebudowalem przyszly terminarz ligi ${selectedLeagueMeta?.name || ""}.`,
      });
    } catch (error) {
      setAlert({ type: "error", message: `Nie udalo sie zapisac zmiany druzyny: ${error.message}` });
    } finally {
      setApplyingTeamChange(false);
    }
  }

  async function applyRoundSwap(scope, sourceRoundInput, targetRoundInput) {
    if (hasPendingEdits) {
      setAlert({ type: "error", message: "Najpierw zapisz reczne zmiany terminow meczow." });
      return;
    }

    const sourceRound = Number(sourceRoundInput);
    const targetRound = Number(targetRoundInput);

    if (!sourceRound || !targetRound) {
      setAlert({ type: "error", message: "Podaj dwie kolejki do zamiany." });
      return;
    }

    setSwappingRounds(true);

    try {
      if (scope === "league") {
        const plan = buildRoundSwapUpdates(matches, sourceRound, targetRound);
        await persistMatchPayloadUpdates(plan.updates);
        await loadMatches();
        setAlert({
          type: "success",
          message: `Zamieniono terminami kolejki ${sourceRound} i ${targetRound} w lidze ${selectedLeagueMeta?.name || ""}.`,
        });
        return;
      }

      const { data: seasonMatches, error: seasonMatchesError } = await supabase
        .from("matches")
        .select("id, league_id, round, match_date, match_time, status, home_team_id, away_team_id")
        .eq("season_id", selectedSeason)
        .order("league_id")
        .order("round")
        .order("match_date")
        .order("match_time");

      if (seasonMatchesError) throw seasonMatchesError;

      const matchesByLeague = new Map();
      for (const match of seasonMatches || []) {
        if (!matchesByLeague.has(match.league_id)) {
          matchesByLeague.set(match.league_id, []);
        }
        matchesByLeague.get(match.league_id).push(match);
      }

      const successfulPlans = [];
      const skippedLeagues = [];

      for (const league of leagues) {
        const leagueMatches = matchesByLeague.get(league.id) || [];
        if (!leagueMatches.length) continue;

        try {
          const plan = buildRoundSwapUpdates(leagueMatches, sourceRound, targetRound);
          successfulPlans.push({ league, plan });
        } catch (error) {
          skippedLeagues.push(`${league.name}: ${error.message}`);
        }
      }

      if (successfulPlans.length === 0) {
        throw new Error(skippedLeagues[0] || "Nie znaleziono zadnej ligi, w ktorej da sie wykonac te zamiane.");
      }

      for (const entry of successfulPlans) {
        await persistMatchPayloadUpdates(entry.plan.updates);
      }

      await loadMatches();

      const skippedLabel = skippedLeagues.length
        ? ` Pominiete ligi: ${skippedLeagues.join(" | ")}`
        : "";

      setAlert({
        type: "success",
        message: `Globalnie zamieniono kolejki ${sourceRound} i ${targetRound} w ${successfulPlans.length} ligach.${skippedLabel}`,
      });
    } catch (error) {
      setAlert({ type: "error", message: `Nie udalo sie zamienic kolejek: ${error.message}` });
    } finally {
      setSwappingRounds(false);
      setDraggedRoundNumber(null);
      setDropTargetRoundNumber(null);
    }
  }

  function handleRoundDragStart(event, roundNumber) {
    if (swappingRounds) return;

    setDraggedRoundNumber(String(roundNumber));
    event.dataTransfer.effectAllowed = "move";
    event.dataTransfer.setData("text/plain", String(roundNumber));
  }

  function handleRoundDragOver(event, roundNumber) {
    if (swappingRounds || String(roundNumber) === String(draggedRoundNumber)) return;

    event.preventDefault();
    event.dataTransfer.dropEffect = "move";

    if (String(roundNumber) !== String(dropTargetRoundNumber)) {
      setDropTargetRoundNumber(String(roundNumber));
    }
  }

  function handleRoundDrop(event, targetRoundNumber) {
    event.preventDefault();

    const sourceRoundNumber = draggedRoundNumber || event.dataTransfer.getData("text/plain");
    if (!sourceRoundNumber || String(sourceRoundNumber) === String(targetRoundNumber)) {
      setDropTargetRoundNumber(null);
      return;
    }

    applyRoundSwap(roundSwapScope, sourceRoundNumber, targetRoundNumber);
  }

  function handleRoundDragEnd() {
    if (swappingRounds) return;

    setDraggedRoundNumber(null);
    setDropTargetRoundNumber(null);
  }

  function buildGuidelineAwarePlan(leagueMatches, teamCount, guidelines) {
    const maxAttempts = 500;

    for (let attempt = 0; attempt < maxAttempts; attempt += 1) {
      const candidate = buildRegenerationPlan(leagueMatches, teamCount);
      if (validatePlanAgainstGuidelines(candidate, guidelines)) {
        return candidate;
      }
    }

    if (guidelines?.blockedMatchups?.length) {
      throw new Error("Nie udalo sie znalezc ukladu kolejek spelniajacego podane wytyczne.");
    }

    return buildRegenerationPlan(leagueMatches, teamCount);
  }

  async function handleGenerate() {
    if (!startDate) {
      setAlert({ type: "error", message: "Wybierz date startu." });
      return;
    }

    if (matches.length > 0) {
      if (!window.confirm("Terminarz juz istnieje. Wygenerowac od nowa i skasowac stary?")) return;
      await supabase
        .from("matches")
        .delete()
        .eq("season_id", selectedSeason)
        .eq("league_id", selectedLeague);
    }

    setGenerating(true);

    const { data, error } = await supabase.rpc("generate_round_robin", {
      p_season_id: selectedSeason,
      p_league_id: selectedLeague,
      p_start_date: startDate,
    });

    if (error) {
      setAlert({ type: "error", message: `Blad generowania: ${error.message}` });
      setGenerating(false);
      return;
    }

    await supabase.rpc("initialize_standings", {
      p_season_id: selectedSeason,
      p_league_id: selectedLeague,
    });

    setAlert({
      type: "success",
      message: `Terminarz wygenerowany. ${data?.matches_created || ""} meczow w ${data?.rounds_total || ""} kolejkach.`,
    });
    setGenerating(false);
    loadMatches();
  }

  function openReshuffleModal() {
    if (!selectedSeason || !selectedLeague || matches.length === 0) {
      setAlert({ type: "error", message: "Najpierw wybierz lige z istniejacym terminarzem." });
      return;
    }

    setShowReshuffleModal(true);
  }

  async function confirmRegenerateFutureRounds() {
    setRegeneratingFuture(true);

    try {
      const { data: seasonTeams, error: teamError } = await supabase
        .from("season_teams")
        .select("team_id")
        .eq("season_id", selectedSeason)
        .eq("league_id", selectedLeague);

      if (teamError) throw teamError;

      const teamCount = seasonTeams?.length || 0;
      const basePlan = buildRegenerationPlan(matches, teamCount);

      const invalidRound = getGuidelineRounds(parsedReshuffleGuidelines).find(
        (roundNumber) => roundNumber > basePlan.totalRounds
      );
      if (invalidRound) {
        throw new Error(`Ta liga ma tylko ${basePlan.totalRounds} kolejek, a wytyczna dotyczy kolejki ${invalidRound}.`);
      }

      const lockedGuidelineRounds = getGuidelineRounds(parsedReshuffleGuidelines).filter((roundNumber) =>
        basePlan.lockedRounds.includes(roundNumber)
      );
      if (lockedGuidelineRounds.length > 0) {
        throw new Error(
          `Nie moge zastosowac wytycznych dla zablokowanych kolejek: ${formatLockedRounds(lockedGuidelineRounds, basePlan.roundsInHalf)}.`
        );
      }

      const plan = buildGuidelineAwarePlan(matches, teamCount, parsedReshuffleGuidelines);

      if (plan.updates.length === 0) {
        const lockedLabel = plan.lockedRounds.length
          ? ` Zablokowane: ${formatLockedRounds(plan.lockedRounds, plan.roundsInHalf)}.`
          : "";

        setAlert({
          type: "warning",
          message: `Brak kolejek do przetasowania.${lockedLabel}`,
        });
        setRegeneratingFuture(false);
        return;
      }

      let updatesToApply = plan.updates;
      if (parsedReshuffleGuidelines.hasRules) {
        const matchById = new Map(matches.map((match) => [match.id, match]));
        const constrainedUpdates = [];

        for (const round of plan.editableRounds) {
          const roundUpdates = plan.updates.filter((update) => matchById.get(update.matchId)?.round === round);
          if (!roundUpdates.length) continue;

          const pairings = roundUpdates.map((update) => ({
            home_team_id: update.payload.home_team_id,
            away_team_id: update.payload.away_team_id,
            payload: update.payload,
          }));

          const targetRows = roundUpdates.map((update) => {
            const targetMatch = matchById.get(update.matchId);
            return {
              matchId: update.matchId,
              dayKey: getDayKeyFromDate(targetMatch?.match_date),
              time: targetMatch?.match_time,
              match_time: targetMatch?.match_time,
            };
          });

          const effectiveDayRules = buildEffectiveDayRuleMap({}, parsedReshuffleGuidelines, round);
          const assignments = assignMatchesToAllowedSlots(
            pairings,
            targetRows,
            effectiveDayRules,
            teamNames,
            `${leagues.find((league) => league.id === selectedLeague)?.name || "Liga"}, kolejka ${round}`,
            {
              scoreMatchSlot: (match, slot) =>
                scoreGuidelineSlotPreference(match, slot, parsedReshuffleGuidelines, round),
            }
          );

          for (const { match, slot } of assignments) {
            constrainedUpdates.push({
              matchId: slot.matchId,
              targetRound: round,
              payload: match.payload,
            });
          }
        }

        if (constrainedUpdates.length > 0) {
          updatesToApply = constrainedUpdates;
        }
      }

      if (plan.cleanupMatchIds.length) {
        const { error: lineupError } = await supabase
          .from("match_lineups")
          .delete()
          .in("match_id", plan.cleanupMatchIds);
        if (lineupError) throw lineupError;

        const { error: eventError } = await supabase
          .from("match_events")
          .delete()
          .in("match_id", plan.cleanupMatchIds);
        if (eventError) throw eventError;
      }

      const { stageOne, stageTwo } = buildSafeRegenerationBatches(updatesToApply, matches);

      for (const update of stageOne) {
        const { error } = await supabase
          .from("matches")
          .update(update.payload)
          .eq("id", update.matchId);
        if (error) throw error;
      }

      for (const update of stageTwo) {
        const { error } = await supabase
          .from("matches")
          .update(update.payload)
          .eq("id", update.matchId);
        if (error) throw error;
      }

      const lockedLabel = plan.lockedRounds.length
        ? ` Zablokowane: ${formatLockedRounds(plan.lockedRounds, plan.roundsInHalf)}.`
        : "";

      setAlert({
        type: "success",
        message: `Przetasowano ${plan.editableRounds.length} kolejek bez naruszania rozegranych rund i ich rewanzy.${lockedLabel}`,
      });

      setShowReshuffleModal(false);
      await loadMatches();
    } catch (error) {
      setAlert({ type: "error", message: `Blad regenerowania: ${error.message}` });
    } finally {
      setRegeneratingFuture(false);
    }
  }

  function handleMatchEdit(matchId, field, value) {
    setEditedMatches((prev) => ({
      ...prev,
      [matchId]: { ...prev[matchId], [field]: value },
    }));
  }

  async function saveMatchEdits(matchId) {
    const edits = editedMatches[matchId];
    if (!edits) return;

    const { error } = await supabase
      .from("matches")
      .update(edits)
      .eq("id", matchId);

    if (error) {
      setAlert({ type: "error", message: error.message });
      return;
    }

    applyMatchUpdatesLocally([{ matchId, payload: edits }]);
    clearEditedMatches([matchId]);
    setAlert({ type: "success", message: "Mecz zaktualizowany." });
  }

  async function swapMatchSchedules(sourceMatchId, targetMatchId) {
    if (!sourceMatchId || !targetMatchId || String(sourceMatchId) === String(targetMatchId)) return;

    const sourceMatch = matchesById.get(String(sourceMatchId));
    const targetMatch = matchesById.get(String(targetMatchId));
    if (!sourceMatch || !targetMatch) return;

    const sourceSlot = {
      match_date: getVisibleMatchValue(sourceMatch, "match_date"),
      match_time: getVisibleMatchValue(sourceMatch, "match_time"),
    };
    const targetSlot = {
      match_date: getVisibleMatchValue(targetMatch, "match_date"),
      match_time: getVisibleMatchValue(targetMatch, "match_time"),
    };

    if (
      sourceSlot.match_date === targetSlot.match_date &&
      sourceSlot.match_time === targetSlot.match_time
    ) {
      setAlert({ type: "warning", message: "Te mecze maja juz ten sam termin." });
      return;
    }

    setSwappingMatches(true);

    try {
      const updates = [
        { matchId: sourceMatch.id, payload: targetSlot },
        { matchId: targetMatch.id, payload: sourceSlot },
      ];

      for (const update of updates) {
        const { error } = await supabase
          .from("matches")
          .update(update.payload)
          .eq("id", update.matchId);

        if (error) throw error;
      }

      applyMatchUpdatesLocally(updates);
      clearEditedMatches([sourceMatch.id, targetMatch.id]);
      setAlert({ type: "success", message: "Spotkania zamienily sie terminami." });
    } catch (error) {
      setAlert({ type: "error", message: `Nie udalo sie zamienic terminow: ${error.message}` });
    } finally {
      setSwappingMatches(false);
      setDraggedMatchId(null);
      setDropTargetMatchId(null);
    }
  }

  function handleDragStart(event, matchId) {
    if (swappingMatches) return;

    setDraggedMatchId(String(matchId));
    event.dataTransfer.effectAllowed = "move";
    event.dataTransfer.setData("text/plain", String(matchId));
  }

  function handleDragOver(event, matchId) {
    if (swappingMatches || String(matchId) === String(draggedMatchId)) return;

    event.preventDefault();
    event.dataTransfer.dropEffect = "move";

    if (String(matchId) !== String(dropTargetMatchId)) {
      setDropTargetMatchId(String(matchId));
    }
  }

  function handleDrop(event, targetMatchId) {
    event.preventDefault();

    const sourceMatchId = draggedMatchId || event.dataTransfer.getData("text/plain");
    if (!sourceMatchId || String(sourceMatchId) === String(targetMatchId)) {
      setDropTargetMatchId(null);
      return;
    }

    swapMatchSchedules(sourceMatchId, targetMatchId);
  }

  function handleDragEnd() {
    if (swappingMatches) return;
    setDraggedMatchId(null);
    setDropTargetMatchId(null);
  }

  const rounds = useMemo(() => {
    const groupedRounds = {};

    matches.forEach((match) => {
      if (!groupedRounds[match.round]) groupedRounds[match.round] = [];
      groupedRounds[match.round].push(match);
    });

    return groupedRounds;
  }, [matches]);

  const statusLabels = {
    scheduled: "Zaplanowany",
    live: "W trakcie",
    completed: "Zakonczony",
    walkover_home: "Walkower (gosp.)",
    walkover_away: "Walkower (gosc)",
    postponed: "Przelozony",
    cancelled: "Odwolany",
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
      <h2 className="text-2xl font-bold">Terminarz</h2>

      <AdminAlert
        type={alert.type}
        message={alert.message}
        onClose={() => setAlert({ type: null, message: null })}
      />

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <AdminFormField
          label="Sezon"
          name="season"
          type="select"
          value={selectedSeason}
          onChange={(e) => setSelectedSeason(e.target.value)}
          darkMode={darkMode}
          options={seasons.map((season) => ({ value: season.id, label: season.name }))}
        />
        <AdminFormField
          label="Liga"
          name="league"
          type="select"
          value={selectedLeague}
          onChange={(e) => setSelectedLeague(e.target.value)}
          darkMode={darkMode}
          options={leagues.map((league) => ({ value: league.id, label: league.name }))}
        />
      </div>

      {matches.length === 0 ? (
        <div className={`rounded-2xl border p-6 text-center ${card}`}>
          <Calendar size={48} className={`mx-auto mb-4 ${textMuted}`} />
          <h3 className="text-lg font-bold mb-2">Brak terminarza</h3>
          <p className={`text-sm mb-4 ${textMuted}`}>Wygeneruj terminarz round-robin dla tej ligi.</p>
          <div className="flex items-center justify-center gap-4 flex-wrap">
            <input
              type="date"
              value={startDate}
              onChange={(e) => setStartDate(e.target.value)}
              className={`px-3 py-2 rounded-xl border outline-none ${
                darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-300"
              }`}
            />
            <button
              onClick={handleGenerate}
              disabled={generating}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 disabled:opacity-50"
            >
              <Zap size={16} />
              {generating ? "Generowanie..." : "Generuj terminarz"}
            </button>
          </div>
        </div>
      ) : (
        <div className="space-y-4">
          <div className="flex flex-wrap items-center justify-between gap-3">
            <p className={`text-sm ${textMuted}`}>
              {matches.length} meczow w {Object.keys(rounds).length} kolejkach
            </p>
            <div className="flex flex-wrap items-center gap-2">
              <button
                onClick={openTeamManagerModal}
                disabled={applyingTeamChange || loadingLeagueTeams}
                className={`flex items-center gap-2 px-3 py-2 rounded-xl text-sm ${
                  darkMode
                    ? "bg-white/5 text-white hover:bg-white/10"
                    : "bg-white border border-gray-200 text-gray-700 hover:bg-gray-50"
                } disabled:opacity-50`}
              >
                {applyingTeamChange || loadingLeagueTeams ? <Loader2 size={14} className="animate-spin" /> : <Users size={14} />}
                Druzyny w sezonie
              </button>
              <button
                onClick={openRoundSwapModal}
                disabled={swappingRounds}
                className={`flex items-center gap-2 px-3 py-2 rounded-xl text-sm ${
                  darkMode
                    ? "bg-white/5 text-white hover:bg-white/10"
                    : "bg-white border border-gray-200 text-gray-700 hover:bg-gray-50"
                } disabled:opacity-50`}
              >
                {swappingRounds ? <Loader2 size={14} className="animate-spin" /> : <ArrowLeftRight size={14} />}
                Zamien kolejki
              </button>
              <button
                onClick={openReshuffleModal}
                disabled={regeneratingFuture}
                className="flex items-center gap-2 px-3 py-2 rounded-xl bg-cyan-500/10 text-cyan-400 text-sm hover:bg-cyan-500/20 disabled:opacity-50"
              >
                {regeneratingFuture ? <Loader2 size={14} className="animate-spin" /> : <RefreshCw size={14} />}
                Przetasuj przyszle kolejki
              </button>
            </div>
          </div>

          <div className={`rounded-2xl border px-4 py-3 text-sm ${card}`}>
            Ta opcja nie rusza rozegranych kolejek. Automatycznie blokuje tez odpowiadajace im kolejki rewanzowe,
            a przyszle mecze uklada w juz istniejacych datach i godzinach tej ligi.
          </div>

          <div className={`rounded-2xl border px-4 py-3 text-sm ${card}`}>
            Przeciagnij kafelek meczu na inny kafelek, aby oba spotkania zamienily sie data i godzina.
          </div>

          <div className={`rounded-2xl border px-4 py-3 text-sm ${card}`}>
            W tym samym panelu mozesz tez wycofac lub dodac druzyne od konkretnej kolejki oraz zamienic terminami cale kolejki w tej lidze albo globalnie dla sezonu.
          </div>

          {Object.entries(rounds)
            .sort(([a], [b]) => Number(a) - Number(b))
            .map(([roundNum, roundMatches]) => (
              <div key={roundNum} className={`rounded-2xl border overflow-hidden ${card}`}>
                <div className={`px-4 py-2 font-semibold text-sm ${darkMode ? "bg-white/5" : "bg-gray-50"}`}>
                  Kolejka {roundNum}
                </div>
                <div className="divide-y" style={{ borderColor: darkMode ? "rgba(255,255,255,0.05)" : "rgba(0,0,0,0.05)" }}>
                  {roundMatches.map((match) => {
                    const edits = editedMatches[match.id] || {};
                    const hasEdits = Object.keys(edits).length > 0;
                    const isDragged = String(draggedMatchId) === String(match.id);
                    const isDropTarget = String(dropTargetMatchId) === String(match.id);

                    return (
                      <div className="px-4 py-3" key={match.id}>
                        <div
                          draggable={!swappingMatches}
                          onDragStart={(event) => handleDragStart(event, match.id)}
                          onDragOver={(event) => handleDragOver(event, match.id)}
                          onDrop={(event) => handleDrop(event, match.id)}
                          onDragEnd={handleDragEnd}
                          className={`rounded-2xl border p-4 transition-all ${
                            darkMode
                              ? "bg-white/[0.03] border-white/10"
                              : "bg-white border-gray-200"
                          } ${
                            swappingMatches ? "opacity-70 cursor-wait" : "cursor-grab active:cursor-grabbing"
                          } ${
                            isDragged ? "scale-[0.99] opacity-60" : ""
                          } ${
                            isDropTarget
                              ? darkMode
                                ? "border-cyan-400 bg-cyan-500/10 shadow-[0_0_0_1px_rgba(34,211,238,0.45)]"
                                : "border-cyan-500 bg-cyan-50 shadow-[0_0_0_1px_rgba(6,182,212,0.28)]"
                              : ""
                          }`}
                        >
                          <div className="flex items-center gap-3 flex-wrap">
                            <div
                              className={`flex items-center gap-2 text-xs font-medium select-none ${
                                darkMode ? "text-cyan-300" : "text-cyan-700"
                              }`}
                            >
                              <GripVertical size={16} />
                              Przesun, aby zamienic termin
                            </div>

                            <div className="flex-1 min-w-[220px]">
                              <span className="font-medium">{match.home_team_name}</span>
                              <span className={`mx-2 ${textMuted}`}>vs</span>
                              <span className="font-medium">{match.away_team_name}</span>
                            </div>

                            <input
                              type="date"
                              draggable={false}
                              value={getVisibleMatchValue(match, "match_date")}
                              onChange={(e) => handleMatchEdit(match.id, "match_date", e.target.value)}
                              className={`px-2 py-1 rounded-lg border text-sm w-36 ${
                                darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-200"
                              }`}
                            />
                            <input
                              type="time"
                              draggable={false}
                              value={getVisibleMatchValue(match, "match_time")}
                              onChange={(e) => handleMatchEdit(match.id, "match_time", e.target.value)}
                              className={`px-2 py-1 rounded-lg border text-sm w-24 ${
                                darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-200"
                              }`}
                            />
                            <span className={`text-xs ${textMuted}`}>{statusLabels[match.status] || match.status}</span>

                            {hasEdits && (
                              <button
                                onClick={() => saveMatchEdits(match.id)}
                                draggable={false}
                                className="p-1.5 rounded-lg bg-green-500/10 text-green-400 hover:bg-green-500/20"
                              >
                                <Save size={14} />
                              </button>
                            )}
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            ))}
        </div>
      )}

      <AdminModal
        isOpen={showTeamManagerModal}
        onClose={() => !applyingTeamChange && setShowTeamManagerModal(false)}
        title="Druzyny w trakcie sezonu"
        darkMode={darkMode}
        xwide
      >
        <div className="space-y-4">
          <div className={`rounded-xl border p-3 text-sm ${card}`}>
            Ta operacja przebudowuje przyszly terminarz od wskazanej kolejki. Od tej kolejki wzwyz wszystkie mecze musza byc nadal edytowalne.
            Sugerowany start zmian dla tej ligi: <strong>Kolejka {suggestedStructureRound}</strong>.
          </div>

          {hasPendingEdits && (
            <div className={`rounded-xl border p-3 text-sm ${darkMode ? "border-yellow-500/30 bg-yellow-500/10 text-yellow-200" : "border-yellow-200 bg-yellow-50 text-yellow-900"}`}>
              Masz niezapisane reczne zmiany terminow meczow. Zapisz je albo odswiez liste przed przebudowa ligi.
            </div>
          )}

          <div className="grid grid-cols-1 xl:grid-cols-[1.15fr_0.85fr] gap-4">
            <div className={`rounded-xl border p-4 ${card}`}>
              <div className="flex items-center justify-between gap-3 mb-3">
                <div>
                  <h4 className="font-semibold">Aktualne druzyny ligi</h4>
                  <p className={`text-xs mt-1 ${textMuted}`}>{selectedLeagueMeta?.name || "Wybrana liga"}</p>
                </div>
                {loadingLeagueTeams && <Loader2 size={16} className="animate-spin" />}
              </div>

              <div className="space-y-2 max-h-[28rem] overflow-y-auto">
                {leagueSeasonTeams
                  .slice()
                  .sort((left, right) => getLeagueSeasonTeamName(left).localeCompare(getLeagueSeasonTeamName(right), "pl"))
                  .map((seasonTeam) => {
                    const isCurrentlyActive = isSeasonTeamActiveOnRound(
                      seasonTeam,
                      Number(removeFromRound) || suggestedStructureRound
                    );

                    return (
                      <div
                        key={seasonTeam.id || seasonTeam.team_id}
                        className={`rounded-xl border px-3 py-2.5 ${
                          darkMode ? "border-white/10 bg-white/[0.03]" : "border-gray-200 bg-gray-50"
                        }`}
                      >
                        <div className="flex items-center justify-between gap-3">
                          <div className="min-w-0">
                            <div className="text-sm font-semibold truncate">{getLeagueSeasonTeamName(seasonTeam)}</div>
                            <div className={`text-xs mt-1 ${textMuted}`}>
                              {seasonTeam.joined_round > 1
                                ? `Dolacza od kolejki ${seasonTeam.joined_round}.`
                                : "Gra od poczatku sezonu."}
                              {seasonTeam.left_round
                                ? ` Nie gra od kolejki ${seasonTeam.left_round}.`
                                : " Nadal aktywna."}
                            </div>
                          </div>
                          <span
                            className={`px-2 py-1 rounded-full text-[11px] font-semibold ${
                              isCurrentlyActive
                                ? darkMode
                                  ? "bg-green-500/15 text-green-300"
                                  : "bg-green-100 text-green-700"
                                : darkMode
                                  ? "bg-white/10 text-gray-300"
                                  : "bg-gray-200 text-gray-700"
                            }`}
                          >
                            {isCurrentlyActive ? "Aktywna" : "Poza liga"}
                          </span>
                        </div>
                      </div>
                    );
                  })}

                {!loadingLeagueTeams && leagueSeasonTeams.length === 0 && (
                  <div className={`rounded-xl border px-3 py-6 text-sm text-center ${card}`}>
                    Brak przypisanych druzyn w tym sezonie.
                  </div>
                )}
              </div>
            </div>

            <div className="space-y-4">
              <div className={`rounded-xl border p-4 ${card}`}>
                <h4 className="font-semibold mb-3">Wycofaj druzyne</h4>
                <div className="grid grid-cols-1 gap-3">
                  <AdminFormField
                    label="Druzyna"
                    name="remove_team"
                    type="select"
                    value={removeTeamId}
                    onChange={(event) => setRemoveTeamId(event.target.value)}
                    darkMode={darkMode}
                    options={activeTeamsAtRemoveRound
                      .slice()
                      .sort((left, right) => getLeagueSeasonTeamName(left).localeCompare(getLeagueSeasonTeamName(right), "pl"))
                      .map((seasonTeam) => ({
                        value: seasonTeam.team_id,
                        label: getLeagueSeasonTeamName(seasonTeam),
                      }))}
                  />
                  <AdminFormField
                    label="Nie gra od kolejki"
                    name="remove_round"
                    type="number"
                    value={removeFromRound}
                    onChange={(event) => setRemoveFromRound(event.target.value)}
                    darkMode={darkMode}
                    min={1}
                    max={Math.max(highestRound + 1, suggestedStructureRound)}
                  />
                </div>

                <button
                  type="button"
                  onClick={() => applyLeagueTeamChange("remove")}
                  disabled={applyingTeamChange || loadingLeagueTeams}
                  className="mt-4 w-full px-4 py-2.5 rounded-xl bg-red-500 text-white text-sm font-semibold hover:bg-red-400 disabled:opacity-50"
                >
                  {applyingTeamChange ? "Przebudowuje lige..." : "Wycofaj i przebuduj terminarz"}
                </button>
              </div>

              <div className={`rounded-xl border p-4 ${card}`}>
                <h4 className="font-semibold mb-3">Dodaj nowa druzyne</h4>
                <div className="grid grid-cols-1 gap-3">
                  <AdminFormField
                    label="Druzyna"
                    name="add_team"
                    type="select"
                    value={addTeamId}
                    onChange={(event) => setAddTeamId(event.target.value)}
                    darkMode={darkMode}
                    options={availableTeamsForAddition.map((team) => ({
                      value: team.id,
                      label: team.name,
                    }))}
                  />
                  <AdminFormField
                    label="Gra od kolejki"
                    name="add_round"
                    type="number"
                    value={addFromRound}
                    onChange={(event) => setAddFromRound(event.target.value)}
                    darkMode={darkMode}
                    min={1}
                    max={Math.max(highestRound + 1, suggestedStructureRound)}
                  />
                </div>

                <button
                  type="button"
                  onClick={() => applyLeagueTeamChange("add")}
                  disabled={applyingTeamChange || loadingLeagueTeams || availableTeamsForAddition.length === 0}
                  className="mt-4 w-full px-4 py-2.5 rounded-xl bg-green-500 text-white text-sm font-semibold hover:bg-green-400 disabled:opacity-50"
                >
                  {applyingTeamChange ? "Przebudowuje lige..." : "Dodaj i przebuduj terminarz"}
                </button>

                {availableTeamsForAddition.length === 0 && (
                  <p className={`text-xs mt-3 ${textMuted}`}>
                    Wszystkie aktywne druzyny sa juz przypisane do tego sezonu.
                  </p>
                )}
              </div>
            </div>
          </div>
        </div>
      </AdminModal>

      <AdminModal
        isOpen={showRoundSwapModal}
        onClose={() => !swappingRounds && setShowRoundSwapModal(false)}
        title="Zamien terminy kolejek"
        darkMode={darkMode}
        xwide
      >
        <div className="space-y-4">
          <div className={`rounded-xl border p-3 text-sm ${card}`}>
            Przeciagnij kafelek kolejki na inny kafelek, aby podmienic ich terminy. Numery kolejek i pary meczowe zostaja bez zmian.
          </div>

          {hasPendingEdits && (
            <div className={`rounded-xl border p-3 text-sm ${darkMode ? "border-yellow-500/30 bg-yellow-500/10 text-yellow-200" : "border-yellow-200 bg-yellow-50 text-yellow-900"}`}>
              Najpierw zapisz reczne zmiany dat i godzin, a dopiero potem zamieniaj cale kolejki.
            </div>
          )}

          <div className="flex flex-wrap gap-2">
            <button
              type="button"
              onClick={() => setRoundSwapScope("league")}
              className={`px-4 py-2 rounded-xl text-sm font-semibold transition-colors ${
                roundSwapScope === "league"
                  ? "bg-cyan-500 text-white"
                  : darkMode
                    ? "bg-white/5 text-gray-200 hover:bg-white/10"
                    : "bg-gray-100 text-gray-700 hover:bg-gray-200"
              }`}
            >
              Tylko ta liga
            </button>
            <button
              type="button"
              onClick={() => setRoundSwapScope("global")}
              className={`px-4 py-2 rounded-xl text-sm font-semibold transition-colors ${
                roundSwapScope === "global"
                  ? "bg-cyan-500 text-white"
                  : darkMode
                    ? "bg-white/5 text-gray-200 hover:bg-white/10"
                    : "bg-gray-100 text-gray-700 hover:bg-gray-200"
              }`}
            >
              Globalnie w sezonie
            </button>
          </div>

          <div className={`rounded-xl border p-3 text-sm ${card}`}>
            {roundSwapScope === "league"
              ? `Zamiana dotyczy tylko ligi ${selectedLeagueMeta?.name || ""}.`
              : "Zamiana dotyczy tych samych numerow kolejek we wszystkich ligach sezonu. Ligi z rozegranymi meczami w tych kolejkach zostana pominiete."}
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-3">
            {roundSwapTiles.map((tile) => {
              const isDragged = String(draggedRoundNumber) === String(tile.round);
              const isDropTarget = String(dropTargetRoundNumber) === String(tile.round);
              const isDisabled = swappingRounds || (roundSwapScope === "league" && tile.isLocked);

              return (
                <div
                  key={tile.round}
                  draggable={!isDisabled}
                  onDragStart={(event) => handleRoundDragStart(event, tile.round)}
                  onDragOver={(event) => handleRoundDragOver(event, tile.round)}
                  onDrop={(event) => handleRoundDrop(event, tile.round)}
                  onDragEnd={handleRoundDragEnd}
                  className={`rounded-2xl border p-4 transition-all ${
                    darkMode ? "bg-white/[0.03] border-white/10" : "bg-white border-gray-200"
                  } ${
                    isDisabled ? "opacity-60 cursor-not-allowed" : "cursor-grab active:cursor-grabbing"
                  } ${
                    isDragged ? "scale-[0.99] opacity-60" : ""
                  } ${
                    isDropTarget
                      ? darkMode
                        ? "border-cyan-400 bg-cyan-500/10 shadow-[0_0_0_1px_rgba(34,211,238,0.45)]"
                        : "border-cyan-500 bg-cyan-50 shadow-[0_0_0_1px_rgba(6,182,212,0.28)]"
                      : ""
                  }`}
                >
                  <div className="flex items-start justify-between gap-3">
                    <div>
                      <div className="text-base font-bold">Kolejka {tile.round}</div>
                      <div className={`text-xs mt-1 ${textMuted}`}>{formatRoundWindowLabel(tile)}</div>
                    </div>
                    <div
                      className={`px-2 py-1 rounded-full text-[11px] font-semibold ${
                        tile.isLocked
                          ? darkMode
                            ? "bg-amber-500/15 text-amber-300"
                            : "bg-amber-100 text-amber-800"
                          : darkMode
                            ? "bg-cyan-500/10 text-cyan-300"
                            : "bg-cyan-100 text-cyan-800"
                      }`}
                    >
                      {tile.isLocked ? "Zablokowana" : "Edytowalna"}
                    </div>
                  </div>

                  <div className="mt-4 flex items-center justify-between gap-3">
                    <div className={`text-sm ${textMuted}`}>{tile.matchCount} mecz{tile.matchCount === 1 ? "" : tile.matchCount < 5 ? "e" : "ow"}</div>
                    <div className={`flex items-center gap-2 text-xs font-medium ${darkMode ? "text-cyan-300" : "text-cyan-700"}`}>
                      <GripVertical size={16} />
                      Przeciagnij na inna kolejke
                    </div>
                  </div>
                </div>
              );
            })}
          </div>

          {roundSwapTiles.length < 2 && (
            <div className={`rounded-xl border p-3 text-sm ${card}`}>
              Ta liga ma za malo kolejek do zamiany.
            </div>
          )}

          <div className="flex flex-wrap justify-end gap-3">
            <button
              type="button"
              onClick={() => setShowRoundSwapModal(false)}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} ${darkMode ? "hover:bg-white/5" : "hover:bg-gray-100"}`}
              disabled={swappingRounds}
            >
              Anuluj
            </button>
            {swappingRounds && (
              <div className={`px-4 py-2 rounded-xl text-sm font-semibold ${darkMode ? "bg-cyan-500/10 text-cyan-300" : "bg-cyan-50 text-cyan-800"}`}>
                Zamieniam kolejki...
              </div>
            )}
          </div>
        </div>
      </AdminModal>

      <AdminModal
        isOpen={showReshuffleModal}
        onClose={() => !regeneratingFuture && setShowReshuffleModal(false)}
        title="Przetasuj przyszle kolejki"
        darkMode={darkMode}
        wide
      >
        <div className="space-y-4">
          <div className={`rounded-xl border p-3 text-sm ${card}`}>
            Daty i godziny zostaja na swoich miejscach. Tu wpisujesz dodatkowe uwagi, ktore maja wplynac tylko na nierozegrane kolejki tej ligi.
          </div>

          <div>
            <label className="text-sm font-medium block mb-2">Uwagi do przetasowania</label>
            <textarea
              value={reshuffleNotes}
              onChange={(e) => setReshuffleNotes(e.target.value)}
              rows={5}
              placeholder={"Przyklady:\nFC Faworyt w pierwszej kolejce moze grac tylko w niedziele\nStarszaki nie moga grac z Rebeliantami w drugiej kolejce\nChaos Team jesli ma grac w niedziele to jak najpozniejsza godzina"}
              className={`w-full px-4 py-3 rounded-2xl border text-sm outline-none resize-y ${
                darkMode ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500" : "bg-white border-gray-300 text-gray-900 placeholder:text-gray-400"
              }`}
            />
          </div>

          {parsedReshuffleLabels.length > 0 && (
            <div>
              <div className="flex items-center gap-2 text-sm font-semibold mb-2">
                <MessageSquareText size={16} />
                Rozpoznane wytyczne
              </div>
              <div className="flex flex-wrap gap-2">
                {parsedReshuffleLabels.map((label, index) => (
                  <span
                    key={`${label}-${index}`}
                    className={`px-2.5 py-1 rounded-lg text-xs ${
                      darkMode ? "bg-cyan-500/10 text-cyan-300" : "bg-cyan-100 text-cyan-800"
                    }`}
                  >
                    {label}
                  </span>
                ))}
              </div>
            </div>
          )}

          {parsedReshuffleGuidelines.warnings.length > 0 && (
            <div className={`rounded-xl border p-3 text-xs ${darkMode ? "border-yellow-500/20 bg-yellow-500/10 text-yellow-200" : "border-yellow-200 bg-yellow-50 text-yellow-900"}`}>
              <div className="font-semibold mb-2">Tego jeszcze nie rozpoznalem:</div>
              <div className="space-y-1">
                {parsedReshuffleGuidelines.warnings.map((warning, index) => (
                  <div key={`${warning}-${index}`}>{warning}</div>
                ))}
              </div>
            </div>
          )}

          <div className="flex justify-end gap-3">
            <button
              type="button"
              onClick={() => setShowReshuffleModal(false)}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} ${darkMode ? "hover:bg-white/5" : "hover:bg-gray-100"}`}
              disabled={regeneratingFuture}
            >
              Anuluj
            </button>
            <button
              type="button"
              onClick={confirmRegenerateFutureRounds}
              disabled={regeneratingFuture}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-cyan-500 text-white text-sm font-semibold hover:bg-cyan-400 disabled:opacity-50"
            >
              {regeneratingFuture ? <Loader2 size={14} className="animate-spin" /> : <RefreshCw size={14} />}
              {regeneratingFuture ? "Przetasowuje..." : "Przetasuj"}
            </button>
          </div>
        </div>
      </AdminModal>
    </div>
  );
}
