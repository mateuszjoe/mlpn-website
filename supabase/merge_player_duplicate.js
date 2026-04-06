#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
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
    sourceId: "",
    targetId: "",
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

    if (key === "source" || key === "source-id") {
      options.sourceId = value;
      continue;
    }

    if (key === "target" || key === "target-id") {
      options.targetId = value;
      continue;
    }
  }

  if (!options.sourceId || !options.targetId) {
    throw new Error("Provide --source-id <uuid> and --target-id <uuid>.");
  }
  if (options.sourceId === options.targetId) {
    throw new Error("Source and target player ids must be different.");
  }

  return options;
}

function throwIfError(result, label) {
  if (result?.error) {
    throw new Error(`${label}: ${result.error.message}`);
  }
}

function sanitizeUpsertRow(row) {
  const copy = { ...row };
  delete copy.id;
  delete copy.created_at;
  delete copy.updated_at;
  return copy;
}

function hasValue(value) {
  if (value === null || value === undefined) return false;
  if (typeof value === "string") return value.trim() !== "";
  return true;
}

function mergePlayerPayload(targetPlayer, sourcePlayer) {
  return {
    first_name: hasValue(targetPlayer.first_name) ? targetPlayer.first_name : sourcePlayer.first_name,
    last_name: hasValue(targetPlayer.last_name) ? targetPlayer.last_name : sourcePlayer.last_name,
    position: hasValue(targetPlayer.position) ? targetPlayer.position : sourcePlayer.position,
    birth_year: hasValue(targetPlayer.birth_year) ? targetPlayer.birth_year : sourcePlayer.birth_year,
    preferred_foot: hasValue(targetPlayer.preferred_foot) ? targetPlayer.preferred_foot : sourcePlayer.preferred_foot,
    photo_url: hasValue(targetPlayer.photo_url) ? targetPlayer.photo_url : sourcePlayer.photo_url,
    city: hasValue(targetPlayer.city) ? targetPlayer.city : sourcePlayer.city,
    is_active: true,
  };
}

function mergePrivatePayload(targetPrivate, sourcePrivate) {
  return {
    date_of_birth: hasValue(targetPrivate?.date_of_birth) ? targetPrivate.date_of_birth : sourcePrivate?.date_of_birth || null,
    phone: hasValue(targetPrivate?.phone) ? targetPrivate.phone : sourcePrivate?.phone || null,
    email: hasValue(targetPrivate?.email) ? targetPrivate.email : sourcePrivate?.email || null,
    address: hasValue(targetPrivate?.address) ? targetPrivate.address : sourcePrivate?.address || null,
    rodo_consent_date: hasValue(targetPrivate?.rodo_consent_date) ? targetPrivate.rodo_consent_date : sourcePrivate?.rodo_consent_date || null,
    rodo_consent_type: hasValue(targetPrivate?.rodo_consent_type) ? targetPrivate.rodo_consent_type : sourcePrivate?.rodo_consent_type || null,
    notes: hasValue(targetPrivate?.notes) ? targetPrivate.notes : sourcePrivate?.notes || null,
  };
}

async function transferRowsWithUpsert(supabase, table, sourceId, targetId, onConflict) {
  const selectRes = await supabase.from(table).select("*").eq("player_id", sourceId);
  throwIfError(selectRes, `${table} select`);
  const rows = selectRes.data || [];
  if (!rows.length) return 0;

  const payload = rows.map((row) => ({
    ...sanitizeUpsertRow(row),
    player_id: targetId,
  }));

  const upsertRes = await supabase.from(table).upsert(payload, {
    onConflict,
    ignoreDuplicates: true,
  });
  throwIfError(upsertRes, `${table} upsert`);

  const cleanupRes = await supabase.from(table).delete().eq("player_id", sourceId);
  throwIfError(cleanupRes, `${table} cleanup`);

  return rows.length;
}

function buildSeasonStatsFloorMap(rows) {
  const byKey = new Map();

  for (const row of rows || []) {
    const key = `${row.season_id || ""}|${row.league_id || ""}`;
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

    const current = byKey.get(key);
    if (!current.team_id && row.team_id) {
      current.team_id = row.team_id;
    }
    current.appearances = Math.max(current.appearances, Number(row.appearances || 0));
    current.goals = Math.max(current.goals, Number(row.goals || 0));
    current.assists = Math.max(current.assists, Number(row.assists || 0));
    current.yellow_cards = Math.max(current.yellow_cards, Number(row.yellow_cards || 0));
    current.red_cards = Math.max(current.red_cards, Number(row.red_cards || 0));
  }

  return byKey;
}

