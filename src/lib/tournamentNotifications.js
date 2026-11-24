const KEY_PREFIX = "mlpn:tournament-follow:v1:";

function tournamentBasePath(basePath) {
  const value = String(basePath || "/turnieje").replace(/\/+$/, "");
  if (!/^\/(?:[a-z0-9-]+\/?)+$/i.test(value)) throw new Error("Nieprawidłowy adres sekcji turniejów.");
  return value;
}

export function tournamentUrl(tournament, basePath = "/turnieje", origin = window.location.origin) {
  return new URL(`${tournamentBasePath(basePath)}/${encodeURIComponent(tournament.slug)}`, origin).href;
}

export function isLocalTournamentPreview(hostname = window.location.hostname) {
  return ["localhost", "127.0.0.1", "[::1]", "::1"].includes(hostname);
}

function cleanPreferences(value, tournament) {
  const allowed = new Set((tournament.teams || []).map(team => team.id));
  return {
    following: value?.following === true,
    teamIds: Array.isArray(value?.teamIds) ? [...new Set(value.teamIds.filter(id => allowed.has(id)))] : [],
  };
}

export function loadTournamentFollowing(tournament) {
  try {
    return cleanPreferences(JSON.parse(localStorage.getItem(KEY_PREFIX + tournament.id)), tournament);
  } catch {
    return cleanPreferences(null, tournament);
  }
}

export function saveTournamentFollowing(tournament, preferences) {
  try {
    localStorage.setItem(KEY_PREFIX + tournament.id, JSON.stringify(cleanPreferences(preferences, tournament)));
    return true;
  } catch {
    return false;
  }
}

export function getTournamentNotificationSupport() {
  if (!window.isSecureContext) return { supported: false, reason: "Test powiadomień wymaga bezpiecznego adresu HTTPS albo localhost." };
  if (!("Notification" in window) || !("serviceWorker" in navigator)) {
    return { supported: false, reason: "Ta przeglądarka nie obsługuje tego testu. Na iPhonie otwórz stronę dodaną do ekranu początkowego." };
  }
  return { supported: true, permission: window.Notification.permission };
}

function waitUntilActive(registration) {
  if (registration.active) return Promise.resolve();
  const worker = registration.installing || registration.waiting;
  if (!worker) return Promise.reject(new Error("Nie udało się uruchomić obsługi powiadomień. Odśwież stronę i spróbuj ponownie."));
  return new Promise((resolve, reject) => {
    const finish = error => {
      clearTimeout(timeout);
      worker.removeEventListener("statechange", check);
      if (error) reject(error); else resolve();
    };
    const check = () => {
      if (worker.state === "activated") finish();
      else if (worker.state === "redundant") finish(new Error("Nie udało się uruchomić obsługi powiadomień."));
    };
    const timeout = setTimeout(() => finish(new Error("Uruchamianie powiadomień trwa zbyt długo. Spróbuj ponownie.")), 12000);
    worker.addEventListener("statechange", check);
    check();
  });
}

// Called only by the explicit test button. The permission request stays before
// any network await so browsers can associate it with the user's gesture.
export async function showTournamentTestNotification(tournament, basePath = "/turnieje") {
  const support = getTournamentNotificationSupport();
  if (!support.supported) throw new Error(support.reason);
  let permission = window.Notification.permission;
  if (permission === "denied") throw new Error("Powiadomienia są zablokowane. Możesz zmienić zgodę w ustawieniach tej strony w przeglądarce.");
  if (permission !== "granted") permission = await window.Notification.requestPermission();
  if (permission !== "granted") throw new Error("Nie udzielono zgody na powiadomienia. Obserwowane drużyny nadal są zapisane.");
  const base = tournamentBasePath(basePath);
  const registration = await navigator.serviceWorker.register(`${base}/tournament-notifications-sw.js`, { scope: `${base}/` });
  await waitUntilActive(registration);
  await registration.showNotification(`Test · ${tournament.name}`, {
    body: "Tak będzie wyglądać powiadomienie z turnieju MLPN. To test na tym urządzeniu, bez wysyłki do innych osób.",
    icon: "/logo1.png",
    tag: `mlpn-tournament-test-${tournament.id}`,
    data: { url: tournamentUrl(tournament, base) },
  });
}
