import React, { useCallback, useEffect, useMemo, useState } from "react";
import { supabase } from "../../lib/supabase";
import AdminFormField from "./components/AdminFormField";
import AdminAlert from "./components/AdminAlert";
import AdminMatchGalleryManager from "./components/AdminMatchGalleryManager";
import { Check, ChevronDown, ChevronUp, Loader2, Save, Users } from "lucide-react";

const EMPTY_TEAM_SELECTION = { home: [], away: [] };

function createEmptyPlayerStats() {
  return {
    goals: "",
    assists: "",
    yellow: "",
    red: "",
  };
}

function uniqueIds(ids) {
  return Array.from(new Set((ids || []).filter(Boolean)));
}

function parseCount(value) {
  const parsed = Number.parseInt(value, 10);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
}

function parseScoreValue(value) {
  if (value === "" || value === null || value === undefined) return null;
  const parsed = Number.parseInt(value, 10);
  return Number.isFinite(parsed) ? Math.max(parsed, 0) : null;
}

function normalizeCounterInput(value, max) {
  if (value === "" || value === null || value === undefined) return "";
  const parsed = Number.parseInt(value, 10);
  if (!Number.isFinite(parsed)) return "";
  return String(Math.max(0, Math.min(parsed, max)));
}

function sortRosterRows(rows) {
  return (rows || [])
    .slice()
    .sort((a, b) => {
      const numberA = a.shirtNumber ?? Number.MAX_SAFE_INTEGER;
      const numberB = b.shirtNumber ?? Number.MAX_SAFE_INTEGER;
      if (numberA !== numberB) return numberA - numberB;
      return String(a.name || "").localeCompare(String(b.name || ""), "pl");
    });
}

function sortPlayerIdsByRoster(ids, rosterRows) {
  const order = new Map((rosterRows || []).map((player, index) => [player.id, index]));
  return uniqueIds(ids).sort((a, b) => {
    const orderA = order.has(a) ? order.get(a) : Number.MAX_SAFE_INTEGER;
    const orderB = order.has(b) ? order.get(b) : Number.MAX_SAFE_INTEGER;
    if (orderA !== orderB) return orderA - orderB;
    return String(a).localeCompare(String(b));
  });
}

function buildRosterRows(teamPlayers, lineupRows, eventRows, teamId) {
  const byId = new Map();

  for (const row of teamPlayers || []) {
    const player = row.players;
    if (!player?.id) continue;
    byId.set(player.id, {
      id: player.id,
      name: player.display_name || "Bez nazwy",
      pos: player.position || "",
      shirtNumber: row.shirt_number ?? null,
      isCaptain: row.is_captain || false,
    });
  }

  for (const row of (lineupRows || []).filter((item) => item.team_id === teamId)) {
    const player = row.players;
    if (!row.player_id) continue;
    const current = byId.get(row.player_id);
    byId.set(row.player_id, {
      id: row.player_id,
      name: player?.display_name || current?.name || "Bez nazwy",
      pos: row.position_played || player?.position || current?.pos || "",
      shirtNumber: row.shirt_number ?? current?.shirtNumber ?? null,
      isCaptain: current?.isCaptain || false,
    });
  }

  for (const row of (eventRows || []).filter((item) => item.team_id === teamId)) {
    const scorer = row.player;
    if (row.player_id && scorer && !byId.has(row.player_id)) {
      byId.set(row.player_id, {
        id: row.player_id,
        name: scorer.display_name || "Bez nazwy",
        pos: scorer.position || "",
        shirtNumber: null,
        isCaptain: false,
      });
    }

    const assist = row.assist;
    if (row.assist_player_id && assist && !byId.has(row.assist_player_id)) {
      byId.set(row.assist_player_id, {
        id: row.assist_player_id,
        name: assist.display_name || "Bez nazwy",
        pos: assist.position || "",
        shirtNumber: null,
        isCaptain: false,
      });
    }
  }

  return sortRosterRows(Array.from(byId.values()));
}

function buildSelectedIds(lineupRows, eventRows, teamId) {
  const ids = [];

  for (const row of lineupRows || []) {
    if (row.team_id === teamId && row.player_id) ids.push(row.player_id);
  }

  for (const row of eventRows || []) {
    if (row.team_id !== teamId) continue;
    if (row.player_id) ids.push(row.player_id);
    if (row.assist_player_id) ids.push(row.assist_player_id);
  }

  return uniqueIds(ids);
}

function buildPlayerStatsFromEvents(eventRows) {
  const counts = {};

  const ensurePlayer = (playerId) => {
    if (!playerId) return null;
    if (!counts[playerId]) {
      counts[playerId] = { goals: 0, assists: 0, yellow: 0, red: 0 };
    }
    return counts[playerId];
  };

  for (const event of eventRows || []) {
    const playerStats = ensurePlayer(event.player_id);
    if (playerStats) {
      if (event.event_type === "GOAL") playerStats.goals += 1;
      if (event.event_type === "YELLOW_CARD") playerStats.yellow += 1;
      if (event.event_type === "RED_CARD") playerStats.red += 1;
    }

    if (event.event_type === "GOAL" && event.assist_player_id) {
      const assistStats = ensurePlayer(event.assist_player_id);
      if (assistStats) assistStats.assists += 1;
    }
  }

  const mapped = {};
  for (const [playerId, stats] of Object.entries(counts)) {
    mapped[playerId] = {
      goals: stats.goals > 0 ? String(stats.goals) : "",
      assists: stats.assists > 0 ? String(stats.assists) : "",
      yellow: stats.yellow > 0 ? String(stats.yellow) : "",
      red: stats.red > 0 ? String(stats.red) : "",
    };
  }
  return mapped;
}

