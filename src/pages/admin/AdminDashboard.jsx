import React, { useState, useEffect } from "react";
import { supabase } from "../../lib/supabase";
import { Users, Shield, Trophy, Calendar, AlertCircle } from "lucide-react";

export default function AdminDashboard({ darkMode, setAdminSection }) {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadStats();
  }, []);

  async function loadStats() {
    try {
      const [teams, players, matches, seasons, news, freeAgents, messages] = await Promise.all([
        supabase.from("teams").select("*", { count: "exact", head: true }).eq("is_active", true),
        supabase.from("players").select("*", { count: "exact", head: true }).eq("is_active", true),
        supabase.from("matches").select("*", { count: "exact", head: true }),
        supabase.from("seasons").select("*").order("year", { ascending: false }),
        supabase.from("news").select("*", { count: "exact", head: true }),
        supabase.from("free_agents").select("*", { count: "exact", head: true }).eq("is_approved", false).eq("is_active", true),
        supabase.from("contact_messages").select("*", { count: "exact", head: true }).eq("is_read", false),
      ]);

      setStats({
        teamCount: teams.count || 0,
        playerCount: players.count || 0,
        matchCount: matches.count || 0,
        seasonCount: seasons.data?.length || 0,
        currentSeason: seasons.data?.find(s => s.is_current),
        newsCount: news.count || 0,
        pendingFreeAgents: freeAgents.count || 0,
        unreadMessages: messages.count || 0,
      });
    } catch (err) {
      console.error("Blad ladowania statystyk:", err);
    } finally {
      setLoading(false);
    }
  }

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const statCards = [
    { label: "Drużyny", value: stats?.teamCount, icon: <Shield size={24} />, color: "text-blue-400 bg-blue-500/10", section: "teams" },
    { label: "Zawodnicy", value: stats?.playerCount, icon: <Users size={24} />, color: "text-green-400 bg-green-500/10", section: "players" },
    { label: "Mecze", value: stats?.matchCount, icon: <Trophy size={24} />, color: "text-yellow-400 bg-yellow-500/10", section: "results" },
    { label: "Sezony", value: stats?.seasonCount, icon: <Calendar size={24} />, color: "text-purple-400 bg-purple-500/10", section: "seasons" },
  ];

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-2 border-yellow-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold">Panel Admina</h2>
        <p className={`text-sm mt-1 ${textMuted}`}>
          {stats?.currentSeason
            ? `Aktualny sezon: ${stats.currentSeason.name} (${stats.currentSeason.status})`
            : "Brak aktywnego sezonu"}
        </p>
      </div>

      {/* Karty statystyk */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        {statCards.map(s => (
          <button
            key={s.label}
            onClick={() => setAdminSection(s.section)}
            className={`rounded-2xl border p-4 text-left transition-all hover:scale-[1.02] ${card}`}
          >
            <div className={`w-10 h-10 rounded-xl flex items-center justify-center mb-3 ${s.color}`}>
              {s.icon}
            </div>
            <p className="text-2xl font-bold">{s.value ?? "—"}</p>
            <p className={`text-sm ${textMuted}`}>{s.label}</p>
          </button>
        ))}
      </div>

      {/* Powiadomienia */}
      {(stats?.pendingFreeAgents > 0 || stats?.unreadMessages > 0) && (
        <div className={`rounded-2xl border p-4 ${card}`}>
          <h3 className="font-semibold mb-3 flex items-center gap-2">
            <AlertCircle size={18} className="text-yellow-400" /> Wymagaja uwagi
          </h3>
          <div className="space-y-2 text-sm">
            {stats.pendingFreeAgents > 0 && (
              <p>{stats.pendingFreeAgents} wolnych zawodnikow czeka na zatwierdzenie</p>
            )}
            {stats.unreadMessages > 0 && (
              <p>{stats.unreadMessages} nieprzeczytanych wiadomosci kontaktowych</p>
            )}
          </div>
        </div>
      )}

      {/* Szybkie akcje */}
      <div className={`rounded-2xl border p-4 ${card}`}>
        <h3 className="font-semibold mb-3">Szybkie akcje</h3>
        <div className="flex flex-wrap gap-2">
          <button onClick={() => setAdminSection("seasons")} className="px-4 py-2 rounded-xl bg-yellow-500/10 text-yellow-400 hover:bg-yellow-500/20 text-sm font-medium transition-colors">
            + Nowy sezon
          </button>
          <button onClick={() => setAdminSection("teams")} className="px-4 py-2 rounded-xl bg-blue-500/10 text-blue-400 hover:bg-blue-500/20 text-sm font-medium transition-colors">
            + Dodaj druzyne
          </button>
          <button onClick={() => setAdminSection("players")} className="px-4 py-2 rounded-xl bg-green-500/10 text-green-400 hover:bg-green-500/20 text-sm font-medium transition-colors">
            + Dodaj zawodnika
          </button>
        </div>
      </div>
    </div>
  );
}
