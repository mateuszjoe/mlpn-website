import React, { useEffect, useState } from "react";
import { useAuth } from "../../contexts/AuthContext";
import { ADMIN_SECTION_PERMISSIONS } from "../../lib/adminPermissions";
import AdminLogin from "./AdminLogin";
import AdminDashboard from "./AdminDashboard";
import AdminSeasons from "./AdminSeasons";
import AdminTeams from "./AdminTeams";
import AdminPlayers from "./AdminPlayers";
import AdminRosters from "./AdminRosters";
import AdminSchedule from "./AdminSchedule";
import AdminMatchResults from "./AdminMatchResults";
import AdminNews from "./AdminNews";
import AdminSeasonWizard from "./AdminSeasonWizard";
import AdminControlCenter from "./AdminControlCenter";
import AdminUsers from "./AdminUsers";
import AdminReferees from "./AdminReferees";
import AdminSponsors from "./AdminSponsors";
import {
  LayoutDashboard,
  Calendar,
  Shield,
  Users,
  UserCog,
  UserPlus,
  ListChecks,
  Trophy,
  LogOut,
  ArrowLeft,
  Menu,
  X,
  Wand2,
  SlidersHorizontal,
  Scale,
  Newspaper,
  Handshake,
} from "lucide-react";

const ADMIN_MENU_ITEMS = [
  { id: "dashboard", label: "Pulpit", icon: <LayoutDashboard size={18} /> },
  { id: "wizard", label: "Generator", icon: <Wand2 size={18} /> },
  { id: "seasons", label: "Sezony", icon: <Calendar size={18} /> },
  { id: "teams", label: "Druzyny", icon: <Shield size={18} /> },
  { id: "players", label: "Zawodnicy", icon: <Users size={18} /> },
  { id: "rosters", label: "Kadry", icon: <UserCog size={18} /> },
  { id: "schedule", label: "Terminarz", icon: <ListChecks size={18} /> },
  { id: "results", label: "Wyniki", icon: <Trophy size={18} /> },
  { id: "news", label: "Aktualności", icon: <Newspaper size={18} /> },
  { id: "sponsors", label: "Sponsorzy", icon: <Handshake size={18} /> },
  { id: "referees", label: "Sedziowie", icon: <Scale size={18} /> },
  { id: "control-center", label: "Ustawienia", icon: <SlidersHorizontal size={18} /> },
  { id: "users", label: "Konta", icon: <UserPlus size={18} /> },
];

