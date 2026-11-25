import React, { useCallback, useEffect, useId, useState } from "react";
import { createClient } from "@supabase/supabase-js";
import { Ban, Edit3, KeyRound, PauseCircle, Search, Shield, Trash2, Undo2, UserPlus, Users, UserRound } from "lucide-react";
import { supabase } from "../../lib/supabase";
import { useAuth } from "../../contexts/AuthContext";
import {
  ADMIN_PERMISSION_GROUPS,
  createEmptyPermissions,
  getDefaultDisplayName,
  getPermissionValue,
  normalizePermissions,
  setPermissionValue,
} from "../../lib/adminPermissions";
import AdminAlert from "./components/AdminAlert";
import AdminFormField from "./components/AdminFormField";
import AdminPermissionTree from "./components/AdminPermissionTree";
import { countAccountGroups, filterAccountDirectory, getAccountGroup, getAccountRoleLabel } from "../../lib/accountDirectory";
import "./AdminUsers.css";
import {
  canChangeProfilePermission,
  canChangeProfileStatus,
  canEditProfileDetails,
  canManageProfileTarget,
  getProfileRoleForSave,
  isActiveProfileAdmin,
} from "./utils/profileManagementAccess";

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
  const directoryId = useId();
  const { profile, can, canAny } = useAuth();
  const isAdmin = isActiveProfileAdmin(profile);
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [schemaUpdateRequired, setSchemaUpdateRequired] = useState(false);
  const [showForm, setShowForm] = useState(false);
  const [editId, setEditId] = useState(null);
  const [originalEmail, setOriginalEmail] = useState("");
  const [form, setForm] = useState(createAccountForm);
  const [alert, setAlert] = useState({ type: null, message: null });
  const [accountGroup, setAccountGroup] = useState("users");
  const [formGroup, setFormGroup] = useState("users");
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");

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
  const accountCounts = countAccountGroups(users);
  const visibleUsers = filterAccountDirectory(users, { group: accountGroup, query: search, status: statusFilter });
  const groupLabel = accountGroup === "staff" ? "Obsługa MLPN" : "Użytkownicy";
  const editingUser = users.find((user) => user.id === editId) || null;
  const canEditDetails = canEditProfileDetails(profile, editingUser);
  const canEditSensitiveFields = isAdmin || (editingUser?.id !== profile?.id && canManageProfileTarget(profile, editingUser));
  const canTogglePermission = (key, value) => canChangeProfilePermission(profile, editingUser, key, value);

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMain = darkMode ? "text-white" : "text-gray-900";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const isSchemaError = (message = "") =>
    message.includes("column profiles.") ||
    message.includes("column public.profiles.") ||
    message.includes("Could not find the 'email' column");

  const loadUsers = useCallback(async () => {
    if (!canManageAnyUsers) {
      setUsers([]); setLoading(false);
      return;
    }
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
  }, [canManageAnyUsers]);

  useEffect(() => {
    loadUsers();
  }, [loadUsers]);

  const resetForm = () => {
    setForm(createAccountForm());
    setOriginalEmail("");
    setEditId(null);
    setShowForm(false);
  };

  const changeAccountGroup = (group) => {
    if (saving) return;
    setAccountGroup(group);
    resetForm();
  };

  const updateField = (event) => {
    const { name, value } = event.target;
    setForm((current) => ({ ...current, [name]: value }));
  };

  const handleTogglePermission = (permissionKey, nextValue) => {
    if (!canTogglePermission(permissionKey, nextValue)) return;
    setForm((current) => {
      const nextPermissions = normalizePermissions(current.permissions);
      setPermissionValue(nextPermissions, permissionKey, nextValue);
      return { ...current, permissions: nextPermissions };
    });
  };

  const handleToggleGroup = (groupKey, nextValue) => {
    setForm((current) => {
      const nextPermissions = normalizePermissions(current.permissions);
      const group = ADMIN_PERMISSION_GROUPS.find((item) => item.key === groupKey);
      const changes = (group?.permissions || []).filter(({ key }) => !!getPermissionValue(nextPermissions, key) !== nextValue);
      if (!changes.every(({ key }) => canTogglePermission(key, nextValue))) return current;
      changes.forEach(({ key }) => setPermissionValue(nextPermissions, key, nextValue));
      return { ...current, permissions: nextPermissions };
    });
  };

  const validateForm = (isEditing) => {
    if ((!isEditing || canEditDetails) && (!form.email || !form.first_name || !form.last_name || !form.display_name)) {
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
    role: getProfileRoleForSave(profile, editingUser, form.access_mode),
    account_status: form.account_status,
    permissions: normalizePermissions(form.permissions),
  });

  const syncAuthCredentials = async () => {
    if (!canEditDetails) return null;
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
    if (!isEditing && formGroup === "staff" && getAccountGroup(profilePayload) !== "staff") {
      setAlert({ type: "error", message: "Wybierz zakres uprawnień dla konta obsługi MLPN." });
      return;
    }
    const basicFields = ["email", "first_name", "last_name", "display_name"];
    const changes = isEditing && editingUser
      ? Object.fromEntries(Object.entries(profilePayload).filter(([key]) => canEditDetails || !basicFields.includes(key)).filter(([key, value]) =>
        key === "permissions"
          ? JSON.stringify(value) !== JSON.stringify(editingUser.permissions)
          : value !== (editingUser[key] || "")))
      : {};

    if (!isEditing && !canCreateUsers) {
      setAlert({ type: "error", message: "Brak uprawnien do tworzenia kont." });
      return;
    }

    if (isEditing && !canAny(["users.edit", "users.permissions.grant", "users.permissions.revoke", "users.ban", "users.suspend"])) {
      setAlert({ type: "error", message: "Brak uprawnien do edycji tego konta." });
      return;
    }

    if (isEditing && (!editingUser || (!canManageProfileTarget(profile, editingUser) && editingUser.id !== profile?.id))) {
      setAlert({ type: "error", message: "Tym kontem moze zarzadzac tylko administrator." });
      return;
    }

    if (isEditing && !canEditDetails && (basicFields.some((key) => key in changes) || form.new_password)) {
      setAlert({ type: "error", message: "Brak uprawnien do zmiany danych konta." });
      return;
    }

    const permissionsAllowed = ADMIN_PERMISSION_GROUPS.every((group) => group.permissions.every(({ key }) => {
      const nextValue = !!getPermissionValue(profilePayload.permissions, key);
      return nextValue === !!getPermissionValue(editingUser?.permissions, key) || canTogglePermission(key, nextValue);
    }));
    if (!permissionsAllowed || !canChangeProfileStatus(profile, editingUser, profilePayload.account_status)) {
      setAlert({ type: "error", message: "Brak uprawnien do wybranej zmiany statusu lub uprawnien." });
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

        if (Object.keys(changes).length) {
          const { error } = await supabase
            .from("profiles")
            .update(changes)
            .eq("id", editId)
            .select("id")
            .single();
          if (error) throw error;
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

        // Auth creates the viewer profile and copies names from signup metadata.
        // A creator with no editing permissions needs no additional profile write.
        const accessChanges = {};
        if (profilePayload.role !== "viewer") accessChanges.role = profilePayload.role;
        if (profilePayload.account_status !== "active") accessChanges.account_status = profilePayload.account_status;
        if (ADMIN_PERMISSION_GROUPS.some((group) => group.permissions.some(({ key }) => getPermissionValue(profilePayload.permissions, key)))) {
          accessChanges.permissions = profilePayload.permissions;
        }
        try {
          if (Object.keys(accessChanges).length) {
            const { error: profileError } = await supabase
              .from("profiles")
              .update(accessChanges)
              .eq("id", signUpData.user.id)
              .select("id")
              .single();
            if (profileError) throw profileError;
          }
        } finally {
          await authClient.auth.signOut();
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
      setAccountGroup(getAccountGroup(profilePayload));
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
    if (!canManageProfileTarget(profile, user) && user.id !== profile?.id) return;
    setEditId(user.id);
    setOriginalEmail(user.email || "");
    setFormGroup(getAccountGroup(user));
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
      access_mode: ["admin", "editor"].includes(user.role) ? user.role : "custom",
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

    if (!canDeleteUsers || !canManageProfileTarget(profile, user)) {
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

    if (!canChangeProfileStatus(profile, user, nextStatus)) {
      setAlert({ type: "error", message: "Brak uprawnien do tej zmiany statusu konta." });
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
    { value: "custom", label: "Użytkownik / wybrane uprawnienia" },
    ...(editingUser?.role === "editor" ? [{ value: "editor", label: "Redaktor" }] : []),
    { value: "admin", label: "Pełny administrator" },
  ];

  const statusOptions = STATUS_OPTIONS.filter((option) => option.value === form.account_status ||
    canChangeProfileStatus(profile, editingUser, option.value));

  return (
    <div className={`mlpn-account-directory space-y-4${darkMode ? " is-dark" : ""}`}>
      <AdminAlert
        type={alert.type}
        message={alert.message}
        onClose={() => setAlert({ type: null, message: null })}
      />

      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h2 className={`text-xl font-bold ${textMain}`}>Zarządzanie kontami</h2>
          <p className={`text-sm ${textMuted}`}>
            Użytkownicy strony i osoby zarządzające MLPN.
          </p>
        </div>
        {canCreateUsers && (accountGroup === "users" || isAdmin || can("users.permissions.grant")) && (
          <button
            onClick={() => {
              resetForm();
              setFormGroup(accountGroup);
              setShowForm(true);
            }}
            disabled={schemaUpdateRequired || saving}
            className="flex items-center gap-2 px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors"
          >
            <UserPlus size={18} /> {accountGroup === "staff" ? "Nowe konto obsługi" : "Nowy użytkownik"}
          </button>
        )}
      </div>

      {canManageAnyUsers && <div className="mlpn-account-tabs" role="tablist" aria-label="Rodzaj kont">
        {[["users", "Użytkownicy", Users], ["staff", "Obsługa MLPN", Shield]].map(([group, label, Icon], index) =>
          <button key={group} type="button" role="tab" id={`${directoryId}-${group}`}
            aria-selected={accountGroup === group} aria-controls={`${directoryId}-accounts`}
            tabIndex={accountGroup === group ? 0 : -1} disabled={saving}
            onClick={() => changeAccountGroup(group)} onKeyDown={event => {
              if (!["ArrowLeft", "ArrowRight", "Home", "End"].includes(event.key)) return;
              event.preventDefault();
              const nextIndex = event.key === "Home" ? 0 : event.key === "End" ? 1 : 1 - index;
              changeAccountGroup(nextIndex === 0 ? "users" : "staff");
              event.currentTarget.parentElement.querySelectorAll('button')[nextIndex]?.focus();
            }}>
            <Icon size={20} aria-hidden="true" /><span>{label} ({accountCounts[group]})</span>
          </button>)}
      </div>}

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

      {showForm && canManageAnyUsers && (
        <div className={`rounded-2xl border p-5 ${card}`}>
          <h3 className={`text-lg font-semibold mb-4 ${textMain}`}>
            {editId ? (formGroup === "staff" ? "Edytuj konto obsługi" : "Edytuj użytkownika")
              : (formGroup === "staff" ? "Nowe konto obsługi MLPN" : "Nowy użytkownik")}
          </h3>

          <form onSubmit={handleSubmit} className="space-y-5">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
              <AdminFormField
                label="Mail"
                name="email"
                disabled={!canEditDetails}
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
                disabled={!canEditDetails}
                value={form.display_name}
                onChange={updateField}
                required
                darkMode={darkMode}
                placeholder="np. Jan Kowalski"
              />
              <AdminFormField
                label="Imie"
                name="first_name"
                disabled={!canEditDetails}
                value={form.first_name}
                onChange={updateField}
                required
                darkMode={darkMode}
                placeholder="Jan"
              />
              <AdminFormField
                label="Nazwisko"
                name="last_name"
                disabled={!canEditDetails}
                value={form.last_name}
                onChange={updateField}
                required
                darkMode={darkMode}
                placeholder="Kowalski"
              />
              <AdminFormField
                label="Status konta"
                name="account_status"
                disabled={!canEditSensitiveFields || statusOptions.length < 2}
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
                    disabled={!canEditDetails}
                    type="password"
                    value={form.current_password}
                    onChange={updateField}
                    darkMode={darkMode}
                    placeholder="Wymagane do zmiany maila lub hasla"
                  />
                  <AdminFormField
                    label="Nowe haslo"
                    name="new_password"
                    disabled={!canEditDetails}
                    type="password"
                    value={form.new_password}
                    onChange={updateField}
                    darkMode={darkMode}
                    placeholder="Zostaw puste, jesli bez zmiany"
                  />
                  <AdminFormField
                    label="Powtorz nowe haslo"
                    name="new_password_confirm"
                    disabled={!canEditDetails}
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

            <details key={`${editId || "new"}-${formGroup}`} className="mlpn-account-access space-y-3" open={formGroup === "staff" ? true : undefined}>
              <summary>Dostęp do panelu MLPN</summary>
              <p className={`text-xs ${textMuted}`}>{
                getAccountGroup({ role: form.access_mode, permissions: form.permissions }) === "staff"
                  ? "To konto należy do obsługi MLPN."
                  : "Konto użytkownika — bez dostępu do panelu."
              }</p>
              <AdminFormField label="Tryb dostępu" name="access_mode" type="select" value={form.access_mode}
                onChange={updateField} options={accessModeOptions} darkMode={darkMode} disabled={!isAdmin}
                includeEmptyOption={false} />
              <div>
                <h4 className={`text-sm font-semibold ${textMain}`}>Zakres uprawnień</h4>
                <p className={`text-xs mt-1 ${textMuted}`}>
                  Zaznaczenie glownej kategorii wlacza wszystkie czynnosci w tej galezi. Mozesz tez rozwinac kategorie i wybrac tylko pojedyncze akcje.
                </p>
              </div>
              <AdminPermissionTree
                darkMode={darkMode}
                permissions={form.permissions}
                onTogglePermission={handleTogglePermission}
                onToggleGroup={handleToggleGroup}
                canTogglePermission={canTogglePermission}
                disabled={form.access_mode === "admin" || !canManagePermissions || !canEditSensitiveFields}
              />
              {form.access_mode === "admin" && (
                <p className={`text-xs ${textMuted}`}>
                  Pelny administrator ma dostep do wszystkiego, wiec drzewo uprawnien jest tylko informacyjne.
                </p>
              )}
            </details>

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

      <div id={`${directoryId}-accounts`} role={canManageAnyUsers ? "tabpanel" : undefined}
        aria-labelledby={canManageAnyUsers ? `${directoryId}-${accountGroup}` : undefined}
        className={`rounded-2xl border ${card}`}>
        <div className={`px-5 py-3 border-b ${darkMode ? "border-white/10" : "border-gray-200"}`}>
          <h3 className={`font-semibold ${textMain}`}>{groupLabel}</h3>
          {canManageAnyUsers && <p className={`text-xs mt-1 ${textMuted}`}>{
            accountGroup === "staff" ? "Administratorzy, organizatorzy, dyżurni i pozostałe osoby z uprawnieniami do panelu."
              : "Konta użytkowników strony i gier MLPN bez uprawnień do panelu."
          }</p>}
        </div>

        {canManageAnyUsers && <div className="mlpn-account-filters">
          <label className="mlpn-account-search"><span><Search size={16} aria-hidden="true" />Szukaj konta</span>
            <input type="search" aria-label="Szukaj konta" placeholder="Imię, nazwisko lub e-mail" value={search}
              onChange={event => setSearch(event.target.value)} /></label>
          <label><span>Status kont</span><select aria-label="Status kont" value={statusFilter} onChange={event => setStatusFilter(event.target.value)}>
            <option value="all">Wszystkie statusy</option>{STATUS_OPTIONS.map(option => <option key={option.value} value={option.value}>{option.label}</option>)}
          </select></label>
          {!loading && <p role="status">Wyświetlono {visibleUsers.length} z {accountCounts[accountGroup]}</p>}
        </div>}

        {!canManageAnyUsers ? (
          <div className={`p-8 text-center ${textMuted}`}>Brak uprawnien do przegladania i edycji kont.</div>
        ) : loading ? (
          <div className={`p-8 text-center ${textMuted}`}>Ladowanie...</div>
        ) : visibleUsers.length === 0 ? (
          <div className={`p-8 text-center ${textMuted}`}>{
            search || statusFilter !== "all" ? "Brak kont pasujących do filtrów."
              : accountGroup === "staff" ? "Brak kont obsługi MLPN." : "Brak kont użytkowników."
          }</div>
        ) : (
          <div className="divide-y divide-gray-200 dark:divide-white/10">
            {visibleUsers.map((user) => {
              const fullName = [user.first_name, user.last_name].filter(Boolean).join(" ").trim();
              const status = user.account_status || "active";

              return (
                <div key={user.id} data-account-id={user.id} className="mlpn-account-row px-5 py-4">
                  <div className="mlpn-account-identity">
                    <div className={`mlpn-account-avatar w-10 h-10 rounded-full flex items-center justify-center ${
                      user.role === "admin"
                        ? "bg-red-500/20 text-red-400"
                        : "bg-blue-500/20 text-blue-400"
                    }`}>
                      {getAccountGroup(user) === "staff" ? <Shield size={16} aria-hidden="true" /> : <UserRound size={16} aria-hidden="true" />}
                    </div>

                    <div className="min-w-0">
                      <div className={`text-sm font-semibold mlpn-account-name ${textMain}`}>
                        {user.display_name || fullName || user.email || user.id.slice(0, 8)}
                      </div>
                      <div className={`text-xs mlpn-account-contact ${textMuted}`}>
                        {user.email || "brak maila"}{fullName ? ` | ${fullName}` : ""}
                      </div>
                    </div>
                  </div>

                  <div className="mlpn-account-actions flex flex-wrap items-center gap-2">
                    <span className={`px-2 py-0.5 rounded-lg text-xs font-medium border ${getStatusBadge(status)}`}>
                      {status === "banned" ? "Zbanowane" : status === "suspended" ? "Zawieszone" : "Aktywne"}
                    </span>
                    <span className={`px-2 py-0.5 rounded-lg text-xs font-medium border ${
                      user.role === "admin"
                        ? "bg-red-500/20 text-red-400 border-red-500/30"
                        : "bg-slate-500/15 text-slate-500 border-slate-400/30"
                    }`}>
                      {getAccountRoleLabel(user)}
                    </span>

                    {status === "active" && canChangeProfileStatus(profile, user, "suspended") && (
                      <button
                        onClick={() => handleQuickStatusChange(user, "suspended")}
                        className={`p-1.5 rounded-lg transition-colors ${darkMode ? "hover:bg-yellow-500/10 text-yellow-400" : "hover:bg-yellow-50 text-yellow-700"}`}
                        title="Zawies konto"
                      >
                        <PauseCircle size={15} />
                      </button>
                    )}

                    {status !== "banned" && canChangeProfileStatus(profile, user, "banned") && (
                      <button
                        onClick={() => handleQuickStatusChange(user, "banned")}
                        className="p-1.5 rounded-lg hover:bg-red-500/10 text-red-400 transition-colors"
                        title="Zbanuj konto"
                      >
                        <Ban size={15} />
                      </button>
                    )}

                    {status !== "active" && canChangeProfileStatus(profile, user, "active") && (
                      <button
                        onClick={() => handleQuickStatusChange(user, "active")}
                        className={`p-1.5 rounded-lg transition-colors ${darkMode ? "hover:bg-green-500/10 text-green-400" : "hover:bg-green-50 text-green-700"}`}
                        title="Przywroc konto"
                      >
                        <Undo2 size={15} />
                      </button>
                    )}

                    {(canEditUsers || canManagePermissions) && (canManageProfileTarget(profile, user) || user.id === profile?.id) && (
                      <button
                        onClick={() => handleEditUser(user)}
                        className={`p-1.5 rounded-lg transition-colors ${darkMode ? "hover:bg-white/10 text-gray-400" : "hover:bg-gray-100 text-gray-500"}`}
                        title="Edytuj konto"
                      >
                        <Edit3 size={15} />
                      </button>
                    )}

                    {canDeleteUsers && canManageProfileTarget(profile, user) && user.id !== profile?.id && (
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
