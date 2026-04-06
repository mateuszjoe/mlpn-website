import React, { useState, useEffect, useCallback, useMemo } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminTable from "./components/AdminTable";
import AdminModal from "./components/AdminModal";
import AdminAlert from "./components/AdminAlert";
import AdminImageUpload from "./components/AdminImageUpload";
import { Plus, Lock, AlertTriangle, GitMerge, UserMinus } from "lucide-react";

function levenshtein(a, b) {
  const la = a.length, lb = b.length;
  if (!la) return lb;
  if (!lb) return la;
  const dp = Array.from({ length: la + 1 }, (_, i) => i);
  for (let j = 1; j <= lb; j++) {
    let prev = dp[0];
    dp[0] = j;
    for (let i = 1; i <= la; i++) {
      const tmp = dp[i];
      dp[i] = a[i - 1] === b[j - 1] ? prev : 1 + Math.min(prev, dp[i], dp[i - 1]);
      prev = tmp;
    }
  }
  return dp[la];
}

function findFuzzyCandidates(firstName, lastName, players, threshold = 3) {
  const newKey = normalizePlayerKey(firstName, lastName);
  if (!newKey || newKey.length < 3) return [];
  const newLast = (lastName || "").normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().replace(/[^a-z]/g, "");
  const newFirst = (firstName || "").normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().replace(/[^a-z]/g, "");

  const results = [];
  for (const p of players) {
    if (isMergedPlayerRecord(p)) continue;
    const pKey = normalizePlayerKey(p.first_name, p.last_name);
    if (!pKey) continue;

    // Exact match
    if (pKey === newKey) {
      results.push({ player: p, distance: 0, reason: "Identyczne imię i nazwisko" });
      continue;
    }

    // Full name fuzzy
    const dist = levenshtein(newKey, pKey);
    if (dist <= threshold) {
      results.push({ player: p, distance: dist, reason: `Podobne imię i nazwisko (różnica: ${dist} znaki)` });
      continue;
    }

    // Same last name, similar first name
    const pLast = (p.last_name || "").normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().replace(/[^a-z]/g, "");
    const pFirst = (p.first_name || "").normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().replace(/[^a-z]/g, "");

    if (newLast === pLast && newFirst && pFirst) {
      const firstDist = levenshtein(newFirst, pFirst);
      if (firstDist <= 2) {
        results.push({ player: p, distance: firstDist, reason: `To samo nazwisko, podobne imię (różnica: ${firstDist})` });
        continue;
      }
    }
    if (newFirst === pFirst && newLast && pLast) {
      const lastDist = levenshtein(newLast, pLast);
      if (lastDist <= 2) {
        results.push({ player: p, distance: lastDist, reason: `To samo imię, podobne nazwisko (różnica: ${lastDist})` });
        continue;
      }
    }
  }
  return results.sort((a, b) => a.distance - b.distance);
}

function normalizePlayerKey(firstName, lastName) {
  return String(`${firstName || ""} ${lastName || ""}`)
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "");
}

function privateRow(player) {
  if (!player) return null;
  if (Array.isArray(player.players_private)) return player.players_private[0] || null;
  return player.players_private || null;
}

function hasVal(v) {
  if (v === null || v === undefined) return false;
  if (typeof v === "string") return v.trim() !== "";
  return true;
}

function pickExisting(existingValue, incomingValue) {
  if (hasVal(existingValue)) return existingValue;
  return hasVal(incomingValue) ? incomingValue : null;
}

function isMergedPlayerRecord(player) {
  const notes = String(privateRow(player)?.notes || "");
  return notes.includes("[MERGED_TO:");
}

function calcAge(birthYear) {
  if (!birthYear) return null;
  const year = new Date().getFullYear();
  const age = Number(year) - Number(birthYear);
  return Number.isFinite(age) && age > 0 && age < 100 ? age : null;
}

const DEFAULT_PLAYER_MERGE_STAT_STRATEGY = {
  appearances: "sum",
  goals: "sum",
  assists: "sum",
  yellow_cards: "sum",
  red_cards: "sum",
};

const PLAYER_MERGE_STAT_FIELDS = [
  { key: "appearances", label: "Występy" },
  { key: "goals", label: "Gole" },
  { key: "assists", label: "Asysty" },
  { key: "yellow_cards", label: "Kartki żółte" },
  { key: "red_cards", label: "Kartki czerwone" },
];