function teamTotals(playerIds, playerStatsForm) {
  return playerIds.reduce(
    (totals, playerId) => {
      const stats = playerStatsForm[playerId] || createEmptyPlayerStats();
      totals.goals += parseCount(stats.goals);
      totals.assists += parseCount(stats.assists);
      totals.yellow += parseCount(stats.yellow);
      totals.red += parseCount(stats.red);
      return totals;
    },
    { goals: 0, assists: 0, yellow: 0, red: 0 }
  );
}

function buildGoalEvents(matchId, teamId, playerIds, playerStatsForm, teamLabel) {
  const goals = [];
  const assists = [];

  for (const playerId of playerIds) {
    const stats = playerStatsForm[playerId] || createEmptyPlayerStats();
    const goalCount = parseCount(stats.goals);
    const assistCount = parseCount(stats.assists);

    for (let index = 0; index < goalCount; index += 1) {
      goals.push({
        match_id: matchId,
        event_type: "GOAL",
        team_id: teamId,
        player_id: playerId,
        assist_player_id: null,
        minute: null,
        is_penalty: false,
        is_own_goal: false,
        notes: null,
      });
    }

    for (let index = 0; index < assistCount; index += 1) {
      assists.push(playerId);
    }
  }

  if (assists.length > goals.length) {
    throw new Error(`Za duzo asyst w druzynie ${teamLabel}. Asyst nie moze byc wiecej niz goli.`);
  }

  for (const assistPlayerId of assists) {
    const targetGoal = goals.find((goal) => !goal.assist_player_id && goal.player_id !== assistPlayerId);
    if (!targetGoal) {
      throw new Error(`Nie da sie przypisac wszystkich asyst w druzynie ${teamLabel} bez asysty do wlasnego gola.`);
    }
    targetGoal.assist_player_id = assistPlayerId;
  }

  return goals;
}

function buildCardEvents(matchId, teamId, playerIds, playerStatsForm) {
  const events = [];

  for (const playerId of playerIds) {
    const stats = playerStatsForm[playerId] || createEmptyPlayerStats();
    const yellowCount = parseCount(stats.yellow);
    const redCount = parseCount(stats.red);

    for (let index = 0; index < yellowCount; index += 1) {
      events.push({
        match_id: matchId,
        event_type: "YELLOW_CARD",
        team_id: teamId,
        player_id: playerId,
        assist_player_id: null,
        minute: null,
        is_penalty: false,
        is_own_goal: false,
        notes: null,
      });
    }

    for (let index = 0; index < redCount; index += 1) {
      events.push({
        match_id: matchId,
        event_type: "RED_CARD",
        team_id: teamId,
        player_id: playerId,
        assist_player_id: null,
        minute: null,
        is_penalty: false,
        is_own_goal: false,
        notes: null,
      });
    }
  }

  return events;
}

function buildMatchEventsPayload(match, participantSelection, playerStatsForm) {
  const homeGoals = buildGoalEvents(
    match.id,
    match.home_team_id,
    participantSelection.home,
    playerStatsForm,
    match.home_team_name
  );
  const awayGoals = buildGoalEvents(
    match.id,
    match.away_team_id,
    participantSelection.away,
    playerStatsForm,
    match.away_team_name
  );
  const homeCards = buildCardEvents(match.id, match.home_team_id, participantSelection.home, playerStatsForm);
  const awayCards = buildCardEvents(match.id, match.away_team_id, participantSelection.away, playerStatsForm);

  const ordered = [...homeGoals, ...awayGoals, ...homeCards, ...awayCards];
  return ordered.map((event, index) => ({
    ...event,
    event_order: index + 1,
  }));
}

function buildLineupsPayload(match, participantSelection, homeRoster, awayRoster) {
  const homeById = new Map((homeRoster || []).map((player) => [player.id, player]));
  const awayById = new Map((awayRoster || []).map((player) => [player.id, player]));

  return [
    ...participantSelection.home.map((playerId) => {
      const player = homeById.get(playerId);
      return {
        match_id: match.id,
        team_id: match.home_team_id,
        player_id: playerId,
        is_starter: true,
        shirt_number: player?.shirtNumber ?? null,
        position_played: player?.pos || null,
      };
    }),
    ...participantSelection.away.map((playerId) => {
      const player = awayById.get(playerId);
      return {
        match_id: match.id,
        team_id: match.away_team_id,
        player_id: playerId,
        is_starter: true,
        shirt_number: player?.shirtNumber ?? null,
        position_played: player?.pos || null,
      };
    }),
  ];
}

