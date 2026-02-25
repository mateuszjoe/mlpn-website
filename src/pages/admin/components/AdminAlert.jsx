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
  const bg = isSuccess ? "bg-green-500/10 border-green-500/30 text-green-400" : "bg-red-500/10 border-red-500/30 text-red-400";

  return (
    <div className={`flex items-center gap-3 px-4 py-3 rounded-xl border ${bg}`}>
      {isSuccess ? <CheckCircle size={18} /> : <AlertCircle size={18} />}
      <span className="flex-1 text-sm">{message}</span>
      <button onClick={onClose} className="p-1 rounded hover:bg-white/10">
        <X size={16} />
      </button>
    </div>
  );
}
