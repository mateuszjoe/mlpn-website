import React, { useState, useEffect, useCallback } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminAlert from "./components/AdminAlert";
import { Calendar, Zap, Save } from "lucide-react";

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

  async function handleGenerate() {
    if (!startDate) {
      setAlert({ type: "error", message: "Wybierz datę startu" });
      return;
    }
    if (matches.length > 0) {
      if (!window.confirm("Terminarz już istnieje! Wygenerować od nowa? (stary zostanie usunięty)")) return;
      await supabase.from("matches").delete()
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
      setAlert({ type: "error", message: "Błąd generowania: " + error.message });
      setGenerating(false);
      return;
    }

    // Initialize standings
    await supabase.rpc("initialize_standings", {
      p_season_id: selectedSeason,
      p_league_id: selectedLeague,
    });

    setAlert({ type: "success", message: `Terminarz wygenerowany! ${data?.matches_created || ""} meczow w ${data?.rounds_total || ""} kolejkach.` });
    setGenerating(false);
    loadMatches();
  }

  function handleMatchEdit(matchId, field, value) {
    setEditedMatches(prev => ({
      ...prev,
      [matchId]: { ...prev[matchId], [field]: value },
    }));
  }

  async function saveMatchEdits(matchId) {
    const edits = editedMatches[matchId];
    if (!edits) return;
    const { error } = await supabase.from("matches").update(edits).eq("id", matchId);
    if (error) {
      setAlert({ type: "error", message: error.message });
    } else {
      setAlert({ type: "success", message: "Mecz zaktualizowany" });
      setEditedMatches(prev => { const copy = { ...prev }; delete copy[matchId]; return copy; });
      loadMatches();
    }
  }

  // Group matches by round
  const rounds = {};
  matches.forEach(m => {
    if (!rounds[m.round]) rounds[m.round] = [];
    rounds[m.round].push(m);
  });

  const statusLabels = {
    scheduled: "Zaplanowany",
    live: "W trakcie",
    completed: "Zakonczony",
    walkover_home: "Walkover (gosp.)",
    walkover_away: "Walkover (gosc)",
    postponed: "Przełożony",
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

      <AdminAlert type={alert.type} message={alert.message} onClose={() => setAlert({ type: null, message: null })} />

      {/* Filters */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <AdminFormField label="Sezon" name="season" type="select" value={selectedSeason}
          onChange={e => setSelectedSeason(e.target.value)} darkMode={darkMode}
          options={seasons.map(s => ({ value: s.id, label: s.name }))} />
        <AdminFormField label="Liga" name="league" type="select" value={selectedLeague}
          onChange={e => setSelectedLeague(e.target.value)} darkMode={darkMode}
          options={leagues.map(l => ({ value: l.id, label: l.name }))} />
      </div>

      {/* Generate section */}
      {matches.length === 0 ? (
        <div className={`rounded-2xl border p-6 text-center ${card}`}>
          <Calendar size={48} className={`mx-auto mb-4 ${textMuted}`} />
          <h3 className="text-lg font-bold mb-2">Brak terminarza</h3>
          <p className={`text-sm mb-4 ${textMuted}`}>Wygeneruj terminarz round-robin dla tej ligi.</p>
          <div className="flex items-center justify-center gap-4 flex-wrap">
            <input type="date" value={startDate} onChange={e => setStartDate(e.target.value)}
              className={`px-3 py-2 rounded-xl border outline-none ${
                darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-300"
              }`}
            />
            <button onClick={handleGenerate} disabled={generating}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 disabled:opacity-50">
              <Zap size={16} /> {generating ? "Generowanie..." : "Generuj terminarz"}
            </button>
          </div>
        </div>
      ) : (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <p className={`text-sm ${textMuted}`}>{matches.length} meczow w {Object.keys(rounds).length} kolejkach</p>
            <div className="flex items-center gap-3">
              <input type="date" value={startDate} onChange={e => setStartDate(e.target.value)}
                className={`px-3 py-2 rounded-xl border outline-none text-sm ${
                  darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-300"
                }`}
              />
              <button onClick={handleGenerate} disabled={generating}
                className="flex items-center gap-2 px-3 py-2 rounded-xl bg-red-500/10 text-red-400 text-sm hover:bg-red-500/20">
                <Zap size={14} /> Generuj od nowa
              </button>
            </div>
          </div>

          {/* Matches by round */}
          {Object.entries(rounds).sort(([a], [b]) => a - b).map(([roundNum, roundMatches]) => (
            <div key={roundNum} className={`rounded-2xl border overflow-hidden ${card}`}>
              <div className={`px-4 py-2 font-semibold text-sm ${darkMode ? "bg-white/5" : "bg-gray-50"}`}>
                Kolejka {roundNum}
              </div>
              <div className="divide-y" style={{ borderColor: darkMode ? "rgba(255,255,255,0.05)" : "rgba(0,0,0,0.05)" }}>
                {roundMatches.map(m => {
                  const edits = editedMatches[m.id] || {};
                  const hasEdits = Object.keys(edits).length > 0;
                  return (
                    <div key={m.id} className="px-4 py-3 flex items-center gap-3 flex-wrap">
                      <div className="flex-1 min-w-[200px]">
                        <span className="font-medium">{m.home_team_name}</span>
                        <span className={`mx-2 ${textMuted}`}>vs</span>
                        <span className="font-medium">{m.away_team_name}</span>
                      </div>
                      <input type="date"
                        value={edits.match_date ?? m.match_date ?? ""}
                        onChange={e => handleMatchEdit(m.id, "match_date", e.target.value)}
                        className={`px-2 py-1 rounded-lg border text-sm w-36 ${
                          darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-200"
                        }`}
                      />
                      <input type="time"
                        value={edits.match_time ?? m.match_time ?? ""}
                        onChange={e => handleMatchEdit(m.id, "match_time", e.target.value)}
                        className={`px-2 py-1 rounded-lg border text-sm w-24 ${
                          darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-200"
                        }`}
                      />
                      <span className={`text-xs ${textMuted}`}>{statusLabels[m.status] || m.status}</span>
                      {hasEdits && (
                        <button onClick={() => saveMatchEdits(m.id)}
                          className="p-1.5 rounded-lg bg-green-500/10 text-green-400 hover:bg-green-500/20">
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
    </div>
  );
}
