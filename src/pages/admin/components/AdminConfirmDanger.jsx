import React, { useState } from "react";
import { createClient } from "@supabase/supabase-js";
import { supabase } from "../../../lib/supabase";
import { ShieldAlert, Loader2 } from "lucide-react";

const supabaseUrl = process.env.REACT_APP_SUPABASE_URL || "";
const supabaseAnonKey = process.env.REACT_APP_SUPABASE_ANON_KEY || "";

function createVerificationClient() {
  return createClient(supabaseUrl, supabaseAnonKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
      detectSessionInUrl: false,
      storageKey: `mlpn-danger-check-${Date.now()}`,
    },
  });
}

/**
 * Modal wymagający hasła admina przed niebezpieczną operacją.
 * Props:
 *   isOpen, onClose, onConfirm, darkMode,
 *   title (np. "Usunięcie sezonu"),
 *   message (np. "Ta operacja jest nieodwracalna!")
 */
export default function AdminConfirmDanger({ isOpen, onClose, onConfirm, darkMode, title, message }) {
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  if (!isOpen) return null;

  const bg = darkMode ? "bg-[#141828] border-white/10" : "bg-white border-gray-200";
  const inputCls = darkMode
    ? "bg-white/5 border-white/10 text-white placeholder-gray-500"
    : "bg-white border-gray-300 text-gray-900 placeholder-gray-400";

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!password.trim()) { setError("Wpisz hasło"); return; }

    setLoading(true);
    setError("");

    try {
      // Weryfikuj hasło przez ponowne logowanie
      const { data: { session } } = await supabase.auth.getSession();
      const email = session?.user?.email;
      if (!email) { setError("Brak sesji. Zaloguj się ponownie."); setLoading(false); return; }

      const verificationClient = createVerificationClient();
      const { error: authErr } = await verificationClient.auth.signInWithPassword({ email, password });
      await verificationClient.auth.signOut();
      if (authErr) { setError("Błędne hasło!"); setLoading(false); return; }

      // Hasło poprawne — wykonaj operację
      setPassword("");
      onClose();
      await onConfirm();
    } catch (err) {
      setError(err.message || "Błąd weryfikacji");
    } finally {
      setLoading(false);
    }
  };

  const handleClose = () => {
    setPassword("");
    setError("");
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center pt-[10vh] px-4 bg-black/60" onClick={handleClose}>
      <div
        onClick={e => e.stopPropagation()}
        className={`w-full max-w-md rounded-2xl border p-6 shadow-2xl ${bg}`}
      >
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 rounded-full bg-red-500/20 flex items-center justify-center">
            <ShieldAlert size={22} className="text-red-400" />
          </div>
          <div>
            <h3 className="text-lg font-bold text-red-400">{title || "Potwierdź operację"}</h3>
          </div>
        </div>

        {message && (
          <p className={`text-sm mb-4 ${darkMode ? "text-gray-300" : "text-gray-600"}`}>{message}</p>
        )}

        <form onSubmit={handleSubmit} className="space-y-3">
          <div>
            <label className={`block text-sm font-medium mb-1 ${darkMode ? "text-gray-300" : "text-gray-700"}`}>
              Wpisz swoje hasło aby potwierdzić:
            </label>
            <input
              type="password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              placeholder="Hasło admina"
              autoFocus
              className={`w-full px-3 py-2 rounded-xl border outline-none transition-colors ${inputCls}`}
            />
          </div>

          {error && <p className="text-sm text-red-400 font-medium">{error}</p>}

          <div className="flex gap-2 pt-1">
            <button
              type="submit"
              disabled={loading}
              className="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl bg-red-500 text-white font-semibold hover:bg-red-400 transition-colors disabled:opacity-50"
            >
              {loading ? <Loader2 size={16} className="animate-spin" /> : null}
              {loading ? "Weryfikacja..." : "Potwierdzam usunięcie"}
            </button>
            <button
              type="button"
              onClick={handleClose}
              className={`px-4 py-2.5 rounded-xl border font-medium transition-colors ${darkMode ? "border-white/10 text-gray-300 hover:bg-white/5" : "border-gray-200 text-gray-700 hover:bg-gray-50"}`}
            >
              Anuluj
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
