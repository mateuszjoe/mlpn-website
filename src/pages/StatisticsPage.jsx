import React from "react";
import { topScorers, logoByTeam } from "../data/mockData";

function Logo({ name, darkMode }) {
  const src = logoByTeam[name];
  const bg = darkMode
    ? "bg-white/5 border-white/10"
    : "bg-black/5 border-black/10";
  return (
    <div
      className={`w-10 h-10 rounded-xl border ${bg} flex items-center justify-center overflow-hidden`}
    >
      {src ? (
        <img
          src={encodeURI(src)}
          alt={name}
          className="w-[78%] h-[78%] object-contain"
        />
      ) : (
        <div className="text-xs opacity-60 font-bold">?</div>
      )}
    </div>
  );
}

export default function StatisticsPage({ darkMode, activeLeague }) {
  const list = topScorers.filter((s) => s.league === activeLeague);
  const card = darkMode
    ? "bg-white/5 border-white/10"
    : "bg-white border-gray-200";

  return (
    <div className="space-y-4">
      <div>
        <div className="text-2xl font-bold">Zawodnicy</div>
        <div
          className={`text-sm ${darkMode ? "text-gray-400" : "text-gray-600"}`}
        >
          Klasyfikacja strzelców •{" "}
          {activeLeague === "1st"
            ? "I Liga"
            : activeLeague === "2nd"
            ? "II Liga"
            : "III Liga"}
        </div>
      </div>

      <div className={`rounded-2xl border overflow-hidden ${card}`}>
        <div
          className={`px-4 py-3 text-xs font-bold tracking-wide ${
            darkMode ? "text-gray-300 bg-black/20" : "text-gray-600 bg-gray-50"
          }`}
        >
          <div className="grid grid-cols-[60px_1fr_1fr_90px] gap-2">
            <div>#</div>
            <div>Zawodnik</div>
            <div>Drużyna</div>
            <div>Gole</div>
          </div>
        </div>

        {list.map((s, idx) => (
          <div
            key={s.id}
            className={`px-4 py-3 border-t ${
              darkMode ? "border-white/10" : "border-gray-100"
            }`}
          >
            <div className="grid grid-cols-[60px_1fr_1fr_90px] gap-2 items-center">
              <div className="font-bold">{idx + 1}</div>
              <div className="font-bold">{s.player}</div>
              <div className="flex items-center gap-3">
                <Logo name={s.team} darkMode={darkMode} />
                <div className="font-bold">{s.team}</div>
              </div>
              <div className="font-extrabold">{s.goals}</div>
            </div>
          </div>
        ))}

        {list.length === 0 && (
          <div
            className={`px-4 py-6 ${
              darkMode ? "text-gray-400" : "text-gray-600"
            }`}
          >
            Brak danych.
          </div>
        )}
      </div>
    </div>
  );
}
