import React, { useCallback, useEffect, useMemo, useState } from "react";
import { supabase } from "../../lib/supabase";
import AdminAlert from "./components/AdminAlert";
import {
  Vote,
  Target,
  KeyRound,
  ShieldCheck,
  UserPlus,
  Loader2,
  Mail,
  Info,
  RefreshCw,
  CheckSquare,
  Square,
} from "lucide-react";

function TabButton({ active, onClick, icon, children, darkMode }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={[
        "inline-flex items-center gap-2 px-3 py-2 rounded-xl border text-sm font-semibold transition-colors",
        active
          ? darkMode
            ? "bg-yellow-500/10 text-yellow-300 border-yellow-400/30"
            : "bg-yellow-50 text-yellow-700 border-yellow-200"
          : darkMode
          ? "bg-white/5 border-white/10 text-gray-300 hover:bg-white/10"
          : "bg-white border-gray-200 text-gray-700 hover:bg-gray-50",
      ].join(" ")}
    >
      {icon}
      {children}
    </button>
  );
}

function SectionCard({ darkMode, title, subtitle, children, icon }) {
  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";
  return (
    <div className={`rounded-2xl border p-4 ${card}`}>
      <div className="flex items-start gap-3 mb-4">
        <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${darkMode ? "bg-white/5" : "bg-gray-100"}`}>
          {icon}
        </div>
        <div>
          <h3 className="text-lg font-bold">{title}</h3>
          {subtitle && <p className={`text-sm mt-1 ${textMuted}`}>{subtitle}</p>}
        </div>
      </div>
      {children}
    </div>
  );
}

function toLocalDatetimeValue(dateObj) {
  if (!dateObj) return "";
  const d = new Date(dateObj);
  if (Number.isNaN(d.getTime())) return "";
  const pad = (n) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function TeamLogoThumb({ src, name, darkMode }) {
  const resolvedSrc = (() => {
    const raw = String(src || "").trim();
    if (!raw) return "";
    if (/^(https?:|data:|blob:)/i.test(raw)) return raw;
    return supabase.storage.from("team-logos").getPublicUrl(raw).data?.publicUrl || raw;
  })();
  const initial = String(name || "?").trim().charAt(0).toUpperCase() || "?";
  return (
    <div
      className={`w-8 h-8 rounded-full border shrink-0 flex items-center justify-center overflow-hidden ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white"}`}
      title={name || ""}
    >
      {resolvedSrc ? (
        <img
          src={encodeURI(resolvedSrc)}
          alt={name || ""}
          className="w-6 h-6 object-contain"
          onError={(e) => {
            e.currentTarget.style.display = "none";
            const fallback = e.currentTarget.nextElementSibling;
            if (fallback) fallback.style.display = "flex";
          }}
        />
      ) : null}
      <span
        style={{ display: resolvedSrc ? "none" : "flex" }}
        className={`w-full h-full items-center justify-center text-[10px] font-bold ${darkMode ? "text-gray-300" : "text-gray-600"}`}
      >
        {initial}
      </span>
    </div>
  );
}

