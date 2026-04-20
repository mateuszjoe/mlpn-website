import React, { useState, useEffect, useCallback } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminModal from "./components/AdminModal";
import AdminAlert from "./components/AdminAlert";
import { Plus, UserMinus, Shield, Star, Copy, Loader2, Pencil } from "lucide-react";

const ADMIN_PAGE_SIZE = 1000;
const defaultJoinDate = () => new Date().toISOString().split("T")[0];
const defaultAddForm = () => ({ player_id: "", shirt_number: "", is_captain: false, joined_date: defaultJoinDate() });
const defaultNewPlayerForm = () => ({
  first_name: "",
  last_name: "",
  position: "POM",
  birth_year: "",
  preferred_foot: "",
  city: "",
  is_active: true,
});
const defaultEditPlayerForm = () => ({
  first_name: "",
  last_name: "",
  position: "POM",
  birth_year: "",
  preferred_foot: "",
  city: "",
  is_active: true,
  shirt_number: "",
  joined_date: "",
  is_captain: false,
});

async function fetchAllAdminRows(queryFactory, pageSize = ADMIN_PAGE_SIZE) {
  const rows = [];
  let from = 0;

  while (true) {
    const to = from + pageSize - 1;
    const { data, error } = await queryFactory(from, to);
    if (error) throw error;

    const chunk = data || [];
    rows.push(...chunk);

    if (chunk.length < pageSize) break;
    from += pageSize;
  }

  return rows;
}

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
  const [showCreatePlayer, setShowCreatePlayer] = useState(false);
  const [showEditPlayer, setShowEditPlayer] = useState(false);
  const [showAddTeam, setShowAddTeam] = useState(false);
  const [playerSearch, setPlayerSearch] = useState("");
  const [addForm, setAddForm] = useState(defaultAddForm);
  const [newPlayerForm, setNewPlayerForm] = useState(defaultNewPlayerForm);
  const [editPlayerForm, setEditPlayerForm] = useState(defaultEditPlayerForm);
  const [editingRosterRow, setEditingRosterRow] = useState(null);
  const [creatingPlayer, setCreatingPlayer] = useState(false);
  const [savingPlayerEdit, setSavingPlayerEdit] = useState(false);
  const [copyingRosters, setCopyingRosters] = useState(false);

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const loadBase = useCallback(async () => {
    try {
      const [{ data: s }, { data: l }, playersRows, { data: t }] = await Promise.all([
        supabase.from("seasons").select("*").order("year", { ascending: false }),
        supabase.from("leagues").select("*").order("display_order"),
        fetchAllAdminRows((from, to) =>
          supabase
            .from("players")
            .select("id, first_name, last_name, display_name, position, birth_year, preferred_foot, city, is_active")
            .eq("is_active", true)
            .order("last_name")
            .order("id")
            .range(from, to)
        ),
        supabase.from("teams").select("id, name, abbreviation").eq("is_active", true).order("name"),
      ]);

      setSeasons(s || []);
      setLeagues(l || []);
      setAllPlayers(playersRows || []);
      setAllTeams(t || []);
      if (s?.length) setSelectedSeason(s[0].id);
      if (l?.length) setSelectedLeague(l[0].id);
    } catch (error) {
      console.error("Nie udało się wczytać danych kadr:", error);
      setAlert({ type: "error", message: "Nie udało się wczytać pełnej listy zawodników." });
    } finally {
      setLoading(false);
    }
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
      .select("*, players(id, first_name, last_name, display_name, position, birth_year, preferred_foot, city, is_active)")
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

    const rosterEntry = {
      team_id: selectedTeam,
      player_id: addForm.player_id,
      season_id: selectedSeason,
      league_id: selectedLeague,
      joined_date: addForm.joined_date,
      left_date: null,
      shirt_number: addForm.shirt_number ? parseInt(addForm.shirt_number) : null,
      is_captain: addForm.is_captain,
    };

    const { error } = await supabase
      .from("team_players")
      .upsert(rosterEntry, { onConflict: "player_id,season_id,league_id,team_id" });

    if (error) {
      setAlert({ type: "error", message: error.message });
    } else {
      setAlert({ type: "success", message: "Zawodnik dodany lub przywrócony do kadry" });
      setShowAddPlayer(false);
      setAddForm(defaultAddForm());
      setPlayerSearch("");
      loadRoster();
    }
  }

  async function createPlayerFromRoster() {
    const firstName = newPlayerForm.first_name.trim();
    const lastName = newPlayerForm.last_name.trim();

    if (!firstName || !lastName) {
      setAlert({ type: "error", message: "Podaj imię i nazwisko nowego zawodnika." });
      return;
    }

    setCreatingPlayer(true);
    try {
      const payload = {
        first_name: firstName,
        last_name: lastName,
        position: newPlayerForm.position,
        birth_year: newPlayerForm.birth_year ? parseInt(newPlayerForm.birth_year, 10) : null,
        preferred_foot: newPlayerForm.preferred_foot || null,
        city: newPlayerForm.city?.trim() || null,
        is_active: newPlayerForm.is_active,
      };

      const { data, error } = await supabase
        .from("players")
        .insert(payload)
        .select("id, first_name, last_name, display_name, position, birth_year, preferred_foot, city, is_active")
        .single();

      if (error) throw error;

      const createdPlayer = {
        ...data,
        display_name: data.display_name || `${data.first_name || ""} ${data.last_name || ""}`.trim(),
      };

      setAllPlayers((prev) =>
        [...prev, createdPlayer].sort((a, b) =>
          String(a.last_name || "").localeCompare(String(b.last_name || ""), "pl") ||
          String(a.first_name || "").localeCompare(String(b.first_name || ""), "pl") ||
          String(a.id).localeCompare(String(b.id))
        )
      );
      setAddForm((prev) => ({ ...prev, player_id: createdPlayer.id }));
      setPlayerSearch(createdPlayer.display_name);
      setShowCreatePlayer(false);
      setNewPlayerForm(defaultNewPlayerForm());
      setAlert({ type: "success", message: "Nowy zawodnik został dodany do bazy. Możesz go teraz dodać do kadry." });
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się dodać zawodnika do bazy." });
    } finally {
      setCreatingPlayer(false);
    }
  }

  function openEditPlayerFromRoster(row) {
    const player = Array.isArray(row.players) ? row.players[0] : row.players;
    if (!player?.id) {
      setAlert({ type: "error", message: "Brak danych zawodnika do edycji." });
      return;
    }

    setEditingRosterRow(row);
    setEditPlayerForm({
      first_name: player.first_name || "",
      last_name: player.last_name || "",
      position: player.position || "POM",
      birth_year: player.birth_year || "",
      preferred_foot: player.preferred_foot || "",
      city: player.city || "",
      is_active: player.is_active !== false,
      shirt_number: row.shirt_number || "",
      joined_date: row.joined_date || "",
      is_captain: !!row.is_captain,
    });
    setShowEditPlayer(true);
  }

  function handleEditPlayerChange(e) {
    const { name, value } = e.target;
    setEditPlayerForm((form) => ({ ...form, [name]: value }));
  }

  async function saveEditedRosterPlayer(e) {
    e.preventDefault();
    if (!editingRosterRow?.id || !editingRosterRow?.player_id) return;

    const firstName = editPlayerForm.first_name.trim();
    const lastName = editPlayerForm.last_name.trim();
    if (!firstName || !lastName) {
      setAlert({ type: "error", message: "Podaj imię i nazwisko zawodnika." });
      return;
    }

    const shirtNumber =
      editPlayerForm.shirt_number === "" || editPlayerForm.shirt_number === null
        ? null
        : Number.parseInt(editPlayerForm.shirt_number, 10);

    if (shirtNumber !== null && (!Number.isFinite(shirtNumber) || shirtNumber < 1 || shirtNumber > 99)) {
      setAlert({ type: "error", message: "Numer zawodnika musi być w zakresie 1-99." });
      return;
    }

    setSavingPlayerEdit(true);
    try {
      const playerPayload = {
        first_name: firstName,
        last_name: lastName,
        position: editPlayerForm.position || "POM",
        birth_year: editPlayerForm.birth_year ? Number.parseInt(editPlayerForm.birth_year, 10) : null,
        preferred_foot: editPlayerForm.preferred_foot || null,
        city: editPlayerForm.city?.trim() || null,
        is_active: editPlayerForm.is_active,
      };

      const rosterPayload = {
        shirt_number: shirtNumber,
        joined_date: editPlayerForm.joined_date || null,
        is_captain: !!editPlayerForm.is_captain,
      };

      const { data: savedPlayer, error: playerError } = await supabase
        .from("players")
        .update(playerPayload)
        .eq("id", editingRosterRow.player_id)
        .select("id, first_name, last_name, display_name, position, birth_year, preferred_foot, city, is_active")
        .single();

      if (playerError) throw playerError;

      const { error: rosterError } = await supabase
        .from("team_players")
        .update(rosterPayload)
        .eq("id", editingRosterRow.id);

      if (rosterError) throw rosterError;

      setAllPlayers((prev) => {
        const normalizedPlayer = {
          ...savedPlayer,
          display_name:
            savedPlayer.display_name ||
            `${savedPlayer.first_name || ""} ${savedPlayer.last_name || ""}`.trim(),
        };

        const next = normalizedPlayer.is_active
          ? [
              ...prev.filter((player) => player.id !== normalizedPlayer.id),
              normalizedPlayer,
            ]
          : prev.filter((player) => player.id !== normalizedPlayer.id);

        return next.sort((a, b) =>
          String(a.last_name || "").localeCompare(String(b.last_name || ""), "pl") ||
          String(a.first_name || "").localeCompare(String(b.first_name || ""), "pl") ||
          String(a.id).localeCompare(String(b.id))
        );
      });

      setAlert({ type: "success", message: "Dane zawodnika z kadry zostały zaktualizowane." });
      setShowEditPlayer(false);
      setEditingRosterRow(null);
      setEditPlayerForm(defaultEditPlayerForm());
      await loadRoster();
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się zaktualizować zawodnika." });
    } finally {
      setSavingPlayerEdit(false);
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

  async function copyRostersFromPreviousSeason() {
    if (!selectedSeason || !selectedLeague) return;

    const currentSeason = seasons.find(s => s.id === selectedSeason);
    const currentTeamIds = seasonTeams.map(st => st.team_id).filter(Boolean);
    if (!currentSeason) return;

    // Find previous season (one year back)
    const prevSeason = seasons.find(s => s.year === currentSeason.year - 1);
    if (!prevSeason) {
      setAlert({ type: "error", message: `Nie znaleziono poprzedniego sezonu (${currentSeason.year - 1}).` });
      return;
    }
    if (currentTeamIds.length === 0) {
      setAlert({ type: "error", message: "Brak druzyn przypisanych do tej ligi w biezacym sezonie." });
      return;
    }

    if (!window.confirm(
      `Skopiować kadry wszystkich drużyn z sezonu ${prevSeason.name || prevSeason.year} do ${currentSeason.name || currentSeason.year}?\n\n` +
      `Zostaną skopiowani aktywni zawodnicy (bez left_date) ze wszystkich drużyn w tej lidze. ` +
      `Zawodnicy którzy już są w kadrze nowego sezonu nie zostaną zduplikowani.`
    )) return;

    setCopyingRosters(true);
    try {
      // Copy previous-season rosters by team_id so promoted/relegated teams are included too.
      const { data: prevRosters, error: prevErr } = await supabase
        .from("team_players")
        .select("player_id, team_id, shirt_number, is_captain, players(is_active)")
        .eq("season_id", prevSeason.id)
        .in("team_id", currentTeamIds)
        .is("left_date", null);

      if (prevErr) throw prevErr;
      if (!prevRosters || prevRosters.length === 0) {
        setAlert({ type: "error", message: `Brak zawodników w kadrach sezonu ${prevSeason.name || prevSeason.year}.` });
        setCopyingRosters(false);
        return;
      }

      // Filter only active players.
      const activePrev = prevRosters.filter(r => {
        const playerObj = Array.isArray(r.players) ? r.players[0] : r.players;
        return playerObj?.is_active !== false;
      });

      if (activePrev.length === 0) {
        setAlert({ type: "error", message: "Brak aktywnych zawodników do skopiowania (sprawdź czy drużyny są dodane do nowej ligi)." });
        setCopyingRosters(false);
        return;
      }

      // Get existing team_players in new season to avoid duplicates
      const { data: existingNew } = await supabase
        .from("team_players")
        .select("player_id, team_id")
        .eq("season_id", selectedSeason)
        .eq("league_id", selectedLeague);

      const existingSet = new Set((existingNew || []).map(r => `${r.player_id}|${r.team_id}`));

      const toInsert = activePrev
        .filter(r => !existingSet.has(`${r.player_id}|${r.team_id}`))
        .map(r => ({
          player_id: r.player_id,
          team_id: r.team_id,
          season_id: selectedSeason,
          league_id: selectedLeague,
          shirt_number: r.shirt_number,
          is_captain: r.is_captain,
          joined_date: new Date().toISOString().split("T")[0],
        }));

      if (toInsert.length === 0) {
        setAlert({ type: "info", message: "Wszystkie kadry są już skopiowane - nie ma nowych zawodników do dodania." });
        setCopyingRosters(false);
        return;
      }

      const { error: insertErr } = await supabase.from("team_players").insert(toInsert);
      if (insertErr) throw insertErr;

      setAlert({
        type: "success",
        message: `Skopiowano ${toInsert.length} zawodników z sezonu ${prevSeason.name || prevSeason.year}. Teraz możesz zaktualizować składy - kogo trzeba zwolnij, kogo trzeba dodaj.`,
      });
      loadRoster();
    } catch (err) {
      setAlert({ type: "error", message: err.message || "Nie udało się skopiować kadr." });
    } finally {
      setCopyingRosters(false);
    }
  }

  const rosterPlayerIds = new Set(roster.map(r => r.player_id));
  const availablePlayers = allPlayers.filter(p =>
    !rosterPlayerIds.has(p.id) &&
    (playerSearch ? `${p.first_name} ${p.last_name}`.toLowerCase().includes(playerSearch.toLowerCase()) : true)
  );

  const teamsInSeason = new Set(seasonTeams.map(st => st.team_id));
  const availableTeams = allTeams.filter(t => !teamsInSeason.has(t.id));

  const posLabels = { BR: "BR", OBR: "OBR", POM: "POM", NAP: "NAP" };
  const noAvailablePlayers = availablePlayers.length === 0;
  const canCreatePlayerFromSearch = playerSearch.trim().length > 0 && noAvailablePlayers;

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

      {/* Copy rosters from previous season */}
      {selectedSeason && selectedLeague && seasonTeams.length > 0 && (
        <div className={`rounded-2xl border p-4 ${darkMode ? "border-blue-500/20 bg-blue-500/5" : "border-blue-200 bg-blue-50"}`}>
          <div className="flex items-center justify-between gap-4 flex-wrap">
            <div>
              <div className="text-sm font-medium">Nowy sezon?</div>
              <div className={`text-xs ${textMuted}`}>
                Skopiuj kadry wszystkich drużyn z poprzedniego sezonu. Potem zaktualizuj kto odszedł, kto doszedł.
              </div>
            </div>
            <button
              onClick={copyRostersFromPreviousSeason}
              disabled={copyingRosters}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-blue-500 text-white font-medium text-sm hover:bg-blue-400 disabled:opacity-50"
            >
              {copyingRosters ? <Loader2 size={16} className="animate-spin" /> : <Copy size={16} />}
              Kopiuj kadry z poprzedniego sezonu
            </button>
          </div>
        </div>
      )}

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
            <button onClick={() => { setPlayerSearch(""); setAddForm(defaultAddForm()); setShowAddPlayer(true); }}
              className="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-yellow-500 text-black font-medium text-sm hover:bg-yellow-400">
              <Plus size={14} /> Dodaj zawodnika
            </button>
          </div>
          <div className="space-y-2">
            {roster.map(r => (
              <div key={r.id} className={`flex flex-col gap-3 px-3 py-3 rounded-xl border sm:flex-row sm:items-center sm:justify-between ${darkMode ? "border-white/5" : "border-gray-100"}`}>
                <div className="flex min-w-0 items-center gap-3">
                  <span className={`shrink-0 text-xs font-mono w-8 text-center ${textMuted}`}>{r.shirt_number || "—"}</span>
                  <div className="min-w-0">
                    <div className="font-medium truncate">{r.players?.display_name}</div>
                    <div className={`mt-1 flex flex-wrap items-center gap-2 text-xs ${textMuted}`}>
                      <span className={`px-1.5 py-0.5 rounded ${darkMode ? "bg-white/10 text-gray-200" : "bg-gray-100 text-gray-700"}`}>{posLabels[r.players?.position] || r.players?.position || "Pozycja?"}</span>
                      {r.players?.birth_year && <span>Rocznik {r.players.birth_year}</span>}
                      {r.players?.preferred_foot && <span>{r.players.preferred_foot}</span>}
                      {r.is_captain && <span className="inline-flex items-center gap-1 text-yellow-400"><Star size={13} /> Kapitan</span>}
                    </div>
                  </div>
                </div>
                <div className="flex flex-wrap items-center justify-end gap-2">
                  <button onClick={() => toggleCaptain(r.id, r.is_captain)} className={`text-xs ${r.is_captain ? "text-yellow-400" : textMuted} hover:text-yellow-400`}>
                    {r.is_captain ? "Kapitan" : "Kapitan?"}
                  </button>
                  <button
                    type="button"
                    onClick={() => openEditPlayerFromRoster(r)}
                    className="inline-flex items-center gap-1 rounded-lg px-2 py-1 text-xs text-blue-400 hover:bg-blue-500/10 hover:text-blue-300"
                    title="Edytuj zawodnika"
                  >
                    <Pencil size={13} /> Edytuj
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
            {noAvailablePlayers && (
              <div className={`px-3 py-3 text-sm text-center rounded-xl ${darkMode ? "bg-white/5 text-gray-400" : "bg-gray-50 text-gray-500"}`}>
                Brak zawodnika w wynikach wyszukiwania.
              </div>
            )}
          </div>
          {canCreatePlayerFromSearch && <div className={`rounded-xl border p-3 ${darkMode ? "border-blue-500/20 bg-blue-500/5" : "border-blue-200 bg-blue-50"}`}>
            <div className="flex items-center justify-between gap-3 flex-wrap">
              <div>
                <div className="text-sm font-medium">Nie ma go w bazie?</div>
                <div className={`text-xs ${textMuted}`}>
                  Dodaj nowego zawodnika bez wychodzenia z uzupełniania kadry.
                </div>
              </div>
              <button
                type="button"
                onClick={() => {
                  const [firstName = "", ...lastNameParts] = playerSearch.trim().split(/\s+/).filter(Boolean);
                  setNewPlayerForm({
                    ...defaultNewPlayerForm(),
                    first_name: firstName || "",
                    last_name: lastNameParts.join(" "),
                  });
                  setShowCreatePlayer(true);
                }}
                className="flex items-center gap-2 px-3 py-2 rounded-xl bg-blue-500 text-white font-medium text-sm hover:bg-blue-400"
              >
                <Plus size={14} /> Dodaj nowego zawodnika do bazy
              </button>
            </div>
          </div>}
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

      <AdminModal
        isOpen={showEditPlayer}
        onClose={() => {
          setShowEditPlayer(false);
          setEditingRosterRow(null);
          setEditPlayerForm(defaultEditPlayerForm());
        }}
        title="Edytuj zawodnika z kadry"
        darkMode={darkMode}
        wide
      >
        <form onSubmit={saveEditedRosterPlayer} className="space-y-4">
          <div className={`rounded-xl border p-3 text-sm ${darkMode ? "border-blue-500/20 bg-blue-500/5 text-gray-300" : "border-blue-200 bg-blue-50 text-gray-700"}`}>
            Zmieniasz dane zawodnika bezpośrednio z aktualnej kadry. Pozycja, imię, nazwisko i dane podstawowe zapisują się w bazie zawodników, a numer/kapitan/data dotyczą tej konkretnej kadry.
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <AdminFormField
              label="Imię"
              name="first_name"
              value={editPlayerForm.first_name}
              onChange={handleEditPlayerChange}
              required
              darkMode={darkMode}
            />
            <AdminFormField
              label="Nazwisko"
              name="last_name"
              value={editPlayerForm.last_name}
              onChange={handleEditPlayerChange}
              required
              darkMode={darkMode}
            />
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <AdminFormField
              label="Pozycja"
              name="position"
              type="select"
              value={editPlayerForm.position}
              onChange={handleEditPlayerChange}
              required
              darkMode={darkMode}
              options={[
                { value: "BR", label: "Bramkarz" },
                { value: "OBR", label: "Obrońca" },
                { value: "POM", label: "Pomocnik" },
                { value: "NAP", label: "Napastnik" },
              ]}
            />
            <AdminFormField
              label="Rocznik"
              name="birth_year"
              type="number"
              value={editPlayerForm.birth_year}
              onChange={handleEditPlayerChange}
              darkMode={darkMode}
              min={1960}
              max={2015}
            />
            <AdminFormField
              label="Noga"
              name="preferred_foot"
              type="select"
              value={editPlayerForm.preferred_foot}
              onChange={handleEditPlayerChange}
              darkMode={darkMode}
              options={[
                { value: "Prawa", label: "Prawa" },
                { value: "Lewa", label: "Lewa" },
                { value: "Obie", label: "Obie" },
              ]}
            />
          </div>

          <AdminFormField
            label="Miasto"
            name="city"
            value={editPlayerForm.city}
            onChange={handleEditPlayerChange}
            darkMode={darkMode}
          />

          <div className={`rounded-xl border p-4 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
            <div className="mb-3 text-sm font-semibold">Dane w tej kadrze</div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <AdminFormField
                label="Numer"
                name="shirt_number"
                type="number"
                value={editPlayerForm.shirt_number}
                onChange={handleEditPlayerChange}
                darkMode={darkMode}
                min={1}
                max={99}
              />
              <AdminFormField
                label="Data dołączenia"
                name="joined_date"
                type="date"
                value={editPlayerForm.joined_date}
                onChange={handleEditPlayerChange}
                darkMode={darkMode}
              />
            </div>
            <div className="mt-4 flex flex-wrap gap-4">
              <AdminFormField
                label="Kapitan"
                name="is_captain"
                type="checkbox"
                value={editPlayerForm.is_captain}
                onChange={handleEditPlayerChange}
                darkMode={darkMode}
              />
              <AdminFormField
                label="Aktywny zawodnik"
                name="is_active"
                type="checkbox"
                value={editPlayerForm.is_active}
                onChange={handleEditPlayerChange}
                darkMode={darkMode}
              />
            </div>
          </div>

          <div className="flex justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={() => {
                setShowEditPlayer(false);
                setEditingRosterRow(null);
                setEditPlayerForm(defaultEditPlayerForm());
              }}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted}`}
            >
              Anuluj
            </button>
            <button
              type="submit"
              disabled={savingPlayerEdit}
              className="px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium text-sm hover:bg-yellow-400 disabled:opacity-50"
            >
              {savingPlayerEdit ? "Zapisywanie..." : "Zapisz zmiany"}
            </button>
          </div>
        </form>
      </AdminModal>

      <AdminModal isOpen={showCreatePlayer} onClose={() => setShowCreatePlayer(false)} title="Dodaj nowego zawodnika do bazy" darkMode={darkMode}>
        <div className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <AdminFormField
              label="Imię"
              name="first_name"
              value={newPlayerForm.first_name}
              onChange={e => setNewPlayerForm(f => ({ ...f, first_name: e.target.value }))}
              required
              darkMode={darkMode}
            />
            <AdminFormField
              label="Nazwisko"
              name="last_name"
              value={newPlayerForm.last_name}
              onChange={e => setNewPlayerForm(f => ({ ...f, last_name: e.target.value }))}
              required
              darkMode={darkMode}
            />
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <AdminFormField
              label="Pozycja"
              name="position"
              type="select"
              value={newPlayerForm.position}
              onChange={e => setNewPlayerForm(f => ({ ...f, position: e.target.value }))}
              darkMode={darkMode}
              options={[
                { value: "BR", label: "Bramkarz" },
                { value: "OBR", label: "Obrońca" },
                { value: "POM", label: "Pomocnik" },
                { value: "NAP", label: "Napastnik" },
              ]}
            />
            <AdminFormField
              label="Rocznik"
              name="birth_year"
              type="number"
              value={newPlayerForm.birth_year}
              onChange={e => setNewPlayerForm(f => ({ ...f, birth_year: e.target.value }))}
              darkMode={darkMode}
              min={1960}
              max={2015}
            />
            <AdminFormField
              label="Noga"
              name="preferred_foot"
              type="select"
              value={newPlayerForm.preferred_foot}
              onChange={e => setNewPlayerForm(f => ({ ...f, preferred_foot: e.target.value }))}
              darkMode={darkMode}
              options={[
                { value: "Prawa", label: "Prawa" },
                { value: "Lewa", label: "Lewa" },
                { value: "Obie", label: "Obie" },
              ]}
            />
          </div>
          <AdminFormField
            label="Miasto"
            name="city"
            value={newPlayerForm.city}
            onChange={e => setNewPlayerForm(f => ({ ...f, city: e.target.value }))}
            darkMode={darkMode}
          />
          <AdminFormField
            label="Aktywny"
            name="is_active"
            type="checkbox"
            value={newPlayerForm.is_active}
            onChange={e => setNewPlayerForm(f => ({ ...f, is_active: e.target.value }))}
            darkMode={darkMode}
          />
          <div className="flex justify-end gap-3">
            <button type="button" onClick={() => setShowCreatePlayer(false)} className={`px-4 py-2 rounded-xl text-sm ${textMuted}`}>
              Anuluj
            </button>
            <button
              type="button"
              onClick={createPlayerFromRoster}
              disabled={creatingPlayer || !newPlayerForm.first_name.trim() || !newPlayerForm.last_name.trim()}
              className="px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium text-sm hover:bg-yellow-400 disabled:opacity-50"
            >
              {creatingPlayer ? "Dodawanie..." : "Dodaj do bazy"}
            </button>
          </div>
        </div>
      </AdminModal>
    </div>
  );
}
