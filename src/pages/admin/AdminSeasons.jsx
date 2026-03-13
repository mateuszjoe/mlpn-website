import React, { useState, useEffect, useCallback } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminTable from "./components/AdminTable";
import AdminModal from "./components/AdminModal";
import AdminAlert from "./components/AdminAlert";
import { Plus, Settings2 } from "lucide-react";
import AdminConfirmDanger from "./components/AdminConfirmDanger";

export default function AdminSeasons({ darkMode }) {
  const [seasons, setSeasons] = useState([]);
  const [leagues, setLeagues] = useState([]);
  const [loading, setLoading] = useState(true);
  const [alert, setAlert] = useState({ type: null, message: null });
  const [showForm, setShowForm] = useState(false);
  const [showConfig, setShowConfig] = useState(null); // season_id for config modal
  const [seasonLeagues, setSeasonLeagues] = useState([]);
  const [form, setForm] = useState({
    year: new Date().getFullYear() + 1,
    name: "",
    status: "planned",
    is_current: false,
    start_date: "",
    end_date: "",
  });
  const [editId, setEditId] = useState(null);
  const [dangerTarget, setDangerTarget] = useState(null); // season to delete

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const loadData = useCallback(async () => {
    setLoading(true);
    const [{ data: s }, { data: l }] = await Promise.all([
      supabase.from("seasons").select("*").order("year", { ascending: false }),
      supabase.from("leagues").select("*").order("display_order"),
    ]);
    setSeasons(s || []);
    setLeagues(l || []);
    setLoading(false);
  }, []);

  useEffect(() => { loadData(); }, [loadData]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm(f => ({
      ...f,
      [name]: value,
      ...(name === "year" && !editId ? { name: `Sezon ${value}` } : {}),
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const payload = {
      year: parseInt(form.year),
      name: form.name || `Sezon ${form.year}`,
      status: form.status,
      is_current: form.is_current,
      start_date: form.start_date || null,
      end_date: form.end_date || null,
    };

    if (form.is_current) {
      await supabase.from("seasons").update({ is_current: false }).eq("is_current", true);
    }

    let result;
    if (editId) {
      result = await supabase.from("seasons").update(payload).eq("id", editId).select().single();
    } else {
      result = await supabase.from("seasons").insert(payload).select().single();
    }

    if (result.error) {
      setAlert({ type: "error", message: result.error.message });
      return;
    }

    // Auto-create season_leagues for new season
    if (!editId && leagues.length > 0) {
      const entries = leagues.map(l => ({
        season_id: result.data.id,
        league_id: l.id,
        points_win: 3,
        points_draw: 1,
        points_loss: 0,
        walkover_goals_winner: 3,
        walkover_goals_loser: 0,
        promotion_spots: l.code === "1st" ? 0 : 2,
        relegation_spots: l.code === "3rd" ? 0 : 2,
        yellow_card_suspension_threshold: 2,
      }));
      await supabase.from("season_leagues").insert(entries);
    }

    setAlert({ type: "success", message: editId ? "Sezon zaktualizowany" : "Sezon utworzony" });
    setShowForm(false);
    setEditId(null);
    resetForm();
    loadData();
  };

  const resetForm = () => {
    setForm({
      year: new Date().getFullYear() + 1,
      name: "",
      status: "planned",
      is_current: false,
      start_date: "",
      end_date: "",
    });
  };

  const handleEdit = (season) => {
    setForm({
      year: season.year,
      name: season.name,
      status: season.status,
      is_current: season.is_current,
      start_date: season.start_date || "",
      end_date: season.end_date || "",
    });
    setEditId(season.id);
    setShowForm(true);
  };

  const handleDelete = (season) => {
    setDangerTarget(season);
  };

  const executeDelete = async () => {
    if (!dangerTarget) return;
    const { error } = await supabase.from("seasons").delete().eq("id", dangerTarget.id);
    if (error) {
      setAlert({ type: "error", message: error.message });
    } else {
      setAlert({ type: "success", message: "Sezon usunięty" });
      loadData();
    }
    setDangerTarget(null);
  };

  const openConfig = async (seasonId) => {
    const { data } = await supabase
      .from("season_leagues")
      .select("*, leagues(code, name)")
      .eq("season_id", seasonId)
      .order("leagues(display_order)");
    setSeasonLeagues(data || []);
    setShowConfig(seasonId);
  };

  const updateSeasonLeague = async (id, field, value) => {
    await supabase.from("season_leagues").update({ [field]: parseInt(value) || 0 }).eq("id", id);
    setSeasonLeagues(prev => prev.map(sl => sl.id === id ? { ...sl, [field]: parseInt(value) || 0 } : sl));
  };

  const columns = [
    { key: "year", label: "Rok", sortable: true },
    { key: "name", label: "Nazwa", sortable: true },
    {
      key: "status", label: "Status", sortable: true,
      render: (v) => {
        const colors = { planned: "text-blue-400 bg-blue-500/10", active: "text-green-400 bg-green-500/10", completed: "text-gray-400 bg-gray-500/10" };
        const labels = { planned: "Planowany", active: "Aktywny", completed: "Zakonczony" };
        return <span className={`px-2 py-0.5 rounded-lg text-xs font-medium ${colors[v] || ""}`}>{labels[v] || v}</span>;
      }
    },
    {
      key: "is_current", label: "Biezacy",
      render: (v) => v ? <span className="text-green-400 font-bold">Tak</span> : <span className={textMuted}>—</span>
    },
    {
      key: "id", label: "Konfiguracja",
      render: (_, row) => (
        <button onClick={() => openConfig(row.id)} className="flex items-center gap-1 text-xs text-blue-400 hover:text-blue-300">
          <Settings2 size={14} /> Zasady lig
        </button>
      )
    },
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
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold">Sezony</h2>
          <p className={`text-sm ${textMuted}`}>{seasons.length} sezonow</p>
        </div>
        <button
          onClick={() => { resetForm(); setEditId(null); setShowForm(true); }}
          className="flex items-center gap-2 px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium hover:bg-yellow-400 transition-colors text-sm"
        >
          <Plus size={16} /> Nowy sezon
        </button>
      </div>

      <AdminAlert type={alert.type} message={alert.message} onClose={() => setAlert({ type: null, message: null })} />

      <div className={`rounded-2xl border overflow-hidden ${card}`}>
        <AdminTable
          columns={columns}
          rows={seasons}
          darkMode={darkMode}
          onEdit={handleEdit}
          onDelete={handleDelete}
          emptyMessage="Brak sezonow - dodaj pierwszy!"
        />
      </div>

      {/* Form modal */}
      <AdminModal isOpen={showForm} onClose={() => setShowForm(false)} title={editId ? "Edytuj sezon" : "Nowy sezon"} darkMode={darkMode}>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <AdminFormField label="Rok" name="year" type="number" value={form.year} onChange={handleChange} required darkMode={darkMode} min={2020} max={2040} />
            <AdminFormField label="Nazwa" name="name" value={form.name} onChange={handleChange} darkMode={darkMode} placeholder="Sezon 2026" />
          </div>
          <AdminFormField label="Status" name="status" type="select" value={form.status} onChange={handleChange} darkMode={darkMode}
            options={[
              { value: "planned", label: "Planowany" },
              { value: "active", label: "Aktywny" },
              { value: "completed", label: "Zakonczony" },
            ]}
          />
          <div className="grid grid-cols-2 gap-4">
            <AdminFormField label="Data startu" name="start_date" type="date" value={form.start_date} onChange={handleChange} darkMode={darkMode} />
            <AdminFormField label="Data konca" name="end_date" type="date" value={form.end_date} onChange={handleChange} darkMode={darkMode} />
          </div>
          <AdminFormField label="Biezacy sezon" name="is_current" type="checkbox" value={form.is_current} onChange={handleChange} darkMode={darkMode} />
          <div className="flex justify-end gap-3 pt-2">
            <button type="button" onClick={() => setShowForm(false)} className={`px-4 py-2 rounded-xl text-sm ${textMuted} hover:bg-white/5`}>Anuluj</button>
            <button type="submit" className="px-4 py-2 rounded-xl bg-yellow-500 text-black font-medium text-sm hover:bg-yellow-400">
              {editId ? "Zapisz" : "Utworz sezon"}
            </button>
          </div>
        </form>
      </AdminModal>

      {/* Danger confirm */}
      <AdminConfirmDanger
        isOpen={!!dangerTarget}
        onClose={() => setDangerTarget(null)}
        onConfirm={executeDelete}
        darkMode={darkMode}
        title={`Usunięcie sezonu ${dangerTarget?.name || ""}`}
        message="Ta operacja jest NIEODWRACALNA! Usuniesz sezon i WSZYSTKIE jego dane (mecze, tabele, statystyki). Wpisz haslo aby potwierdzic."
      />

      {/* Season leagues config modal */}
      <AdminModal isOpen={!!showConfig} onClose={() => setShowConfig(null)} title="Konfiguracja zasad lig" darkMode={darkMode} wide>
        <div className="space-y-4">
          {seasonLeagues.map(sl => (
            <div key={sl.id} className={`p-4 rounded-xl border ${card}`}>
              <h4 className="font-semibold mb-3">{sl.leagues?.name || "Liga"}</h4>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                <AdminFormField label="Pkt za wygrana" name="points_win" type="number" value={sl.points_win}
                  onChange={(e) => updateSeasonLeague(sl.id, "points_win", e.target.value)} darkMode={darkMode} />
                <AdminFormField label="Pkt za remis" name="points_draw" type="number" value={sl.points_draw}
                  onChange={(e) => updateSeasonLeague(sl.id, "points_draw", e.target.value)} darkMode={darkMode} />
                <AdminFormField label="Pkt za przegrana" name="points_loss" type="number" value={sl.points_loss}
                  onChange={(e) => updateSeasonLeague(sl.id, "points_loss", e.target.value)} darkMode={darkMode} />
                <AdminFormField label="Walkover (bramki zwycięzcy)" name="walkover_goals_winner" type="number" value={sl.walkover_goals_winner}
                  onChange={(e) => updateSeasonLeague(sl.id, "walkover_goals_winner", e.target.value)} darkMode={darkMode} />
                <AdminFormField label="Awanse" name="promotion_spots" type="number" value={sl.promotion_spots}
                  onChange={(e) => updateSeasonLeague(sl.id, "promotion_spots", e.target.value)} darkMode={darkMode} />
                <AdminFormField label="Spadki" name="relegation_spots" type="number" value={sl.relegation_spots}
                  onChange={(e) => updateSeasonLeague(sl.id, "relegation_spots", e.target.value)} darkMode={darkMode} />
                <AdminFormField label="Żółte do pauzy" name="yellow_card_suspension_threshold" type="number" value={sl.yellow_card_suspension_threshold}
                  onChange={(e) => updateSeasonLeague(sl.id, "yellow_card_suspension_threshold", e.target.value)} darkMode={darkMode} />
              </div>
            </div>
          ))}
          {seasonLeagues.length === 0 && <p className={textMuted}>Brak konfiguracji lig dla tego sezonu.</p>}
        </div>
      </AdminModal>
    </div>
  );
}
