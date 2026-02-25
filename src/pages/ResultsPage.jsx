import React from "react";
import { fixtures, results, logoByTeam } from "../data/mockData";

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

export default function ResultsPage({ darkMode, round, activeLeague }) {
  const fix = fixtures.filter(
    (f) => f.league === activeLeague && f.round === round
  );
  const res = results.filter(
    (r) => r.league === activeLeague && r.round === round
  );

  const card = darkMode
    ? "bg-white/5 border-white/10"
    : "bg-white border-gray-200";

  return (
    <div className="space-y-4">
      <div>
        <div className="text-2xl font-bold">Kalendarz</div>
        <div
          className={`text-sm ${darkMode ? "text-gray-400" : "text-gray-600"}`}
        >
          {activeLeague === "1st"
            ? "I Liga"
            : activeLeague === "2nd"
            ? "II Liga"
            : "III Liga"}{" "}
          • Kolejka {round}
        </div>
      </div>

      <div className={`p-4 rounded-2xl border ${card}`}>
        <div className="font-bold mb-3">Nadchodzące mecze</div>
        {fix.length === 0 ? (
          <div className={`${darkMode ? "text-gray-400" : "text-gray-600"}`}>
            Brak danych dla tej kolejki.
          </div>
        ) : (
          <div className="grid gap-3">
            {fix.map((m) => (
              <div
                key={m.id}
                className={`p-3 rounded-xl border ${
                  darkMode
                    ? "border-white/10 bg-black/10"
                    : "border-gray-200 bg-gray-50"
                }`}
              >
                <div className="flex items-center justify-between gap-3">
                  <div className="flex items-center gap-3">
                    <Logo name={m.home} darkMode={darkMode} />
                    <div className="font-bold">{m.home}</div>
                  </div>

                  <div
                    className={`px-3 py-1 rounded-lg text-sm font-bold ${
                      darkMode
                        ? "bg-white/5"
                        : "bg-white border border-gray-200"
                    }`}
                  >
                    {m.date} • {m.time}
                  </div>

                  <div className="flex items-center gap-3">
                    <div className="font-bold text-right">{m.away}</div>
                    <Logo name={m.away} darkMode={darkMode} />
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      <div className={`p-4 rounded-2xl border ${card}`}>
        <div className="font-bold mb-3">Wyniki</div>
        {res.length === 0 ? (
          <div className={`${darkMode ? "text-gray-400" : "text-gray-600"}`}>
            Brak wyników dla tej kolejki.
          </div>
        ) : (
          <div className="grid gap-3">
            {res.map((m) => (
              <div
                key={m.id}
                className={`p-3 rounded-xl border ${
                  darkMode
                    ? "border-white/10 bg-black/10"
                    : "border-gray-200 bg-gray-50"
                }`}
              >
                <div className="flex items-center justify-between gap-3">
                  <div className="flex items-center gap-3">
                    <Logo name={m.home} darkMode={darkMode} />
                    <div className="font-bold">{m.home}</div>
                  </div>

                  <div
                    className={`px-4 py-1 rounded-lg text-lg font-extrabold ${
                      darkMode
                        ? "bg-white/5"
                        : "bg-white border border-gray-200"
                    }`}
                  >
                    {m.homeGoals} : {m.awayGoals}
                  </div>

                  <div className="flex items-center gap-3">
                    <div className="font-bold text-right">{m.away}</div>
                    <Logo name={m.away} darkMode={darkMode} />
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
