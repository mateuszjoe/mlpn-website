const fs = require("fs");
const path = require("path");

const ESPN_SCOREBOARD_URL = "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.world/scoreboard";
const ESPN_DATES = process.env.WORLD_CUP_ESPN_DATES || "20260611-20260720";
const DRY_RUN = process.argv.includes("--dry-run");

function readEnvFile() {
  const envPath = path.resolve(".env.local");
  const values = {};

  if (!fs.existsSync(envPath)) return values;

  for (const line of fs.readFileSync(envPath, "utf8").split(/\r?\n/)) {
    const match = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$/);
    if (!match) continue;

    let value = match[2].trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    values[match[1]] = value;
  }

  return values;
}

function getEnv(name, envFile) {
  return process.env[name] || envFile[name] || "";
}

function getSupabaseUrl(envFile) {
  return (
    getEnv("SUPABASE_URL", envFile) ||
    getEnv("REACT_APP_SUPABASE_URL", envFile) ||
    getEnv("VITE_SUPABASE_URL", envFile)
  );
}

function getServiceKey(envFile) {
  return (
    getEnv("SUPABASE_SERVICE_KEY", envFile) ||
    getEnv("SUPABASE_SERVICE_ROLE_KEY", envFile) ||
    getEnv("SUPABASE_SECRET_KEY", envFile)
  );
}

// --- Supabase REST (PostgREST) helpers -------------------------------------
// Celowo NIE używamy bezpośredniego połączenia pg/pooler: hasło bazy bywa
// nieaktualne i pooler odrzuca logowanie. Klucz serwisowy przez REST omija RLS
// i działa zarówno lokalnie, jak i w GitHub Actions (sekret SUPABASE_SERVICE_KEY).

function createRest(baseUrl, serviceKey) {
  const root = baseUrl.replace(/\/$/, "");
  const headers = {
    apikey: serviceKey,
    Authorization: `Bearer ${serviceKey}`,
    "Content-Type": "application/json",
  };

  async function request(method, pathAndQuery, { body, prefer } = {}) {
    const response = await fetch(`${root}/rest/v1/${pathAndQuery}`, {
      method,
      headers: prefer ? { ...headers, Prefer: prefer } : headers,
      body: body == null ? undefined : JSON.stringify(body),
    });

    const text = await response.text();
    if (!response.ok) {
      throw new Error(`Supabase REST ${method} ${pathAndQuery} -> HTTP ${response.status}: ${text}`);
    }

    return text ? JSON.parse(text) : null;
  }

  return { request };
}

async function fetchEspnEvents() {
  const url = new URL(ESPN_SCOREBOARD_URL);
  url.searchParams.set("limit", "500");
  url.searchParams.set("dates", ESPN_DATES);

  const response = await fetch(url, {
    headers: {
      "user-agent": "mlpn-world-cup-typer-sync/1.0",
      accept: "application/json",
    },
  });

  if (!response.ok) {
    throw new Error(`ESPN zwrocil HTTP ${response.status}.`);
  }

  const data = await response.json();
  const events = Array.isArray(data.events) ? data.events.map(normalizeEspnEvent).filter(Boolean) : [];

  if (events.length < 64) {
    throw new Error(`ESPN zwrocil za malo meczow: ${events.length}.`);
  }

  return events.sort(compareByKickoff);
}

function normalizeEspnEvent(event) {
  const competition = Array.isArray(event.competitions) ? event.competitions[0] : null;
  const competitors = Array.isArray(competition?.competitors) ? competition.competitors : [];
  const home = competitors.find((competitor) => competitor.homeAway === "home") || null;
  const away = competitors.find((competitor) => competitor.homeAway === "away") || null;
  const kickoffAt = competition?.date || event.date || null;

  if (!event?.id || !kickoffAt || !home || !away) return null;

  const status = getMatchStatus(event.status);
  const useScores = status !== "TIMED";
  const homeScore = useScores ? parseScore(home.score) : null;
  const awayScore = useScores ? parseScore(away.score) : null;

  return {
    espnEventId: String(event.id),
    espnCompetitionId: competition?.id ? String(competition.id) : String(event.id),
    kickoffAt: new Date(kickoffAt).toISOString(),
    status,
    duration: getDuration(event.status),
    winner: getWinner(status, home, away, homeScore, awayScore),
    homeScore,
    awayScore,
    homeTeam: normalizeEspnTeam(home),
    awayTeam: normalizeEspnTeam(away),
    raw: {
      id: event.id,
      uid: event.uid || null,
      name: event.name || null,
      shortName: event.shortName || null,
      date: event.date || null,
      competitionDate: competition?.date || null,
      status: event.status || null,
    },
  };
}

