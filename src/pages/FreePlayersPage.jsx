import React from "react";

export default function FreePlayersPage({ darkMode }) {
  const card = darkMode
    ? "bg-white/5 border-white/10"
    : "bg-white border-gray-200";
  return (
    <div className="space-y-4">
      <div className="text-2xl font-bold">Wolni zawodnicy</div>
      <div className={`p-4 rounded-2xl border ${card}`}>
        <div className="font-bold mb-2">Lista wolnych graczy</div>
        <div className={`${darkMode ? "text-gray-300" : "text-gray-600"}`}>
          Placeholder: docelowo formularz + lista + kontakt.
        </div>
      </div>
    </div>
  );
}
