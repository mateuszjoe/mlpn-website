import {
  fetchMyTyperPicks,
  fetchTyperProfiles,
  upsertTyperPick,
  upsertTyperProfile,
} from "./typerService";

const PICKS_STORAGE_KEY = "mlpn:world-cup-typer-prototype:v2";
const PROFILE_STORAGE_KEY = "mlpn:typer-profile:v1";
const DEFAULT_AVATAR = { type: "default", id: "playmaker-01" };

function readJsonStorage(key, fallback) {
  if (typeof window === "undefined") return fallback;

  try {
    const raw = window.localStorage?.getItem(key);
    return raw ? JSON.parse(raw) : fallback;
  } catch {
    return fallback;
  }
}

function getMetadataString(data, keys) {
  for (const key of keys) {
    const value = data?.[key];
    if (typeof value === "string" && value.trim()) return value.trim();
  }
  return "";
}

function getProviderIdentityData(user, provider) {
  return user?.identities?.find((identity) => identity?.provider === provider)?.identity_data || {};
}

function getProviderAvatarUrl(user, provider) {
  const data = getProviderIdentityData(user, provider);
  const directUrl = getMetadataString(data, ["avatar_url", "picture"]);
  if (directUrl) return directUrl;

  if (typeof data?.picture?.data?.url === "string") return data.picture.data.url;

  const providerId = getMetadataString(data, ["sub", "id", "user_id"]);
  if (provider === "facebook" && providerId) {
    return `https://graph.facebook.com/${providerId}/picture?type=large`;
  }

  return "";
}

function getProviderDisplayName(user, provider) {
  const data = getProviderIdentityData(user, provider);
  return getMetadataString(data, ["full_name", "name", "display_name"]);
}

function getAccountAvatar(user) {
  const googleAvatar = getProviderAvatarUrl(user, "google");
  if (googleAvatar) return { type: "google", url: googleAvatar, source: "auth-metadata" };

  const facebookAvatar = getProviderAvatarUrl(user, "facebook");
  if (facebookAvatar) return { type: "facebook", url: facebookAvatar, source: "auth-metadata" };

  const metadataAvatar = getMetadataString(user?.user_metadata, ["avatar_url", "picture"]);
  if (metadataAvatar) return { type: "upload", url: metadataAvatar, source: "auth-metadata" };

  return null;
}

function getAccountNickname(user, profile, remoteProfile) {
  const metadata = user?.user_metadata || {};
  const name =
    profile?.display_name ||
    profile?.full_name ||
    profile?.name ||
    getProviderDisplayName(user, "google") ||
    getProviderDisplayName(user, "facebook") ||
    getMetadataString(metadata, ["display_name", "full_name", "name"]) ||
    remoteProfile?.nickname ||
    user?.email?.split("@")[0] ||
    "Kibic MLPN";

  return String(name).trim().slice(0, 28) || "Kibic MLPN";
}

function isAutoBackfilledProfile(profile) {
  return profile?.avatar?.source === "profiles-backfill";
}

function normalizePick(pick) {
  if (!pick || typeof pick !== "object") return null;

  const home = Number.parseInt(pick.home, 10);
  const away = Number.parseInt(pick.away, 10);
  if (!Number.isFinite(home) || !Number.isFinite(away)) return null;

  return {
    home,
    away,
    advance: pick.advance || undefined,
    confirmed: !!pick.confirmed,
  };
}

function getLocalPicks() {
  const picks = readJsonStorage(PICKS_STORAGE_KEY, {});

  return Object.fromEntries(
    Object.entries(picks || {})
      .map(([matchId, pick]) => [matchId, normalizePick(pick)])
      .filter(([, pick]) => !!pick)
  );
}

function getLocalProfile(userId) {
  const profiles = readJsonStorage(PROFILE_STORAGE_KEY, {});
  const profile = profiles?.[userId];

  if (!profile || typeof profile !== "object") return null;
  if (!String(profile.nickname || "").trim()) return null;

  return profile;
}

async function syncProfile({ user, profile, remoteProfile, localProfile }) {
  if (!user?.id) return { restoredProfile: false };

  const localProfileIsBackfill = isAutoBackfilledProfile(localProfile);
  const shouldRestoreLocalProfile =
    !!localProfile && !localProfileIsBackfill && (!remoteProfile || isAutoBackfilledProfile(remoteProfile));

  if (shouldRestoreLocalProfile) {
    await upsertTyperProfile({
      userId: user.id,
      email: user.email || localProfile.email || "",
      nickname: localProfile.nickname,
      avatar: localProfile.avatar || DEFAULT_AVATAR,
      champion: localProfile.champion || remoteProfile?.champion || "",
    });

    return { restoredProfile: true };
  }

  const accountAvatar = getAccountAvatar(user);
  const shouldUseAccountAvatar =
    accountAvatar && remoteProfile && isAutoBackfilledProfile(remoteProfile);

  if (shouldUseAccountAvatar) {
    await upsertTyperProfile({
      userId: user.id,
      email: user.email || "",
      nickname: getAccountNickname(user, profile, remoteProfile),
      avatar: accountAvatar,
      champion: remoteProfile.champion || "",
    });

    return { restoredProfile: true };
  }

  return { restoredProfile: false };
}

async function syncPicks(userId, localPicks) {
  const localEntries = Object.entries(localPicks || {});
  if (!userId || localEntries.length === 0) {
    return { restoredPicks: 0, failedPicks: 0 };
  }

  const { picks: remotePicks, backendReady } = await fetchMyTyperPicks(userId);
  if (!backendReady) return { restoredPicks: 0, failedPicks: localEntries.length };

  const missingEntries = localEntries.filter(([matchId]) => !remotePicks?.[matchId]);
  if (missingEntries.length === 0) return { restoredPicks: 0, failedPicks: 0 };

  const results = await Promise.allSettled(
    missingEntries.map(([matchId, pick]) => upsertTyperPick(userId, matchId, pick))
  );
  const failedPicks = results.filter(
    (result) => result.status === "rejected" || result.value?.backendReady === false
  ).length;

  return {
    restoredPicks: missingEntries.length - failedPicks,
    failedPicks,
  };
}

export async function syncStoredTyperData({ user, profile } = {}) {
  if (!user?.id) return { restoredProfile: false, restoredPicks: 0, failedPicks: 0 };

  const localPicks = getLocalPicks();
  const localProfile = getLocalProfile(user.id);
  const needsProfileCheck = !!localProfile || !!getAccountAvatar(user);
  let remoteProfile = null;

  if (needsProfileCheck) {
    const { profiles, backendReady } = await fetchTyperProfiles();
    if (backendReady) {
      remoteProfile = profiles.find((item) => item.userId === user.id) || null;
    }
  }

  const profileResult = await syncProfile({ user, profile, remoteProfile, localProfile });
  const picksResult = await syncPicks(user.id, localPicks);

  return {
    ...profileResult,
    ...picksResult,
  };
}
