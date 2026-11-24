import {
  getTournamentNotificationSupport, isLocalTournamentPreview, loadTournamentFollowing,
  saveTournamentFollowing, showTournamentTestNotification, tournamentUrl,
} from "./tournamentNotifications";

const tournament = { id: "demo", slug: "puchar-testowy", name: "Puchar testowy", teams: [{ id: "a" }, { id: "b" }] };
const originalNotification = window.Notification;
const secureContext = Object.getOwnPropertyDescriptor(window, "isSecureContext");
const workerDescriptor = Object.getOwnPropertyDescriptor(navigator, "serviceWorker");

beforeEach(() => {
  localStorage.clear();
  Object.defineProperty(window, "isSecureContext", { configurable: true, value: true });
});
afterEach(() => {
  jest.restoreAllMocks();
  window.Notification = originalNotification;
  if (secureContext) Object.defineProperty(window, "isSecureContext", secureContext); else delete window.isSecureContext;
  if (workerDescriptor) Object.defineProperty(navigator, "serviceWorker", workerDescriptor); else delete navigator.serviceWorker;
});

function notificationMocks(permission = "default", answer = "granted") {
  const showNotification = jest.fn().mockResolvedValue(undefined);
  const register = jest.fn().mockResolvedValue({ active: {}, showNotification });
  window.Notification = { permission, requestPermission: jest.fn().mockResolvedValue(answer) };
  Object.defineProperty(navigator, "serviceWorker", { configurable: true, value: { register } });
  return { showNotification, register };
}

test("direct links preserve the unlisted base path and never invent the production origin", () => {
  expect(tournamentUrl(tournament, "/podglad-turniejow-abc/", "http://127.0.0.1:4194"))
    .toBe("http://127.0.0.1:4194/podglad-turniejow-abc/puchar-testowy");
  expect(tournamentUrl({ slug: "a/b" }, "/turnieje", "https://mlpn.pl")).toBe("https://mlpn.pl/turnieje/a%2Fb");
  expect(() => tournamentUrl(tournament, "//other.example", "https://mlpn.pl")).toThrow();
  expect(isLocalTournamentPreview("127.0.0.1")).toBe(true);
  expect(isLocalTournamentPreview("mlpn.pl")).toBe(false);
});

test("following is local, filters stale team ids and survives a page reload", () => {
  expect(saveTournamentFollowing(tournament, { following: true, teamIds: ["a", "a", "unknown"] })).toBe(true);
  expect(loadTournamentFollowing(tournament)).toEqual({ following: true, teamIds: ["a"] });
  expect(loadTournamentFollowing({ ...tournament, id: "other" })).toEqual({ following: false, teamIds: [] });
});

test("corrupt and blocked storage fail safely without claiming preferences were saved", () => {
  localStorage.setItem("mlpn:tournament-follow:v1:demo", "{broken");
  expect(loadTournamentFollowing(tournament)).toEqual({ following: false, teamIds: [] });
  jest.spyOn(Storage.prototype, "setItem").mockImplementation(() => { throw new Error("Blocked"); });
  expect(saveTournamentFollowing(tournament, { following: true })).toBe(false);
});

test("support detection never requests permission or registers a worker", () => {
  const { register } = notificationMocks();
  expect(getTournamentNotificationSupport()).toEqual({ supported: true, permission: "default" });
  expect(window.Notification.requestPermission).not.toHaveBeenCalled();
  expect(register).not.toHaveBeenCalled();
});

test("explicit test requests permission first, uses the unlisted scope and points the notification back to it", async () => {
  const { register, showNotification } = notificationMocks();
  await showTournamentTestNotification(tournament, "/podglad-turniejow-abc");
  expect(window.Notification.requestPermission).toHaveBeenCalledTimes(1);
  expect(window.Notification.requestPermission.mock.invocationCallOrder[0]).toBeLessThan(register.mock.invocationCallOrder[0]);
  expect(register).toHaveBeenCalledWith("/podglad-turniejow-abc/tournament-notifications-sw.js", { scope: "/podglad-turniejow-abc/" });
  expect(showNotification).toHaveBeenCalledWith("Test · Puchar testowy", expect.objectContaining({
    data: { url: "http://localhost/podglad-turniejow-abc/puchar-testowy" },
    tag: "mlpn-tournament-test-demo",
  }));
});

test.each(["denied", "default"])("a refused or dismissed consent cannot register a worker (%s)", async permission => {
  const { register, showNotification } = notificationMocks(permission, "default");
  await expect(showTournamentTestNotification(tournament)).rejects.toThrow();
  expect(register).not.toHaveBeenCalled();
  expect(showNotification).not.toHaveBeenCalled();
  if (permission === "denied") expect(window.Notification.requestPermission).not.toHaveBeenCalled();
});

test("insecure preview cannot prompt and already granted permission is not requested again", async () => {
  const { register } = notificationMocks("granted");
  Object.defineProperty(window, "isSecureContext", { configurable: true, value: false });
  await expect(showTournamentTestNotification(tournament)).rejects.toThrow("HTTPS");
  expect(register).not.toHaveBeenCalled();
  Object.defineProperty(window, "isSecureContext", { configurable: true, value: true });
  await showTournamentTestNotification(tournament);
  expect(window.Notification.requestPermission).not.toHaveBeenCalled();
});

test("a worker that has no active/installing version produces a useful error instead of waiting forever", async () => {
  const { register } = notificationMocks("granted");
  register.mockResolvedValue({});
  await expect(showTournamentTestNotification(tournament)).rejects.toThrow("Odśwież");
});
