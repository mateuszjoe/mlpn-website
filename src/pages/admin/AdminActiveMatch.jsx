import React, { useCallback, useEffect, useMemo, useState } from "react";
import { Check, CheckCircle2, Loader2, Pencil, Plus, RefreshCw, Radio, Send } from "lucide-react";
import { useAuth } from "../../contexts/AuthContext";
import { notifyMatchDataUpdated } from "../../lib/matchDataEvents";
import { supabase } from "../../lib/supabase";
import AdminAlert from "./components/AdminAlert";
import AdminFormField from "./components/AdminFormField";

const EMPTY_EVENT_FORM = {
  teamId: "",
  playerId: "",
  eventType: "GOAL",
  assistPlayerId: "none",
};

const EMPTY_ATTENDANCE_EDITOR = {
  matchId: "",
  teamId: "",
  draftIds: [],
};

const ABSENT_SEPARATOR_VALUE = "__absent_separator__";

const EVENT_TYPE_OPTIONS = [
  { value: "GOAL", label: "Bramka" },
  { value: "OWN_GOAL", label: "Gol samobójczy" },
  { value: "YELLOW_CARD", label: "Żółta kartka" },
  { value: "RED_CARD", label: "Czerwona kartka" },
];

function asPlayer(row) {
  const player = Array.isArray(row?.players) ? row.players[0] : row?.players;
  return player || {};
}

function playerName(row) {
  const player = asPlayer(row);
  return player.display_name || row?.display_name || "Bez nazwy";
}

