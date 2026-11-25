import React from "react";
import { createRoot } from "react-dom/client";
import { act, Simulate } from "react-dom/test-utils";
import QRCode from "qrcode";
import TournamentShareTools from "./TournamentShareTools";
import { getTournamentNotificationSupport, loadTournamentFollowing, saveTournamentFollowing, showTournamentTestNotification } from "../lib/tournamentNotifications";

jest.mock("qrcode", () => ({ toDataURL: jest.fn() }));
jest.mock("../lib/tournamentNotifications", () => ({
  ...jest.requireActual("../lib/tournamentNotifications"),
  getTournamentNotificationSupport: jest.fn(), loadTournamentFollowing: jest.fn(),
  saveTournamentFollowing: jest.fn(), showTournamentTestNotification: jest.fn(),
}));

const tournament = { id: "demo", slug: "puchar-testowy", name: "Puchar testowy", teams: [{ id: "a", name: "Klub A" }] };
let host, root;
beforeEach(async () => {
  jest.clearAllMocks();
  global.IS_REACT_ACT_ENVIRONMENT = true;
  Object.defineProperty(navigator, "clipboard", { configurable: true, value: undefined });
  QRCode.toDataURL.mockResolvedValue("data:image/png;base64,test");
  host = document.createElement("div"); document.body.appendChild(host); root = createRoot(host);
  await act(async () => root.render(<TournamentShareTools tournament={tournament} basePath="/podglad-turniejow-abc" />));
});
afterEach(async () => { await act(async () => root.unmount()); host.remove(); delete navigator.clipboard; localStorage.clear(); });

const button = label => [...host.querySelectorAll("button")].find(element => element.textContent === label);

test("renders no permission prompt or external QR request and only encodes the unlisted URL when expanded", async () => {
  expect(showTournamentTestNotification).not.toHaveBeenCalled();
  expect(QRCode.toDataURL).not.toHaveBeenCalled();
  const details = host.querySelector("details");
  await act(async () => { details.open = true; Simulate.toggle(details); });
  expect(QRCode.toDataURL).toHaveBeenCalledWith("http://localhost/podglad-turniejow-abc/puchar-testowy", expect.objectContaining({ margin: 4 }));
  expect(host.querySelector("img").src).toBe("data:image/png;base64,test");
  expect(host.querySelector("a[download]").getAttribute("href")).toBe("data:image/png;base64,test");
  expect(host.querySelector("summary").textContent).toBe("Udostępnij");
});

test("hides unfinished notification features and preserves existing following preferences", async () => {
  const key = "mlpn:tournament-follow:v1:demo";
  const saved = JSON.stringify({ following: true, teamIds: ["a"] });
  localStorage.setItem(key, saved);
  const details = host.querySelector("details");
  await act(async () => { details.open = true; Simulate.toggle(details); });
  expect(host.querySelectorAll("details")).toHaveLength(1);
  expect(host.querySelector('input[type="checkbox"]')).toBeNull();
  expect(host.textContent).not.toMatch(/obserwuj|powiadomieni|push|testowe|przeglądarka|kolejnym etapie/i);
  expect(getTournamentNotificationSupport).not.toHaveBeenCalled();
  expect(loadTournamentFollowing).not.toHaveBeenCalled();
  expect(saveTournamentFollowing).not.toHaveBeenCalled();
  expect(showTournamentTestNotification).not.toHaveBeenCalled();
  expect(localStorage.getItem(key)).toBe(saved);
});

test("copies the complete unlisted tournament link", async () => {
  const writeText = jest.fn().mockResolvedValue(undefined);
  Object.defineProperty(navigator, "clipboard", { configurable: true, value: { writeText } });
  await act(async () => Simulate.click(button("Kopiuj link")));
  expect(writeText).toHaveBeenCalledWith("http://localhost/podglad-turniejow-abc/puchar-testowy");
  expect(host.textContent).toContain("Link skopiowany.");
});

test("clipboard denial leaves a selected visible URL that can be copied manually", async () => {
  await act(async () => Simulate.click(button("Kopiuj link")));
  const field = host.querySelector("input[readonly]");
  expect(document.activeElement).toBe(field);
  expect(field.selectionEnd - field.selectionStart).toBe(field.value.length);
  expect(host.textContent).toContain("Skopiuj zaznaczony link.");
});

test("keeps the copy action available if QR generation fails", async () => {
  QRCode.toDataURL.mockRejectedValue(new Error("QR failure"));
  const details = host.querySelector("details");
  await act(async () => { details.open = true; Simulate.toggle(details); });
  expect(host.textContent).toContain("Kod QR niedostępny");
  expect(host.querySelector("a[download]")).toBeNull();
  expect(button("Kopiuj link")).toBeTruthy();
  expect(host.textContent).not.toContain("Ładowanie…");
});
