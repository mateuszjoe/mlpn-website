import {
  canChangeProfilePermission,
  canChangeProfileStatus,
  canEditProfileDetails,
  canManageProfileTarget,
  getProfileRoleForSave,
} from "./profileManagementAccess";

const viewer = { id: "viewer", role: "viewer", account_status: "active", permissions: {} };
const actor = (permissions, overrides = {}) => ({ ...viewer, id: "manager", permissions, ...overrides });

test("delegates can only grant their own business permissions, never user administration", () => {
  const manager = actor({ users: { create: true, permissions: { grant: true } }, schedule: { edit: true } });
  expect(canChangeProfilePermission(manager, viewer, "schedule.edit", true)).toBe(true);
  expect(canChangeProfilePermission(manager, viewer, "seasons.generate", true)).toBe(false);
  expect(canChangeProfilePermission(manager, viewer, "users.create", true)).toBe(false);
  expect(canChangeProfilePermission(manager, manager, "schedule.edit", false)).toBe(false);
});

test("grant and revoke permissions are separate, with unsaved changes reversible", () => {
  const grantedViewer = { ...viewer, permissions: { schedule: { edit: true }, users: { create: true } } };
  const grantOnly = actor({ users: { permissions: { grant: true } }, schedule: { edit: true } });
  const revokeOnly = actor({ users: { permissions: { revoke: true } } });
  expect(canChangeProfilePermission(grantOnly, grantedViewer, "schedule.edit", false)).toBe(false);
  expect(canChangeProfilePermission(revokeOnly, grantedViewer, "schedule.edit", false)).toBe(true);
  expect(canChangeProfilePermission(revokeOnly, grantedViewer, "users.create", false)).toBe(true);
  expect(canChangeProfilePermission(revokeOnly, viewer, "schedule.edit", true)).toBe(false);
  expect(canChangeProfilePermission(grantOnly, viewer, "schedule.edit", false)).toBe(true);
  expect(canChangeProfilePermission(revokeOnly, grantedViewer, "schedule.edit", true)).toBe(true);
});

test("restoration and transitions require authority over the old and new status", () => {
  const banOnly = actor({ users: { ban: true } });
  const editOnly = actor({ users: { edit: true } });
  expect(canChangeProfileStatus(banOnly, viewer, "banned")).toBe(true);
  expect(canChangeProfileStatus(banOnly, { ...viewer, account_status: "banned" }, "active")).toBe(true);
  expect(canChangeProfileStatus(banOnly, { ...viewer, account_status: "suspended" }, "active")).toBe(false);
  expect(canChangeProfileStatus(banOnly, { ...viewer, account_status: "suspended" }, "banned")).toBe(false);
  expect(canChangeProfileStatus(editOnly, { ...viewer, account_status: "banned" }, "active")).toBe(false);
  expect(canChangeProfileStatus(banOnly, banOnly, "banned")).toBe(false);
});

test("admin/editor targets and roles are protected from delegates", () => {
  const manager = actor({ users: { edit: true, permissions: { grant: true } } });
  for (const role of ["admin", "editor"]) {
    const target = { ...viewer, role };
    expect(canManageProfileTarget(manager, target)).toBe(false);
    expect(canEditProfileDetails(manager, target)).toBe(false);
    expect(canChangeProfilePermission(manager, target, "schedule.edit", true)).toBe(false);
    expect(getProfileRoleForSave(manager, target, "admin")).toBe(role);
  }
  expect(getProfileRoleForSave(manager, viewer, "admin")).toBe("viewer");
  expect(canEditProfileDetails(viewer, viewer)).toBe(true);
});

test("active admins retain management access and legacy editor roles are preserved", () => {
  const admin = actor({}, { role: "admin" });
  expect(canChangeProfilePermission(admin, viewer, "users.permissions.grant", true)).toBe(true);
  expect(getProfileRoleForSave(admin, { ...viewer, role: "editor" }, "editor")).toBe("editor");
  expect(getProfileRoleForSave(admin, viewer, "admin")).toBe("admin");
  const blocked = { ...admin, account_status: "suspended" };
  expect(canEditProfileDetails(blocked, viewer)).toBe(false);
  expect(canChangeProfilePermission(blocked, viewer, "schedule.edit", true)).toBe(false);
  expect(canChangeProfileStatus(blocked, viewer, "banned")).toBe(false);
});
