import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  Edit3,
  ExternalLink,
  Eye,
  Handshake,
  Plus,
  Save,
  Trash2,
  X,
} from "lucide-react";
import { supabase } from "../../lib/supabase";
import { useAuth } from "../../contexts/AuthContext";
import AdminAlert from "./components/AdminAlert";
import AdminFormField from "./components/AdminFormField";
import AdminImageUpload from "./components/AdminImageUpload";

const SPONSOR_CATEGORIES = [
  { value: "sponsor_tytularny", label: "Sponsor tytularny" },
  { value: "sponsor_techniczny", label: "Sponsor techniczny" },
  { value: "sponsor", label: "Sponsor" },
];

const SPONSOR_PROFILE_MARKER = "[MLPN_SPONSOR_PROFILE]";

const emptyForm = () => ({
  name: "",
  category: "sponsor",
  logo_url: "",
  website_url: "",
  facebook_url: "",
  instagram_url: "",
  contact_email: "",
  phone: "",
  cta_label: "Odwiedz strone",
  short_description: "",
  description: "",
  profile_slug: "",
  display_order: 0,
  is_active: true,
});

function slugify(value) {
  return String(value || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 80);
}

function categoryLabel(value) {
  return SPONSOR_CATEGORIES.find((item) => item.value === value)?.label || "Sponsor";
}

function parseCompatDescription(rawDescription = "") {
  const raw = String(rawDescription || "");
  if (!raw.startsWith(SPONSOR_PROFILE_MARKER)) {
    return { description: raw, meta: {} };
  }

  try {
    const meta = JSON.parse(raw.slice(SPONSOR_PROFILE_MARKER.length).trim());
    return {
      description: meta.description || "",
      meta: meta && typeof meta === "object" ? meta : {},
    };
  } catch {
    return { description: raw, meta: {} };
  }
}

function buildCompatDescription(payload) {
  return `${SPONSOR_PROFILE_MARKER}${JSON.stringify({
    description: payload.description || "",
    category: payload.category || "sponsor",
    profileSlug: payload.profile_slug || "",
    shortDescription: payload.short_description || "",
    facebookUrl: payload.facebook_url || "",
    instagramUrl: payload.instagram_url || "",
    contactEmail: payload.contact_email || "",
    phone: payload.phone || "",
    ctaLabel: payload.cta_label || "",
  })}`;
}

function normalizeSponsor(row = {}) {
  const { description, meta } = parseCompatDescription(row.description);
  const rowCategory = row.category || "";
  const metaCategory = meta.category || "";

  return {
    ...row,
    description,
    category: rowCategory && rowCategory !== "sponsor" ? rowCategory : metaCategory || rowCategory || "sponsor",
    profile_slug: row.profile_slug || meta.profileSlug || "",
    short_description: row.short_description || meta.shortDescription || "",
    facebook_url: row.facebook_url || meta.facebookUrl || "",
    instagram_url: row.instagram_url || meta.instagramUrl || "",
    contact_email: row.contact_email || meta.contactEmail || "",
    phone: row.phone || meta.phone || "",
    cta_label: row.cta_label || meta.ctaLabel || "Odwiedz strone",
    is_active: row.is_active !== false,
  };
}

function schemaHint(error) {
  const message = error?.message || "";
  if (message.includes("category") || message.includes("profile_slug") || message.includes("short_description")) {
    return "Brakuje nowych kolumn sponsorow w Supabase. Uruchom migracje 019_sponsor_profiles.sql, a potem zapisz ponownie.";
  }
  return message || "Operacja nie powiodla sie.";
}

function isMissingSponsorColumnError(error) {
  const message = error?.message || "";
  return (
    message.includes("category") ||
    message.includes("profile_slug") ||
    message.includes("short_description") ||
    message.includes("facebook_url") ||
    message.includes("instagram_url") ||
    message.includes("contact_email") ||
    message.includes("cta_label")
  );
}

