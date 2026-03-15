import React, { useEffect, useMemo, useRef, useState } from "react";
import {
  ADMIN_PERMISSION_GROUPS,
  getGroupSelectionState,
  getPermissionValue,
} from "../../../lib/adminPermissions";
import { ChevronDown, ChevronRight } from "lucide-react";

function GroupCheckbox({ checked, partiallyChecked, onChange, disabled }) {
  const inputRef = useRef(null);

  useEffect(() => {
    if (inputRef.current) {
      inputRef.current.indeterminate = partiallyChecked;
    }
  }, [partiallyChecked]);

  return (
    <input
      ref={inputRef}
      type="checkbox"
      checked={checked}
      onChange={onChange}
      disabled={disabled}
      className="w-4 h-4 rounded border-gray-300"
    />
  );
}

export default function AdminPermissionTree({
  darkMode,
  permissions,
  onTogglePermission,
  onToggleGroup,
  disabled,
}) {
  const [openGroups, setOpenGroups] = useState(() =>
    ADMIN_PERMISSION_GROUPS.reduce((acc, group) => {
      acc[group.key] = true;
      return acc;
    }, {})
  );

  const cardClass = darkMode
    ? "border-white/10 bg-white/5"
    : "border-gray-200 bg-gray-50/80";
  const childClass = darkMode
    ? "border-white/10 bg-[#121826]"
    : "border-gray-200 bg-white";

  const groupStates = useMemo(
    () =>
      ADMIN_PERMISSION_GROUPS.reduce((acc, group) => {
        acc[group.key] = getGroupSelectionState(permissions, group.key);
        return acc;
      }, {}),
    [permissions]
  );

  return (
    <div className="space-y-3">
      {ADMIN_PERMISSION_GROUPS.map((group) => {
        const state = groupStates[group.key];
        const isOpen = openGroups[group.key];

        return (
          <div key={group.key} className={`rounded-2xl border ${cardClass}`}>
            <div className="flex items-center gap-3 px-4 py-3">
              <button
                type="button"
                onClick={() => setOpenGroups((current) => ({ ...current, [group.key]: !current[group.key] }))}
                className={`p-1 rounded-lg transition-colors ${darkMode ? "hover:bg-white/10 text-gray-300" : "hover:bg-gray-200 text-gray-600"}`}
              >
                {isOpen ? <ChevronDown size={16} /> : <ChevronRight size={16} />}
              </button>

              <GroupCheckbox
                checked={state.allChecked}
                partiallyChecked={state.partiallyChecked}
                onChange={(event) => onToggleGroup(group.key, event.target.checked)}
                disabled={disabled}
              />

              <div className="min-w-0 flex-1">
                <div className={`text-sm font-semibold ${darkMode ? "text-white" : "text-gray-900"}`}>
                  {group.label}
                </div>
                <div className={`text-xs ${darkMode ? "text-gray-400" : "text-gray-500"}`}>
                  {group.permissions.filter((permission) => getPermissionValue(permissions, permission.key)).length}/
                  {group.permissions.length} zaznaczone
                </div>
              </div>
            </div>

            {isOpen && (
              <div className="px-4 pb-4 space-y-2">
                {group.permissions.map((permission) => (
                  <label
                    key={permission.key}
                    className={`flex items-center gap-3 rounded-xl border px-3 py-2 text-sm ${childClass} ${disabled ? "opacity-60" : ""}`}
                  >
                    <input
                      type="checkbox"
                      checked={!!getPermissionValue(permissions, permission.key)}
                      onChange={(event) => onTogglePermission(permission.key, event.target.checked)}
                      disabled={disabled}
                      className="w-4 h-4 rounded border-gray-300"
                    />
                    <span className={darkMode ? "text-gray-200" : "text-gray-700"}>
                      {permission.label}
                    </span>
                  </label>
                ))}
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}
