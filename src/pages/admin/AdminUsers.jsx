import React, { useState, useEffect, useCallback } from "react";
import { supabase } from "../../lib/supabase";
import { createClient } from "@supabase/supabase-js";
import AdminFormField from "./components/AdminFormField";
import AdminAlert from "./components/AdminAlert";
import { UserPlus, Trash2, Shield, Edit3 } from "lucide-react";

// Osobny klient do rejestracji (nie wpływa na sesję admina)
const signupClient = createClient(
  process.env.REACT_APP_SUPABASE_URL || "",
  process.env.REACT_APP_SUPABASE_ANON_KEY || "",
  { auth: { persistSession: false, autoRefreshToken: false } }
);

const ROLES = [
  { value: "admin", label: "Admin" },
  { value: "editor", label: "Redaktor" },
  { value: "viewer", label: "Przeglądający" },
];

export default function AdminUsers({ darkMode }) {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [alert, setAlert] = useState({ type: null, message: null });
  const [showForm, setShowForm] = useState(false);
  const [saving, setSaving] = useState(false);
  const [form, setForm] = useState({ email: "", password: "", role: "editor", display_name: "" });
  const [editId, setEditId] = useState(null);

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMain = darkMode ? "text-white" : "text-gray-900";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const loadUsers = useCallback(async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from("profiles")
      .select("*")
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Błąd ładowania użytkowników:", error);
    }
    setUsers(data || []);
    setLoading(false);
  }, []);

  useEffect(() => {
    loadUsers();
  }, [loadUsers]);

  const resetForm = () => {
    setForm({ email: "", password: "", role: "editor", display_name: "" });
    setEditId(null);
    setShowForm(false);
  };

  const handleCreateUser = async (e) => {
    e.preventDefault();
    setSaving(true);

    try {
      if (editId) {
        // Edycja roli istniejącego użytkownika
        const { error } = await supabase
          .from("profiles")
          .update({ role: form.role, display_name: form.display_name || null })
          .eq("id", editId);

        if (error) throw error;
        setAlert({ type: "success", message: "Rola użytkownika zaktualizowana." });
      } else {
        // Tworzenie nowego użytkownika
        if (!form.email || !form.password) {
          setAlert({ type: "error", message: "Podaj e-mail i hasło." });
          setSaving(false);
          return;
        }

        if (form.password.length < 6) {
          setAlert({ type: "error", message: "Hasło musi mieć minimum 6 znaków." });
          setSaving(false);
          return;
        }

        // Rejestruj nowego użytkownika (osobny klient - nie wylogowuje admina)
        const { data: signUpData, error: signUpError } = await signupClient.auth.signUp({
          email: form.email,
          password: form.password,
        });

        if (signUpError) {
          throw new Error(signUpError.message);
        }

        if (!signUpData?.user?.id) {
          throw new Error("Nie udało się utworzyć konta. Sprawdź czy e-mail nie jest już zajęty.");
        }

        // Utwórz/zaktualizuj profil z wybraną rolą
        const { error: profileError } = await supabase
          .from("profiles")
          .upsert({
            id: signUpData.user.id,
            email: form.email,
            role: form.role,
            display_name: form.display_name || null,
          }, { onConflict: "id" });

        if (profileError) {
          console.warn("Profil nie został utworzony automatycznie, próbuję ręcznie:", profileError);
        }

        setAlert({
          type: "success",
          message: `Konto dla ${form.email} utworzone! Rola: ${ROLES.find(r => r.value === form.role)?.label}`,
        });
      }

      resetForm();
      loadUsers();
    } catch (err) {
      setAlert({ type: "error", message: err.message || "Błąd tworzenia konta." });
    } finally {
      setSaving(false);
    }
  };

  const handleEditRole = (user) => {
    setForm({
      email: user.email || "",
      password: "",
      role: user.role || "viewer",
      display_name: user.display_name || "",
    });
    setEditId(user.id);
    setShowForm(true);
  };

  const handleDeleteUser = async (user) => {
    if (!window.confirm(`Czy na pewno usunąć profil użytkownika ${user.email || user.id}? Konto auth pozostanie, ale straci dostęp.`)) return;

    const { error } = await supabase
      .from("profiles")
      .delete()
      .eq("id", user.id);

    if (error) {
      setAlert({ type: "error", message: "Błąd usuwania profilu: " + error.message });
    } else {
      setAlert({ type: "success", message: "Profil usunięty." });
      loadUsers();
    }
  };

  const handleChange = (e) => {
    setForm((f) => ({ ...f, [e.target.name]: e.target.value }));
  };

  const roleBadge = (role) => {
    const colors = {
      admin: "bg-red-500/20 text-red-400 border-red-500/30",
      editor: "bg-blue-500/20 text-blue-400 border-blue-500/30",
      viewer: "bg-gray-500/20 text-gray-400 border-gray-500/30",
    };
    const labels = { admin: "Admin", editor: "Redaktor", viewer: "Przeglądający" };
    return (
      <span className={`px-2 py-0.5 rounded-lg text-xs font-medium border ${colors[role] || colors.viewer}`}>
        {labels[role] || role}
      </span>
    );
  };

  return (
    <div className="space-y-4">
      <AdminAlert
        type={alert.type}
        message={alert.message}
        onClose={() => setAlert({ type: null, message: null })}
      />

      {/* Header */}
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h2 className={`text-xl font-bold ${textMain}`}>Zarządzanie kontami</h2>
          <p className={`text-sm ${textMuted}`}>
            Twórz konta dla osób, które mają mieć dostęp do panelu.
          </p>
        </div>
        <button
          onClick={() => { resetForm(); setShowForm(true); }}
          className="flex items-center gap-2 px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors"
        >
          <UserPlus size={18} /> Nowe konto
        </button>
      </div>

      {/* Formularz */}
      {showForm && (
        <div className={`rounded-2xl border p-5 ${card}`}>
          <h3 className={`text-lg font-semibold mb-4 ${textMain}`}>
            {editId ? "Edytuj użytkownika" : "Utwórz nowe konto"}
          </h3>
          <form onSubmit={handleCreateUser} className="space-y-4">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <AdminFormField
                label="E-mail"
                name="email"
                type="email"
                value={form.email}
                onChange={handleChange}
                required={!editId}
                disabled={!!editId}
                darkMode={darkMode}
                placeholder="jan@example.com"
              />
              {!editId && (
                <AdminFormField
                  label="Hasło"
                  name="password"
                  type="password"
                  value={form.password}
                  onChange={handleChange}
                  required
                  darkMode={darkMode}
                  placeholder="Min. 6 znaków"
                  helpText="Podaj hasło, które przekażesz tej osobie."
                />
              )}
              <AdminFormField
                label="Nazwa wyświetlana"
                name="display_name"
                value={form.display_name}
                onChange={handleChange}
                darkMode={darkMode}
                placeholder="np. Jan Kowalski"
              />
              <AdminFormField
                label="Rola"
                name="role"
                type="select"
                value={form.role}
                onChange={handleChange}
                options={ROLES}
                darkMode={darkMode}
              />
            </div>

            {!editId && (
              <div className={`text-xs ${textMuted} p-3 rounded-xl ${darkMode ? "bg-yellow-500/10" : "bg-yellow-50"}`}>
                <strong>Jak to działa:</strong> Tworzysz konto z e-mailem i hasłem. Podajesz te dane osobie,
                która loguje się na stronie w panelu admina. Rola określa co może robić.
              </div>
            )}

            <div className="flex gap-3">
              <button
                type="submit"
                disabled={saving}
                className="px-5 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors disabled:opacity-50"
              >
                {saving ? "Zapisywanie..." : editId ? "Zapisz zmiany" : "Utwórz konto"}
              </button>
              <button
                type="button"
                onClick={resetForm}
                className={`px-5 py-2 rounded-xl border font-medium transition-colors ${darkMode ? "border-white/10 text-gray-400 hover:bg-white/5" : "border-gray-200 text-gray-600 hover:bg-gray-50"}`}
              >
                Anuluj
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Lista użytkowników */}
      <div className={`rounded-2xl border ${card}`}>
        <div className={`px-5 py-3 border-b ${darkMode ? "border-white/10" : "border-gray-200"}`}>
          <h3 className={`font-semibold ${textMain}`}>Konta ({users.length})</h3>
        </div>

        {loading ? (
          <div className={`p-8 text-center ${textMuted}`}>Ładowanie...</div>
        ) : users.length === 0 ? (
          <div className={`p-8 text-center ${textMuted}`}>Brak kont.</div>
        ) : (
          <div className="divide-y divide-gray-200 dark:divide-white/10">
            {users.map((u) => (
              <div
                key={u.id}
                className={`flex flex-wrap items-center gap-3 px-5 py-3 ${darkMode ? "divide-white/10" : "divide-gray-200"}`}
              >
                <div className="flex items-center gap-3 flex-1 min-w-0">
                  <div className={`w-9 h-9 rounded-full flex items-center justify-center text-sm font-bold ${
                    u.role === "admin"
                      ? "bg-red-500/20 text-red-400"
                      : u.role === "editor"
                      ? "bg-blue-500/20 text-blue-400"
                      : "bg-gray-500/20 text-gray-400"
                  }`}>
                    <Shield size={16} />
                  </div>
                  <div className="min-w-0">
                    <div className={`text-sm font-medium truncate ${textMain}`}>
                      {u.display_name || u.email || u.id.slice(0, 8)}
                    </div>
                    <div className={`text-xs truncate ${textMuted}`}>{u.email || "brak e-maila"}</div>
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  {roleBadge(u.role)}
                  <button
                    onClick={() => handleEditRole(u)}
                    className={`p-1.5 rounded-lg transition-colors ${darkMode ? "hover:bg-white/10 text-gray-400" : "hover:bg-gray-100 text-gray-500"}`}
                    title="Edytuj rolę"
                  >
                    <Edit3 size={15} />
                  </button>
                  <button
                    onClick={() => handleDeleteUser(u)}
                    className="p-1.5 rounded-lg hover:bg-red-500/10 text-red-400 transition-colors"
                    title="Usuń profil"
                  >
                    <Trash2 size={15} />
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