export default function AdminSponsors({ darkMode }) {
  const { isAdmin, can } = useAuth();
  const [sponsors, setSponsors] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState(emptyForm);
  const [alert, setAlert] = useState({ type: null, message: null });

  const canCreate = isAdmin || can("sponsors.create");
  const canEdit = isAdmin || can("sponsors.edit");
  const canDelete = isAdmin || can("sponsors.delete");
  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const muted = darkMode ? "text-gray-400" : "text-gray-500";
  const inputHelp = "Docelowo wklej tutaj adres pliku z hostingu strony. Upload ponizej dziala pomocniczo, jesli bucket sponsor-logos jest skonfigurowany w Supabase.";

  const loadSponsors = useCallback(async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from("sponsors")
        .select("*")
        .order("display_order", { ascending: true })
        .order("name", { ascending: true });

      if (error) throw error;
      setSponsors((data || []).map(normalizeSponsor));
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udalo sie wczytac sponsorow." });
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadSponsors();
  }, [loadSponsors]);

  const groupedSponsors = useMemo(() => {
    return SPONSOR_CATEGORIES.map((category) => ({
      ...category,
      sponsors: sponsors.filter((sponsor) => sponsor.category === category.value),
    }));
  }, [sponsors]);

  function handleChange(event) {
    const { name, value } = event.target;
    setForm((current) => ({ ...current, [name]: value }));
  }

  function openCreate() {
    setEditingId(null);
    setForm(emptyForm());
    setShowForm(true);
  }

  function openEdit(sponsor) {
    setEditingId(sponsor.id);
    setForm({
      name: sponsor.name || "",
      category: sponsor.category || "sponsor",
      logo_url: sponsor.logo_url || "",
      website_url: sponsor.website_url || "",
      facebook_url: sponsor.facebook_url || "",
      instagram_url: sponsor.instagram_url || "",
      contact_email: sponsor.contact_email || "",
      phone: sponsor.phone || "",
      cta_label: sponsor.cta_label || "Odwiedz strone",
      short_description: sponsor.short_description || "",
      description: sponsor.description || "",
      profile_slug: sponsor.profile_slug || "",
      display_order: sponsor.display_order ?? 0,
      is_active: sponsor.is_active !== false,
    });
    setShowForm(true);
  }

  function closeForm() {
    setEditingId(null);
    setForm(emptyForm());
    setShowForm(false);
  }

  async function handleSubmit(event) {
    event.preventDefault();
    const name = form.name.trim();

    if (!name) {
      setAlert({ type: "error", message: "Podaj nazwe sponsora." });
      return;
    }

    setSaving(true);
    try {
      const payload = {
        name,
        category: form.category || "sponsor",
        logo_url: form.logo_url.trim() || null,
        website_url: form.website_url.trim() || null,
        facebook_url: form.facebook_url.trim() || null,
        instagram_url: form.instagram_url.trim() || null,
        contact_email: form.contact_email.trim() || null,
        phone: form.phone.trim() || null,
        cta_label: form.cta_label.trim() || "Odwiedz strone",
        short_description: form.short_description.trim() || null,
        description: form.description.trim() || null,
        profile_slug: (form.profile_slug.trim() || slugify(name)) || null,
        display_order: Number(form.display_order || 0),
        is_active: !!form.is_active,
        updated_at: new Date().toISOString(),
      };

      let result = editingId
        ? await supabase.from("sponsors").update(payload).eq("id", editingId)
        : await supabase.from("sponsors").insert(payload);

      let savedInCompatMode = false;
      if (result.error && isMissingSponsorColumnError(result.error)) {
        const fallbackPayload = {
          name: payload.name,
          logo_url: payload.logo_url,
          website_url: payload.website_url,
          description: buildCompatDescription(payload),
          display_order: payload.display_order,
          is_active: payload.is_active,
          updated_at: payload.updated_at,
        };
        result = editingId
          ? await supabase.from("sponsors").update(fallbackPayload).eq("id", editingId)
          : await supabase.from("sponsors").insert(fallbackPayload);
        savedInCompatMode = true;
      }

      if (result.error) throw result.error;

      setAlert({
        type: savedInCompatMode ? "warning" : "success",
        message: savedInCompatMode
          ? "Sponsor zapisany. Baza dziala jeszcze w trybie kompatybilnym - po migracji pola profilu beda osobnymi kolumnami."
          : editingId
          ? "Sponsor zaktualizowany."
          : "Sponsor dodany.",
      });
      closeForm();
      await loadSponsors();
    } catch (error) {
      setAlert({ type: "error", message: schemaHint(error) });
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete(sponsor) {
    if (!window.confirm(`Usunac sponsora "${sponsor.name}"?`)) return;

    try {
      const { error } = await supabase.from("sponsors").delete().eq("id", sponsor.id);
      if (error) throw error;
      setAlert({ type: "success", message: "Sponsor usuniety." });
      await loadSponsors();
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udalo sie usunac sponsora." });
    }
  }

  return (
    <div className="space-y-5">
      <AdminAlert
        type={alert.type}
        message={alert.message}
        onClose={() => setAlert({ type: null, message: null })}
      />

      <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
        <div>
          <div className="flex items-center gap-2 text-2xl font-bold">
            <Handshake size={26} />
            Sponsorzy
          </div>
          <p className={`mt-1 text-sm ${muted}`}>
            Dodawaj logo, opisy, linki i kategorie. Aktywni sponsorzy pojawia sie na stronie oraz dostaja wlasny profil.
          </p>
        </div>
        {canCreate && (
          <button
            onClick={openCreate}
            className="inline-flex items-center justify-center gap-2 rounded-xl bg-yellow-500 px-4 py-2 font-semibold text-black transition-colors hover:bg-yellow-400"
          >
            <Plus size={18} />
            Dodaj sponsora
          </button>
        )}
      </div>

      {showForm && (canCreate || canEdit) && (
        <form onSubmit={handleSubmit} className={`rounded-2xl border p-4 shadow-sm ${card}`}>
          <div className="mb-4 flex items-center justify-between gap-3">
            <div>
              <div className="text-lg font-bold">{editingId ? "Edytuj sponsora" : "Nowy sponsor"}</div>
              <div className={`text-xs ${muted}`}>Profil publiczny z logo, opisem i linkami.</div>
            </div>
            <button
              type="button"
              onClick={closeForm}
              className={`rounded-xl p-2 transition-colors ${darkMode ? "hover:bg-white/10" : "hover:bg-gray-100"}`}
              title="Zamknij"
            >
              <X size={18} />
            </button>
          </div>

          <div className="grid gap-4 lg:grid-cols-[minmax(0,1fr)_320px]">
            <div className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2">
                <AdminFormField
                  label="Nazwa firmy"
                  name="name"
                  value={form.name}
                  onChange={handleChange}
                  required
                  darkMode={darkMode}
                />
                <AdminFormField
                  label="Kategoria sponsora"
                  name="category"
                  type="select"
                  options={SPONSOR_CATEGORIES}
                  value={form.category}
                  onChange={handleChange}
                  required
                  darkMode={darkMode}
                />
              </div>

              <div className="grid gap-4 md:grid-cols-2">
                <AdminFormField
                  label="Logo URL"
                  name="logo_url"
                  value={form.logo_url}
                  onChange={handleChange}
                  darkMode={darkMode}
                  placeholder="https://twoj-hosting.pl/sponsorzy/logo.webp"
                  helpText={inputHelp}
                />
                <AdminFormField
                  label="Slug profilu"
                  name="profile_slug"
                  value={form.profile_slug}
                  onChange={handleChange}
                  darkMode={darkMode}
                  placeholder={form.name ? slugify(form.name) : "np. isola-ristorante"}
                  helpText="Jesli zostawisz puste, zostanie wygenerowany z nazwy firmy."
                />
              </div>

              <AdminFormField
                label="Krotki opis"
                name="short_description"
                value={form.short_description}
                onChange={handleChange}
                darkMode={darkMode}
                placeholder="Jedno zdanie do kart sponsorskich."
              />

              <AdminFormField
                label="Opis firmy"
                name="description"
                type="textarea"
                value={form.description}
                onChange={handleChange}
                darkMode={darkMode}
                placeholder="Opis widoczny na profilu sponsora."
              />

              <div className="grid gap-4 md:grid-cols-2">
                <AdminFormField
                  label="Strona WWW"
                  name="website_url"
                  value={form.website_url}
                  onChange={handleChange}
                  darkMode={darkMode}
                  placeholder="https://..."
                />
                <AdminFormField
                  label="Etykieta przycisku"
                  name="cta_label"
                  value={form.cta_label}
                  onChange={handleChange}
                  darkMode={darkMode}
                />
                <AdminFormField
                  label="Facebook"
                  name="facebook_url"
                  value={form.facebook_url}
                  onChange={handleChange}
                  darkMode={darkMode}
                  placeholder="https://facebook.com/..."
                />
                <AdminFormField
                  label="Instagram"
                  name="instagram_url"
                  value={form.instagram_url}
                  onChange={handleChange}
                  darkMode={darkMode}
                  placeholder="https://instagram.com/..."
                />
                <AdminFormField
                  label="Email kontaktowy"
                  name="contact_email"
                  value={form.contact_email}
                  onChange={handleChange}
                  darkMode={darkMode}
                />
                <AdminFormField
                  label="Telefon"
                  name="phone"
                  value={form.phone}
                  onChange={handleChange}
                  darkMode={darkMode}
                />
              </div>

              <div className="grid gap-4 md:grid-cols-2">
                <AdminFormField
                  label="Kolejnosc wyswietlania"
                  name="display_order"
                  type="number"
                  value={form.display_order}
                  onChange={handleChange}
                  darkMode={darkMode}
                  min={0}
                />
                <div className="flex items-end pb-2">
                  <AdminFormField
                    label="Aktywny na stronie"
                    name="is_active"
                    type="checkbox"
                    value={form.is_active}
                    onChange={({ target }) => setForm((current) => ({ ...current, is_active: target.value }))}
                    darkMode={darkMode}
                  />
                </div>
              </div>
            </div>

            <div className={`rounded-2xl border p-4 ${darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"}`}>
              <AdminImageUpload
                bucket="sponsor-logos"
                folder="logos"
                currentUrl={form.logo_url}
                onUpload={(url) => setForm((current) => ({ ...current, logo_url: url }))}
                darkMode={darkMode}
                label="Upload logo"
                maxFileSizeMB={2}
                convertToWebp
                webpMaxSide={1200}
                helperText="Opcjonalnie: uzyj tylko wtedy, gdy w Supabase istnieje bucket sponsor-logos. W przeciwnym razie wklej URL logo z hostingu."
              />

              <div className={`mt-4 rounded-2xl border p-4 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white"}`}>
                <div className={`text-[10px] font-black uppercase tracking-[0.16em] ${muted}`}>
                  Podglad karty
                </div>
                <div className="mt-3 flex items-center gap-3">
                  <div className={`flex h-16 w-16 shrink-0 items-center justify-center rounded-2xl border p-2 ${darkMode ? "border-white/10 bg-white" : "border-gray-200 bg-white"}`}>
                    {form.logo_url ? (
                      <img src={form.logo_url} alt="" className="h-full w-full object-contain" />
                    ) : (
                      <Handshake size={24} className={darkMode ? "text-gray-500" : "text-gray-400"} />
                    )}
                  </div>
                  <div className="min-w-0">
                    <div className="truncate font-black">{form.name || "Nazwa sponsora"}</div>
                    <div className={`text-xs ${muted}`}>{categoryLabel(form.category)}</div>
                  </div>
                </div>
                <p className={`mt-3 text-sm ${darkMode ? "text-gray-300" : "text-gray-700"}`}>
                  {form.short_description || form.description || "Krotki opis sponsora pojawi sie tutaj."}
                </p>
              </div>
            </div>
          </div>

          <div className="mt-4 flex flex-col gap-2 sm:flex-row sm:justify-end">
            <button
              type="button"
              onClick={closeForm}
              className={`rounded-xl border px-4 py-2 font-semibold transition-colors ${darkMode ? "border-white/10 hover:bg-white/10" : "border-gray-200 hover:bg-gray-50"}`}
            >
              Anuluj
            </button>
            <button
              type="submit"
              disabled={saving || (editingId ? !canEdit : !canCreate)}
              className="inline-flex items-center justify-center gap-2 rounded-xl bg-green-600 px-5 py-2 font-semibold text-white transition-colors hover:bg-green-500 disabled:cursor-not-allowed disabled:opacity-50"
            >
              <Save size={18} />
              {saving ? "Zapisuje..." : "Zapisz sponsora"}
            </button>
          </div>
        </form>
      )}

      <div className="grid gap-4 xl:grid-cols-3">
        {groupedSponsors.map((group) => (
          <section key={group.value} className={`rounded-2xl border p-4 ${card}`}>
            <div className="mb-3 flex items-center justify-between gap-3">
              <div>
                <div className="font-bold">{group.label}</div>
                <div className={`text-xs ${muted}`}>{group.sponsors.length} pozycji</div>
              </div>
            </div>

            {loading ? (
              <div className={`py-6 text-center text-sm ${muted}`}>Ladowanie...</div>
            ) : group.sponsors.length === 0 ? (
              <div className={`rounded-xl border border-dashed p-4 text-sm ${darkMode ? "border-white/10 text-gray-400" : "border-gray-300 text-gray-500"}`}>
                Brak sponsorow w tej kategorii.
              </div>
            ) : (
              <div className="space-y-2">
                {group.sponsors.map((sponsor) => (
                  <div
                    key={sponsor.id}
                    className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"}`}
                  >
                    <div className="flex items-center gap-3">
                      <div className={`flex h-12 w-12 shrink-0 items-center justify-center rounded-xl border p-1.5 ${darkMode ? "border-white/10 bg-white" : "border-gray-200 bg-white"}`}>
                        {sponsor.logo_url ? (
                          <img src={sponsor.logo_url} alt="" className="h-full w-full object-contain" />
                        ) : (
                          <Handshake size={20} className={darkMode ? "text-gray-500" : "text-gray-400"} />
                        )}
                      </div>
                      <div className="min-w-0 flex-1">
                        <div className="truncate font-bold">{sponsor.name}</div>
                        <div className={`truncate text-xs ${muted}`}>
                          {sponsor.is_active ? "Widoczny" : "Ukryty"} {sponsor.profile_slug ? `- /sponsor/${sponsor.profile_slug}` : ""}
                        </div>
                      </div>
                    </div>

                    <div className="mt-3 flex flex-wrap gap-2">
                      {sponsor.website_url && (
                        <a
                          href={sponsor.website_url}
                          target="_blank"
                          rel="noreferrer"
                          className={`inline-flex items-center gap-1 rounded-lg border px-2 py-1 text-xs font-semibold ${darkMode ? "border-white/10 hover:bg-white/10" : "border-gray-200 hover:bg-white"}`}
                        >
                          <ExternalLink size={13} />
                          WWW
                        </a>
                      )}
                      {canEdit && (
                        <button
                          onClick={() => openEdit(sponsor)}
                          className={`inline-flex items-center gap-1 rounded-lg border px-2 py-1 text-xs font-semibold ${darkMode ? "border-white/10 hover:bg-white/10" : "border-gray-200 hover:bg-white"}`}
                        >
                          <Edit3 size={13} />
                          Edytuj
                        </button>
                      )}
                      {canDelete && (
                        <button
                          onClick={() => handleDelete(sponsor)}
                          className="inline-flex items-center gap-1 rounded-lg border border-red-400/30 px-2 py-1 text-xs font-semibold text-red-400 hover:bg-red-500/10"
                        >
                          <Trash2 size={13} />
                          Usun
                        </button>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </section>
        ))}
      </div>

      {!loading && sponsors.length === 0 && !showForm && (
        <div className={`rounded-2xl border p-8 text-center ${card}`}>
          <Eye size={34} className={`mx-auto mb-3 ${muted}`} />
          <div className="text-lg font-bold">Nie ma jeszcze sponsorow</div>
          <p className={`mt-1 text-sm ${muted}`}>
            Dodaj pierwszego sponsora, a pojawi sie na stronie publicznej i w module sponsorow.
          </p>
        </div>
      )}
    </div>
  );
}
