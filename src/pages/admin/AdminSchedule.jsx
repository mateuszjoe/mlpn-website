import React, { useState, useEffect, useCallback, useMemo } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminModal from "./components/AdminModal";
import AdminAlert from "./components/AdminAlert";
import { Calendar, Zap, Save, RefreshCw, Loader2, MessageSquareText } from "lucide-react";
import {
  buildSafeRegenerationBatches,
  buildRegenerationPlan,
  formatLockedRounds,
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

export default function AdminSchedule({ darkMode }) {
  const [seasons, setSeasons] = useState([]);
  const [leagues, setLeagues] = useState([]);
  const [matches, setMatches] = useState([]);
  const [selectedSeason, setSelectedSeason] = useState("");
  const [selectedLeague, setSelectedLeague] = useState("");
  const [loading, setLoading] = useState(true);
  const [generating, setGenerating] = useState(false);
  const [alert, setAlert] = useState({ type: null, message: null });
  const [startDate, setStartDate] = useState("");
  const [editedMatches, setEditedMatches] = useState({});
  const [regeneratingFuture, setRegeneratingFuture] = useState(false);
  const [showReshuffleModal, setShowReshuffleModal] = useState(false);
  const [reshuffleNotes, setReshuffleNotes] = useState("");

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

    setAlert({ type: "success", message: "Mecz zaktualizowany." });
    setEditedMatches((prev) => {
      const next = { ...prev };
      delete next[matchId];
      return next;
    });
    loadMatches();
  }

  const rounds = {};
  matches.forEach((match) => {
    if (!rounds[match.round]) rounds[match.round] = [];
    rounds[match.round].push(match);
  });

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
            <button
              onClick={openReshuffleModal}
              disabled={regeneratingFuture}
              className="flex items-center gap-2 px-3 py-2 rounded-xl bg-cyan-500/10 text-cyan-400 text-sm hover:bg-cyan-500/20 disabled:opacity-50"
            >
              {regeneratingFuture ? <Loader2 size={14} className="animate-spin" /> : <RefreshCw size={14} />}
              Przetasuj przyszle kolejki
            </button>
          </div>

          <div className={`rounded-2xl border px-4 py-3 text-sm ${card}`}>
            Ta opcja nie rusza rozegranych kolejek. Automatycznie blokuje tez odpowiadajace im kolejki rewanzowe,
            a przyszle mecze uklada w juz istniejacych datach i godzinach tej ligi.
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

                    return (
                      <div key={match.id} className="px-4 py-3 flex items-center gap-3 flex-wrap">
                        <div className="flex-1 min-w-[200px]">
                          <span className="font-medium">{match.home_team_name}</span>
                          <span className={`mx-2 ${textMuted}`}>vs</span>
                          <span className="font-medium">{match.away_team_name}</span>
                        </div>

                        <input
                          type="date"
                          value={edits.match_date ?? match.match_date ?? ""}
                          onChange={(e) => handleMatchEdit(match.id, "match_date", e.target.value)}
                          className={`px-2 py-1 rounded-lg border text-sm w-36 ${
                            darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-200"
                          }`}
                        />
                        <input
                          type="time"
                          value={edits.match_time ?? match.match_time ?? ""}
                          onChange={(e) => handleMatchEdit(match.id, "match_time", e.target.value)}
                          className={`px-2 py-1 rounded-lg border text-sm w-24 ${
                            darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-200"
                          }`}
                        />
                        <span className={`text-xs ${textMuted}`}>{statusLabels[match.status] || match.status}</span>

                        {hasEdits && (
                          <button
                            onClick={() => saveMatchEdits(match.id)}
                            className="p-1.5 rounded-lg bg-green-500/10 text-green-400 hover:bg-green-500/20"
                          >
                            <Save size={14} />
                          </button>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            ))}
        </div>
      )}

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
