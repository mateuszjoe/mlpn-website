import React, { useCallback, useEffect, useState } from "react";
import { createClient } from "@supabase/supabase-js";
import { Ban, Edit3, KeyRound, PauseCircle, Shield, Trash2, Undo2, UserPlus } from "lucide-react";
import { supabase } from "../../lib/supabase";
import { useAuth } from "../../contexts/AuthContext";
import {
  createEmptyPermissions,
  getDefaultDisplayName,
  normalizePermissions,
  setPermissionValue,
} from "../../lib/adminPermissions";
import AdminAlert from "./components/AdminAlert";
import AdminFormField from "./components/AdminFormField";
import AdminPermissionTree from "./components/AdminPermissionTree";

const supabaseUrl = process.env.REACT_APP_SUPABASE_URL || "";
const supabaseAnonKey = process.env.REACT_APP_SUPABASE_ANON_KEY || "";

const STATUS_OPTIONS = [
  { value: "active", label: "Aktywne" },
  { value: "suspended", label: "Zawieszone" },
  { value: "banned", label: "Zbanowane" },
];

function createAccountForm() {
  return {
    email: "",
    first_name: "",
    last_name: "",
    display_name: "",
    password: "",
    password_confirm: "",
    current_password: "",
    new_password: "",
    new_password_confirm: "",
    access_mode: "custom",
    account_status: "active",
    permissions: createEmptyPermissions(),
  };
}

function createEphemeralAuthClient(storageKeySuffix) {
  return createClient(supabaseUrl, supabaseAnonKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
      detectSessionInUrl: false,
      storageKey: `mlpn-user-admin-${storageKeySuffix}`,
    },
  });
}

function getCurrentAuthRedirectUrl() {
  if (typeof window === "undefined") return undefined;
  return `${window.location.origin}${window.location.pathname}`;
}

function getStatusBadge(status) {
  switch (status) {
    case "banned":
      return "bg-red-500/15 text-red-400 border-red-500/30";
    case "suspended":
      return "bg-yellow-500/15 text-yellow-500 border-yellow-500/30";
    default:
      return "bg-green-500/15 text-green-500 border-green-500/30";
  }
}