function normalizeEspnTeam(competitor) {
  return {
    espnId: competitor?.team?.id ? String(competitor.team.id) : competitor?.id ? String(competitor.id) : null,
    name: competitor?.team?.displayName || competitor?.team?.name || null,
    abbreviation: competitor?.team?.abbreviation || null,
    logo: competitor?.team?.logo || null,
  };
}

function getMatchStatus(status) {
  const type = status?.type || {};

  if (type.completed === true || type.state === "post") return "FINISHED";
  if (type.state === "in") return "IN_PLAY";

  return "TIMED";
}

function getDuration(status) {
  const text = [
    status?.type?.name,
    status?.type?.description,
    status?.type?.detail,
    status?.type?.shortDetail,
  ]
    .filter(Boolean)
    .join(" ")
    .toUpperCase();

  if (text.includes("PEN")) return "PENALTY_SHOOTOUT";
  if (text.includes("EXTRA") || Number(status?.period || 0) > 2) return "EXTRA_TIME";

  return "REGULAR";
}

function parseScore(score) {
  const number = Number.parseInt(score, 10);
  return Number.isFinite(number) ? number : null;
}

function getWinner(status, home, away, homeScore, awayScore) {
  if (status !== "FINISHED" || homeScore === null || awayScore === null) return null;

  if (home?.winner === true) return "HOME_TEAM";
  if (away?.winner === true) return "AWAY_TEAM";
  if (homeScore > awayScore) return "HOME_TEAM";
  if (awayScore > homeScore) return "AWAY_TEAM";

  return "DRAW";
}

function compareByKickoff(a, b) {
  const diff = new Date(a.kickoffAt).getTime() - new Date(b.kickoffAt).getTime();
  if (diff !== 0) return diff;

  const aId = a.match_id || a.matchId || a.espnEventId || "";
  const bId = b.match_id || b.matchId || b.espnEventId || "";
  return String(aId).localeCompare(String(bId));
}

function toMinuteIso(value) {
  if (!value) return "";
  return new Date(value).toISOString().slice(0, 16);
}

function getSavedEspnId(row) {
  const payload = row.source_payload || {};
  return (
    payload?.espn?.event_id ||
    payload?.espn?.eventId ||
    payload?.espn_event_id ||
    payload?.espnEventId ||
    null
  );
}

function shouldUpdateTeamFields(row) {
  const emptyNames = new Set(["", "TBD", "DO USTALENIA", "NULL"]);
  return (
    emptyNames.has(String(row.home_team_name || "").trim().toUpperCase()) ||
    emptyNames.has(String(row.away_team_name || "").trim().toUpperCase())
  );
}

function mergeSourcePayload(row, event) {
  const payload = row.source_payload && typeof row.source_payload === "object" ? row.source_payload : {};

  return {
    ...payload,
    espn: {
      event_id: event.espnEventId,
      competition_id: event.espnCompetitionId,
      event_date_utc: event.kickoffAt,
      synced_at: new Date().toISOString(),
      status: event.raw.status,
      home_team: event.homeTeam,
      away_team: event.awayTeam,
      event: event.raw,
    },
  };
}