export default function AdminPlayers({ darkMode }) {
  const [players, setPlayers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [alert, setAlert] = useState({ type: null, message: null });
  const [showForm, setShowForm] = useState(false);
  const [editId, setEditId] = useState(null);
  const [showRodo, setShowRodo] = useState(false);
  const [search, setSearch] = useState("");
  const [showMergePicker, setShowMergePicker] = useState(false);
  const [showMergeCompare, setShowMergeCompare] = useState(false);
  const [mergeDupSearch, setMergeDupSearch] = useState("");
  const [mergeGroup, setMergeGroup] = useState([]);
  const [mergeTargetId, setMergeTargetId] = useState("");
  const [mergeGroupStats, setMergeGroupStats] = useState({});
  const [mergeLoadingStats, setMergeLoadingStats] = useState(false);
  const [mergeBusy, setMergeBusy] = useState(false);
  const [mergeStatStrategy, setMergeStatStrategy] = useState(DEFAULT_PLAYER_MERGE_STAT_STRATEGY);
  const [playerTeams, setPlayerTeams] = useState({});
  const [releasingId, setReleasingId] = useState(null);
  const [dupPrompt, setDupPrompt] = useState({
    open: false,
    payload: null,
    rodoPayload: null,
    candidates: [],
  });
  const [form, setForm] = useState({
    first_name: "", last_name: "", position: "POM", birth_year: "",
    preferred_foot: "", photo_url: "", city: "", is_active: true,
  });
  const [rodoForm, setRodoForm] = useState({
    date_of_birth: "", phone: "", email: "", address: "",
    rodo_consent_date: "", rodo_consent_type: "", notes: "",
  });

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const loadData = useCallback(async () => {
    setLoading(true);
    const [playersRes, teamsRes] = await Promise.all([
      supabase
        .from("players")
        .select("*, players_private(*)")
        .order("last_name"),
      supabase
        .from("team_players")
        .select("player_id, team_id, season_id, joined_date, left_date, teams(name), seasons(year)")
        .is("left_date", null)
        .order("joined_date", { ascending: false }),
    ]);
    setPlayers(playersRes.data || []);

    // Build map: player_id -> { team_name, season_year, team_players_id }
    const teamsMap = {};
    for (const tp of teamsRes.data || []) {
      if (teamsMap[tp.player_id]) continue; // keep first (most recent)
      const teamObj = Array.isArray(tp.teams) ? tp.teams[0] : tp.teams;
      const seasonObj = Array.isArray(tp.seasons) ? tp.seasons[0] : tp.seasons;
      teamsMap[tp.player_id] = {
        team_name: teamObj?.name || "?",
        season_year: seasonObj?.year || null,
        team_id: tp.team_id,
      };
    }
    setPlayerTeams(teamsMap);
    setLoading(false);
  }, []);

  useEffect(() => { loadData(); }, [loadData]);

  const duplicateGroups = useMemo(() => {
    const groups = new Map();
    for (const p of players) {
      if (isMergedPlayerRecord(p)) continue;
      const key = normalizePlayerKey(p.first_name, p.last_name);
      if (!key) continue;
      if (!groups.has(key)) groups.set(key, []);
      groups.get(key).push(p);
    }
    return [...groups.values()]
      .filter((g) => g.length > 1)
      .map((g) => [...g].sort((a, b) => Number(b.is_active) - Number(a.is_active) || String(a.created_at || "").localeCompare(String(b.created_at || ""))))
      .sort((a, b) => b.length - a.length);
  }, [players]);

  const filteredMergeDuplicateGroups = useMemo(() => {
    if (!mergeDupSearch.trim()) return duplicateGroups;
    const q = normalizePlayerKey(mergeDupSearch, "");
    return duplicateGroups.filter((group) =>
      group.some((p) => {
        const blob = normalizePlayerKey(p.first_name, p.last_name) + normalizePlayerKey(p.city || "", "");
        return blob.includes(q);
      })
    );
  }, [duplicateGroups, mergeDupSearch]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm(f => ({ ...f, [name]: value }));
  };

  const handleRodoChange = (e) => {
    const { name, value } = e.target;
    setRodoForm(f => ({ ...f, [name]: value }));
  };

  const buildPayloads = () => {
    const payload = {
      first_name: form.first_name.trim(),
      last_name: form.last_name.trim(),
      position: form.position,
      birth_year: form.birth_year ? parseInt(form.birth_year, 10) : null,
      preferred_foot: form.preferred_foot || null,
      photo_url: form.photo_url || null,
      city: form.city || null,
      is_active: form.is_active,
    };
    const rodoPayload = {
      date_of_birth: rodoForm.date_of_birth || null,
      phone: rodoForm.phone || null,
      email: rodoForm.email || null,
      address: rodoForm.address || null,
      rodo_consent_date: rodoForm.rodo_consent_date || null,
      rodo_consent_type: rodoForm.rodo_consent_type || null,
      notes: rodoForm.notes || null,
    };
    return { payload, rodoPayload };
  };

  const savePlayerRecord = async ({ payload, rodoPayload, targetId = null }) => {
    let result;
    if (targetId) {
      result = await supabase.from("players").update(payload).eq("id", targetId).select().single();
    } else {
      result = await supabase.from("players").insert(payload).select().single();
    }

    if (result.error) throw result.error;

    const finalPlayerId = result.data.id;
    const finalRodo = { player_id: finalPlayerId, ...rodoPayload };

    const hasAnyRodo = Object.entries(rodoPayload).some(([, v]) => hasVal(v));
    if (hasAnyRodo) {
      const { error: rodoErr } = await supabase
        .from("players_private")
        .upsert(finalRodo, { onConflict: "player_id" });
      if (rodoErr) throw rodoErr;
    }

    return result.data;
  };

  const finishSuccess = (msg) => {
    setAlert({ type: "success", message: msg });
    setShowForm(false);
    setEditId(null);
    resetForm();
    setDupPrompt({ open: false, payload: null, rodoPayload: null, candidates: [] });
    loadData();
  };

  const closePlayerMergeFlow = () => {
    setShowMergePicker(false);
    setShowMergeCompare(false);
    setMergeDupSearch("");
    setMergeGroup([]);
    setMergeTargetId("");
    setMergeGroupStats({});
    setMergeLoadingStats(false);
    setMergeBusy(false);
    setMergeStatStrategy(DEFAULT_PLAYER_MERGE_STAT_STRATEGY);
  };

  const throwIfError = (result, label) => {
    if (result?.error) throw new Error(`${label}: ${result.error.message}`);
  };

  const sanitizeUpsertRow = (row) => {
    const copy = { ...row };
    delete copy.id;
    delete copy.created_at;
    delete copy.updated_at;
    delete copy.display_name;
    delete copy.goals_per_match;
    return copy;
  };

  const transferPlayerRowsWithUpsert = async (table, sourceId, targetId, onConflict) => {
    const selectRes = await supabase.from(table).select("*").eq("player_id", sourceId);
    throwIfError(selectRes, `${table} select`);
    const rows = selectRes.data || [];
    if (!rows.length) return 0;

    const payload = rows.map((row) => ({
      ...sanitizeUpsertRow(row),
      player_id: targetId,
    }));

    const upsertRes = await supabase.from(table).upsert(payload, { onConflict, ignoreDuplicates: true });
    throwIfError(upsertRes, `${table} upsert`);

    const cleanupRes = await supabase.from(table).delete().eq("player_id", sourceId);
    throwIfError(cleanupRes, `${table} cleanup`);
    return rows.length;
  };

  const mergePlayerSeasonStatsRows = async (sourceId, targetId) => {
    const sourceRes = await supabase.from("player_season_stats").select("*").eq("player_id", sourceId);
    throwIfError(sourceRes, "player_season_stats source select");
    const sourceRows = sourceRes.data || [];
    if (!sourceRows.length) return 0;

    for (const row of sourceRows) {
      const targetRes = await supabase
        .from("player_season_stats")
        .select("id, team_id, appearances, goals, assists, yellow_cards, red_cards")
        .eq("player_id", targetId)
        .eq("season_id", row.season_id)
        .eq("league_id", row.league_id)
        .maybeSingle();
      throwIfError(targetRes, "player_season_stats target select");

      if (targetRes.data) {
        const t = targetRes.data;
        throwIfError(
          await supabase
            .from("player_season_stats")
            .update({
              team_id: t.team_id || row.team_id,
              appearances: Math.max(Number(t.appearances || 0), Number(row.appearances || 0)),
              goals: Number(t.goals || 0) + Number(row.goals || 0),
              assists: Number(t.assists || 0) + Number(row.assists || 0),
              yellow_cards: Number(t.yellow_cards || 0) + Number(row.yellow_cards || 0),
              red_cards: Number(t.red_cards || 0) + Number(row.red_cards || 0),
            })
            .eq("id", t.id),
          "player_season_stats aggregate update"
        );
        throwIfError(
          await supabase.from("player_season_stats").delete().eq("id", row.id),
          "player_season_stats source cleanup"
        );
      } else {
        throwIfError(
          await supabase.from("player_season_stats").update({ player_id: targetId }).eq("id", row.id),
          "player_season_stats move row"
        );
      }
    }
    return sourceRows.length;
  };

  const buildMergedPlayerSeasonStatsBaseline = async (playerIds, targetId) => {
    if (!Array.isArray(playerIds) || !playerIds.length) return [];
    const res = await supabase
      .from("player_season_stats")
      .select("player_id, season_id, league_id, team_id, appearances, goals, assists, yellow_cards, red_cards")
      .in("player_id", playerIds);
    throwIfError(res, "player_season_stats baseline select");

    const byKey = new Map();
    const keyOf = (row) => `${row.season_id || ""}|${row.league_id || ""}`;

    for (const row of res.data || []) {
      const key = keyOf(row);
      if (!byKey.has(key)) {
        byKey.set(key, {
          season_id: row.season_id,
          league_id: row.league_id,
          team_id: row.team_id || null,
          appearances: 0,
          goals: 0,
          assists: 0,
          yellow_cards: 0,
          red_cards: 0,
        });
      }
      const acc = byKey.get(key);
      const isTargetRow = String(row.player_id) === String(targetId);
      if ((isTargetRow && row.team_id) || (!acc.team_id && row.team_id)) {
        acc.team_id = row.team_id;
      }
      acc.appearances = Math.max(acc.appearances, Number(row.appearances || 0));
      acc.goals += Number(row.goals || 0);
      acc.assists += Number(row.assists || 0);
      acc.yellow_cards += Number(row.yellow_cards || 0);
      acc.red_cards += Number(row.red_cards || 0);
    }

    return [...byKey.values()];
  };

  const buildPlayerSeasonStatsBaselineMapForTarget = async (targetId) => {
    if (!targetId) return new Map();
    const res = await supabase
      .from("player_season_stats")
      .select("season_id, league_id, team_id, appearances, goals, assists, yellow_cards, red_cards")
      .eq("player_id", targetId);
    throwIfError(res, "player_season_stats target baseline select");

    const map = new Map();
    for (const row of res.data || []) {
      map.set(`${row.season_id || ""}|${row.league_id || ""}`, {
        team_id: row.team_id || null,
        appearances: Number(row.appearances || 0),
        goals: Number(row.goals || 0),
        assists: Number(row.assists || 0),
        yellow_cards: Number(row.yellow_cards || 0),
        red_cards: Number(row.red_cards || 0),
      });
    }
    return map;
  };

  const applyPlayerSeasonStatsBaselineFloor = async (targetId, baselineRows, options = {}) => {
    if (!targetId || !Array.isArray(baselineRows) || baselineRows.length === 0) return 0;
    const strategy = {
      ...DEFAULT_PLAYER_MERGE_STAT_STRATEGY,
      ...(options.strategy || {}),
    };
    const targetBaselineMap = options.targetBaselineMap instanceof Map ? options.targetBaselineMap : new Map();

    const currentRes = await supabase
      .from("player_season_stats")
      .select("id, season_id, league_id, team_id, appearances, goals, assists, yellow_cards, red_cards")
      .eq("player_id", targetId);
    throwIfError(currentRes, "player_season_stats target final select");

    const currentByKey = new Map();
    for (const row of currentRes.data || []) {
      currentByKey.set(`${row.season_id || ""}|${row.league_id || ""}`, row);
    }

    let touched = 0;
    for (const base of baselineRows) {
      const key = `${base.season_id || ""}|${base.league_id || ""}`;
      const current = currentByKey.get(key);
      const targetBaseline = targetBaselineMap.get(key);
      const mergedBase = {
        appearances: Number(base.appearances || 0),
        goals: Number(base.goals || 0),
        assists: Number(base.assists || 0),
        yellow_cards: Number(base.yellow_cards || 0),
        red_cards: Number(base.red_cards || 0),
      };
      const targetBaseValues = {
        appearances: Number(targetBaseline?.appearances || 0),
        goals: Number(targetBaseline?.goals || 0),
        assists: Number(targetBaseline?.assists || 0),
        yellow_cards: Number(targetBaseline?.yellow_cards || 0),
        red_cards: Number(targetBaseline?.red_cards || 0),
      };

      const pickStatValue = (field) => {
        if (strategy[field] === "overwrite") {
          if (targetBaseline) return targetBaseValues[field];
          return mergedBase[field];
        }
        const currentVal = Number(current?.[field] || 0);
        return Math.max(currentVal, mergedBase[field]);
      };

      if (current) {
        const patch = {
          team_id: current.team_id || targetBaseline?.team_id || base.team_id || null,
          appearances: pickStatValue("appearances"),
          goals: pickStatValue("goals"),
          assists: pickStatValue("assists"),
          yellow_cards: pickStatValue("yellow_cards"),
          red_cards: pickStatValue("red_cards"),
        };

        const changed =
          String(patch.team_id || "") !== String(current.team_id || "") ||
          patch.appearances !== Number(current.appearances || 0) ||
          patch.goals !== Number(current.goals || 0) ||
          patch.assists !== Number(current.assists || 0) ||
          patch.yellow_cards !== Number(current.yellow_cards || 0) ||
          patch.red_cards !== Number(current.red_cards || 0);

        if (changed) {
          throwIfError(
            await supabase.from("player_season_stats").update(patch).eq("id", current.id),
            "player_season_stats final floor update"
          );
          touched += 1;
        }
      } else {
        const insertRow = {
          player_id: targetId,
          season_id: base.season_id,
          league_id: base.league_id,
          team_id: targetBaseline?.team_id || base.team_id || null,
          appearances: strategy.appearances === "overwrite" && targetBaseline ? targetBaseValues.appearances : mergedBase.appearances,
          goals: strategy.goals === "overwrite" && targetBaseline ? targetBaseValues.goals : mergedBase.goals,
          assists: strategy.assists === "overwrite" && targetBaseline ? targetBaseValues.assists : mergedBase.assists,
          yellow_cards: strategy.yellow_cards === "overwrite" && targetBaseline ? targetBaseValues.yellow_cards : mergedBase.yellow_cards,
          red_cards: strategy.red_cards === "overwrite" && targetBaseline ? targetBaseValues.red_cards : mergedBase.red_cards,
        };
        throwIfError(
          await supabase.from("player_season_stats").insert(insertRow),
          "player_season_stats final floor insert"
        );
        touched += 1;
      }
    }

    return touched;
  };

  const openMergeComparisonForGroup = async (group) => {
    if (!Array.isArray(group) || group.length < 2) return;
    setMergeGroup(group);
    setMergeTargetId(group[0]?.id || "");
    setShowMergeCompare(true);
    setMergeLoadingStats(true);
    setMergeGroupStats({});

    const ids = group.map((p) => p.id);
    const byPlayer = {};
    ids.forEach((id) => { byPlayer[id] = []; });

    const unwrap = (v) => (Array.isArray(v) ? v[0] : v);
    const rowKey = (r) => `${r.player_id}|${r.season_id || ""}|${r.league_id || ""}|${r.team_id || ""}`;

    try {
      const [pssRes, tpRes] = await Promise.all([
        supabase
          .from("player_season_stats")
          .select("player_id, season_id, league_id, team_id, appearances, goals, assists, yellow_cards, red_cards, seasons(year), leagues(code), teams(name)")
          .in("player_id", ids),
        supabase
          .from("team_players")
          .select("player_id, season_id, league_id, team_id, seasons(year), leagues(code), teams(name)")
          .in("player_id", ids),
      ]);

      throwIfError(pssRes, "player_season_stats select");
      throwIfError(tpRes, "team_players select");

      const combined = new Map();

      for (const row of pssRes.data || []) {
        const seasonObj = unwrap(row.seasons);
        const leagueObj = unwrap(row.leagues);
        const teamObj = unwrap(row.teams);
        combined.set(rowKey(row), {
          player_id: row.player_id,
          season_id: row.season_id,
          league_id: row.league_id,
          team_id: row.team_id,
          season_year: seasonObj?.year ?? null,
          league_code: leagueObj?.code ?? null,
          team_name: teamObj?.name ?? null,
          appearances: row.appearances ?? 0,
          goals: row.goals ?? 0,
          assists: row.assists ?? 0,
          yellow_cards: row.yellow_cards ?? 0,
          red_cards: row.red_cards ?? 0,
        });
      }

      for (const row of tpRes.data || []) {
        const key = rowKey(row);
        const seasonObj = unwrap(row.seasons);
        const leagueObj = unwrap(row.leagues);
        const teamObj = unwrap(row.teams);
        if (!combined.has(key)) {
          combined.set(key, {
            player_id: row.player_id,
            season_id: row.season_id,
            league_id: row.league_id,
            team_id: row.team_id,
            season_year: seasonObj?.year ?? null,
            league_code: leagueObj?.code ?? null,
            team_name: teamObj?.name ?? null,
            appearances: 0,
            goals: 0,
            assists: 0,
            yellow_cards: 0,
            red_cards: 0,
          });
        }
      }

      for (const statsRow of combined.values()) {
        if (!byPlayer[statsRow.player_id]) byPlayer[statsRow.player_id] = [];
        byPlayer[statsRow.player_id].push(statsRow);
      }

      Object.values(byPlayer).forEach((list) =>
        list.sort((a, b) =>
          Number(b.season_year || 0) - Number(a.season_year || 0) ||
          String(a.league_code || "").localeCompare(String(b.league_code || ""), "pl") ||
          String(a.team_name || "").localeCompare(String(b.team_name || ""), "pl")
        )
      );

      setMergeGroupStats(byPlayer);
    } catch (err) {
      setAlert({ type: "error", message: `Błąd pobierania porównania zawodników: ${err.message}` });
    } finally {
      setMergeLoadingStats(false);
    }
  };

  const executeMergePlayersGroup = async () => {
    if (!mergeTargetId || !mergeGroup.length) return;
    const target = mergeGroup.find((p) => String(p.id) === String(mergeTargetId));
    const sources = mergeGroup.filter((p) => String(p.id) !== String(mergeTargetId));
    if (!target || !sources.length) {
      setAlert({ type: "error", message: "Wybierz rekord docelowy i co najmniej jeden rekord do scalenia." });
      return;
    }

    setMergeBusy(true);
    try {
      const baselinePss = await buildMergedPlayerSeasonStatsBaseline(
        mergeGroup.map((p) => p.id),
        target.id
      );
      const targetBaselineMap = await buildPlayerSeasonStatsBaselineMapForTarget(target.id);

      let mergedTargetPayload = {
        first_name: target.first_name || "",
        last_name: target.last_name || "",
        position: target.position || "POM",
        birth_year: target.birth_year || null,
        preferred_foot: target.preferred_foot || null,
        photo_url: target.photo_url || null,
        city: target.city || null,
        is_active: true,
      };

      const targetPriv = privateRow(target) || {};
      let mergedTargetPriv = {
        date_of_birth: targetPriv.date_of_birth || null,
        phone: targetPriv.phone || null,
        email: targetPriv.email || null,
        address: targetPriv.address || null,
        rodo_consent_date: targetPriv.rodo_consent_date || null,
        rodo_consent_type: targetPriv.rodo_consent_type || null,
        notes: targetPriv.notes || null,
      };

      for (const source of sources) {
        const priv = privateRow(source) || {};
        mergedTargetPayload = {
          first_name: pickExisting(mergedTargetPayload.first_name, source.first_name),
          last_name: pickExisting(mergedTargetPayload.last_name, source.last_name),
          position: pickExisting(mergedTargetPayload.position, source.position) || "POM",
          birth_year: pickExisting(mergedTargetPayload.birth_year, source.birth_year),
          preferred_foot: pickExisting(mergedTargetPayload.preferred_foot, source.preferred_foot),
          photo_url: pickExisting(mergedTargetPayload.photo_url, source.photo_url),
          city: pickExisting(mergedTargetPayload.city, source.city),
          is_active: true,
        };
        mergedTargetPriv = {
          date_of_birth: pickExisting(mergedTargetPriv.date_of_birth, priv.date_of_birth),
          phone: pickExisting(mergedTargetPriv.phone, priv.phone),
          email: pickExisting(mergedTargetPriv.email, priv.email),
          address: pickExisting(mergedTargetPriv.address, priv.address),
          rodo_consent_date: pickExisting(mergedTargetPriv.rodo_consent_date, priv.rodo_consent_date),
          rodo_consent_type: pickExisting(mergedTargetPriv.rodo_consent_type, priv.rodo_consent_type),
          notes: pickExisting(mergedTargetPriv.notes, priv.notes),
        };
      }

      throwIfError(
        await supabase.from("players").update(mergedTargetPayload).eq("id", target.id),
        "players target update"
      );
      if (Object.values(mergedTargetPriv).some((v) => hasVal(v))) {
        throwIfError(
          await supabase.from("players_private").upsert({ player_id: target.id, ...mergedTargetPriv }, { onConflict: "player_id" }),
          "players_private target upsert"
        );
      }

      for (const source of sources) {
        await transferPlayerRowsWithUpsert("team_players", source.id, target.id, "player_id,season_id,league_id,team_id");
        await transferPlayerRowsWithUpsert("match_lineups", source.id, target.id, "match_id,player_id");
        await mergePlayerSeasonStatsRows(source.id, target.id);

        throwIfError(await supabase.from("suspensions").update({ player_id: target.id }).eq("player_id", source.id), "suspensions update");
        throwIfError(await supabase.from("match_events").update({ player_id: target.id }).eq("player_id", source.id), "match_events player update");
        throwIfError(await supabase.from("match_events").update({ assist_player_id: target.id }).eq("assist_player_id", source.id), "match_events assist update");
        throwIfError(await supabase.from("matches").update({ mvp_player_id: target.id }).eq("mvp_player_id", source.id), "matches mvp update");

        const sourcePriv = privateRow(source) || {};
        const mergeMarker = `[MERGED_TO:${target.id}] ${new Date().toISOString()}`;
        const sourceNotes = sourcePriv.notes ? `${mergeMarker}\n${sourcePriv.notes}` : mergeMarker;
        throwIfError(
          await supabase.from("players_private").upsert({ player_id: source.id, notes: sourceNotes }, { onConflict: "player_id" }),
          "players_private source mark"
        );
        throwIfError(
          await supabase.from("players").update({ is_active: false }).eq("id", source.id),
          "players source deactivate"
        );
      }

      await applyPlayerSeasonStatsBaselineFloor(target.id, baselinePss, {
        strategy: mergeStatStrategy,
        targetBaselineMap,
      });

      setAlert({
        type: "success",
        message: sources.length === 1
          ? `Scalono zawodnika do rekordu docelowego: ${target.display_name}.`
          : `Scalono ${sources.length} rekordy zawodników do: ${target.display_name}.`,
      });
      closePlayerMergeFlow();
      loadData();
    } catch (err) {
      setAlert({ type: "error", message: err.message || "Nie udało się scalić zawodników." });
    } finally {
      setMergeBusy(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const { payload, rodoPayload } = buildPayloads();

    if (!editId) {
      const fuzzyResults = findFuzzyCandidates(payload.first_name, payload.last_name, players);
      if (fuzzyResults.length > 0) {
        setDupPrompt({ open: true, payload, rodoPayload, candidates: fuzzyResults });
        return;
      }
    }

    try {
      await savePlayerRecord({ payload, rodoPayload, targetId: editId || null });
      finishSuccess(editId ? "Zawodnik zaktualizowany" : "Zawodnik dodany");
    } catch (err) {
      setAlert({ type: "error", message: err.message });
    }
  };

  const continueCreateWithoutMerge = async () => {
    if (!dupPrompt.payload) return;
    try {
      await savePlayerRecord({ payload: dupPrompt.payload, rodoPayload: dupPrompt.rodoPayload, targetId: null });
      finishSuccess("Dodano nowego zawodnika (bez scalania).");
    } catch (err) {
      setAlert({ type: "error", message: err.message });
    }
  };

  const mergeWithExistingCandidate = async (candidate) => {
    if (!candidate || !dupPrompt.payload) return;
    const mergedPayload = {
      first_name: pickExisting(candidate.first_name, dupPrompt.payload.first_name),
      last_name: pickExisting(candidate.last_name, dupPrompt.payload.last_name),
      position: pickExisting(candidate.position, dupPrompt.payload.position) || "POM",
      birth_year: pickExisting(candidate.birth_year, dupPrompt.payload.birth_year),
      preferred_foot: pickExisting(candidate.preferred_foot, dupPrompt.payload.preferred_foot),
      photo_url: pickExisting(candidate.photo_url, dupPrompt.payload.photo_url),
      city: pickExisting(candidate.city, dupPrompt.payload.city),
      is_active: Boolean(candidate.is_active || dupPrompt.payload.is_active),
    };

    const currentPrivate = privateRow(candidate);
    const mergedRodo = {
      date_of_birth: pickExisting(currentPrivate?.date_of_birth, dupPrompt.rodoPayload?.date_of_birth),
      phone: pickExisting(currentPrivate?.phone, dupPrompt.rodoPayload?.phone),
      email: pickExisting(currentPrivate?.email, dupPrompt.rodoPayload?.email),
      address: pickExisting(currentPrivate?.address, dupPrompt.rodoPayload?.address),
      rodo_consent_date: pickExisting(currentPrivate?.rodo_consent_date, dupPrompt.rodoPayload?.rodo_consent_date),
      rodo_consent_type: pickExisting(currentPrivate?.rodo_consent_type, dupPrompt.rodoPayload?.rodo_consent_type),
      notes: pickExisting(currentPrivate?.notes, dupPrompt.rodoPayload?.notes),
    };

    try {
      await savePlayerRecord({ payload: mergedPayload, rodoPayload: mergedRodo, targetId: candidate.id });
      finishSuccess("Wykryto duplikat. Użyto istniejącego zawodnika i uzupełniono dane.");
    } catch (err) {
      setAlert({ type: "error", message: err.message });
    }
  };

  const resetForm = () => {
    setForm({
      first_name: "", last_name: "", position: "POM", birth_year: "",
      preferred_foot: "", photo_url: "", city: "", is_active: true,
    });
    setRodoForm({
      date_of_birth: "", phone: "", email: "", address: "",
      rodo_consent_date: "", rodo_consent_type: "", notes: "",
    });
    setShowRodo(false);
  };

  const handleEdit = (player) => {
    setForm({
      first_name: player.first_name || "",
      last_name: player.last_name || "",
      position: player.position || "POM",
      birth_year: player.birth_year || "",
      preferred_foot: player.preferred_foot || "",
      photo_url: player.photo_url || "",
      city: player.city || "",
      is_active: player.is_active,
    });
    const priv = player.players_private;
    setRodoForm({
      date_of_birth: priv?.date_of_birth || "",
      phone: priv?.phone || "",
      email: priv?.email || "",
      address: priv?.address || "",
      rodo_consent_date: priv?.rodo_consent_date || "",
      rodo_consent_type: priv?.rodo_consent_type || "",
      notes: priv?.notes || "",
    });
    setEditId(player.id);
    setShowForm(true);
  };

  const handleDelete = async (player) => {
    if (!window.confirm(`Dezaktywować zawodnika ${player.display_name}?`)) return;
    const { error } = await supabase.from("players").update({ is_active: false }).eq("id", player.id);
    if (error) {
      setAlert({ type: "error", message: error.message });
    } else {
      setAlert({ type: "success", message: "Zawodnik dezaktywowany" });
      loadData();
    }
  };

  const handleRelease = async (player) => {
    const info = playerTeams[player.id];
    if (!info) {
      setAlert({ type: "error", message: "Ten zawodnik nie jest przypisany do żadnej drużyny." });
      return;
    }
    if (!window.confirm(`Zwolnić ${player.display_name} z drużyny ${info.team_name}? Zawodnik stanie się wolnym zawodnikiem.`)) return;
    setReleasingId(player.id);
    try {
      const { error } = await supabase
        .from("team_players")
        .update({ left_date: new Date().toISOString().split("T")[0] })
        .eq("player_id", player.id)
        .is("left_date", null);
      if (error) throw error;
      setAlert({ type: "success", message: `${player.display_name} został zwolniony z ${info.team_name}. Jest teraz wolnym zawodnikiem.` });
      loadData();
    } catch (err) {
      setAlert({ type: "error", message: err.message || "Nie udało się zwolnić zawodnika." });
    } finally {
      setReleasingId(null);
    }
  };

  const positionLabels = { BR: "Bramkarz", OBR: "Obrońca", POM: "Pomocnik", NAP: "Napastnik" };

  const columns = [
    {
      key: "photo_url", label: "",
      render: (v) => v ? <img src={v} alt="" className="w-8 h-8 object-cover rounded-full" /> : <div className="w-8 h-8 rounded-full bg-gray-700/50" />
    },
    { key: "last_name", label: "Nazwisko", sortable: true },
    { key: "first_name", label: "Imię", sortable: true },
    {
      key: "position", label: "Pozycja", sortable: true,
      render: (v) => positionLabels[v] || v
    },
    { key: "birth_year", label: "Rocznik", sortable: true },
    { key: "city", label: "Miasto", sortable: true },
    {
      key: "id", label: "Drużyna",
      render: (_, row) => {
        const info = playerTeams[row?.id];
        if (!info) return <span className={`text-xs ${textMuted}`}>Wolny</span>;
        return <span className="text-xs font-medium">{info.team_name}</span>;
      }
    },
    {
      key: "is_active", label: "Status",
      render: (v) => v
        ? <span className="text-green-400 text-xs font-medium">Aktywny</span>
        : <span className="text-red-400 text-xs font-medium">Nieaktywny</span>
    },
  ];

  const filtered = search
    ? players.filter(p =>
        `${p.first_name} ${p.last_name}`.toLowerCase().includes(search.toLowerCase()) ||
        p.city?.toLowerCase().includes(search.toLowerCase())
      )
    : players;

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-2 border-yellow-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <h2 className="text-2xl font-bold">Zawodnicy</h2>
          <p className={`text-sm ${textMuted}`}>{players.filter((p) => p.is_active).length} aktywnych z {players.length}</p>
        </div>
        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={() => setShowMergePicker(true)}
            className={`flex items-center gap-2 px-4 py-2 rounded-xl border font-medium text-sm transition-colors ${
              darkMode ? "border-white/10 text-gray-300 hover:bg-white/5" : "border-gray-200 text-gray-700 hover:bg-gray-50"
            }`}
          >
            <GitMerge size={16} /> Scalaj
            {duplicateGroups.length > 0 && (
              <span className={`px-2 py-0.5 rounded-full text-xs ${darkMode ? "bg-orange-500/15 text-orange-300" : "bg-orange-100 text-orange-700"}`}>
                {duplicateGroups.length}
              </span>
            )}
          </button>
          <button
            onClick={() => { resetForm(); setEditId(null); setShowForm(true); }}
            className="flex items-center gap-2 px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors text-sm"
          >
            <Plus size={16} /> Dodaj zawodnika
          </button>
        </div>
      </div>

      <AdminAlert type={alert.type} message={alert.message} onClose={() => setAlert({ type: null, message: null })} />

      {/* Search */}
      <input
        type="text"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        placeholder="Szukaj zawodnika..."
        className={`w-full max-w-sm px-4 py-2 rounded-xl border outline-none ${
          darkMode ? "bg-white/5 border-white/10 text-white placeholder-gray-500" : "bg-white border-gray-300 text-gray-900"
        }`}
      />

      <div className={`rounded-2xl border overflow-hidden ${card}`}>
        <AdminTable
          columns={columns}
          rows={filtered}
          darkMode={darkMode}
          onEdit={handleEdit}
          onDelete={handleDelete}
          extraActions={(row) => playerTeams[row.id] ? (
            <button
              onClick={() => handleRelease(row)}
              disabled={releasingId === row.id}
              className="p-1.5 rounded-lg hover:bg-orange-500/20 text-orange-400"
              title={`Zwolnij z ${playerTeams[row.id]?.team_name}`}
            >
              <UserMinus size={15} />
            </button>
          ) : null}
          emptyMessage="Brak zawodników"
        />
      </div>

      {/* Player merge - duplicate groups picker */}
      <AdminModal
        isOpen={showMergePicker}
        onClose={() => {
          setShowMergePicker(false);
          setMergeDupSearch("");
        }}
        title="Scalaj zawodników - wykryte duplikaty"
        darkMode={darkMode}
        xwide
      >
        <div className="space-y-4">
          <div className={`rounded-xl border p-3 ${darkMode ? "border-orange-500/30 bg-orange-500/5" : "border-orange-200 bg-orange-50"}`}>
            <div className="flex items-start gap-2">
              <AlertTriangle size={16} className="text-orange-400 mt-0.5 shrink-0" />
              <div>
                <div className="text-sm font-medium">Kandydaci do duplikatów po imieniu i nazwisku</div>
                <div className={`text-xs ${textMuted}`}>
                  Kliknij grupę, aby zobaczyć porównanie rekordów i statystyk sezonowych. To pomaga odróżnić duplikat od zbieżności danych.
                </div>
              </div>
            </div>
          </div>

          <div className="flex flex-col md:flex-row md:items-center gap-3">
            <input
              type="text"
              value={mergeDupSearch}
              onChange={(e) => setMergeDupSearch(e.target.value)}
              placeholder="Szukaj grup duplikatów (imię / nazwisko / miasto)"
              className={`w-full md:flex-1 px-3 py-2 rounded-xl border text-sm outline-none ${
                darkMode
                  ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500"
                  : "bg-white border-gray-300 text-gray-900 placeholder:text-gray-400"
              }`}
            />
            <div className={`text-xs px-3 py-2 rounded-xl border ${darkMode ? "border-white/10 bg-white/5 text-gray-300" : "border-gray-200 bg-gray-50 text-gray-600"}`}>
              grup: {filteredMergeDuplicateGroups.length}
            </div>
          </div>

          <div className={`rounded-xl border p-2 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
            <div className="space-y-2 max-h-[52vh] overflow-y-auto pr-1">
              {filteredMergeDuplicateGroups.length > 0 ? filteredMergeDuplicateGroups.map((group, idx) => (
                <button
                  key={`dup-player-group-${idx}-${group[0]?.id || "x"}`}
                  type="button"
                  onClick={() => {
                    setShowMergePicker(false);
                    openMergeComparisonForGroup(group);
                  }}
                  className={`w-full text-left rounded-xl border p-3 transition-colors ${
                    darkMode ? "border-white/10 bg-black/10 hover:bg-white/5" : "border-gray-200 bg-white hover:bg-gray-50"
                  }`}
                >
                  <div className="flex items-start justify-between gap-3">
                    <div className="min-w-0">
                      <div className="font-semibold truncate">{group[0]?.display_name} <span className={`text-xs ${textMuted}`}>({group.length} wpisy)</span></div>
                      <div className={`text-xs mt-1 ${textMuted}`}>
                        {group.map((p) => `${p.birth_year || "brak rocznika"}${p.city ? `, ${p.city}` : ""}`).slice(0, 4).join(" | ")}
                      </div>
                    </div>
                    <span className={`text-xs px-2 py-1 rounded ${darkMode ? "bg-orange-500/10 text-orange-300" : "bg-orange-100 text-orange-700"}`}>
                      Porównaj
                    </span>
                  </div>
                </button>
              )) : (
                <div className={`text-sm text-center py-6 ${textMuted}`}>Brak grup duplikatów dla tej frazy.</div>
              )}
            </div>
          </div>

          <div className="flex justify-end">
            <button
              type="button"
              onClick={() => { setShowMergePicker(false); setMergeDupSearch(""); }}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}
            >
              Zamknij
            </button>
          </div>
        </div>
      </AdminModal>

      {/* Player merge - comparison view */}
      <AdminModal
        isOpen={showMergeCompare}
        onClose={closePlayerMergeFlow}
        title="Scalaj zawodników - porównanie rekordów"
        darkMode={darkMode}
        xwide
      >
        <div className="space-y-4">
          <div className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
            <div className="text-sm font-medium mb-1">Jak czytać to porównanie?</div>
            <div className={`text-xs ${textMuted}`}>
              Wybierz rekord docelowy (ten zostaje w bazie), a potem porównaj sezony, kluby i statystyki. Jeśli to ta sama osoba, kliknij "Scalaj zawodników".
              Pole "Wzrost" jest pokazane jako pomocnicze, ale obecnie baza nie przechowuje tego parametru.
            </div>
          </div>

          {mergeGroup.length > 0 && (
            <div className="space-y-2">
              <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Który rekord zostaje jako zawodnik docelowy?</label>
              <div className={`rounded-xl border p-2 max-h-40 overflow-y-auto space-y-1 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
                {mergeGroup.map((p) => (
                  <label key={`target-player-${p.id}`} className={`flex items-center gap-2 px-2 py-1 rounded cursor-pointer text-sm ${darkMode ? "hover:bg-white/5" : "hover:bg-white"}`}>
                    <input
                      type="radio"
                      name="mergeTargetPlayer"
                      checked={String(mergeTargetId) === String(p.id)}
                      onChange={() => setMergeTargetId(p.id)}
                      className="w-4 h-4"
                    />
                    <span className={p.is_active ? "text-green-400 text-xs" : "text-red-400 text-xs"}>
                      {p.is_active ? "Aktywny" : "Nieaktywny"}
                    </span>
                    <span className="truncate">{p.display_name}</span>
                    <span className={`text-xs ml-auto ${textMuted}`}>{positionLabels[p.position] || p.position}</span>
                  </label>
                ))}
              </div>
            </div>
          )}

          <div className="space-y-2">
            <div className="flex items-center justify-between gap-3">
              <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>
                Jak łączyć statystyki sezonowe?
              </label>
              <button
                type="button"
                onClick={() => setMergeStatStrategy(DEFAULT_PLAYER_MERGE_STAT_STRATEGY)}
                className={`text-xs px-2 py-1 rounded border ${darkMode ? "border-white/10 text-gray-300 hover:bg-white/5" : "border-gray-200 text-gray-700 hover:bg-gray-50"}`}
              >
                Przywróć domyślne (sumuj)
              </button>
            </div>
            <div className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
              <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-3">
                {PLAYER_MERGE_STAT_FIELDS.map((field) => (
                  <div key={`merge-stat-strategy-${field.key}`} className="space-y-1">
                    <div className={`text-xs font-semibold ${textMuted}`}>{field.label}</div>
                    <select
                      value={mergeStatStrategy[field.key] || "sum"}
                      onChange={(e) =>
                        setMergeStatStrategy((prev) => ({
                          ...prev,
                          [field.key]: e.target.value,
                        }))
                      }
                      className={`w-full px-3 py-2 rounded-xl border text-sm outline-none ${
                        darkMode
                          ? "bg-black/20 border-white/10 text-white"
                          : "bg-white border-gray-300 text-gray-900"
                      }`}
                    >
                      <option value="sum">Sumuj rekordy</option>
                      <option value="overwrite">Nadpisz wartością rekordu docelowego</option>
                    </select>
                  </div>
                ))}
              </div>
              <div className={`text-xs mt-3 ${textMuted}`}>
                "Nadpisz" = po scaleniu zostanie wartość z rekordu docelowego (zachowamy tylko brakujące sezony z pozostałych wpisów).
              </div>
            </div>
          </div>

          {mergeLoadingStats ? (
            <div className="flex items-center justify-center py-10">
              <div className="w-7 h-7 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
            </div>
          ) : (
            <div className="grid grid-cols-1 xl:grid-cols-2 gap-4">
              {mergeGroup.map((p) => {
                const statsRows = mergeGroupStats[p.id] || [];
                const age = calcAge(p.birth_year);
                return (
                  <div key={`compare-player-${p.id}`} className={`rounded-2xl border p-4 space-y-3 ${darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-white"}`}>
                    <div className="flex items-start justify-between gap-3">
                      <div className="min-w-0">
                        <div className="font-semibold truncate">{p.display_name}</div>
                        <div className={`text-xs ${textMuted}`}>
                          ID: {String(p.id).slice(0, 8)}... {String(mergeTargetId) === String(p.id) ? "• DOCELOWY" : ""}
                        </div>
                      </div>
                      <span className={`text-xs px-2 py-1 rounded ${p.is_active ? "bg-green-500/10 text-green-400" : "bg-red-500/10 text-red-400"}`}>
                        {p.is_active ? "Aktywny" : "Nieaktywny"}
                      </span>
                    </div>

                    <div className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-100 bg-gray-50"}`}>
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-sm">
                        <div>Imię: <span className="font-medium">{p.first_name || "-"}</span></div>
                        <div>Nazwisko: <span className="font-medium">{p.last_name || "-"}</span></div>
                        <div>Wiek: <span className="font-medium">{age ?? "brak"}</span></div>
                        <div>Wzrost: <span className="font-medium">brak pola w bazie</span></div>
                        <div>Pozycja: <span className="font-medium">{positionLabels[p.position] || p.position || "-"}</span></div>
                        <div>Rocznik: <span className="font-medium">{p.birth_year || "brak"}</span></div>
                        <div>Miasto: <span className="font-medium">{p.city || "brak"}</span></div>
                        <div>Noga: <span className="font-medium">{p.preferred_foot || "brak"}</span></div>
                      </div>
                    </div>

                    <div className="space-y-2">
                      <div className="text-sm font-medium">Statystyki sezonowe / rekordy klubowe</div>
                      {statsRows.length > 0 ? (
                        <div className="overflow-x-auto">
                          <table className="w-full text-xs min-w-[620px]">
                            <thead>
                              <tr className={darkMode ? "text-gray-400" : "text-gray-500"}>
                                <th className="text-left py-1 pr-2">Sezon</th>
                                <th className="text-left py-1 pr-2">Liga</th>
                                <th className="text-left py-1 pr-2">Klub</th>
                                <th className="text-right py-1 px-1">Wyst.</th>
                                <th className="text-right py-1 px-1">Gole</th>
                                <th className="text-right py-1 px-1">As.</th>
                                <th className="text-right py-1 px-1">ZK</th>
                                <th className="text-right py-1 pl-1">CK</th>
                              </tr>
                            </thead>
                            <tbody>
                              {statsRows.map((r, idx) => (
                                <tr key={`${p.id}-${idx}-${r.season_id || "s"}-${r.team_id || "t"}`} className={`border-t ${darkMode ? "border-white/10" : "border-gray-100"}`}>
                                  <td className="py-1 pr-2">{r.season_year || "-"}</td>
                                  <td className="py-1 pr-2">{r.league_code || "-"}</td>
                                  <td className="py-1 pr-2">{r.team_name || "-"}</td>
                                  <td className="py-1 px-1 text-right">{r.appearances ?? 0}</td>
                                  <td className="py-1 px-1 text-right">{r.goals ?? 0}</td>
                                  <td className="py-1 px-1 text-right">{r.assists ?? 0}</td>
                                  <td className="py-1 px-1 text-right">{r.yellow_cards ?? 0}</td>
                                  <td className="py-1 pl-1 text-right">{r.red_cards ?? 0}</td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                      ) : (
                        <div className={`text-xs ${textMuted}`}>Brak rekordów sezonowych/statystyk dla tego wpisu.</div>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          )}

          <div className="flex justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={() => { setShowMergeCompare(false); setShowMergePicker(true); }}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}
            >
              Wróć
            </button>
            <button
              type="button"
              onClick={closePlayerMergeFlow}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}
            >
              Anuluj
            </button>
            <button
              type="button"
              onClick={executeMergePlayersGroup}
              disabled={mergeBusy || !mergeTargetId || mergeGroup.filter((p) => String(p.id) !== String(mergeTargetId)).length === 0}
              className="px-4 py-2 rounded-xl bg-orange-500 text-black font-medium text-sm hover:bg-orange-400 disabled:opacity-40 disabled:cursor-not-allowed"
            >
              {mergeBusy ? "Scalanie..." : "Scalaj zawodników"}
            </button>
          </div>
        </div>
      </AdminModal>

      {/* Add-form duplicate prompt */}
      <AdminModal isOpen={dupPrompt.open} onClose={() => setDupPrompt({ open: false, payload: null, rodoPayload: null, candidates: [] })} title="Możliwy duplikat zawodnika" darkMode={darkMode} wide>
        <div className="space-y-4">
          <div className={`rounded-xl border p-3 ${darkMode ? "border-orange-500/30 bg-orange-500/5" : "border-orange-200 bg-orange-50"}`}>
            <div className="text-sm font-medium mb-1">System wykrył podobny wpis</div>
            <div className={`text-xs ${textMuted}`}>
              Jeśli to ta sama osoba, kliknij "Scal - to ten sam zawodnik". Nie utworzymy wtedy nowego rekordu.
            </div>
          </div>

          {dupPrompt.payload && (
            <div className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
              <div className="text-xs font-semibold text-yellow-400 mb-2">NOWY WPIS (z formularza)</div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-2 text-sm">
                <div>Imię i nazwisko: <span className="font-medium">{dupPrompt.payload.first_name} {dupPrompt.payload.last_name}</span></div>
                <div>Pozycja: <span className="font-medium">{positionLabels[dupPrompt.payload.position] || dupPrompt.payload.position}</span></div>
                <div>Rocznik: <span className="font-medium">{dupPrompt.payload.birth_year || "brak"}</span></div>
                <div>Miasto: <span className="font-medium">{dupPrompt.payload.city || "brak"}</span></div>
              </div>
            </div>
          )}

          <div className="space-y-2">
            {dupPrompt.candidates.map((match) => {
              const candidate = match.player || match;
              const priv = privateRow(candidate);
              const teamInfo = playerTeams[candidate.id];
              return (
                <div key={candidate.id} className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-white"}`}>
                  <div className="flex items-start justify-between gap-2">
                    <div className="min-w-0">
                      <div className="font-semibold truncate">{candidate.display_name}</div>
                      {match.reason && (
                        <div className={`text-xs mt-0.5 ${match.distance === 0 ? "text-red-400" : "text-orange-400"}`}>
                          {match.reason}
                        </div>
                      )}
                      <div className={`text-xs ${textMuted} mt-1`}>
                        {candidate.is_active ? "Aktywny" : "Nieaktywny"} • {positionLabels[candidate.position] || candidate.position} • {candidate.birth_year || "brak rocznika"}
                      </div>
                      <div className={`text-xs ${textMuted}`}>
                        Drużyna: {teamInfo ? teamInfo.team_name : "Wolny"} • Miasto: {candidate.city || "brak"}
                      </div>
                    </div>
                    <button
                      type="button"
                      onClick={() => mergeWithExistingCandidate(candidate)}
                      className="px-3 py-1.5 rounded-lg bg-orange-500 text-black text-xs font-semibold hover:bg-orange-400 shrink-0"
                    >
                      To ten sam - kontynuuj karierę
                    </button>
                  </div>
                </div>
              );
            })}
          </div>

          <div className="flex justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={() => setDupPrompt({ open: false, payload: null, rodoPayload: null, candidates: [] })}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}
            >
              Wróć do edycji
            </button>
            <button
              type="button"
              onClick={continueCreateWithoutMerge}
              className="px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium text-sm hover:bg-yellow-400"
            >
              Nie scalaj - to nie ten sam zawodnik
            </button>
          </div>
        </div>
      </AdminModal>

      {/* Form modal */}
      <AdminModal isOpen={showForm} onClose={() => setShowForm(false)} title={editId ? "Edytuj zawodnika" : "Nowy zawodnik"} darkMode={darkMode} wide>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <AdminFormField label="Imię" name="first_name" value={form.first_name} onChange={handleChange} required darkMode={darkMode} />
            <AdminFormField label="Nazwisko" name="last_name" value={form.last_name} onChange={handleChange} required darkMode={darkMode} />
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <AdminFormField label="Pozycja" name="position" type="select" value={form.position} onChange={handleChange} required darkMode={darkMode}
              options={[
                { value: "BR", label: "Bramkarz" },
                { value: "OBR", label: "Obrońca" },
                { value: "POM", label: "Pomocnik" },
                { value: "NAP", label: "Napastnik" },
              ]}
            />
            <AdminFormField label="Rocznik" name="birth_year" type="number" value={form.birth_year} onChange={handleChange} darkMode={darkMode} min={1960} max={2015} />
            <AdminFormField label="Noga" name="preferred_foot" type="select" value={form.preferred_foot} onChange={handleChange} darkMode={darkMode}
              options={[
                { value: "Prawa", label: "Prawa" },
                { value: "Lewa", label: "Lewa" },
                { value: "Obie", label: "Obie" },
              ]}
            />
          </div>
          <AdminFormField label="Miasto" name="city" value={form.city} onChange={handleChange} darkMode={darkMode} />
          <AdminImageUpload
            bucket="player-photos"
            folder="photos"
            currentUrl={form.photo_url}
            onUpload={(url) => setForm(f => ({ ...f, photo_url: url }))}
            darkMode={darkMode}
            label="Zdjęcie zawodnika"
          />
          <AdminFormField label="Aktywny" name="is_active" type="checkbox" value={form.is_active} onChange={handleChange} darkMode={darkMode} />

          {/* RODO section */}
          <div className={`border rounded-xl p-4 ${darkMode ? "border-red-500/30 bg-red-500/5" : "border-red-200 bg-red-50"}`}>
            <button type="button" onClick={() => setShowRodo(v => !v)}
              className="flex items-center gap-2 font-medium text-sm text-red-400 w-full"
            >
              <Lock size={14} />
              Dane RODO (chronione) {showRodo ? "\u25B2" : "\u25BC"}
            </button>
            {showRodo && (
              <div className="mt-4 space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <AdminFormField label="Data urodzenia" name="date_of_birth" type="date" value={rodoForm.date_of_birth} onChange={handleRodoChange} darkMode={darkMode} />
                  <AdminFormField label="Telefon" name="phone" value={rodoForm.phone} onChange={handleRodoChange} darkMode={darkMode} placeholder="+48..." />
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <AdminFormField label="Email" name="email" type="email" value={rodoForm.email} onChange={handleRodoChange} darkMode={darkMode} />
                  <AdminFormField label="Adres" name="address" value={rodoForm.address} onChange={handleRodoChange} darkMode={darkMode} />
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <AdminFormField label="Data zgody RODO" name="rodo_consent_date" type="date" value={rodoForm.rodo_consent_date} onChange={handleRodoChange} darkMode={darkMode} />
                  <AdminFormField label="Typ zgody" name="rodo_consent_type" type="select" value={rodoForm.rodo_consent_type} onChange={handleRodoChange} darkMode={darkMode}
                    options={[
                      { value: "full", label: "Pełna zgoda" },
                      { value: "stats_only", label: "Tylko statystyki" },
                      { value: "withdrawn", label: "Cofnięta" },
                    ]}
                  />
                </div>
                <AdminFormField label="Notatki" name="notes" type="textarea" value={rodoForm.notes} onChange={handleRodoChange} darkMode={darkMode} />
              </div>
            )}
          </div>

          <div className="flex justify-end gap-3 pt-2">
            <button type="button" onClick={() => setShowForm(false)} className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}>Anuluj</button>
            <button type="submit" className="px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium text-sm hover:bg-yellow-400">
              {editId ? "Zapisz" : "Dodaj zawodnika"}
            </button>
          </div>
        </form>
      </AdminModal>
    </div>
  );
}
