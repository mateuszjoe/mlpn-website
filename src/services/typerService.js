import { publicSupabase, supabase } from "../lib/supabase";

const MISSING_RELATION_CODES = new Set(["42P01", "PGRST116", "PGRST205", "PGRST202", "42883"]);
const AVATAR_BUCKET = "typer-avatars";

function isMissingBackend(error) {
  if (!error) return false;
  const message = String(error.message || "").toLowerCase();
  return (
    MISSING_RELATION_CODES.has(error.code) ||
    message.includes("could not find the table") ||
    message.includes("could not find the function") ||
    (message.includes("relation") && message.includes("does not exist")) ||
    message.includes("bucket not found")
  );
}

function rethrowUnlessMissing(error) {
  if (isMissingBackend(error)) return false;
  throw error;
}

export function mapTyperProfile(row) {
  if (!row) return null;
  return {
    userId: row.user_id,
    nickname: row.nickname,
    avatar: row.avatar || { type: "default", id: "playmaker-01" },
    email: row.email || "",
    champion: row.champion_team_id || "",
    status: row.status || "approved",
    warnings: Number(row.warnings_count || 0),
    points: Number(row.points || 0),
    exact: Number(row.exact_hits || 0),
    result: Number(row.result_hits || 0),
    advance: Number(row.advance_hits || 0),
    updatedAt: row.updated_at,
  };
}

export function profileToPlayer(profile) {
  const isPlaceholder = profile.avatar?.source === "profiles-backfill";

  return {
    id: `site-${profile.userId}`,
    userId: profile.userId,
    name: profile.nickname,
    avatar: profile.avatar,
    points: profile.points || 0,
    exact: profile.exact || 0,
    result: profile.result || 0,
    advance: profile.advance || 0,
    // Tylko realnie zapisany typ na mistrza. Bez podstawiania domyślnej drużyny,
    // żeby gracze bez wyboru nie pokazywali się fałszywie z Brazylią.
    champion: profile.champion || "",
    warnings: profile.warnings || 0,
    status: profile.status || "approved",
    isPlaceholder,
  };
}

export async function fetchTyperProfiles() {
  const { data, error } = await publicSupabase
    .from("typer_profiles")
    .select(
      "user_id,nickname,avatar,champion_team_id,status,warnings_count,points,exact_hits,result_hits,advance_hits,updated_at"
    )
    .order("points", { ascending: false })
    .order("exact_hits", { ascending: false })
    .order("nickname", { ascending: true });

  if (error) {
    if (rethrowUnlessMissing(error) === false) return { profiles: [], backendReady: false };
  }

  return { profiles: (data || []).map(mapTyperProfile).filter(Boolean), backendReady: true };
}

function mapWorldCupMatch(row) {
  if (!row) return null;

  return {
    id: row.match_id,
    stage: row.stage || "",
    group: row.group_code || null,
    matchday: row.matchday || null,
    kickoffAt: row.kickoff_at || null,
    homeTeam: {
      id: row.home_team_id || "",
      name: row.home_team_name || "TBD",
      crest: row.home_team_crest || "",
    },
    awayTeam: {
      id: row.away_team_id || "",
      name: row.away_team_name || "TBD",
      crest: row.away_team_crest || "",
    },
    status: row.status || "TIMED",
    duration: row.duration || "REGULAR",
    winner: row.winner || null,
    homeScore: row.home_score ?? null,
    awayScore: row.away_score ?? null,
  };
}

export async function fetchWorldCupMatches() {
  const { data, error } = await publicSupabase
    .from("typer_world_cup_matches")
    .select(
      "match_id,stage,group_code,matchday,kickoff_at,home_team_id,home_team_name,home_team_crest,away_team_id,away_team_name,away_team_crest,status,duration,winner,home_score,away_score,updated_at"
    )
    .order("kickoff_at", { ascending: true });

  if (error) {
    if (rethrowUnlessMissing(error) === false) return { matches: [], backendReady: false };
  }

  const matches = (data || []).map(mapWorldCupMatch).filter(Boolean);
  if (matches.length < 64) {
    return { matches: [], backendReady: false };
  }

  return { matches, backendReady: true };
}

export async function fetchMyTyperPicks(userId) {
  if (!userId) return { picks: {}, backendReady: true };

  const { data, error } = await supabase
    .from("typer_picks")
    .select("match_id,home_score,away_score,advance_team_id,confirmed,updated_at")
    .eq("user_id", userId);

  if (error) {
    if (rethrowUnlessMissing(error) === false) return { picks: {}, backendReady: false };
  }

  const picks = {};
  (data || []).forEach((row) => {
    picks[row.match_id] = {
      home: Number(row.home_score || 0),
      away: Number(row.away_score || 0),
      advance: row.advance_team_id || undefined,
      confirmed: !!row.confirmed,
      updatedAt: row.updated_at,
    };
  });

  return { picks, backendReady: true };
}