async function applySeasonStatsFloor(supabase, targetId, floorMap) {
  const currentRes = await supabase
    .from("player_season_stats")
    .select("id, season_id, league_id, team_id, appearances, goals, assists, yellow_cards, red_cards")
    .eq("player_id", targetId);
  throwIfError(currentRes, "player_season_stats target select");

  const currentByKey = new Map(
    (currentRes.data || []).map((row) => [`${row.season_id || ""}|${row.league_id || ""}`, row])
  );

  let touched = 0;

  for (const [key, floor] of floorMap.entries()) {
    const current = currentByKey.get(key);

    if (current) {
      const patch = {
        team_id: current.team_id || floor.team_id,
        appearances: Math.max(Number(current.appearances || 0), Number(floor.appearances || 0)),
        goals: Math.max(Number(current.goals || 0), Number(floor.goals || 0)),
        assists: Math.max(Number(current.assists || 0), Number(floor.assists || 0)),
        yellow_cards: Math.max(Number(current.yellow_cards || 0), Number(floor.yellow_cards || 0)),
        red_cards: Math.max(Number(current.red_cards || 0), Number(floor.red_cards || 0)),
      };

      const changed =
        String(patch.team_id || "") !== String(current.team_id || "") ||
        patch.appearances !== Number(current.appearances || 0) ||
        patch.goals !== Number(current.goals || 0) ||
        patch.assists !== Number(current.assists || 0) ||
        patch.yellow_cards !== Number(current.yellow_cards || 0) ||
        patch.red_cards !== Number(current.red_cards || 0);

      if (changed) {
        const updateRes = await supabase.from("player_season_stats").update(patch).eq("id", current.id);
        throwIfError(updateRes, "player_season_stats floor update");
        touched += 1;
      }
      continue;
    }

    const insertRes = await supabase.from("player_season_stats").insert({
      player_id: targetId,
      season_id: floor.season_id,
      league_id: floor.league_id,
      team_id: floor.team_id,
      appearances: floor.appearances,
      goals: floor.goals,
      assists: floor.assists,
      yellow_cards: floor.yellow_cards,
      red_cards: floor.red_cards,
    });
    throwIfError(insertRes, "player_season_stats floor insert");
    touched += 1;
  }

  return touched;
}

async function fetchPlayerBundle(supabase, playerId) {
  const [playerRes, privateRes, pssRes] = await Promise.all([
    supabase.from("players").select("*").eq("id", playerId).single(),
    supabase.from("players_private").select("*").eq("player_id", playerId).maybeSingle(),
    supabase.from("player_season_stats").select("*").eq("player_id", playerId),
  ]);

  throwIfError(playerRes, `players ${playerId} select`);
  throwIfError(privateRes, `players_private ${playerId} select`);
  throwIfError(pssRes, `player_season_stats ${playerId} select`);

  return {
    player: playerRes.data,
    privateRow: privateRes.data || null,
    statsRows: pssRes.data || [],
  };
}

async function countReferences(supabase, playerId) {
  const [teamPlayersRes, lineupsRes, eventPlayerRes, eventAssistRes, suspensionsRes, mvpRes] = await Promise.all([
    supabase.from("team_players").select("id", { count: "exact", head: true }).eq("player_id", playerId),
    supabase.from("match_lineups").select("id", { count: "exact", head: true }).eq("player_id", playerId),
    supabase.from("match_events").select("id", { count: "exact", head: true }).eq("player_id", playerId),
    supabase.from("match_events").select("id", { count: "exact", head: true }).eq("assist_player_id", playerId),
    supabase.from("suspensions").select("id", { count: "exact", head: true }).eq("player_id", playerId),
    supabase.from("matches").select("id", { count: "exact", head: true }).eq("mvp_player_id", playerId),
  ]);

  for (const [result, label] of [
    [teamPlayersRes, "team_players count"],
    [lineupsRes, "match_lineups count"],
    [eventPlayerRes, "match_events player count"],
    [eventAssistRes, "match_events assist count"],
    [suspensionsRes, "suspensions count"],
    [mvpRes, "matches mvp count"],
  ]) {
    throwIfError(result, label);
  }

  return {
    team_players: teamPlayersRes.count || 0,
    match_lineups: lineupsRes.count || 0,
    match_events_player: eventPlayerRes.count || 0,
    match_events_assist: eventAssistRes.count || 0,
    suspensions: suspensionsRes.count || 0,
    mvps: mvpRes.count || 0,
  };
}

