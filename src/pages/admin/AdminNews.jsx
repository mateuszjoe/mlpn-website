import React, { useCallback, useEffect, useMemo, useState } from "react";
import { AlertTriangle, Megaphone, PauseCircle, Plus, Trash2 } from "lucide-react";
import { supabase } from "../../lib/supabase";
import { useAuth } from "../../contexts/AuthContext";
import AdminAlert from "./components/AdminAlert";
import AdminFormField from "./components/AdminFormField";
import AdminModal from "./components/AdminModal";

const CATEGORY_OPTIONS = [
  { value: "komunikat", label: "Organizacyjne", tone: "blue" },
  { value: "pauza", label: "Pauzy", tone: "yellow" },
  { value: "wazne", label: "WAŻNE", tone: "red" },
];

const defaultForm = () => ({
  category: "komunikat",
  title: "",
  body: "",
  season_id: "",
  is_published: true,
  published_at: toDatetimeLocal(new Date()),
  suspended_text: "",
});

function pad(value) {
  return String(value).padStart(2, "0");
}

function toDatetimeLocal(value) {
  if (!value) return "";
  const date = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(date.getTime())) return "";

  return [
    date.getFullYear(),
    "-",
    pad(date.getMonth() + 1),
    "-",
    pad(date.getDate()),
    "T",
    pad(date.getHours()),
    ":",
    pad(date.getMinutes()),
  ].join("");
}

function fromDatetimeLocal(value) {
  if (!value) return null;
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? null : date.toISOString();
}

function categoryMeta(category) {
  return CATEGORY_OPTIONS.find((item) => item.value === category) || CATEGORY_OPTIONS[0];
}

function suspendedToText(value) {
  if (!Array.isArray(value)) return "";
  return value
    .map((item) => {
      if (typeof item === "string") return item;
      return [item?.name, item?.team, item?.playerId].filter(Boolean).join(" | ");
    })
    .filter(Boolean)
    .join("\n");
}

function textToSuspendedPlayers(value) {
  const rows = String(value || "")
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean);

  if (!rows.length) return null;

  return rows.map((line) => {
    const [name, team, playerId] = line.split("|").map((part) => part.trim());
    return {
      name: name || line,
      team: team || "",
      playerId: playerId || null,
    };
  });
}

function formatDate(value) {
  if (!value) return "Nieopublikowane";
  return new Intl.DateTimeFormat("pl-PL", {
    dateStyle: "short",
    timeStyle: "short",
  }).format(new Date(value));
}

