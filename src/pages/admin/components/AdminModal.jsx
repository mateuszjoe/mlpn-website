import React from "react";
import { X } from "lucide-react";

export default function AdminModal({ isOpen, onClose, title, children, darkMode, wide, xwide }) {
  if (!isOpen) return null;

  const bg = darkMode ? "bg-[#141828] border-white/10" : "bg-white border-gray-200";

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center pt-[10vh] px-4 bg-black/60" onClick={onClose}>
      <div
        onClick={e => e.stopPropagation()}
        className={`w-full ${xwide ? "max-w-6xl" : wide ? "max-w-2xl" : "max-w-lg"} rounded-2xl border p-6 shadow-2xl ${bg} max-h-[80vh] overflow-y-auto`}
      >
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-lg font-bold">{title}</h3>
          <button onClick={onClose} className="p-1 rounded-lg hover:bg-white/10 transition-colors">
            <X size={20} />
          </button>
        </div>
        {children}
      </div>
    </div>
  );
}