async function main() {
  const options = parseArgs(process.argv.slice(2));
  loadEnvFile(path.resolve(process.cwd(), ".env.local"));

  const supabaseUrl = process.env.REACT_APP_SUPABASE_URL;
  const supabaseKey = process.env.SUPABASE_SERVICE_KEY || process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!supabaseUrl || !supabaseKey) {
    throw new Error("Missing REACT_APP_SUPABASE_URL or SUPABASE_SERVICE_KEY.");
  }

  const supabase = createClient(supabaseUrl, supabaseKey, {
    auth: { persistSession: false },
  });

  const [sourceBundle, targetBundle, sourceRefs, targetRefs] = await Promise.all([
    fetchPlayerBundle(supabase, options.sourceId),
    fetchPlayerBundle(supabase, options.targetId),
    countReferences(supabase, options.sourceId),
    countReferences(supabase, options.targetId),
  ]);

  const statsFloorMap = buildSeasonStatsFloorMap([
    ...targetBundle.statsRows,
    ...sourceBundle.statsRows,
  ]);

  console.log("Source:");
  console.log(JSON.stringify({
    id: sourceBundle.player.id,
    name: sourceBundle.player.display_name,
    refs: sourceRefs,
    statsRows: sourceBundle.statsRows,
  }, null, 2));
  console.log("Target:");
  console.log(JSON.stringify({
    id: targetBundle.player.id,
    name: targetBundle.player.display_name,
    refs: targetRefs,
    statsRows: targetBundle.statsRows,
  }, null, 2));

  if (!options.apply) {
    console.log("Dry run complete. Re-run with --apply to execute the merge.");
    return;
  }

  const mergedPlayerPayload = mergePlayerPayload(targetBundle.player, sourceBundle.player);
  const mergedPrivatePayload = mergePrivatePayload(targetBundle.privateRow, sourceBundle.privateRow);

  const updateTargetRes = await supabase.from("players").update(mergedPlayerPayload).eq("id", options.targetId);
  throwIfError(updateTargetRes, "players target update");

  if (Object.values(mergedPrivatePayload).some((value) => hasValue(value))) {
    const upsertPrivateRes = await supabase.from("players_private").upsert(
      { player_id: options.targetId, ...mergedPrivatePayload },
      { onConflict: "player_id" }
    );
    throwIfError(upsertPrivateRes, "players_private target upsert");
  }

  await transferRowsWithUpsert(supabase, "team_players", options.sourceId, options.targetId, "player_id,season_id,league_id,team_id");
  await transferRowsWithUpsert(supabase, "match_lineups", options.sourceId, options.targetId, "match_id,player_id");

  throwIfError(
    await supabase.from("suspensions").update({ player_id: options.targetId }).eq("player_id", options.sourceId),
    "suspensions update"
  );
  throwIfError(
    await supabase.from("match_events").update({ player_id: options.targetId }).eq("player_id", options.sourceId),
    "match_events player update"
  );
  throwIfError(
    await supabase.from("match_events").update({ assist_player_id: options.targetId }).eq("assist_player_id", options.sourceId),
    "match_events assist update"
  );
  throwIfError(
    await supabase.from("matches").update({ mvp_player_id: options.targetId }).eq("mvp_player_id", options.sourceId),
    "matches mvp update"
  );

  const deleteSourceStatsRes = await supabase.from("player_season_stats").delete().eq("player_id", options.sourceId);
  throwIfError(deleteSourceStatsRes, "player_season_stats source cleanup");

  await applySeasonStatsFloor(supabase, options.targetId, statsFloorMap);

  const mergeMarker = `[MERGED_TO:${options.targetId}] ${new Date().toISOString()}`;
  const sourceNotes = hasValue(sourceBundle.privateRow?.notes)
    ? `${mergeMarker}\n${sourceBundle.privateRow.notes}`
    : mergeMarker;

  const markSourcePrivateRes = await supabase.from("players_private").upsert(
    { player_id: options.sourceId, notes: sourceNotes },
    { onConflict: "player_id" }
  );
  throwIfError(markSourcePrivateRes, "players_private source mark");

  const deactivateSourceRes = await supabase
    .from("players")
    .update({ is_active: false })
    .eq("id", options.sourceId);
  throwIfError(deactivateSourceRes, "players source deactivate");

  const [finalSource, finalTarget, finalSourceRefs, finalTargetRefs] = await Promise.all([
    fetchPlayerBundle(supabase, options.sourceId),
    fetchPlayerBundle(supabase, options.targetId),
    countReferences(supabase, options.sourceId),
    countReferences(supabase, options.targetId),
  ]);

  console.log("Merge complete.");
  console.log(JSON.stringify({
    source: {
      id: finalSource.player.id,
      is_active: finalSource.player.is_active,
      notes: finalSource.privateRow?.notes || null,
      refs: finalSourceRefs,
      statsRows: finalSource.statsRows,
    },
    target: {
      id: finalTarget.player.id,
      is_active: finalTarget.player.is_active,
      refs: finalTargetRefs,
      statsRows: finalTarget.statsRows,
    },
  }, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
