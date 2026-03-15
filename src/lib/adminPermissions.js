export const ADMIN_PERMISSION_GROUPS = [
  {
    key: "seasons",
    label: "Sezony",
    permissions: [
      { key: "seasons.generate", label: "Generowanie sezonów" },
      { key: "seasons.delete", label: "Usuwanie sezonów" },
      { key: "seasons.edit", label: "Edycja sezonów" },
    ],
  },
  {
    key: "teams",
    label: "Drużyny",
    permissions: [
      { key: "teams.create", label: "Tworzenie drużyn" },
      { key: "teams.delete", label: "Usuwanie drużyn" },
      { key: "teams.edit", label: "Edycja drużyn" },
    ],
  },
  {
    key: "players",
    label: "Zawodnicy",
    permissions: [
      { key: "players.create", label: "Tworzenie zawodników" },
      { key: "players.delete", label: "Usuwanie zawodników" },
      { key: "players.edit", label: "Edycja zawodników" },
    ],
  },
  {
    key: "rosters",
    label: "Kadry",
    permissions: [
      { key: "rosters.edit", label: "Edycja kadry" },
    ],
  },
  {
    key: "schedule",
    label: "Terminarz",
    permissions: [
      { key: "schedule.edit", label: "Edycja terminarza" },
    ],
  },
  {
    key: "results",
    label: "Wyniki",
    permissions: [
      { key: "results.enter", label: "Wprowadzanie wyników" },
      { key: "results.edit", label: "Edycja wprowadzonych wyników" },
    ],
  },
  {
    key: "referees",
    label: "Sędziowie",
    permissions: [
      { key: "referees.create", label: "Dodawanie sędziów" },
      { key: "referees.delete", label: "Usuwanie sędziów" },
      { key: "referees.edit", label: "Edycja sędziów" },
    ],
  },
  {
    key: "polls",
    label: "Ankiety",
    permissions: [
      { key: "polls.create", label: "Tworzenie ankiet" },
      { key: "polls.delete", label: "Usuwanie ankiet" },
      { key: "polls.edit", label: "Edycja ankiet" },
    ],
  },
  {
    key: "typer",
    label: "Typer",
    permissions: [
      { key: "typer.create", label: "Tworzenie typera" },
      { key: "typer.delete", label: "Usuwanie typera" },
      { key: "typer.edit", label: "Edycja typera" },
    ],
  },
  {
    key: "users",
    label: "Konta i uprawnienia",
    permissions: [
      { key: "users.create", label: "Dodawanie użytkowników" },
      { key: "users.delete", label: "Usuwanie użytkowników" },
      { key: "users.ban", label: "Banowanie użytkowników" },
      { key: "users.suspend", label: "Zawieszanie użytkowników" },
      { key: "users.edit", label: "Edycja użytkowników" },
      { key: "users.permissions.grant", label: "Nadawanie uprawnień" },
      { key: "users.permissions.revoke", label: "Usuwanie uprawnień" },
    ],
  },
];

export const ADMIN_SECTION_PERMISSIONS = {
  dashboard: [],
  wizard: ["seasons.generate"],
  seasons: ["seasons.generate", "seasons.edit", "seasons.delete"],
  teams: ["teams.create", "teams.edit", "teams.delete"],
  players: ["players.create", "players.edit", "players.delete"],
  rosters: ["rosters.edit"],
  schedule: ["schedule.edit"],
  results: ["results.enter", "results.edit"],
  referees: ["referees.create", "referees.edit", "referees.delete"],
  "control-center": [
    "polls.create",
    "polls.edit",
    "polls.delete",
    "typer.create",
    "typer.edit",
    "typer.delete",
  ],
  users: [
    "users.create",
    "users.delete",
    "users.ban",
    "users.suspend",
    "users.edit",
    "users.permissions.grant",
    "users.permissions.revoke",
  ],
};

