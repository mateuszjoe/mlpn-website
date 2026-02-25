import React from "react";
import { leagueTables, logoByTeam } from "../data/mockData";

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
          onError={(e) => (e.currentTarget.style.display = "none")}
        />
      ) : (
        <div className="text-xs opacity-60 font-bold">?</div>
      )}
    </div>
  );
}

function FormPill({ v }) {
  const cls =
    v === "W"
      ? "bg-green-500/20 text-green-300"
      : v === "R"
      ? "bg-yellow-500/20 text-yellow-300"
      : "bg-red-500/20 text-red-300";
  return (
    <span
      className={`w-6 h-6 rounded-md flex items-center justify-center text-xs font-bold ${cls}`}
    >
      {v}
    </span>
  );
}

export default function HomePage({ darkMode, activeLeague }) {
  // Jeśli home -> landing
  if (!activeLeague) {
    return (
      <div className="space-y-6">
        <div
          className={`p-6 rounded-2xl border ${
            darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200"
          }`}
        >
          <div className="text-xl font-bold mb-2">Witaj w MLPN</div>
          <div className={`${darkMode ? "text-gray-300" : "text-gray-600"}`}>
            Wybierz ligę u góry, żeby zobaczyć tabelę, terminarz, drużyny i
            statystyki.
          </div>
        </div>
      </div>
    );
  }

  const rows = leagueTables[activeLeague] || [];

  return (
    <div className="space-y-4">
      <div className="flex items-end justify-between">
        <div>
          <div className="text-2xl font-bold">
            {activeLeague === "1st"
              ? "I Liga"
              : activeLeague === "2nd"
              ? "II Liga"
              : "III Liga"}
          </div>
          <div
            className={`text-sm ${
              darkMode ? "text-gray-400" : "text-gray-600"
            }`}
          >
            Tabela
          </div>
        </div>
      </div>

      <div
        className={`rounded-2xl border overflow-hidden ${
          darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white"
        }`}
      >
        <div
          className={`px-4 py-3 text-xs font-bold tracking-wide ${
            darkMode ? "text-gray-300 bg-black/20" : "text-gray-600 bg-gray-50"
          }`}
        >
          <div className="grid grid-cols-[48px_1fr_60px_60px_60px_60px_90px_70px_180px] gap-2">
            <div>#</div>
            <div>Drużyna</div>
            <div>M</div>
            <div>W</div>
            <div>R</div>
            <div>P</div>
            <div>RÓŻ</div>
            <div>PKT</div>
            <div>OBECNA FORMA</div>
          </div>
        </div>

        {rows.map((r) => (
          <div
            key={r.team}
            className={`px-4 py-3 border-t ${
              darkMode
                ? "border-white/10 hover:bg-white/5"
                : "border-gray-100 hover:bg-gray-50"
            }`}
          >
            <div className="grid grid-cols-[48px_1fr_60px_60px_60px_60px_90px_70px_180px] gap-2 items-center">
              <div className="font-bold">{r.pos}</div>

              <div className="flex items-center gap-3">
                <Logo name={r.team} darkMode={darkMode} />
                <div className="font-bold">{r.team}</div>
              </div>

              <div>{r.m}</div>
              <div>{r.w}</div>
              <div>{r.r}</div>
              <div>{r.p}</div>
              <div
                className={`${darkMode ? "text-gray-300" : "text-gray-700"}`}
              >
                {r.roz}
              </div>
              <div className="font-extrabold">{r.pkt}</div>

              <div className="flex gap-2">
                {(r.form || []).slice(0, 5).map((v, i) => (
                  <FormPill key={i} v={v} />
                ))}
              </div>
            </div>
          </div>
        ))}
      </div>

      <div
        className={`text-xs ${darkMode ? "text-gray-400" : "text-gray-500"}`}
      >
        Jeśli któregoś herbu nie widać: nazwa pliku w <b>/public</b> musi
        zgadzać się 1:1 (wielkie litery + spacje).
      </div>
    </div>
  );
}
