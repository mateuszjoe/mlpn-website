import React, { useCallback, useEffect, useId, useRef, useState } from "react";
import { useAuth } from "../../contexts/AuthContext";
import { fetchContactMessages, updateContactMessageStatus } from "../../services/contactService";

const STATUS_LABELS = { new: "Nowa", read: "Przeczytana", archived: "Archiwum" };
const PAGE_SIZE = 25;
const dateFormat = new Intl.DateTimeFormat("pl-PL", { dateStyle: "short", timeStyle: "short", timeZone: "Europe/Warsaw" });

function displayDate(value) {
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? "Brak daty" : dateFormat.format(date);
}

export default function AdminContactMessages({ darkMode = false }) {
  const { isAdmin, can } = useAuth();
  const canManage = isAdmin || can("contact.manage");
  const canRead = canManage || can("contact.read");
  const filterId = useId();
  const [messages, setMessages] = useState([]);
  const [count, setCount] = useState(0);
  const [filter, setFilter] = useState("all");
  const [page, setPage] = useState(0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");
  const [opened, setOpened] = useState(null);
  const [saving, setSaving] = useState(null);
  const request = useRef(0);
  const savePending = useRef(false);
  const muted = darkMode ? "text-gray-300" : "text-gray-600";
  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const button = `px-3 py-2 rounded-lg border text-sm font-semibold disabled:opacity-50 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-500 ${darkMode ? "border-white/20 hover:bg-white/10" : "border-gray-300 hover:bg-gray-50"}`;

  const load = useCallback(async () => {
    if (!canRead) return;
    const current = ++request.current;
    setLoading(true);
    setError("");
    try {
      const result = await fetchContactMessages({ status: filter, page, pageSize: PAGE_SIZE });
      if (current !== request.current) return;
      if (page > 0 && result.messages.length === 0 && result.count <= page * PAGE_SIZE) {
        setPage(Math.max(0, Math.ceil(result.count / PAGE_SIZE) - 1));
        return;
      }
      setMessages(result.messages);
      setCount(result.count);
    } catch (_) {
      if (current === request.current) setError("Nie udało się pobrać skrzynki. Sprawdź połączenie i uprawnienia, a następnie spróbuj ponownie.");
    } finally {
      if (current === request.current) setLoading(false);
    }
  }, [canRead, filter, page]);

  useEffect(() => {
    load();
    return () => { request.current += 1; };
  }, [load]);

  const changeStatus = async (message, status) => {
    if (!canManage || savePending.current) return;
    savePending.current = true;
    setSaving(message.id);
    setError("");
    setNotice("");
    try {
      const updated = await updateContactMessageStatus(message.id, status);
      setMessages((previous) => previous.map((item) => item.id === updated.id ? updated : item));
      setNotice(`Zapisano status: ${STATUS_LABELS[updated.status]}.`);
      await load();
    } catch (_) {
      setError("Nie udało się potwierdzić zmiany statusu. Odśwież skrzynkę, aby sprawdzić aktualny stan, lub spróbuj ponownie.");
    } finally {
      savePending.current = false;
      setSaving(null);
    }
  };

  if (!canRead) return <p role="alert">Nie masz uprawnień do odczytu wiadomości kontaktowych.</p>;

  return (
    <section aria-labelledby={`${filterId}-heading`} className="space-y-5 min-w-0">
      <div>
        <h2 id={`${filterId}-heading`} className="text-2xl font-bold">Wiadomości kontaktowe</h2>
        <p className={`mt-1 text-sm ${muted}`}>Prywatna skrzynka wiadomości z formularza na stronie MLPN.</p>
        {!canManage && <p className={`mt-2 text-sm ${muted}`}>Masz dostęp do odczytu. Zmiana statusu wymaga uprawnień do zarządzania skrzynką.</p>}
      </div>
      <div className="flex flex-wrap items-end gap-3">
        <div>
          <label htmlFor={filterId} className="block text-sm font-semibold mb-1">Pokaż wiadomości</label>
          <select id={filterId} value={filter} disabled={loading || !!saving} onChange={(event) => { setFilter(event.target.value); setPage(0); setOpened(null); setNotice(""); }} className={`px-3 py-2 rounded-lg border ${darkMode ? "bg-gray-900 border-white/20" : "bg-white border-gray-300"}`}>
            <option value="all">Wszystkie</option><option value="new">Nowe</option><option value="read">Przeczytane</option><option value="archived">Archiwum</option>
          </select>
        </div>
        <button type="button" onClick={load} disabled={loading || !!saving} className={button}>Odśwież skrzynkę</button>
      </div>
      {error && <div role="alert" className={`p-4 rounded-lg ${darkMode ? "bg-red-500/10 text-red-300" : "bg-red-50 text-red-700"}`}>{error}</div>}
      {notice && <p role="status" className={darkMode ? "text-green-300" : "text-green-800"}>{notice}</p>}
      {loading && <p role="status" className={muted}>Ładowanie wiadomości…</p>}
      {!loading && !error && messages.length === 0 && <p className={`p-6 rounded-xl border ${card}`}>Brak wiadomości w wybranym widoku.</p>}
      <ul className="space-y-3" aria-busy={loading} aria-label="Lista wiadomości kontaktowych">
        {messages.map((message) => {
          const expanded = opened === message.id;
          const detailsId = `${filterId}-${message.id}`;
          return (
            <li key={message.id} className={`rounded-xl border overflow-hidden ${card}`}>
              <button type="button" aria-expanded={expanded} aria-controls={detailsId} onClick={() => setOpened(expanded ? null : message.id)} className="w-full p-4 text-left focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-green-500">
                <span className="flex flex-wrap items-center gap-x-3 gap-y-1"><span className="font-bold break-words min-w-0" style={{ overflowWrap: "anywhere" }}>{message.subject}</span><span className={`text-xs px-2 py-1 rounded-full ${message.status === "new" ? darkMode ? "bg-green-500/20 text-green-300" : "bg-green-100 text-green-900" : darkMode ? "bg-white/10 text-gray-300" : "bg-gray-100 text-gray-700"}`}>{STATUS_LABELS[message.status] || message.status}</span></span>
                <span className={`block text-sm mt-2 ${muted}`} style={{ overflowWrap: "anywhere" }}>{message.name} · {displayDate(message.created_at)}</span>
                <span className={`block text-xs mt-2 ${muted}`}>{expanded ? "Zwiń wiadomość" : "Otwórz wiadomość"}</span>
              </button>
              <div id={detailsId} hidden={!expanded} className={`p-4 border-t ${darkMode ? "border-white/10" : "border-gray-200"}`}>
                <dl className="text-sm space-y-1 mb-4"><div><dt className="inline font-semibold">Nadawca: </dt><dd className="inline" style={{ overflowWrap: "anywhere" }}>{message.name}</dd></div><div><dt className="inline font-semibold">E-mail: </dt><dd className="inline select-text" style={{ overflowWrap: "anywhere" }}>{message.email}</dd></div></dl>
                <p className="whitespace-pre-wrap" style={{ overflowWrap: "anywhere" }}>{message.message}</p>
                {canManage && <div className="flex flex-wrap gap-2 mt-5">
                  {message.status !== "read" && <button type="button" disabled={!!saving || loading} className={button} onClick={() => changeStatus(message, "read")}>Oznacz jako przeczytaną</button>}
                  {message.status !== "new" && <button type="button" disabled={!!saving || loading} className={button} onClick={() => changeStatus(message, "new")}>Oznacz jako nową</button>}
                  {message.status !== "archived" && <button type="button" disabled={!!saving || loading} className={button} onClick={() => changeStatus(message, "archived")}>Archiwizuj</button>}
                </div>}
                {saving === message.id && <p role="status" className={`mt-2 text-sm ${muted}`}>Zapisywanie statusu…</p>}
              </div>
            </li>
          );
        })}
      </ul>
      {count > 0 && <nav aria-label="Strony wiadomości" className="flex flex-wrap items-center gap-3">
        <button type="button" className={button} disabled={page === 0 || loading || !!saving} onClick={() => { setPage((value) => value - 1); setOpened(null); }}>Poprzednia</button>
        <span className={`text-sm ${muted}`}>Strona {page + 1} z {Math.max(1, Math.ceil(count / PAGE_SIZE))} · Wiadomości: {count}</span>
        <button type="button" className={button} disabled={(page + 1) * PAGE_SIZE >= count || loading || !!saving} onClick={() => { setPage((value) => value + 1); setOpened(null); }}>Następna</button>
      </nav>}
    </section>
  );
}
