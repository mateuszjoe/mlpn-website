import React, { useState, useEffect, useCallback } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminModal from "./components/AdminModal";
import AdminAlert from "./components/AdminAlert";
import { Plus, UserMinus, Shield, Star } from "lucide-react";

export default function AdminRosters({ darkMode }) {
  const [seasons, setSeasons] = useState([]);
  const [leagues, setLeagues] = useState([]);
  const [seasonTeams, setSeasonTeams] = useState([]);
  const [roster, setRoster] = useState([]);
  const [allPlayers, setAllPlayers] = useState([]);
  const [allTeams, setAllTeams] = useState([]);
  const [selectedSeason, setSelectedSeason] = useState("");
  const [selectedLeague, setSelectedLeague] = useState("");
  const [selectedTeam, setSelectedTeam] = useState("");
  const [loading, setLoading] = useState(true);
  const [alert, setAlert] = useState({ type: null, message: null });
  const [showAddPlayer, setShowAddPlayer] = useState(false);
  const [showAddTeam, setShowAddTeam] = useState(false);
  const [playerSearch, setPlayerSearch] = useState("");
  const [addForm, setAddForm] = useState({ player_id: "", shirt_number: "", is_captain: false, joined_date: new Date().toISOString().split("T")[0] });

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const loadBase = useCallback(async () => {
    const [{ data: s }, { data: l }, { data: p }, { data: t }] = await Promise.all([
      supabase.from("seasons").select("*").order("year", { ascending: false }),
      supabase.from("leagues").select("*").order("display_order"),
      supabase.from("players").select("id, first_name, last_name, display_name, position").eq("is_active", true).order("last_name"),
      supabase.from("teams").select("id, name, abbreviation").eq("is_active", true).order("name"),
    ]);
    setSeasons(s || []);
    setLeagues(l || []);
    setAllPlayers(p || []);
    setAllTeams(t || []);
    if (s?.length) setSelectedSeason(s[0].id);
    if (l?.length) setSelectedLeague(l[0].id);
    setLoading(false);
  }, []);

  useEffect(() => { loadBase(); }, [loadBase]);

  useEffect(() => {
    if (selectedSeason && selectedLeague) loadSeasonTeams();
  }, [selectedSeason, selectedLeague]);

  useEffect(() => {
    if (selectedTeam && selectedSeason && selectedLeague) loadRoster();
  }, [selectedTeam, selectedSeason, selectedLeague]);

  async function loadSeasonTeams() {
    const { data } = await supabase
      .from("season_teams")
      .select("*, teams(id, name, abbreviation, logo_url)")
      .eq("season_id", selectedSeason)
      .eq("league_id", selectedLeague)
      .order("teams(name)");
    setSeasonTeams(data || []);
    setSelectedTeam("");
    setRoster([]);
  }

  async function loadRoster() {
    const { data } = await supabase
      .from("team_players")
      .select("*, players(id, first_name, last_name, display_name, position)")
      .eq("team_id", selectedTeam)
      .eq("season_id", selectedSeason)
      .eq("league_id", selectedLeague)
      .is("left_date", null)
      .order("players(last_name)");
    setRoster(data || []);
  }

  async function addTeamToSeason(teamId) {
    const { error } = await supabase.from("season_teams").insert({
      season_id: selectedSeason,
      league_id: selectedLeague,
      team_id: teamId,
    });
    if (error) {
      setAlert({ type: "error", message: error.message });
    } else {
      setAlert({ type: "success", message: "Drużyna dodana do ligi" });
      loadSeasonTeams();
    }
  }

  async function removeTeamFromSeason(stId) {
    if (!window.confirm("Usunąć drużynę z tej ligi?")) return;
    const { error } = await supabase.from("season_teams").delete().eq("id", stId);
    if (error) {
      setAlert({ type: "error", message: error.message });
    } else {
      setAlert({ type: "success", message: "Drużyna usunięta z ligi" });
      loadSeasonTeams();
    }
  }

  async function addPlayerToRoster() {
    if (!addForm.player_id) return;
    const { error } = await supabase.from("team_players").insert({
      team_id: selectedTeam,
      player_id: addForm.player_id,
      season_id: selectedSeason,
      league_id: selectedLeague,
      joined_date: addForm.joined_date,
      shirt_number: addForm.shirt_number ? parseInt(addForm.shirt_number) : null,
      is_captain: addForm.is_captain,
    });
    if (error) {
      setAlert({ type: "error", message: error.message });
    } else {
      setAlert({ type: "success", message: "Zawodnik dodany do kadry" });
      setShowAddPlayer(false);
      setAddForm({ player_id: "", shirt_number: "", is_captain: false, joined_date: new Date().toISOString().split("T")[0] });
      loadRoster();
    }
  }

  async function removeFromRoster(id) {
    if (!window.confirm("Usunąć zawodnika z kadry?")) return;
    await supabase.from("team_players").update({ left_date: new Date().toISOString().split("T")[0] }).eq("id", id);
    setAlert({ type: "success", message: "Zawodnik usunięty z kadry" });
    loadRoster();
  }

  async function toggleCaptain(id, current) {
    await supabase.from("team_players").update({ is_captain: !current }).eq("id", id);
    loadRoster();
  }

  const rosterPlayerIds = new Set(roster.map(r => r.player_id));
  const availablePlayers = allPlayers.filter(p =>
    !rosterPlayerIds.has(p.id) &&
    (playerSearch ? `${p.first_name} ${p.last_name}`.toLowerCase().includes(playerSearch.toLowerCase()) : true)
  );

  const teamsInSeason = new Set(seasonTeams.map(st => st.team_id));
  const availableTeams = allTeams.filter(t => !teamsInSeason.has(t.id));

  const posLabels = { BR: "BR", OBR: "OBR", POM: "POM", NAP: "NAP" };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-2 border-yellow-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold">Kadry drużyn</h2>

      <AdminAlert type={alert.type} message={alert.message} onClose={() => setAlert({ type: null, message: null })} />

      {/* Filters */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <AdminFormField label="Sezon" name="season" type="select" value={selectedSeason}
          onChange={e => setSelectedSeason(e.target.value)} darkMode={darkMode}
          options={seasons.map(s => ({ value: s.id, label: s.name }))} />
        <AdminFormField label="Liga" name="league" type="select" value={selectedLeague}
          onChange={e => setSelectedLeague(e.target.value)} darkMode={darkMode}
          options={leagues.map(l => ({ value: l.id, label: l.name }))} />
        <AdminFormField label="Drużyna" name="team" type="select" value={selectedTeam}
          onChange={e => setSelectedTeam(e.target.value)} darkMode={darkMode}
          options={seasonTeams.map(st => ({ value: st.teams?.id, label: st.teams?.name }))} />
      </div>

      {/* Teams in season */}
      <div className={`rounded-2xl border p-4 ${card}`}>
        <div className="flex items-center justify-between mb-3">
          <h3 className="font-semibold flex items-center gap-2"><Shield size={16} /> Drużyny w lidze ({seasonTeams.length})</h3>
          <button onClick={() => setShowAddTeam(true)} className="flex items-center gap-1 text-xs text-blue-400 hover:text-blue-300">
            <Plus size={14} /> Dodaj drużynę do ligi
          </button>
        </div>
        <div className="flex flex-wrap gap-2">
          {seasonTeams.map(st => (
            <div key={st.id} className={`flex items-center gap-2 px-3 py-1.5 rounded-xl border text-sm ${
              selectedTeam === st.teams?.id ? "border-yellow-500/50 bg-yellow-500/10" : darkMode ? "border-white/10" : "border-gray-200"
            }`}>
              <button onClick={() => setSelectedTeam(st.teams?.id)} className="font-medium">{st.teams?.name}</button>
              <button onClick={() => removeTeamFromSeason(st.id)} className="text-red-400 hover:text-red-300 ml-1" title="Usuń z ligi">
                <UserMinus size={14} />
              </button>
            </div>
          ))}
          {seasonTeams.length === 0 && <p className={`text-sm ${textMuted}`}>Brak drużyn - dodaj je do ligi</p>}
        </div>
      </div>

      {/* Roster */}
      {selectedTeam && (
        <div className={`rounded-2xl border p-4 ${card}`}>
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold">Kadra ({roster.length} zawodników)</h3>
            <button onClick={() => { setPlayerSearch(""); setShowAddPlayer(true); }}
              className="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-yellow-500 text-black font-medium text-sm hover:bg-yellow-400">
              <Plus size={14} /> Dodaj zawodnika
            </button>
          </div>
          <div className="space-y-2">
            {roster.map(r => (
              <div key={r.id} className={`flex items-center justify-between px-3 py-2 rounded-xl border ${darkMode ? "border-white/5" : "border-gray-100"}`}>
                <div className="flex items-center gap-3">
                  <span className={`text-xs font-mono w-6 text-center ${textMuted}`}>{r.shirt_number || "—"}</span>
                  <span className="font-medium">{r.players?.display_name}</span>
                  <span className={`text-xs px-1.5 py-0.5 rounded ${darkMode ? "bg-white/10" : "bg-gray-100"}`}>{posLabels[r.players?.position]}</span>
                  {r.is_captain && <Star size={14} className="text-yellow-400" />}
                </div>
                <div className="flex items-center gap-2">
                  <button onClick={() => toggleCaptain(r.id, r.is_captain)} className={`text-xs ${r.is_captain ? "text-yellow-400" : textMuted} hover:text-yellow-400`}>
                    {r.is_captain ? "Kapitan" : "Kapitan?"}
                  </button>
                  <button onClick={() => removeFromRoster(r.id)} className="text-red-400 hover:text-red-300">
                    <UserMinus size={14} />
                  </button>
                </div>
              </div>
            ))}
            {roster.length === 0 && <p className={`text-sm text-center py-4 ${textMuted}`}>Brak zawodników w kadrze</p>}
          </div>
        </div>
      )}

      {/* Add team modal */}
      <AdminModal isOpen={showAddTeam} onClose={() => setShowAddTeam(false)} title="Dodaj drużynę do ligi" darkMode={darkMode}>
        <div className="space-y-2 max-h-60 overflow-y-auto">
          {availableTeams.map(t => (
            <button key={t.id} onClick={() => { addTeamToSeason(t.id); setShowAddTeam(false); }}
              className={`w-full text-left px-3 py-2 rounded-xl border ${darkMode ? "border-white/10 hover:bg-white/5" : "border-gray-200 hover:bg-gray-50"}`}>
              <span className="font-medium">{t.name}</span> <span className={`text-xs ${textMuted}`}>({t.abbreviation})</span>
            </button>
          ))}
          {availableTeams.length === 0 && <p className={`text-sm text-center py-4 ${textMuted}`}>Wszystkie drużyny są już w lidze</p>}
        </div>
      </AdminModal>

      {/* Add player modal */}
      <AdminModal isOpen={showAddPlayer} onClose={() => setShowAddPlayer(false)} title="Dodaj zawodnika do kadry" darkMode={darkMode}>
        <div className="space-y-4">
          <input type="text" value={playerSearch} onChange={e => setPlayerSearch(e.target.value)}
            placeholder="Szukaj zawodnika..."
            className={`w-full px-3 py-2 rounded-xl border outline-none ${
              darkMode ? "bg-white/5 border-white/10 text-white placeholder-gray-500" : "bg-white border-gray-300"
            }`}
          />
          <div className="max-h-40 overflow-y-auto space-y-1">
            {availablePlayers.slice(0, 20).map(p => (
              <button key={p.id} onClick={() => setAddForm(f => ({ ...f, player_id: p.id }))}
                className={`w-full text-left px-3 py-2 rounded-xl text-sm ${
                  addForm.player_id === p.id
                    ? "bg-yellow-500/10 border border-yellow-500/50"
                    : darkMode ? "hover:bg-white/5" : "hover:bg-gray-50"
                }`}>
                {p.display_name} <span className={`text-xs ${textMuted}`}>({posLabels[p.position]})</span>
              </button>
            ))}
          </div>
          <div className="grid grid-cols-2 gap-4">
            <AdminFormField label="Numer" name="shirt_number" type="number" value={addForm.shirt_number}
              onChange={e => setAddForm(f => ({ ...f, shirt_number: e.target.value }))} darkMode={darkMode} min={1} max={99} />
            <AdminFormField label="Data dołączenia" name="joined_date" type="date" value={addForm.joined_date}
              onChange={e => setAddForm(f => ({ ...f, joined_date: e.target.value }))} darkMode={darkMode} />
          </div>
          <AdminFormField label="Kapitan" name="is_captain" type="checkbox" value={addForm.is_captain}
            onChange={e => setAddForm(f => ({ ...f, is_captain: e.target.value }))} darkMode={darkMode} />
          <div className="flex justify-end gap-3">
            <button onClick={() => setShowAddPlayer(false)} className={`px-4 py-2 rounded-xl text-sm ${textMuted}`}>Anuluj</button>
            <button onClick={addPlayerToRoster} disabled={!addForm.player_id}
              className="px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium text-sm hover:bg-yellow-400 disabled:opacity-50">
              Dodaj do kadry
            </button>
          </div>
        </div>
      </AdminModal>
    </div>
  );
}
