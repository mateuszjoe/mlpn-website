/**
 * Scraper danych z mlpn.pl (JoomSport / WordPress)
 * Sezony 2018-2025: drużyny, mecze, tabele
 *
 * UWAGA: Strona działa TYLKO na HTTP (nie HTTPS)!
 *
 * Uruchomienie: node supabase/scrape_mlpn.js
 * Wyjście: supabase/import_part5_2018-2025.sql (+ opcjonalnie part6, part7)
 */

const http = require("http");
const path = require("path");
const fs = require("fs");

// ====== KONFIGURACJA SEZONÓW ======
const SEASONS = [
  // 2018
  { year: 2018, league: "I", slug: "i_liga_2018" },
  { year: 2018, league: "II", slug: "ii_liga_2018" },
  { year: 2018, league: "III", slug: "iii_liga_2018" },
  // 2019
  { year: 2019, league: "I", slug: "i-liga-sezon-2019" },
  { year: 2019, league: "II", slug: "ii-liga-sezon-2019" },
  { year: 2019, league: "III", slug: "iii-liga-sezon-2019" },
  // 2020
  { year: 2020, league: "I", slug: "i-liga-mlpn-sezon-2020" },
  { year: 2020, league: "II", slug: "ii-liga-mlpn-sezon-2020" },
  { year: 2020, league: "III", slug: "iii-liga-mlpn-sezon-2020" },
  // 2021
  { year: 2021, league: "I", slug: "i-liga-mlpn-i-liga-sezon-2021" },
  { year: 2021, league: "II", slug: "ii-liga-mlpn-ii-liga-sezon-2021" },
  { year: 2021, league: "III", slug: "iii-liga-mlpn-iii-liga-sezon-2021" },
  // 2022
  { year: 2022, league: "I", slug: "i-liga-mlpn-i-liga-sezon-2022" },
  { year: 2022, league: "II", slug: "ii-liga-mlpn-ii-liga-sezon-2022" },
  { year: 2022, league: "III", slug: "iii-liga-mlpn-iii-liga-sezon-2022" },
  // 2023
  { year: 2023, league: "I", slug: "i-liga-mlpn-i-liga-sezon-2023" },
  { year: 2023, league: "II", slug: "ii-liga-mlpn-ii-liga-sezon-2023" },
  { year: 2023, league: "III", slug: "iii-liga-mlpn-iii-liga-sezon-2023" },
  // 2024
  { year: 2024, league: "I", slug: "i-liga-mlpn-i-liga-sezon-2024" },
  { year: 2024, league: "II", slug: "ii-liga-mlpn-ii-liga-mlpn-ii-liga-sezon-2024" },
  { year: 2024, league: "III", slug: "iii-liga-mlpn-iii-liga-sezon-2024" },
  // 2025
  { year: 2025, league: "I", slug: "i-liga-mlpn-i-liga-sezon-2025" },
  { year: 2025, league: "II", slug: "ii-liga-mlpn-ii-liga-sezon-2025" },
  { year: 2025, league: "III", slug: "iii-liga-mlpn-iii-liga-sezon-2025" },
];

const LEAGUE_CODE = { I: "1st", II: "2nd", III: "3rd" };

// ====== HTTP FETCH ======
function fetchPage(url) {
  return new Promise((resolve, reject) => {
    const options = {
      timeout: 15000,
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7",
      },
    };
    const req = http.get(url, options, (res) => {
      if (res.statusCode === 301 || res.statusCode === 302) {
        const redirectUrl = res.headers.location;
        if (redirectUrl) {
          fetchPage(redirectUrl).then(resolve).catch(reject);
          return;
        }
      }
      if (res.statusCode !== 200) {
        reject(new Error(`HTTP ${res.statusCode} for ${url}`));
        res.resume();
        return;
      }
      let data = "";
      res.setEncoding("utf-8");
      res.on("data", (chunk) => (data += chunk));
      res.on("end", () => resolve(data));
    });
    req.on("error", reject);
    req.on("timeout", () => {
      req.destroy();
      reject(new Error(`Timeout for ${url}`));
    });
  });
}

// ====== PARSERY HTML ======

