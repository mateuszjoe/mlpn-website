/**
 * MLPN - Import bramek/kartek 2018-2025 z backupu WordPress (SQL dump)
 *
 * Parsuje SQL dump WordPressa, wyciąga zdarzenia meczowe JoomSport,
 * mapuje na istniejące dane w Supabase, importuje do match_events.
 */

const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env.local") });
const { createClient } = require("@supabase/supabase-js");

const sb = createClient(
  process.env.REACT_APP_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

const SQL_FILE = path.join(__dirname, "..", "baza 2018-2025",
  "backup_2026_02_22_11_06_12-3dbedda7-db.sql");

// ==============================================
// KROK 1: Parser SQL dump
// ==============================================

function parseInserts(sql, tableName) {
  const rows = [];
  const lines = sql.split("\n");
  let collecting = false;
  let buffer = "";

  for (const line of lines) {
    if (line.startsWith(`INSERT INTO \`${tableName}\``)) {
      collecting = true;
      buffer = line;
    } else if (collecting) {
      buffer += line;
    }

    if (collecting && line.trimEnd().endsWith(";")) {
      // Parse values from buffer
      // Remove INSERT INTO ... VALUES prefix
      const valuesStart = buffer.indexOf("VALUES ");
      if (valuesStart >= 0) {
        const valuesStr = buffer.substring(valuesStart + 7, buffer.length - 1); // remove trailing ;
        // Split by ),( but carefully handle quoted strings
        const tuples = splitTuples(valuesStr);
        for (const tuple of tuples) {
          rows.push(parseTuple(tuple));
        }
      }
      collecting = false;
      buffer = "";
    }
  }
  return rows;
}

function splitTuples(valuesStr) {
  const tuples = [];
  let depth = 0;
  let start = -1;
  let inString = false;
  let escapeNext = false;
  let quoteChar = null;

  for (let i = 0; i < valuesStr.length; i++) {
    const c = valuesStr[i];

    if (escapeNext) {
      escapeNext = false;
      continue;
    }
    if (c === "\\") {
      escapeNext = true;
      continue;
    }

    if (inString) {
      if (c === quoteChar) inString = false;
      continue;
    }

    if (c === '"' || c === "'") {
      inString = true;
      quoteChar = c;
      continue;
    }

    if (c === "(") {
      if (depth === 0) start = i;
      depth++;
    } else if (c === ")") {
      depth--;
      if (depth === 0 && start >= 0) {
        tuples.push(valuesStr.substring(start + 1, i));
        start = -1;
      }
    }
  }
  return tuples;
}

function parseTuple(str) {
  const values = [];
  let current = "";
  let inString = false;
  let escapeNext = false;
  let quoteChar = null;

  for (let i = 0; i < str.length; i++) {
    const c = str[i];

    if (escapeNext) {
      current += c;
      escapeNext = false;
      continue;
    }
    if (c === "\\") {
      escapeNext = true;
      current += c;
      continue;
    }

    if (inString) {
      if (c === quoteChar) {
        inString = false;
      } else {
        current += c;
      }
      continue;
    }

    if (c === '"' || c === "'") {
      inString = true;
      quoteChar = c;
      continue;
    }

    if (c === ",") {
      values.push(parseValue(current.trim()));
      current = "";
      continue;
    }

    current += c;
  }
  if (current.trim()) {
    values.push(parseValue(current.trim()));
  }
  return values;
}

function parseValue(v) {
  if (v === "NULL") return null;
  if (/^-?\d+$/.test(v)) return parseInt(v);
  if (/^-?\d+\.\d+$/.test(v)) return parseFloat(v);
  return v;
}

// ==============================================
// KROK 2: Wyciągnij dane z SQL dump
// ==============================================

function extractData(sql) {
  console.log("Parsowanie SQL dump...");

  // 1. Match events (bramki, kartki)
  const matchEvents = parseInserts(sql, "wp_joomsport_match_events");
  console.log(`  wp_joomsport_match_events: ${matchEvents.length} wierszy`);

  // 2. Matches (wp_joomsport_matches)
  const wpMatches = parseInserts(sql, "wp_joomsport_matches");
  console.log(`  wp_joomsport_matches: ${wpMatches.length} wierszy`);

  // 3. Posts (players, teams, seasons, matches)
  // wp_posts is huge, so we'll parse selectively
  const wpPosts = parseInserts(sql, "wp_posts");
  console.log(`  wp_posts: ${wpPosts.length} wierszy`);

  // 4. Postmeta (match details)
  const wpPostmeta = parseInserts(sql, "wp_postmeta");
  console.log(`  wp_postmeta: ${wpPostmeta.length} wierszy`);

  return { matchEvents, wpMatches, wpPosts, wpPostmeta };
}

// ==============================================
// KROK 3: Buduj lookup tables
// ==============================================

function buildLookups(data) {
  console.log("\nBudowanie lookup tables...");

  // wp_posts: ID, author, date, date_gmt, content, title, excerpt, status, ...
  // We need: ID (0), post_title (5), post_type (20), post_status (7)
  // Actually the columns depend on the dump format. Let me identify by position.
  // Standard wp_posts columns:
  // ID, post_author, post_date, post_date_gmt, post_content, post_title,
  // post_excerpt, post_status, comment_status, ping_status, post_password,
  // post_name, to_ping, pinged, post_modified, post_modified_gmt,
  // post_content_filtered, post_parent, guid, menu_order, post_type, post_mime_type, comment_count

  const players = {}; // WP ID -> name
  const teams = {};   // WP ID -> name
  const seasons = {}; // WP ID -> name (e.g., "I liga - sezon 2018")

  for (const row of data.wpPosts) {
    const id = row[0];
    const title = row[5];
    const status = row[7];
    const postType = row[20];

    if (status === "trash") continue;

    if (postType === "joomsport_player") {
      players[id] = title;
    } else if (postType === "joomsport_team") {
      teams[id] = title;
    } else if (postType === "joomsport_season") {
      seasons[id] = title;
    }
  }

  console.log(`  Gracze WP: ${Object.keys(players).length}`);
  console.log(`  Drużyny WP: ${Object.keys(teams).length}`);
  console.log(`  Sezony WP: ${Object.keys(seasons).length}`);

  // wp_joomsport_matches: postID, mdID, seasonID, teamHomeID, teamAwayID, groupID, status, date, time, scoreHome, scoreAway, post_status, duration
  const matches = {};
  for (const row of data.wpMatches) {
    matches[row[0]] = {
      postID: row[0],
      mdID: row[1],
      seasonID: row[2],
      teamHomeID: row[3],
      teamAwayID: row[4],
      groupID: row[5],
      status: row[6],
      date: row[7],
      time: row[8],
      scoreHome: row[9],
      scoreAway: row[10]
    };
  }
  console.log(`  Mecze WP: ${Object.keys(matches).length}`);

  // Match events: id, e_id, player_id, match_id, season_id, ecount, minutes, t_id, eordering, minutes_input, additional_to, stage_id
  const events = data.matchEvents.map(row => ({
    id: row[0],
    e_id: row[1],       // 5=goal, 6=own goal, 7=yellow, 8=2nd yellow, 9=red, 10=MOTM
    player_id: row[2],
    match_id: row[3],
    season_id: row[4],
    ecount: row[5],
    minutes: row[6],
    t_id: row[7],       // team ID
    eordering: row[8]
  }));

  return { players, teams, seasons, matches, events };
}

// ==============================================
// KROK 4: Mapowanie WP -> Supabase
// ==============================================

function normalizeTeamName(name) {
  return name
    .replace(/\s+/g, " ")
    .replace(/–/g, "-")
    .replace(/\u00A0/g, " ")
    .trim()
    .toLowerCase();
}

function normalizePlayerName(name) {
  return name
    .replace(/\s+/g, " ")
    .trim()
    .toLowerCase();
}

// Mapuj sezon WP na rok
function parseSeasonYear(seasonName) {
  // Formaty: "I liga - sezon 2018", "II liga - sezon 2019", "Puchar MLPN 2020" itp.
  const m = seasonName.match(/(\d{4})/);
  return m ? parseInt(m[1]) : null;
}

// Mapuj sezon WP na ligę
function parseSeasonLeague(seasonName) {
  const name = seasonName.toLowerCase();
  if (name.includes("i liga") && !name.includes("ii") && !name.includes("iii")) return "1st";
  if (name.includes("ii liga") && !name.includes("iii")) return "2nd";
  if (name.includes("iii liga")) return "3rd";
  if (name.includes("puchar")) return null; // turniej
  return null;
}

async function buildSupabaseMappings(wpLookups) {
  console.log("\nPobieranie danych z Supabase...");

  // Sezony
  const { data: sbSeasons } = await sb.from("seasons").select("id, year, name");
  const seasonByYear = {};
  for (const s of sbSeasons) {
    seasonByYear[s.year] = s.id;
  }
  console.log(`  Sezony Supabase: ${sbSeasons.length}`);

  // Ligi
  const { data: sbLeagues } = await sb.from("leagues").select("id, code, name");
  const leagueByCode = {};
  for (const l of sbLeagues) {
    leagueByCode[l.code] = l.id;
  }

  // Season leagues
  const { data: sbSeasonLeagues } = await sb.from("season_leagues")
    .select("id, season_id, league_id");
  const slByKey = {};
  for (const sl of sbSeasonLeagues) {
    slByKey[`${sl.season_id}_${sl.league_id}`] = sl.id;
  }

  // Drużyny
  const { data: sbTeams } = await sb.from("teams").select("id, name");
  const teamByName = {};
  for (const t of sbTeams) {
    teamByName[normalizeTeamName(t.name)] = t.id;
  }
  console.log(`  Drużyny Supabase: ${sbTeams.length}`);

  // Gracze (paginacja — Supabase limit to 1000 na raz)
  let allPlayers = [];
  let from = 0;
  const PAGE = 1000;
  while (true) {
    const { data: page } = await sb.from("players")
      .select("id, first_name, last_name")
      .range(from, from + PAGE - 1);
    if (!page || page.length === 0) break;
    allPlayers = allPlayers.concat(page);
    from += PAGE;
    if (page.length < PAGE) break;
  }
  const playerByName = {};
  for (const p of allPlayers) {
    const fullName = `${p.first_name} ${p.last_name}`.toLowerCase().trim();
    playerByName[fullName] = p.id;
  }
  console.log(`  Gracze Supabase: ${allPlayers.length}`);

  // Mecze Supabase (paginacja)
  let allMatches = [];
  from = 0;
  while (true) {
    const { data: page, error: pageErr } = await sb.from("matches")
      .select("id, season_id, home_team_id, away_team_id, round, match_date, home_goals, away_goals")
      .not("season_id", "is", null)
      .range(from, from + PAGE - 1);
    if (pageErr) {
      console.error("Błąd pobierania meczów:", pageErr.message);
      return null;
    }
    if (!page || page.length === 0) break;
    allMatches = allMatches.concat(page);
    from += PAGE;
    if (page.length < PAGE) break;
  }

  // Buduj lookup meczów: season_id + home_team_id + away_team_id -> match
  const matchLookup = {};
  for (const m of allMatches) {
    const key = `${m.season_id}_${m.home_team_id}_${m.away_team_id}`;
    matchLookup[key] = m;
  }
  console.log(`  Mecze Supabase: ${allMatches.length}`);

  // Mapuj WP season IDs -> Supabase season IDs
  const wpSeasonToSb = {};
  for (const [wpId, wpName] of Object.entries(wpLookups.seasons)) {
    const year = parseSeasonYear(wpName);
    if (year && seasonByYear[year]) {
      wpSeasonToSb[wpId] = {
        seasonId: seasonByYear[year],
        year: year,
        leagueCode: parseSeasonLeague(wpName)
      };
    }
  }
  console.log(`  Zmapowane sezony WP->SB: ${Object.keys(wpSeasonToSb).length}`);

  // Mapuj WP team IDs -> Supabase team IDs
  const wpTeamToSb = {};
  const unmatchedTeams = [];
  for (const [wpId, wpName] of Object.entries(wpLookups.teams)) {
    const normalized = normalizeTeamName(wpName);
    if (teamByName[normalized]) {
      wpTeamToSb[wpId] = teamByName[normalized];
    } else {
      // Spróbuj fuzzy match
      let found = false;
      for (const [sbName, sbId] of Object.entries(teamByName)) {
        if (sbName.includes(normalized) || normalized.includes(sbName)) {
          wpTeamToSb[wpId] = sbId;
          found = true;
          break;
        }
      }
      if (!found) unmatchedTeams.push({ wpId, wpName });
    }
  }
  console.log(`  Zmapowane drużyny WP->SB: ${Object.keys(wpTeamToSb).length}`);
  if (unmatchedTeams.length > 0) {
    console.log(`  Niezmapowane drużyny: ${unmatchedTeams.length}`);
    for (const t of unmatchedTeams.slice(0, 10)) {
      console.log(`    - "${t.wpName}" (WP ID: ${t.wpId})`);
    }
  }

  // Mapuj WP player IDs -> Supabase player IDs
  const wpPlayerToSb = {};
  const unmatchedPlayers = [];
  for (const [wpId, wpName] of Object.entries(wpLookups.players)) {
    const normalized = normalizePlayerName(wpName);
    if (playerByName[normalized]) {
      wpPlayerToSb[wpId] = playerByName[normalized];
    } else {
      unmatchedPlayers.push({ wpId, wpName });
    }
  }
  console.log(`  Zmapowani gracze WP->SB: ${Object.keys(wpPlayerToSb).length}`);
  if (unmatchedPlayers.length > 0) {
    console.log(`  Niezmapowani gracze: ${unmatchedPlayers.length}`);
    for (const p of unmatchedPlayers.slice(0, 10)) {
      console.log(`    - "${p.wpName}" (WP ID: ${p.wpId})`);
    }
  }

  return {
    seasonByYear,
    leagueByCode,
    slByKey,
    teamByName,
    playerByName,
    matchLookup,
    wpSeasonToSb,
    wpTeamToSb,
    wpPlayerToSb,
    sbMatches: allMatches,
    unmatchedTeams,
    unmatchedPlayers
  };
}

// ==============================================
// KROK 5: Generuj i importuj match_events
// ==============================================

// Mapuj WP event type na Supabase event type
// Dozwolone: GOAL, YELLOW_CARD, RED_CARD
function mapEventType(eId) {
  switch (eId) {
    case 5: return "GOAL";
    case 6: return "OWN_GOAL";       // -> event_type=GOAL + is_own_goal=true
    case 7: return "YELLOW_CARD";
    case 8: return "YELLOW_CARD";    // druga żółta = traktujemy jako żółtą
    case 9: return "RED_CARD";
    case 10: return null;            // MOTM - nie importujemy
    default: return null;
  }
}

async function importEvents(wpLookups, mappings) {
  console.log("\n=== IMPORT ZDARZEŃ MECZOWYCH ===\n");

  const events = wpLookups.events;
  const stats = {
    total: events.length,
    goals: 0,
    ownGoals: 0,
    yellowCards: 0,
    secondYellow: 0,
    redCards: 0,
    motm: 0,
    skippedNoType: 0,
    skippedNoSeason: 0,
    skippedNoPlayer: 0,
    skippedNoMatch: 0,
    skippedNoTeam: 0,
    imported: 0,
    errors: 0,
    duplicates: 0
  };

  // Filtruj sezony 2018-2025 (te których bramek nie mamy)
  const targetYears = new Set([2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025]);

  // Grupuj events wg sezonu WP
  const eventsBySeason = {};
  for (const ev of events) {
    const seasonInfo = mappings.wpSeasonToSb[ev.season_id];
    if (!seasonInfo) {
      stats.skippedNoSeason++;
      continue;
    }
    if (!targetYears.has(seasonInfo.year)) {
      continue; // Pomijamy sezony przed 2018 (mamy już z L98)
    }
    if (!eventsBySeason[ev.season_id]) eventsBySeason[ev.season_id] = [];
    eventsBySeason[ev.season_id].push(ev);
  }

  console.log(`Sezony do importu: ${Object.keys(eventsBySeason).length}`);
  for (const [wpSeasonId, evs] of Object.entries(eventsBySeason)) {
    const info = mappings.wpSeasonToSb[wpSeasonId];
    console.log(`  ${info.year} (liga: ${info.leagueCode || "?"}) — ${evs.length} zdarzeń`);
  }

  // Dla każdego sezonu, znajdź mecze i importuj zdarzenia
  const allInserts = [];

  for (const [wpSeasonId, evs] of Object.entries(eventsBySeason)) {
    const seasonInfo = mappings.wpSeasonToSb[wpSeasonId];
    const sbSeasonId = seasonInfo.seasonId;

    for (const ev of evs) {
      const eventType = mapEventType(ev.e_id);
      if (!eventType) {
        if (ev.e_id === 10) stats.motm++;
        else stats.skippedNoType++;
        continue;
      }

      // Mapuj gracza
      const sbPlayerId = mappings.wpPlayerToSb[ev.player_id];
      if (!sbPlayerId) {
        stats.skippedNoPlayer++;
        continue;
      }

      // Mapuj drużynę
      const sbTeamId = mappings.wpTeamToSb[ev.t_id];
      if (!sbTeamId) {
        stats.skippedNoTeam++;
        continue;
      }

      // Znajdź mecz w Supabase
      // Mecz WP: match_id -> wp_joomsport_matches -> teamHomeID, teamAwayID -> Supabase
      const wpMatch = wpLookups.matches[ev.match_id];
      if (!wpMatch) {
        stats.skippedNoMatch++;
        continue;
      }

      const sbHomeTeamId = mappings.wpTeamToSb[wpMatch.teamHomeID];
      const sbAwayTeamId = mappings.wpTeamToSb[wpMatch.teamAwayID];

      if (!sbHomeTeamId || !sbAwayTeamId) {
        stats.skippedNoTeam++;
        continue;
      }

      // Szukaj meczu w Supabase po: season + home_team + away_team
      const matchKey = `${sbSeasonId}_${sbHomeTeamId}_${sbAwayTeamId}`;
      const sbMatch = mappings.matchLookup[matchKey];

      if (!sbMatch) {
        stats.skippedNoMatch++;
        continue;
      }

      // Minuta: konwertuj na liczbę (lub null)
      const minute = (ev.minutes && ev.minutes !== "0" && ev.minutes !== 0)
        ? parseInt(ev.minutes) || null
        : null;

      // Licz bramki (ecount mówi ile bramek strzelił ten gracz w tym zdarzeniu)
      if (eventType === "GOAL") {
        for (let i = 0; i < (ev.ecount || 1); i++) {
          allInserts.push({
            match_id: sbMatch.id,
            player_id: sbPlayerId,
            team_id: sbTeamId,
            event_type: "GOAL",
            is_own_goal: false,
            is_penalty: false,
            minute: minute
          });
          stats.goals++;
        }
      } else if (eventType === "OWN_GOAL") {
        allInserts.push({
          match_id: sbMatch.id,
          player_id: sbPlayerId,
          team_id: sbTeamId,
          event_type: "GOAL",
          is_own_goal: true,
          is_penalty: false,
          minute: minute
        });
        stats.ownGoals++;
      } else {
        allInserts.push({
          match_id: sbMatch.id,
          player_id: sbPlayerId,
          team_id: sbTeamId,
          event_type: eventType,
          is_own_goal: false,
          is_penalty: false,
          minute: minute
        });
        if (eventType === "YELLOW_CARD") stats.yellowCards++;
        if (eventType === "SECOND_YELLOW") stats.secondYellow++;
        if (eventType === "RED_CARD") stats.redCards++;
      }
    }
  }

  console.log(`\n=== PODSUMOWANIE ===`);
  console.log(`Zdarzenia WP (2018-2025): ${Object.values(eventsBySeason).reduce((a, b) => a + b.length, 0)}`);
  console.log(`Do importu: ${allInserts.length}`);
  console.log(`  Bramki: ${stats.goals}`);
  console.log(`  Samobóje: ${stats.ownGoals}`);
  console.log(`  Żółte kartki: ${stats.yellowCards}`);
  console.log(`  Drugie żółte (jako żółte): ${stats.secondYellow}`);
  console.log(`  Czerwone kartki: ${stats.redCards}`);
  console.log(`Pominięte:`);
  console.log(`  MOTM (nie importujemy): ${stats.motm}`);
  console.log(`  Brak sezonu: ${stats.skippedNoSeason}`);
  console.log(`  Brak gracza: ${stats.skippedNoPlayer}`);
  console.log(`  Brak meczu: ${stats.skippedNoMatch}`);
  console.log(`  Brak drużyny: ${stats.skippedNoTeam}`);
  console.log(`  Brak typu: ${stats.skippedNoType}`);

  if (allInserts.length === 0) {
    console.log("\nBrak danych do importu!");
    return;
  }

  // Sprawdź czy chcemy importować
  const dryRun = process.argv.includes("--dry-run");
  if (dryRun) {
    console.log("\n[DRY RUN] Nie importuję — uruchom bez --dry-run żeby zaimportować.");
    // Pokaż próbkę
    console.log("\nPróbka (10 pierwszych):");
    for (const ins of allInserts.slice(0, 10)) {
      console.log(JSON.stringify(ins));
    }
    return;
  }

  // Wyłącz trigger przed importem (unikamy problemu z player_season_stats)
  console.log(`\nWyłączam triggery na match_events...`);
  await sb.rpc("exec_sql", { query: "ALTER TABLE match_events DISABLE TRIGGER USER;" });

  // Import partiami po 200
  console.log(`Importowanie ${allInserts.length} zdarzeń...`);
  const BATCH_SIZE = 200;
  let imported = 0;
  let errors = 0;

  for (let i = 0; i < allInserts.length; i += BATCH_SIZE) {
    const batch = allInserts.slice(i, i + BATCH_SIZE);
    const { error } = await sb.from("match_events").insert(batch);

    if (error) {
      console.log(`  Batch ${Math.floor(i / BATCH_SIZE) + 1}: BŁĄD — ${error.message.substring(0, 100)}`);
      errors += batch.length;
    } else {
      imported += batch.length;
      process.stdout.write(`  Zaimportowano: ${imported}/${allInserts.length}\r`);
    }
  }

  // Włącz triggery z powrotem
  console.log(`\nWłączam triggery z powrotem...`);
  await sb.rpc("exec_sql", { query: "ALTER TABLE match_events ENABLE TRIGGER USER;" });

  console.log(`\n=== WYNIK IMPORTU ===`);
  console.log(`Zaimportowano: ${imported}`);
  console.log(`Błędy: ${errors}`);

  // Weryfikacja
  const { count } = await sb.from("match_events").select("*", { count: "exact", head: true });
  console.log(`\nŁączna liczba zdarzeń w Supabase: ${count}`);
}

// ==============================================
// MAIN
// ==============================================

async function main() {
  console.log("=== MLPN Import bramek 2018-2025 z backupu WordPress ===\n");

  if (!fs.existsSync(SQL_FILE)) {
    console.error("Nie znaleziono pliku SQL dump:", SQL_FILE);
    process.exit(1);
  }

  const fileSize = (fs.statSync(SQL_FILE).size / 1024 / 1024).toFixed(1);
  console.log(`Plik: ${path.basename(SQL_FILE)} (${fileSize} MB)`);

  const sql = fs.readFileSync(SQL_FILE, "utf-8");
  const rawData = extractData(sql);
  const lookups = buildLookups(rawData);
  const mappings = await buildSupabaseMappings(lookups);

  if (!mappings) {
    console.error("Nie udało się pobrać danych z Supabase!");
    process.exit(1);
  }

  await importEvents(lookups, mappings);
}

main().catch(err => { console.error(err); process.exit(1); });
