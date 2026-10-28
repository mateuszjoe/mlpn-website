import { publicSupabase, supabase } from "../lib/supabase";

export const CONTACT_LIMITS = { name: 120, email: 254, subject: 160, message: 5000 };
export const CONTACT_STATUSES = ["new", "read", "archived"];
const COLUMNS = "id,sender_name,sender_email,subject,message,created_at,status,updated_at";
const UUID_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export function normalizeContactFields(fields) {
  const values = Object.fromEntries(["name", "email", "subject", "message", "website"].map((key) => [key, String(fields[key] || "").trim()]));
  values.email = values.email.toLowerCase();
  return values;
}

export function validateContactFields(fields) {
  const values = normalizeContactFields(fields);
  const errors = {};
  if (values.name.length < 2 || values.name.length > CONTACT_LIMITS.name) errors.name = "Podaj imię i nazwisko (od 2 do 120 znaków).";
  if (values.email.length > CONTACT_LIMITS.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(values.email)) errors.email = "Podaj poprawny adres e-mail (maksymalnie 254 znaki).";
  if (values.subject.length < 3 || values.subject.length > CONTACT_LIMITS.subject) errors.subject = "Wpisz temat (od 3 do 160 znaków).";
  if (values.message.length < 10 || values.message.length > CONTACT_LIMITS.message) errors.message = "Wpisz wiadomość (od 10 do 5000 znaków).";
  if (values.website) errors.website = "Nie udało się przyjąć wiadomości. Odśwież stronę i spróbuj ponownie.";
  return errors;
}

export function createContactSubmissionId() {
  if (globalThis.crypto?.randomUUID) return globalThis.crypto.randomUUID();
  if (!globalThis.crypto?.getRandomValues) throw new Error("CONTACT_UNAVAILABLE");
  const bytes = globalThis.crypto.getRandomValues(new Uint8Array(16));
  bytes[6] = (bytes[6] & 15) | 64;
  bytes[8] = (bytes[8] & 63) | 128;
  const hex = Array.from(bytes, (byte) => byte.toString(16).padStart(2, "0")).join("");
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
}

// An interrupted request may still have reached the server. The form retains the
// submission UUID so retrying the same content cannot create a second message.
async function withTimeout(query) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 20000);
  try {
    return await query.abortSignal(controller.signal);
  } finally {
    clearTimeout(timer);
  }
}

export function getContactSubmissionError(error) {
  const code = `${error?.code || ""} ${error?.message || ""}`;
  if (code.includes("CONTACT_RATE_LIMIT")) return "Wysłano zbyt wiele wiadomości w krótkim czasie. Odczekaj kilka minut i spróbuj ponownie. Treść formularza została zachowana.";
  if (code.includes("CONTACT_INVALID_INPUT")) return "Sprawdź dane w formularzu i spróbuj ponownie. Wiadomość nie została przyjęta.";
  if (code.includes("CONTACT_SUBMISSION_CONFLICT")) return "Nie udało się potwierdzić tej wersji wiadomości. Odśwież stronę dopiero po skopiowaniu jej treści.";
  return "Nie udało się potwierdzić przyjęcia wiadomości. Treść formularza została zachowana — spróbuj wysłać ją ponownie.";
}

export async function submitContactMessage(fields, submissionId) {
  if (Object.keys(validateContactFields(fields)).length || !UUID_PATTERN.test(submissionId || "")) throw new Error("CONTACT_INVALID_INPUT");
  const values = normalizeContactFields(fields);
  const { data, error } = await withTimeout(publicSupabase.rpc("submit_contact_message", {
    p_name: values.name,
    p_email: values.email,
    p_subject: values.subject,
    p_message: values.message,
    p_website: values.website,
    p_submission_id: submissionId,
  }));
  if (error) throw error;
  if (data !== submissionId) throw new Error("CONTACT_UNCONFIRMED");
  return data;
}

function mapMessage(row) {
  return { ...row, name: row.sender_name, email: row.sender_email };
}

export async function fetchContactMessages({ status = "all", page = 0, pageSize = 25 } = {}) {
  if (status !== "all" && !CONTACT_STATUSES.includes(status)) throw new Error("Nieprawidłowy status wiadomości.");
  const size = Math.min(100, Math.max(1, Math.floor(pageSize) || 25));
  const from = Math.max(0, Math.floor(page) || 0) * size;
  let query = supabase.from("contact_messages").select(COLUMNS, { count: "exact" });
  if (status !== "all") query = query.eq("status", status);
  const { data, error, count } = await withTimeout(query.order("created_at", { ascending: false }).order("id", { ascending: false }).range(from, from + size - 1));
  if (error) throw error;
  if (!Array.isArray(data)) throw new Error("Nie udało się potwierdzić pobrania wiadomości.");
  return { messages: data.map(mapMessage), count: count ?? data.length };
}

export async function updateContactMessageStatus(id, status) {
  if (!UUID_PATTERN.test(id || "") || !CONTACT_STATUSES.includes(status)) throw new Error("Nieprawidłowa wiadomość lub status.");
  const { data, error } = await withTimeout(supabase.from("contact_messages").update({ status }).eq("id", id).select(COLUMNS).single());
  if (error) throw error;
  if (data?.id !== id || data?.status !== status) throw new Error("Nie udało się potwierdzić zmiany statusu.");
  return mapMessage(data);
}