function buildUpdates(rows, events) {
  const eventById = new Map(events.map((event) => [event.espnEventId, event]));
  const usedEventIds = new Set();
  const updates = [];

  for (const row of rows) {
    const savedEspnId = getSavedEspnId(row);
    if (!savedEspnId) continue;

    const event = eventById.get(String(savedEspnId));
    if (!event) {
      throw new Error(`Nie znalazlem w ESPN meczu ${row.match_id} z ESPN ID ${savedEspnId}.`);
    }

    updates.push({ row, event, source: "espn-id" });
    usedEventIds.add(event.espnEventId);
  }

  const alreadyMappedRows = new Set(updates.map((update) => update.row.match_id));
  const unmatchedRows = rows
    .filter((row) => !alreadyMappedRows.has(row.match_id))
    .sort(compareByKickoff);
  const unmatchedEvents = events
    .filter((event) => !usedEventIds.has(event.espnEventId))
    .sort(compareByKickoff);

  if (unmatchedRows.length !== unmatchedEvents.length) {
    throw new Error(
      `Nie moge bezpiecznie zmapowac meczow: baza=${unmatchedRows.length}, ESPN=${unmatchedEvents.length}.`
    );
  }

  const mismatches = [];
  for (let index = 0; index < unmatchedRows.length; index += 1) {
    const row = unmatchedRows[index];
    const event = unmatchedEvents[index];
    const dbMinute = toMinuteIso(row.kickoff_at);
    const espnMinute = toMinuteIso(event.kickoffAt);

    if (dbMinute !== espnMinute) {
      mismatches.push(`${row.match_id}: DB ${dbMinute}, ESPN ${espnMinute}`);
    }

    updates.push({ row, event, source: "kickoff-order" });
    usedEventIds.add(event.espnEventId);
  }

  if (mismatches.length > 0 && process.env.ALLOW_SORTED_TIME_MISMATCH !== "1") {
    throw new Error(
      [
        "ESPN ma inne godziny niz baza, wiec nie ryzykuje zlego przypisania.",
        "Pierwsze roznice:",
        ...mismatches.slice(0, 6),
        "Jesli to swiadoma zmiana terminarza, uruchom z ALLOW_SORTED_TIME_MISMATCH=1.",
      ].join("\n")
    );
  }

  return updates.sort((a, b) => compareByKickoff(a.row, b.row));
}

function getUpdateValues(row, event) {
  const updateTeams = shouldUpdateTeamFields(row);

  return {
    matchId: row.match_id,
    kickoffAt: event.kickoffAt,
    homeTeamId: updateTeams ? event.homeTeam.espnId : row.home_team_id,
    homeTeamName: updateTeams ? event.homeTeam.name : row.home_team_name,
    homeTeamCrest: updateTeams ? event.homeTeam.logo || row.home_team_crest : row.home_team_crest,
    awayTeamId: updateTeams ? event.awayTeam.espnId : row.away_team_id,
    awayTeamName: updateTeams ? event.awayTeam.name : row.away_team_name,
    awayTeamCrest: updateTeams ? event.awayTeam.logo || row.away_team_crest : row.away_team_crest,
    status: event.status,
    duration: event.duration,
    winner: event.winner,
    homeScore: event.homeScore,
    awayScore: event.awayScore,
    sourcePayload: mergeSourcePayload(row, event),
  };
}

// Czy wartości z ESPN różnią się od tego, co już mamy w bazie (pomijamy
// source_payload, bo jego synced_at zmienia się zawsze). Tylko realne zmiany
// idą jako PATCH, dzięki czemu nie wywołujemy zbędnych zapisów ani triggerów.
function hasMeaningfulChange(row, values) {
  const toMinute = (v) => (v ? new Date(v).toISOString().slice(0, 16) : "");
  return (
    toMinute(row.kickoff_at) !== toMinute(values.kickoffAt) ||
    (row.home_team_id || "") !== (values.homeTeamId || "") ||
    (row.home_team_name || "") !== (values.homeTeamName || "") ||
    (row.home_team_crest || "") !== (values.homeTeamCrest || "") ||
    (row.away_team_id || "") !== (values.awayTeamId || "") ||
    (row.away_team_name || "") !== (values.awayTeamName || "") ||
    (row.away_team_crest || "") !== (values.awayTeamCrest || "") ||
    (row.status || "") !== (values.status || "") ||
    (row.duration || "") !== (values.duration || "") ||
    (row.winner || null) !== (values.winner || null) ||
    (row.home_score ?? null) !== (values.homeScore ?? null) ||
    (row.away_score ?? null) !== (values.awayScore ?? null)
  );
}

async function readDbRows(rest) {
  const select =
    "match_id,kickoff_at,home_team_id,home_team_name,home_team_crest," +
    "away_team_id,away_team_name,away_team_crest,status,duration,winner," +
    "home_score,away_score,source_payload";
  const rows = await rest.request(
    "GET",
    `typer_world_cup_matches?select=${select}&order=kickoff_at.nullslast,match_id.asc`
  );

  if (!Array.isArray(rows) || rows.length < 64) {
    throw new Error(`W bazie jest za malo meczow typera: ${rows?.length ?? 0}. Najpierw odpal seed.`);
  }

  return rows;
}