// Wyciągnij drużyny z tabeli ligowej (standings page)
function parseStandings(html) {
  const teams = [];
  // Szukaj tabeli standings
  const tableMatch = html.match(/<table[^>]*jsStandings[^>]*>([\s\S]*?)<\/table>/i);
  if (!tableMatch) return teams;

  const tbody = tableMatch[1];
  // Każdy wiersz tabeli
  const rowRegex = /<tr[^>]*>([\s\S]*?)<\/tr>/gi;
  let rowMatch;
  while ((rowMatch = rowRegex.exec(tbody)) !== null) {
    const row = rowMatch[1];
    // Szukaj nazwy drużyny
    const teamLink = row.match(/<a[^>]*joomsport_team[^>]*>([^<]+)<\/a>/i);
    if (!teamLink) continue;

    const name = decodeHtmlEntities(teamLink[1].trim());

    // Logo URL
    const logoMatch = row.match(/<img[^>]*class="img-thumbnail[^"]*"[^>]*src="([^"]+)"/i);
    const logoUrl = logoMatch ? logoMatch[1] : null;

    // Pozycja (pierwsza komórka z cyfrą)
    const posMatch = row.match(/<td[^>]*>\s*(\d+)\s*<\/td>/i);
    const position = posMatch ? parseInt(posMatch[1]) : 0;

    // Statystyki: M, W, R, P, Goals, Pts
    const tdRegex = /<td[^>]*>\s*([^<]*?)\s*<\/td>/gi;
    const cells = [];
    let tdMatch;
    while ((tdMatch = tdRegex.exec(row)) !== null) {
      cells.push(tdMatch[1].trim());
    }

    // Typowa kolejność: Pos, Team, M, W, R, P, Goals, Pts, Form
    // Ale team jest w <a> więc komórka zawiera HTML
    let played = 0, won = 0, drawn = 0, lost = 0, goalsFor = 0, goalsAgainst = 0, points = 0;

    // Znajdź komórki z liczbami (pomijając pozycję)
    const numCells = cells.filter(c => /^\d+$/.test(c) || /^\d+\s*-\s*\d+$/.test(c));
    if (numCells.length >= 6) {
      // [pos, played, won, drawn, lost, pts] or with goals
      // Try to find the goals cell (contains " - ")
      const goalsIdx = cells.findIndex(c => /^\d+\s*-\s*\d+$/.test(c));
      if (goalsIdx > 0) {
        const goalsParts = cells[goalsIdx].split(/\s*-\s*/);
        goalsFor = parseInt(goalsParts[0]) || 0;
        goalsAgainst = parseInt(goalsParts[1]) || 0;
      }

      // Parse numeric cells in order after position
      const nums = numCells.filter(c => /^\d+$/.test(c));
      if (nums.length >= 5) {
        // pos, played, won, drawn, lost, pts
        played = parseInt(nums[1]) || 0;
        won = parseInt(nums[2]) || 0;
        drawn = parseInt(nums[3]) || 0;
        lost = parseInt(nums[4]) || 0;
        points = parseInt(nums[nums.length - 1]) || 0;
      }
    }

    teams.push({ name, logoUrl, position, played, won, drawn, lost, goalsFor, goalsAgainst, points });
  }

  return teams;
}

// Wyciągnij mecze z kalendarza
function parseCalendar(html) {
  const matches = [];

  // Strategia: skanuj HTML sekwencyjnie
  // 1. Zbierz pozycje nagłówków kolejek i ich numery
  const roundPositions = []; // { pos, round }
  const roundRegex = /jsrow-matchday-name">[^<]*kolejka\s*(\d+)/gi;
  let rm;
  while ((rm = roundRegex.exec(html)) !== null) {
    roundPositions.push({ pos: rm.index, round: parseInt(rm[1]) });
  }

  // 2. Zbierz wszystkie mecze (jsMatchDivTime jako marker)
  //    Każdy mecz: Time → Home → Score → Away (w tej kolejności w HTML)
  const timeRegex = /jsMatchDivTime[\s\S]*?(\d{1,2}[-.]?\d{1,2}[-.]?\d{4}\s*\d{1,2}:\d{2})/gi;
  // Zamiast tego, parsujmy po fragmencie: od jednego jsMatchDivTime do następnego
  const timePositions = [];
  const tpRegex = /jsMatchDivTime/gi;
  let tp;
  while ((tp = tpRegex.exec(html)) !== null) {
    timePositions.push(tp.index);
  }

  for (let i = 0; i < timePositions.length; i++) {
    const start = timePositions[i];
    const end = i + 1 < timePositions.length ? timePositions[i + 1] : start + 5000;
    const chunk = html.substring(start, end);

    // Numer kolejki: najbliższy nagłówek PRZED tą pozycją
    let currentRound = 0;
    for (const rp of roundPositions) {
      if (rp.pos < start) currentRound = rp.round;
      else break;
    }

    // Data i czas
    let matchDate = null, matchTime = null;
    const dtMatch = chunk.match(/(\d{1,2})[-.](\d{1,2})[-.](\d{4})\s*(\d{1,2}):(\d{2})/);
    if (dtMatch) {
      matchDate = `${dtMatch[3]}-${dtMatch[2].padStart(2, "0")}-${dtMatch[1].padStart(2, "0")}`;
      matchTime = `${dtMatch[4].padStart(2, "0")}:${dtMatch[5]}`;
    }

    // Drużyna gospodarzy - jsMatchDivHome" (nie Embl)
    const homeMatch = chunk.match(/jsMatchDivHome"[\s\S]*?js_div_particName[\s\S]*?<a[^>]*>([^<]+)<\/a>/i);
    const homeName = homeMatch ? decodeHtmlEntities(homeMatch[1].trim()) : null;

    // Wynik
    const scoreMatch = chunk.match(/jsMatchDivScore[\s\S]*?>\s*(\d+)\s*-\s*(\d+)\s*</i);
    let homeGoals = null, awayGoals = null;
    if (scoreMatch) {
      homeGoals = parseInt(scoreMatch[1]);
      awayGoals = parseInt(scoreMatch[2]);
    }

    // Drużyna gości - jsMatchDivAway" (nie Embl)
    const awayMatch = chunk.match(/jsMatchDivAway"[\s\S]*?js_div_particName[\s\S]*?<a[^>]*>([^<]+)<\/a>/i);
    const awayName = awayMatch ? decodeHtmlEntities(awayMatch[1].trim()) : null;

    if (homeName && awayName && currentRound > 0) {
      matches.push({
        round: currentRound,
        homeName,
        awayName,
        homeGoals,
        awayGoals,
        date: matchDate,
        time: matchTime,
        status: homeGoals !== null ? "completed" : "scheduled",
      });
    }
  }

  return matches;
}

function decodeHtmlEntities(str) {
  return str
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#039;/g, "'")
    .replace(/&#8211;/g, "–")
    .replace(/&#8217;/g, "'")
    .replace(/&nbsp;/g, " ");
}

// SQL escape
function esc(str) {
  if (str === null || str === undefined) return "NULL";
  return "'" + String(str).replace(/'/g, "''") + "'";
}

// ====== SLEEP ======
function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// ====== MAIN ======
async function main() {
  console.log("=== Scraper mlpn.pl (2018-2025) ===\n");

  const allSeasonData = [];
  const allTeams = new Map(); // name -> { logoUrl }
  let failedSeasons = [];

  for (const season of SEASONS) {
    const baseUrl = `http://mlpn.pl/joomsport_season/${season.slug}/`;
    const calendarUrl = `${baseUrl}?action=calendar&jslimit=0`;

    console.log(`\n--- ${season.league} liga ${season.year} ---`);
    console.log(`  Standings: ${baseUrl}`);

    let teams = [];
    let matches = [];

    // 1. Pobierz tabelę
    try {
      const standingsHtml = await fetchPage(baseUrl);
      teams = parseStandings(standingsHtml);
      console.log(`  Drużyny: ${teams.length}`);
      for (const t of teams) {
        if (!allTeams.has(t.name)) {
          allTeams.set(t.name, { logoUrl: t.logoUrl });
        }
      }
    } catch (err) {
      console.log(`  BŁĄD standings: ${err.message}`);
      failedSeasons.push(`${season.league} liga ${season.year} (standings)`);
    }

    await sleep(500); // Pauza między requestami

    // 2. Pobierz kalendarz
    try {
      console.log(`  Calendar: ${calendarUrl}`);
      const calendarHtml = await fetchPage(calendarUrl);
      matches = parseCalendar(calendarHtml);
      console.log(`  Mecze: ${matches.length}`);

      // Zbieraj nazwy drużyn z meczów (na wypadek gdy nie ma w tabeli)
      for (const m of matches) {
        if (m.homeName && !allTeams.has(m.homeName)) {
          allTeams.set(m.homeName, { logoUrl: null });
        }
        if (m.awayName && !allTeams.has(m.awayName)) {
          allTeams.set(m.awayName, { logoUrl: null });
        }
      }
    } catch (err) {
      console.log(`  BŁĄD calendar: ${err.message}`);
      failedSeasons.push(`${season.league} liga ${season.year} (calendar)`);
    }

    await sleep(500);

    allSeasonData.push({
      year: season.year,
      league: season.league,
      leagueCode: LEAGUE_CODE[season.league],
      teams,
      matches,
    });
  }

  console.log(`\n=== PODSUMOWANIE ===`);
  console.log(`Sezonów: ${allSeasonData.length}`);
  console.log(`Unikalne drużyny: ${allTeams.size}`);
  const totalMatches = allSeasonData.reduce((s, d) => s + d.matches.length, 0);
  console.log(`Łącznie meczów: ${totalMatches}`);
  if (failedSeasons.length > 0) {
    console.log(`\nBŁĘDY (${failedSeasons.length}):`);
    failedSeasons.forEach((s) => console.log(`  - ${s}`));
  }

  // ====== GENERUJ SQL ======
  console.log(`\n=== Generowanie SQL ===`);

  const importDir = path.join(__dirname, "import");
  if (!fs.existsSync(importDir)) fs.mkdirSync(importDir, { recursive: true });

  // Collect unique years
  const uniqueYears = [...new Set(allSeasonData.map((d) => d.year))].sort();

  // Setup: seasons 2018-2025 + teams (dopisz do 00_setup.sql lub osobny plik)
  const sqlSetup = [];
  sqlSetup.push("-- ==============================================");
  sqlSetup.push("-- Dodatkowe sezony i drużyny z mlpn.pl 2018-2025");
  sqlSetup.push(`-- ${allTeams.size} drużyn, ${totalMatches} meczów`);
  sqlSetup.push("-- Uruchom PO 00_setup.sql");
  sqlSetup.push("-- ==============================================");
  sqlSetup.push("");
  sqlSetup.push("BEGIN;");
  sqlSetup.push("");

  sqlSetup.push("-- Sezony 2018-2025");
  for (const year of uniqueYears) {
    const status = year === 2025 ? "active" : "completed";
    sqlSetup.push(
      `INSERT INTO seasons (name, year, status) VALUES (${esc(`Sezon ${year}`)}, ${year}, ${esc(status)}) ON CONFLICT (year) DO NOTHING;`
    );
  }
  sqlSetup.push("");

  sqlSetup.push("-- Drużyny (nowe z 2018-2025)");
  const usedAbbrs = new Set();
  const sortedTeams = [...allTeams.entries()].sort((a, b) =>
    a[0].localeCompare(b[0], "pl")
  );
  for (const [name, data] of sortedTeams) {
    let abbr = name
      .replace(/[^A-Za-zĄĆĘŁŃÓŚŹŻąćęłńóśźż0-9 ]/g, "")
      .substring(0, 5)
      .toUpperCase()
      .trim();
    if (!abbr) abbr = "TEAM";
    let finalAbbr = abbr;
    let counter = 2;
    while (usedAbbrs.has(finalAbbr)) {
      finalAbbr = abbr.substring(0, 4) + counter;
      counter++;
    }
    usedAbbrs.add(finalAbbr);

    sqlSetup.push(
      `INSERT INTO teams (name, abbreviation, is_active) VALUES (${esc(name)}, ${esc(finalAbbr)}, true) ON CONFLICT (name) DO NOTHING;`
    );
    if (data.logoUrl) {
      const logoVal = esc(`http://mlpn.pl${data.logoUrl}`);
      sqlSetup.push(
        `UPDATE teams SET logo_url = ${logoVal} WHERE name = ${esc(name)} AND logo_url IS NULL;`
      );
    }
  }
  sqlSetup.push("");
  sqlSetup.push("COMMIT;");

  const setupFile = path.join(importDir, "01_setup_2018-2025.sql");
  fs.writeFileSync(setupFile, sqlSetup.join("\n"), "utf-8");
  console.log(`01_setup_2018-2025.sql (${(sqlSetup.join("\n").length / 1024).toFixed(1)} KB)`);

  // 1 plik per rok
  for (const year of uniqueYears) {
    const yearData = allSeasonData.filter((d) => d.year === year);
    const partSql = [];
    const yearMatches = yearData.reduce((s, d) => s + d.matches.length, 0);
    const yearTeams = yearData.reduce((s, d) => s + d.teams.length, 0);

    partSql.push(`-- Import mlpn.pl - Sezon ${year}`);
    partSql.push(`-- ${yearData.length} lig, ${yearTeams} drużyn, ${yearMatches} meczów`);
    partSql.push(`-- Uruchom PO 01_setup_2018-2025.sql`);
    partSql.push("");

    for (const data of yearData) {
      if (data.teams.length === 0 && data.matches.length === 0) continue;

      partSql.push(`-- === ${data.league} liga ${data.year} (${data.teams.length} drużyn, ${data.matches.length} meczów) ===`);
      partSql.push("DO $$ DECLARE");
      partSql.push("  v_season_id uuid;");
      partSql.push("  v_league_id uuid;");
      partSql.push("  v_team_id uuid;");
      partSql.push("  v_home_id uuid;");
      partSql.push("  v_away_id uuid;");
      partSql.push("BEGIN");
      partSql.push(`  SELECT id INTO v_season_id FROM seasons WHERE year = ${data.year} LIMIT 1;`);
      partSql.push(`  SELECT id INTO v_league_id FROM leagues WHERE code = ${esc(data.leagueCode)} LIMIT 1;`);
      partSql.push("");

      partSql.push(`  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;`);

      for (const team of data.teams) {
        partSql.push(`  SELECT id INTO v_team_id FROM teams WHERE name = ${esc(team.name)} LIMIT 1;`);
        partSql.push(`  IF v_team_id IS NOT NULL THEN`);
        partSql.push(`    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, ${team.position || "NULL"}) ON CONFLICT DO NOTHING;`);
        partSql.push(`  END IF;`);
      }

      if (data.matches.length > 0) {
        partSql.push("");
        partSql.push(`  -- Mecze`);
        for (const match of data.matches) {
          const dateVal = match.date ? esc(match.date) : "NULL";
          const timeVal = match.time ? esc(match.time) : "NULL";
          const homeGoals = match.homeGoals !== null ? match.homeGoals : "NULL";
          const awayGoals = match.awayGoals !== null ? match.awayGoals : "NULL";

          partSql.push(`  SELECT id INTO v_home_id FROM teams WHERE name = ${esc(match.homeName)} LIMIT 1;`);
          partSql.push(`  SELECT id INTO v_away_id FROM teams WHERE name = ${esc(match.awayName)} LIMIT 1;`);
          partSql.push(`  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN`);
          partSql.push(`    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)`);
          partSql.push(`    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, ${match.round}, ${dateVal}, ${timeVal}, ${homeGoals}, ${awayGoals}, ${esc(match.status)})`);
          partSql.push(`    ON CONFLICT DO NOTHING;`);
          partSql.push(`  END IF;`);
        }
      }

      partSql.push("END $$;");
      partSql.push("");
    }

    partSql.push(`-- Gotowe! Sezon ${year} zaimportowany.`);

    const partFile = path.join(importDir, `${year}.sql`);
    const partText = partSql.join("\n");
    fs.writeFileSync(partFile, partText, "utf-8");
    console.log(`  ${year}.sql (${(partText.length / 1024).toFixed(1)} KB) - ${yearData.length} lig, ${yearMatches} meczów`);
  }

  // Zapisz surowe dane jako JSON (do debugowania)
  const jsonFile = path.join(__dirname, "scraped_data_2018-2025.json");
  fs.writeFileSync(
    jsonFile,
    JSON.stringify({ seasons: allSeasonData, teams: [...allTeams.entries()], failedSeasons }, null, 2),
    "utf-8"
  );
  console.log(`\nSurowe dane: ${jsonFile}`);

  console.log(`\n=== GOTOWE ===`);
  console.log(`Uruchom: 00_setup.sql → 01_setup_2018-2025.sql → pliki roczne (2003.sql ... 2025.sql)`);
}

main().catch(console.error);
