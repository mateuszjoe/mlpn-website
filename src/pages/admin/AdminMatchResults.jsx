import React, { useState, useEffect, useCallback } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminAlert from "./components/AdminAlert";
import { ChevronDown, ChevronUp, Plus, Trash2, Save } from "lucide-react";

export default function AdminMatchResults({ darkMode }) {
  const [seasons, setSeasons] = useState([]);
  const [leagues, setLeagues] = useState([]);
  const [matches, setMatches] = useState([]);
  const [selectedSeason, setSelectedSeason] = useState("");
  const [selectedLeague, setSelectedLeague] = useState("");
  const [selectedRound, setSelectedRound] = useState("");
  const [expandedMatch, setExpandedMatch] = useState(null);
  const [matchEvents, setMatchEvents] = useState([]);
  const [homeRoster, setHomeRoster] = useState([]);
  const [awayRoster, setAwayRoster] = useState([]);
  const [loading, setLoading] = useState(true);
  const [alert, setAlert] = useState({ type: null, message: null });
  const [scoreForm, setScoreForm] = useState({});
  const [newEvent, setNewEvent] = useState({ event_type: "GOAL", team_id: "", player_id: "", assist_player_id: "", minute: "", is_penalty: false, is_own_goal: false });

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const loadBase = useCallback(async () => {
    const [{ data: s }, { data: l }] = await Promise.all([
      supabase.from("seasons").select("*").order("year", { ascending: false }),
      supabase.from("leagues").select("*").order("display_order"),
    ]);
    setSeasons(s || []);
    setLeagues(l || []);
    if (s?.length) setSelectedSeason(s[0].id);
    if (l?.length) setSelectedLeague(l[0].id);
    setLoading(false);
  }, []);

  useEffect(() => { loadBase(); }, [loadBase]);

  useEffect(() => {
    if (selectedSeason && selectedLeague) loadMatches();
  }, [selectedSeason, selectedLeague, selectedRound]);

  async function loadMatches() {
    let query = supabase
      .from("v_matches")
      .select("*")
      .eq("season_id", selectedSeason)
      .eq("league_id", selectedLeague)
      .order("round")
      .order("match_date");
    if (selectedRound) query = query.eq("round", parseInt(selectedRound));
    const { data } = await query;
    setMatches(data || []);
  }

  async function expandMatch(match) {
    if (expandedMatch === match.id) {
      setExpandedMatch(null);
      return;
    }
    setExpandedMatch(match.id);
    const rawStatus = match.status || "scheduled";
    const isWalkover = rawStatus === "walkover_home" || rawStatus === "walkover_away";
    setScoreForm({
      home_goals: match.home_goals ?? "",
      away_goals: match.away_goals ?? "",
      status: isWalkover ? "walkover" : rawStatus,
      walkover_winner: rawStatus === "walkover_away" ? "away" : "home",
      referee: match.referee || "",
      video_url: match.video_url || "",
    });

    // Load events and rosters
    const [{ data: events }, { data: hr }, { data: ar }] = await Promise.all([
      supabase.from("match_events")
        .select("*, players(display_name)")
        .eq("match_id", match.id)
        .order("minute")
        .order("event_order"),
      supabase.from("team_players")
        .select("player_id, players(id, display_name, position)")
        .eq("team_id", match.home_team_id)
        .eq("season_id", match.season_id)
        .eq("league_id", match.league_id)
        .is("left_date", null),
      supabase.from("team_players")
        .select("player_id, players(id, display_name, position)")
        .eq("team_id", match.away_team_id)
        .eq("season_id", match.season_id)
        .eq("league_id", match.league_id)
        .is("left_date", null),
    ]);
    setMatchEvents(events || []);
    setHomeRoster(hr || []);
    setAwayRoster(ar || []);
    setNewEvent({ event_type: "GOAL", team_id: match.home_team_id, player_id: "", assist_player_id: "", minute: "", is_penalty: false, is_own_goal: false });
  }

  async function saveScore(matchId) {
    const resolvedStatus = scoreForm.status === "walkover"
      ? (scoreForm.walkover_winner === "away" ? "walkover_away" : "walkover_home")
      : scoreForm.status;

    const noScoreStatuses = new Set(["scheduled", "postponed", "cancelled", "unplayed"]);
    let homeGoals = scoreForm.home_goals !== "" ? parseInt(scoreForm.home_goals) : null;
    let awayGoals = scoreForm.away_goals !== "" ? parseInt(scoreForm.away_goals) : null;

    if (resolvedStatus === "walkover_home") {
      homeGoals = Number.isFinite(homeGoals) ? homeGoals : 3;
      awayGoals = Number.isFinite(awayGoals) ? awayGoals : 0;
    } else if (resolvedStatus === "walkover_away") {
      homeGoals = Number.isFinite(homeGoals) ? homeGoals : 0;
      awayGoals = Number.isFinite(awayGoals) ? awayGoals : 3;
    } else if (noScoreStatuses.has(resolvedStatus)) {
      homeGoals = null;
      awayGoals = null;
    }

    const payload = {
      home_goals: homeGoals,
      away_goals: awayGoals,
      status: resolvedStatus,
      referee: scoreForm.referee || null,
      video_url: scoreForm.video_url || null,
    };
    const { error } = await supabase.from("matches").update(payload).eq("id", matchId);
    if (error) {
      setAlert({ type: "error", message: error.message });
    } else {
      setAlert({ type: "success", message: "Wynik zapisany! Tabela przeliczona automatycznie." });
      loadMatches();
    }
  }

  async function addEvent(matchId, match) {
    if (!newEvent.player_id || !newEvent.team_id) {
      setAlert({ type: "error", message: "Wybierz druzyne i zawodnika" });
      return;
    }
    const { error } = await supabase.from("match_events").insert({
      match_id: matchId,
      event_type: newEvent.event_type,
      team_id: newEvent.team_id,
      player_id: newEvent.player_id,
      assist_player_id: newEvent.assist_player_id || null,
      minute: newEvent.minute ? parseInt(newEvent.minute) : null,
      is_penalty: newEvent.is_penalty,
      is_own_goal: newEvent.is_own_goal,
    });
    if (error) {
      setAlert({ type: "error", message: error.message });
    } else {
      setAlert({ type: "success", message: "Zdarzenie dodane" });
      expandMatch(match); // reload events
      setNewEvent(prev => ({ ...prev, player_id: "", assist_player_id: "", minute: "" }));
    }
  }

  async function deleteEvent(eventId, match) {
    if (!window.confirm("Usunac zdarzenie?")) return;
    await supabase.from("match_events").delete().eq("id", eventId);
    setAlert({ type: "success", message: "Zdarzenie usuniete" });
    expandMatch(match);
  }

  const currentRoster = newEvent.team_id
    ? (matches.find(m => m.id === expandedMatch)?.home_team_id === newEvent.team_id ? homeRoster : awayRoster)
    : [];

  // Czy wybrany sezon pozwala na edycję wyników?
  const selectedSeasonObj = seasons.find(s => s.id === selectedSeason);
  const isEditable = selectedSeasonObj?.status === "active";

  const maxRound = matches.length > 0 ? Math.max(...matches.map(m => m.round)) : 0;
  const roundOptions = Array.from({ length: maxRound }, (_, i) => ({ value: String(i + 1), label: `Kolejka ${i + 1}` }));

  const eventTypeLabels = { GOAL: "Gol", YELLOW_CARD: "Żółta kartka", RED_CARD: "Czerwona kartka" };
  const eventTypeColors = { GOAL: "text-green-400", YELLOW_CARD: "text-yellow-400", RED_CARD: "text-red-400" };
  const statusLabel = (status) => (
    status === "completed" ? "Zakończony" :
    status === "walkover_home" ? "Walkower (gosp.)" :
    status === "walkover_away" ? "Walkower (gosc)" :
    status === "postponed" ? "Przełożony" :
    status === "cancelled" ? "Odwołany" :
    status === "unplayed" ? "Nierozegrany" :
    "Zaplanowany"
  );

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-2 border-yellow-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold">Wyniki meczów</h2>

      <AdminAlert type={alert.type} message={alert.message} onClose={() => setAlert({ type: null, message: null })} />

      {/* Filters */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <AdminFormField label="Sezon" name="season" type="select" value={selectedSeason}
          onChange={e => setSelectedSeason(e.target.value)} darkMode={darkMode}
          options={seasons.map(s => ({ value: s.id, label: s.name }))} />
        <AdminFormField label="Liga" name="league" type="select" value={selectedLeague}
          onChange={e => setSelectedLeague(e.target.value)} darkMode={darkMode}
          options={leagues.map(l => ({ value: l.id, label: l.name }))} />
        <AdminFormField label="Kolejka" name="round" type="select" value={selectedRound}
          onChange={e => setSelectedRound(e.target.value)} darkMode={darkMode}
          options={[{ value: "", label: "Wszystkie" }, ...roundOptions]} />
      </div>

      {/* Non-editable warning */}
      {!isEditable && selectedSeasonObj && (
        <div className={`rounded-xl border p-3 text-sm ${darkMode ? "border-orange-500/30 bg-orange-500/10 text-orange-300" : "border-orange-200 bg-orange-50 text-orange-800"}`}>
          Sezon „{selectedSeasonObj.name}" ma status <strong>{selectedSeasonObj.status === "planned" ? "planowany" : selectedSeasonObj.status === "completed" ? "zakończony" : selectedSeasonObj.status}</strong> — edycja wyników niedostępna. Tylko aktywne sezony można edytować.
        </div>
      )}

      {/* Matches */}
      {matches.length === 0 ? (
        <div className={`rounded-2xl border p-8 text-center ${card}`}>
          <p className={textMuted}>Brak meczów. Wygeneruj terminarz w zakladce "Terminarz".</p>
        </div>
      ) : (
        <div className="space-y-3">
          {matches.map(m => (
            <div key={m.id} className={`rounded-2xl border overflow-hidden ${card}`}>
              {/* Match header */}
              <button
                onClick={() => expandMatch(m)}
                className="w-full px-4 py-3 flex items-center justify-between hover:bg-white/5 transition-colors"
              >
                <div className="flex items-center gap-3">
                  <span className={`text-xs ${textMuted} w-8`}>K{m.round}</span>
                  <span className="font-medium">{m.home_team_name}</span>
                  {m.status === "completed" || m.status?.startsWith("walkover") ? (
                    <span className="font-bold text-lg px-2">{m.home_goals} : {m.away_goals}</span>
                  ) : (
                    <span className={`px-2 ${textMuted}`}>vs</span>
                  )}
                  <span className="font-medium">{m.away_team_name}</span>
                </div>
                <div className="flex items-center gap-2">
                  <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${
                    m.status === "completed" ? "bg-green-500/20 text-green-400" :
                    m.status?.startsWith("walkover") ? "bg-orange-500/20 text-orange-400" :
                    m.status === "postponed" ? "bg-blue-500/20 text-blue-400" :
                    m.status === "cancelled" ? "bg-red-500/20 text-red-400" :
                    m.status === "unplayed" ? "bg-slate-500/20 text-slate-300" :
                    `${darkMode ? "bg-white/10 text-gray-400" : "bg-gray-100 text-gray-500"}`
                  }`}>{statusLabel(m.status)}</span>
                  <span className={`text-xs ${textMuted}`}>{m.match_date || "—"}</span>
                  {expandedMatch === m.id ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
                </div>
              </button>

              {/* Expanded edit section */}
              {expandedMatch === m.id && (
                <div className={`border-t px-4 py-4 space-y-4 ${darkMode ? "border-white/10" : "border-gray-200"}`}>
                  {/* Score form */}
                  {isEditable ? (
                  <div className="grid grid-cols-2 md:grid-cols-6 gap-3 items-end">
                    <AdminFormField label={`Bramki ${m.home_team_abbr}`} name="home_goals" type="number" value={scoreForm.home_goals}
                      onChange={e => setScoreForm(f => ({ ...f, home_goals: e.target.value }))} darkMode={darkMode} min={0} />
                    <AdminFormField label={`Bramki ${m.away_team_abbr}`} name="away_goals" type="number" value={scoreForm.away_goals}
                      onChange={e => setScoreForm(f => ({ ...f, away_goals: e.target.value }))} darkMode={darkMode} min={0} />
                    <AdminFormField label="Status" name="status" type="select" value={scoreForm.status}
                      onChange={e => {
                        const v = e.target.value;
                        setScoreForm(f => {
                          const next = { ...f, status: v };
                          if (v === "walkover") {
                            const winner = next.walkover_winner || "home";
                            next.walkover_winner = winner;
                            next.home_goals = winner === "home" ? 3 : 0;
                            next.away_goals = winner === "away" ? 3 : 0;
                          }
                          if (["scheduled", "postponed", "cancelled", "unplayed"].includes(v)) {
                            next.home_goals = "";
                            next.away_goals = "";
                          }
                          return next;
                        });
                      }} darkMode={darkMode}
                      options={[
                        { value: "scheduled", label: "Zaplanowany" },
                        { value: "completed", label: "Zakończony" },
                        { value: "walkover", label: "Walkower" },
                        { value: "postponed", label: "Przełożony" },
                        { value: "cancelled", label: "Odwołany" },
                        { value: "unplayed", label: "Nierozegrany" },
                      ]}
                    />
                    {scoreForm.status === "walkover" && (
                      <AdminFormField label="Wygral walkowerem" name="walkover_winner" type="select" value={scoreForm.walkover_winner || "home"}
                        onChange={e => {
                          const winner = e.target.value;
                          setScoreForm(f => ({
                            ...f,
                            walkover_winner: winner,
                            home_goals: winner === "home" ? 3 : 0,
                            away_goals: winner === "away" ? 3 : 0,
                          }));
                        }} darkMode={darkMode}
                        options={[
                          { value: "home", label: m.home_team_name },
                          { value: "away", label: m.away_team_name },
                        ]}
                      />
                    )}
                    <AdminFormField label="Sedzia" name="referee" value={scoreForm.referee}
                      onChange={e => setScoreForm(f => ({ ...f, referee: e.target.value }))} darkMode={darkMode} />
                    <button onClick={() => saveScore(m.id)}
                      className="flex items-center justify-center gap-2 px-4 py-2 rounded-xl bg-green-500 text-black font-medium text-sm hover:bg-green-400 h-[42px]">
                      <Save size={14} /> Zapisz wynik
                    </button>
                  </div>
                  ) : (
                  <div className={`flex items-center gap-4 text-sm py-1 ${textMuted}`}>
                    <span>Wynik: <strong className={darkMode ? "text-white" : "text-gray-900"}>{m.home_goals ?? "—"} : {m.away_goals ?? "—"}</strong></span>
                    <span>Status: {statusLabel(m.status)}</span>
                    {m.referee && <span>Sedzia: {m.referee}</span>}
                  </div>
                  )}

                  {/* Events list */}
                  <div>
                    <h4 className="font-semibold text-sm mb-2">Zdarzenia ({matchEvents.length})</h4>
                    {matchEvents.length > 0 && (
                      <div className="space-y-1 mb-3">
                        {matchEvents.map(ev => (
                          <div key={ev.id} className={`flex items-center justify-between px-3 py-1.5 rounded-lg text-sm ${darkMode ? "bg-white/5" : "bg-gray-50"}`}>
                            <div className="flex items-center gap-2">
                              <span className={`font-medium ${eventTypeColors[ev.event_type]}`}>
                                {ev.minute != null ? `${ev.minute}'` : "—"}
                              </span>
                              <span className={eventTypeColors[ev.event_type]}>{eventTypeLabels[ev.event_type]}</span>
                              <span>{ev.players?.display_name}</span>
                              {ev.is_penalty && <span className={`text-xs ${textMuted}`}>(karny)</span>}
                              {ev.is_own_goal && <span className={`text-xs ${textMuted}`}>(samobój)</span>}
                            </div>
                            {isEditable && (
                              <button onClick={() => deleteEvent(ev.id, m)} className="text-red-400 hover:text-red-300">
                                <Trash2 size={14} />
                              </button>
                            )}
                          </div>
                        ))}
                      </div>
                    )}

                    {/* Add event form */}
                    {isEditable && (
                    <div className={`p-3 rounded-xl border ${darkMode ? "border-white/10" : "border-gray-200"}`}>
                      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 items-end">
                        <AdminFormField label="Typ" name="event_type" type="select" value={newEvent.event_type}
                          onChange={e => setNewEvent(f => ({ ...f, event_type: e.target.value }))} darkMode={darkMode}
                          options={[
                            { value: "GOAL", label: "Gol" },
                            { value: "YELLOW_CARD", label: "Żółta kartka" },
                            { value: "RED_CARD", label: "Czerwona kartka" },
                          ]}
                        />
                        <AdminFormField label="Druzyna" name="team_id" type="select" value={newEvent.team_id}
                          onChange={e => setNewEvent(f => ({ ...f, team_id: e.target.value, player_id: "", assist_player_id: "" }))} darkMode={darkMode}
                          options={[
                            { value: m.home_team_id, label: m.home_team_name },
                            { value: m.away_team_id, label: m.away_team_name },
                          ]}
                        />
                        <AdminFormField label="Zawodnik" name="player_id" type="select" value={newEvent.player_id}
                          onChange={e => setNewEvent(f => ({ ...f, player_id: e.target.value }))} darkMode={darkMode}
                          options={currentRoster.map(r => ({ value: r.players?.id, label: r.players?.display_name }))}
                        />
                        <AdminFormField label="Minuta" name="minute" type="number" value={newEvent.minute}
                          onChange={e => setNewEvent(f => ({ ...f, minute: e.target.value }))} darkMode={darkMode} min={0} max={120} />
                      </div>
                      {newEvent.event_type === "GOAL" && (
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mt-3 items-end">
                          <AdminFormField label="Asystent" name="assist_player_id" type="select" value={newEvent.assist_player_id}
                            onChange={e => setNewEvent(f => ({ ...f, assist_player_id: e.target.value }))} darkMode={darkMode}
                            options={currentRoster.filter(r => r.players?.id !== newEvent.player_id).map(r => ({ value: r.players?.id, label: r.players?.display_name }))}
                          />
                          <AdminFormField label="Karny" name="is_penalty" type="checkbox" value={newEvent.is_penalty}
                            onChange={e => setNewEvent(f => ({ ...f, is_penalty: e.target.value }))} darkMode={darkMode} />
                          <AdminFormField label="Samoboj" name="is_own_goal" type="checkbox" value={newEvent.is_own_goal}
                            onChange={e => setNewEvent(f => ({ ...f, is_own_goal: e.target.value }))} darkMode={darkMode} />
                        </div>
                      )}
                      <div className="mt-3">
                        <button onClick={() => addEvent(m.id, m)}
                          className="flex items-center gap-2 px-4 py-2 rounded-xl bg-blue-500/10 text-blue-400 text-sm hover:bg-blue-500/20">
                          <Plus size={14} /> Dodaj zdarzenie
                        </button>
                      </div>
                    </div>
                    )}
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