// Ranking na żywo: RPC liczy tymczasowe punkty wszystkich graczy z aktualnych
// wyników (przekazanych z ESPN) PO STRONIE BAZY, nie ujawniając cudzych typów.
// Działa po wgraniu migracji 028. Bez niej zwraca backendReady:false i ranking
// po prostu nie rusza się dla innych graczy (własny i tak liczy się lokalnie).
export async function fetchLiveLeaderboard(liveScores) {
  if (!Array.isArray(liveScores) || liveScores.length === 0) {
    return { deltas: {}, backendReady: true };
  }

  const { data, error } = await publicSupabase.rpc("typer_live_leaderboard", {
    p_live_scores: liveScores,
  });

  if (error) {
    if (rethrowUnlessMissing(error) === false) return { deltas: {}, backendReady: false };
  }

  const deltas = {};
  (data || []).forEach((row) => {
    deltas[row.user_id] = {
      points: Number(row.live_points || 0),
      exact: Number(row.live_exact || 0),
      result: Number(row.live_result || 0),
      advance: Number(row.live_advance || 0),
    };
  });

  return { deltas, backendReady: true };
}

const TYPER_PROFILE_COLUMNS =
  "user_id,nickname,avatar,champion_team_id,status,warnings_count,points,exact_hits,result_hits,advance_hits,updated_at";

export async function upsertTyperProfile({ userId, email, nickname, avatar, champion }) {
  const payload = {
    user_id: userId,
    email,
    nickname,
    avatar,
    avatar_url: avatar?.type === "upload" ? avatar.url : null,
    champion_team_id: champion || null,
  };

  // Uwaga: celowo NIE używamy .upsert() (INSERT ... ON CONFLICT DO UPDATE).
  // Rola "authenticated" ma na typer_profiles tylko kolumnowy SELECT, a ON CONFLICT
  // DO UPDATE wymaga SELECT na całej tabeli -> upsert kończył się "permission denied"
  // i żaden profil (avatar, nick, mistrz) nie zapisywał się dla zalogowanych graczy.
  // Robimy więc UPDATE, a gdy profilu jeszcze nie ma — INSERT.
  const { data: updated, error: updateError } = await supabase
    .from("typer_profiles")
    .update(payload)
    .eq("user_id", userId)
    .select(TYPER_PROFILE_COLUMNS)
    .maybeSingle();

  if (updateError) {
    if (rethrowUnlessMissing(updateError) === false) return { profile: null, backendReady: false };
  }

  if (updated) {
    return { profile: mapTyperProfile(updated), backendReady: true };
  }

  const { data: inserted, error: insertError } = await supabase
    .from("typer_profiles")
    .insert(payload)
    .select(TYPER_PROFILE_COLUMNS)
    .single();

  if (insertError) {
    if (rethrowUnlessMissing(insertError) === false) return { profile: null, backendReady: false };
  }

  return { profile: mapTyperProfile(inserted), backendReady: true };
}

export async function upsertTyperPick(userId, matchId, pick) {
  const { error } = await supabase
    .from("typer_picks")
    .upsert(
      {
        user_id: userId,
        match_id: matchId,
        home_score: Number(pick.home || 0),
        away_score: Number(pick.away || 0),
        advance_team_id: pick.advance || null,
        confirmed: !!pick.confirmed,
      },
      { onConflict: "user_id,match_id" }
    );

  if (error) {
    if (rethrowUnlessMissing(error) === false) return { backendReady: false };
  }

  return { backendReady: true };
}

export async function deleteTyperPick(userId, matchId) {
  const { error } = await supabase
    .from("typer_picks")
    .delete()
    .eq("user_id", userId)
    .eq("match_id", matchId);

  if (error) {
    if (rethrowUnlessMissing(error) === false) return { backendReady: false };
  }

  return { backendReady: true };
}

export async function uploadTyperAvatar(userId, file) {
  const ext = (file.name.split(".").pop() || "jpg").toLowerCase().replace(/[^a-z0-9]/g, "") || "jpg";
  const path = `${userId}/${Date.now()}-${Math.random().toString(36).slice(2, 8)}.${ext}`;

  const { error } = await supabase.storage.from(AVATAR_BUCKET).upload(path, file, {
    upsert: true,
    contentType: file.type || undefined,
  });

  if (error) {
    if (rethrowUnlessMissing(error) === false) return { publicUrl: "", backendReady: false };
  }

  const { data } = supabase.storage.from(AVATAR_BUCKET).getPublicUrl(path);
  return { publicUrl: data?.publicUrl || "", backendReady: true };
}

export async function updateTyperProfileModeration(userId, patch, action, reason = "") {
  const { data: previous } = await supabase
    .from("typer_profiles")
    .select("status,warnings_count,nickname")
    .eq("user_id", userId)
    .maybeSingle();

  const { data, error } = await supabase
    .from("typer_profiles")
    .update(patch)
    .eq("user_id", userId)
    .select(
      "user_id,nickname,avatar,champion_team_id,status,warnings_count,points,exact_hits,result_hits,advance_hits,updated_at"
    )
    .single();

  if (error) {
    if (rethrowUnlessMissing(error) === false) return { profile: null, backendReady: false };
  }

  const { error: moderationError } = await supabase.from("typer_moderation_actions").insert({
    user_id: userId,
    action,
    reason,
    previous_status: previous?.status || null,
    next_status: patch.status || previous?.status || null,
    metadata: {
      previousNickname: previous?.nickname || null,
      previousWarnings: previous?.warnings_count ?? null,
    },
  });

  if (moderationError && !isMissingBackend(moderationError)) {
    console.warn("Nie udało się zapisać akcji moderacji typera:", moderationError.message);
  }

  return { profile: mapTyperProfile(data), backendReady: true };
}
