import React, { useState, useEffect, useCallback, useMemo } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminTable from "./components/AdminTable";
import AdminModal from "./components/AdminModal";
import AdminAlert from "./components/AdminAlert";
import AdminImageUpload from "./components/AdminImageUpload";
import AdminTeamLogoCreator from "./components/AdminTeamLogoCreator";
import { Plus, GitMerge, Trash2, Loader2, Search } from "lucide-react";
import AdminConfirmDanger from "./components/AdminConfirmDanger";

function normalizeTeamKey(name) {
  return String(name || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "");
}

export default function AdminTeams({ darkMode }) {
  const [teams, setTeams] = useState([]);
  const [loading, setLoading] = useState(true);
  const [alert, setAlert] = useState({ type: null, message: null });
  const [showForm, setShowForm] = useState(false);
  const [hideInactiveTeams, setHideInactiveTeams] = useState(false);
  const [showLogoCreator, setShowLogoCreator] = useState(false);
  const [editId, setEditId] = useState(null);
  const [dangerTarget, setDangerTarget] = useState(null);
  const [showMergePicker, setShowMergePicker] = useState(false);
  const [showMerge, setShowMerge] = useState(false);
  const [mergeSelectedTeamIds, setMergeSelectedTeamIds] = useState([]);
  const [mergePickerQuery, setMergePickerQuery] = useState("");
  const [teamListQuery, setTeamListQuery] = useState("");
  const [mergeSource, setMergeSource] = useState("");
  const [mergeTarget, setMergeTarget] = useState("");
  const [mergeExtraSources, setMergeExtraSources] = useState([]);
  const [duplicateQuery, setDuplicateQuery] = useState("");
  const [mergeSourceQuery, setMergeSourceQuery] = useState("");
  const [mergeTargetQuery, setMergeTargetQuery] = useState("");
  const [mergeNameOption, setMergeNameOption] = useState("selected"); // "selected" | "target" | "source" | "custom"
  const [mergeKeepNameTeamId, setMergeKeepNameTeamId] = useState("");
  const [mergeCustomName, setMergeCustomName] = useState("");
  const [merging, setMerging] = useState(false);
  const [showDeactivate, setShowDeactivate] = useState(null);
  const [form, setForm] = useState({
    name: "", short_name: "", abbreviation: "", logo_url: "",
    founded_year: "", home_venue: "Narutowicza 10, 05-071 Sulejówek",
    description: "", district: "", is_active: true,
  });

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const loadData = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase.from("teams").select("*").order("name");
    setTeams(data || []);
    setLoading(false);
  }, []);

  useEffect(() => { loadData(); }, [loadData]);

  const duplicateGroups = useMemo(() => {
    const groups = new Map();
    for (const t of teams) {
      const key = normalizeTeamKey(t.name);
      if (!key) continue;
      if (!groups.has(key)) groups.set(key, []);
      groups.get(key).push(t);
    }
    return [...groups.values()]
      .filter((g) => g.length > 1)
      .map((g) => [...g].sort((a, b) => Number(b.is_active) - Number(a.is_active) || String(a.created_at || "").localeCompare(String(b.created_at || ""))))
      .sort((a, b) => b.length - a.length);
  }, [teams]);

  const teamMatchesQuery = useCallback((team, query) => {
    const q = normalizeTeamKey(query);
    if (!q) return true;
    const blob = [
      team?.name,
      team?.short_name,
      team?.abbreviation,
      team?.district,
    ]
      .map((v) => normalizeTeamKey(v))
      .join("");
    return blob.includes(q);
  }, []);

  const filteredDuplicateGroups = useMemo(() => {
    if (!duplicateQuery.trim()) return duplicateGroups;
    return duplicateGroups.filter((group) => group.some((t) => teamMatchesQuery(t, duplicateQuery)));
  }, [duplicateGroups, duplicateQuery, teamMatchesQuery]);

  const teamsSortedAlpha = useMemo(
    () =>
      [...teams].sort((a, b) =>
        String(a?.name || "").localeCompare(String(b?.name || ""), "pl", { sensitivity: "base" })
      ),
    [teams]
  );

  const visibleTeams = useMemo(
    () => {
      const baseTeams = hideInactiveTeams ? teams.filter((t) => t.is_active) : teams;
      if (!teamListQuery.trim()) return baseTeams;
      return baseTeams.filter((team) => teamMatchesQuery(team, teamListQuery));
    },
    [teams, hideInactiveTeams, teamListQuery, teamMatchesQuery]
  );

  const mergePickerTeams = useMemo(() => {
    if (!mergePickerQuery.trim()) return teamsSortedAlpha;
    return teamsSortedAlpha.filter((t) => teamMatchesQuery(t, mergePickerQuery));
  }, [teamsSortedAlpha, mergePickerQuery, teamMatchesQuery]);

  const mergeSelectedTeams = useMemo(
    () =>
      teamsSortedAlpha.filter((t) =>
        (mergeSelectedTeamIds || []).some((id) => String(id) === String(t.id))
      ),
    [teamsSortedAlpha, mergeSelectedTeamIds]
  );

  const filteredMergeSourceTeams = useMemo(() => {
    return teams.filter((t) => {
      if (String(t.id) === String(mergeSource)) return true;
      return teamMatchesQuery(t, mergeSourceQuery);
    });
  }, [teams, mergeSource, mergeSourceQuery, teamMatchesQuery]);

  const filteredMergeTargetTeams = useMemo(() => {
    return teams.filter((t) => {
      if (String(t.id) === String(mergeSource)) return false;
      if (String(t.id) === String(mergeTarget)) return true;
      return teamMatchesQuery(t, mergeTargetQuery);
    });
  }, [teams, mergeSource, mergeTarget, mergeTargetQuery, teamMatchesQuery]);

  const filteredExtraSourceTeams = useMemo(() => {
    return teams.filter((t) => {
      if (String(t.id) === String(mergeTarget)) return false;
      if (String(t.id) === String(mergeSource)) return false;
      if (mergeExtraSources.some((id) => String(id) === String(t.id))) return true;
      return teamMatchesQuery(t, mergeSourceQuery);
    });
  }, [teams, mergeTarget, mergeSource, mergeExtraSources, mergeSourceQuery, teamMatchesQuery]);

  const toggleExtraSource = (teamId) => {
    setMergeExtraSources((prev) =>
      prev.some((id) => String(id) === String(teamId))
        ? prev.filter((id) => String(id) !== String(teamId))
        : [...prev, teamId]
    );
  };

  const toggleMergeSelectedTeam = (teamId) => {
    setMergeSelectedTeamIds((prev) =>
      prev.some((id) => String(id) === String(teamId))
        ? prev.filter((id) => String(id) !== String(teamId))
        : [...prev, teamId]
    );
  };

  const openMergePicker = (prefillIds = []) => {
    const uniqueIds = [...new Set((prefillIds || []).filter(Boolean))];
    setMergeSelectedTeamIds(uniqueIds);
    setMergePickerQuery("");
    setShowMergePicker(true);
  };

  const closeMergePicker = () => {
    setShowMergePicker(false);
    setMergePickerQuery("");
  };

  const openMergeFinalizeFromSelection = () => {
    const selected = [...new Set(mergeSelectedTeamIds.filter(Boolean))];
    if (selected.length < 2) {
      setAlert({ type: "error", message: "Zaznacz co najmniej 2 drużyny do scalenia." });
      return;
    }

    const selectedTeams = selected
      .map((id) => teams.find((t) => String(t.id) === String(id)))
      .filter(Boolean);

    const targetDefault =
      [...selectedTeams]
        .sort((a, b) =>
          Number(b.is_active) - Number(a.is_active) ||
          String(a?.name || "").localeCompare(String(b?.name || ""), "pl", { sensitivity: "base" })
        )[0] || selectedTeams[0];

    const sourceIds = selected.filter((id) => String(id) !== String(targetDefault?.id));
    setMergeTarget(targetDefault?.id || "");
    setMergeSource(sourceIds[0] || "");
    setMergeExtraSources(sourceIds.slice(1));
    setMergeKeepNameTeamId(targetDefault?.id || "");
    setMergeNameOption("selected");
    setMergeCustomName("");
    setShowMergePicker(false);
    setShowMerge(true);
  };

  const closeMergeModal = () => {
    setShowMerge(false);
    setShowMergePicker(false);
    setMergeSelectedTeamIds([]);
    setMergePickerQuery("");
    setMergeSource("");
    setMergeTarget("");
    setMergeSourceQuery("");
    setMergeTargetQuery("");
    setMergeExtraSources([]);
    setMergeNameOption("selected");
    setMergeCustomName("");
    setMergeKeepNameTeamId("");
  };

  const renderSearchableTeamPicker = ({
    label,
    query,
    setQuery,
    selectedId,
    onSelect,
    options,
    placeholder,
  }) => {
    const selectedTeam = teams.find((t) => String(t.id) === String(selectedId));
    const visibleOptions = options || [];

    return (
      <div className="space-y-2">
        <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>{label}</label>
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder={placeholder}
          className={`w-full px-3 py-2 rounded-xl border text-sm outline-none ${
            darkMode
              ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500 focus:border-white/20"
              : "bg-white border-gray-200 text-gray-900 placeholder:text-gray-400 focus:border-gray-300"
          }`}
        />
        <div className={`rounded-xl border ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
          <div className={`px-3 py-2 text-xs border-b ${darkMode ? "border-white/10 text-gray-400" : "border-gray-200 text-gray-500"}`}>
            {selectedTeam
              ? <>Wybrano: <span className={darkMode ? "text-white" : "text-gray-900"}>{selectedTeam.name}</span>{selectedTeam.is_active ? "" : " (nieaktywna)"}</>
              : "Wpisz fragment nazwy i kliknij pozycję z listy poniżej"}
          </div>
          <div className="max-h-40 overflow-y-auto p-1">
            {visibleOptions.length > 0 ? visibleOptions.map((t) => {
              const isSelected = String(t.id) === String(selectedId);
              return (
                <button
                  key={`pick-${label}-${t.id}`}
                  type="button"
                  onClick={() => onSelect(t.id)}
                  className={`w-full text-left px-2 py-1.5 rounded text-sm flex items-center gap-2 ${
                    isSelected
                      ? (darkMode ? "bg-blue-500/20 text-blue-200" : "bg-blue-50 text-blue-700")
                      : (darkMode ? "hover:bg-white/5 text-gray-200" : "hover:bg-white text-gray-700")
                  }`}
                >
                  <span className={`text-xs ${t.is_active ? "text-green-500" : "text-red-500"}`}>
                    {t.is_active ? "Aktywna" : "Nieaktywna"}
                  </span>
                  <span className="truncate">{t.name}</span>
                  <span className={`text-xs ml-auto ${textMuted}`}>{t.abbreviation || "-"}</span>
                </button>
              );
            }) : (
              <div className={`px-2 py-2 text-xs ${textMuted}`}>Brak wyników dla tej frazy.</div>
            )}
          </div>
        </div>
      </div>
    );
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm(f => ({
      ...f,
      [name]: value,
      ...(name === "name" && !editId ? {
        abbreviation: value.slice(0, 3).toUpperCase(),
        short_name: value.length > 15 ? value.split(" ")[0] : value,
      } : {}),
    }));
  };

  const throwIfError = (result, label) => {
    if (result?.error) {
      throw new Error(`${label}: ${result.error.message}`);
    }
  };

  const getTeamReferenceCounts = async (teamId) => {
    const [
      seasonTeamsRes,
      teamPlayersRes,
      standingsRes,
      pssRes,
      matchEventsRes,
      lineupsRes,
      matchesHomeRes,
      matchesAwayRes,
    ] = await Promise.all([
      supabase.from("season_teams").select("id", { count: "exact", head: true }).eq("team_id", teamId),
      supabase.from("team_players").select("id", { count: "exact", head: true }).eq("team_id", teamId),
      supabase.from("standings").select("id", { count: "exact", head: true }).eq("team_id", teamId),
      supabase.from("player_season_stats").select("id", { count: "exact", head: true }).eq("team_id", teamId),
      supabase.from("match_events").select("id", { count: "exact", head: true }).eq("team_id", teamId),
      supabase.from("match_lineups").select("id", { count: "exact", head: true }).eq("team_id", teamId),
      supabase.from("matches").select("id", { count: "exact", head: true }).eq("home_team_id", teamId),
      supabase.from("matches").select("id", { count: "exact", head: true }).eq("away_team_id", teamId),
    ]);

    return {
      seasonTeams: seasonTeamsRes.count || 0,
      teamPlayers: teamPlayersRes.count || 0,
      standings: standingsRes.count || 0,
      playerStats: pssRes.count || 0,
      matchEvents: matchEventsRes.count || 0,
      matchLineups: lineupsRes.count || 0,
      matches: (matchesHomeRes.count || 0) + (matchesAwayRes.count || 0),
    };
  };

  const sanitizeUpsertRow = (row) => {
    const copy = { ...row };
    delete copy.id;
    delete copy.created_at;
    delete copy.updated_at;
    // Kolumny wyliczane (GENERATED ALWAYS) - baza liczy je sama.
    delete copy.goal_difference;
    delete copy.goals_per_match;
    delete copy.display_name;
    return copy;
  };

  const transferTeamRowsWithUpsert = async (table, sourceId, targetId, onConflict) => {
    const selectRes = await supabase.from(table).select("*").eq("team_id", sourceId);
    throwIfError(selectRes, `${table} select`);
    const rows = selectRes.data || [];
    if (!rows.length) return 0;

    const payload = rows.map((row) => ({
      ...sanitizeUpsertRow(row),
      team_id: targetId,
    }));

    const upsertRes = await supabase.from(table).upsert(payload, {
      onConflict,
      ignoreDuplicates: true,
    });
    throwIfError(upsertRes, `${table} upsert`);

    const cleanupRes = await supabase.from(table).delete().eq("team_id", sourceId);
    throwIfError(cleanupRes, `${table} cleanup`);

    return rows.length;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const payload = {
      name: form.name.trim(),
      short_name: form.short_name.trim() || null,
      abbreviation: form.abbreviation.trim().toUpperCase(),
      logo_url: form.logo_url || null,
      founded_year: form.founded_year ? parseInt(form.founded_year) : null,
      home_venue: form.home_venue || null,
      description: form.description || null,
      district: form.district || null,
      is_active: form.is_active,
    };

    let result;
    if (editId) {
      result = await supabase.from("teams").update(payload).eq("id", editId).select().single();
    } else {
      result = await supabase.from("teams").insert(payload).select().single();
    }

    if (result.error) {
      setAlert({ type: "error", message: result.error.message });
      return;
    }

    setAlert({ type: "success", message: editId ? "Drużyna zaktualizowana" : "Drużyna dodana" });
    setShowForm(false);
    setEditId(null);
    resetForm();
    loadData();
  };

  const resetForm = () => {
    setForm({
      name: "", short_name: "", abbreviation: "", logo_url: "",
      founded_year: "", home_venue: "Narutowicza 10, 05-071 Sulejówek",
      description: "", district: "", is_active: true,
    });
  };

  const handleEdit = (team) => {
    setForm({
      name: team.name || "",
      short_name: team.short_name || "",
      abbreviation: team.abbreviation || "",
      logo_url: team.logo_url || "",
      founded_year: team.founded_year || "",
      home_venue: team.home_venue || "",
      description: team.description || "",
      district: team.district || "",
      is_active: team.is_active,
    });
    setEditId(team.id);
    setShowLogoCreator(false);
    setShowForm(true);
  };

  const handleDelete = (team) => {
    setDangerTarget(team);
  };

  const [forceDeleteTarget, setForceDeleteTarget] = useState(null); // {team, refs}
  const [forceDeleting, setForceDeleting] = useState(false);

  const executeDelete = async () => {
    if (!dangerTarget) return;
    const target = dangerTarget;

    try {
      const { error } = await supabase.from("teams").delete().eq("id", target.id);
      if (error) {
        const isFkError =
          error.code === "23503" ||
          String(error.message || "").toLowerCase().includes("foreign key");

        if (isFkError) {
          const refs = await getTeamReferenceCounts(target.id);
          setForceDeleteTarget({ team: target, refs });
        } else {
          setAlert({ type: "error", message: error.message });
        }
      } else {
        setAlert({ type: "success", message: `Drużyna "${target.name}" usunięta trwale.` });
        loadData();
      }
    } catch (err) {
      setAlert({ type: "error", message: err.message || "Nie udało się usunąć drużyny." });
    } finally {
      setDangerTarget(null);
    }
  };

  const executeForceDelete = async () => {
    if (!forceDeleteTarget) return;
    const { team } = forceDeleteTarget;
    setForceDeleting(true);

    try {
      // Kolejność usuwania uwzględnia zależności FK
      // 1. suspensions (zależą od match_events)
      const { data: eventsOfTeam } = await supabase
        .from("match_events")
        .select("id")
        .eq("team_id", team.id);
      if (eventsOfTeam?.length) {
        const eventIds = eventsOfTeam.map(e => e.id);
        await supabase.from("suspensions").delete().in("triggering_event_id", eventIds);
      }

      // 2. match_events
      await supabase.from("match_events").delete().eq("team_id", team.id);

      // 3. match_lineups
      await supabase.from("match_lineups").delete().eq("team_id", team.id);

      // 4. player_season_stats
      await supabase.from("player_season_stats").delete().eq("team_id", team.id);

      // 5. standings
      await supabase.from("standings").delete().eq("team_id", team.id);

      // 6. team_players
      await supabase.from("team_players").delete().eq("team_id", team.id);

      // 7. season_teams
      await supabase.from("season_teams").delete().eq("team_id", team.id);

      // 8. matches (home or away)
      // Najpierw usuń eventy/lineup z meczów gdzie ta drużyna gra
      const { data: teamMatches } = await supabase
        .from("matches")
        .select("id")
        .or(`home_team_id.eq.${team.id},away_team_id.eq.${team.id}`);
      if (teamMatches?.length) {
        const matchIds = teamMatches.map(m => m.id);
        // Usuń suspensions powiązane z eventami tych meczów
        const { data: matchEvts } = await supabase
          .from("match_events")
          .select("id")
          .in("match_id", matchIds);
        if (matchEvts?.length) {
          await supabase.from("suspensions").delete().in("triggering_event_id", matchEvts.map(e => e.id));
        }
        await supabase.from("match_events").delete().in("match_id", matchIds);
        await supabase.from("match_lineups").delete().in("match_id", matchIds);
        await supabase.from("matches").delete().in("id", matchIds);
      }

      // 9. Na koniec sama drużyna
      const { error } = await supabase.from("teams").delete().eq("id", team.id);
      if (error) throw error;

      setAlert({ type: "success", message: `Drużyna "${team.name}" i wszystkie powiązane dane zostały usunięte.` });
      loadData();
    } catch (err) {
      setAlert({ type: "error", message: `Błąd wymuszania usunięcia: ${err.message}` });
    } finally {
      setForceDeleting(false);
      setForceDeleteTarget(null);
    }
  };

  // — Scalanie drużyn —
  const handleMerge = async () => {
    const selectedSourceIds = (mergeSelectedTeamIds || []).filter(
      (id) => String(id) !== String(mergeTarget)
    );
    const sourceIds = [...new Set((selectedSourceIds.length ? selectedSourceIds : [mergeSource, ...mergeExtraSources]).filter(Boolean))]
      .filter((id) => String(id) !== String(mergeTarget));

    if (!sourceIds.length || !mergeTarget) {
      setAlert({ type: "error", message: "Wybierz dwie różne drużyny" });
      return;
    }
    if (mergeNameOption === "custom" && !mergeCustomName.trim()) {
      setAlert({ type: "error", message: "Wpisz nową nazwę drużyny" });
      return;
    }

    setMerging(true);
    try {
      const tgtTeam = teams.find((t) => String(t.id) === String(mergeTarget));
      const mergedSourceNames = [];

      for (const sourceId of sourceIds) {
        const srcTeam = teams.find((t) => String(t.id) === String(sourceId));

        await transferTeamRowsWithUpsert("season_teams", sourceId, mergeTarget, "season_id,team_id");
        await transferTeamRowsWithUpsert("team_players", sourceId, mergeTarget, "player_id,season_id,league_id,team_id");
        await transferTeamRowsWithUpsert("standings", sourceId, mergeTarget, "season_id,league_id,team_id");
        await transferTeamRowsWithUpsert("player_season_stats", sourceId, mergeTarget, "player_id,season_id,league_id");

        throwIfError(
          await supabase.from("match_events").update({ team_id: mergeTarget }).eq("team_id", sourceId),
          "match_events update"
        );
        throwIfError(
          await supabase.from("match_lineups").update({ team_id: mergeTarget }).eq("team_id", sourceId),
          "match_lineups update"
        );
        throwIfError(
          await supabase.from("matches").update({ home_team_id: mergeTarget }).eq("home_team_id", sourceId),
          "matches home update"
        );
        throwIfError(
          await supabase.from("matches").update({ away_team_id: mergeTarget }).eq("away_team_id", sourceId),
          "matches away update"
        );

        const srcNameBase = String(srcTeam?.name || "Drużyna").trim() || "Drużyna";
        const srcSuffix = String(srcTeam?.id || sourceId || "").slice(-6) || "MERGED";
        const archivedSourceName = `${srcNameBase} [MERGED ${srcSuffix}]`;
        throwIfError(
          await supabase.from("teams").update({ is_active: false, name: archivedSourceName }).eq("id", sourceId),
          "teams source archive"
        );

        mergedSourceNames.push(srcTeam?.name || String(sourceId));
      }

      let finalName = tgtTeam?.name || "drużyna docelowa";
      if (mergeNameOption === "selected" && mergeKeepNameTeamId) {
        const keepNameTeam = teams.find((t) => String(t.id) === String(mergeKeepNameTeamId));
        finalName = keepNameTeam?.name || finalName;
      } else if (mergeNameOption === "source") {
        const primarySource = teams.find((t) => String(t.id) === String(mergeSource));
        finalName = primarySource?.name || finalName;
      } else if (mergeNameOption === "custom") {
        finalName = mergeCustomName.trim();
      }

      if (finalName && finalName.trim() && finalName.trim() !== String(tgtTeam?.name || "")) {
        const trimmedName = finalName.trim();
        throwIfError(
          await supabase
            .from("teams")
            .update({
              name: trimmedName,
              short_name: trimmedName.length > 15 ? trimmedName.split(" ")[0] : trimmedName,
            })
            .eq("id", mergeTarget),
          "teams target rename"
        );
        finalName = trimmedName;
      }

      setAlert({
        type: "success",
        message: sourceIds.length === 1
          ? `Scalono "${mergedSourceNames[0]}" -> "${finalName}". Powiązania zostały przepięte, rekord źródłowy oznaczony jako MERGED.`
          : `Scalono ${sourceIds.length} drużyny do "${finalName}". Powiązania zostały przepięte, rekordy źródłowe oznaczone jako MERGED.`,
      });
      // Wróć do pickera (nie zamykaj) — użytkownik może kontynuować scalanie
      setShowMerge(false);
      setShowMergePicker(true);
      setMergeSource("");
      setMergeTarget("");
      setMergeExtraSources([]);
      setMergeSelectedTeamIds([]);
      setMergeNameOption("selected");
      setMergeCustomName("");
      loadData();
    } catch (err) {
      setAlert({ type: "error", message: err.message || "Nie udało się scalić drużyn." });
    } finally {
      setMerging(false);
    }
  };

  // — Dezaktywacja drużyny (bez hasła) —
  const handleDeactivate = async (team) => {
    const { error } = await supabase.from("teams").update({ is_active: !team.is_active }).eq("id", team.id);
    if (error) {
      setAlert({ type: "error", message: error.message });
    } else {
      setAlert({ type: "success", message: team.is_active ? `"${team.name}" dezaktywowana` : `"${team.name}" aktywowana` });
      loadData();
    }
  };

  const columns = [
    {
      key: "logo_url", label: "",
      render: (v) => v ? <img src={v} alt="" className="w-8 h-8 object-contain rounded" /> : <div className="w-8 h-8 rounded bg-gray-700/50" />
    },
    { key: "name", label: "Nazwa", sortable: true },
    { key: "abbreviation", label: "Skrót", sortable: true },
    { key: "district", label: "Dzielnica", sortable: true },
    {
      key: "is_active", label: "Status",
      render: (v, row) => (
        <button
          onClick={(e) => { e.stopPropagation(); handleDeactivate(row); }}
          className={`text-xs font-medium px-2 py-0.5 rounded-full transition-colors ${
            v ? "bg-green-500/20 text-green-400 hover:bg-green-500/30"
              : "bg-red-500/20 text-red-400 hover:bg-red-500/30"
          }`}
          title={v ? "Kliknij aby dezaktywować" : "Kliknij aby aktywować"}
        >
          {v ? "Aktywna" : "Nieaktywna"}
        </button>
      )
    },
  ];

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-2 border-yellow-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold">Drużyny</h2>
          <p className={`text-sm ${textMuted}`}>{teams.filter(t => t.is_active).length} aktywnych z {teams.length}</p>
        </div>
        <div className="flex items-center gap-2">
          <label className={`flex items-center gap-2 px-3 py-2 rounded-xl border text-sm ${
            darkMode
              ? "border-white/10 bg-white/5 text-gray-300"
              : "border-gray-200 bg-white text-gray-700"
          }`}>
            <input
              type="checkbox"
              checked={hideInactiveTeams}
              onChange={(e) => setHideInactiveTeams(e.target.checked)}
              className="w-4 h-4"
            />
            Ukryj nieaktywne
          </label>
          <button
            onClick={() => openMergePicker()}
            className={`flex items-center gap-2 px-4 py-2 rounded-xl border font-medium text-sm transition-colors ${darkMode ? "border-white/10 text-gray-300 hover:bg-white/5" : "border-gray-200 text-gray-700 hover:bg-gray-50"}`}
          >
            <GitMerge size={16} /> Wybierz drużyny
          </button>
          <button
            onClick={() => { resetForm(); setEditId(null); setShowLogoCreator(false); setShowForm(true); }}
            className="flex items-center gap-2 px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors text-sm"
          >
            <Plus size={16} /> Dodaj drużynę
          </button>
        </div>
      </div>

      <AdminAlert type={alert.type} message={alert.message} onClose={() => setAlert({ type: null, message: null })} />

      <div className={`rounded-2xl border p-4 ${card}`}>
        <div className="relative">
          <Search size={16} className={`absolute left-3 top-1/2 -translate-y-1/2 ${textMuted}`} />
          <input
            type="text"
            value={teamListQuery}
            onChange={(e) => setTeamListQuery(e.target.value)}
            placeholder="Szukaj druzyny po nazwie, skrocie albo dzielnicy..."
            className={`w-full pl-9 pr-4 py-2.5 rounded-xl border text-sm outline-none ${
              darkMode
                ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500 focus:border-white/20"
                : "bg-white border-gray-200 text-gray-900 placeholder:text-gray-400 focus:border-gray-300"
            }`}
          />
        </div>
      </div>

      {duplicateGroups.length > 0 && (
        <div className={`rounded-2xl border p-4 ${card}`}>
          <div className="font-semibold mb-1">Kandydaci do duplikatów drużyn</div>
          <p className={`text-xs mb-3 ${textMuted}`}>
            Wykryto {duplicateGroups.length} grup podobnych nazw. Wpisz fragment nazwy, aby zawęzić wyniki.
          </p>
          <input
            type="text"
            value={duplicateQuery}
            onChange={(e) => setDuplicateQuery(e.target.value)}
            placeholder="Szukaj w duplikatach"
            className={`w-full mb-3 px-3 py-2 rounded-xl border text-sm outline-none ${
              darkMode
                ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500 focus:border-white/20"
                : "bg-white border-gray-200 text-gray-900 placeholder:text-gray-400 focus:border-gray-300"
            }`}
          />
          <div className="space-y-2 max-h-72 overflow-y-auto">
            {filteredDuplicateGroups.map((group, idx) => (
              <div key={`${idx}-${group[0]?.id || "g"}`} className={`rounded-xl border p-2 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
                <div className="flex items-center justify-between gap-2 mb-1">
                  <div className="text-sm font-medium truncate">{group[0]?.name} <span className={`text-xs ${textMuted}`}>({group.length} wpisy)</span></div>
                  {group.length > 1 && (
                    <button
                      type="button"
                      onClick={() => {
                        openMergePicker(group.map((t) => t.id));
                      }}
                      className="px-2 py-1 rounded text-xs bg-orange-500/10 text-orange-400 hover:bg-orange-500/20 shrink-0"
                    >
                      Przygotuj scalanie
                    </button>
                  )}
                </div>
                <div className="space-y-1">
                  {group.map((t, i) => (
                    <div key={t.id} className="flex items-center justify-between gap-2 text-xs">
                      <div className="truncate min-w-0">
                        <span className={t.is_active ? "text-green-400" : "text-red-400"}>{t.is_active ? "Aktywna" : "Nieaktywna"}</span>
                        {" • "}
                        {t.name}
                        {" • "}
                        {t.abbreviation}
                      </div>
                      <span className={`px-2 py-1 rounded shrink-0 ${i === 0 ? "bg-green-500/10 text-green-400" : darkMode ? "bg-white/5 text-gray-400" : "bg-gray-100 text-gray-600"}`}>
                        {i === 0 ? "KEEP" : "duplikat"}
                      </span>
                    </div>
                  ))}
                </div>
              </div>
            ))}
            {filteredDuplicateGroups.length === 0 && (
              <div className={`text-sm py-3 text-center rounded-xl border ${darkMode ? "border-white/10 text-gray-400" : "border-gray-200 text-gray-500"}`}>
                Brak wyników dla frazy "{duplicateQuery}"
              </div>
            )}
          </div>
        </div>
      )}

      <div className={`rounded-2xl border overflow-hidden ${card}`}>
        <AdminTable
          columns={columns}
          rows={visibleTeams}
          darkMode={darkMode}
          onEdit={handleEdit}
          onDelete={handleDelete}
          emptyMessage={teamListQuery.trim() ? `Brak druzyn dla frazy "${teamListQuery}".` : "Brak drużyn - dodaj pierwszą!"}
        />
      </div>

      {/* Danger confirm — trwałe usunięcie */}
      <AdminConfirmDanger
        isOpen={!!dangerTarget}
        onClose={() => setDangerTarget(null)}
        onConfirm={executeDelete}
        darkMode={darkMode}
        title={`Trwałe usunięcie drużyny "${dangerTarget?.name || ""}"`}
        message="UWAGA: Drużyna zostanie trwale usunięta z bazy danych. Jeżeli ma powiązane mecze lub kadry, operacja się nie powiedzie. W takim przypadku użyj dezaktywacji (kliknij status)."
      />

      {/* Force delete confirm */}
      {forceDeleteTarget && (
        <div className="fixed inset-0 z-50 flex items-start justify-center pt-[10vh] px-4 bg-black/60" onClick={() => !forceDeleting && setForceDeleteTarget(null)}>
          <div onClick={e => e.stopPropagation()} className={`w-full max-w-md rounded-2xl border p-6 shadow-2xl ${darkMode ? "bg-[#141828] border-white/10" : "bg-white border-gray-200"}`}>
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-full bg-red-500/20 flex items-center justify-center">
                <Trash2 size={22} className="text-red-400" />
              </div>
              <h3 className="text-lg font-bold text-red-400">Wymuś usunięcie &quot;{forceDeleteTarget.team.name}&quot;</h3>
            </div>
            <p className={`text-sm mb-3 ${darkMode ? "text-gray-300" : "text-gray-600"}`}>
              Drużyna ma powiązane dane, które zostaną <strong>trwale usunięte</strong>:
            </p>
            <ul className={`text-sm mb-4 space-y-1 ${darkMode ? "text-gray-400" : "text-gray-500"}`}>
              {[
                ["Sezony", forceDeleteTarget.refs.seasonTeams],
                ["Kadra", forceDeleteTarget.refs.teamPlayers],
                ["Tabela", forceDeleteTarget.refs.standings],
                ["Statystyki", forceDeleteTarget.refs.playerStats],
                ["Eventy meczowe", forceDeleteTarget.refs.matchEvents],
                ["Składy meczowe", forceDeleteTarget.refs.matchLineups],
                ["Mecze", forceDeleteTarget.refs.matches],
              ].filter(([, c]) => c > 0).map(([label, count]) => (
                <li key={label}>• {label}: <strong>{count}</strong></li>
              ))}
            </ul>
            <div className="flex gap-2">
              <button
                onClick={executeForceDelete}
                disabled={forceDeleting}
                className="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl bg-red-500 text-white font-semibold hover:bg-red-400 transition-colors disabled:opacity-50"
              >
                {forceDeleting ? <Loader2 size={16} className="animate-spin" /> : <Trash2 size={16} />}
                {forceDeleting ? "Usuwanie..." : "Usuń wszystko"}
              </button>
              <button
                onClick={() => setForceDeleteTarget(null)}
                disabled={forceDeleting}
                className={`px-4 py-2.5 rounded-xl border font-medium transition-colors ${darkMode ? "border-white/10 text-gray-300 hover:bg-white/5" : "border-gray-200 text-gray-700 hover:bg-gray-50"}`}
              >
                Anuluj
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Merge picker modal (duże okno z checkboxami) */}
      <AdminModal isOpen={showMergePicker} onClose={closeMergePicker} title="Wybierz drużyny do scalenia" darkMode={darkMode} xwide>
        <div className="space-y-4">
          <p className={`text-sm ${textMuted}`}>
            Zaznacz wszystkie warianty tej samej drużyny (np. różne zapisy nazwy lub sponsor w innych sezonach). Po kliknięciu "Dalej" wybierzesz rekord docelowy i nazwę do zachowania.
          </p>
          <div className="flex flex-col md:flex-row md:items-center gap-3">
            <input
              type="text"
              value={mergePickerQuery}
              onChange={(e) => setMergePickerQuery(e.target.value)}
              placeholder="Szukaj drużyny"
              className={`w-full md:flex-1 px-3 py-2 rounded-xl border text-sm outline-none ${
                darkMode
                  ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500 focus:border-white/20"
                  : "bg-white border-gray-200 text-gray-900 placeholder:text-gray-400 focus:border-gray-300"
              }`}
            />
            <div className={`text-xs px-3 py-2 rounded-xl border ${
              darkMode ? "border-white/10 bg-white/5 text-gray-300" : "border-gray-200 bg-gray-50 text-gray-600"
            }`}>
              zaznaczone: {mergeSelectedTeamIds.length}
            </div>
          </div>

          <div className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
            <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-2 max-h-[48vh] overflow-y-auto pr-1">
              {mergePickerTeams.map((t) => {
                const checked = mergeSelectedTeamIds.some((id) => String(id) === String(t.id));
                return (
                  <label
                    key={`merge-pick-${t.id}`}
                    className={`flex items-center gap-2 rounded-xl border px-3 py-2 cursor-pointer text-sm ${
                      checked
                        ? (darkMode ? "border-orange-400/40 bg-orange-500/10" : "border-orange-200 bg-orange-50")
                        : (darkMode ? "border-white/10 hover:bg-white/5" : "border-gray-200 bg-white hover:bg-gray-50")
                    }`}
                  >
                    <input
                      type="checkbox"
                      checked={checked}
                      onChange={() => toggleMergeSelectedTeam(t.id)}
                      className="w-4 h-4 shrink-0"
                    />
                    <div className="min-w-0 flex-1">
                      <div className="truncate font-medium">{t.name}</div>
                      <div className={`text-xs ${textMuted}`}>
                        {t.abbreviation || "-"} {t.district ? `• ${t.district}` : ""}
                      </div>
                    </div>
                    <span className={`text-xs shrink-0 ${t.is_active ? "text-green-500" : "text-red-500"}`}>
                      {t.is_active ? "Aktywna" : "Nieaktywna"}
                    </span>
                  </label>
                );
              })}
            </div>
            {mergePickerTeams.length === 0 && (
              <div className={`text-sm text-center py-4 ${textMuted}`}>Brak wyników dla tej frazy.</div>
            )}
          </div>

          <div className="flex justify-end gap-3 pt-1">
            <button type="button" onClick={closeMergePicker} className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}>
              Anuluj
            </button>
            <button
              type="button"
              onClick={openMergeFinalizeFromSelection}
              disabled={mergeSelectedTeamIds.length < 2}
              className="px-4 py-2 rounded-xl bg-orange-500 text-black font-medium text-sm hover:bg-orange-400 disabled:opacity-40 disabled:cursor-not-allowed"
            >
              Dalej
            </button>
          </div>
        </div>
      </AdminModal>

      {/* Merge finalization modal */}
      <AdminModal isOpen={showMerge} onClose={closeMergeModal} title="Scal drużyny - finalizacja" darkMode={darkMode} wide>
        <div className="space-y-4">
          <p className={`text-sm ${textMuted}`}>
            Wybierz, który rekord ma zostać główną drużyną oraz jaką nazwę zachować po scaleniu. Pozostałe rekordy zostaną oznaczone jako MERGED i dezaktywowane.
          </p>

          <div className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
            <div className="text-sm font-medium mb-2">Wybrane drużyny ({mergeSelectedTeams.length})</div>
            <div className="max-h-32 overflow-y-auto space-y-1">
              {mergeSelectedTeams.map((t) => (
                <div key={`selected-${t.id}`} className="flex items-center gap-2 text-sm">
                  <span className={`text-xs ${t.is_active ? "text-green-500" : "text-red-500"}`}>
                    {t.is_active ? "Aktywna" : "Nieaktywna"}
                  </span>
                  <span className="truncate">{t.name}</span>
                  <span className={`text-xs ml-auto ${textMuted}`}>{t.abbreviation || "-"}</span>
                </div>
              ))}
            </div>
          </div>

          <div className="space-y-2">
            <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Który rekord zostaje jako drużyna docelowa?</label>
            <div className={`rounded-xl border p-2 space-y-1 max-h-44 overflow-y-auto ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
              {mergeSelectedTeams.map((t) => (
                <label key={`target-${t.id}`} className={`flex items-center gap-2 px-2 py-1 rounded cursor-pointer text-sm ${darkMode ? "hover:bg-white/5" : "hover:bg-white"}`}>
                  <input
                    type="radio"
                    name="mergeTargetTeam"
                    checked={String(mergeTarget) === String(t.id)}
                    onChange={() => {
                      setMergeTarget(t.id);
                      if (mergeNameOption !== "custom") setMergeKeepNameTeamId(t.id);
                    }}
                    className="w-4 h-4"
                  />
                  <span className={`text-xs ${t.is_active ? "text-green-500" : "text-red-500"}`}>
                    {t.is_active ? "Aktywna" : "Nieaktywna"}
                  </span>
                  <span className="truncate">{t.name}</span>
                  <span className={`text-xs ml-auto ${textMuted}`}>{t.abbreviation || "-"}</span>
                </label>
              ))}
            </div>
          </div>

          <div className="space-y-2">
            <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Jaka nazwa ma zostać po scaleniu?</label>
            <div className={`rounded-xl border p-2 space-y-1 max-h-44 overflow-y-auto ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
              {mergeSelectedTeams.map((t) => (
                <label key={`keepname-${t.id}`} className={`flex items-center gap-2 px-2 py-1 rounded cursor-pointer text-sm ${darkMode ? "hover:bg-white/5" : "hover:bg-white"}`}>
                  <input
                    type="radio"
                    name="mergeKeepName"
                    checked={mergeNameOption === "selected" && String(mergeKeepNameTeamId) === String(t.id)}
                    onChange={() => {
                      setMergeNameOption("selected");
                      setMergeKeepNameTeamId(t.id);
                    }}
                    className="w-4 h-4"
                  />
                  <span className="truncate">{t.name}</span>
                </label>
              ))}
              <label className={`flex items-center gap-2 px-2 py-1 rounded cursor-pointer text-sm ${darkMode ? "hover:bg-white/5" : "hover:bg-white"}`}>
                <input
                  type="radio"
                  name="mergeKeepName"
                  checked={mergeNameOption === "custom"}
                  onChange={() => setMergeNameOption("custom")}
                  className="w-4 h-4"
                />
                Własna nazwa
              </label>
            </div>
            {mergeNameOption === "custom" && (
              <AdminFormField
                label="Nowa nazwa po scaleniu"
                name="customName"
                value={mergeCustomName}
                onChange={(e) => setMergeCustomName(e.target.value)}
                darkMode={darkMode}
                placeholder="Wpisz nazwę"
              />
            )}
          </div>

          <div className="flex justify-end gap-3 pt-1">
            <button
              type="button"
              onClick={() => { setShowMerge(false); setShowMergePicker(true); }}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}
            >
              Wróć
            </button>
            <button type="button" onClick={closeMergeModal} className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}>
              Anuluj
            </button>
            <button
              onClick={handleMerge}
              disabled={merging || !mergeTarget || mergeSelectedTeamIds.filter((id) => String(id) !== String(mergeTarget)).length === 0 || (mergeNameOption === "custom" && !mergeCustomName.trim())}
              className="px-4 py-2 rounded-xl bg-orange-500 text-black font-medium text-sm hover:bg-orange-400 disabled:opacity-40 disabled:cursor-not-allowed"
            >
              {merging ? "Scalanie..." : "Scalaj"}
            </button>
          </div>
        </div>
      </AdminModal>

      <AdminModal isOpen={showForm} onClose={() => setShowForm(false)} title={editId ? "Edytuj drużynę" : "Nowa drużyna"} darkMode={darkMode} wide>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <AdminFormField label="Nazwa" name="name" value={form.name} onChange={handleChange} required darkMode={darkMode} placeholder="np. Starszaki" />
            <AdminFormField label="Nazwa skrócona" name="short_name" value={form.short_name} onChange={handleChange} darkMode={darkMode} placeholder="np. Starszaki" />
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <AdminFormField label="Skrót (3 litery)" name="abbreviation" value={form.abbreviation} onChange={handleChange} required darkMode={darkMode} placeholder="STA" />
            <AdminFormField label="Rok założenia" name="founded_year" type="number" value={form.founded_year} onChange={handleChange} darkMode={darkMode} min={1900} max={2030} />
            <AdminFormField label="Dzielnica" name="district" value={form.district} onChange={handleChange} darkMode={darkMode} placeholder="np. Sulejówek" />
          </div>
          <AdminFormField label="Boisko domowe" name="home_venue" value={form.home_venue} onChange={handleChange} darkMode={darkMode} />
          <AdminFormField label="Opis" name="description" type="textarea" value={form.description} onChange={handleChange} darkMode={darkMode} />
          <AdminImageUpload
            bucket="team-logos"
            folder="logos"
            currentUrl={form.logo_url}
            onUpload={(url) => setForm(f => ({ ...f, logo_url: url }))}
            darkMode={darkMode}
            label="Logo drużyny"
          />
          <div className={`rounded-2xl border p-3 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
            <div className="flex items-center justify-between gap-3">
              <div>
                <div className="text-sm font-medium">Kreator logo</div>
                <div className={`text-xs ${textMuted}`}>
                  Alternatywa dla uploadu pliku: prosta tarcza + kolory + wzór + inicjały/napis.
                </div>
              </div>
              <button
                type="button"
                onClick={() => setShowLogoCreator((v) => !v)}
                className={`px-3 py-2 rounded-xl border text-sm ${
                  darkMode
                    ? "border-white/10 bg-white/5 text-gray-200 hover:bg-white/10"
                    : "border-gray-200 bg-white text-gray-700 hover:bg-gray-50"
                }`}
              >
                {showLogoCreator ? "Ukryj kreator" : "Otwórz kreator"}
              </button>
            </div>
            {showLogoCreator && (
              <div className="mt-3">
                <AdminTeamLogoCreator
                  darkMode={darkMode}
                  teamName={form.name}
                  abbreviation={form.abbreviation}
                  currentUrl={form.logo_url}
                  onApply={(url) => setForm((f) => ({ ...f, logo_url: url }))}
                />
              </div>
            )}
          </div>
          <AdminFormField label="Aktywna" name="is_active" type="checkbox" value={form.is_active} onChange={handleChange} darkMode={darkMode} />
          <div className="flex justify-end gap-3 pt-2">
            <button type="button" onClick={() => setShowForm(false)} className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}>Anuluj</button>
            <button type="submit" className="px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium text-sm hover:bg-yellow-400">
              {editId ? "Zapisz" : "Dodaj drużynę"}
            </button>
          </div>
        </form>
      </AdminModal>
    </div>
  );
}
