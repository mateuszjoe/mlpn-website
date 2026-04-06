#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");
const { createClient } = require("@supabase/supabase-js");

function loadEnvFile(filePath) {
  if (!fs.existsSync(filePath)) return;

  const content = fs.readFileSync(filePath, "utf8");
  for (const rawLine of content.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) continue;

    const eqIndex = line.indexOf("=");
    if (eqIndex === -1) continue;

    const key = line.slice(0, eqIndex).trim();
    let value = line.slice(eqIndex + 1).trim();
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }

    if (!(key in process.env)) {
      process.env[key] = value;
    }
  }
}

function parseArgs(argv) {
  const options = {
    apply: false,
    limit: null,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const token = argv[index];
    if (token === "--apply") {
      options.apply = true;
      continue;
    }

    const [rawKey, rawInlineValue] = token.split("=", 2);
    const key = rawKey.replace(/^--/, "");
    const nextValue = rawInlineValue ?? argv[index + 1];
    if (rawInlineValue == null && nextValue && !nextValue.startsWith("--")) {
      index += 1;
    }

    const value = rawInlineValue ?? nextValue;
    if (!value) continue;

    if (key === "limit") {
      const parsed = Number.parseInt(value, 10);
      if (Number.isFinite(parsed) && parsed > 0) {
        options.limit = parsed;
      }
    }
  }

  return options;
}

function throwIfError(result, label) {
  if (result?.error) {
    throw new Error(`${label}: ${result.error.message}`);
  }
}

