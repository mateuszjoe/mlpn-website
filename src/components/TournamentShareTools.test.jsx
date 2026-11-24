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
  getTournamentNotificationSupport.mockReturnValue({ supported: true, permission: "default" });
  loadTournamentFollowing.mockReturnValue({ following: false, teamIds: [] });
  saveTournamentFollowing.mockReturnValue(true);
  showTournamentTestNotification.mockResolvedValue(undefined);
  QRCode.toDataURL.mockResolvedValue("data:image/png;base64,test");
  host = document.createElement("div"); document.body.appendChild(host); root = createRoot(host);
  await act(async () => root.render(<TournamentShareTools tournament={tournament} basePath="/podglad-turniejow-abc" />));
});
afterEach(async () => { await act(async () => root.unmount()); host.remove(); });

const button = label => [...host.querySelectorAll("button")].find(element => element.textContent === label);

test("renders no permission prompt or external QR request and only encodes the unlisted URL when expanded", async () => {
  expect(showTournamentTestNotification).not.toHaveBeenCalled();
  expect(QRCode.toDataURL).not.toHaveBeenCalled();
  const details = host.querySelector("details");
  await act(async () => { details.open = true; Simulate.toggle(details); });
  expect(QRCode.toDataURL).toHaveBeenCalledWith("http://localhost/podglad-turniejow-abc/puchar-testowy", expect.objectContaining({ margin: 4 }));
  expect(host.querySelector("img").src).toBe("data:image/png;base64,test");
  expect(host.querySelector("a[download]").getAttribute("href")).toBe("data:image/png;base64,test");
  expect(host.textContent).toContain("To adres lokalny");
});

test("following teams saves only preferences and never asks for notification consent", async () => {
  const team = host.querySelectorAll('input[type="checkbox"]')[1];
  await act(async () => Simulate.change(team, { target: { checked: true } }));
  expect(saveTournamentFollowing).toHaveBeenCalledWith(tournament, { following: false, teamIds: ["a"] });
  expect(host.textContent).toContain("Wybór zapisany na tym urządzeniu");
  expect(showTournamentTestNotification).not.toHaveBeenCalled();
});

test("the explicit test button forwards the hidden base and reports browser permission errors", async () => {
  showTournamentTestNotification.mockRejectedValue(new Error("Powiadomienia są zablokowane."));
  await act(async () => Simulate.click(button("Pokaż powiadomienie testowe")));
  expect(showTournamentTestNotification).toHaveBeenCalledWith(tournament, "/podglad-turniejow-abc");
  expect(host.textContent).toContain("Powiadomienia są zablokowane.");
  expect(button("Pokaż powiadomienie testowe").disabled).toBe(false);
});

test("clipboard denial leaves a selected visible URL that can be copied manually", async () => {
  await act(async () => Simulate.click(button("Kopiuj link")));
  const field = host.querySelector("input[readonly]");
  expect(document.activeElement).toBe(field);
  expect(field.selectionEnd - field.selectionStart).toBe(field.value.length);
  expect(host.textContent).toContain("Skopiuj go z pola ręcznie");
});

test("blocked storage is not reported as a successful save", async () => {
  saveTournamentFollowing.mockReturnValue(false);
  await act(async () => Simulate.change(host.querySelector('input[type="checkbox"]'), { target: { checked: true } }));
  expect(host.textContent).toContain("nie pozwoliła go zapisać");
  expect(host.textContent).not.toContain("Wybór zapisany na tym urządzeniu");
});
