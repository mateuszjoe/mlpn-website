import React from "react";
import { teams, logoByTeam } from "../data/mockData";

function Logo({ name, darkMode }) {
  const src = logoByTeam[name];
  const bg = darkMode
    ? "bg-white/5 border-white/10"
    : "bg-black/5 border-black/10";
  return (
    <div
      className={`w-12 h-12 rounded-2xl border ${bg} flex items-center justify-center overflow-hidden`}
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

export default function TeamsPage({ darkMode, activeLeague }) {
  const list = teams.filter((t) => t.league === activeLeague);
  const card = darkMode
    ? "bg-white/5 border-white/10"
    : "bg-white border-gray-200";

  return (
    <div className="space-y-4">
      <div>
        <div className="text-2xl font-bold">Drużyny</div>
        <div
          className={`text-sm ${darkMode ? "text-gray-400" : "text-gray-600"}`}
        >
          {activeLeague === "1st"
            ? "I Liga"
            : activeLeague === "2nd"
            ? "II Liga"
            : "III Liga"}
        </div>
      </div>

      <div className={`p-4 rounded-2xl border ${card}`}>
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-3">
          {list.map((t) => (
            <div
              key={t.id}
              className={`p-3 rounded-2xl border flex items-center gap-3 ${
                darkMode
                  ? "border-white/10 bg-black/10 hover:bg-white/5"
                  : "border-gray-200 bg-gray-50 hover:bg-white"
              }`}
            >
              <Logo name={t.name} darkMode={darkMode} />
              <div className="font-bold">{t.name}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