function normalizeText(value) {
  return String(value || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

function normalizedNameKey(player) {
  return normalizeText(`${player.first_name || ""} ${player.last_name || ""}`);
}

function isMergedPlayer(privateRow) {
  return String(privateRow?.notes || "").includes("[MERGED_TO:");
}

function countFilled(values) {
  return values.filter((value) => value !== null && value !== undefined && String(value).trim() !== "").length;
}

function createIncrementMap(rows, field) {
  const map = new Map();
  for (const row of rows || []) {
    const value = row[field];
    if (!value) continue;
    map.set(value, (map.get(value) || 0) + 1);
  }
  return map;
}

function addMapValue(target, key, value) {
  if (!key || !value) return;
  target.set(key, (target.get(key) || 0) + value);
}

async function fetchAll(supabase, table, select, pageSize = 1000) {
  let from = 0;
  const rows = [];

  while (true) {
    const to = from + pageSize - 1;
    const result = await supabase.from(table).select(select).range(from, to);
    throwIfError(result, `${table} select`);

    rows.push(...(result.data || []));
    if (!result.data || result.data.length < pageSize) {
      break;
    }

    from += pageSize;
  }

  return rows;
}

function buildHistoryByPlayer(teamPlayers, playerSeasonStats) {
  const historyByPlayer = new Map();

  function pushEntry(playerId, seasonId, teamId, leagueId) {
    if (!playerId || !seasonId || !teamId) return;

    if (!historyByPlayer.has(playerId)) {
      historyByPlayer.set(playerId, new Map());
    }

    const key = `${teamId}|${seasonId}`;
    if (!historyByPlayer.get(playerId).has(key)) {
      historyByPlayer.get(playerId).set(key, {
        team_id: teamId,
        season_id: seasonId,
        league_id: leagueId || null,
      });
    }
  }

  for (const row of teamPlayers || []) {
    if (row.left_date) continue;
    pushEntry(row.player_id, row.season_id, row.team_id, row.league_id);
  }

  for (const row of playerSeasonStats || []) {
    pushEntry(row.player_id, row.season_id, row.team_id, row.league_id);
  }

  return historyByPlayer;
}

function historyEntries(historyByPlayer, playerId) {
  return [...(historyByPlayer.get(playerId)?.values() || [])];
}

function overlappingHistoryKeys(aEntries, bEntries) {
  const aSet = new Set(aEntries.map((entry) => `${entry.team_id}|${entry.season_id}`));
  return bEntries
    .map((entry) => `${entry.team_id}|${entry.season_id}`)
    .filter((key, index, keys) => aSet.has(key) && keys.indexOf(key) === index);
}

function chooseMergeCategory(a, b, aPrivate, bPrivate, overlapKeys, aHistoryEntries, bHistoryEntries) {
  if (!overlapKeys.length) return null;

  const sameDob =
    aPrivate?.date_of_birth &&
    bPrivate?.date_of_birth &&
    String(aPrivate.date_of_birth) === String(bPrivate.date_of_birth);
  if (sameDob) return "same_dob";

  const sameBirthYear =
    a.birth_year &&
    b.birth_year &&
    String(a.birth_year) === String(b.birth_year);
  if (sameBirthYear) return "same_birth_year";

  if (overlapKeys.length >= 2) {
    return "overlap_2plus";
  }

  const aInactiveFragment = !a.is_active && aHistoryEntries.length <= 2;
  const bInactiveFragment = !b.is_active && bHistoryEntries.length <= 2;
  if (aInactiveFragment || bInactiveFragment) {
    return "inactive_fragment";
  }

  return null;
}

function compareOptional(left, right, normalize = (value) => String(value)) {
  if (left == null || right == null || left === "" || right === "") {
    return false;
  }
  return normalize(left) !== normalize(right);
}

function hasHardConflict(a, b, aPrivate, bPrivate) {
  return (
    compareOptional(a.birth_year, b.birth_year) ||
    compareOptional(aPrivate?.date_of_birth, bPrivate?.date_of_birth) ||
    compareOptional(aPrivate?.email, bPrivate?.email, (value) => String(value).trim().toLowerCase()) ||
    compareOptional(aPrivate?.phone, bPrivate?.phone, (value) => String(value).trim())
  );
}

function totalReferencesForPlayer(playerId, referenceMaps) {
  let total = 0;
  for (const map of referenceMaps) {
    total += map.get(playerId) || 0;
  }
  return total;
}

function scorePlayer(player, privateRow, historyCount, referenceTotal) {
  const identityScore = countFilled([
    player.birth_year,
    privateRow?.date_of_birth,
    privateRow?.email,
    privateRow?.phone,
  ]);

  return (
    (player.is_active ? 1_000_000 : 0) +
    referenceTotal * 100 +
    historyCount * 10 +
    identityScore
  );
}

function chooseTargetAndSource(a, b, aPrivate, bPrivate, aHistoryEntries, bHistoryEntries, referenceMaps) {
  const aReferences = totalReferencesForPlayer(a.id, referenceMaps);
  const bReferences = totalReferencesForPlayer(b.id, referenceMaps);
  const aScore = scorePlayer(a, aPrivate, aHistoryEntries.length, aReferences);
  const bScore = scorePlayer(b, bPrivate, bHistoryEntries.length, bReferences);

  if (aScore !== bScore) {
    return aScore > bScore
      ? { target: a, source: b, targetReferences: aReferences, sourceReferences: bReferences }
      : { target: b, source: a, targetReferences: bReferences, sourceReferences: aReferences };
  }

  const aCreated = Date.parse(a.created_at || "") || 0;
  const bCreated = Date.parse(b.created_at || "") || 0;
  if (aCreated !== bCreated) {
    return aCreated <= bCreated
      ? { target: a, source: b, targetReferences: aReferences, sourceReferences: bReferences }
      : { target: b, source: a, targetReferences: bReferences, sourceReferences: aReferences };
  }

  return String(a.id) <= String(b.id)
    ? { target: a, source: b, targetReferences: aReferences, sourceReferences: bReferences }
    : { target: b, source: a, targetReferences: bReferences, sourceReferences: aReferences };
}

async function gatherData(supabase) {
  const [
    players,
    playersPrivate,
    teamPlayers,
    playerSeasonStats,
    matchLineups,
    matchEvents,
    suspensions,
    matches,
  ] = await Promise.all([
    fetchAll(supabase, "players", "id, first_name, last_name, display_name, birth_year, is_active, created_at"),
    fetchAll(supabase, "players_private", "player_id, notes, date_of_birth, email, phone"),
    fetchAll(supabase, "team_players", "player_id, season_id, league_id, team_id, left_date"),
    fetchAll(
      supabase,
      "player_season_stats",
      "player_id, season_id, league_id, team_id, appearances, goals, assists, yellow_cards, red_cards"
    ),
    fetchAll(supabase, "match_lineups", "player_id"),
    fetchAll(supabase, "match_events", "player_id, assist_player_id"),
    fetchAll(supabase, "suspensions", "player_id"),
    fetchAll(supabase, "matches", "mvp_player_id"),
  ]);

  return {
    players,
    playersPrivate,
    teamPlayers,
    playerSeasonStats,
    referenceMaps: [
      createIncrementMap(teamPlayers, "player_id"),
      createIncrementMap(playerSeasonStats, "player_id"),
      createIncrementMap(matchLineups, "player_id"),
      createIncrementMap(matchEvents, "player_id"),
      createIncrementMap(matchEvents, "assist_player_id"),
      createIncrementMap(suspensions, "player_id"),
      createIncrementMap(matches, "mvp_player_id"),
    ],
  };
}

function buildCandidateReport(dataset) {
  const privateByPlayer = new Map(dataset.playersPrivate.map((row) => [row.player_id, row]));
  const visiblePlayers = dataset.players.filter((player) => !isMergedPlayer(privateByPlayer.get(player.id)));
  const historyByPlayer = buildHistoryByPlayer(dataset.teamPlayers, dataset.playerSeasonStats);
  const groups = new Map();

  for (const player of visiblePlayers) {
    const key = normalizedNameKey(player);
    if (!key) continue;
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key).push(player);
  }

  const report = {
    visiblePlayers: visiblePlayers.length,
    duplicateGroups: 0,
    skipped: {
      multi_record_groups: 0,
      hard_conflict: 0,
      no_overlap: 0,
      weak_overlap_only: 0,
    },
    mergeable: [],
  };

  for (const group of groups.values()) {
    if (group.length < 2) continue;
    report.duplicateGroups += 1;

    if (group.length !== 2) {
      report.skipped.multi_record_groups += 1;
      continue;
    }

    const [a, b] = group;
    const aPrivate = privateByPlayer.get(a.id) || null;
    const bPrivate = privateByPlayer.get(b.id) || null;
    const aHistoryEntries = historyEntries(historyByPlayer, a.id);
    const bHistoryEntries = historyEntries(historyByPlayer, b.id);

    if (hasHardConflict(a, b, aPrivate, bPrivate)) {
      report.skipped.hard_conflict += 1;
      continue;
    }

    const overlapKeys = overlappingHistoryKeys(aHistoryEntries, bHistoryEntries);
    if (!overlapKeys.length) {
      report.skipped.no_overlap += 1;
      continue;
    }

    const category = chooseMergeCategory(
      a,
      b,
      aPrivate,
      bPrivate,
      overlapKeys,
      aHistoryEntries,
      bHistoryEntries
    );

    if (!category) {
      report.skipped.weak_overlap_only += 1;
      continue;
    }

    const choice = chooseTargetAndSource(
      a,
      b,
      aPrivate,
      bPrivate,
      aHistoryEntries,
      bHistoryEntries,
      dataset.referenceMaps
    );

    report.mergeable.push({
      name: a.display_name || `${a.first_name} ${a.last_name}`.trim(),
      category,
      overlap_count: overlapKeys.length,
      overlap_keys: overlapKeys,
      target_id: choice.target.id,
      source_id: choice.source.id,
      target_active: !!choice.target.is_active,
      source_active: !!choice.source.is_active,
      target_birth_year: choice.target.birth_year || null,
      source_birth_year: choice.source.birth_year || null,
      target_reference_total: choice.targetReferences,
      source_reference_total: choice.sourceReferences,
      target_history_count:
        choice.target.id === a.id ? aHistoryEntries.length : bHistoryEntries.length,
      source_history_count:
        choice.source.id === a.id ? aHistoryEntries.length : bHistoryEntries.length,
    });
  }

  report.mergeable.sort((left, right) => {
    if (left.category !== right.category) {
      return left.category.localeCompare(right.category);
    }
    if (right.overlap_count !== left.overlap_count) {
      return right.overlap_count - left.overlap_count;
    }
    return left.name.localeCompare(right.name, "pl");
  });

  return report;
}

function summarizeCategories(mergeable) {
  const summary = new Map();
  for (const row of mergeable) {
    addMapValue(summary, row.category, 1);
  }
  return Object.fromEntries([...summary.entries()].sort(([a], [b]) => a.localeCompare(b)));
}

function runSingleMerge(rootDir, sourceId, targetId) {
  const scriptPath = path.resolve(rootDir, "supabase", "merge_player_duplicate.js");
  const result = spawnSync(
    process.execPath,
    [scriptPath, "--source-id", sourceId, "--target-id", targetId, "--apply"],
    {
      cwd: rootDir,
      encoding: "utf8",
      maxBuffer: 10 * 1024 * 1024,
    }
  );

  if (result.status !== 0) {
    const stderr = String(result.stderr || "").trim();
    const stdout = String(result.stdout || "").trim();
    throw new Error(
      [
        `Merge failed for source=${sourceId} target=${targetId}.`,
        stderr ? `stderr: ${stderr}` : "",
        stdout ? `stdout: ${stdout}` : "",
      ]
        .filter(Boolean)
        .join("\n")
    );
  }
}

async function main() {
  const options = parseArgs(process.argv.slice(2));
  const rootDir = process.cwd();
  loadEnvFile(path.resolve(rootDir, ".env.local"));

  const supabaseUrl = process.env.REACT_APP_SUPABASE_URL;
  const supabaseKey = process.env.SUPABASE_SERVICE_KEY || process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!supabaseUrl || !supabaseKey) {
    throw new Error("Missing REACT_APP_SUPABASE_URL or SUPABASE_SERVICE_KEY.");
  }

  const supabase = createClient(supabaseUrl, supabaseKey, {
    auth: { persistSession: false },
  });

  const dataset = await gatherData(supabase);
  const report = buildCandidateReport(dataset);
  const plannedMerges = options.limit ? report.mergeable.slice(0, options.limit) : report.mergeable;

  console.log(
    JSON.stringify(
      {
        visiblePlayers: report.visiblePlayers,
        duplicateGroups: report.duplicateGroups,
        mergeablePairs: report.mergeable.length,
        plannedPairs: plannedMerges.length,
        skipped: report.skipped,
        categories: summarizeCategories(report.mergeable),
        sample: report.mergeable.slice(0, 20),
      },
      null,
      2
    )
  );

  if (!options.apply) {
    console.log("Dry run complete. Re-run with --apply to execute safe merges.");
    return;
  }

  for (let index = 0; index < plannedMerges.length; index += 1) {
    const row = plannedMerges[index];
    runSingleMerge(rootDir, row.source_id, row.target_id);

    if ((index + 1) % 25 === 0 || index + 1 === plannedMerges.length) {
      console.log(
        `[${index + 1}/${plannedMerges.length}] merged ${row.name} (${row.category}, overlap=${row.overlap_count})`
      );
    }
  }

  const finalDataset = await gatherData(supabase);
  const finalReport = buildCandidateReport(finalDataset);
  console.log(
    JSON.stringify(
      {
        appliedPairs: plannedMerges.length,
        remainingMergeablePairs: finalReport.mergeable.length,
        remainingSkipped: finalReport.skipped,
        remainingCategories: summarizeCategories(finalReport.mergeable),
      },
      null,
      2
    )
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
