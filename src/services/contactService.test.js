import { publicSupabase, supabase } from "../lib/supabase";
import { fetchContactMessages, getContactSubmissionError, submitContactMessage, updateContactMessageStatus, validateContactFields } from "./contactService";

jest.mock("../lib/supabase", () => ({ publicSupabase: { rpc: jest.fn() }, supabase: { from: jest.fn() } }));
const ID = "03f70555-1437-4464-a0ab-b0766e977619";
const OTHER_ID = "03f70555-1437-4464-a0ab-b0766e977620";
const fields = { name: " Jan Kowalski ", email: " JAN@example.org ", subject: " Mecz ligowy ", message: " Proszę o informację o terminie meczu. ", website: "" };
const row = { id: ID, sender_name: "Jan Kowalski", sender_email: "jan@example.org", subject: "Mecz", message: "Treść wiadomości", status: "new", created_at: "2026-10-28T12:00:00Z" };

function query(result) {
  const chain = {};
  ["select", "eq", "order", "range", "update", "single"].forEach((method) => { chain[method] = jest.fn(() => chain); });
  chain.abortSignal = jest.fn().mockResolvedValue(result);
  return chain;
}

beforeEach(() => jest.clearAllMocks());

test("submits trimmed content through the public RPC and checks its exact receipt", async () => {
  publicSupabase.rpc.mockReturnValue(query({ data: ID, error: null }));
  await expect(submitContactMessage(fields, ID)).resolves.toBe(ID);
  expect(publicSupabase.rpc).toHaveBeenCalledWith("submit_contact_message", { p_name: "Jan Kowalski", p_email: "jan@example.org", p_subject: "Mecz ligowy", p_message: "Proszę o informację o terminie meczu.", p_website: "", p_submission_id: ID });
  expect(supabase.from).not.toHaveBeenCalled();
});

test.each([null, OTHER_ID, { id: ID }])("rejects an absent or mismatched receipt: %p", async (data) => {
  publicSupabase.rpc.mockReturnValue(query({ data, error: null }));
  await expect(submitContactMessage(fields, ID)).rejects.toThrow("CONTACT_UNCONFIRMED");
});

test("rejects invalid fields and honeypot before making any request", async () => {
  const invalid = { name: " ", email: "invalid", subject: "a", message: "too short", website: "spam" };
  expect(Object.keys(validateContactFields(invalid))).toEqual(["name", "email", "subject", "message", "website"]);
  await expect(submitContactMessage(invalid, ID)).rejects.toThrow("CONTACT_INVALID_INPUT");
  expect(publicSupabase.rpc).not.toHaveBeenCalled();
});

test("returns safe retry guidance for a rate limit without exposing server internals", () => {
  expect(getContactSubmissionError({ message: "CONTACT_RATE_LIMIT: private internal details" })).toContain("Odczekaj kilka minut");
  expect(getContactSubmissionError({ message: "private internal details" })).not.toContain("private internal");
});

test("reads existing sender columns and requests an ordered, filtered page", async () => {
  const chain = query({ data: [row], count: 52, error: null });
  supabase.from.mockReturnValue(chain);
  await expect(fetchContactMessages({ status: "new", page: 1, pageSize: 25 })).resolves.toEqual({ messages: [{ ...row, name: row.sender_name, email: row.sender_email }], count: 52 });
  expect(supabase.from).toHaveBeenCalledWith("contact_messages");
  expect(chain.select.mock.calls[0][0]).toContain("sender_name,sender_email");
  expect(chain.eq).toHaveBeenCalledWith("status", "new");
  expect(chain.range).toHaveBeenCalledWith(25, 49);
  expect(chain.order).toHaveBeenCalledWith("created_at", { ascending: false });
});

test("updates only status and requires the server to return the changed row", async () => {
  const chain = query({ data: { ...row, status: "read" }, error: null });
  supabase.from.mockReturnValue(chain);
  await expect(updateContactMessageStatus(ID, "read")).resolves.toMatchObject({ id: ID, status: "read" });
  expect(chain.update).toHaveBeenCalledWith({ status: "read" });
  expect(chain.eq).toHaveBeenCalledWith("id", ID);
  expect(chain.single).toHaveBeenCalled();
  chain.abortSignal.mockResolvedValue({ data: null, error: null });
  await expect(updateContactMessageStatus(ID, "read")).rejects.toThrow("Nie udało się potwierdzić");
});

test("surfaces rejected queries instead of returning an empty inbox or optimistic update", async () => {
  const denied = { code: "42501", message: "permission denied" };
  supabase.from.mockReturnValue(query({ data: null, error: denied }));
  await expect(fetchContactMessages()).rejects.toBe(denied);
  await expect(updateContactMessageStatus(ID, "archived")).rejects.toBe(denied);
});
