const fs = require("fs");
const path = require("path");

const TEAM_NAME_ALIASES = require("../src/data/teamNameAliases.json");

const ESPN_SCOREBOARD_URL = "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.world/scoreboard";
const ESPN_DATES = process.env.WORLD_CUP_ESPN_DATES || "20260611-20260720";
const DRY_RUN = process.argv.includes("--dry-run");

// Maksymalna różnica gwizdka przy dopasowaniu meczu po nazwach (jak w typerze
// referencyjnym: ±3 h). Chroni przed dopasowaniem do złej daty.
const KICKOFF_MATCH_TOLERANCE_MS = 3 * 60 * 60 * 1000;

// Znormalizowany klucz drużyny: PL->EN (mapa), małe litery, bez ogonków i znaków
// nie-alfanumerycznych. Dzięki temu "Korea Płd." == "South Korea", "Turcja" ==
// "Türkiye" itd. To jest sedno: mecze dopasowujemy PO NAZWACH, nie po kolejności.
function normalizeName(value) {
  return String(value || "")
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]/g, "");
}

function teamKey(name) {
  const raw = String(name || "").trim();
  if (!raw) return "";
  const aliased = TEAM_NAME_ALIASES[raw] || raw;
  return normalizeName(aliased);
}

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

  const homeTeam = normalizeEspnTeam(home);
  const awayTeam = normalizeEspnTeam(away);

  return {
    espnEventId: String(event.id),
    espnCompetitionId: competition?.id ? String(competition.id) : String(event.id),
    kickoffAt: new Date(kickoffAt).toISOString(),
    status,
    duration: getDuration(event.status),
    winner: getWinner(status, home, away, homeScore, awayScore),
    homeScore,
    awayScore,
    homeTeam,
    awayTeam,
    homeKey: teamKey(homeTeam.name),
    awayKey: teamKey(awayTeam.name),
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

function kickoffDistanceMs(row, event) {
  const dbMs = Date.parse(row.kickoff_at || "");
  const espnMs = Date.parse(event.kickoffAt || "");
  if (!Number.isFinite(dbMs) || !Number.isFinite(espnMs)) return Number.POSITIVE_INFINITY;
  return Math.abs(dbMs - espnMs);
}

// Dopasowanie meczu ESPN <-> wiersz bazy PO NAZWACH drużyn (znormalizowanych,
// PL->EN) PLUS zbliżony czas gwizdka (±3 h). To naprawia błędne dopasowania przy
// meczach granych o tej samej godzinie (kolejka 3. fazy grupowej) i samoczynnie
// koryguje wcześniej zapisane złe ESPN ID.
//
// Zwraca { row, event, swapped }, gdzie swapped=true oznacza, że ESPN ma drużyny
// w odwrotnej kolejności niż baza (wtedy zamieniamy wynik/zwycięzcę miejscami).
function buildUpdates(rows, events) {
  const usedEventIds = new Set();
  const updates = [];
  const unmatchedFinals = [];

  for (const row of rows) {
    const homeKey = teamKey(row.home_team_name);
    const awayKey = teamKey(row.away_team_name);

    // Faza pucharowa z zaślepkami ("Zwycięzca grupy A" itp.) nie ma realnych
    // drużyn — nie da się dopasować po nazwie, więc czekamy (sticky).
    if (!homeKey || !awayKey) continue;

    let best = null;
    for (const event of events) {
      if (usedEventIds.has(event.espnEventId)) continue;

      const sameOrder = event.homeKey === homeKey && event.awayKey === awayKey;
      const swappedOrder = event.homeKey === awayKey && event.awayKey === homeKey;
      if (!sameOrder && !swappedOrder) continue;

      const distance = kickoffDistanceMs(row, event);
      if (distance > KICKOFF_MATCH_TOLERANCE_MS) continue;

      if (!best || distance < best.distance) {
        best = { event, swapped: swappedOrder && !sameOrder, distance };
      }
    }

    if (!best) {
      // Sticky finals: ESPN nie pokazuje już tego meczu (wypadł z okna), a my
      // mamy zakończony wynik — zostawiamy go nietkniętego, nie zerujemy.
      const isFinalInDb =
        ["FINISHED", "AWARDED"].includes(String(row.status || "").toUpperCase()) &&
        row.home_score !== null &&
        row.away_score !== null;
      if (isFinalInDb) unmatchedFinals.push(row.match_id);
      continue;
    }

    updates.push({ row, event: best.event, swapped: best.swapped });
    usedEventIds.add(best.event.espnEventId);
  }

  if (unmatchedFinals.length > 0) {
    console.warn(
      `[world-cup-sync] Sticky: ${unmatchedFinals.length} zakonczonych meczow nie ma juz w ESPN - zostawiam wynik bez zmian.`
    );
  }

  const matchedRowIds = new Set(updates.map((update) => update.row.match_id));
  const stillUnmatched = rows.filter(
    (row) => !matchedRowIds.has(row.match_id) && teamKey(row.home_team_name) && teamKey(row.away_team_name)
  );
  if (stillUnmatched.length > 0) {
    console.warn(
      `[world-cup-sync] Nie dopasowano ${stillUnmatched.length} meczow z realnymi druzynami (np. inny termin) - pomijam, sprobuje przy nastepnym uruchomieniu.`
    );
  }

  return updates.sort((a, b) => compareByKickoff(a.row, b.row));
}

// Odwraca zwycięzcę, gdy ESPN ma drużyny w odwrotnej kolejności niż baza.
function orientWinner(winner, swapped) {
  if (!swapped) return winner;
  if (winner === "HOME_TEAM") return "AWAY_TEAM";
  if (winner === "AWAY_TEAM") return "HOME_TEAM";
  return winner;
}

function getUpdateValues(row, event, swapped = false) {
  const updateTeams = shouldUpdateTeamFields(row);
  // Wynik/zwycięzca zawsze względem orientacji bazy (home=home wiersza).
  const homeScore = swapped ? event.awayScore : event.homeScore;
  const awayScore = swapped ? event.homeScore : event.awayScore;
  const winner = orientWinner(event.winner, swapped);
  const espnHome = swapped ? event.awayTeam : event.homeTeam;
  const espnAway = swapped ? event.homeTeam : event.awayTeam;

  return {
    matchId: row.match_id,
    kickoffAt: event.kickoffAt,
    homeTeamId: updateTeams ? espnHome.espnId : row.home_team_id,
    homeTeamName: updateTeams ? espnHome.name : row.home_team_name,
    homeTeamCrest: updateTeams ? espnHome.logo || row.home_team_crest : row.home_team_crest,
    awayTeamId: updateTeams ? espnAway.espnId : row.away_team_id,
    awayTeamName: updateTeams ? espnAway.name : row.away_team_name,
    awayTeamCrest: updateTeams ? espnAway.logo || row.away_team_crest : row.away_team_crest,
    status: event.status,
    duration: event.duration,
    winner,
    homeScore,
    awayScore,
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
    const values = getUpdateValues(update.row, update.event, update.swapped);
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
  const swapped = updates.filter((update) => update.swapped).length;

  console.log(
    `[world-cup-sync] ESPN: events=${events.length}, finished=${finished}, live=${live}, scored=${scored}.`
  );
  console.log(
    `[world-cup-sync] Dopasowano po nazwie+czasie: ${updates.length} meczow (w tym ${swapped} z odwrocona kolejnoscia gospodarz/gosc).`
  );

  for (const update of updates.filter((item) => item.event.status !== "TIMED").slice(0, 8)) {
    const values = getUpdateValues(update.row, update.event, update.swapped);
    console.log(
      `[world-cup-sync] ${values.matchId}: ${values.homeTeamName} ${values.homeScore}-${values.awayScore} ${values.awayTeamName} (${values.status})`
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
    const wouldChange = updates.filter((u) => hasMeaningfulChange(u.row, getUpdateValues(u.row, u.event, u.swapped))).length;
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

// §6.2: nie wywalamy joba. Każdy błąd (ESPN padło, brak sekretu, chwilowy błąd
// sieci) -> log + exit 0. Dzięki temu w bazie zostaje ostatnia dobra wersja,
// GitHub nie wysyła maili o błędach, a następne uruchomienie spróbuje ponownie.
// Wyjątek: w trybie --dry-run zwracamy 1, żeby było widać problem lokalnie.
process.on("unhandledRejection", (reason) => {
  console.warn(`[world-cup-sync] unhandledRejection: ${reason?.message || reason}`);
  process.exit(DRY_RUN ? 1 : 0);
});
process.on("uncaughtException", (error) => {
  console.warn(`[world-cup-sync] uncaughtException: ${error?.message || error}`);
  process.exit(DRY_RUN ? 1 : 0);
});

main().catch((error) => {
  console.warn(`[world-cup-sync] Pomijam to uruchomienie: ${error.message}`);
  process.exit(DRY_RUN ? 1 : 0);
});