export default function AdminNews({ darkMode }) {
  const { isAdmin, can } = useAuth();
  const [news, setNews] = useState([]);
  const [seasons, setSeasons] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [showForm, setShowForm] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(defaultForm);
  const [filter, setFilter] = useState("all");
  const [alert, setAlert] = useState({ type: null, message: null });

  const canCreate = isAdmin || can("news.create");
  const canEdit = isAdmin || can("news.edit");
  const canDelete = isAdmin || can("news.delete");
  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const loadData = useCallback(async () => {
    setLoading(true);
    try {
      const [{ data: newsRows, error: newsError }, { data: seasonRows, error: seasonError }] = await Promise.all([
        supabase
          .from("news")
          .select("*, seasons(id, name, year)")
          .order("created_at", { ascending: false }),
        supabase.from("seasons").select("id, name, year").order("year", { ascending: false }),
      ]);

      if (newsError) throw newsError;
      if (seasonError) throw seasonError;

      setNews(newsRows || []);
      setSeasons(seasonRows || []);
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się wczytać aktualności." });
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const filteredNews = useMemo(() => {
    if (filter === "all") return news;
    return news.filter((item) => item.category === filter);
  }, [filter, news]);

  function handleChange(e) {
    const { name, value } = e.target;
    setForm((current) => ({ ...current, [name]: value }));
  }

  function openCreateForm() {
    setEditId(null);
    setForm(defaultForm());
    setShowForm(true);
  }

  function openEditForm(item) {
    setEditId(item.id);
    setForm({
      category: item.category || "komunikat",
      title: item.title || "",
      body: item.body || "",
      season_id: item.season_id || "",
      is_published: !!item.is_published,
      published_at: toDatetimeLocal(item.published_at || item.created_at || new Date()),
      suspended_text: suspendedToText(item.suspended_players),
    });
    setShowForm(true);
  }

  function closeForm() {
    setShowForm(false);
    setEditId(null);
    setForm(defaultForm());
  }

  async function handleSubmit(e) {
    e.preventDefault();

    const title = form.title.trim();
    if (!title) {
      setAlert({ type: "error", message: "Podaj tytuł aktualności." });
      return;
    }

    setSaving(true);
    try {
      const publishedAt =
        form.is_published
          ? fromDatetimeLocal(form.published_at) || new Date().toISOString()
          : fromDatetimeLocal(form.published_at);

      const payload = {
        category: form.category,
        title,
        body: form.body.trim() || null,
        suspended_players: form.category === "pauza" ? textToSuspendedPlayers(form.suspended_text) : null,
        season_id: form.season_id || null,
        is_published: !!form.is_published,
        published_at: publishedAt,
        updated_at: new Date().toISOString(),
      };

      const result = editId
        ? await supabase.from("news").update(payload).eq("id", editId)
        : await supabase.from("news").insert(payload);

      if (result.error) throw result.error;

      setAlert({ type: "success", message: editId ? "Aktualność zaktualizowana." : "Aktualność dodana." });
      closeForm();
      await loadData();
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się zapisać aktualności." });
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete(item) {
    if (!window.confirm(`Usunąć aktualność "${item.title}"?`)) return;

    try {
      const { error } = await supabase.from("news").delete().eq("id", item.id);
      if (error) throw error;
      setAlert({ type: "success", message: "Aktualność usunięta." });
      await loadData();
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się usunąć aktualności." });
    }
  }

  const CategoryIcon =
    form.category === "pauza" ? PauseCircle : form.category === "wazne" ? AlertTriangle : Megaphone;

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-2 border-yellow-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold">Aktualności</h2>
          <p className={`text-sm ${textMuted}`}>
            Komunikaty organizacyjne, pauzy zawodników i ważne ogłoszenia na stronie.
          </p>
        </div>
        {canCreate && (
          <button
            type="button"
            onClick={openCreateForm}
            className="flex items-center gap-2 px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors text-sm"
          >
            <Plus size={16} /> Dodaj aktualność
          </button>
        )}
      </div>

      <AdminAlert type={alert.type} message={alert.message} onClose={() => setAlert({ type: null, message: null })} />

      <div className="flex flex-wrap gap-2">
        {[{ value: "all", label: "Wszystkie" }, ...CATEGORY_OPTIONS].map((item) => (
          <button
            key={item.value}
            type="button"
            onClick={() => setFilter(item.value)}
            className={`px-3 py-2 rounded-xl border text-sm font-medium transition-colors ${
              filter === item.value
                ? "bg-yellow-500/10 border-yellow-500/40 text-yellow-400"
                : darkMode
                ? "border-white/10 bg-white/5 text-gray-300 hover:bg-white/10"
                : "border-gray-200 bg-white text-gray-700 hover:bg-gray-50"
            }`}
          >
            {item.label}
          </button>
        ))}
      </div>

      <div className="grid gap-3">
        {filteredNews.length === 0 ? (
          <div className={`rounded-2xl border p-8 text-center ${card} ${textMuted}`}>
            Brak aktualności w tej kategorii.
          </div>
        ) : (
          filteredNews.map((item) => {
            const meta = categoryMeta(item.category);
            const Icon = item.category === "pauza" ? PauseCircle : item.category === "wazne" ? AlertTriangle : Megaphone;

            return (
              <div key={item.id} className={`rounded-2xl border p-4 ${card}`}>
                <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                  <div className="min-w-0 flex-1">
                    <div className="flex flex-wrap items-center gap-2">
                      <span
                        className={`inline-flex items-center gap-1 rounded-full border px-2.5 py-1 text-[11px] font-black uppercase tracking-[0.14em] ${
                          meta.tone === "red"
                            ? "border-red-400/30 bg-red-500/10 text-red-400"
                            : meta.tone === "yellow"
                            ? "border-yellow-400/30 bg-yellow-500/10 text-yellow-400"
                            : "border-blue-400/30 bg-blue-500/10 text-blue-400"
                        }`}
                      >
                        <Icon size={13} /> {meta.label}
                      </span>
                      <span className={`text-xs ${textMuted}`}>{formatDate(item.published_at)}</span>
                      {!item.is_published && (
                        <span className="rounded-full bg-gray-500/10 px-2 py-1 text-[11px] font-bold text-gray-400">
                          Szkic
                        </span>
                      )}
                    </div>
                    <h3 className="mt-2 text-lg font-bold">{item.title}</h3>
                    {item.body && <p className={`mt-1 line-clamp-2 text-sm ${textMuted}`}>{item.body}</p>}
                    {item.category === "pauza" && Array.isArray(item.suspended_players) && item.suspended_players.length > 0 && (
                      <div className={`mt-2 text-xs ${textMuted}`}>
                        Pauzujący: {item.suspended_players.map((player) => player?.name || player).filter(Boolean).join(", ")}
                      </div>
                    )}
                  </div>

                  <div className="flex shrink-0 flex-wrap justify-end gap-2">
                    {canEdit && (
                      <button
                        type="button"
                        onClick={() => openEditForm(item)}
                        className="rounded-xl border border-blue-400/30 px-3 py-2 text-sm font-medium text-blue-400 hover:bg-blue-500/10"
                      >
                        Edytuj
                      </button>
                    )}
                    {canDelete && (
                      <button
                        type="button"
                        onClick={() => handleDelete(item)}
                        className="inline-flex items-center gap-2 rounded-xl border border-red-400/30 px-3 py-2 text-sm font-medium text-red-400 hover:bg-red-500/10"
                      >
                        <Trash2 size={15} /> Usuń
                      </button>
                    )}
                  </div>
                </div>
              </div>
            );
          })
        )}
      </div>

      <AdminModal
        isOpen={showForm}
        onClose={closeForm}
        title={editId ? "Edytuj aktualność" : "Nowa aktualność"}
        darkMode={darkMode}
        wide
      >
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <AdminFormField
              label="Kategoria"
              name="category"
              type="select"
              value={form.category}
              onChange={handleChange}
              darkMode={darkMode}
              required
              options={CATEGORY_OPTIONS}
            />
            <AdminFormField
              label="Sezon"
              name="season_id"
              type="select"
              value={form.season_id}
              onChange={handleChange}
              darkMode={darkMode}
              options={seasons.map((season) => ({
                value: season.id,
                label: season.name || `Sezon ${season.year}`,
              }))}
            />
          </div>

          <AdminFormField
            label="Tytuł"
            name="title"
            value={form.title}
            onChange={handleChange}
            darkMode={darkMode}
            required
            placeholder="np. Zawieszenia po 3. kolejce"
          />

          <AdminFormField
            label="Treść"
            name="body"
            type="textarea"
            value={form.body}
            onChange={handleChange}
            darkMode={darkMode}
            placeholder="Wpisz treść komunikatu widoczną na stronie."
          />

          {form.category === "pauza" && (
            <div className={`rounded-xl border p-4 ${darkMode ? "border-yellow-500/20 bg-yellow-500/5" : "border-yellow-200 bg-yellow-50"}`}>
              <div className="mb-3 flex items-start gap-2">
                <CategoryIcon size={18} className="mt-0.5 text-yellow-400" />
                <div>
                  <div className="text-sm font-semibold">Lista pauzujących</div>
                  <div className={`text-xs ${textMuted}`}>
                    Jedna osoba w linii. Opcjonalny format: Imię Nazwisko | Drużyna | ID zawodnika.
                  </div>
                </div>
              </div>
              <AdminFormField
                label="Pauzujący zawodnicy"
                name="suspended_text"
                type="textarea"
                value={form.suspended_text}
                onChange={handleChange}
                darkMode={darkMode}
                placeholder={"Jan Kowalski | FC Przykład\nAdam Nowak | KS Test"}
              />
            </div>
          )}

          <div className={`rounded-xl border p-4 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <AdminFormField
                label="Data publikacji"
                name="published_at"
                type="datetime-local"
                value={form.published_at}
                onChange={handleChange}
                darkMode={darkMode}
              />
              <div className="flex items-end">
                <AdminFormField
                  label="Opublikowana"
                  name="is_published"
                  type="checkbox"
                  value={form.is_published}
                  onChange={handleChange}
                  darkMode={darkMode}
                />
              </div>
            </div>
          </div>

          <div className="flex justify-end gap-3 pt-2">
            <button type="button" onClick={closeForm} className={`px-4 py-2 rounded-xl text-sm ${textMuted}`}>
              Anuluj
            </button>
            <button
              type="submit"
              disabled={saving}
              className="px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium text-sm hover:bg-yellow-400 disabled:opacity-50"
            >
              {saving ? "Zapisywanie..." : editId ? "Zapisz" : "Dodaj aktualność"}
            </button>
          </div>
        </form>
      </AdminModal>
    </div>
  );
}
