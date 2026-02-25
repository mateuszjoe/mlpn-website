import React, { useState } from "react";
import { useAuth } from "../../contexts/AuthContext";
import { Lock, Mail, Eye, EyeOff } from "lucide-react";

export default function AdminLogin({ darkMode }) {
  const { signIn } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      await signIn(email, password);
    } catch (err) {
      setError("Bledny email lub haslo");
    } finally {
      setLoading(false);
    }
  };

  const card = darkMode ? "bg-[#141828] border-white/10" : "bg-white border-gray-200";
  const inputClass = darkMode
    ? "bg-white/5 border-white/10 text-white placeholder-gray-500"
    : "bg-white border-gray-300 text-gray-900 placeholder-gray-400";

  return (
    <div className="flex items-center justify-center min-h-[70vh] px-4">
      <div className={`w-full max-w-sm rounded-2xl border p-8 shadow-xl ${card}`}>
        <div className="text-center mb-6">
          <div className={`w-14 h-14 rounded-2xl mx-auto mb-3 flex items-center justify-center ${darkMode ? "bg-yellow-500/10" : "bg-yellow-50"}`}>
            <Lock size={28} className="text-yellow-500" />
          </div>
          <h2 className="text-xl font-bold">Panel Admina</h2>
          <p className={`text-sm mt-1 ${darkMode ? "text-gray-400" : "text-gray-500"}`}>Zaloguj sie aby kontynuowac</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-1">
            <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Email</label>
            <div className="relative">
              <Mail size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500" />
              <input
                type="email" value={email} onChange={e => setEmail(e.target.value)}
                placeholder="twoj@email.pl" required autoFocus
                className={`w-full pl-10 pr-3 py-2.5 rounded-xl border outline-none ${inputClass}`}
              />
            </div>
          </div>

          <div className="space-y-1">
            <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Haslo</label>
            <div className="relative">
              <Lock size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500" />
              <input
                type={showPassword ? "text" : "password"} value={password}
                onChange={e => setPassword(e.target.value)}
                placeholder="Twoje haslo" required
                className={`w-full pl-10 pr-10 py-2.5 rounded-xl border outline-none ${inputClass}`}
              />
              <button
                type="button" onClick={() => setShowPassword(v => !v)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-300"
              >
                {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
              </button>
            </div>
          </div>

          {error && (
            <div className="px-3 py-2 rounded-xl bg-red-500/10 border border-red-500/30 text-red-400 text-sm">
              {error}
            </div>
          )}

          <button
            type="submit" disabled={loading}
            className={`w-full py-2.5 rounded-xl font-medium transition-colors ${
              loading ? "opacity-50 cursor-not-allowed" : ""
            } bg-yellow-500 hover:bg-yellow-400 text-black`}
          >
            {loading ? "Logowanie..." : "Zaloguj sie"}
          </button>
        </form>
      </div>
    </div>
  );
}
