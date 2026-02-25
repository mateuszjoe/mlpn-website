import React from "react";

export default function TyperPage({ darkMode }) {
  const card = darkMode
    ? "bg-white/5 border-white/10"
    : "bg-white border-gray-200";
  return (
    <div className="space-y-4">
      <div className="text-2xl font-bold">Typer</div>
      <div className={`p-4 rounded-2xl border ${card}`}>
        <div className="font-bold mb-2">Nagroda: bon 30 zł do Jadłostacji</div>
        <div className={`${darkMode ? "text-gray-300" : "text-gray-600"}`}>
          Placeholder pod mechanikę typowania (formularz / komentarze /
          integracja).
        </div>
      </div>
    </div>
  );
}