function normalizeText(value) {
  return String(value || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase();
}

function playerNameParts(row) {
  const name = playerName(row).trim();
  const parts = name.split(/\s+/).filter(Boolean);
  if (parts.length <= 1) return { first: "", last: name || "Zawodnik", full: name || "Zawodnik" };

  return {
    first: parts.slice(0, -1).join(" "),
    last: parts[parts.length - 1],
    full: name,
  };
}

function playerShortName(row) {
  const { first, last, full } = playerNameParts(row);
  if (!first) return full;
  return `${first.charAt(0).toUpperCase()}. ${last}`;
}

function comparePlayersBySurname(a, b) {
  const left = playerNameParts(a);
  const right = playerNameParts(b);
  return (
    normalizeText(left.last).localeCompare(normalizeText(right.last), "pl") ||
    normalizeText(left.first).localeCompare(normalizeText(right.first), "pl") ||
    normalizeText(left.full).localeCompare(normalizeText(right.full), "pl")
  );
}

function eventPlayerName(event, key = "player") {
  const player = Array.isArray(event?.[key]) ? event[key][0] : event?.[key];
  return player?.display_name || "Zawodnik";
}

function isOwnGoalEvent(event) {
  return event?.event_type === "OWN_GOAL" || event?.is_own_goal === true;
}

function isGoalEvent(event) {
  return event?.event_type === "GOAL" || event?.event_type === "OWN_GOAL";
}

function eventLabel(type, ownGoal = false) {
  if (ownGoal || type === "OWN_GOAL") return "Gol samobójczy";
  if (type === "GOAL") return "Bramka";
  if (type === "YELLOW_CARD") return "Żółta kartka";
  if (type === "RED_CARD") return "Czerwona kartka";
  return type || "Zdarzenie";
}

function eventBadgeClass(type, darkMode, ownGoal = false) {
  if (ownGoal || type === "OWN_GOAL") {
    return darkMode
      ? "border-orange-400/30 bg-orange-500/10 text-orange-200"
      : "border-orange-200 bg-orange-50 text-orange-800";
  }
  if (type === "GOAL") {
    return darkMode
      ? "border-emerald-400/30 bg-emerald-500/10 text-emerald-200"
      : "border-emerald-200 bg-emerald-50 text-emerald-800";
  }
  if (type === "YELLOW_CARD") {
    return darkMode
      ? "border-yellow-400/30 bg-yellow-500/10 text-yellow-200"
      : "border-yellow-200 bg-yellow-50 text-yellow-800";
  }
  return darkMode
    ? "border-red-400/30 bg-red-500/10 text-red-200"
    : "border-red-200 bg-red-50 text-red-800";
}

function formatMatchMoment(match) {
  const parts = [];
  if (match?.match_date) parts.push(match.match_date);
  if (match?.match_time) parts.push(String(match.match_time).slice(0, 5));
  if (match?.round) parts.push(`Kolejka ${match.round}`);
  return parts.join(" - ");
}

function groupRowsByMatch(rows) {
  const grouped = {};
  for (const row of rows || []) {
    if (!row.match_id) continue;
    if (!grouped[row.match_id]) grouped[row.match_id] = [];
    grouped[row.match_id].push(row);
  }
  return grouped;
}

function sortLineups(rows) {
  return (rows || []).slice().sort((a, b) => {
    if (a.team_id !== b.team_id) return String(a.team_id).localeCompare(String(b.team_id));
    return comparePlayersBySurname(a, b);
  });
}

function sortRosterRows(rows) {
  return (rows || []).slice().sort((a, b) => {
    if (a.team_id !== b.team_id) return String(a.team_id).localeCompare(String(b.team_id));
    return comparePlayersBySurname(a, b);
  });
}

function sortEvents(rows) {
  return (rows || []).slice().sort((a, b) => {
    const orderA = Number(a.event_order || 0);
    const orderB = Number(b.event_order || 0);
    if (orderA !== orderB) return orderA - orderB;
    return String(a.created_at || "").localeCompare(String(b.created_at || ""));
  });
}

function getTeamName(match, teamId) {
  if (teamId === match?.home_team_id) return match.home_team_name;
  if (teamId === match?.away_team_id) return match.away_team_name;
  return "Drużyna";
}

function getOpponentTeamId(match, teamId) {
  if (teamId === match?.home_team_id) return match.away_team_id;
  if (teamId === match?.away_team_id) return match.home_team_id;
  return "";
}

function getEventPlayerTeamId(match, selectedTeamId, eventType) {
  if (eventType === "OWN_GOAL") return getOpponentTeamId(match, selectedTeamId);
  return selectedTeamId;
}

function getOwnGoalScoringTeamId(match, event) {
  return getOpponentTeamId(match, event?.team_id);
}

function getEventTeamLabel(match, event) {
  if (isOwnGoalEvent(event)) {
    const ownTeamName = getTeamName(match, event.team_id);
    const scoringTeamName = getTeamName(match, getOwnGoalScoringTeamId(match, event));
    return `${ownTeamName} -> gol dla ${scoringTeamName}`;
  }
  return getTeamName(match, event.team_id);
}

function calculateScore(match, events) {
  const score = { home: 0, away: 0 };
  for (const event of events || []) {
    if (!isGoalEvent(event)) continue;
    if (isOwnGoalEvent(event)) {
      if (event.team_id === match.home_team_id) score.away += 1;
      if (event.team_id === match.away_team_id) score.home += 1;
      continue;
    }
    if (event.team_id === match.home_team_id) score.home += 1;
    if (event.team_id === match.away_team_id) score.away += 1;
  }
  return score;
}

function getTeamRoster(match, rostersByMatchId, teamId) {
  return (rostersByMatchId[match?.id] || []).filter((row) => row.team_id === teamId);
}

function getTeamLineups(match, lineupsByMatchId, teamId) {
  return (lineupsByMatchId[match?.id] || []).filter((row) => row.team_id === teamId);
}

function getPlayersForMatchTeam(match, rostersByMatchId, lineupsByMatchId, teamId) {
  const presentIds = new Set(getTeamLineups(match, lineupsByMatchId, teamId).map((row) => row.player_id));
  const byId = new Map();

  for (const row of getTeamRoster(match, rostersByMatchId, teamId)) {
    if (!row.player_id) continue;
    byId.set(row.player_id, {
      ...row,
      team_id: teamId,
      present: presentIds.has(row.player_id),
    });
  }

  for (const row of getTeamLineups(match, lineupsByMatchId, teamId)) {
    if (!row.player_id) continue;
    const current = byId.get(row.player_id);
    byId.set(row.player_id, {
      ...current,
      ...row,
      team_id: teamId,
      present: true,
      players: row.players || current?.players,
      shirt_number: row.shirt_number ?? current?.shirt_number ?? null,
    });
  }

  return Array.from(byId.values()).sort(comparePlayersBySurname);
}

function buildPlayerOptions(players, excludePlayerId = "") {
  const filtered = (players || []).filter((row) => row.player_id && row.player_id !== excludePlayerId);
  const present = filtered.filter((row) => row.present);
  const absent = filtered.filter((row) => !row.present);
  const mapOption = (row) => ({
    value: row.player_id,
    label: playerShortName(row),
  });
  const options = present.map(mapOption);

  if (absent.length > 0) {
    options.push({ value: ABSENT_SEPARATOR_VALUE, label: "- NIEOBECNI -", disabled: true });
    options.push(...absent.map(mapOption));
  }

  return options;
}

function firstSelectableOption(options) {
  return (options || []).find((option) => option && !option.disabled)?.value || "";
}

function buildLineupPayload(match, teamId, playerRow) {
  const player = asPlayer(playerRow);
  return {
    match_id: match.id,
    team_id: teamId,
    player_id: playerRow.player_id,
    is_starter: true,
    shirt_number: playerRow.shirt_number ?? null,
    position_played: playerRow.position_played || player.position || null,
  };
}

function isMissingActiveMatchDutyFeature(error) {
  const message = String(error?.message || "").toLowerCase();
  return (
    error?.code === "42P01" ||
    error?.code === "42883" ||
    message.includes("active_match_assignments") ||
    message.includes("transfer_active_match_assignment") ||
    message.includes("list_active_match_duty_users") ||
    message.includes("ensure_active_match_assignment")
  );
}

export default function AdminActiveMatch({ darkMode }) {
  const { user, isAdmin } = useAuth();
  const [matches, setMatches] = useState([]);
  const [assignmentsByMatchId, setAssignmentsByMatchId] = useState({});
  const [dutyUsers, setDutyUsers] = useState([]);
  const [lineupsByMatchId, setLineupsByMatchId] = useState({});
  const [rostersByMatchId, setRostersByMatchId] = useState({});
  const [eventsByMatchId, setEventsByMatchId] = useState({});
  const [activeFormMatchId, setActiveFormMatchId] = useState("");
  const [editingEventId, setEditingEventId] = useState("");
  const [eventForm, setEventForm] = useState(EMPTY_EVENT_FORM);
  const [attendanceEditor, setAttendanceEditor] = useState(EMPTY_ATTENDANCE_EDITOR);
  const [activeTransferMatchId, setActiveTransferMatchId] = useState("");
  const [transferTargetId, setTransferTargetId] = useState("");
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [savingAttendance, setSavingAttendance] = useState(false);
  const [finishingMatchId, setFinishingMatchId] = useState("");
  const [transferringMatchId, setTransferringMatchId] = useState("");
  const [assignmentFeatureMissing, setAssignmentFeatureMissing] = useState(false);
  const [alert, setAlert] = useState({ type: null, message: null });

  const cardClass = darkMode
    ? "border-white/10 bg-[#141828] text-white"
    : "border-gray-200 bg-white text-gray-900";
  const mutedText = darkMode ? "text-gray-400" : "text-gray-500";

  const loadDutyUsers = useCallback(async () => {
    if (assignmentFeatureMissing) return;

    try {
      const { data, error } = await supabase.rpc("list_active_match_duty_users");
      if (error) throw error;
      setDutyUsers(data || []);
    } catch (error) {
      if (isMissingActiveMatchDutyFeature(error)) {
        setAssignmentFeatureMissing(true);
        return;
      }
      console.warn("Duty users fetch:", error.message);
    }
  }, [assignmentFeatureMissing]);

  const loadActiveMatches = useCallback(async () => {
    setLoading(true);
    try {
      const { data: matchRows, error: matchesError } = await supabase
        .from("v_matches")
        .select(
          "id, season_id, league_id, league_code, league_name, season_year, round, match_date, match_time, home_team_id, away_team_id, home_team_name, home_team_abbr, away_team_name, away_team_abbr, home_goals, away_goals, status"
        )
        .eq("status", "live")
        .order("match_date", { ascending: true, nullsFirst: false })
        .order("match_time", { ascending: true, nullsFirst: false });

      if (matchesError) throw matchesError;

      let nextMatches = matchRows || [];
      let nextAssignments = {};
      let dutyFeatureMissing = assignmentFeatureMissing;

      if (nextMatches.length > 0 && !assignmentFeatureMissing) {
        const { data: assignmentRows, error: assignmentsError } = await supabase
          .from("active_match_assignments")
          .select("match_id, assigned_to, assigned_to_name_snapshot, assigned_by, assigned_by_name_snapshot, assigned_at")
          .in("match_id", nextMatches.map((match) => match.id));

        if (assignmentsError) {
          if (isMissingActiveMatchDutyFeature(assignmentsError)) {
            dutyFeatureMissing = true;
            setAssignmentFeatureMissing(true);
          } else {
            throw assignmentsError;
          }
        } else {
          nextAssignments = Object.fromEntries((assignmentRows || []).map((row) => [row.match_id, row]));
        }
      }

      if (!isAdmin && !dutyFeatureMissing) {
        nextMatches = nextMatches.filter((match) => nextAssignments[match.id]?.assigned_to === user?.id);
      }

      const matchIds = nextMatches.map((match) => match.id);
      const teamIds = Array.from(new Set(nextMatches.flatMap((match) => [match.home_team_id, match.away_team_id]).filter(Boolean)));
      const seasonIds = Array.from(new Set(nextMatches.map((match) => match.season_id).filter(Boolean)));
      let nextLineups = {};
      let nextRosters = {};
      let nextEvents = {};

      if (matchIds.length > 0) {
        const [lineupsResult, rostersResult, eventsResult] = await Promise.all([
          supabase
            .from("match_lineups")
            .select("id, match_id, team_id, player_id, shirt_number, position_played, players(id, display_name, position)")
            .in("match_id", matchIds),
          supabase
            .from("team_players")
            .select("id, team_id, season_id, league_id, player_id, is_captain, shirt_number, players(id, display_name, position)")
            .in("team_id", teamIds)
            .in("season_id", seasonIds)
            .is("left_date", null),
          supabase
            .from("match_events")
            .select(
              "id, match_id, event_type, team_id, player_id, assist_player_id, is_own_goal, is_penalty, minute, event_order, created_at, player:players!match_events_player_id_fkey(id, display_name), assist:players!match_events_assist_player_id_fkey(id, display_name)"
            )
            .in("match_id", matchIds)
            .order("event_order")
            .order("created_at"),
        ]);

        if (lineupsResult.error) throw lineupsResult.error;
        if (rostersResult.error) throw rostersResult.error;
        if (eventsResult.error) throw eventsResult.error;

        nextLineups = Object.fromEntries(
          Object.entries(groupRowsByMatch(lineupsResult.data || [])).map(([matchId, rows]) => [
            matchId,
            sortLineups(rows),
          ])
        );
        nextRosters = Object.fromEntries(
          nextMatches.map((match) => [
            match.id,
            sortRosterRows((rostersResult.data || []).filter((row) =>
              row.season_id === match.season_id &&
              (row.team_id === match.home_team_id || row.team_id === match.away_team_id)
            )),
          ])
        );
        nextEvents = Object.fromEntries(
          Object.entries(groupRowsByMatch(eventsResult.data || [])).map(([matchId, rows]) => [
            matchId,
            sortEvents(rows),
          ])
        );
      }

      setMatches(nextMatches);
      setAssignmentsByMatchId(nextAssignments);
      setLineupsByMatchId(nextLineups);
      setRostersByMatchId(nextRosters);
      setEventsByMatchId(nextEvents);
      setActiveFormMatchId((current) => {
        if (!current || matchIds.includes(current)) return current;
        return "";
      });
      setAttendanceEditor((current) => (
        current.matchId && !matchIds.includes(current.matchId) ? EMPTY_ATTENDANCE_EDITOR : current
      ));
      setActiveTransferMatchId((current) => (current && !matchIds.includes(current) ? "" : current));
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się załadować aktywnych meczów." });
    } finally {
      setLoading(false);
    }
  }, [assignmentFeatureMissing, isAdmin, user?.id]);

  useEffect(() => {
    loadActiveMatches();
    loadDutyUsers();
  }, [loadActiveMatches, loadDutyUsers]);

  const activeMatch = useMemo(
    () => matches.find((match) => match.id === activeFormMatchId) || null,
    [matches, activeFormMatchId]
  );

  const activeEventPlayerTeamId = activeMatch
    ? getEventPlayerTeamId(activeMatch, eventForm.teamId, eventForm.eventType)
    : "";
  const activeTeamPlayers = activeMatch
    ? getPlayersForMatchTeam(activeMatch, rostersByMatchId, lineupsByMatchId, activeEventPlayerTeamId)
    : [];
  const selectedTeamPlayers = buildPlayerOptions(activeTeamPlayers);
  const assistantOptions = buildPlayerOptions(activeTeamPlayers, eventForm.playerId);

  function canManageMatch(match) {
    if (!match?.id) return false;
    if (assignmentFeatureMissing || isAdmin) return true;
    return assignmentsByMatchId[match.id]?.assigned_to === user?.id;
  }

  function openTransferPanel(match) {
    const assignment = assignmentsByMatchId[match.id] || {};
    setActiveTransferMatchId((current) => (current === match.id ? "" : match.id));
    setTransferTargetId(assignment.assigned_to || user?.id || "");
    loadDutyUsers();
  }

  function openEventForm(match) {
    if (!canManageMatch(match)) {
      setAlert({ type: "error", message: "Ten aktywny mecz jest przypisany do innego dyżurnego." });
      return;
    }

    const defaultTeamId = match.home_team_id;
    const options = buildPlayerOptions(getPlayersForMatchTeam(match, rostersByMatchId, lineupsByMatchId, defaultTeamId));

    setActiveFormMatchId(match.id);
    setEditingEventId("");
    setEventForm({
      teamId: defaultTeamId,
      playerId: firstSelectableOption(options),
      eventType: "GOAL",
      assistPlayerId: "none",
    });
  }

  function openEditEventForm(match, event) {
    if (!canManageMatch(match)) {
      setAlert({ type: "error", message: "Ten aktywny mecz jest przypisany do innego dyżurnego." });
      return;
    }

    const isOwnGoal = isOwnGoalEvent(event);
    const teamId = isOwnGoal ? getOwnGoalScoringTeamId(match, event) : event.team_id || match.home_team_id;
    const eventType = isOwnGoal ? "OWN_GOAL" : event.event_type || "GOAL";
    const playerTeamId = getEventPlayerTeamId(match, teamId, eventType);
    const options = buildPlayerOptions(getPlayersForMatchTeam(match, rostersByMatchId, lineupsByMatchId, playerTeamId));

    setActiveFormMatchId(match.id);
    setEditingEventId(event.id);
    setEventForm({
      teamId,
      playerId: event.player_id || firstSelectableOption(options),
      eventType,
      assistPlayerId: event.assist_player_id || "none",
    });

    window.setTimeout(() => {
      document.getElementById(`active-match-event-form-${match.id}`)?.scrollIntoView({
        behavior: "smooth",
        block: "start",
      });
    }, 0);
  }

  function updateFormField(field, value) {
    setEventForm((prev) => {
      const next = { ...prev, [field]: value };
      if (field === "teamId" || field === "eventType") {
        const nextTeamId = field === "teamId" ? value : next.teamId;
        const nextEventType = field === "eventType" ? value : next.eventType;
        const playerTeamId = activeMatch ? getEventPlayerTeamId(activeMatch, nextTeamId, nextEventType) : "";
        const options = activeMatch
          ? buildPlayerOptions(getPlayersForMatchTeam(activeMatch, rostersByMatchId, lineupsByMatchId, playerTeamId))
          : [];
        next.playerId = firstSelectableOption(options);
        next.assistPlayerId = "none";
      }
      if (field === "playerId") {
        next.assistPlayerId = "none";
      }
      return next;
    });
  }

  function openAttendanceEditor(match, teamId) {
    if (!canManageMatch(match)) {
      setAlert({ type: "error", message: "Ten aktywny mecz jest przypisany do innego dyżurnego." });
      return;
    }

    const players = getPlayersForMatchTeam(match, rostersByMatchId, lineupsByMatchId, teamId);
    setAttendanceEditor({
      matchId: match.id,
      teamId,
      draftIds: players.filter((row) => row.present).map((row) => row.player_id),
    });
  }

  function toggleAttendancePlayer(playerId) {
    setAttendanceEditor((prev) => {
      const current = new Set(prev.draftIds || []);
      if (current.has(playerId)) current.delete(playerId);
      else current.add(playerId);
      return { ...prev, draftIds: Array.from(current) };
    });
  }

  async function saveAttendance(match, teamId) {
    if (!match?.id || !teamId) return;
    if (!canManageMatch(match)) {
      setAlert({ type: "error", message: "Nie możesz modyfikować meczu przypisanego do innego dyżurnego." });
      return;
    }

    setSavingAttendance(true);
    try {
      const allPlayers = getPlayersForMatchTeam(match, rostersByMatchId, lineupsByMatchId, teamId);
      const playersById = new Map(allPlayers.map((row) => [row.player_id, row]));
      const currentIds = new Set(getTeamLineups(match, lineupsByMatchId, teamId).map((row) => row.player_id));
      const draftIds = new Set(attendanceEditor.draftIds || []);
      const toInsert = Array.from(draftIds).filter((playerId) => !currentIds.has(playerId));
      const toDelete = Array.from(currentIds).filter((playerId) => !draftIds.has(playerId));

      if (toDelete.length > 0) {
        const { error: deleteError } = await supabase
          .from("match_lineups")
          .delete()
          .eq("match_id", match.id)
          .eq("team_id", teamId)
          .in("player_id", toDelete);
        if (deleteError) throw deleteError;
      }

      if (toInsert.length > 0) {
        const payload = toInsert
          .map((playerId) => playersById.get(playerId))
          .filter(Boolean)
          .map((row) => buildLineupPayload(match, teamId, row));

        if (payload.length > 0) {
          const { error: insertError } = await supabase.from("match_lineups").insert(payload);
          if (insertError) throw insertError;
        }
      }

      const { error: auditError } = await supabase.rpc("touch_match_result_edit", { p_match_id: match.id });
      if (auditError) {
        console.warn("Match result audit update:", auditError.message);
      }

      setAlert({ type: "success", message: "Lista obecności została zapisana." });
      setAttendanceEditor(EMPTY_ATTENDANCE_EDITOR);
      await loadActiveMatches();
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się zapisać listy obecności." });
    } finally {
      setSavingAttendance(false);
    }
  }

  async function ensurePlayersPresent(match, teamId, playerIds) {
    const uniquePlayerIds = Array.from(new Set((playerIds || []).filter(Boolean)));
    if (!match?.id || !teamId || uniquePlayerIds.length === 0) return;

    const currentIds = new Set(getTeamLineups(match, lineupsByMatchId, teamId).map((row) => row.player_id));
    const allPlayers = getPlayersForMatchTeam(match, rostersByMatchId, lineupsByMatchId, teamId);
    const playersById = new Map(allPlayers.map((row) => [row.player_id, row]));
    const payload = uniquePlayerIds
      .filter((playerId) => !currentIds.has(playerId))
      .map((playerId) => playersById.get(playerId))
      .filter(Boolean)
      .map((row) => buildLineupPayload(match, teamId, row));

    if (payload.length === 0) return;

    const { error } = await supabase.from("match_lineups").insert(payload);
    if (error && error.code !== "23505") throw error;
  }

  async function saveEvent() {
    if (!activeMatch?.id) return;
    if (!canManageMatch(activeMatch)) {
      setAlert({ type: "error", message: "Nie możesz dopisywać zdarzeń w meczu przypisanym do innego dyżurnego." });
      return;
    }

    const teamIds = [activeMatch.home_team_id, activeMatch.away_team_id];
    if (!teamIds.includes(eventForm.teamId)) {
      setAlert({ type: "error", message: "Wybierz drużynę zdarzenia." });
      return;
    }
    if (!eventForm.playerId || eventForm.playerId === ABSENT_SEPARATOR_VALUE) {
      setAlert({ type: "error", message: "Wybierz zawodnika." });
      return;
    }
    if (!eventForm.eventType) {
      setAlert({ type: "error", message: "Wybierz rodzaj zdarzenia." });
      return;
    }

    setSaving(true);
    try {
      const currentEvents = eventsByMatchId[activeMatch.id] || [];
      const editedEvent = editingEventId ? currentEvents.find((event) => event.id === editingEventId) : null;
      if (editingEventId && !editedEvent) {
        setAlert({ type: "error", message: "Nie znaleziono edytowanego zdarzenia. Odśwież mecz i spróbuj ponownie." });
        return;
      }

      const isOwnGoal = eventForm.eventType === "OWN_GOAL";
      const eventPlayerTeamId = getEventPlayerTeamId(activeMatch, eventForm.teamId, eventForm.eventType);
      if (!eventPlayerTeamId) {
        setAlert({ type: "error", message: "Nie udało się ustalić drużyny zawodnika dla tego zdarzenia." });
        return;
      }

      const lineupPlayerIds = [eventForm.playerId];
      if (!isOwnGoal && eventForm.eventType === "GOAL" && eventForm.assistPlayerId && eventForm.assistPlayerId !== "none") {
        lineupPlayerIds.push(eventForm.assistPlayerId);
      }
      await ensurePlayersPresent(activeMatch, eventPlayerTeamId, lineupPlayerIds);

      const nextOrder = currentEvents.reduce((max, event) => Math.max(max, Number(event.event_order || 0)), 0) + 1;
      const payload = {
        event_type: isOwnGoal ? "GOAL" : eventForm.eventType,
        team_id: eventPlayerTeamId,
        player_id: eventForm.playerId,
        assist_player_id: !isOwnGoal && eventForm.eventType === "GOAL" && eventForm.assistPlayerId !== "none" ? eventForm.assistPlayerId : null,
        is_penalty: !isOwnGoal && (editedEvent?.is_penalty ?? false),
        is_own_goal: isOwnGoal,
        minute: editedEvent?.minute ?? null,
        event_order: editedEvent?.event_order ?? nextOrder,
      };

      if (editedEvent) {
        const { error: updateError } = await supabase
          .from("match_events")
          .update(payload)
          .eq("id", editedEvent.id)
          .eq("match_id", activeMatch.id);
        if (updateError) throw updateError;
      } else {
        const { error: insertError } = await supabase
          .from("match_events")
          .insert({ match_id: activeMatch.id, ...payload });
        if (insertError) throw insertError;
      }

      const savedEvent = {
        ...(editedEvent || {}),
        ...payload,
        id: editedEvent?.id || "__new_event__",
        match_id: activeMatch.id,
      };
      const nextEvents = editedEvent
        ? currentEvents.map((event) => (event.id === editedEvent.id ? savedEvent : event))
        : [...currentEvents, savedEvent];
      const nextScore = calculateScore(activeMatch, nextEvents);
      const { error: scoreError } = await supabase
        .from("matches")
        .update({
          home_goals: nextScore.home,
          away_goals: nextScore.away,
        })
        .eq("id", activeMatch.id);
      if (scoreError) throw scoreError;

      const { error: auditError } = await supabase.rpc("touch_match_result_edit", { p_match_id: activeMatch.id });
      if (auditError) {
        console.warn("Match result audit update:", auditError.message);
      }

      setAlert({ type: "success", message: editedEvent ? "Zdarzenie zostało zaktualizowane." : "Zdarzenie zostało dodane." });
      notifyMatchDataUpdated({
        matchId: activeMatch.id,
        source: editedEvent ? "active-match-event-edited" : "active-match-event",
      });
      await loadActiveMatches();
      setEditingEventId("");
      setEventForm((prev) => ({
        ...prev,
        playerId: "",
        assistPlayerId: "none",
      }));
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się zapisać zdarzenia." });
    } finally {
      setSaving(false);
    }
  }

  async function finishMatch(match) {
    if (!match?.id) return;
    if (!canManageMatch(match)) {
      setAlert({ type: "error", message: "Nie możesz zakończyć meczu przypisanego do innego dyżurnego." });
      return;
    }

    const events = eventsByMatchId[match.id] || [];
    const score = calculateScore(match, events);
    const confirmed = window.confirm(
      `Zakończyć mecz ${match.home_team_name} - ${match.away_team_name} wynikiem ${score.home} - ${score.away}?`
    );
    if (!confirmed) return;

    setFinishingMatchId(match.id);
    try {
      const { error: updateError } = await supabase
        .from("matches")
        .update({
          home_goals: score.home,
          away_goals: score.away,
          status: "completed",
        })
        .eq("id", match.id);
      if (updateError) throw updateError;

      const { error: auditError } = await supabase.rpc("touch_match_result_edit", { p_match_id: match.id });
      if (auditError) {
        console.warn("Match result audit update:", auditError.message);
      }

      setAlert({ type: "success", message: `Mecz zakończony i zapisany wynikiem ${score.home} - ${score.away}.` });
      setActiveFormMatchId((current) => (current === match.id ? "" : current));
      setEditingEventId("");
      setAttendanceEditor((current) => (current.matchId === match.id ? EMPTY_ATTENDANCE_EDITOR : current));
      notifyMatchDataUpdated({ matchId: match.id, source: "active-match-finished" });
      await loadActiveMatches();
    } catch (error) {
      setAlert({ type: "error", message: error.message || "Nie udało się zakończyć meczu." });
    } finally {
      setFinishingMatchId("");
    }
  }

  async function transferMatch(match) {
    if (!match?.id) return;
    if (!canManageMatch(match)) {
      setAlert({ type: "error", message: "Tylko aktualny dyżurny albo superadmin może przekazać ten mecz." });
      return;
    }
    if (!transferTargetId) {
      setAlert({ type: "error", message: "Wybierz osobę, która ma przejąć dyżur." });
      return;
    }

    setTransferringMatchId(match.id);
    try {
      const { error } = await supabase.rpc("transfer_active_match_assignment", {
        p_match_id: match.id,
        p_assigned_to: transferTargetId,
      });
      if (error) throw error;

      const target = dutyUsers.find((item) => item.id === transferTargetId);
      setAlert({
        type: "success",
        message: `Dyżur przekazany: ${target?.label || "wybrany dyżurny"}.`,
      });
      setActiveTransferMatchId("");
      setTransferTargetId("");
      notifyMatchDataUpdated({ matchId: match.id, source: "active-match-duty-transfer" });
      await loadActiveMatches();
    } catch (error) {
      if (isMissingActiveMatchDutyFeature(error)) {
        setAssignmentFeatureMissing(true);
        setAlert({
          type: "error",
          message: "Brakuje migracji dyżurów aktywnego meczu w bazie. Uruchom migrację 022_active_match_assignments.sql.",
        });
      } else {
        setAlert({ type: "error", message: error.message || "Nie udało się przekazać dyżuru." });
      }
    } finally {
      setTransferringMatchId("");
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
    <div className="max-w-full space-y-6 overflow-hidden">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div className="min-w-0">
          <h2 className="text-2xl font-bold">Aktywny mecz</h2>
          <p className={`mt-1 text-sm ${mutedText}`}>
            Prosty panel do dopisywania zdarzeń w meczach ze statusem "Rozpoczęty".
          </p>
        </div>
        <button
          type="button"
          onClick={loadActiveMatches}
          className={`inline-flex w-full items-center justify-center gap-2 rounded-xl border px-4 py-2 text-sm font-semibold sm:w-auto ${
            darkMode ? "border-white/10 bg-white/5 hover:bg-white/10" : "border-gray-200 bg-white hover:bg-gray-50"
          }`}
        >
          <RefreshCw size={16} />
          Odśwież
        </button>
      </div>

      <AdminAlert
        type={alert.type}
        message={alert.message}
        onClose={() => setAlert({ type: null, message: null })}
      />

      {matches.length === 0 ? (
        <div className={`rounded-2xl border p-8 text-center ${cardClass}`}>
          <Radio size={28} className="mx-auto mb-3 opacity-70" />
          <div className="text-lg font-bold">
            {isAdmin || assignmentFeatureMissing ? "Brak rozpoczętego meczu" : "Brak meczu przypisanego do Ciebie"}
          </div>
          <p className={`mt-1 text-sm ${mutedText}`}>
            {isAdmin || assignmentFeatureMissing
              ? "Najpierw ustaw status meczu na \"Rozpoczęty\" w zakładce Wyniki i zapisz listę obecności."
              : "Jeśli przejmujesz dyżur, obecny dyżurny albo superadmin musi przekazać Ci uprawnienia do meczu."}
          </p>
        </div>
      ) : (
        <div className="grid gap-4">
          {matches.map((match) => {
            const events = eventsByMatchId[match.id] || [];
            const homePlayers = getPlayersForMatchTeam(match, rostersByMatchId, lineupsByMatchId, match.home_team_id);
            const awayPlayers = getPlayersForMatchTeam(match, rostersByMatchId, lineupsByMatchId, match.away_team_id);
            const score = calculateScore(match, events);
            const isFormOpen = activeFormMatchId === match.id;
            const editedEvent = isFormOpen && editingEventId ? events.find((event) => event.id === editingEventId) : null;
            const homeCount = homePlayers.filter((row) => row.present).length;
            const awayCount = awayPlayers.filter((row) => row.present).length;
            const isAttendanceOpen = attendanceEditor.matchId === match.id;
            const attendancePlayers = isAttendanceOpen
              ? getPlayersForMatchTeam(match, rostersByMatchId, lineupsByMatchId, attendanceEditor.teamId)
              : [];
            const attendanceTeamName = getTeamName(match, attendanceEditor.teamId);
            const selectableEventPlayers = isFormOpen ? selectedTeamPlayers.filter((option) => !option.disabled) : [];
            const isFinishing = finishingMatchId === match.id;
            const isTransferring = transferringMatchId === match.id;
            const assignment = assignmentsByMatchId[match.id] || {};
            const assignedLabel = assignmentFeatureMissing
              ? "tryb zgodności"
              : assignment.assigned_to_name_snapshot || "Nieprzypisany";
            const canManage = canManageMatch(match);
            const isTransferOpen = activeTransferMatchId === match.id;

            return (
              <div key={match.id} className={`max-w-full overflow-hidden rounded-2xl border p-4 shadow-sm ${cardClass}`}>
                <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
                  <div className="min-w-0 flex-1">
                    <div className={`max-w-full break-words text-[11px] font-bold uppercase leading-relaxed tracking-[0.08em] sm:text-xs sm:tracking-[0.16em] ${mutedText}`}>
                      {match.league_name || match.league_code || "Liga"} {formatMatchMoment(match) ? `- ${formatMatchMoment(match)}` : ""}
                    </div>
                    <div className={`mt-2 inline-flex max-w-full items-center gap-2 rounded-full border px-3 py-1 text-[11px] font-bold ${
                      darkMode ? "border-white/10 bg-white/5 text-gray-200" : "border-gray-200 bg-gray-50 text-gray-700"
                    }`}>
                      <span className="shrink-0">Dyżur:</span>
                      <span className="min-w-0 truncate">{assignedLabel}</span>
                    </div>
                    <div className="mt-3 grid grid-cols-2 items-start gap-3 sm:grid-cols-[minmax(0,1fr)_auto_minmax(0,1fr)] sm:items-center">
                      <div className="order-2 min-w-0 text-center sm:order-1 sm:text-right">
                        <div className="truncate text-lg font-black">{match.home_team_name}</div>
                        <div className={`text-xs ${mutedText}`}>Obecność: {homeCount}</div>
                        <button
                          type="button"
                          onClick={() => openAttendanceEditor(match, match.home_team_id)}
                          disabled={!canManage}
                          className={`mt-1 max-w-full text-[10px] font-bold uppercase tracking-normal sm:text-[11px] sm:tracking-[0.08em] ${
                            darkMode ? "text-emerald-300 hover:text-emerald-200" : "text-emerald-700 hover:text-emerald-800"
                          } disabled:opacity-40`}
                        >
                          Popraw listę
                        </button>
                      </div>
                      <div className={`order-1 col-span-2 justify-self-center rounded-2xl border px-5 py-3 text-center sm:order-2 sm:col-span-1 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"}`}>
                        <div className="text-3xl font-black leading-none">{score.home} - {score.away}</div>
                        <div className={`mt-1 text-[11px] font-bold uppercase tracking-[0.12em] ${mutedText}`}>Rozpoczęty</div>
                      </div>
                      <div className="order-3 min-w-0 text-center sm:text-left">
                        <div className="truncate text-lg font-black">{match.away_team_name}</div>
                        <div className={`text-xs ${mutedText}`}>Obecność: {awayCount}</div>
                        <button
                          type="button"
                          onClick={() => openAttendanceEditor(match, match.away_team_id)}
                          disabled={!canManage}
                          className={`mt-1 max-w-full text-[10px] font-bold uppercase tracking-normal sm:text-[11px] sm:tracking-[0.08em] ${
                            darkMode ? "text-emerald-300 hover:text-emerald-200" : "text-emerald-700 hover:text-emerald-800"
                          } disabled:opacity-40`}
                        >
                          Popraw listę
                        </button>
                      </div>
                    </div>
                  </div>

                  <div className="flex w-full flex-col gap-2 lg:w-auto">
                    <button
                      type="button"
                      onClick={() => openEventForm(match)}
                      disabled={isFinishing || !canManage}
                      className="inline-flex min-h-[46px] w-full max-w-full items-center justify-center gap-2 rounded-xl bg-green-500 px-4 py-3 text-sm font-bold text-black hover:bg-green-400 disabled:opacity-60"
                    >
                      <Plus size={16} />
                      Dodaj zdarzenie
                    </button>
                    {!assignmentFeatureMissing && canManage && (
                      <button
                        type="button"
                        onClick={() => openTransferPanel(match)}
                        disabled={isFinishing || saving || savingAttendance || isTransferring}
                        className={`inline-flex min-h-[44px] w-full max-w-full items-center justify-center gap-2 rounded-xl border px-4 py-2 text-sm font-bold disabled:opacity-60 ${
                          darkMode
                            ? "border-sky-400/30 bg-sky-500/10 text-sky-100 hover:bg-sky-500/20"
                            : "border-sky-200 bg-sky-50 text-sky-700 hover:bg-sky-100"
                        }`}
                      >
                        <Send size={15} />
                        Przekaż uprawnienia
                      </button>
                    )}
                    <button
                      type="button"
                      onClick={() => finishMatch(match)}
                      disabled={isFinishing || saving || savingAttendance || !canManage}
                      className={`inline-flex min-h-[46px] w-full max-w-full items-center justify-center gap-2 rounded-xl border px-4 py-3 text-sm font-bold disabled:opacity-60 ${
                        darkMode
                          ? "border-red-400/40 bg-red-500/15 text-red-100 hover:bg-red-500/25"
                          : "border-red-200 bg-red-50 text-red-700 hover:bg-red-100"
                      }`}
                    >
                      {isFinishing ? <Loader2 size={16} className="animate-spin" /> : <CheckCircle2 size={16} />}
                      Zakończ mecz
                    </button>
                  </div>
                </div>

                {isTransferOpen && canManage && (
                  <div className={`mt-4 rounded-2xl border p-4 ${darkMode ? "border-sky-400/20 bg-sky-500/10" : "border-sky-200 bg-sky-50"}`}>
                    <div className="grid gap-3 sm:grid-cols-[minmax(0,1fr)_auto] sm:items-end">
                      <AdminFormField
                        label="Przekaż dyżur"
                        name="transfer_to"
                        type="select"
                        value={transferTargetId}
                        onChange={(event) => setTransferTargetId(event.target.value)}
                        darkMode={darkMode}
                        options={dutyUsers.map((item) => ({
                          value: item.id,
                          label: `${item.label}${item.role === "admin" ? " (superadmin)" : ""}`,
                        }))}
                        includeEmptyOption
                        disabled={isTransferring || dutyUsers.length === 0}
                      />
                      <button
                        type="button"
                        onClick={() => transferMatch(match)}
                        disabled={isTransferring || !transferTargetId}
                        className="inline-flex min-h-[44px] items-center justify-center gap-2 rounded-xl bg-sky-500 px-4 py-2 text-sm font-bold text-white hover:bg-sky-400 disabled:opacity-60"
                      >
                        {isTransferring ? <Loader2 size={16} className="animate-spin" /> : <Send size={16} />}
                        Przekaż
                      </button>
                    </div>
                    <div className={`mt-2 text-xs ${mutedText}`}>
                      Po przekazaniu zwykły dyżurny traci edycję tego meczu, a nowy dyżurny zobaczy go w swojej zakładce.
                    </div>
                  </div>
                )}

                {isAttendanceOpen && (
                  <div className={`mt-4 max-w-full overflow-hidden rounded-2xl border p-4 ${darkMode ? "border-emerald-400/20 bg-emerald-500/10" : "border-emerald-200 bg-emerald-50"}`}>
                    <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                      <div>
                        <div className="text-sm font-black">Popraw listę: {attendanceTeamName}</div>
                        <div className={`text-xs ${mutedText}`}>
                          Zaznaczeni zawodnicy będą liczeni jako obecni w meczu.
                        </div>
                      </div>
                      <div className={`text-xs font-bold ${mutedText}`}>
                        Wybrano: {attendanceEditor.draftIds.length}/{attendancePlayers.length}
                      </div>
                    </div>

                    {attendancePlayers.length === 0 ? (
                      <div className={`mt-3 rounded-xl border px-3 py-3 text-sm ${darkMode ? "border-yellow-400/30 bg-yellow-500/10 text-yellow-100" : "border-yellow-200 bg-yellow-50 text-yellow-800"}`}>
                        Brak zawodników w kadrze tej drużyny.
                      </div>
                    ) : (
                      <div className="mt-3 grid gap-2 sm:grid-cols-2 lg:grid-cols-3">
                        {attendancePlayers.map((player) => {
                          const checked = attendanceEditor.draftIds.includes(player.player_id);
                          return (
                            <label
                              key={player.player_id}
                              className={`flex items-center gap-2 rounded-xl border px-3 py-2 text-sm ${
                                checked
                                  ? darkMode
                                    ? "border-emerald-400/50 bg-emerald-500/15"
                                    : "border-emerald-300 bg-white"
                                  : darkMode
                                    ? "border-white/10 bg-black/10"
                                    : "border-gray-200 bg-white/70"
                              }`}
                            >
                              <input
                                type="checkbox"
                                checked={checked}
                                onChange={() => toggleAttendancePlayer(player.player_id)}
                                disabled={savingAttendance}
                                className="h-4 w-4 shrink-0"
                              />
                              <span className="min-w-0 truncate font-semibold">{playerName(player)}</span>
                            </label>
                          );
                        })}
                      </div>
                    )}

                    <div className="mt-4 flex flex-col gap-2 sm:flex-row sm:justify-end">
                      <button
                        type="button"
                        onClick={() => setAttendanceEditor(EMPTY_ATTENDANCE_EDITOR)}
                        disabled={savingAttendance}
                        className={`min-h-[42px] rounded-xl border px-4 py-2 text-sm font-semibold ${
                          darkMode ? "border-white/10 bg-white/5 hover:bg-white/10" : "border-gray-200 bg-white hover:bg-gray-50"
                        } disabled:opacity-60`}
                      >
                        Anuluj
                      </button>
                      <button
                        type="button"
                        onClick={() => saveAttendance(match, attendanceEditor.teamId)}
                        disabled={savingAttendance || attendancePlayers.length === 0 || !canManage}
                        className="inline-flex min-h-[42px] items-center justify-center gap-2 rounded-xl bg-green-500 px-4 py-2 text-sm font-bold text-black hover:bg-green-400 disabled:opacity-60"
                      >
                        {savingAttendance ? <Loader2 size={16} className="animate-spin" /> : <Check size={16} />}
                        Zatwierdź listę
                      </button>
                    </div>
                  </div>
                )}

                {isFormOpen && (
                  <div
                    id={`active-match-event-form-${match.id}`}
                    className={`mt-4 max-w-full overflow-hidden rounded-2xl border p-4 ${darkMode ? "border-white/10 bg-black/15" : "border-gray-200 bg-gray-50"}`}
                  >
                    <div className="mb-3 flex flex-col gap-1 sm:flex-row sm:items-center sm:justify-between">
                      <div className="text-sm font-black">
                        {editedEvent ? "Edytuj zdarzenie" : "Dodaj zdarzenie"}
                      </div>
                      {editedEvent && (
                        <div className={`text-xs ${mutedText}`}>
                          Po zapisie wynik LIVE zostanie przeliczony.
                        </div>
                      )}
                    </div>
                    <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-4">
                      <AdminFormField
                        label={eventForm.eventType === "OWN_GOAL" ? "Gol dla" : "Drużyna"}
                        name="team_id"
                        type="select"
                        value={eventForm.teamId}
                        onChange={(event) => updateFormField("teamId", event.target.value)}
                        darkMode={darkMode}
                        options={[
                          { value: match.home_team_id, label: match.home_team_name },
                          { value: match.away_team_id, label: match.away_team_name },
                        ]}
                        disabled={saving}
                      />
                      <AdminFormField
                        label={eventForm.eventType === "OWN_GOAL" ? "Zawodnik strzelający samobója" : "Zawodnik"}
                        name="player_id"
                        type="select"
                        value={eventForm.playerId}
                        onChange={(event) => updateFormField("playerId", event.target.value)}
                        darkMode={darkMode}
                        options={selectedTeamPlayers}
                        disabled={saving}
                      />
                      <AdminFormField
                        label="Rodzaj zdarzenia"
                        name="event_type"
                        type="select"
                        value={eventForm.eventType}
                        onChange={(event) => updateFormField("eventType", event.target.value)}
                        darkMode={darkMode}
                        options={EVENT_TYPE_OPTIONS}
                        disabled={saving}
                      />
                      {eventForm.eventType === "GOAL" && (
                        <AdminFormField
                          label="Asystent"
                          name="assist_player_id"
                          type="select"
                          value={eventForm.assistPlayerId}
                          onChange={(event) => updateFormField("assistPlayerId", event.target.value)}
                          darkMode={darkMode}
                          options={[{ value: "none", label: "- BRAK -" }, ...assistantOptions]}
                          disabled={saving}
                          includeEmptyOption={false}
                        />
                      )}
                    </div>
                    {selectableEventPlayers.length === 0 && (
                      <div className={`mt-3 rounded-xl border px-3 py-2 text-sm ${darkMode ? "border-yellow-400/30 bg-yellow-500/10 text-yellow-100" : "border-yellow-200 bg-yellow-50 text-yellow-800"}`}>
                        Ta drużyna nie ma zawodników do wyboru. Sprawdź kadrę albo popraw listę obecności.
                      </div>
                    )}
                    <div className="mt-4 flex flex-col gap-2 sm:flex-row sm:justify-end">
                      <button
                        type="button"
                        onClick={() => {
                          setActiveFormMatchId("");
                          setEditingEventId("");
                          setEventForm(EMPTY_EVENT_FORM);
                        }}
                        disabled={saving}
                        className={`min-h-[44px] rounded-xl border px-4 py-2 text-sm font-semibold ${
                          darkMode ? "border-white/10 bg-white/5 hover:bg-white/10" : "border-gray-200 bg-white hover:bg-gray-50"
                        } disabled:opacity-60`}
                      >
                        Anuluj
                      </button>
                      <button
                        type="button"
                        onClick={saveEvent}
                        disabled={saving || selectableEventPlayers.length === 0 || !eventForm.playerId || !canManage}
                        className="inline-flex min-h-[44px] items-center justify-center gap-2 rounded-xl bg-green-500 px-4 py-2 text-sm font-bold text-black hover:bg-green-400 disabled:opacity-60"
                      >
                        {saving ? <Loader2 size={16} className="animate-spin" /> : <Check size={16} />}
                        {editedEvent ? "Zapisz zmianę" : "Zatwierdź"}
                      </button>
                    </div>
                  </div>
                )}

                <div className="mt-4">
                  <div className={`mb-2 text-xs font-bold uppercase tracking-[0.14em] ${mutedText}`}>
                    Zdarzenia meczu
                  </div>
                  {events.length === 0 ? (
                    <div className={`rounded-xl border px-3 py-3 text-sm ${darkMode ? "border-white/10 bg-white/5 text-gray-400" : "border-gray-200 bg-gray-50 text-gray-500"}`}>
                      Brak zdarzeń. Dodaj pierwsze zdarzenie przyciskiem powyżej.
                    </div>
                  ) : (
                    <div className="grid gap-2">
                      {events.slice().reverse().map((event) => (
                        <div
                          key={event.id}
                          className={`grid max-w-full gap-1 rounded-xl border px-3 py-2 text-sm sm:grid-cols-[minmax(0,1fr)_auto] sm:items-center ${
                            darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50"
                          }`}
                        >
                          <div className="min-w-0">
                            <div className="flex min-w-0 flex-wrap items-center gap-x-2 gap-y-1">
                              <span className={`shrink-0 rounded-full border px-2 py-1 text-[11px] font-bold ${eventBadgeClass(event.event_type, darkMode, isOwnGoalEvent(event))}`}>
                                {eventLabel(event.event_type, isOwnGoalEvent(event))}
                              </span>
                              <span className="min-w-0 max-w-full break-words font-semibold leading-snug">
                                {eventPlayerName(event)}
                              </span>
                            </div>
                            {event.assist_player_id && (
                              <div className={`mt-1 min-w-0 break-words text-xs leading-snug ${mutedText}`}>
                                asysta: <span className="font-semibold">{eventPlayerName(event, "assist")}</span>
                              </div>
                            )}
                          </div>
                          <div className="flex min-w-0 flex-wrap items-center gap-2 sm:justify-end">
                            <span className={`min-w-0 break-words text-xs leading-snug ${mutedText}`}>
                              {getEventTeamLabel(match, event)}
                            </span>
                            {canManage && (
                              <button
                                type="button"
                                onClick={() => openEditEventForm(match, event)}
                                disabled={saving || isFinishing}
                                className={`inline-flex min-h-[30px] shrink-0 items-center gap-1 rounded-lg border px-2 py-1 text-[11px] font-bold disabled:opacity-50 ${
                                  darkMode
                                    ? "border-white/10 bg-white/5 text-gray-100 hover:bg-white/10"
                                    : "border-gray-200 bg-white text-gray-700 hover:bg-gray-100"
                                }`}
                              >
                                <Pencil size={12} />
                                Edytuj
                              </button>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