async function applyUpdates(rest, updates) {
  let changed = 0;

  for (const update of updates) {
    const values = getUpdateValues(update.row, update.event);
    if (!hasMeaningfulChange(update.row, values)) continue;

    await rest.request(
      "PATCH",
      `typer_world_cup_matches?match_id=eq.${encodeURIComponent(values.matchId)}`,
      {
        prefer: "return=minimal",
        body: {
          kickoff_at: values.kickoffAt,
          home_team_id: values.homeTeamId,
          home_team_name: values.homeTeamName,
          home_team_crest: values.homeTeamCrest,
          away_team_id: values.awayTeamId,
          away_team_name: values.awayTeamName,
          away_team_crest: values.awayTeamCrest,
          status: values.status,
          duration: values.duration,
          winner: values.winner,
          home_score: values.homeScore,
          away_score: values.awayScore,
          source_payload: values.sourcePayload,
        },
      }
    );

    changed += 1;
  }

  // Przeliczenie rankingu po stronie bazy (SECURITY DEFINER, nadane service_role).
  await rest.request("POST", "rpc/recalculate_all_typer_scores", { body: {} });

  return changed;
}

function printSummary(events, updates) {
  const finished = events.filter((event) => event.status === "FINISHED").length;
  const live = events.filter((event) => event.status === "IN_PLAY").length;
  const scored = events.filter((event) => event.homeScore !== null && event.awayScore !== null).length;
  const byEspnId = updates.filter((update) => update.source === "espn-id").length;
  const byKickoffOrder = updates.filter((update) => update.source === "kickoff-order").length;

  console.log(
    `[world-cup-sync] ESPN: events=${events.length}, finished=${finished}, live=${live}, scored=${scored}.`
  );
  console.log(
    `[world-cup-sync] Mapowanie: espn-id=${byEspnId}, kickoff-order=${byKickoffOrder}.`
  );

  for (const update of updates.filter((item) => item.event.status !== "TIMED").slice(0, 8)) {
    const event = update.event;
    console.log(
      `[world-cup-sync] ${update.row.match_id}: ${event.homeTeam.name} ${event.homeScore}-${event.awayScore} ${event.awayTeam.name} (${event.status})`
    );
  }
}

async function main() {
  const envFile = readEnvFile();
  const supabaseUrl = getSupabaseUrl(envFile);
  const serviceKey = getServiceKey(envFile);
  const events = await fetchEspnEvents();

  if (!supabaseUrl) {
    throw new Error("Brak SUPABASE_URL / REACT_APP_SUPABASE_URL.");
  }

  if (!serviceKey) {
    throw new Error("Brak SUPABASE_SERVICE_KEY w tym terminalu albo w sekretach GitHuba.");
  }

  const rest = createRest(supabaseUrl, serviceKey);
  const rows = await readDbRows(rest);
  const updates = buildUpdates(rows, events);
  printSummary(events, updates);

  if (DRY_RUN) {
    const wouldChange = updates.filter((u) => hasMeaningfulChange(u.row, getUpdateValues(u.row, u.event))).length;
    console.log(`[world-cup-sync] Dry run - baza nie zostala zmieniona. Do zmiany: ${wouldChange}.`);
    return;
  }

  const changed = await applyUpdates(rest, updates);

  const afterRows = await rest.request(
    "GET",
    "typer_world_cup_matches?select=status,home_score,away_score"
  );
  const after = {
    matches: afterRows.length,
    finished: afterRows.filter((r) => r.status === "FINISHED").length,
    live: afterRows.filter((r) => r.status === "IN_PLAY").length,
    scored: afterRows.filter((r) => r.home_score !== null && r.away_score !== null).length,
  };

  console.log(`[world-cup-sync] Zaktualizowano rekordow: ${changed}.`);
  console.log("[world-cup-sync] Po:", after);
  console.log("[world-cup-sync] Gotowe.");
}

main().catch((error) => {
  console.error(`[world-cup-sync] BLAD: ${error.message}`);
  process.exit(1);
});