export default function AdminPanel({ darkMode, goHome }) {
  const { user, isAdmin, hasAdminAccess, accountStatus, canAny, signOut, loading } = useAuth();
  const [adminSection, setAdminSection] = useState("dashboard");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const adminMenu = ADMIN_MENU_ITEMS.filter((item) => {
    if (item.id === "dashboard") return true;
    return isAdmin || canAny(ADMIN_SECTION_PERMISSIONS[item.id] || []);
  });

  useEffect(() => {
    if (!adminMenu.length) return;
    const isCurrentSectionAvailable = adminMenu.some((item) => item.id === adminSection);
    if (!isCurrentSectionAvailable) {
      setAdminSection(adminMenu[0].id);
    }
  }, [adminMenu, adminSection]);

  if (!user) {
    return <AdminLogin darkMode={darkMode} />;
  }

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

  if (!hasAdminAccess) {
    const blockedMessage =
      accountStatus === "suspended"
        ? "To konto jest zawieszone. Przywroc dostep w ustawieniach uzytkownikow."
        : accountStatus === "banned"
        ? "To konto jest zablokowane i nie moze korzystac z panelu."
        : "To konto nie ma przydzielonych uprawnien do panelu.";

    return (
      <div className="flex items-center justify-center min-h-[60vh] px-4">
        <div className={`max-w-sm text-center p-8 rounded-2xl border ${darkMode ? "bg-[#141828] border-white/10" : "bg-white border-gray-200"}`}>
          <h2 className="text-xl font-bold mb-2">Brak dostepu</h2>
          <p className={`text-sm mb-4 ${darkMode ? "text-gray-400" : "text-gray-500"}`}>
            {blockedMessage}
          </p>
          <div className="flex flex-col gap-2">
            <button
              onClick={goHome}
              className="px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors"
            >
              Wroc na strone glowna
            </button>
            <button
              onClick={signOut}
              className={`px-4 py-2 rounded-xl border text-sm font-medium transition-colors ${darkMode ? "border-white/10 text-gray-400 hover:text-white hover:bg-white/5" : "border-gray-200 text-gray-500 hover:text-gray-700 hover:bg-gray-50"}`}
            >
              Wyloguj sie
            </button>
          </div>
        </div>
      </div>
    );
  }

  const renderContent = () => {
    switch (adminSection) {
      case "wizard":
        return <AdminSeasonWizard darkMode={darkMode} />;
      case "seasons":
        return <AdminSeasons darkMode={darkMode} />;
      case "teams":
        return <AdminTeams darkMode={darkMode} />;
      case "players":
        return <AdminPlayers darkMode={darkMode} />;
      case "rosters":
        return <AdminRosters darkMode={darkMode} />;
      case "schedule":
        return <AdminSchedule darkMode={darkMode} />;
      case "results":
        return <AdminMatchResults darkMode={darkMode} />;
      case "news":
        return <AdminNews darkMode={darkMode} />;
      case "sponsors":
        return <AdminSponsors darkMode={darkMode} />;
      case "referees":
        return <AdminReferees darkMode={darkMode} />;
      case "control-center":
        return <AdminControlCenter darkMode={darkMode} />;
      case "users":
        return <AdminUsers darkMode={darkMode} />;
      default:
        return <AdminDashboard darkMode={darkMode} setAdminSection={setAdminSection} />;
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
  const currentAdminLabel = adminMenu.find((item) => item.id === adminSection)?.label || "Pulpit";

  const handleSignOut = async () => {
    setMobileMenuOpen(false);
    await signOut();
  };

  const handleNavClick = (id) => {
    setAdminSection(id);
    setMobileMenuOpen(false);
  };

  return (
    <div className="flex min-h-[80vh]">
      {mobileMenuOpen && (
        <div className="md:hidden fixed inset-0 z-40 bg-black/60" onClick={() => setMobileMenuOpen(false)}>
          <div
            onClick={(event) => event.stopPropagation()}
            className={`absolute inset-y-0 left-0 w-[86vw] max-w-[320px] border-r p-4 shadow-2xl flex flex-col ${sidebarBg}`}
          >
            <div className="flex items-center justify-between gap-3 mb-4">
              <div>
                <div className={`text-[11px] uppercase tracking-[0.16em] ${darkMode ? "text-gray-500" : "text-gray-500"}`}>
                  Panel admina
                </div>
                <div className="font-semibold text-base">{currentAdminLabel}</div>
              </div>
              <button
                onClick={() => setMobileMenuOpen(false)}
                className={`w-11 h-11 rounded-2xl flex items-center justify-center ${darkMode ? "bg-white/5 text-white" : "bg-white text-gray-700"}`}
              >
                <X size={20} />
              </button>
            </div>

            <nav className="flex-1 overflow-y-auto space-y-1">
              {adminMenu.map((item) => (
                <button
                  key={item.id}
                  onClick={() => handleNavClick(item.id)}
                  className={`${menuItemBase} ${adminSection === item.id ? menuItemActive : menuItemInactive}`}
                >
                  {item.icon} {item.label}
                </button>
              ))}
            </nav>

            <div className={`pt-4 mt-4 border-t space-y-1 ${darkMode ? "border-white/10" : "border-gray-200"}`}>
              <button onClick={goHome} className={`${menuItemBase} ${menuItemInactive}`}>
                <ArrowLeft size={18} /> Wroc do strony
              </button>
              <button onClick={handleSignOut} className={`${menuItemBase} text-red-400 hover:bg-red-500/10`}>
                <LogOut size={18} /> Wyloguj
              </button>
            </div>
          </div>
        </div>
      )}

      <div className={`hidden md:flex flex-col w-52 shrink-0 border-r p-3 ${sidebarBg}`}>
        <button onClick={goHome} className={`${menuItemBase} ${menuItemInactive} mb-2`}>
          <ArrowLeft size={18} /> Wroc do strony
        </button>

        <hr className={`my-2 ${darkMode ? "border-white/10" : "border-gray-200"}`} />

        <nav className="flex-1 space-y-1">
          {adminMenu.map((item) => (
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

      <div className="flex-1 p-3 md:p-6 min-w-0">
        <div className="md:hidden sticky top-[76px] z-20 mb-4">
          <div className={`rounded-2xl border px-3 py-3 flex items-center gap-3 shadow-sm ${sidebarBg}`}>
            <button
              onClick={goHome}
              className={`w-11 h-11 rounded-2xl flex items-center justify-center ${darkMode ? "bg-white/5 text-white" : "bg-white text-gray-700"}`}
              title="Wroc do strony"
            >
              <ArrowLeft size={18} />
            </button>

            <div className="min-w-0 flex-1">
              <div className={`text-[11px] uppercase tracking-[0.16em] ${darkMode ? "text-gray-500" : "text-gray-500"}`}>
                Panel admina
              </div>
              <div className="font-semibold truncate">{currentAdminLabel}</div>
            </div>

            <button
              onClick={() => setMobileMenuOpen(true)}
              className="w-11 h-11 rounded-2xl bg-yellow-500 text-black flex items-center justify-center shadow-sm"
              title="Menu panelu"
            >
              <Menu size={20} />
            </button>
          </div>
        </div>

        {renderContent()}
      </div>
    </div>
  );
}
