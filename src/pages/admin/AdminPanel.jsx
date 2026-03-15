import React, { useState } from "react";
import { useAuth } from "../../contexts/AuthContext";
import AdminLogin from "./AdminLogin";
import AdminDashboard from "./AdminDashboard";
import AdminSeasons from "./AdminSeasons";
import AdminTeams from "./AdminTeams";
import AdminPlayers from "./AdminPlayers";
import AdminRosters from "./AdminRosters";
import AdminSchedule from "./AdminSchedule";
import AdminMatchResults from "./AdminMatchResults";
import AdminSeasonWizard from "./AdminSeasonWizard";
import AdminControlCenter from "./AdminControlCenter";
import AdminUsers from "./AdminUsers";
import AdminReferees from "./AdminReferees";
import {
  LayoutDashboard, Calendar, Shield, Users, UserCog, UserPlus,
  ListChecks, Trophy, LogOut, ArrowLeft, Menu, X, Wand2, SlidersHorizontal, Scale
} from "lucide-react";

export default function AdminPanel({ darkMode, goHome }) {
  const { user, isAdmin, signOut, loading } = useAuth();
  const [adminSection, setAdminSection] = useState("dashboard");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh] px-4">
        <div className={`max-w-sm text-center p-8 rounded-2xl border ${darkMode ? "bg-[#141828] border-white/10" : "bg-white border-gray-200"}`}>
          <div className="w-8 h-8 mx-auto border-2 border-yellow-500 border-t-transparent rounded-full animate-spin mb-4" />
          <p className={`text-sm ${darkMode ? "text-gray-400" : "text-gray-500"}`}>
            Sprawdzam logowanie i uprawnienia...
          </p>
        </div>
      </div>
    );
  }

  if (!user) {
    return <AdminLogin darkMode={darkMode} />;
  }

  if (!isAdmin) {
    return (
      <div className="flex items-center justify-center min-h-[60vh] px-4">
        <div className={`max-w-sm text-center p-8 rounded-2xl border ${darkMode ? "bg-[#141828] border-white/10" : "bg-white border-gray-200"}`}>
          <h2 className="text-xl font-bold mb-2">Brak dostępu</h2>
          <p className={`text-sm mb-4 ${darkMode ? "text-gray-400" : "text-gray-500"}`}>
            Twoje konto nie ma uprawnień administratora.
          </p>
          <div className="flex flex-col gap-2">
            <button
              onClick={goHome}
              className="px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors"
            >
              Wróć na stronę główną
            </button>
            <button
              onClick={() => {
                Object.keys(localStorage).filter(k => k.startsWith("sb-")).forEach(k => localStorage.removeItem(k));
                window.location.reload();
              }}
              className={`px-4 py-2 rounded-xl border text-sm font-medium transition-colors ${darkMode ? "border-white/10 text-gray-400 hover:text-white hover:bg-white/5" : "border-gray-200 text-gray-500 hover:text-gray-700 hover:bg-gray-50"}`}
            >
              Wyloguj się
            </button>
          </div>
        </div>
      </div>
    );
  }

  const adminMenu = [
    { id: "dashboard", label: "Pulpit", icon: <LayoutDashboard size={18} /> },
    { id: "wizard", label: "Generator", icon: <Wand2 size={18} /> },
    { id: "seasons", label: "Sezony", icon: <Calendar size={18} /> },
    { id: "teams", label: "Drużyny", icon: <Shield size={18} /> },
    { id: "players", label: "Zawodnicy", icon: <Users size={18} /> },
    { id: "rosters", label: "Kadry", icon: <UserCog size={18} /> },
    { id: "schedule", label: "Terminarz", icon: <ListChecks size={18} /> },
    { id: "results", label: "Wyniki", icon: <Trophy size={18} /> },
    { id: "referees", label: "Sędziowie", icon: <Scale size={18} /> },
    { id: "control-center", label: "Ustawienia", icon: <SlidersHorizontal size={18} /> },
    { id: "users", label: "Konta", icon: <UserPlus size={18} /> },
  ];

  const renderContent = () => {
    switch (adminSection) {
      case "wizard": return <AdminSeasonWizard darkMode={darkMode} />;
      case "seasons": return <AdminSeasons darkMode={darkMode} />;
      case "teams": return <AdminTeams darkMode={darkMode} />;
      case "players": return <AdminPlayers darkMode={darkMode} />;
      case "rosters": return <AdminRosters darkMode={darkMode} />;
      case "schedule": return <AdminSchedule darkMode={darkMode} />;
      case "results": return <AdminMatchResults darkMode={darkMode} />;
      case "referees": return <AdminReferees darkMode={darkMode} />;
      case "control-center": return <AdminControlCenter darkMode={darkMode} />;
      case "users": return <AdminUsers darkMode={darkMode} />;
      default: return <AdminDashboard darkMode={darkMode} setAdminSection={setAdminSection} />;
    }
  };

  const sidebarBg = darkMode
    ? "bg-[#0d1117] border-white/10"
    : "bg-gradient-to-b from-[#eef4ff] to-[#dfeaff] border-[#c7d7ef]";
  const menuItemBase = "flex items-center gap-3 w-full px-3 py-2.5 rounded-xl text-sm font-medium transition-colors";
  const menuItemActive = darkMode
    ? "bg-yellow-500/10 text-yellow-400"
    : "bg-yellow-50 text-yellow-700";
  const menuItemInactive = darkMode
    ? "text-gray-400 hover:text-white hover:bg-white/5"
    : "text-gray-600 hover:text-gray-900 hover:bg-gray-100";

  const handleSignOut = () => {
    Object.keys(localStorage).filter(k => k.startsWith("sb-")).forEach(k => localStorage.removeItem(k));
    window.location.reload();
  };

  const handleNavClick = (id) => {
    setAdminSection(id);
    setMobileMenuOpen(false);
  };

  return (
    <div className="flex min-h-[80vh]">
      {/* Mobile menu button */}
      <div className="md:hidden fixed bottom-4 right-4 z-40">
        <button
          onClick={() => setMobileMenuOpen(v => !v)}
          className="w-12 h-12 rounded-full bg-yellow-500 text-black flex items-center justify-center shadow-lg"
        >
          {mobileMenuOpen ? <X size={22} /> : <Menu size={22} />}
        </button>
      </div>

      {/* Mobile menu overlay */}
      {mobileMenuOpen && (
        <div className="md:hidden fixed inset-0 z-30 bg-black/60" onClick={() => setMobileMenuOpen(false)}>
          <div
            onClick={e => e.stopPropagation()}
            className={`absolute bottom-20 right-4 w-56 rounded-2xl border p-3 shadow-xl ${darkMode ? "bg-[#141828] border-white/10" : "bg-white border-gray-200"}`}
          >
            {adminMenu.map(item => (
              <button
                key={item.id}
                onClick={() => handleNavClick(item.id)}
                className={`${menuItemBase} ${adminSection === item.id ? menuItemActive : menuItemInactive}`}
              >
                {item.icon} {item.label}
              </button>
            ))}
            <hr className={`my-2 ${darkMode ? "border-white/10" : "border-gray-200"}`} />
            <button onClick={goHome} className={`${menuItemBase} ${menuItemInactive}`}>
              <ArrowLeft size={18} /> Wróć do strony
            </button>
            <button onClick={handleSignOut} className={`${menuItemBase} text-red-400 hover:bg-red-500/10`}>
              <LogOut size={18} /> Wyloguj
            </button>
          </div>
        </div>
      )}

      {/* Desktop sidebar */}
      <div className={`hidden md:flex flex-col w-52 shrink-0 border-r p-3 ${sidebarBg}`}>
        <button onClick={goHome} className={`${menuItemBase} ${menuItemInactive} mb-2`}>
          <ArrowLeft size={18} /> Wróć do strony
        </button>

        <hr className={`my-2 ${darkMode ? "border-white/10" : "border-gray-200"}`} />

        <nav className="flex-1 space-y-1">
          {adminMenu.map(item => (
            <button
              key={item.id}
              onClick={() => handleNavClick(item.id)}
              className={`${menuItemBase} ${adminSection === item.id ? menuItemActive : menuItemInactive}`}
            >
              {item.icon} {item.label}
            </button>
          ))}
        </nav>

        <hr className={`my-2 ${darkMode ? "border-white/10" : "border-gray-200"}`} />

        <button onClick={handleSignOut} className={`${menuItemBase} text-red-400 hover:bg-red-500/10`}>
          <LogOut size={18} /> Wyloguj
        </button>
      </div>

      {/* Content */}
      <div className="flex-1 p-4 md:p-6 min-w-0">
        {renderContent()}
      </div>
    </div>
  );
}
