import React from "react";
import { createRoot } from "react-dom/client";
import { act, Simulate } from "react-dom/test-utils";
import AdminContactMessages from "./AdminContactMessages";
import { useAuth } from "../../contexts/AuthContext";
import { fetchContactMessages, updateContactMessageStatus } from "../../services/contactService";

jest.mock("../../contexts/AuthContext", () => ({ useAuth: jest.fn() }));
jest.mock("../../services/contactService", () => ({ fetchContactMessages: jest.fn(), updateContactMessageStatus: jest.fn() }));
const message = { id: "03f70555-1437-4464-a0ab-b0766e977619", name: "Jan Kowalski", email: "jan@example.org", subject: "Termin meczu", message: '<script>alert("tekst")</script>\nProszę o informację.', status: "new", created_at: "2026-10-28T12:00:00Z" };
let host;
let root;

beforeEach(() => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  jest.clearAllMocks();
  useAuth.mockReturnValue({ isAdmin: false, can: (permission) => permission === "contact.read" });
  fetchContactMessages.mockResolvedValue({ messages: [message], count: 1 });
  host = document.createElement("div");
  document.body.appendChild(host);
  root = createRoot(host);
});
afterEach(async () => { await act(async () => root.unmount()); host.remove(); });
async function render() { await act(async () => root.render(<AdminContactMessages />)); }
function button(label) { return Array.from(host.querySelectorAll("button")).find((item) => item.textContent === label); }
async function click(element) { await act(async () => Simulate.click(element)); }
async function open() { await click(host.querySelector('button[aria-expanded="false"]')); }

test("does not fetch private messages without the required permission", async () => {
  useAuth.mockReturnValue({ isAdmin: false, can: () => false });
  await render();
  expect(fetchContactMessages).not.toHaveBeenCalled();
  expect(host.querySelector('[role="alert"]').textContent).toContain("Nie masz uprawnień");
});

test("read permission allows details but no mutation, and renders submitted markup as text", async () => {
  await render();
  await open();
  expect(host.querySelector('button[aria-expanded="true"]')).not.toBeNull();
  expect(host.textContent).toContain(message.message);
  expect(host.querySelector("script")).toBeNull();
  expect(button("Archiwizuj")).toBeUndefined();
  expect(updateContactMessageStatus).not.toHaveBeenCalled();
});

test("shows a failed fetch honestly and permits refreshing", async () => {
  fetchContactMessages.mockRejectedValueOnce(new Error("network"));
  await render();
  expect(host.querySelector('[role="alert"]').textContent).toContain("Nie udało się pobrać");
  expect(host.textContent).not.toContain("Brak wiadomości");
  await click(button("Odśwież skrzynkę"));
  expect(host.querySelector('[role="alert"]')).toBeNull();
  expect(host.textContent).toContain("Termin meczu");
});

test("manage permission permits a status change only after confirmation, with retry after error", async () => {
  useAuth.mockReturnValue({ isAdmin: false, can: (permission) => permission === "contact.manage" });
  updateContactMessageStatus.mockRejectedValueOnce(new Error("denied")).mockResolvedValue({ ...message, status: "read" });
  await render();
  await open();
  await click(button("Oznacz jako przeczytaną"));
  expect(host.querySelector('[role="alert"]').textContent).toContain("Nie udało się potwierdzić zmiany");
  expect(button("Oznacz jako przeczytaną")).toBeDefined();
  expect(host.textContent).not.toContain("Zapisano status");
  fetchContactMessages.mockResolvedValue({ messages: [{ ...message, status: "read" }], count: 1 });
  await click(button("Oznacz jako przeczytaną"));
  expect(updateContactMessageStatus).toHaveBeenLastCalledWith(message.id, "read");
  expect(host.textContent).toContain("Zapisano status: Przeczytana.");
  expect(button("Oznacz jako przeczytaną")).toBeUndefined();
});

test("requests the next page and resets page when changing the filter", async () => {
  fetchContactMessages.mockResolvedValue({ messages: [message], count: 51 });
  await render();
  await click(button("Następna"));
  expect(fetchContactMessages).toHaveBeenLastCalledWith({ status: "all", page: 1, pageSize: 25 });
  await act(async () => Simulate.change(host.querySelector("select"), { target: { value: "archived" } }));
  expect(fetchContactMessages).toHaveBeenLastCalledWith({ status: "archived", page: 0, pageSize: 25 });
});