export const LEGACY_EDITOR_PERMISSION_KEYS = new Set([
  "players.edit",
  "rosters.edit",
  "schedule.edit",
  "results.enter",
  "results.edit",
  "referees.create",
  "referees.edit",
  "referees.delete",
  "polls.create",
  "polls.edit",
  "polls.delete",
  "typer.create",
  "typer.edit",
  "typer.delete",
]);

function buildNestedValue(keys, value) {
  if (keys.length === 0) return value;

  const [head, ...tail] = keys;
  return { [head]: buildNestedValue(tail, value) };
}

function mergeObjects(base, incoming) {
  const result = { ...base };

  Object.entries(incoming || {}).forEach(([key, value]) => {
    if (
      value &&
      typeof value === "object" &&
      !Array.isArray(value) &&
      result[key] &&
      typeof result[key] === "object" &&
      !Array.isArray(result[key])
    ) {
      result[key] = mergeObjects(result[key], value);
      return;
    }

    result[key] = value;
  });

  return result;
}

export function createEmptyPermissions() {
  return ADMIN_PERMISSION_GROUPS.reduce((acc, group) => {
    acc[group.key] = group.permissions.reduce((groupAcc, permission) => {
      const [, ...rest] = permission.key.split(".");
      return mergeObjects(groupAcc, buildNestedValue(rest, false));
    }, {});
    return acc;
  }, {});
}

export function normalizePermissions(rawPermissions) {
  const empty = createEmptyPermissions();
  if (!rawPermissions || typeof rawPermissions !== "object" || Array.isArray(rawPermissions)) {
    return empty;
  }

  const normalized = JSON.parse(JSON.stringify(empty));

  ADMIN_PERMISSION_GROUPS.forEach((group) => {
    group.permissions.forEach((permission) => {
      const value = getPermissionValue(rawPermissions, permission.key);
      if (value) {
        setPermissionValue(normalized, permission.key, true);
      }
    });
  });

  return normalized;
}

export function getPermissionValue(permissions, permissionKey) {
  return permissionKey
    .split(".")
    .reduce((acc, part) => (acc && typeof acc === "object" ? acc[part] : undefined), permissions);
}

export function setPermissionValue(permissions, permissionKey, nextValue) {
  const parts = permissionKey.split(".");
  let cursor = permissions;

  parts.forEach((part, index) => {
    if (index === parts.length - 1) {
      cursor[part] = !!nextValue;
      return;
    }

    if (!cursor[part] || typeof cursor[part] !== "object" || Array.isArray(cursor[part])) {
      cursor[part] = {};
    }

    cursor = cursor[part];
  });

  return permissions;
}

export function clonePermissions(permissions) {
  return normalizePermissions(JSON.parse(JSON.stringify(permissions || {})));
}

export function hasGrantedPermissions(permissions) {
  return ADMIN_PERMISSION_GROUPS.some((group) =>
    group.permissions.some((permission) => !!getPermissionValue(permissions, permission.key))
  );
}

export function hasPermission(permissions, permissionKey, role = "viewer") {
  if (role === "admin") return true;
  if (role === "editor" && LEGACY_EDITOR_PERMISSION_KEYS.has(permissionKey)) return true;
  return !!getPermissionValue(permissions, permissionKey);
}

export function hasAnyPermission(permissions, permissionKeys, role = "viewer") {
  if (role === "admin") return true;
  return permissionKeys.some((permissionKey) => hasPermission(permissions, permissionKey, role));
}

export function getGroupSelectionState(permissions, groupKey, role = "viewer") {
  const group = ADMIN_PERMISSION_GROUPS.find((item) => item.key === groupKey);
  if (!group) {
    return { allChecked: false, partiallyChecked: false };
  }

  const states = group.permissions.map((permission) => hasPermission(permissions, permission.key, role));
  const allChecked = states.every(Boolean);
  const partiallyChecked = !allChecked && states.some(Boolean);

  return { allChecked, partiallyChecked };
}

export function getDefaultDisplayName(firstName, lastName, fallbackEmail = "") {
  const fullName = [firstName, lastName].filter(Boolean).join(" ").trim();
  return fullName || fallbackEmail || "";
}