export default function AdminUsers({ darkMode }) {
  const { profile, can, canAny, isAdmin } = useAuth();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [schemaUpdateRequired, setSchemaUpdateRequired] = useState(false);
  const [showForm, setShowForm] = useState(false);
  const [editId, setEditId] = useState(null);
  const [originalEmail, setOriginalEmail] = useState("");
  const [form, setForm] = useState(createAccountForm);
  const [alert, setAlert] = useState({ type: null, message: null });

  const canCreateUsers = isAdmin || can("users.create");
  const canDeleteUsers = isAdmin || can("users.delete");
  const canBanUsers = isAdmin || can("users.ban");
  const canSuspendUsers = isAdmin || can("users.suspend");
  const canEditUsers = isAdmin || can("users.edit");
  const canManagePermissions =
    isAdmin || canAny(["users.permissions.grant", "users.permissions.revoke"]);
  const canManageAnyUsers =
    canCreateUsers ||
    canDeleteUsers ||
    canBanUsers ||
    canSuspendUsers ||
    canEditUsers ||
    canManagePermissions;

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMain = darkMode ? "text-white" : "text-gray-900";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const isSchemaError = (message = "") =>
    message.includes("column profiles.") ||
    message.includes("column public.profiles.") ||
    message.includes("Could not find the 'email' column");

  const loadUsers = useCallback(async () => {
    setLoading(true);

    const { error: schemaError } = await supabase
      .from("profiles")
      .select("email, first_name, last_name, permissions, account_status")
      .limit(1);

    const schemaMissing = isSchemaError(schemaError?.message || "");
    setSchemaUpdateRequired(schemaMissing);

    const { data, error } = await supabase
      .from("profiles")
      .select("*")
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Blad ladowania uzytkownikow:", error);
      setAlert({
        type: "error",
        message: schemaMissing
          ? "Baza nie jest jeszcze zaktualizowana. Uruchom w Supabase plik: supabase/migrations/017_user_permissions.sql"
          : error.message || "Nie udalo sie zaladowac kont.",
      });
      setUsers([]);
      setLoading(false);
      return;
    }

    setUsers((data || []).map((user) => ({
      ...user,
      permissions: normalizePermissions(user.permissions),
      account_status: user.account_status || "active",
    })));
    setLoading(false);
  }, []);

  useEffect(() => {
    loadUsers();
  }, [loadUsers]);

  const resetForm = () => {
    setForm(createAccountForm());
    setOriginalEmail("");
    setEditId(null);
    setShowForm(false);
  };

  const updateField = (event) => {
    const { name, value } = event.target;
    setForm((current) => ({ ...current, [name]: value }));
  };

  const handleTogglePermission = (permissionKey, nextValue) => {
    setForm((current) => {
      const nextPermissions = normalizePermissions(current.permissions);
      setPermissionValue(nextPermissions, permissionKey, nextValue);
      return { ...current, permissions: nextPermissions };
    });
  };

  const handleToggleGroup = (groupKey, nextValue) => {
    setForm((current) => {
      const nextPermissions = normalizePermissions(current.permissions);
      Object.keys(nextPermissions[groupKey] || {}).forEach((key) => {
        if (typeof nextPermissions[groupKey][key] === "object" && nextPermissions[groupKey][key] !== null) {
          Object.keys(nextPermissions[groupKey][key]).forEach((nestedKey) => {
            nextPermissions[groupKey][key][nestedKey] = nextValue;
          });
          return;
        }
        nextPermissions[groupKey][key] = nextValue;
      });
      return { ...current, permissions: nextPermissions };
    });
  };

  const validateForm = (isEditing) => {
    if (!form.email || !form.first_name || !form.last_name || !form.display_name) {
      return "Uzupelnij mail, imie, nazwisko i nazwe wyswietlana.";
    }

    if (!isEditing) {
      if (!form.password) {
        return "Podaj haslo dla nowego konta.";
      }
      if (form.password.length < 6) {
        return "Haslo musi miec minimum 6 znakow.";
      }
      if (form.password !== form.password_confirm) {
        return "Hasla dla nowego konta nie sa takie same.";
      }
    }

    if (isEditing && (form.new_password || form.new_password_confirm)) {
      if (!form.current_password) {
        return "Aby zmienic haslo lub mail istniejacego konta, wpisz aktualne haslo tego konta.";
      }
      if (form.new_password.length < 6) {
        return "Nowe haslo musi miec minimum 6 znakow.";
      }
      if (form.new_password !== form.new_password_confirm) {
        return "Nowe hasla nie sa takie same.";
      }
    }

    if (isEditing && form.email !== originalEmail && !form.current_password) {
      return "Zmiana maila wymaga wpisania aktualnego hasla tego konta.";
    }

    return null;
  };

  const buildProfilePayload = () => ({
    email: form.email.trim(),
    first_name: form.first_name.trim(),
    last_name: form.last_name.trim(),
    display_name: form.display_name.trim() || getDefaultDisplayName(form.first_name, form.last_name, form.email),
    role: form.access_mode === "admin" ? "admin" : "viewer",
    account_status: form.account_status,
    permissions: normalizePermissions(form.permissions),
  });

  const syncAuthCredentials = async () => {
    const shouldChangeEmail = form.email.trim() !== originalEmail.trim();
    const shouldChangePassword = !!form.new_password;

    if (!shouldChangeEmail && !shouldChangePassword && !editId) {
      return null;
    }

    if (editId && !shouldChangeEmail && !shouldChangePassword) {
      return null;
    }

    if (!editId) {
      return null;
    }

    const authClient = createEphemeralAuthClient(`edit-${editId}-${Date.now()}`);

    const { error: signInError } = await authClient.auth.signInWithPassword({
      email: originalEmail,
      password: form.current_password,
    });

    if (signInError) {
      throw new Error("Nie udalo sie potwierdzic aktualnego hasla tego konta.");
    }

    const updatePayload = {
      data: {
        first_name: form.first_name.trim(),
        last_name: form.last_name.trim(),
        display_name: form.display_name.trim(),
      },
    };

    if (shouldChangeEmail) {
      updatePayload.email = form.email.trim();
    }

    if (shouldChangePassword) {
      updatePayload.password = form.new_password;
    }

    const { error: updateError } = await authClient.auth.updateUser(updatePayload);
    await authClient.auth.signOut();

    if (updateError) {
      throw new Error(updateError.message || "Nie udalo sie zaktualizowac danych logowania.");
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    if (schemaUpdateRequired) {
      setAlert({
        type: "error",
        message: "Najpierw uruchom w Supabase plik: supabase/migrations/017_user_permissions.sql",
      });
      return;
    }

    if (!canManageAnyUsers) {
      setAlert({ type: "error", message: "To konto nie moze zarzadzac uzytkownikami." });
      return;
    }

    const isEditing = !!editId;
    const validationError = validateForm(isEditing);
    if (validationError) {
      setAlert({ type: "error", message: validationError });
      return;
    }

    const profilePayload = buildProfilePayload();

    if (!isEditing && !canCreateUsers) {
      setAlert({ type: "error", message: "Brak uprawnien do tworzenia kont." });
      return;
    }

    if (isEditing && !canAny(["users.edit", "users.permissions.grant", "users.permissions.revoke", "users.ban", "users.suspend"])) {
      setAlert({ type: "error", message: "Brak uprawnien do edycji tego konta." });
      return;
    }

    if (profile?.id === editId && form.account_status !== "active") {
      setAlert({ type: "error", message: "Nie mozesz zawiesic ani zbanowac aktualnie zalogowanego konta." });
      return;
    }

    setSaving(true);

    try {
      if (isEditing) {
        await syncAuthCredentials();

        const { error } = await supabase
          .from("profiles")
          .update(profilePayload)
          .eq("id", editId);

        if (error) {
          throw error;
        }

        setAlert({ type: "success", message: "Konto zostalo zaktualizowane." });
      } else {
        const authClient = createEphemeralAuthClient(`create-${Date.now()}`);
        const { data: signUpData, error: signUpError } = await authClient.auth.signUp({
          email: profilePayload.email,
          password: form.password,
          options: {
            emailRedirectTo: getCurrentAuthRedirectUrl(),
            data: {
              first_name: profilePayload.first_name,
              last_name: profilePayload.last_name,
              display_name: profilePayload.display_name,
            },
          },
        });

        if (signUpError) {
          throw new Error(signUpError.message || "Nie udalo sie utworzyc konta.");
        }

        if (!signUpData?.user?.id) {
          throw new Error("Supabase nie zwrocilo identyfikatora nowego konta.");
        }

        const { error: profileError } = await supabase
          .from("profiles")
          .upsert(
            {
              id: signUpData.user.id,
              ...profilePayload,
            },
            { onConflict: "id" }
          );

        await authClient.auth.signOut();

        if (profileError) {
          throw profileError;
        }

        const requiresEmailConfirmation = !signUpData?.session;

        setAlert({
          type: requiresEmailConfirmation ? "warning" : "success",
          message: requiresEmailConfirmation
            ? `Konto dla ${profilePayload.email} zostalo utworzone, ale ta osoba musi jeszcze kliknac link z maila aktywacyjnego. Jesli chcesz, zeby nowe konta logowaly sie od razu, w Supabase wylacz opcje Confirm email.`
            : `Konto dla ${profilePayload.email} zostalo utworzone i moze sie juz zalogowac.`,
        });
      }

      resetForm();
      await loadUsers();
    } catch (error) {
      const message = error.message || "Nie udalo sie zapisac konta.";
      const schemaMissing = isSchemaError(message);
      if (schemaMissing) {
        setSchemaUpdateRequired(true);
      }
      setAlert({
        type: "error",
        message: schemaMissing
          ? "Brakuje nowych pol w bazie. W Supabase uruchom plik: supabase/migrations/017_user_permissions.sql"
          : message,
      });
    } finally {
      setSaving(false);
    }
  };

  const handleEditUser = (user) => {
    setEditId(user.id);
    setOriginalEmail(user.email || "");
    setForm({
      email: user.email || "",
      first_name: user.first_name || "",
      last_name: user.last_name || "",
      display_name: user.display_name || getDefaultDisplayName(user.first_name, user.last_name, user.email),
      password: "",
      password_confirm: "",
      current_password: "",
      new_password: "",
      new_password_confirm: "",
      access_mode: user.role === "admin" ? "admin" : "custom",
      account_status: user.account_status || "active",
      permissions: normalizePermissions(user.permissions),
    });
    setShowForm(true);
  };

  const handleDeleteUser = async (user) => {
    if (schemaUpdateRequired) {
      setAlert({
        type: "error",
        message: "Najpierw uruchom w Supabase plik: supabase/migrations/017_user_permissions.sql",
      });
      return;
    }

    if (!canDeleteUsers) {
      setAlert({ type: "error", message: "Brak uprawnien do usuwania kont." });
      return;
    }

    if (profile?.id === user.id) {
      setAlert({ type: "error", message: "Nie mozesz usunac aktualnie zalogowanego konta." });
      return;
    }

    if (!window.confirm(`Czy na pewno usunac konto ${user.display_name || user.email || user.id}?`)) {
      return;
    }

    const { error } = await supabase.from("profiles").delete().eq("id", user.id);
    if (error) {
      setAlert({ type: "error", message: error.message || "Nie udalo sie usunac konta." });
      return;
    }

    setAlert({ type: "success", message: "Konto zostalo usuniete z panelu." });
    await loadUsers();
  };

  const handleQuickStatusChange = async (user, nextStatus) => {
    if (schemaUpdateRequired) {
      setAlert({
        type: "error",
        message: "Najpierw uruchom w Supabase plik: supabase/migrations/017_user_permissions.sql",
      });
      return;
    }

    if (nextStatus === "banned" && !canBanUsers) {
      setAlert({ type: "error", message: "Brak uprawnien do banowania kont." });
      return;
    }

    if (nextStatus === "suspended" && !canSuspendUsers) {
      setAlert({ type: "error", message: "Brak uprawnien do zawieszania kont." });
      return;
    }

    if (nextStatus === "active" && !(canBanUsers || canSuspendUsers || canEditUsers)) {
      setAlert({ type: "error", message: "Brak uprawnien do przywracania kont." });
      return;
    }

    if (profile?.id === user.id && nextStatus !== "active") {
      setAlert({ type: "error", message: "Nie mozesz zablokowac aktualnie zalogowanego konta." });
      return;
    }

    const { error } = await supabase
      .from("profiles")
      .update({ account_status: nextStatus })
      .eq("id", user.id);

    if (error) {
      setAlert({ type: "error", message: error.message || "Nie udalo sie zmienic statusu konta." });
      return;
    }

    setAlert({ type: "success", message: "Status konta zostal zmieniony." });
    await loadUsers();
  };

  const accessModeOptions = [
    { value: "custom", label: "Wlasne uprawnienia" },
    { value: "admin", label: "Pelny administrator" },
  ];

  const statusOptions = STATUS_OPTIONS.filter((option) => {
    if (option.value === form.account_status) return true;
    if (option.value === "banned") return canBanUsers || isAdmin || !showForm;
    if (option.value === "suspended") return canSuspendUsers || isAdmin || !showForm;
    return true;
  });

  return (
    <div className="space-y-4">
      <AdminAlert
        type={alert.type}
        message={alert.message}
        onClose={() => setAlert({ type: null, message: null })}
      />

      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h2 className={`text-xl font-bold ${textMain}`}>Zarzadzanie kontami</h2>
          <p className={`text-sm ${textMuted}`}>
            Zarzadzasz danymi logowania, statusem kont i szczegolowymi uprawnieniami do panelu.
          </p>
        </div>
        {canCreateUsers && (
          <button
            onClick={() => {
              resetForm();
              setShowForm(true);
            }}
            disabled={schemaUpdateRequired}
            className="flex items-center gap-2 px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors"
          >
            <UserPlus size={18} /> Nowe konto
          </button>
        )}
      </div>

      {schemaUpdateRequired && (
        <div className={`rounded-2xl border px-4 py-4 ${darkMode ? "border-yellow-500/30 bg-yellow-500/10" : "border-yellow-200 bg-yellow-50"}`}>
          <div className={`font-semibold ${darkMode ? "text-yellow-300" : "text-yellow-800"}`}>
            Trzeba zaktualizowac baze danych
          </div>
          <p className={`text-sm mt-1 ${darkMode ? "text-yellow-100/80" : "text-yellow-700"}`}>
            Ten ekran jest juz gotowy, ale Twoj projekt w Supabase nie ma jeszcze nowych kolumn dla kont i uprawnien.
            Uruchom plik <code className="font-mono">supabase/migrations/017_user_permissions.sql</code> w SQL Editor.
          </p>
        </div>
      )}

      {showForm && (
        <div className={`rounded-2xl border p-5 ${card}`}>
          <h3 className={`text-lg font-semibold mb-4 ${textMain}`}>
            {editId ? "Edytuj konto" : "Utworz nowe konto"}
          </h3>

          <form onSubmit={handleSubmit} className="space-y-5">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
              <AdminFormField
                label="Mail"
                name="email"
                type="email"
                value={form.email}
                onChange={updateField}
                required
                darkMode={darkMode}
                placeholder="jan@example.com"
              />
              <AdminFormField
                label="Nazwa wyswietlana"
                name="display_name"
                value={form.display_name}
                onChange={updateField}
                required
                darkMode={darkMode}
                placeholder="np. Jan Kowalski"
              />
              <AdminFormField
                label="Imie"
                name="first_name"
                value={form.first_name}
                onChange={updateField}
                required
                darkMode={darkMode}
                placeholder="Jan"
              />
              <AdminFormField
                label="Nazwisko"
                name="last_name"
                value={form.last_name}
                onChange={updateField}
                required
                darkMode={darkMode}
                placeholder="Kowalski"
              />
              <AdminFormField
                label="Tryb dostepu"
                name="access_mode"
                type="select"
                value={form.access_mode}
                onChange={updateField}
                options={accessModeOptions}
                darkMode={darkMode}
                disabled={!isAdmin && !canManagePermissions}
              />
              <AdminFormField
                label="Status konta"
                name="account_status"
                type="select"
                value={form.account_status}
                onChange={updateField}
                options={statusOptions}
                darkMode={darkMode}
              />
            </div>

            {!editId ? (
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                <AdminFormField
                  label="Haslo"
                  name="password"
                  type="password"
                  value={form.password}
                  onChange={updateField}
                  required
                  darkMode={darkMode}
                  placeholder="Minimum 6 znakow"
                />
                <AdminFormField
                  label="Powtorz haslo"
                  name="password_confirm"
                  type="password"
                  value={form.password_confirm}
                  onChange={updateField}
                  required
                  darkMode={darkMode}
                  placeholder="Powtorz haslo"
                />
              </div>
            ) : (
              <div className={`rounded-2xl border p-4 ${darkMode ? "border-white/10 bg-[#121826]" : "border-gray-200 bg-gray-50"}`}>
                <div className="flex items-center gap-2 mb-3">
                  <KeyRound size={16} className={darkMode ? "text-yellow-400" : "text-yellow-600"} />
                  <h4 className={`text-sm font-semibold ${textMain}`}>Zmiana danych logowania</h4>
                </div>
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
                  <AdminFormField
                    label="Aktualne haslo"
                    name="current_password"
                    type="password"
                    value={form.current_password}
                    onChange={updateField}
                    darkMode={darkMode}
                    placeholder="Wymagane do zmiany maila lub hasla"
                  />
                  <AdminFormField
                    label="Nowe haslo"
                    name="new_password"
                    type="password"
                    value={form.new_password}
                    onChange={updateField}
                    darkMode={darkMode}
                    placeholder="Zostaw puste, jesli bez zmiany"
                  />
                  <AdminFormField
                    label="Powtorz nowe haslo"
                    name="new_password_confirm"
                    type="password"
                    value={form.new_password_confirm}
                    onChange={updateField}
                    darkMode={darkMode}
                    placeholder="Powtorz nowe haslo"
                  />
                </div>
                <p className={`text-xs mt-3 ${textMuted}`}>
                  Jesli zmieniasz mail lub haslo istniejacego konta, wpisz aktualne haslo tego konta.
                </p>
              </div>
            )}

            <div className="space-y-3">
              <div>
                <h4 className={`text-sm font-semibold ${textMain}`}>Zakres uprawnien</h4>
                <p className={`text-xs mt-1 ${textMuted}`}>
                  Zaznaczenie glownej kategorii wlacza wszystkie czynnosci w tej galezi. Mozesz tez rozwinac kategorie i wybrac tylko pojedyncze akcje.
                </p>
              </div>
              <AdminPermissionTree
                darkMode={darkMode}
                permissions={form.permissions}
                onTogglePermission={handleTogglePermission}
                onToggleGroup={handleToggleGroup}
                disabled={form.access_mode === "admin" || !canManagePermissions}
              />
              {form.access_mode === "admin" && (
                <p className={`text-xs ${textMuted}`}>
                  Pelny administrator ma dostep do wszystkiego, wiec drzewo uprawnien jest tylko informacyjne.
                </p>
              )}
            </div>

            <div className="flex flex-wrap gap-3">
              <button
                type="submit"
                disabled={saving}
                className="px-5 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors disabled:opacity-50"
              >
                {saving ? "Zapisywanie..." : editId ? "Zapisz zmiany" : "Utworz konto"}
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

      <div className={`rounded-2xl border ${card}`}>
        <div className={`px-5 py-3 border-b ${darkMode ? "border-white/10" : "border-gray-200"}`}>
          <h3 className={`font-semibold ${textMain}`}>Konta ({users.length})</h3>
        </div>

        {!canManageAnyUsers ? (
          <div className={`p-8 text-center ${textMuted}`}>Brak uprawnien do przegladania i edycji kont.</div>
        ) : loading ? (
          <div className={`p-8 text-center ${textMuted}`}>Ladowanie...</div>
        ) : users.length === 0 ? (
          <div className={`p-8 text-center ${textMuted}`}>Brak kont.</div>
        ) : (
          <div className="divide-y divide-gray-200 dark:divide-white/10">
            {users.map((user) => {
              const fullName = [user.first_name, user.last_name].filter(Boolean).join(" ").trim();
              const status = user.account_status || "active";

              return (
                <div key={user.id} className="flex flex-wrap items-center gap-3 px-5 py-4">
                  <div className="flex items-center gap-3 flex-1 min-w-0">
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                      user.role === "admin"
                        ? "bg-red-500/20 text-red-400"
                        : "bg-blue-500/20 text-blue-400"
                    }`}>
                      <Shield size={16} />
                    </div>

                    <div className="min-w-0">
                      <div className={`text-sm font-semibold truncate ${textMain}`}>
                        {user.display_name || fullName || user.email || user.id.slice(0, 8)}
                      </div>
                      <div className={`text-xs truncate ${textMuted}`}>
                        {user.email || "brak maila"}{fullName ? ` | ${fullName}` : ""}
                      </div>
                    </div>
                  </div>

                  <div className="flex flex-wrap items-center gap-2">
                    <span className={`px-2 py-0.5 rounded-lg text-xs font-medium border ${getStatusBadge(status)}`}>
                      {status === "banned" ? "Zbanowane" : status === "suspended" ? "Zawieszone" : "Aktywne"}
                    </span>
                    <span className={`px-2 py-0.5 rounded-lg text-xs font-medium border ${
                      user.role === "admin"
                        ? "bg-red-500/20 text-red-400 border-red-500/30"
                        : "bg-slate-500/15 text-slate-500 border-slate-400/30"
                    }`}>
                      {user.role === "admin" ? "Pelny admin" : "Wlasne uprawnienia"}
                    </span>

                    {canSuspendUsers && status === "active" && user.id !== profile?.id && (
                      <button
                        onClick={() => handleQuickStatusChange(user, "suspended")}
                        className={`p-1.5 rounded-lg transition-colors ${darkMode ? "hover:bg-yellow-500/10 text-yellow-400" : "hover:bg-yellow-50 text-yellow-700"}`}
                        title="Zawies konto"
                      >
                        <PauseCircle size={15} />
                      </button>
                    )}

                    {canBanUsers && status !== "banned" && user.id !== profile?.id && (
                      <button
                        onClick={() => handleQuickStatusChange(user, "banned")}
                        className="p-1.5 rounded-lg hover:bg-red-500/10 text-red-400 transition-colors"
                        title="Zbanuj konto"
                      >
                        <Ban size={15} />
                      </button>
                    )}

                    {(canBanUsers || canSuspendUsers || canEditUsers) && status !== "active" && (
                      <button
                        onClick={() => handleQuickStatusChange(user, "active")}
                        className={`p-1.5 rounded-lg transition-colors ${darkMode ? "hover:bg-green-500/10 text-green-400" : "hover:bg-green-50 text-green-700"}`}
                        title="Przywroc konto"
                      >
                        <Undo2 size={15} />
                      </button>
                    )}

                    {(canEditUsers || canManagePermissions) && (
                      <button
                        onClick={() => handleEditUser(user)}
                        className={`p-1.5 rounded-lg transition-colors ${darkMode ? "hover:bg-white/10 text-gray-400" : "hover:bg-gray-100 text-gray-500"}`}
                        title="Edytuj konto"
                      >
                        <Edit3 size={15} />
                      </button>
                    )}

                    {canDeleteUsers && user.id !== profile?.id && (
                      <button
                        onClick={() => handleDeleteUser(user)}
                        className="p-1.5 rounded-lg hover:bg-red-500/10 text-red-400 transition-colors"
                        title="Usun konto z panelu"
                      >
                        <Trash2 size={15} />
                      </button>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
