import React from "react";
import { createRoot } from "react-dom/client";
import { act, Simulate } from "react-dom/test-utils";
import ContactForm from "./ContactForm";
import { createContactSubmissionId, submitContactMessage } from "../services/contactService";

jest.mock("../lib/supabase", () => ({ publicSupabase: {}, supabase: {} }));
jest.mock("../services/contactService", () => ({ ...jest.requireActual("../services/contactService"), createContactSubmissionId: jest.fn(), submitContactMessage: jest.fn() }));
let host;
let root;
const FIRST_ID = "03f70555-1437-4464-a0ab-b0766e977619";
const SECOND_ID = "03f70555-1437-4464-a0ab-b0766e977620";

beforeEach(async () => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  jest.clearAllMocks();
  createContactSubmissionId.mockReturnValueOnce(FIRST_ID).mockReturnValue(SECOND_ID);
  host = document.createElement("div");
  document.body.appendChild(host);
  root = createRoot(host);
  await act(async () => root.render(<ContactForm />));
});
afterEach(async () => { await act(async () => root.unmount()); host.remove(); });

async function change(name, value) {
  await act(async () => Simulate.change(host.querySelector(`[name="${name}"]`), { target: { name, value } }));
}
async function fill() {
  for (const [name, value] of Object.entries({ name: "Jan Kowalski", email: "Jan@example.org", subject: "Termin meczu", message: "Proszę o potwierdzenie terminu meczu." })) await change(name, value);
}
async function submit() { await act(async () => Simulate.submit(host.querySelector("form"))); }

test("validates fields accessibly and focuses the first error without sending", async () => {
  await submit();
  expect(submitContactMessage).not.toHaveBeenCalled();
  const name = host.querySelector('[name="name"]');
  expect(name.getAttribute("aria-invalid")).toBe("true");
  expect(document.getElementById(name.getAttribute("aria-describedby")).textContent).toContain("od 2 do 120");
  expect(host.querySelector(`label[for="${name.id}"]`).textContent).toBe("Imię i nazwisko");
  expect(document.activeElement).toBe(name);
});

test("blocks duplicate submits and confirms success only after the server resolves", async () => {
  let resolve;
  submitContactMessage.mockReturnValue(new Promise((done) => { resolve = done; }));
  await fill();
  await submit();
  await submit();
  expect(submitContactMessage).toHaveBeenCalledTimes(1);
  expect(host.querySelector("fieldset").disabled).toBe(true);
  expect(host.textContent).not.toContain("Wiadomość została przyjęta");
  await act(async () => resolve(FIRST_ID));
  expect(host.querySelector('[role="status"]').textContent).toContain("Wiadomość została przyjęta");
  expect(host.querySelector("form")).toBeNull();
});

test("keeps the message and idempotency key after failure, including email case-only changes", async () => {
  submitContactMessage.mockRejectedValueOnce(new Error("network")).mockResolvedValue(FIRST_ID);
  await fill();
  await submit();
  expect(host.querySelector('[role="alert"]').textContent).toContain("Nie udało się potwierdzić");
  expect(host.querySelector('[name="message"]').value).toBe("Proszę o potwierdzenie terminu meczu.");
  await change("email", "JAN@EXAMPLE.ORG");
  await submit();
  expect(submitContactMessage.mock.calls.map((call) => call[1])).toEqual([FIRST_ID, FIRST_ID]);
  expect(createContactSubmissionId).toHaveBeenCalledTimes(1);
});

test("uses a new idempotency key when content changes after a failed request", async () => {
  submitContactMessage.mockRejectedValue(new Error("network"));
  await fill();
  await submit();
  await change("message", "Poprawiona treść wiadomości o terminie meczu.");
  await submit();
  expect(submitContactMessage.mock.calls.map((call) => call[1])).toEqual([FIRST_ID, SECOND_ID]);
});