function ParticipantSelector({
  title,
  teamKey,
  teamName,
  roster,
  selectedIds,
  draftIds,
  open,
  onToggleOpen,
  onTogglePlayer,
  onApply,
  darkMode,
  disabled,
}) {
  const cardClass = darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  return (
    <div className={`rounded-xl border ${cardClass}`}>
      <button
        type="button"
        onClick={() => onToggleOpen(teamKey)}
        className="w-full px-4 py-3 flex items-center justify-between gap-3 text-left"
      >
        <div className="min-w-0">
          <div className="flex items-center gap-2 font-semibold">
            <Users size={15} />
            <span>{title}</span>
          </div>
          <div className={`text-xs mt-1 ${textMuted}`}>
            {teamName} • wybranych: {selectedIds.length}
          </div>
        </div>
        {open ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
      </button>

      {open && (
        <div className={`border-t px-4 py-4 space-y-3 ${darkMode ? "border-white/10" : "border-gray-200"}`}>
          {roster.length === 0 ? (
            <div className={`text-sm ${textMuted}`}>Brak zawodnikow w kadrze tej druzyny.</div>
          ) : (
            <div className="grid md:grid-cols-2 gap-2">
              {roster.map((player) => {
                const checked = draftIds.includes(player.id);
                return (
                  <label
                    key={player.id}
                    className={`flex items-center gap-3 rounded-xl border px-3 py-2 ${
                      darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white"
                    } ${disabled ? "opacity-70 cursor-not-allowed" : "cursor-pointer"}`}
                  >
                    <input
                      type="checkbox"
                      checked={checked}
                      onChange={() => onTogglePlayer(teamKey, player.id)}
                      disabled={disabled}
                      className="w-4 h-4"
                    />
                    <div className="min-w-0">
                      <div className="font-medium truncate">
                        {player.shirtNumber ? `${player.shirtNumber}. ` : ""}
                        {player.isCaptain ? "(C) " : ""}
                        {player.name}
                      </div>
                      <div className={`text-xs ${textMuted}`}>{player.pos || "Bez pozycji"}</div>
                    </div>
                  </label>
                );
              })}
            </div>
          )}

          <div className="flex justify-end">
            <button
              type="button"
              onClick={() => onApply(teamKey)}
              disabled={disabled}
              className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-emerald-500 text-black font-medium text-sm hover:bg-emerald-400 disabled:opacity-60"
            >
              <Check size={14} />
              Gotowe
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

function ParticipantStatsTable({
  title,
  players,
  playerStatsForm,
  mvpPlayerId,
  onToggleMvp,
  onStatChange,
  darkMode,
  disabled,
}) {
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";
  const inputClass = darkMode
    ? "bg-white/5 border-white/10 text-white"
    : "bg-white border-gray-300 text-gray-900";

  if (players.length === 0) {
    return (
      <div className={`rounded-xl border p-4 ${darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"}`}>
        <div className="font-semibold">{title}</div>
        <div className={`text-sm mt-2 ${textMuted}`}>Najpierw wybierz zawodnikow uczestniczacych w meczu.</div>
      </div>
    );
  }

  return (
    <div className={`rounded-xl border ${darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"}`}>
      <div className={`px-4 py-3 border-b font-semibold ${darkMode ? "border-white/10" : "border-gray-200"}`}>
        {title}
      </div>

      <div className="overflow-x-auto">
        <table className="w-full min-w-[720px] text-sm">
          <thead>
            <tr className={darkMode ? "text-gray-300" : "text-gray-600"}>
              <th className="text-left px-4 py-2 font-semibold">Zawodnik</th>
              <th className="text-center px-2 py-2 font-semibold">MVP</th>
              <th className="text-center px-2 py-2 font-semibold">Gole</th>
              <th className="text-center px-2 py-2 font-semibold">Asysty</th>
              <th className="text-center px-2 py-2 font-semibold">ZK</th>
              <th className="text-center px-2 py-2 font-semibold">CZK</th>
            </tr>
          </thead>
          <tbody>
            {players.map((player) => {
              const stats = playerStatsForm[player.id] || createEmptyPlayerStats();
              const yellowCount = parseCount(stats.yellow);
              const redLocked = yellowCount === 2;
              const mvpChecked = mvpPlayerId === player.id;
              const mvpDisabled = disabled || (!!mvpPlayerId && mvpPlayerId !== player.id);

              return (
                <tr
                  key={player.id}
                  className={darkMode ? "border-t border-white/10" : "border-t border-gray-200"}
                >
                  <td className="px-4 py-3">
                    <div className="font-medium">
                      {player.shirtNumber ? `${player.shirtNumber}. ` : ""}
                      {player.isCaptain ? "(C) " : ""}
                      {player.name}
                    </div>
                    <div className={`text-xs ${textMuted}`}>{player.pos || "Bez pozycji"}</div>
                  </td>
                  <td className="px-2 py-3 text-center">
                    <input
                      type="checkbox"
                      checked={mvpChecked}
                      disabled={mvpDisabled}
                      onChange={() => onToggleMvp(player.id)}
                      className="w-4 h-4"
                    />
                  </td>
                  <td className="px-2 py-3 text-center">
                    <input
                      type="number"
                      min="0"
                      max="20"
                      step="1"
                      value={stats.goals}
                      disabled={disabled}
                      onChange={(e) => onStatChange(player.id, "goals", e.target.value)}
                      className={`w-16 px-2 py-1 rounded-lg border text-center ${inputClass}`}
                    />
                  </td>
                  <td className="px-2 py-3 text-center">
                    <input
                      type="number"
                      min="0"
                      max="20"
                      step="1"
                      value={stats.assists}
                      disabled={disabled}
                      onChange={(e) => onStatChange(player.id, "assists", e.target.value)}
                      className={`w-16 px-2 py-1 rounded-lg border text-center ${inputClass}`}
                    />
                  </td>
                  <td className="px-2 py-3 text-center">
                    <input
                      type="number"
                      min="0"
                      max="2"
                      step="1"
                      value={stats.yellow}
                      disabled={disabled}
                      onChange={(e) => onStatChange(player.id, "yellow", e.target.value)}
                      className={`w-16 px-2 py-1 rounded-lg border text-center ${inputClass}`}
                    />
                  </td>
                  <td className="px-2 py-3 text-center">
                    <input
                      type="number"
                      min="0"
                      max="1"
                      step="1"
                      value={stats.red}
                      disabled={disabled || redLocked}
                      onChange={(e) => onStatChange(player.id, "red", e.target.value)}
                      className={`w-16 px-2 py-1 rounded-lg border text-center ${inputClass}`}
                    />
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default function AdminMatchResults({ darkMode }) {
  const [seasons, setSeasons] = useState([]);
  const [leagues, setLeagues] = useState([]);
  const [matches, setMatches] = useState([]);
  const [availableRounds, setAvailableRounds] = useState([]);
  const [selectedSeason, setSelectedSeason] = useState("");
  const [selectedLeague, setSelectedLeague] = useState("");
  const [selectedRound, setSelectedRound] = useState("");
  const [expandedMatch, setExpandedMatch] = useState(null);
  const [matchEvents, setMatchEvents] = useState([]);
  const [matchLineups, setMatchLineups] = useState([]);
  const [homeRoster, setHomeRoster] = useState([]);
  const [awayRoster, setAwayRoster] = useState([]);
  const [participantSelection, setParticipantSelection] = useState(EMPTY_TEAM_SELECTION);
  const [participantDrafts, setParticipantDrafts] = useState(EMPTY_TEAM_SELECTION);
  const [pickerOpen, setPickerOpen] = useState(null);
  const [playerStatsForm, setPlayerStatsForm] = useState({});
  const [scoreForm, setScoreForm] = useState({});
  const [mvpPlayerId, setMvpPlayerId] = useState("");
  const [loading, setLoading] = useState(true);
  const [loadingExpandedMatch, setLoadingExpandedMatch] = useState(false);
  const [savingMatchData, setSavingMatchData] = useState(false);
  const [alert, setAlert] = useState({ type: null, message: null });

  const card = darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-200";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";

  const resetExpandedEditor = useCallback(() => {
    setMatchEvents([]);
    setMatchLineups([]);
    setHomeRoster([]);
    setAwayRoster([]);
    setParticipantSelection(EMPTY_TEAM_SELECTION);
    setParticipantDrafts(EMPTY_TEAM_SELECTION);
    setPickerOpen(null);
    setPlayerStatsForm({});
    setMvpPlayerId("");
  }, []);

  const loadBase = useCallback(async () => {
    const [{ data: seasonRows, error: seasonError }, { data: leagueRows, error: leagueError }] = await Promise.all([
      supabase.from("seasons").select("*").order("year", { ascending: false }),
      supabase.from("leagues").select("*").order("display_order"),
    ]);

    if (seasonError || leagueError) {
      setAlert({ type: "error", message: seasonError?.message || leagueError?.message || "Nie udalo sie zaladowac danych bazowych." });
      setLoading(false);
      return;
    }

    setSeasons(seasonRows || []);
    setLeagues(leagueRows || []);
    if (seasonRows?.length) setSelectedSeason(seasonRows[0].id);
    if (leagueRows?.length) setSelectedLeague(leagueRows[0].id);
    setLoading(false);
  }, []);

  const loadMatches = useCallback(async () => {
    if (!selectedSeason || !selectedLeague) return [];

    const { data, error } = await supabase
      .from("v_matches")
      .select("*")
      .eq("season_id", selectedSeason)
      .eq("league_id", selectedLeague)
      .order("round")
      .order("match_date")
      .order("match_time");

    if (error) {
      setAlert({ type: "error", message: error.message });
      setMatches([]);
      setAvailableRounds([]);
      return [];
    }

    const allRows = data || [];
    const rounds = uniqueIds(allRows.map((match) => String(match.round))).sort((a, b) => Number(a) - Number(b));
    const filtered = selectedRound ? allRows.filter((match) => String(match.round) === String(selectedRound)) : allRows;

    setAvailableRounds(rounds);
    setMatches(filtered);
    return allRows;
  }, [selectedSeason, selectedLeague, selectedRound]);

  const selectedSeasonObj = useMemo(
    () => seasons.find((season) => season.id === selectedSeason),
    [seasons, selectedSeason]
  );

  const isEditable = selectedSeasonObj?.status === "active";
  const roundOptions = useMemo(
    () => availableRounds.map((round) => ({ value: round, label: `Kolejka ${round}` })),
    [availableRounds]
  );

  useEffect(() => {
    loadBase();
  }, [loadBase]);

  useEffect(() => {
    if (!selectedSeason || !selectedLeague) return;
    setExpandedMatch(null);
    resetExpandedEditor();
    loadMatches();
  }, [selectedSeason, selectedLeague, selectedRound, loadMatches, resetExpandedEditor]);

  const statusLabel = (status) => (
    status === "completed" ? "Zakonczony" :
    status === "walkover_home" ? "Walkower (gosp.)" :
    status === "walkover_away" ? "Walkower (gosc)" :
    status === "postponed" ? "Przelozony" :
    status === "cancelled" ? "Odwolany" :
    status === "unplayed" ? "Nierozegrany" :
    status === "live" ? "W trakcie" :
    "Zaplanowany"
  );

  const openMatchEditor = useCallback(async (match, forceOpen = false) => {
    if (!match?.id) return;

    if (!forceOpen && expandedMatch === match.id) {
      setExpandedMatch(null);
      resetExpandedEditor();
      return;
    }

    setExpandedMatch(match.id);
    setLoadingExpandedMatch(true);
    setPickerOpen(null);

    const rawStatus = match.status || "scheduled";
    const isWalkover = rawStatus === "walkover_home" || rawStatus === "walkover_away";
    setScoreForm({
      home_goals: match.home_goals ?? "",
      away_goals: match.away_goals ?? "",
      status: isWalkover ? "walkover" : rawStatus,
      walkover_winner: rawStatus === "walkover_away" ? "away" : "home",
      referee: match.referee || "",
      video_url: match.video_url || "",
    });

    try {
      const [eventsResult, homeRosterResult, awayRosterResult, lineupsResult] = await Promise.all([
        supabase
          .from("match_events")
          .select(
            "id, event_type, team_id, player_id, assist_player_id, minute, event_order, player:players!match_events_player_id_fkey(id, display_name, position), assist:players!match_events_assist_player_id_fkey(id, display_name, position)"
          )
          .eq("match_id", match.id)
          .order("event_order")
          .order("minute"),
        supabase
          .from("team_players")
          .select("player_id, is_captain, shirt_number, players(id, display_name, position)")
          .eq("team_id", match.home_team_id)
          .eq("season_id", match.season_id)
          .eq("league_id", match.league_id)
          .is("left_date", null),
        supabase
          .from("team_players")
          .select("player_id, is_captain, shirt_number, players(id, display_name, position)")
          .eq("team_id", match.away_team_id)
          .eq("season_id", match.season_id)
          .eq("league_id", match.league_id)
          .is("left_date", null),
        supabase
          .from("match_lineups")
          .select("id, team_id, player_id, is_starter, shirt_number, position_played, players(id, display_name, position)")
          .eq("match_id", match.id),
      ]);

      const error =
        eventsResult.error ||
        homeRosterResult.error ||
        awayRosterResult.error ||
        lineupsResult.error;

      if (error) throw error;

      const eventRows = eventsResult.data || [];
      const lineupRows = lineupsResult.data || [];
      const nextHomeRoster = buildRosterRows(
        homeRosterResult.data || [],
        lineupRows,
        eventRows,
        match.home_team_id
      );
      const nextAwayRoster = buildRosterRows(
        awayRosterResult.data || [],
        lineupRows,
        eventRows,
        match.away_team_id
      );

      const nextSelection = {
        home: sortPlayerIdsByRoster(buildSelectedIds(lineupRows, eventRows, match.home_team_id), nextHomeRoster),
        away: sortPlayerIdsByRoster(buildSelectedIds(lineupRows, eventRows, match.away_team_id), nextAwayRoster),
      };
      const nextStats = buildPlayerStatsFromEvents(eventRows);

      for (const playerId of [...nextSelection.home, ...nextSelection.away]) {
        if (!nextStats[playerId]) nextStats[playerId] = createEmptyPlayerStats();
      }

      setMatchEvents(eventRows);
      setMatchLineups(lineupRows);
      setHomeRoster(nextHomeRoster);
      setAwayRoster(nextAwayRoster);
      setParticipantSelection(nextSelection);
      setParticipantDrafts(nextSelection);
      setPlayerStatsForm(nextStats);
      setMvpPlayerId(match.mvp_player_id || "");
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udalo sie zaladowac danych meczu." });
      resetExpandedEditor();
    } finally {
      setLoadingExpandedMatch(false);
    }
  }, [expandedMatch, resetExpandedEditor]);

  const allSelectedPlayerIds = useMemo(
    () => uniqueIds([...participantSelection.home, ...participantSelection.away]),
    [participantSelection]
  );

  const homeSelectedRows = useMemo(() => {
    const map = new Map(homeRoster.map((player) => [player.id, player]));
    return participantSelection.home.map((playerId) => map.get(playerId)).filter(Boolean);
  }, [homeRoster, participantSelection.home]);

  const awaySelectedRows = useMemo(() => {
    const map = new Map(awayRoster.map((player) => [player.id, player]));
    return participantSelection.away.map((playerId) => map.get(playerId)).filter(Boolean);
  }, [awayRoster, participantSelection.away]);

  function togglePicker(teamKey) {
    setParticipantDrafts((prev) => ({
      ...prev,
      [teamKey]: [...participantSelection[teamKey]],
    }));
    setPickerOpen((current) => (current === teamKey ? null : teamKey));
  }

  function toggleDraftPlayer(teamKey, playerId) {
    const roster = teamKey === "home" ? homeRoster : awayRoster;
    setParticipantDrafts((prev) => {
      const current = new Set(prev[teamKey] || []);
      if (current.has(playerId)) current.delete(playerId);
      else current.add(playerId);
      return {
        ...prev,
        [teamKey]: sortPlayerIdsByRoster(Array.from(current), roster),
      };
    });
  }

  function applyParticipantSelection(teamKey) {
    const roster = teamKey === "home" ? homeRoster : awayRoster;
    const nextTeamIds = sortPlayerIdsByRoster(participantDrafts[teamKey], roster);
    const nextSelection = {
      ...participantSelection,
      [teamKey]: nextTeamIds,
    };
    const nextSelectedIds = uniqueIds([...nextSelection.home, ...nextSelection.away]);

    setParticipantSelection(nextSelection);
    setParticipantDrafts(nextSelection);
    setPlayerStatsForm((prev) => {
      const next = {};
      for (const playerId of nextSelectedIds) {
        next[playerId] = prev[playerId] || createEmptyPlayerStats();
      }
      return next;
    });
    if (mvpPlayerId && !nextSelectedIds.includes(mvpPlayerId)) {
      setMvpPlayerId("");
    }
    setPickerOpen(null);
  }

  function updatePlayerStat(playerId, field, value) {
    setPlayerStatsForm((prev) => {
      const current = prev[playerId] || createEmptyPlayerStats();
      const next = {
        ...prev,
        [playerId]: { ...current },
      };

      if (field === "yellow") {
        const normalized = normalizeCounterInput(value, 2);
        next[playerId].yellow = normalized;
        if (parseCount(normalized) === 2) {
          next[playerId].red = "1";
        }
      } else if (field === "red") {
        next[playerId].red = normalizeCounterInput(value, 1);
      } else {
        next[playerId][field] = normalizeCounterInput(value, 20);
      }

      return next;
    });
  }

  function toggleMvp(playerId) {
    setMvpPlayerId((current) => (current === playerId ? "" : playerId));
  }

  async function saveMatch(match) {
    if (!match?.id) return;

    setSavingMatchData(true);
    try {
      const resolvedStatus = scoreForm.status === "walkover"
        ? (scoreForm.walkover_winner === "away" ? "walkover_away" : "walkover_home")
        : scoreForm.status;

      const noScoreStatuses = new Set(["scheduled", "postponed", "cancelled", "unplayed"]);
      let homeGoals = parseScoreValue(scoreForm.home_goals);
      let awayGoals = parseScoreValue(scoreForm.away_goals);

      if (resolvedStatus === "walkover_home") {
        homeGoals = homeGoals ?? 3;
        awayGoals = awayGoals ?? 0;
      } else if (resolvedStatus === "walkover_away") {
        homeGoals = homeGoals ?? 0;
        awayGoals = awayGoals ?? 3;
      } else if (noScoreStatuses.has(resolvedStatus)) {
        homeGoals = null;
        awayGoals = null;
      }

      let lineupsPayload = [];
      let eventsPayload = [];
      let nextMvpPlayerId = null;

      if (resolvedStatus === "completed") {
        if (homeGoals === null || awayGoals === null) {
          throw new Error("Przy zakonczonym meczu wpisz wynik dla obu druzyn.");
        }

        if (participantSelection.home.length === 0 || participantSelection.away.length === 0) {
          throw new Error("Wybierz zawodnikow uczestniczacych w meczu dla obu druzyn.");
        }

        const homeTotals = teamTotals(participantSelection.home, playerStatsForm);
        const awayTotals = teamTotals(participantSelection.away, playerStatsForm);

        if (homeTotals.goals !== homeGoals) {
          throw new Error(`Liczba goli zawodnikow druzyny ${match.home_team_name} musi zgadzac sie z wynikiem meczu.`);
        }
        if (awayTotals.goals !== awayGoals) {
          throw new Error(`Liczba goli zawodnikow druzyny ${match.away_team_name} musi zgadzac sie z wynikiem meczu.`);
        }
        if (homeTotals.assists > homeTotals.goals) {
          throw new Error(`Za duzo asyst wpisano dla druzyny ${match.home_team_name}.`);
        }
        if (awayTotals.assists > awayTotals.goals) {
          throw new Error(`Za duzo asyst wpisano dla druzyny ${match.away_team_name}.`);
        }
        if (mvpPlayerId && !allSelectedPlayerIds.includes(mvpPlayerId)) {
          throw new Error("MVP musi byc wybrany sposrod zawodnikow uczestniczacych w meczu.");
        }

        lineupsPayload = buildLineupsPayload(match, participantSelection, homeRoster, awayRoster);
        eventsPayload = buildMatchEventsPayload(match, participantSelection, playerStatsForm);
        nextMvpPlayerId = mvpPlayerId || null;
      }

      const updatePayload = {
        home_goals: homeGoals,
        away_goals: awayGoals,
        status: resolvedStatus,
        referee: scoreForm.referee || null,
        video_url: scoreForm.video_url || null,
        mvp_player_id: nextMvpPlayerId,
      };

      const { error: updateError } = await supabase
        .from("matches")
        .update(updatePayload)
        .eq("id", match.id);

      if (updateError) throw updateError;

      const existingEventIds = (matchEvents || []).map((event) => event.id).filter(Boolean);
      if (existingEventIds.length > 0) {
        const { error: suspensionDeleteError } = await supabase
          .from("suspensions")
          .delete()
          .in("triggering_event_id", existingEventIds);
        if (suspensionDeleteError) throw suspensionDeleteError;
      }

      const { error: deleteEventsError } = await supabase
        .from("match_events")
        .delete()
        .eq("match_id", match.id);
      if (deleteEventsError) throw deleteEventsError;

      const { error: deleteLineupsError } = await supabase
        .from("match_lineups")
        .delete()
        .eq("match_id", match.id);
      if (deleteLineupsError) throw deleteLineupsError;

      if (lineupsPayload.length > 0) {
        const { error: insertLineupsError } = await supabase
          .from("match_lineups")
          .insert(lineupsPayload);
        if (insertLineupsError) throw insertLineupsError;
      }

      if (eventsPayload.length > 0) {
        const { error: insertEventsError } = await supabase
          .from("match_events")
          .insert(eventsPayload);
        if (insertEventsError) throw insertEventsError;
      }

      setAlert({ type: "success", message: "Mecz zostal zapisany." });
      const allRows = await loadMatches();
      const refreshedMatch = allRows.find((item) => item.id === match.id) || { ...match, ...updatePayload };
      await openMatchEditor(refreshedMatch, true);
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udalo sie zapisac meczu." });
    } finally {
      setSavingMatchData(false);
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-2 border-yellow-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold">Wyniki meczow</h2>

      <AdminAlert
        type={alert.type}
        message={alert.message}
        onClose={() => setAlert({ type: null, message: null })}
      />

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <AdminFormField
          label="Sezon"
          name="season"
          type="select"
          value={selectedSeason}
          onChange={(e) => setSelectedSeason(e.target.value)}
          darkMode={darkMode}
          options={seasons.map((season) => ({ value: season.id, label: season.name }))}
        />
        <AdminFormField
          label="Liga"
          name="league"
          type="select"
          value={selectedLeague}
          onChange={(e) => setSelectedLeague(e.target.value)}
          darkMode={darkMode}
          options={leagues.map((league) => ({ value: league.id, label: league.name }))}
        />
        <AdminFormField
          label="Kolejka"
          name="round"
          type="select"
          value={selectedRound}
          onChange={(e) => setSelectedRound(e.target.value)}
          darkMode={darkMode}
          options={[{ value: "", label: "Wszystkie" }, ...roundOptions]}
        />
      </div>

      {!isEditable && selectedSeasonObj && (
        <div className={`rounded-xl border p-3 text-sm ${darkMode ? "border-orange-500/30 bg-orange-500/10 text-orange-300" : "border-orange-200 bg-orange-50 text-orange-800"}`}>
          Sezon "{selectedSeasonObj.name}" ma status <strong>{selectedSeasonObj.status}</strong> - edycja wynikow i skladu jest zablokowana. Mozesz jednak podejrzec dane meczu i zarzadzac galeria.
        </div>
      )}

      {matches.length === 0 ? (
        <div className={`rounded-2xl border p-8 text-center ${card}`}>
          <p className={textMuted}>Brak meczow. Wygeneruj terminarz w zakladce "Terminarz".</p>
        </div>
      ) : (
        <div className="space-y-3">
          {matches.map((match) => {
            const homeTotals = teamTotals(participantSelection.home, playerStatsForm);
            const awayTotals = teamTotals(participantSelection.away, playerStatsForm);

            return (
              <div key={match.id} className={`rounded-2xl border overflow-hidden ${card}`}>
                <button
                  type="button"
                  onClick={() => openMatchEditor(match)}
                  className="w-full px-4 py-3 flex items-center justify-between gap-3 hover:bg-white/5 transition-colors"
                >
                  <div className="flex items-center gap-3 min-w-0">
                    <span className={`text-xs ${textMuted} w-8 flex-shrink-0`}>K{match.round}</span>
                    <span className="font-medium truncate">{match.home_team_name}</span>
                    {match.status === "completed" || String(match.status || "").startsWith("walkover") ? (
                      <span className="font-bold text-lg px-2 flex-shrink-0">
                        {match.home_goals} : {match.away_goals}
                      </span>
                    ) : (
                      <span className={`px-2 ${textMuted}`}>vs</span>
                    )}
                    <span className="font-medium truncate">{match.away_team_name}</span>
                  </div>

                  <div className="flex items-center gap-2 flex-shrink-0">
                    <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${
                      match.status === "completed" ? "bg-green-500/20 text-green-400" :
                      String(match.status || "").startsWith("walkover") ? "bg-orange-500/20 text-orange-400" :
                      match.status === "postponed" ? "bg-blue-500/20 text-blue-400" :
                      match.status === "cancelled" ? "bg-red-500/20 text-red-400" :
                      match.status === "unplayed" ? "bg-slate-500/20 text-slate-300" :
                      darkMode ? "bg-white/10 text-gray-400" : "bg-gray-100 text-gray-500"
                    }`}>
                      {statusLabel(match.status)}
                    </span>
                    <span className={`text-xs ${textMuted}`}>{match.match_date || "—"}</span>
                    {expandedMatch === match.id ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
                  </div>
                </button>

                {expandedMatch === match.id && (
                  <div className={`border-t px-4 py-4 space-y-4 ${darkMode ? "border-white/10" : "border-gray-200"}`}>
                    {loadingExpandedMatch ? (
                      <div className={`flex items-center gap-2 text-sm ${textMuted}`}>
                        <Loader2 size={16} className="animate-spin" />
                        Ladowanie danych meczu...
                      </div>
                    ) : (
                      <>
                        {isEditable ? (
                          <div className="grid grid-cols-2 md:grid-cols-6 gap-3 items-end">
                            <AdminFormField
                              label={`Bramki ${match.home_team_abbr || match.home_team_name}`}
                              name="home_goals"
                              type="number"
                              value={scoreForm.home_goals}
                              onChange={(e) => setScoreForm((prev) => ({ ...prev, home_goals: e.target.value }))}
                              darkMode={darkMode}
                              min={0}
                            />
                            <AdminFormField
                              label={`Bramki ${match.away_team_abbr || match.away_team_name}`}
                              name="away_goals"
                              type="number"
                              value={scoreForm.away_goals}
                              onChange={(e) => setScoreForm((prev) => ({ ...prev, away_goals: e.target.value }))}
                              darkMode={darkMode}
                              min={0}
                            />
                            <AdminFormField
                              label="Status"
                              name="status"
                              type="select"
                              value={scoreForm.status}
                              onChange={(e) => {
                                const nextStatus = e.target.value;
                                setScoreForm((prev) => {
                                  const next = { ...prev, status: nextStatus };
                                  if (nextStatus === "walkover") {
                                    const winner = next.walkover_winner || "home";
                                    next.walkover_winner = winner;
                                    next.home_goals = winner === "home" ? 3 : 0;
                                    next.away_goals = winner === "away" ? 3 : 0;
                                  }
                                  if (["scheduled", "postponed", "cancelled", "unplayed"].includes(nextStatus)) {
                                    next.home_goals = "";
                                    next.away_goals = "";
                                  }
                                  return next;
                                });
                              }}
                              darkMode={darkMode}
                              options={[
                                { value: "scheduled", label: "Zaplanowany" },
                                { value: "completed", label: "Zakonczony" },
                                { value: "walkover", label: "Walkower" },
                                { value: "postponed", label: "Przelozony" },
                                { value: "cancelled", label: "Odwolany" },
                                { value: "unplayed", label: "Nierozegrany" },
                              ]}
                            />
                            {scoreForm.status === "walkover" && (
                              <AdminFormField
                                label="Wygral walkowerem"
                                name="walkover_winner"
                                type="select"
                                value={scoreForm.walkover_winner || "home"}
                                onChange={(e) => {
                                  const winner = e.target.value;
                                  setScoreForm((prev) => ({
                                    ...prev,
                                    walkover_winner: winner,
                                    home_goals: winner === "home" ? 3 : 0,
                                    away_goals: winner === "away" ? 3 : 0,
                                  }));
                                }}
                                darkMode={darkMode}
                                options={[
                                  { value: "home", label: match.home_team_name },
                                  { value: "away", label: match.away_team_name },
                                ]}
                              />
                            )}
                            <AdminFormField
                              label="Sedzia"
                              name="referee"
                              value={scoreForm.referee}
                              onChange={(e) => setScoreForm((prev) => ({ ...prev, referee: e.target.value }))}
                              darkMode={darkMode}
                            />
                            <button
                              type="button"
                              onClick={() => saveMatch(match)}
                              disabled={savingMatchData}
                              className="flex items-center justify-center gap-2 px-4 py-2 rounded-xl bg-green-500 text-black font-medium text-sm hover:bg-green-400 h-[42px] disabled:opacity-60"
                            >
                              {savingMatchData ? <Loader2 size={14} className="animate-spin" /> : <Save size={14} />}
                              Zapisz mecz
                            </button>
                          </div>
                        ) : (
                          <div className={`flex items-center gap-4 text-sm py-1 ${textMuted}`}>
                            <span>
                              Wynik:{" "}
                              <strong className={darkMode ? "text-white" : "text-gray-900"}>
                                {match.home_goals ?? "—"} : {match.away_goals ?? "—"}
                              </strong>
                            </span>
                            <span>Status: {statusLabel(match.status)}</span>
                            {match.referee && <span>Sedzia: {match.referee}</span>}
                          </div>
                        )}

                        <div className={`rounded-xl border p-4 ${darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50"}`}>
                          <div className="font-semibold text-sm">Dobor zawodnikow i statystyki meczu</div>
                          <p className={`text-xs mt-1 ${textMuted}`}>
                            Najpierw wybierz zawodnikow uczestniczacych w meczu, a potem wpisz ich statystyki.
                            Puste pola i zera sa traktowane tak samo.
                          </p>

                          {scoreForm.status !== "completed" && (
                            <div className={`mt-3 rounded-xl border px-3 py-2 text-sm ${darkMode ? "border-blue-400/20 bg-blue-500/10 text-blue-200" : "border-blue-200 bg-blue-50 text-blue-800"}`}>
                              Statystyki zawodnikow sa zapisywane tylko dla meczu ze statusem "Zakonczony". Przy innych statusach zapis wyniku wyczysci sklad, zdarzenia i MVP.
                            </div>
                          )}

                          <div className="mt-4 grid xl:grid-cols-2 gap-4">
                            <ParticipantSelector
                              title="Uczestnicy gospodarzy"
                              teamKey="home"
                              teamName={match.home_team_name}
                              roster={homeRoster}
                              selectedIds={participantSelection.home}
                              draftIds={participantDrafts.home}
                              open={pickerOpen === "home"}
                              onToggleOpen={togglePicker}
                              onTogglePlayer={toggleDraftPlayer}
                              onApply={applyParticipantSelection}
                              darkMode={darkMode}
                              disabled={!isEditable || savingMatchData}
                            />
                            <ParticipantSelector
                              title="Uczestnicy gosci"
                              teamKey="away"
                              teamName={match.away_team_name}
                              roster={awayRoster}
                              selectedIds={participantSelection.away}
                              draftIds={participantDrafts.away}
                              open={pickerOpen === "away"}
                              onToggleOpen={togglePicker}
                              onTogglePlayer={toggleDraftPlayer}
                              onApply={applyParticipantSelection}
                              darkMode={darkMode}
                              disabled={!isEditable || savingMatchData}
                            />
                          </div>

                          <div className="mt-4 grid xl:grid-cols-2 gap-4">
                            <ParticipantStatsTable
                              title={`${match.home_team_name} • uczestnicy`}
                              players={homeSelectedRows}
                              playerStatsForm={playerStatsForm}
                              mvpPlayerId={mvpPlayerId}
                              onToggleMvp={toggleMvp}
                              onStatChange={updatePlayerStat}
                              darkMode={darkMode}
                              disabled={!isEditable || savingMatchData || scoreForm.status !== "completed"}
                            />
                            <ParticipantStatsTable
                              title={`${match.away_team_name} • uczestnicy`}
                              players={awaySelectedRows}
                              playerStatsForm={playerStatsForm}
                              mvpPlayerId={mvpPlayerId}
                              onToggleMvp={toggleMvp}
                              onStatChange={updatePlayerStat}
                              darkMode={darkMode}
                              disabled={!isEditable || savingMatchData || scoreForm.status !== "completed"}
                            />
                          </div>

                          <div className={`mt-4 flex flex-wrap gap-2 text-xs ${textMuted}`}>
                            <span className={`px-2 py-1 rounded-full border ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white"}`}>
                              {match.home_team_name}: gole {homeTotals.goals}, asysty {homeTotals.assists}, ZK {homeTotals.yellow}, CZK {homeTotals.red}
                            </span>
                            <span className={`px-2 py-1 rounded-full border ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white"}`}>
                              {match.away_team_name}: gole {awayTotals.goals}, asysty {awayTotals.assists}, ZK {awayTotals.yellow}, CZK {awayTotals.red}
                            </span>
                            {mvpPlayerId && (
                              <span className={`px-2 py-1 rounded-full border ${darkMode ? "border-amber-400/20 bg-amber-500/10 text-amber-200" : "border-amber-300 bg-amber-50 text-amber-800"}`}>
                                MVP wybrany
                              </span>
                            )}
                            <span>
                              Aktualny zapis: {matchEvents.length} zdarzen, {matchLineups.length} pozycji w skladzie.
                            </span>
                          </div>
                        </div>

                        <AdminMatchGalleryManager
                          match={match}
                          darkMode={darkMode}
                          onAlert={setAlert}
                        />
                      </>
                    )}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
