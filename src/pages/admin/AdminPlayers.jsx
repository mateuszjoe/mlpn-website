import React, { useState, useEffect, useCallback, useMemo } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminTable from "./components/AdminTable";
import AdminModal from "./components/AdminModal";
import AdminAlert from "./components/AdminAlert";
import AdminImageUpload from "./components/AdminImageUpload";
import { Plus, Lock, AlertTriangle, GitMerge, UserMinus, Unlink } from "lucide-react";

const ADMIN_PAGE_SIZE = 1000;

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

function mergedTargetId(player) {
  const notes = String(privateRow(player)?.notes || "");
  return notes.match(/\[MERGED_TO:([0-9a-f-]{36})\]/i)?.[1] || "";
}

function unwrapRelation(value) {
  return Array.isArray(value) ? value[0] : value;
}

function unmergeContextKey(context) {
  return `${context?.season_id || ""}|${context?.league_id || ""}|${context?.team_id || ""}`;
}

function mergeNotesBody(player) {
  const notes = String(privateRow(player)?.notes || "");
  return notes
    .replace(/\[MERGED_TO:[0-9a-f-]{36}\][^\n\r]*(\r?\n)?/gi, "")
    .trim();
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
  const [showUnmergePicker, setShowUnmergePicker] = useState(false);
  const [showUnmergeCompare, setShowUnmergeCompare] = useState(false);
  const [unmergeSearch, setUnmergeSearch] = useState("");
  const [unmergeSource, setUnmergeSource] = useState(null);
  const [unmergeTarget, setUnmergeTarget] = useState(null);
  const [unmergeContexts, setUnmergeContexts] = useState([]);
  const [unmergeSelectedKeys, setUnmergeSelectedKeys] = useState([]);
  const [unmergeLoading, setUnmergeLoading] = useState(false);
  const [unmergeBusy, setUnmergeBusy] = useState(false);
  const [showMergeEdit, setShowMergeEdit] = useState(false);
  const [mergeEditSource, setMergeEditSource] = useState(null);
  const [mergeEditForm, setMergeEditForm] = useState({
    target_id: "",
    first_name: "",
    last_name: "",
    position: "POM",
    birth_year: "",
    preferred_foot: "",
    photo_url: "",
    city: "",
    notes: "",
  });
  const [mergeEditBusy, setMergeEditBusy] = useState(false);
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
    try {
      const [playersRows, teamRows] = await Promise.all([
        fetchAllAdminRows((from, to) =>
          supabase
            .from("players")
            .select("*, players_private(*)")
            .order("last_name")
            .order("id")
            .range(from, to)
        ),
        fetchAllAdminRows((from, to) =>
          supabase
            .from("team_players")
            .select("id, player_id, team_id, season_id, joined_date, left_date, teams(name), seasons(year)")
            .is("left_date", null)
            .order("joined_date", { ascending: false })
            .order("id", { ascending: false })
            .range(from, to)
        ),
      ]);

      setPlayers(playersRows);

      // Build map: player_id -> { team_name, season_year, team_players_id }
      const teamsMap = {};
      for (const tp of teamRows) {
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
    } catch (error) {
      console.error("Nie udało się wczytać pełnej listy zawodników:", error);
      setPlayers([]);
      setPlayerTeams({});
      setAlert({ type: "error", message: "Nie udało się wczytać pełnej listy zawodników." });
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { loadData(); }, [loadData]);

  const visiblePlayers = useMemo(
    () => players.filter((player) => !isMergedPlayerRecord(player)),
    [players]
  );

  const playersById = useMemo(
    () => new Map(players.map((player) => [String(player.id), player])),
    [players]
  );

  const mergedPlayerRecords = useMemo(
    () => players.filter((player) => isMergedPlayerRecord(player)),
    [players]
  );

  const filteredUnmergeRecords = useMemo(() => {
    if (!unmergeSearch.trim()) return mergedPlayerRecords;
    const q = normalizePlayerKey(unmergeSearch, "");
    return mergedPlayerRecords.filter((player) => {
      const target = playersById.get(String(mergedTargetId(player)));
      const blob = [
        normalizePlayerKey(player.first_name, player.last_name),
        normalizePlayerKey(player.city || "", ""),
        normalizePlayerKey(target?.first_name, target?.last_name),
        normalizePlayerKey(target?.city || "", ""),
      ].join("");
      return blob.includes(q);
    });
  }, [mergedPlayerRecords, playersById, unmergeSearch]);

  const mergeEditTargetOptions = useMemo(
    () =>
      players
        .filter((player) => String(player.id) !== String(mergeEditSource?.id || ""))
        .filter((player) => !isMergedPlayerRecord(player) || String(player.id) === String(mergeEditForm.target_id || ""))
        .sort((a, b) =>
          String(a.last_name || "").localeCompare(String(b.last_name || ""), "pl") ||
          String(a.first_name || "").localeCompare(String(b.first_name || ""), "pl")
        )
        .map((player) => ({
          value: player.id,
          label: `${player.display_name || `${player.first_name} ${player.last_name}`}${player.birth_year ? ` (${player.birth_year})` : ""}${player.city ? ` - ${player.city}` : ""}`,
        })),
    [players, mergeEditSource, mergeEditForm.target_id]
  );

  const duplicateGroups = useMemo(() => {
    const groups = new Map();
    for (const p of visiblePlayers) {
      const key = normalizePlayerKey(p.first_name, p.last_name);
      if (!key) continue;
      if (!groups.has(key)) groups.set(key, []);
      groups.get(key).push(p);
    }
    return [...groups.values()]
      .filter((g) => g.length > 1)
      .map((g) => [...g].sort((a, b) => Number(b.is_active) - Number(a.is_active) || String(a.created_at || "").localeCompare(String(b.created_at || ""))))
      .sort((a, b) => b.length - a.length);
  }, [visiblePlayers]);

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

  const closePlayerUnmergeFlow = () => {
    setShowUnmergePicker(false);
    setShowUnmergeCompare(false);
    setUnmergeSearch("");
    setUnmergeSource(null);
    setUnmergeTarget(null);
    setUnmergeContexts([]);
    setUnmergeSelectedKeys([]);
    setUnmergeLoading(false);
    setUnmergeBusy(false);
  };

  const closeMergeEditFlow = () => {
    setShowMergeEdit(false);
    setMergeEditSource(null);
    setMergeEditForm({
      target_id: "",
      first_name: "",
      last_name: "",
      position: "POM",
      birth_year: "",
      preferred_foot: "",
      photo_url: "",
      city: "",
      notes: "",
    });
    setMergeEditBusy(false);
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

  const openUnmergeForSource = async (sourcePlayer) => {
    if (!sourcePlayer?.id) return;

    const targetId = mergedTargetId(sourcePlayer);
    const targetPlayer = playersById.get(String(targetId));
    if (!targetId || !targetPlayer) {
      setAlert({
        type: "error",
        message: "Nie udało się znaleźć zawodnika docelowego dla tego scalenia.",
      });
      return;
    }

    setShowUnmergePicker(false);
    setShowUnmergeCompare(true);
    setUnmergeSource(sourcePlayer);
    setUnmergeTarget(targetPlayer);
    setUnmergeContexts([]);
    setUnmergeSelectedKeys([]);
    setUnmergeLoading(true);

    try {
      const [teamRowsRes, statsRowsRes] = await Promise.all([
        supabase
          .from("team_players")
          .select("id, season_id, league_id, team_id, joined_date, left_date, is_captain, shirt_number, seasons(year), leagues(code, name), teams(name)")
          .eq("player_id", targetPlayer.id)
          .order("joined_date", { ascending: false }),
        supabase
          .from("player_season_stats")
          .select("id, season_id, league_id, team_id, appearances, goals, assists, yellow_cards, red_cards, seasons(year), leagues(code, name), teams(name)")
          .eq("player_id", targetPlayer.id),
      ]);

      throwIfError(teamRowsRes, "team_players unmerge select");
      throwIfError(statsRowsRes, "player_season_stats unmerge select");

      const statByExactKey = new Map();
      const statBySeasonLeague = new Map();
      for (const row of statsRowsRes.data || []) {
        const exactKey = unmergeContextKey(row);
        statByExactKey.set(exactKey, row);
        statBySeasonLeague.set(`${row.season_id || ""}|${row.league_id || ""}`, row);
      }

      const contextsByKey = new Map();
      const addContext = (row, source) => {
        if (!row?.season_id || !row?.league_id || !row?.team_id) return;

        const key = unmergeContextKey(row);
        const season = unwrapRelation(row.seasons);
        const league = unwrapRelation(row.leagues);
        const team = unwrapRelation(row.teams);
        const exactStats = statByExactKey.get(key);
        const seasonStats = statBySeasonLeague.get(`${row.season_id || ""}|${row.league_id || ""}`);
        const stats = exactStats || seasonStats || {};

        const current = contextsByKey.get(key) || {};
        contextsByKey.set(key, {
          key,
          season_id: row.season_id,
          league_id: row.league_id,
          team_id: row.team_id,
          season_year: current.season_year ?? season?.year ?? unwrapRelation(stats.seasons)?.year ?? null,
          league_code: current.league_code ?? league?.code ?? unwrapRelation(stats.leagues)?.code ?? "",
          league_name: current.league_name ?? league?.name ?? unwrapRelation(stats.leagues)?.name ?? "",
          team_name: current.team_name ?? team?.name ?? unwrapRelation(stats.teams)?.name ?? "",
          joined_date: current.joined_date ?? row.joined_date ?? null,
          left_date: current.left_date ?? row.left_date ?? null,
          appearances: Number(stats.appearances || 0),
          goals: Number(stats.goals || 0),
          assists: Number(stats.assists || 0),
          yellow_cards: Number(stats.yellow_cards || 0),
          red_cards: Number(stats.red_cards || 0),
          has_exact_stats: !!exactStats,
          source: current.source === "team_players" ? current.source : source,
        });
      };

      for (const row of teamRowsRes.data || []) addContext(row, "team_players");
      for (const row of statsRowsRes.data || []) addContext(row, "player_season_stats");

      const contexts = [...contextsByKey.values()].sort((a, b) =>
        Number(b.season_year || 0) - Number(a.season_year || 0) ||
        String(a.league_code || "").localeCompare(String(b.league_code || ""), "pl") ||
        String(a.team_name || "").localeCompare(String(b.team_name || ""), "pl")
      );

      setUnmergeContexts(contexts);
    } catch (err) {
      setAlert({
        type: "error",
        message: err.message || "Nie udało się przygotować odscalania zawodnika.",
      });
    } finally {
      setUnmergeLoading(false);
    }
  };

  const openMergeEditForSource = (sourcePlayer) => {
    if (!sourcePlayer?.id) return;

    const targetId = mergedTargetId(sourcePlayer);
    setMergeEditSource(sourcePlayer);
    setMergeEditForm({
      target_id: targetId,
      first_name: sourcePlayer.first_name || "",
      last_name: sourcePlayer.last_name || "",
      position: sourcePlayer.position || "POM",
      birth_year: sourcePlayer.birth_year || "",
      preferred_foot: sourcePlayer.preferred_foot || "",
      photo_url: sourcePlayer.photo_url || "",
      city: sourcePlayer.city || "",
      notes: mergeNotesBody(sourcePlayer),
    });
    setShowUnmergePicker(false);
    setShowMergeEdit(true);
  };

  const updateMergeEditField = (event) => {
    const { name, value } = event.target;
    setMergeEditForm((current) => ({ ...current, [name]: value }));
  };

  const saveMergeEdit = async (event) => {
    event.preventDefault();
    if (!mergeEditSource?.id) return;

    const targetId = mergeEditForm.target_id;
    if (!targetId || String(targetId) === String(mergeEditSource.id)) {
      setAlert({ type: "error", message: "Wybierz prawidłowy rekord docelowy scalenia." });
      return;
    }

    const firstName = String(mergeEditForm.first_name || "").trim();
    const lastName = String(mergeEditForm.last_name || "").trim();
    if (!firstName || !lastName) {
      setAlert({ type: "error", message: "Imię i nazwisko scalonego rekordu są wymagane." });
      return;
    }

    setMergeEditBusy(true);
    try {
      const playerPayload = {
        first_name: firstName,
        last_name: lastName,
        position: mergeEditForm.position || "POM",
        birth_year: mergeEditForm.birth_year ? parseInt(mergeEditForm.birth_year, 10) : null,
        preferred_foot: mergeEditForm.preferred_foot || null,
        photo_url: mergeEditForm.photo_url || null,
        city: mergeEditForm.city || null,
        is_active: false,
      };

      throwIfError(
        await supabase.from("players").update(playerPayload).eq("id", mergeEditSource.id),
        "players merged source update"
      );

      const marker = `[MERGED_TO:${targetId}] ${new Date().toISOString()}`;
      const cleanNotes = String(mergeEditForm.notes || "").trim();
      throwIfError(
        await supabase
          .from("players_private")
          .upsert(
            {
              player_id: mergeEditSource.id,
              notes: cleanNotes ? `${marker}\n${cleanNotes}` : marker,
            },
            { onConflict: "player_id" }
          ),
        "players_private merged marker update"
      );

      setAlert({
        type: "success",
        message: "Scalenie zostało poprawione. Jeśli trzeba przenieść historię meczową, użyj odscalania zakresu.",
      });
      closeMergeEditFlow();
      loadData();
    } catch (err) {
      setAlert({ type: "error", message: err.message || "Nie udało się zapisać edycji scalenia." });
    } finally {
      setMergeEditBusy(false);
    }
  };

  const toggleUnmergeContext = (key) => {
    setUnmergeSelectedKeys((current) =>
      current.includes(key) ? current.filter((item) => item !== key) : [...current, key]
    );
  };

  const executeUnmergePlayers = async () => {
    if (!unmergeSource?.id || !unmergeTarget?.id) return;

    const selectedContexts = unmergeContexts
      .filter((context) => unmergeSelectedKeys.includes(context.key))
      .map((context) => ({
        season_id: context.season_id,
        league_id: context.league_id,
        team_id: context.team_id,
      }));

    if (selectedContexts.length === 0) {
      setAlert({ type: "error", message: "Wybierz co najmniej jeden sezon/drużynę do odscalenia." });
      return;
    }

    const confirmed = window.confirm(
      `Odscalić ${unmergeSource.display_name} z rekordu ${unmergeTarget.display_name} i przenieść ${selectedContexts.length} wybranych zakresów?`
    );
    if (!confirmed) return;

    setUnmergeBusy(true);
    try {
      const { data, error } = await supabase.rpc("unmerge_player_contexts", {
        p_source_player_id: unmergeSource.id,
        p_target_player_id: unmergeTarget.id,
        p_contexts: selectedContexts,
      });
      if (error) throw error;

      const result = Array.isArray(data) ? data[0] || {} : data || {};
      const movedBits = [
        `${result.team_rows || 0} wpisów kadry`,
        `${result.stat_rows || 0} statystyk sezonowych`,
        `${result.lineup_rows || 0} składów`,
        `${result.event_rows || 0} zdarzeń`,
        `${result.assist_rows || 0} asyst`,
        `${result.suspension_rows || 0} pauz`,
        `${result.mvp_rows || 0} MVP`,
      ].join(", ");

      setAlert({
        type: "success",
        message: `Odscalono zawodnika ${unmergeSource.display_name}. Przeniesiono: ${movedBits}.`,
      });
      closePlayerUnmergeFlow();
      loadData();
    } catch (err) {
      setAlert({
        type: "error",
        message: err.message || "Nie udało się odscalić zawodnika.",
      });
    } finally {
      setUnmergeBusy(false);
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
    ? visiblePlayers.filter(p =>
        `${p.first_name} ${p.last_name}`.toLowerCase().includes(search.toLowerCase()) ||
        p.city?.toLowerCase().includes(search.toLowerCase())
      )
    : visiblePlayers;

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
          <p className={`text-sm ${textMuted}`}>{visiblePlayers.filter((p) => p.is_active).length} aktywnych z {visiblePlayers.length}</p>
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
            type="button"
            onClick={() => setShowUnmergePicker(true)}
            className={`flex items-center gap-2 px-4 py-2 rounded-xl border font-medium text-sm transition-colors ${
              darkMode ? "border-white/10 text-gray-300 hover:bg-white/5" : "border-gray-200 text-gray-700 hover:bg-gray-50"
            }`}
          >
            <Unlink size={16} /> Odscalaj
            {mergedPlayerRecords.length > 0 && (
              <span className={`px-2 py-0.5 rounded-full text-xs ${darkMode ? "bg-blue-500/15 text-blue-300" : "bg-blue-100 text-blue-700"}`}>
                {mergedPlayerRecords.length}
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

      {/* Player unmerge - merged records picker */}
      <AdminModal
        isOpen={showUnmergePicker}
        onClose={() => {
          setShowUnmergePicker(false);
          setUnmergeSearch("");
        }}
        title="Odscalaj zawodników"
        darkMode={darkMode}
        xwide
      >
        <div className="space-y-4">
          <div className={`rounded-xl border p-3 ${darkMode ? "border-blue-500/30 bg-blue-500/5" : "border-blue-200 bg-blue-50"}`}>
            <div className="flex items-start gap-2">
              <AlertTriangle size={16} className="text-blue-400 mt-0.5 shrink-0" />
              <div>
                <div className="text-sm font-medium">Przywracanie rekordu po omyłkowym scaleniu</div>
                <div className={`text-xs ${textMuted}`}>
                  Wybierz nieaktywny rekord oznaczony jako scalony, a potem wskaż sezony i drużyny, które mają wrócić na tego zawodnika.
                </div>
              </div>
            </div>
          </div>

          <div className="flex flex-col md:flex-row md:items-center gap-3">
            <input
              type="text"
              value={unmergeSearch}
              onChange={(e) => setUnmergeSearch(e.target.value)}
              placeholder="Szukaj po zawodniku odscalanym albo docelowym"
              className={`w-full md:flex-1 px-3 py-2 rounded-xl border text-sm outline-none ${
                darkMode
                  ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500"
                  : "bg-white border-gray-300 text-gray-900 placeholder:text-gray-400"
              }`}
            />
            <div className={`text-xs px-3 py-2 rounded-xl border ${darkMode ? "border-white/10 bg-white/5 text-gray-300" : "border-gray-200 bg-gray-50 text-gray-600"}`}>
              rekordów: {filteredUnmergeRecords.length}
            </div>
          </div>

          <div className={`rounded-xl border p-2 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
            <div className="space-y-2 max-h-[52vh] overflow-y-auto pr-1">
              {filteredUnmergeRecords.length > 0 ? filteredUnmergeRecords.map((player) => {
                const target = playersById.get(String(mergedTargetId(player)));
                return (
                  <div
                    key={`unmerge-player-${player.id}`}
                    className={`rounded-xl border p-3 ${
                      darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-white"
                    }`}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div className="min-w-0">
                        <div className="font-semibold truncate">{player.display_name}</div>
                        <div className={`text-xs mt-1 ${textMuted}`}>
                          scalony do: {target?.display_name || "nie znaleziono rekordu docelowego"}
                        </div>
                        <div className={`text-xs mt-1 ${textMuted}`}>
                          {player.birth_year || "brak rocznika"}{player.city ? `, ${player.city}` : ""} • ID {String(player.id).slice(0, 8)}...
                        </div>
                      </div>
                      <div className="flex flex-col sm:flex-row gap-2 shrink-0">
                        <button
                          type="button"
                          onClick={() => openMergeEditForSource(player)}
                          className={`text-xs px-3 py-1.5 rounded-lg border font-medium ${
                            darkMode ? "border-white/10 text-gray-300 hover:bg-white/5" : "border-gray-200 text-gray-700 hover:bg-gray-50"
                          }`}
                        >
                          Edytuj scalenie
                        </button>
                        <button
                          type="button"
                          onClick={() => openUnmergeForSource(player)}
                          className={`text-xs px-3 py-1.5 rounded-lg font-medium ${darkMode ? "bg-blue-500/10 text-blue-300 hover:bg-blue-500/20" : "bg-blue-100 text-blue-700 hover:bg-blue-200"}`}
                        >
                          Wybierz zakres
                        </button>
                      </div>
                    </div>
                  </div>
                );
              }) : (
                <div className={`text-sm text-center py-6 ${textMuted}`}>Brak scalonych rekordów dla tej frazy.</div>
              )}
            </div>
          </div>

          <div className="flex justify-end">
            <button
              type="button"
              onClick={() => { setShowUnmergePicker(false); setUnmergeSearch(""); }}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}
            >
              Zamknij
            </button>
          </div>
        </div>
      </AdminModal>

      {/* Player merge edit */}
      <AdminModal
        isOpen={showMergeEdit}
        onClose={closeMergeEditFlow}
        title="Edytuj scalenie"
        darkMode={darkMode}
        wide
      >
        <form onSubmit={saveMergeEdit} className="space-y-4">
          <div className={`rounded-xl border p-3 ${darkMode ? "border-blue-500/30 bg-blue-500/5" : "border-blue-200 bg-blue-50"}`}>
            <div className="flex items-start gap-2">
              <AlertTriangle size={16} className="text-blue-400 mt-0.5 shrink-0" />
              <div>
                <div className="text-sm font-medium">Ta edycja poprawia metadane scalenia</div>
                <div className={`text-xs ${textMuted}`}>
                  Możesz zmienić ukryty rekord zawodnika i wskazać właściwy rekord docelowy. Historia meczowa nie jest tu przenoszona - do tego użyj "Odscal wybrany zakres".
                </div>
              </div>
            </div>
          </div>

          <AdminFormField
            label="Rekord docelowy scalenia"
            name="target_id"
            type="select"
            value={mergeEditForm.target_id}
            onChange={updateMergeEditField}
            options={mergeEditTargetOptions}
            required
            darkMode={darkMode}
            helpText="To pole decyduje, z którego rekordu odscalanie będzie później przenosiło historię."
          />

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <AdminFormField
              label="Imię ukrytego rekordu"
              name="first_name"
              value={mergeEditForm.first_name}
              onChange={updateMergeEditField}
              required
              darkMode={darkMode}
            />
            <AdminFormField
              label="Nazwisko ukrytego rekordu"
              name="last_name"
              value={mergeEditForm.last_name}
              onChange={updateMergeEditField}
              required
              darkMode={darkMode}
            />
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <AdminFormField
              label="Pozycja"
              name="position"
              type="select"
              value={mergeEditForm.position}
              onChange={updateMergeEditField}
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
              value={mergeEditForm.birth_year}
              onChange={updateMergeEditField}
              darkMode={darkMode}
              min={1960}
              max={2015}
            />
            <AdminFormField
              label="Noga"
              name="preferred_foot"
              type="select"
              value={mergeEditForm.preferred_foot}
              onChange={updateMergeEditField}
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
            value={mergeEditForm.city}
            onChange={updateMergeEditField}
            darkMode={darkMode}
          />

          <AdminImageUpload
            bucket="player-photos"
            folder="photos"
            currentUrl={mergeEditForm.photo_url}
            onUpload={(url) => setMergeEditForm((current) => ({ ...current, photo_url: url }))}
            darkMode={darkMode}
            label="Zdjęcie ukrytego rekordu"
          />

          <AdminFormField
            label="Notatka scalenia"
            name="notes"
            type="textarea"
            value={mergeEditForm.notes}
            onChange={updateMergeEditField}
            darkMode={darkMode}
            helpText="Znacznik MERGED_TO zostanie dopisany automatycznie, tutaj wpisz tylko ludzką notatkę."
          />

          <div className="flex justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={closeMergeEditFlow}
              disabled={mergeEditBusy}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5 disabled:opacity-50`}
            >
              Anuluj
            </button>
            <button
              type="submit"
              disabled={mergeEditBusy}
              className="px-4 py-2 rounded-xl bg-blue-500 text-white font-medium text-sm hover:bg-blue-400 disabled:opacity-40"
            >
              {mergeEditBusy ? "Zapisywanie..." : "Zapisz scalenie"}
            </button>
          </div>
        </form>
      </AdminModal>

      {/* Player unmerge - context chooser */}
      <AdminModal
        isOpen={showUnmergeCompare}
        onClose={closePlayerUnmergeFlow}
        title="Odscalaj zawodnika - wybierz zakres"
        darkMode={darkMode}
        xwide
      >
        <div className="space-y-4">
          <div className={`rounded-xl border p-3 ${darkMode ? "border-orange-500/30 bg-orange-500/5" : "border-orange-200 bg-orange-50"}`}>
            <div className="flex items-start gap-2">
              <AlertTriangle size={16} className="text-orange-400 mt-0.5 shrink-0" />
              <div>
                <div className="text-sm font-medium">Wybieraj tylko zakres, który na pewno należy do odscalanego zawodnika</div>
                <div className={`text-xs ${textMuted}`}>
                  Operacja przenosi kadry, składy, gole, asysty, kartki, MVP, pauzy i statystyki sezonowe dla wskazanych sezonów/drużyn.
                  Jeśli dwie różne osoby grały w tym samym sezonie, tej samej lidze i tej samej drużynie, taki przypadek trzeba sprawdzić ręcznie.
                </div>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            <div className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
              <div className={`text-xs font-semibold uppercase tracking-[0.14em] ${textMuted}`}>Odscalany rekord</div>
              <div className="mt-1 font-semibold">{unmergeSource?.display_name || "-"}</div>
              <div className={`text-xs mt-1 ${textMuted}`}>
                {unmergeSource?.birth_year || "brak rocznika"}{unmergeSource?.city ? `, ${unmergeSource.city}` : ""} • zostanie ponownie aktywny
              </div>
            </div>
            <div className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
              <div className={`text-xs font-semibold uppercase tracking-[0.14em] ${textMuted}`}>Obecny rekord docelowy</div>
              <div className="mt-1 font-semibold">{unmergeTarget?.display_name || "-"}</div>
              <div className={`text-xs mt-1 ${textMuted}`}>
                {unmergeTarget?.birth_year || "brak rocznika"}{unmergeTarget?.city ? `, ${unmergeTarget.city}` : ""} • z niego przenosimy wybrane zakresy
              </div>
            </div>
          </div>

          {unmergeLoading ? (
            <div className="flex items-center justify-center py-10">
              <div className="w-7 h-7 border-2 border-blue-500 border-t-transparent rounded-full animate-spin" />
            </div>
          ) : (
            <div className="space-y-3">
              <div className="flex items-center justify-between gap-3">
                <div>
                  <div className="text-sm font-medium">Zakresy do przeniesienia</div>
                  <div className={`text-xs ${textMuted}`}>Zaznacz sezony/drużyny należące do odscalanego zawodnika.</div>
                </div>
                <div className="flex items-center gap-2">
                  <button
                    type="button"
                    onClick={() => setUnmergeSelectedKeys(unmergeContexts.map((context) => context.key))}
                    className={`px-3 py-1.5 rounded-lg border text-xs font-medium ${darkMode ? "border-white/10 text-gray-300 hover:bg-white/5" : "border-gray-200 text-gray-700 hover:bg-gray-50"}`}
                  >
                    Zaznacz wszystko
                  </button>
                  <button
                    type="button"
                    onClick={() => setUnmergeSelectedKeys([])}
                    className={`px-3 py-1.5 rounded-lg border text-xs font-medium ${darkMode ? "border-white/10 text-gray-300 hover:bg-white/5" : "border-gray-200 text-gray-700 hover:bg-gray-50"}`}
                  >
                    Wyczyść
                  </button>
                </div>
              </div>

              <div className={`rounded-xl border ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
                {unmergeContexts.length > 0 ? (
                  <div className="divide-y divide-white/10">
                    {unmergeContexts.map((context) => {
                      const checked = unmergeSelectedKeys.includes(context.key);
                      return (
                        <label
                          key={`unmerge-context-${context.key}`}
                          className={`flex items-start gap-3 p-3 cursor-pointer ${darkMode ? "hover:bg-white/5" : "hover:bg-white"}`}
                        >
                          <input
                            type="checkbox"
                            checked={checked}
                            onChange={() => toggleUnmergeContext(context.key)}
                            className="mt-1 w-4 h-4"
                          />
                          <div className="min-w-0 flex-1">
                            <div className="flex flex-wrap items-center gap-2">
                              <span className="font-semibold">{context.team_name || "Drużyna bez nazwy"}</span>
                              <span className={`text-xs px-2 py-0.5 rounded ${darkMode ? "bg-white/10 text-gray-300" : "bg-gray-100 text-gray-600"}`}>
                                {context.season_year || "sezon ?"} • {context.league_code || context.league_name || "liga ?"}
                              </span>
                              {!context.has_exact_stats && (
                                <span className={`text-xs px-2 py-0.5 rounded ${darkMode ? "bg-orange-500/10 text-orange-300" : "bg-orange-100 text-orange-700"}`}>
                                  statystyki sezonu z innego wpisu drużyny
                                </span>
                              )}
                            </div>
                            <div className={`text-xs mt-1 ${textMuted}`}>
                              Kadra: {context.joined_date || "brak daty"}{context.left_date ? ` - ${context.left_date}` : " - aktywny wpis"}
                            </div>
                            <div className={`text-xs mt-1 ${textMuted}`}>
                              Wyst. {context.appearances || 0}, gole {context.goals || 0}, asysty {context.assists || 0}, ZK {context.yellow_cards || 0}, CK {context.red_cards || 0}
                            </div>
                          </div>
                        </label>
                      );
                    })}
                  </div>
                ) : (
                  <div className={`text-sm text-center py-8 ${textMuted}`}>
                    Brak sezonów lub drużyn do przeniesienia z rekordu docelowego.
                  </div>
                )}
              </div>
            </div>
          )}

          <div className="flex justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={() => { setShowUnmergeCompare(false); setShowUnmergePicker(true); }}
              disabled={unmergeBusy}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5 disabled:opacity-50`}
            >
              Wróć
            </button>
            <button
              type="button"
              onClick={closePlayerUnmergeFlow}
              disabled={unmergeBusy}
              className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5 disabled:opacity-50`}
            >
              Anuluj
            </button>
            <button
              type="button"
              onClick={executeUnmergePlayers}
              disabled={unmergeBusy || unmergeLoading || unmergeSelectedKeys.length === 0}
              className="px-4 py-2 rounded-xl bg-blue-500 text-white font-medium text-sm hover:bg-blue-400 disabled:opacity-40 disabled:cursor-not-allowed"
            >
              {unmergeBusy ? "Odscalanie..." : "Odscal wybrany zakres"}
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
