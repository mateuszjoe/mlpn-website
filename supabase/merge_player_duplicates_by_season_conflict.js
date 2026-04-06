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

function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function fetchAll(supabase, table, select, pageSize = 1000) {
  let from = 0;
  const rows = [];

  while (true) {
    const to = from + pageSize - 1;
    let attempts = 0;

    while (true) {
      try {
        const result = await supabase.from(table).select(select).range(from, to);
        throwIfError(result, `${table} select`);
        rows.push(...(result.data || []));
        if (!result.data || result.data.length < pageSize) {
          return rows;
        }
        from += pageSize;
        break;
      } catch (error) {
        attempts += 1;
        if (attempts >= 4) {
          throw error;
        }
        await delay(500 * attempts);
      }
    }
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

function cloneSeasonTeamMap(map) {
  return new Map(
    [...(map?.entries() || [])].map(([seasonId, teams]) => [seasonId, new Set(teams)])
  );
}

function mergeSeasonTeamMaps(targetMap, sourceMap) {
  for (const [seasonId, teamIds] of sourceMap.entries()) {
    if (!targetMap.has(seasonId)) {
      targetMap.set(seasonId, new Set());
    }
    for (const teamId of teamIds) {
      targetMap.get(seasonId).add(teamId);
    }
  }
}

function hasSeasonConflict(leftMap, rightMap) {
  for (const [seasonId, leftTeams] of leftMap.entries()) {
    const rightTeams = rightMap.get(seasonId);
    if (!rightTeams) continue;

    const combined = new Set([...leftTeams, ...rightTeams]);
    if (combined.size > 1) {
      return true;
    }
  }

  return false;
}

function buildHistoryByPlayer(teamPlayers, playerSeasonStats) {
  const historyByPlayer = new Map();

  function pushEntry(playerId, seasonId, teamId) {
    if (!playerId || !seasonId || !teamId) return;

    if (!historyByPlayer.has(playerId)) {
      historyByPlayer.set(playerId, new Map());
    }
    if (!historyByPlayer.get(playerId).has(seasonId)) {
      historyByPlayer.get(playerId).set(seasonId, new Set());
    }

    historyByPlayer.get(playerId).get(seasonId).add(teamId);
  }

  for (const row of teamPlayers || []) {
    if (row.left_date) continue;
    pushEntry(row.player_id, row.season_id, row.team_id);
  }

  for (const row of playerSeasonStats || []) {
    pushEntry(row.player_id, row.season_id, row.team_id);
  }

  return historyByPlayer;
}

function seasonTeamMapForPlayer(historyByPlayer, playerId) {
  return cloneSeasonTeamMap(historyByPlayer.get(playerId) || new Map());
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
    fetchAll(supabase, "player_season_stats", "player_id, season_id, league_id, team_id"),
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

function comparePlayersForTargetPriority(a, b, privateByPlayer, historyByPlayer, referenceMaps) {
  const aPrivate = privateByPlayer.get(a.id) || null;
  const bPrivate = privateByPlayer.get(b.id) || null;
  const aHistoryCount = (historyByPlayer.get(a.id)?.size || 0);
  const bHistoryCount = (historyByPlayer.get(b.id)?.size || 0);
  const aReferences = totalReferencesForPlayer(a.id, referenceMaps);
  const bReferences = totalReferencesForPlayer(b.id, referenceMaps);
  const aScore = scorePlayer(a, aPrivate, aHistoryCount, aReferences);
  const bScore = scorePlayer(b, bPrivate, bHistoryCount, bReferences);

  if (aScore !== bScore) {
    return bScore - aScore;
  }

  const aCreated = Date.parse(a.created_at || "") || 0;
  const bCreated = Date.parse(b.created_at || "") || 0;
  if (aCreated !== bCreated) {
    return aCreated - bCreated;
  }

  return String(a.id).localeCompare(String(b.id));
}

function buildConflictOnlyReport(dataset) {
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
    conflictGroups: 0,
    blockedGroups: [],
    mergeable: [],
  };

  for (const group of groups.values()) {
    if (group.length < 2) continue;
    report.duplicateGroups += 1;

    const orderedPlayers = [...group].sort((left, right) =>
      comparePlayersForTargetPriority(left, right, privateByPlayer, historyByPlayer, dataset.referenceMaps)
    );

    const clusters = [];

    for (const player of orderedPlayers) {
      const playerSeasonTeams = seasonTeamMapForPlayer(historyByPlayer, player.id);
      let placed = false;

      for (const cluster of clusters) {
        if (hasSeasonConflict(cluster.seasonTeams, playerSeasonTeams)) {
          continue;
        }

        cluster.players.push(player);
        mergeSeasonTeamMaps(cluster.seasonTeams, playerSeasonTeams);
        placed = true;
        break;
      }

      if (!placed) {
        clusters.push({
          players: [player],
          seasonTeams: playerSeasonTeams,
        });
      }
    }

    if (clusters.length > 1) {
      report.conflictGroups += 1;
      report.blockedGroups.push({
        name: group[0].display_name || `${group[0].first_name} ${group[0].last_name}`.trim(),
        group_size: group.length,
        cluster_sizes: clusters.map((cluster) => cluster.players.length),
      });
    }

    for (const cluster of clusters) {
      if (cluster.players.length < 2) continue;

      const target = cluster.players[0];
      const sources = cluster.players.slice(1);

      report.mergeable.push({
        name: target.display_name || `${target.first_name} ${target.last_name}`.trim(),
        category: "same_name_no_season_conflict",
        cluster_size: cluster.players.length,
        target_id: target.id,
        source_ids: sources.map((player) => player.id),
        target_active: !!target.is_active,
        source_active_count: sources.filter((player) => player.is_active).length,
        season_count: cluster.seasonTeams.size,
        target_reference_total: totalReferencesForPlayer(target.id, dataset.referenceMaps),
        source_reference_total: sources.reduce(
          (sum, player) => sum + totalReferencesForPlayer(player.id, dataset.referenceMaps),
          0
        ),
      });
    }
  }

  report.mergeable.sort((left, right) => {
    if (right.cluster_size !== left.cluster_size) {
      return right.cluster_size - left.cluster_size;
    }
    if (right.source_ids.length !== left.source_ids.length) {
      return right.source_ids.length - left.source_ids.length;
    }
    return left.name.localeCompare(right.name, "pl");
  });

  report.blockedGroups.sort((left, right) => left.name.localeCompare(right.name, "pl"));
  return report;
}

function summarizeCategories(mergeable) {
  const summary = new Map();
  for (const row of mergeable) {
    summary.set(row.category, (summary.get(row.category) || 0) + 1);
  }
  return Object.fromEntries([...summary.entries()].sort(([a], [b]) => a.localeCompare(b)));
}

function runSingleMerge(rootDir, sourceId, targetId) {
  const scriptPath = path.resolve(rootDir, "supabase", "merge_player_duplicate.js");

  for (let attempt = 1; attempt <= 3; attempt += 1) {
    const result = spawnSync(
      process.execPath,
      [scriptPath, "--source-id", sourceId, "--target-id", targetId, "--apply"],
      {
        cwd: rootDir,
        encoding: "utf8",
        maxBuffer: 10 * 1024 * 1024,
      }
    );

    if (result.status === 0) {
      return;
    }

    const stderr = String(result.stderr || "").trim();
    const stdout = String(result.stdout || "").trim();
    const combined = `${stderr}\n${stdout}`.toLowerCase();
    const retriable =
      combined.includes("fetch failed") ||
      combined.includes("network") ||
      combined.includes("bad gateway") ||
      combined.includes("502") ||
      combined.includes("cloudflare") ||
      combined.includes("timeout") ||
      combined.includes("timed out") ||
      combined.includes("econnreset") ||
      combined.includes("socket") ||
      combined.includes("terminated");

    if (attempt < 3 && retriable) {
      continue;
    }

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
  const report = buildConflictOnlyReport(dataset);
  const plannedClusters = options.limit ? report.mergeable.slice(0, options.limit) : report.mergeable;
  const plannedOperations = plannedClusters.reduce((sum, row) => sum + row.source_ids.length, 0);

  console.log(
    JSON.stringify(
      {
        visiblePlayers: report.visiblePlayers,
        duplicateGroups: report.duplicateGroups,
        mergeableClusters: report.mergeable.length,
        plannedClusters: plannedClusters.length,
        plannedOperations,
        conflictGroups: report.conflictGroups,
        blockedSample: report.blockedGroups.slice(0, 20),
        categories: summarizeCategories(report.mergeable),
        sample: plannedClusters.slice(0, 20),
      },
      null,
      2
    )
  );

  if (!options.apply) {
    console.log("Dry run complete. Re-run with --apply to execute conflict-based merges.");
    return;
  }

  let completedOperations = 0;
  for (const cluster of plannedClusters) {
    for (const sourceId of cluster.source_ids) {
      runSingleMerge(rootDir, sourceId, cluster.target_id);
      completedOperations += 1;

      if (completedOperations % 25 === 0 || completedOperations === plannedOperations) {
        console.log(
          `[${completedOperations}/${plannedOperations}] merged ${cluster.name} into ${cluster.target_id}`
        );
      }
    }
  }

  const finalDataset = await gatherData(supabase);
  const finalReport = buildConflictOnlyReport(finalDataset);
  console.log(
    JSON.stringify(
      {
        appliedClusters: plannedClusters.length,
        appliedOperations: completedOperations,
        remainingMergeableClusters: finalReport.mergeable.length,
        remainingConflictGroups: finalReport.conflictGroups,
        remainingBlockedSample: finalReport.blockedGroups.slice(0, 20),
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
