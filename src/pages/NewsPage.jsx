import React from "react";

export default function NewsPage({ darkMode }) {
  const card = darkMode
    ? "bg-white/5 border-white/10"
    : "bg-white border-gray-200";
  return (
    <div className="space-y-4">
      <div className="text-2xl font-bold">Aktualności</div>
      <div className={`p-4 rounded-2xl border ${card}`}>
        <div className="font-bold mb-2">Tu będą newsy MLPN</div>
        <div className={`${darkMode ? "text-gray-300" : "text-gray-600"}`}>
          Na razie placeholder. Podpinasz później dane / CMS / ręczne wpisy.
        </div>
      </div>
    </div>
  );
}
