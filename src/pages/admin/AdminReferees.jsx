import React, { useCallback, useEffect, useMemo, useState } from "react";
import { supabase } from "../../lib/supabase";
import AdminAlert from "./components/AdminAlert";
import {
  Users,
  Plus,
  Pencil,
  Trash2,
  Undo2,
  Loader2,
  X,
} from "lucide-react";

function normalizeRefereeName(value) {
  return String(value || "").trim().replace(/\s+/g, " ");
}

export default function AdminReferees({ darkMode }) {
  const [referees, setReferees] = useState([]);
  const [refereesLoading, setRefereesLoading] = useState(false);
  const [refereesTableMissing, setRefereesTableMissing] = useState(false);
  const [refereeName, setRefereeName] = useState("");
  const [creatingReferee, setCreatingReferee] = useState(false);
  const [editingRefereeId, setEditingRefereeId] = useState("");
  const [editingRefereeName, setEditingRefereeName] = useState("");
  const [busyRefereeId, setBusyRefereeId] = useState("");
  const [alert, setAlert] = useState({ type: null, message: null });

  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";
  const softBox = darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50";
  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const inputCls = darkMode
    ? "w-full rounded-xl border px-3 py-2 bg-white/5 border-white/10 text-white placeholder:text-gray-500"
    : "w-full rounded-xl border px-3 py-2 bg-white border-gray-300 text-gray-900 placeholder:text-gray-400";
  const btnPrimary =
    "px-4 py-2 rounded-xl bg-yellow-500 text-black font-semibold hover:bg-yellow-400 transition-colors disabled:opacity-50 disabled:cursor-not-allowed";
  const btnGhost = darkMode
    ? "px-4 py-2 rounded-xl border border-white/10 bg-white/5 text-gray-200 hover:bg-white/10"
    : "px-4 py-2 rounded-xl border border-gray-200 bg-white text-gray-700 hover:bg-gray-50";
  const btnSmall = darkMode
    ? "inline-flex items-center gap-2 px-3 py-2 rounded-xl border border-white/10 bg-white/5 text-sm text-gray-200 hover:bg-white/10 disabled:opacity-50"
    : "inline-flex items-center gap-2 px-3 py-2 rounded-xl border border-gray-200 bg-white text-sm text-gray-700 hover:bg-gray-50 disabled:opacity-50";
  const btnDangerSmall = darkMode
    ? "inline-flex items-center gap-2 px-3 py-2 rounded-xl border border-red-400/20 bg-red-500/10 text-sm text-red-200 hover:bg-red-500/15 disabled:opacity-50"
    : "inline-flex items-center gap-2 px-3 py-2 rounded-xl border border-red-200 bg-red-50 text-sm text-red-700 hover:bg-red-100 disabled:opacity-50";

  const loadReferees = useCallback(async () => {
    setRefereesLoading(true);
    try {
      const { data, error } = await supabase
        .from("referees")
        .select("id, full_name, is_active, updated_at")
        .order("is_active", { ascending: false })
        .order("full_name");

      if (error) throw error;

      setReferees(data || []);
      setRefereesTableMissing(false);
    } catch (err) {
      const message = String(err?.message || "");
      setReferees([]);
      setRefereesTableMissing(message.toLowerCase().includes("referees"));
      if (!message.toLowerCase().includes("referees")) {
        setAlert({ type: "error", message: message || "Nie udało się załadować listy sędziów." });
      }
    } finally {
      setRefereesLoading(false);
    }
  }, []);

  useEffect(() => {
    loadReferees();
  }, [loadReferees]);

  function resetRefereeEditor() {
    setEditingRefereeId("");
    setEditingRefereeName("");
  }

  function notifyRefereesChanged() {
    window.dispatchEvent(new CustomEvent("mlpn:referees-updated"));
  }

  async function handleCreateReferee() {
    const fullName = normalizeRefereeName(refereeName);
    if (!fullName) {
      setAlert({ type: "error", message: "Wpisz imię i nazwisko sędziego." });
      return;
    }

    const duplicate = referees.find(
      (referee) => referee.full_name.localeCompare(fullName, "pl", { sensitivity: "base" }) === 0
    );
    if (duplicate) {
      setAlert({ type: "error", message: "Taki sędzia jest już na liście." });
      return;
    }

    setCreatingReferee(true);
    try {
      const { error } = await supabase
        .from("referees")
        .insert({ full_name: fullName, is_active: true });

      if (error) throw error;

      setRefereeName("");
      await loadReferees();
      notifyRefereesChanged();
      setAlert({ type: "success", message: "Sędzia został dodany do listy." });
    } catch (err) {
      setAlert({ type: "error", message: err?.message || "Nie udało się dodać sędziego." });
    } finally {
      setCreatingReferee(false);
    }
  }

  async function handleSaveReferee(refereeId) {
    const fullName = normalizeRefereeName(editingRefereeName);
    if (!fullName) {
      setAlert({ type: "error", message: "Wpisz poprawne imię i nazwisko sędziego." });
      return;
    }

    const duplicate = referees.find(
      (referee) =>
        referee.id !== refereeId &&
        referee.full_name.localeCompare(fullName, "pl", { sensitivity: "base" }) === 0
    );
    if (duplicate) {
      setAlert({ type: "error", message: "Na liście jest już sędzia o takiej nazwie." });
      return;
    }

    setBusyRefereeId(refereeId);
    try {
      const { error } = await supabase
        .from("referees")
        .update({ full_name: fullName })
        .eq("id", refereeId);

      if (error) throw error;

      resetRefereeEditor();
      await loadReferees();
      notifyRefereesChanged();
      setAlert({ type: "success", message: "Dane sędziego zostały zaktualizowane." });
    } catch (err) {
      setAlert({ type: "error", message: err?.message || "Nie udało się zapisać zmian sędziego." });
    } finally {
      setBusyRefereeId("");
    }
  }

  async function handleSetRefereeActive(refereeId, isActive) {
    setBusyRefereeId(refereeId);
    try {
      const { error } = await supabase
        .from("referees")
        .update({ is_active: isActive })
        .eq("id", refereeId);

      if (error) throw error;

      if (!isActive && editingRefereeId === refereeId) resetRefereeEditor();

      await loadReferees();
      notifyRefereesChanged();
      setAlert({
        type: "success",
        message: isActive
          ? "Sędzia wrócił na listę dostępnych osób."
          : "Sędzia został ukryty z listy nowych wyborów.",
      });
    } catch (err) {
      setAlert({ type: "error", message: err?.message || "Nie udało się zaktualizować statusu sędziego." });
    } finally {
      setBusyRefereeId("");
    }
  }

  const activeReferees = useMemo(
    () => (referees || []).filter((referee) => referee.is_active),
    [referees]
  );
  const inactiveReferees = useMemo(
    () => (referees || []).filter((referee) => !referee.is_active),
    [referees]
  );

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold">Sędziowie</h2>
        <p className={`text-sm mt-1 ${textMuted}`}>
          Zarządzaj listą sędziów. Ukrycie sędziego nie usuwa go ze starych meczów.
        </p>
      </div>

      <AdminAlert alert={alert} onDismiss={() => setAlert({ type: null, message: null })} darkMode={darkMode} />

      {refereesTableMissing && (
        <div className={`rounded-xl border p-3 text-sm ${darkMode ? "border-amber-400/30 bg-amber-500/10 text-amber-200" : "border-amber-200 bg-amber-50 text-amber-800"}`}>
          Brakuje tabeli sędziów w bazie. W Supabase uruchom plik:{" "}
          <code className="font-mono">supabase/migrations/015_referees.sql</code>
        </div>
      )}

      <div className="grid lg:grid-cols-[minmax(0,340px)_1fr] gap-4">
        <div className={`rounded-2xl border p-4 ${softBox}`}>
          <div className="font-semibold mb-2">Dodaj nowego sędziego</div>
          <p className={`text-sm mb-3 ${textMuted}`}>
            Edycja nazwy aktualizuje stare spotkania automatycznie.
          </p>
          <div className="space-y-3">
            <input
              className={inputCls}
              value={refereeName}
              onChange={(e) => setRefereeName(e.target.value)}
              placeholder="Imię i nazwisko"
            />
            <button
              type="button"
              className={`${btnPrimary} inline-flex items-center gap-2`}
              onClick={handleCreateReferee}
              disabled={creatingReferee || refereesTableMissing}
            >
              {creatingReferee ? <Loader2 size={16} className="animate-spin" /> : <Plus size={16} />}
              Dodaj sędziego
            </button>
          </div>
        </div>

        <div className="space-y-4">
          <div className={`rounded-2xl border p-4 ${softBox}`}>
            <div className="flex items-center justify-between gap-3 mb-3">
              <div>
                <div className="font-semibold">Aktywni sędziowie</div>
                <div className={`text-sm ${textMuted}`}>Ta lista jest widoczna przy wpisywaniu nowych wyników.</div>
              </div>
              {refereesLoading && <Loader2 size={16} className="animate-spin" />}
            </div>

            <div className="space-y-3">
              {activeReferees.length === 0 ? (
                <div className={`text-sm ${textMuted}`}>Brak aktywnych sędziów na liście.</div>
              ) : (
                activeReferees.map((referee) => {
                  const isEditing = editingRefereeId === referee.id;
                  const isBusy = busyRefereeId === referee.id;

                  return (
                    <div
                      key={referee.id}
                      className={`rounded-xl border p-3 ${darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-white"}`}
                    >
                      {isEditing ? (
                        <div className="flex flex-col sm:flex-row gap-3">
                          <input
                            className={inputCls}
                            value={editingRefereeName}
                            onChange={(e) => setEditingRefereeName(e.target.value)}
                            placeholder="Imię i nazwisko"
                            disabled={isBusy}
                          />
                          <div className="flex gap-2">
                            <button
                              type="button"
                              className={btnSmall}
                              onClick={() => handleSaveReferee(referee.id)}
                              disabled={isBusy}
                            >
                              {isBusy ? <Loader2 size={14} className="animate-spin" /> : <Pencil size={14} />}
                              Zapisz
                            </button>
                            <button
                              type="button"
                              className={btnGhost}
                              onClick={resetRefereeEditor}
                              disabled={isBusy}
                            >
                              <span className="inline-flex items-center gap-2">
                                <X size={14} />
                                Anuluj
                              </span>
                            </button>
                          </div>
                        </div>
                      ) : (
                        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
                          <div>
                            <div className="font-semibold">{referee.full_name}</div>
                            <div className={`text-xs mt-1 ${textMuted}`}>Dostępny przy kolejnych meczach.</div>
                          </div>
                          <div className="flex flex-wrap gap-2">
                            <button
                              type="button"
                              className={btnSmall}
                              onClick={() => {
                                setEditingRefereeId(referee.id);
                                setEditingRefereeName(referee.full_name);
                              }}
                              disabled={isBusy}
                            >
                              <Pencil size={14} />
                              Edytuj
                            </button>
                            <button
                              type="button"
                              className={btnDangerSmall}
                              onClick={() => handleSetRefereeActive(referee.id, false)}
                              disabled={isBusy}
                            >
                              {isBusy ? <Loader2 size={14} className="animate-spin" /> : <Trash2 size={14} />}
                              Ukryj z listy
                            </button>
                          </div>
                        </div>
                      )}
                    </div>
                  );
                })
              )}
            </div>
          </div>

          <div className={`rounded-2xl border p-4 ${softBox}`}>
            <div className="font-semibold mb-1">Ukryci sędziowie</div>
            <div className={`text-sm mb-3 ${textMuted}`}>Nie pojawiają się przy nowych meczach, ale stare spotkania dalej ich pokazują.</div>

            <div className="space-y-3">
              {inactiveReferees.length === 0 ? (
                <div className={`text-sm ${textMuted}`}>Brak ukrytych sędziów.</div>
              ) : (
                inactiveReferees.map((referee) => {
                  const isBusy = busyRefereeId === referee.id;
                  return (
                    <div
                      key={referee.id}
                      className={`rounded-xl border p-3 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 ${darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-white"}`}
                    >
                      <div>
                        <div className="font-semibold">{referee.full_name}</div>
                        <div className={`text-xs mt-1 ${textMuted}`}>Historia meczów zostaje zachowana.</div>
                      </div>
                      <button
                        type="button"
                        className={btnSmall}
                        onClick={() => handleSetRefereeActive(referee.id, true)}
                        disabled={isBusy}
                      >
                        {isBusy ? <Loader2 size={14} className="animate-spin" /> : <Undo2 size={14} />}
                        Przywróć na listę
                      </button>
                    </div>
                  );
                })
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