export default function AdminControlCenter({ darkMode }) {
  const [tab, setTab] = useState("polls");
  const [alert, setAlert] = useState({ type: null, message: null });

  const [password, setPassword] = useState("");
  const [password2, setPassword2] = useState("");
  const [pwLoading, setPwLoading] = useState(false);

  const [inviteEmail, setInviteEmail] = useState("");
  const [inviteRole, setInviteRole] = useState("subadmin");
  const [permissionSearch, setPermissionSearch] = useState("");

  const [seasons, setSeasons] = useState([]);
  const [leagues, setLeagues] = useState([]);
  const [metaLoading, setMetaLoading] = useState(true);

  const [pollForm, setPollForm] = useState({
    title: "",
    option1: "",
    option2: "",
    option3: "",
    option4: "",
    status: "active",
    is_published: true,
    season_id: "",
    end_at: "",
  });
  const [pollSaving, setPollSaving] = useState(false);

  const [typerForm, setTyperForm] = useState({
    season_id: "",
    league_id: "all",
    round: "",
    mode: "all",
    title: "",
    description: "",
    is_active: true,
  });
  const [typerMatches, setTyperMatches] = useState([]);
  const [typerSelectedIds, setTyperSelectedIds] = useState([]);
  const [typerLoading, setTyperLoading] = useState(false);
  const [typerSaving, setTyperSaving] = useState(false);
  const [loadedConfigId, setLoadedConfigId] = useState(null);
  const [typerConfigTableMissing, setTyperConfigTableMissing] = useState(false);

  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";
  const softBox = darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50";
  const inputCls = darkMode
    ? "w-full rounded-xl border px-3 py-2 bg-white/5 border-white/10 text-white placeholder:text-gray-500"
    : "w-full rounded-xl border px-3 py-2 bg-white border-gray-300 text-gray-900 placeholder:text-gray-400";
  const btnPrimary =
    "px-4 py-2 rounded-xl bg-yellow-500 text-black font-semibold hover:bg-yellow-400 transition-colors disabled:opacity-50 disabled:cursor-not-allowed";
  const btnGhost = darkMode
    ? "px-4 py-2 rounded-xl border border-white/10 bg-white/5 text-gray-200 hover:bg-white/10"
    : "px-4 py-2 rounded-xl border border-gray-200 bg-white text-gray-700 hover:bg-gray-50";
  const tabs = useMemo(
    () => [
      { id: "polls", label: "Ankiety", icon: <Vote size={16} /> },
      { id: "typer", label: "Typer na kolejkę", icon: <Target size={16} /> },
      { id: "password", label: "Zmiana hasła", icon: <KeyRound size={16} /> },
      { id: "permissions", label: "Uprawnienia", icon: <ShieldCheck size={16} /> },
      { id: "admins", label: "Podadmini / zaproszenia", icon: <UserPlus size={16} /> },
    ],
    []
  );

  const loadMeta = useCallback(async () => {
    setMetaLoading(true);
    try {
      const [{ data: s }, { data: l }] = await Promise.all([
        supabase.from("seasons").select("id, name, year, is_current").order("year", { ascending: false }),
        supabase.from("leagues").select("id, code, name, display_order").order("display_order"),
      ]);

      const seasonsData = s || [];
      const leaguesData = l || [];
      setSeasons(seasonsData);
      setLeagues(leaguesData);

      const currentSeason = seasonsData.find((x) => x.is_current) || seasonsData[0];
      if (currentSeason) {
        setPollForm((f) => ({
          ...f,
          season_id: f.season_id || currentSeason.id,
          end_at: f.end_at || toLocalDatetimeValue(new Date(Date.now() + 3 * 24 * 60 * 60 * 1000)),
        }));
        setTyperForm((f) => ({
          ...f,
          season_id: f.season_id || currentSeason.id,
          title: f.title || "Typer MLPN",
        }));
      }
    } catch (err) {
      setAlert({ type: "error", message: err.message || "Nie udało się załadować danych konfiguracyjnych." });
    } finally {
      setMetaLoading(false);
    }
  }, []);

  useEffect(() => {
    loadMeta();
  }, [loadMeta]);

  const loadTyperMatches = useCallback(async () => {
    if (!typerForm.season_id || !typerForm.round) {
      setTyperMatches([]);
      setTyperSelectedIds([]);
      setLoadedConfigId(null);
      return;
    }

    setTyperLoading(true);
    try {
      let q = supabase
        .from("v_matches")
        .select("id, round, league_id, league_code, match_date, match_time, status, home_team_name, away_team_name, home_team_logo, away_team_logo")
        .eq("season_id", typerForm.season_id)
        .eq("round", Number(typerForm.round))
        .order("match_date")
        .order("match_time");

      if (typerForm.league_id !== "all") q = q.eq("league_id", typerForm.league_id);

      const { data: matchRows, error: matchErr } = await q;
      if (matchErr) throw matchErr;

      const rows = (matchRows || []).filter((m) => !["completed", "walkover_home", "walkover_away", "cancelled"].includes(m.status));
      setTyperMatches(rows);

      // Spróbuj załadować istniejącą konfigurację dla sezonu + kolejki (globalnie dla tej kolejki).
      const { data: cfg, error: cfgErr } = await supabase
        .from("typer_round_configs")
        .select(`
          id,
          title,
          description,
          is_active,
          round,
          typer_round_config_matches (
            match_id,
            display_order
          )
        `)
        .eq("season_id", typerForm.season_id)
        .eq("round", Number(typerForm.round))
        .maybeSingle();

      if (cfgErr) {
        const msg = String(cfgErr.message || "");
        setTyperConfigTableMissing(
          msg.includes("typer_round_configs") && msg.toLowerCase().includes("schema cache")
        );
        setLoadedConfigId(null);
        setTyperSelectedIds([]);
      } else if (cfg) {
        setTyperConfigTableMissing(false);
        const selected = (cfg.typer_round_config_matches || [])
          .slice()
          .sort((a, b) => (a.display_order || 0) - (b.display_order || 0))
          .map((r) => r.match_id);
        setLoadedConfigId(cfg.id);
        setTyperSelectedIds(selected);
        setTyperForm((f) => ({
          ...f,
          title: cfg.title || f.title || "Typer MLPN",
          description: cfg.description || "",
          is_active: cfg.is_active ?? true,
          mode: selected.length && selected.length !== rows.length ? "selected" : f.mode,
        }));
      } else {
        setTyperConfigTableMissing(false);
        setLoadedConfigId(null);
        setTyperSelectedIds([]);
      }
    } catch (err) {
      setAlert({ type: "error", message: err.message || "Nie udało się załadować meczów do typera." });
      setTyperMatches([]);
      setTyperSelectedIds([]);
      setLoadedConfigId(null);
    } finally {
      setTyperLoading(false);
    }
  }, [typerForm.season_id, typerForm.round, typerForm.league_id]);

  useEffect(() => {
    loadTyperMatches();
  }, [loadTyperMatches]);

  useEffect(() => {
    if (typerForm.mode === "all") {
      setTyperSelectedIds(typerMatches.slice(0, 5).map((m) => m.id));
    }
  }, [typerForm.mode, typerMatches]);

  const effectiveTyperSelectedIds = useMemo(() => {
    if (typerForm.mode === "all") return (typerMatches || []).slice(0, 5).map((m) => m.id);
    return (typerSelectedIds || []).slice(0, 5);
  }, [typerForm.mode, typerMatches, typerSelectedIds]);

  const typerSelectedCount = effectiveTyperSelectedIds.length;
  const typerCountOk = typerSelectedCount === 5;

  function updatePollField(key, value) {
    setPollForm((f) => ({ ...f, [key]: value }));
  }

  function updateTyperField(key, value) {
    setTyperForm((f) => ({ ...f, [key]: value }));
  }

  function resetPollForm() {
    const currentSeason = seasons.find((s) => s.is_current) || seasons[0];
    setPollForm({
      title: "",
      option1: "",
      option2: "",
      option3: "",
      option4: "",
      status: "active",
      is_published: true,
      season_id: currentSeason?.id || "",
      end_at: toLocalDatetimeValue(new Date(Date.now() + 3 * 24 * 60 * 60 * 1000)),
    });
  }

  async function handleCreatePoll() {
    const title = (pollForm.title || "").trim();
    const options = [pollForm.option1, pollForm.option2, pollForm.option3, pollForm.option4]
      .map((x) => (x || "").trim())
      .filter(Boolean);

    if (!title) {
      setAlert({ type: "error", message: "Wpisz pytanie ankiety." });
      return;
    }
    if (options.length < 2) {
      setAlert({ type: "error", message: "Ankieta musi mieć co najmniej 2 opcje." });
      return;
    }
    if (!pollForm.end_at) {
      setAlert({ type: "error", message: "Ustaw datę zakończenia ankiety." });
      return;
    }

    setPollSaving(true);
    try {
      const endDate = new Date(pollForm.end_at);
      if (Number.isNaN(endDate.getTime())) throw new Error("Nieprawidłowa data zakończenia.");

      const { data: pollInsert, error: pollErr } = await supabase
        .from("polls")
        .insert({
          title,
          status: pollForm.status,
          is_published: !!pollForm.is_published,
          season_id: pollForm.season_id || null,
          end_date: endDate.toISOString(),
          updated_at: new Date().toISOString(),
        })
        .select("id")
        .single();

      if (pollErr) throw pollErr;

      const rows = options.map((optionText, idx) => ({
        poll_id: pollInsert.id,
        option_text: optionText,
        display_order: idx + 1,
      }));

      const { error: optionsErr } = await supabase.from("poll_options").insert(rows);
      if (optionsErr) {
        await supabase.from("polls").delete().eq("id", pollInsert.id);
        throw optionsErr;
      }

      setAlert({ type: "success", message: `Ankieta została utworzona (${options.length} opcji).` });
      resetPollForm();
    } catch (err) {
      setAlert({ type: "error", message: err.message || "Nie udało się zapisać ankiety." });
    } finally {
      setPollSaving(false);
    }
  }

  function toggleTyperMatch(matchId) {
    const alreadySelected = typerSelectedIds.includes(matchId);
    if (!alreadySelected && typerSelectedIds.length >= 5) {
      setAlert({ type: "error", message: "Typer musi zawierać dokładnie 5 spotkań. Usuń najpierw jedno zaznaczenie." });
      return;
    }
    setTyperSelectedIds((prev) =>
      prev.includes(matchId) ? prev.filter((id) => id !== matchId) : [...prev, matchId]
    );
  }

  function selectAllTyperMatches() {
    setTyperForm((f) => ({ ...f, mode: "selected" }));
    setTyperSelectedIds(typerMatches.slice(0, 5).map((m) => m.id));
  }

  function clearTyperSelection() {
    setTyperSelectedIds([]);
  }

  async function handleSaveTyperConfig() {
    if (!typerForm.season_id) {
      setAlert({ type: "error", message: "Wybierz sezon." });
      return;
    }
    if (!typerForm.round || Number(typerForm.round) <= 0) {
      setAlert({ type: "error", message: "Podaj numer kolejki." });
      return;
    }

    if (typerConfigTableMissing) {
      setAlert({
        type: "error",
        message: "Brakuje tabel do konfiguracji typera. Uruchom w Supabase plik SQL: supabase/migrations/011_typer_round_configs.sql",
      });
      return;
    }

    const selectedIdSet = new Set(effectiveTyperSelectedIds);
    const selectedRows = typerMatches.filter((m) => selectedIdSet.has(m.id));

    if (selectedRows.length !== 5) {
      setAlert({ type: "error", message: `Typer musi zawierać dokładnie 5 spotkań (teraz: ${selectedRows.length}/5).` });
      return;
    }

    setTyperSaving(true);
    try {
      const payload = {
        season_id: typerForm.season_id,
        round: Number(typerForm.round),
        title: (typerForm.title || "").trim() || `Typer kolejki ${typerForm.round}`,
        description: (typerForm.description || "").trim() || null,
        is_active: !!typerForm.is_active,
        updated_at: new Date().toISOString(),
      };

      const { data: cfg, error: cfgErr } = await supabase
        .from("typer_round_configs")
        .upsert(payload, { onConflict: "season_id,round" })
        .select("id")
        .single();

      if (cfgErr) throw cfgErr;

      const configId = cfg.id;

      const { error: delErr } = await supabase
        .from("typer_round_config_matches")
        .delete()
        .eq("config_id", configId);
      if (delErr) throw delErr;

      const matchRows = selectedRows.map((m, idx) => ({
        config_id: configId,
        match_id: m.id,
        display_order: idx + 1,
      }));

      const { error: insErr } = await supabase
        .from("typer_round_config_matches")
        .insert(matchRows);
      if (insErr) throw insErr;

      setLoadedConfigId(configId);
      setTyperSelectedIds(matchRows.map((r) => r.match_id));
      setAlert({
        type: "success",
        message: `Konfiguracja typera zapisana. Wybrano ${matchRows.length} meczów.`,
      });
    } catch (err) {
      const msg = String(err?.message || "");
      if (msg.includes("typer_round_configs")) {
        setTyperConfigTableMissing(true);
      }
      setAlert({
        type: "error",
        message: msg || "Nie udało się zapisać konfiguracji typera.",
      });
    } finally {
      setTyperSaving(false);
    }
  }

  async function handlePasswordChange(e) {
    e.preventDefault();

    if (!password || !password2) {
      setAlert({ type: "error", message: "Wpisz i potwierdź nowe hasło." });
      return;
    }
    if (password !== password2) {
      setAlert({ type: "error", message: "Hasła nie są takie same." });
      return;
    }
    if (password.length < 8) {
      setAlert({ type: "error", message: "Hasło musi mieć minimum 8 znaków." });
      return;
    }

    setPwLoading(true);
    try {
      const { error } = await supabase.auth.updateUser({ password });
      if (error) throw error;
      setPassword("");
      setPassword2("");
      setAlert({ type: "success", message: "Hasło zostało zmienione." });
    } catch (err) {
      setAlert({ type: "error", message: err?.message || "Nie udało się zmienić hasła." });
    } finally {
      setPwLoading(false);
    }
  }

  const leagueOptions = useMemo(
    () => [{ id: "all", name: "Wszystkie ligi" }, ...(leagues || [])],
    [leagues]
  );
  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold">Ustawienia panelu admina</h2>
        <p className={`text-sm mt-1 ${textMuted}`}>
          Konfiguracja ankiet, typera, kont administracyjnych i uprawnień.
        </p>
      </div>

      <AdminAlert
        type={alert.type}
        message={alert.message}
        onClose={() => setAlert({ type: null, message: null })}
      />

      <div className="flex flex-wrap gap-2">
        {tabs.map((t) => (
          <TabButton
            key={t.id}
            active={tab === t.id}
            onClick={() => setTab(t.id)}
            icon={t.icon}
            darkMode={darkMode}
          >
            {t.label}
          </TabButton>
        ))}
      </div>

      {tab === "polls" && (
        <SectionCard
          darkMode={darkMode}
          icon={<Vote size={18} />}
          title="Konfiguracja ankiety"
          subtitle="Tworzenie ankiety z opcjami i publikacją do sekcji Ankiety."
        >
          <div className="grid gap-3">
            <input
              className={inputCls}
              placeholder="Pytanie ankiety"
              value={pollForm.title}
              onChange={(e) => updatePollField("title", e.target.value)}
            />

            <div className="grid md:grid-cols-2 gap-3">
              <input className={inputCls} placeholder="Opcja 1" value={pollForm.option1} onChange={(e) => updatePollField("option1", e.target.value)} />
              <input className={inputCls} placeholder="Opcja 2" value={pollForm.option2} onChange={(e) => updatePollField("option2", e.target.value)} />
              <input className={inputCls} placeholder="Opcja 3 (opcjonalnie)" value={pollForm.option3} onChange={(e) => updatePollField("option3", e.target.value)} />
              <input className={inputCls} placeholder="Opcja 4 (opcjonalnie)" value={pollForm.option4} onChange={(e) => updatePollField("option4", e.target.value)} />
            </div>

            <div className="grid md:grid-cols-4 gap-3">
              <select className={inputCls} value={pollForm.status} onChange={(e) => updatePollField("status", e.target.value)}>
                <option value="active">Aktywna</option>
                <option value="archived">Archiwalna</option>
              </select>

              <input
                type="datetime-local"
                className={inputCls}
                value={pollForm.end_at}
                onChange={(e) => updatePollField("end_at", e.target.value)}
              />

              <select className={inputCls} value={pollForm.season_id} onChange={(e) => updatePollField("season_id", e.target.value)}>
                <option value="">Bez sezonu</option>
                {seasons.map((s) => (
                  <option key={s.id} value={s.id}>
                    {s.name || s.year}
                  </option>
                ))}
              </select>

              <label className={`rounded-xl border px-3 py-2 flex items-center gap-2 text-sm ${softBox}`}>
                <input
                  type="checkbox"
                  checked={!!pollForm.is_published}
                  onChange={(e) => updatePollField("is_published", e.target.checked)}
                />
                Opublikowana
              </label>
            </div>

            <div className={`rounded-xl border p-3 text-sm ${softBox}`}>
              <div className="flex items-start gap-2">
                <Info size={16} className="mt-0.5 shrink-0" />
                <div>
                  Ankieta zapisze się do tabel `polls` + `poll_options`. Po zapisaniu będzie widoczna w zakładce "Ankiety" (jeśli jest opublikowana).
                </div>
              </div>
            </div>

            <div className="flex gap-2">
              <button type="button" className={btnPrimary} onClick={handleCreatePoll} disabled={pollSaving || metaLoading}>
                {pollSaving ? "Zapisywanie..." : "Zapisz ankietę"}
              </button>
              <button type="button" className={btnGhost} onClick={resetPollForm}>
                Wyczyść
              </button>
            </div>
          </div>
        </SectionCard>
      )}

      {tab === "typer" && (
        <SectionCard
          darkMode={darkMode}
          icon={<Target size={18} />}
          title="Tworzenie typera na kolejkę"
          subtitle="Ustawiasz mecze widoczne w typerze na stronie głównej i w zakładce Typer."
        >
          <div className="grid md:grid-cols-6 gap-3">
            <select className={inputCls} value={typerForm.season_id} onChange={(e) => updateTyperField("season_id", e.target.value)}>
              <option value="">Wybierz sezon</option>
              {seasons.map((s) => (
                <option key={s.id} value={s.id}>{s.name || s.year}</option>
              ))}
            </select>

            <select className={inputCls} value={typerForm.league_id} onChange={(e) => updateTyperField("league_id", e.target.value)}>
              {leagueOptions.map((l) => (
                <option key={l.id} value={l.id}>{l.name}</option>
              ))}
            </select>

            <input
              type="number"
              min={1}
              className={inputCls}
              placeholder="Kolejka"
              value={typerForm.round}
              onChange={(e) => updateTyperField("round", e.target.value)}
            />

            <select className={inputCls} value={typerForm.mode} onChange={(e) => updateTyperField("mode", e.target.value)}>
              <option value="all">Automatycznie: pierwsze 5 z listy</option>
              <option value="selected">Ręczny wybór: dokładnie 5</option>
            </select>

            <button type="button" className={btnGhost} onClick={loadTyperMatches} disabled={typerLoading}>
              <span className="inline-flex items-center gap-2">
                <RefreshCw size={14} className={typerLoading ? "animate-spin" : ""} />
                Odświeź listę
              </span>
            </button>

            <label className={`rounded-xl border px-3 py-2 flex items-center gap-2 text-sm ${softBox}`}>
              <input
                type="checkbox"
                checked={!!typerForm.is_active}
                onChange={(e) => updateTyperField("is_active", e.target.checked)}
              />
              Aktywna konfiguracja
            </label>
          </div>

          <div className="grid md:grid-cols-2 gap-3 mt-3">
            <input
              className={inputCls}
              placeholder="Tytuł typera (np. Typer kolejki 9)"
              value={typerForm.title}
              onChange={(e) => updateTyperField("title", e.target.value)}
            />
            <input
              className={inputCls}
              placeholder="Opis (opcjonalnie)"
              value={typerForm.description}
              onChange={(e) => updateTyperField("description", e.target.value)}
            />
          </div>

          <div className={`mt-3 rounded-xl border p-3 ${softBox}`}>
            <div className="flex flex-wrap items-center justify-between gap-2 mb-2">
              <div className="flex flex-wrap items-center gap-2">
                <div className="text-sm font-semibold">
                  Mecze do typera {loadedConfigId ? "(załadowano istniejącą konfigurację)" : ""}
                </div>
                <span
                  className={`px-2.5 py-1 rounded-full text-xs font-bold border ${
                    typerCountOk
                      ? darkMode
                        ? "bg-emerald-500/15 text-emerald-300 border-emerald-400/30"
                        : "bg-emerald-50 text-emerald-700 border-emerald-200"
                      : darkMode
                      ? "bg-white/5 text-gray-300 border-white/10"
                      : "bg-white text-gray-700 border-gray-200"
                  }`}
                >
                  Zaznaczone: {typerSelectedCount}/5
                </span>
              </div>
              <div className="flex gap-2">
                <button type="button" className={btnGhost} onClick={selectAllTyperMatches}>
                  <span className="inline-flex items-center gap-2"><CheckSquare size={14} /> Zaznacz pierwsze 5</span>
                </button>
                <button type="button" className={btnGhost} onClick={clearTyperSelection}>
                  <span className="inline-flex items-center gap-2"><Square size={14} /> Wyczyść zaznaczenie</span>
                </button>
              </div>
            </div>

            {typerConfigTableMissing && (
              <div className={`mb-3 rounded-xl border p-3 text-sm ${darkMode ? "border-amber-400/30 bg-amber-500/10 text-amber-200" : "border-amber-200 bg-amber-50 text-amber-800"}`}>
                Brakuje tabel do zapisu konfiguracji typera. W Supabase uruchom plik:{" "}
                <code className="font-mono">supabase/migrations/011_typer_round_configs.sql</code>
              </div>
            )}

            {typerLoading ? (
              <div className={`text-sm py-4 ${textMuted}`}>Ładowanie meczów…</div>
            ) : typerMatches.length === 0 ? (
              <div className={`text-sm py-4 ${textMuted}`}>Brak meczów dla wybranego zakresu (sezon / liga / kolejka).</div>
            ) : (
              <div className="max-h-[420px] overflow-y-auto pr-1">
                <div className="grid md:grid-cols-2 gap-2">
                  {typerMatches.map((m) => {
                    const checked = effectiveTyperSelectedIds.includes(m.id);
                    const disabledByLimit =
                      typerForm.mode === "selected" && !checked && typerSelectedCount >= 5;
                    return (
                      <label
                        key={m.id}
                        className={`rounded-xl border p-3 cursor-pointer ${
                          darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-white"
                        } ${checked ? (darkMode ? "ring-1 ring-emerald-400/40" : "ring-1 ring-emerald-300") : ""} ${
                          disabledByLimit ? "opacity-60" : ""
                        }`}
                      >
                        <div className="flex items-start gap-3">
                          <input
                            type="checkbox"
                            checked={checked}
                            onChange={() => toggleTyperMatch(m.id)}
                            disabled={typerForm.mode === "all" || disabledByLimit}
                            className="mt-1"
                          />
                          <div className="min-w-0 w-full">
                            <div className={`text-[11px] mb-2 ${textMuted}`}>
                              {m.league_code || "?"} • {m.match_date || "--"} {m.match_time || ""}
                            </div>
                            <div className="grid grid-cols-[1fr_auto_1fr] items-center gap-2">
                              <div className="flex items-center gap-2 min-w-0">
                                <TeamLogoThumb src={m.home_team_logo} name={m.home_team_name} darkMode={darkMode} />
                                <span className="text-sm font-semibold truncate">{m.home_team_name || "Gospodarz"}</span>
                              </div>
                              <div className={`text-[10px] font-black tracking-[0.18em] ${textMuted}`}>VS</div>
                              <div className="flex items-center justify-end gap-2 min-w-0">
                                <span className="text-sm font-semibold truncate text-right">{m.away_team_name || "Gość"}</span>
                                <TeamLogoThumb src={m.away_team_logo} name={m.away_team_name} darkMode={darkMode} />
                              </div>
                            </div>
                          </div>
                        </div>
                      </label>
                    );
                  })}
                </div>
              </div>
            )}
          </div>

          <div className={`mt-3 rounded-xl border p-3 text-sm ${softBox}`}>
            <div className="flex items-start gap-2">
              <Info size={16} className="mt-0.5 shrink-0" />
              <div>
                Po zapisaniu konfiguracji typer na stronie użyje wybranych meczów. Jeśli konfiguracja nie istnieje, strona działa po staremu (automatyczny wybór).
              </div>
            </div>
          </div>

          <div className="mt-3 flex gap-2">
            <button type="button" className={btnPrimary} onClick={handleSaveTyperConfig} disabled={typerSaving || metaLoading}>
              {typerSaving ? "Zapisywanie..." : "Zapisz konfigurację typera"}
            </button>
          </div>
        </SectionCard>
      )}

      {tab === "password" && (
        <SectionCard
          darkMode={darkMode}
          icon={<KeyRound size={18} />}
          title="Zmiana hasła administratora"
          subtitle="To działa od razu dla aktualnie zalogowanego konta."
        >
          <form className="grid gap-3 max-w-xl" onSubmit={handlePasswordChange}>
            <input
              type="password"
              className={inputCls}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Nowe hasło"
            />
            <input
              type="password"
              className={inputCls}
              value={password2}
              onChange={(e) => setPassword2(e.target.value)}
              placeholder="Powtórz nowe hasło"
            />
            <div className="flex gap-2">
              <button type="submit" className={btnPrimary} disabled={pwLoading}>
                {pwLoading ? "Zapisywanie..." : "Zmień hasło"}
              </button>
            </div>
          </form>
        </SectionCard>
      )}

      {tab === "permissions" && (
        <SectionCard
          darkMode={darkMode}
          icon={<ShieldCheck size={18} />}
          title="Nadawanie i modyfikowanie uprawnień"
          subtitle="Gotowy ekran roboczy pod podpięcie tabeli profili / ról."
        >
          <div className="grid md:grid-cols-[1fr_auto] gap-3 mb-3">
            <input
              className={inputCls}
              value={permissionSearch}
              onChange={(e) => setPermissionSearch(e.target.value)}
              placeholder="Szukaj użytkownika po e-mailu lub nazwie"
            />
            <button type="button" className={btnGhost}>Szukaj</button>
          </div>
          <div className={`rounded-xl border overflow-hidden ${darkMode ? "border-white/10" : "border-gray-200"}`}>
            <div className={`grid grid-cols-[1.2fr_0.7fr_0.9fr_auto] gap-2 px-3 py-2 text-xs font-semibold ${darkMode ? "bg-white/5 text-gray-300" : "bg-gray-50 text-gray-600"}`}>
              <div>Użytkownik</div>
              <div>Rola</div>
              <div>Zakres</div>
              <div>Akcja</div>
            </div>
            <div className={`px-3 py-4 text-sm ${textMuted}`}>
              Tu podepnę listę kont po potwierdzeniu modelu ról w Twojej bazie (np. `profiles`, `user_roles`).
            </div>
          </div>
        </SectionCard>
      )}

      {tab === "admins" && (
        <SectionCard
          darkMode={darkMode}
          icon={<UserPlus size={18} />}
          title="Podadmini i zaproszenia"
          subtitle="Formularz gotowy. Wysyłka zaproszeń wymaga bezpiecznej funkcji backendowej."
        >
          <div className="grid md:grid-cols-[1fr_220px_auto] gap-3">
            <div className="relative">
              <Mail size={16} className={`absolute left-3 top-1/2 -translate-y-1/2 ${textMuted}`} />
              <input
                type="email"
                className={`${inputCls} pl-9`}
                placeholder="E-mail podadmina"
                value={inviteEmail}
                onChange={(e) => setInviteEmail(e.target.value)}
              />
            </div>
            <select className={inputCls} value={inviteRole} onChange={(e) => setInviteRole(e.target.value)}>
              <option value="subadmin">Podadmin</option>
              <option value="operator">Operator</option>
              <option value="editor">Redaktor</option>
            </select>
            <button type="button" className={btnPrimary} disabled>
              Wyślij zaproszenie
            </button>
          </div>
          <div className={`mt-3 rounded-xl border p-3 text-sm ${softBox}`}>
            Bezpieczne tworzenie kont i wysyłka zaproszeń powinny działać przez funkcję backendową (Supabase Edge Function / serwer), bo wymagają uprawnień serwisowych.
          </div>
        </SectionCard>
      )}
    </div>
  );
}
