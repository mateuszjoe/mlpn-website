import React, { useEffect } from "react";
import { CheckCircle, AlertCircle, X } from "lucide-react";

export default function AdminAlert({ type, message, onClose }) {
  useEffect(() => {
    if (message) {
      const timer = setTimeout(onClose, 5000);
      return () => clearTimeout(timer);
    }
  }, [message, onClose]);

  if (!message) return null;

  const isSuccess = type === "success";
  const isWarning = type === "warning";
  const bg = isSuccess
    ? "bg-green-600 border-green-500 text-white"
    : isWarning
      ? "bg-yellow-500 border-yellow-400 text-black"
      : "bg-red-600 border-red-500 text-white";

  return (
    <div className={`fixed bottom-6 right-6 z-[9999] max-w-md shadow-2xl flex items-center gap-3 px-5 py-4 rounded-xl border ${bg} animate-slide-in-right`}>
      {isSuccess ? <CheckCircle size={20} /> : <AlertCircle size={20} />}
      <span className="flex-1 text-sm font-medium">{message}</span>
      <button onClick={onClose} className="p-1 rounded hover:bg-white/20 transition-colors">
        <X size={16} />
      </button>
    </div>
  );
}
