import { getPermissionValue, hasPermission } from "../../../lib/adminPermissions";

const isActive = (actor) => !!actor?.id && (actor.account_status || "active") === "active";
export const isActiveProfileAdmin = (actor) => isActive(actor) && actor.role === "admin";
const can = (actor, key) => isActive(actor) && hasPermission(actor.permissions, key, actor.role);

export function canManageProfileTarget(actor, target) {
  return isActive(actor) && (isActiveProfileAdmin(actor) || !["admin", "editor"].includes(target?.role));
}

export function canEditProfileDetails(actor, target) {
  if (!target) return can(actor, "users.create");
  return isActive(actor) && (actor.id === target.id ||
    (canManageProfileTarget(actor, target) && can(actor, "users.edit")));
}

export function canChangeProfilePermission(actor, target, key, nextValue) {
  if (!canManageProfileTarget(actor, target)) return false;
  if (isActiveProfileAdmin(actor)) return true;
  if (target?.id === actor.id) return false;
  // Allow undoing an unsaved change without requiring the opposite permission.
  if (nextValue === !!getPermissionValue(target?.permissions, key)) return true;
  if (!nextValue) return can(actor, "users.permissions.revoke");
  return !key.startsWith("users.") && can(actor, "users.permissions.grant") && can(actor, key);
}

export function canChangeProfileStatus(actor, target, nextStatus) {
  const previousStatus = target?.account_status || "active";
  if (!isActive(actor)) return false;
  if (nextStatus === previousStatus) return true;
  if (target?.id === actor.id) return false;
  if (!canManageProfileTarget(actor, target)) return false;
  if (isActiveProfileAdmin(actor)) return true;
  const permissionForStatus = { banned: "users.ban", suspended: "users.suspend" };
  return [previousStatus, nextStatus].every((status) =>
    status === "active" || (permissionForStatus[status] && can(actor, permissionForStatus[status])));
}

export function getProfileRoleForSave(actor, target, accessMode) {
  if (!isActiveProfileAdmin(actor)) return target?.role || "viewer";
  if (accessMode === "admin") return "admin";
  if (accessMode === "editor" && target?.role === "editor") return "editor";
  return "viewer";
}
