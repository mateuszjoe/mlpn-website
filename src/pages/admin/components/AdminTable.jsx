import React, { useState } from "react";
import { ChevronUp, ChevronDown, Pencil, Trash2 } from "lucide-react";

export default function AdminTable({ columns, rows, darkMode, onEdit, onDelete, emptyMessage = "Brak danych" }) {
  const [sortKey, setSortKey] = useState(null);
  const [sortDir, setSortDir] = useState("asc");

  const headerBg = darkMode ? "bg-white/5" : "bg-gray-50";
  const rowBg = darkMode ? "hover:bg-white/5" : "hover:bg-gray-50";
  const borderColor = darkMode ? "border-white/10" : "border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const handleSort = (key) => {
    if (sortKey === key) {
      setSortDir(d => d === "asc" ? "desc" : "asc");
    } else {
      setSortKey(key);
      setSortDir("asc");
    }
  };

  const sorted = [...rows].sort((a, b) => {
    if (!sortKey) return 0;
    const av = a[sortKey], bv = b[sortKey];
    if (av == null) return 1;
    if (bv == null) return -1;
    const cmp = typeof av === "number" ? av - bv : String(av).localeCompare(String(bv), "pl");
    return sortDir === "asc" ? cmp : -cmp;
  });

  if (rows.length === 0) {
    return <p className={`text-center py-8 ${textMuted}`}>{emptyMessage}</p>;
  }

  return (
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className={headerBg}>
            {columns.map(col => (
              <th
                key={col.key}
                onClick={col.sortable ? () => handleSort(col.key) : undefined}
                className={`px-3 py-2 text-left font-medium ${textMuted} border-b ${borderColor} ${col.sortable ? "cursor-pointer select-none" : ""}`}
              >
                <span className="flex items-center gap-1">
                  {col.label}
                  {col.sortable && sortKey === col.key && (
                    sortDir === "asc" ? <ChevronUp size={14} /> : <ChevronDown size={14} />
                  )}
                </span>
              </th>
            ))}
            {(onEdit || onDelete) && (
              <th className={`px-3 py-2 text-right font-medium ${textMuted} border-b ${borderColor}`}>Akcje</th>
            )}
          </tr>
        </thead>
        <tbody>
          {sorted.map((row, i) => (
            <tr key={row.id || i} className={`border-b ${borderColor} ${rowBg} transition-colors`}>
              {columns.map(col => (
                <td key={col.key} className="px-3 py-2">
                  {col.render ? col.render(row[col.key], row) : (row[col.key] ?? "—")}
                </td>
              ))}
              {(onEdit || onDelete) && (
                <td className="px-3 py-2 text-right">
                  <div className="flex items-center justify-end gap-1">
                    {onEdit && (
                      <button onClick={() => onEdit(row)} className="p-1.5 rounded-lg hover:bg-blue-500/20 text-blue-400" title="Edytuj">
                        <Pencil size={15} />
                      </button>
                    )}
                    {onDelete && (
                      <button onClick={() => onDelete(row)} className="p-1.5 rounded-lg hover:bg-red-500/20 text-red-400" title="Usuń">
                        <Trash2 size={15} />
                      </button>
                    )}
                  </div>
                </td>
              )}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
