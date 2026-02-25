/**
 * Parser WordPress XML → SQL do importu kadr (team_players)
 * Wyciąga _joomsport_team_players_[SEASON_ID] z drużyn WordPress
 *
 * Uruchomienie: node supabase/parse_wp_rosters.js
 * Wynik: supabase/import/rosters_wp_import.sql
 */

const fs = require("fs");
const path = require("path");

const XML_PATH = path.join(
  __dirname, "..", "baza, wytyczne", "Baza ze starej strony",
  "miejskaligapikinonejwsulejwku.WordPress.2026-01-24.xml"
);

const OUTPUT_PATH = path.join(__dirname, "import", "rosters_wp_import.sql");

// Liga mapowanie
const LEAGUE_MAP = {
  "I": "1st",
  "II": "2nd",
  "III": "3rd",
};

// ── Prosty parser PHP serialize ──
function parsePhpSerialize(str) {
  if (!str || typeof str !== "string") return {};
  const result = {};
  const tokens = [];
  let pos = 0;

  const headerMatch = str.match(/^a:\d+:\{/);
  if (headerMatch) pos = headerMatch[0].length;

  while (pos < str.length) {
    const sMatch = str.substring(pos).match(/^s:(\d+):"([\s\S]*?)";/);
    if (sMatch) {
      tokens.push(sMatch[2]);
      pos += sMatch[0].length;
      continue;
    }
    const iMatch = str.substring(pos).match(/^i:(-?\d+);/);
    if (iMatch) {
      tokens.push(iMatch[1]);
      pos += iMatch[0].length;
      continue;
    }
    pos++;
  }

  for (let i = 0; i + 1 < tokens.length; i += 2) {
    result[tokens[i]] = tokens[i + 1];
  }
  return result;
}

// ── Wyciągnij wartości z serialized array (lista post_ids) ──
function parsePhpArray(str) {
  if (!str || typeof str !== "string") return [];
  const parsed = parsePhpSerialize(str);
  // Wartości to post_ids (indeksy 0,1,2,... → wartości)
  return Object.values(parsed).map(v => String(v));
}

// ── Wyciągnij zawartość CDATA ──
function extractCdata(str) {
  const m = str.match(/<!\[CDATA\[([\s\S]*?)\]\]>/);
  return m ? m[1] : str.replace(/<[^>]+>/g, "").trim();
}

// ── Oczyść imię/nazwisko ──
function cleanName(name) {
  if (!name) return "";
  return name.replace(/^-{2,}/, "").replace(/-{2,}$/, "").trim();
}

// ── SQL escape ──
function esc(str) {
  if (str === null || str === undefined) return "NULL";
  return "'" + String(str).replace(/'/g, "''") + "'";
}

// ── Parsuj sezon z tytułu WordPress ──
// Format: "I liga - sezon 2018", "II liga - sezon 2020", etc.
function parseSeasonTitle(title) {
  const match = title.match(/^(I{1,3})\s+liga\s*[-–—]\s*sezon\s+(\d{4})$/i);
  if (!match) return null;
  const leaguePrefix = match[1].toUpperCase();
  const year = parseInt(match[2]);
  const leagueCode = LEAGUE_MAP[leaguePrefix];
  if (!leagueCode) return null;
  return { leaguePrefix, leagueCode, year };
}

// ── Główna funkcja ──
function main() {
  console.log("Wczytywanie XML...");
  if (!fs.existsSync(XML_PATH)) {
    console.error("Nie znaleziono pliku:", XML_PATH);
    process.exit(1);
  }

  const xml = fs.readFileSync(XML_PATH, "utf-8");
  console.log(`Plik: ${(xml.length / 1024 / 1024).toFixed(1)} MB`);

  const items = xml.split("<item>");
  console.log(`Znaleziono ${items.length - 1} itemów (wszystkie typy)\n`);

  // ── Faza 1: Zbierz graczy (post_id → imię+nazwisko) ──
  const playerMap = new Map(); // wp_post_id → { first_name, last_name }
  let playerCount = 0;

  for (let i = 1; i < items.length; i++) {
    const block = items[i].split("</item>")[0];
    if (!block.includes("<wp:post_type><![CDATA[joomsport_player]]></wp:post_type>")) continue;

    const postIdMatch = block.match(/<wp:post_id>(\d+)<\/wp:post_id>/);
    if (!postIdMatch) continue;
    const postId = postIdMatch[1];

    const titleMatch = block.match(/<title>([\s\S]*?)<\/title>/);
    const title = titleMatch ? extractCdata(titleMatch[1]) : "";

    let firstName = "", lastName = "";
    if (title && title.includes(" ")) {
      const parts = title.split(/\s+/);
      firstName = cleanName(parts[0]);
      lastName = cleanName(parts.slice(1).join(" "));
    } else {
      // Fallback: parsuj _joomsport_player_personal
      const metaBlocks = block.split("<wp:postmeta>");
      for (const mb of metaBlocks) {
        const keyMatch = mb.match(/<wp:meta_key>([\s\S]*?)<\/wp:meta_key>/);
        const valMatch = mb.match(/<wp:meta_value>([\s\S]*?)<\/wp:meta_value>/);
        if (keyMatch && valMatch) {
          const key = extractCdata(keyMatch[1]);
          if (key === "_joomsport_player_personal") {
            const personal = parsePhpSerialize(extractCdata(valMatch[1]));
            firstName = cleanName(personal.first_name || "");
            lastName = cleanName(personal.last_name || "");
          }
        }
      }
    }

    if (firstName && lastName) {
      playerMap.set(postId, { first_name: firstName, last_name: lastName });
      playerCount++;
    }
  }
  console.log(`Graczy znalezionych: ${playerCount}`);

  // ── Faza 2: Zbierz sezony (post_id → {year, leagueCode, title}) ──
  const seasonMap = new Map(); // wp_post_id → { year, leagueCode, leaguePrefix, title }

  for (let i = 1; i < items.length; i++) {
    const block = items[i].split("</item>")[0];
    if (!block.includes("<wp:post_type><![CDATA[joomsport_season]]></wp:post_type>")) continue;

    const postIdMatch = block.match(/<wp:post_id>(\d+)<\/wp:post_id>/);
    if (!postIdMatch) continue;
    const postId = postIdMatch[1];

    const titleMatch = block.match(/<title>([\s\S]*?)<\/title>/);
    const title = titleMatch ? extractCdata(titleMatch[1]) : "";

    const parsed = parseSeasonTitle(title);
    if (parsed) {
      seasonMap.set(postId, { ...parsed, title });
    }
  }

  console.log(`Sezonów znalezionych: ${seasonMap.size}`);
  for (const [id, s] of seasonMap) {
    console.log(`  #${id}: ${s.title} → ${s.leagueCode}, ${s.year}`);
  }

  // ── Faza 3: Zbierz drużyny z kadrami ──
  const rosterEntries = []; // { teamName, seasonPostId, playerPostIds[] }
  let teamCount = 0;

  for (let i = 1; i < items.length; i++) {
    const block = items[i].split("</item>")[0];
    if (!block.includes("<wp:post_type><![CDATA[joomsport_team]]></wp:post_type>")) continue;

    const titleMatch = block.match(/<title>([\s\S]*?)<\/title>/);
    const teamName = titleMatch ? extractCdata(titleMatch[1]).trim() : "";
    if (!teamName) continue;
    teamCount++;

    // Szukaj meta: _joomsport_team_players_[SEASON_ID]
    const metaBlocks = block.split("<wp:postmeta>");
    for (const mb of metaBlocks) {
      const keyMatch = mb.match(/<wp:meta_key>([\s\S]*?)<\/wp:meta_key>/);
      const valMatch = mb.match(/<wp:meta_value>([\s\S]*?)<\/wp:meta_value>/);
      if (!keyMatch || !valMatch) continue;

      const key = extractCdata(keyMatch[1]);
      const rosterMatch = key.match(/^_joomsport_team_players_(\d+)$/);
      if (!rosterMatch) continue;

      const seasonPostId = rosterMatch[1];
      const rawValue = extractCdata(valMatch[1]);
      const playerPostIds = parsePhpArray(rawValue);

      if (playerPostIds.length > 0) {
        rosterEntries.push({
          teamName,
          seasonPostId,
          playerPostIds,
        });
      }
    }
  }

  console.log(`\nDrużyn z danymi: ${teamCount}`);
  console.log(`Wpisów kadrowych: ${rosterEntries.length}`);

  // ── Faza 4: Rozwiąż mapowania i zbierz dane do SQL ──
  const resolvedRosters = []; // { teamName, year, leagueCode, players: [{first_name, last_name}] }
  let totalPlayers = 0;
  let unmatchedSeasons = 0;
  let unmatchedPlayers = 0;

  // Zbierz unikalne lata i drużyny do stworzenia setup SQL
  const uniqueYears = new Set();
  const uniqueTeamNames = new Set();

  for (const entry of rosterEntries) {
    const season = seasonMap.get(entry.seasonPostId);
    if (!season) {
      unmatchedSeasons++;
      continue;
    }

    const players = [];
    for (const pid of entry.playerPostIds) {
      const player = playerMap.get(pid);
      if (player) {
        players.push(player);
      } else {
        unmatchedPlayers++;
      }
    }

    if (players.length > 0) {
      resolvedRosters.push({
        teamName: entry.teamName,
        year: season.year,
        leagueCode: season.leagueCode,
        leaguePrefix: season.leaguePrefix,
        players,
      });
      totalPlayers += players.length;
      uniqueYears.add(season.year);
      uniqueTeamNames.add(entry.teamName);
    }
  }

  console.log(`\n=== Statystyki ===`);
  console.log(`Rozwiązanych kadr: ${resolvedRosters.length}`);
  console.log(`Łącznie przypisań gracz→drużyna: ${totalPlayers}`);
  console.log(`Nieznane sezony (pominięte): ${unmatchedSeasons}`);
  console.log(`Nieznani gracze (pominięci): ${unmatchedPlayers}`);
  console.log(`Unikalne lata: ${[...uniqueYears].sort().join(", ")}`);
  console.log(`Unikalne drużyny: ${uniqueTeamNames.size}`);

  // Rozkład po sezonach
  const seasonCounts = {};
  for (const r of resolvedRosters) {
    const key = `${r.leaguePrefix} liga ${r.year}`;
    seasonCounts[key] = (seasonCounts[key] || 0) + r.players.length;
  }
  console.log(`\nRozkład po sezonach:`);
  for (const [key, count] of Object.entries(seasonCounts).sort()) {
    console.log(`  ${key}: ${count} graczy`);
  }

  // ── Faza 5: Generowanie SQL ──
  console.log(`\n=== Generowanie SQL ===`);

  const dir = path.join(__dirname, "import");
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

  // Setup plik (sezony + drużyny)
  const setupSql = [];
  setupSql.push(`-- Import kadr z WordPress XML (JoomSport) - SETUP`);
  setupSql.push(`-- Wygenerowano: ${new Date().toISOString()}`);
  setupSql.push(`-- Uruchom PRZED plikami rocznymi!`);
  setupSql.push(``);
  setupSql.push(`-- === Sezony 2018-2025 ===`);
  for (const year of [...uniqueYears].sort()) {
    setupSql.push(`INSERT INTO seasons (name, year, status) VALUES (${esc(`Sezon ${year}`)}, ${year}, 'completed') ON CONFLICT DO NOTHING;`);
  }
  setupSql.push(``);
  // Drużyny — pomijaj zaślepki, generuj unikalne skróty
  setupSql.push(`-- === Drużyny z WordPress ===`);
  const SKIP_TEAMS = new Set(["przerwa", "xxx", "---", ""]);
  const usedAbbrs = new Set();
  for (const name of [...uniqueTeamNames].sort()) {
    if (SKIP_TEAMS.has(name.toLowerCase())) continue;
    let base = name.replace(/[^a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ0-9]/g, "").substring(0, 5).toUpperCase() || "TEAM";
    let abbr = base;
    let counter = 2;
    while (usedAbbrs.has(abbr)) {
      abbr = base.substring(0, 4) + counter;
      counter++;
    }
    usedAbbrs.add(abbr);
    // Użyj DO $$ bloku żeby uniknąć konfliktu na abbreviation
    setupSql.push(`DO $$ BEGIN`);
    setupSql.push(`  IF NOT EXISTS (SELECT 1 FROM teams WHERE name = ${esc(name)}) THEN`);
    setupSql.push(`    INSERT INTO teams (name, abbreviation, is_active) VALUES (${esc(name)}, ${esc(abbr)}, true) ON CONFLICT DO NOTHING;`);
    setupSql.push(`  END IF;`);
    setupSql.push(`END $$;`);
  }
  const setupFile = path.join(dir, "rosters_00_setup.sql");
  fs.writeFileSync(setupFile, setupSql.join("\n"), "utf-8");
  console.log(`  rosters_00_setup.sql (${(fs.statSync(setupFile).size / 1024).toFixed(1)} KB)`);

  // Grupuj po roku
  const groupedByYear = new Map(); // year → [roster entries]
  for (const r of resolvedRosters) {
    if (!groupedByYear.has(r.year)) groupedByYear.set(r.year, []);
    groupedByYear.get(r.year).push(r);
  }

  const sortedYears = [...groupedByYear.keys()].sort();

  for (const year of sortedYears) {
    const yearRosters = groupedByYear.get(year);
    const sql = [];
    const yearPlayers = yearRosters.reduce((s, r) => s + r.players.length, 0);

    sql.push(`-- Import kadr z WordPress XML - Sezon ${year}`);
    sql.push(`-- ${yearRosters.length} kadr, ${yearPlayers} przypisań`);
    sql.push(`-- Uruchom PO rosters_00_setup.sql`);
    sql.push(``);

    // Grupuj po lidze w ramach roku
    const byLeague = new Map();
    for (const r of yearRosters) {
      if (!byLeague.has(r.leagueCode)) byLeague.set(r.leagueCode, []);
      byLeague.get(r.leagueCode).push(r);
    }

    for (const [leagueCode, entries] of [...byLeague.entries()].sort()) {
      const leaguePrefix = entries[0].leaguePrefix;

      sql.push(`-- === ${leaguePrefix} liga - sezon ${year} ===`);
      sql.push(`DO $$ DECLARE`);
      sql.push(`  v_season_id uuid;`);
      sql.push(`  v_league_id uuid;`);
      sql.push(`  v_team_id uuid;`);
      sql.push(`  v_player_id uuid;`);
      sql.push(`BEGIN`);
      sql.push(`  SELECT id INTO v_season_id FROM seasons WHERE year = ${year} LIMIT 1;`);
      sql.push(`  SELECT id INTO v_league_id FROM leagues WHERE code = ${esc(leagueCode)} LIMIT 1;`);
      sql.push(``);
      sql.push(`  IF v_season_id IS NULL OR v_league_id IS NULL THEN`);
      sql.push(`    RAISE NOTICE 'Brak sezonu % lub ligi %', ${year}, ${esc(leagueCode)};`);
      sql.push(`    RETURN;`);
      sql.push(`  END IF;`);
      sql.push(``);
      sql.push(`  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;`);
      sql.push(``);

      for (const roster of entries) {
        sql.push(`  -- Drużyna: ${roster.teamName} (${roster.players.length} graczy)`);
        sql.push(`  SELECT id INTO v_team_id FROM teams WHERE name = ${esc(roster.teamName)} LIMIT 1;`);
        sql.push(`  IF v_team_id IS NOT NULL THEN`);
        sql.push(`    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;`);

        for (const player of roster.players) {
          const fn = esc(player.first_name);
          const ln = esc(player.last_name);
          sql.push(`    SELECT id INTO v_player_id FROM players WHERE (first_name = ${fn} AND last_name = ${ln}) OR (first_name = ${ln} AND last_name = ${fn}) LIMIT 1;`);
          sql.push(`    IF v_player_id IS NOT NULL THEN`);
          sql.push(`      INSERT INTO team_players (team_id, player_id, season_id, league_id, joined_date) VALUES (v_team_id, v_player_id, v_season_id, v_league_id, '${year}-01-01') ON CONFLICT (player_id, season_id, league_id, team_id) DO NOTHING;`);
          sql.push(`    END IF;`);
        }

        sql.push(`  END IF;`);
        sql.push(``);
      }

      sql.push(`END $$;`);
      sql.push(``);
    }

    sql.push(`-- Gotowe! Sezon ${year} zaimportowany.`);

    const yearFile = path.join(dir, `rosters_${year}.sql`);
    fs.writeFileSync(yearFile, sql.join("\n"), "utf-8");
    console.log(`  rosters_${year}.sql (${(fs.statSync(yearFile).size / 1024).toFixed(1)} KB) - ${yearRosters.length} kadr, ${yearPlayers} graczy`);
  }

  console.log(`\nUruchom w Supabase Dashboard w kolejności: rosters_00_setup.sql → rosters_2018.sql → ... → rosters_2025.sql`);
}

main();
