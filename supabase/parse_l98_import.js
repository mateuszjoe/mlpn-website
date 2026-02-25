/**
 * Parser plików L98 (Liga98/LigaManager) → SQL INSERT do Supabase
 * Archiwum MLPN 2003-2017
 *
 * Uruchomienie: node supabase/parse_l98_import.js
 * Wyjście: supabase/import_archive_2003_2017.sql
 */

const fs = require("fs");
const path = require("path");

const ARCHIVE_DIR = path.join(__dirname, "..", "archiwum 2003-2017");
const OUTPUT_FILE = path.join(__dirname, "import_archive_2003_2017.sql");

// Liga mapping (kody muszą pasować do seed data: '1st', '2nd', '3rd')
const LEAGUE_MAP = {
  I: { name: "I Liga", code: "1st", order: 1 },
  II: { name: "II Liga", code: "2nd", order: 2 },
  III: { name: "III Liga", code: "3rd", order: 3 },
};

// Parse INI-style L98 file into sections
function parseL98(content) {
  const sections = {};
  let currentSection = null;

  for (const line of content.split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed) continue;

    const sectionMatch = trimmed.match(/^\[(.+)\]$/);
    if (sectionMatch) {
      currentSection = sectionMatch[1];
      sections[currentSection] = {};
      continue;
    }

    if (currentSection) {
      const eqIdx = trimmed.indexOf("=");
      if (eqIdx > 0) {
        const key = trimmed.substring(0, eqIdx);
        const value = trimmed.substring(eqIdx + 1);
        sections[currentSection][key] = value;
      }
    }
  }
  return sections;
}

// Extract structured data from parsed L98 sections
function extractData(sections, fileName) {
  const opts = sections.Options || {};
  const leagueName = opts.Name || "";
  const year = parseInt(fileName.match(/(\d{4})/)?.[1]) || 0;
  const leaguePrefix = fileName.match(/^(I{1,3})_liga/)?.[1] || "I";
  const teamsCount = parseInt(opts.Teams) || 0;
  const roundsCount = parseInt(opts.Rounds) || 0;
  const matchesPerRound = parseInt(opts.Matches) || 0;

  // Extract teams
  const teams = [];
  const teamsSection = sections.Teams || {};
  const teammSection = sections.Teamm || {};
  const teamkSection = sections.Teamk || {};

  for (let i = 1; i <= teamsCount; i++) {
    const fullName = teamsSection[String(i)] || "";
    const medName = teammSection[String(i)] || "";
    const shortName = teamkSection[String(i)] || "";
    const teamMeta = sections[`Team${i}`] || {};

    teams.push({
      index: i,
      name: fullName.trim(),
      mediumName: medName.trim(),
      abbreviation: shortName.trim(),
      pointCorrection: parseInt(teamMeta.SP) || 0,
      goalForCorrection: parseInt(teamMeta.TOR1) || 0,
      goalAgainstCorrection: parseInt(teamMeta.TOR2) || 0,
      notes: (teamMeta.NOT || "").trim(),
    });
  }

  // Extract rounds/matches
  const matches = [];
  for (let r = 1; r <= roundsCount; r++) {
    const roundSection = sections[`Round${r}`];
    if (!roundSection) continue;

    const date1 = roundSection.D1 || "";
    const date2 = roundSection.D2 || "";

    for (let m = 1; m <= matchesPerRound; m++) {
      const ta = parseInt(roundSection[`TA${m}`]) || 0;
      const tb = parseInt(roundSection[`TB${m}`]) || 0;
      const ga = parseInt(roundSection[`GA${m}`]);
      const gb = parseInt(roundSection[`GB${m}`]);
      const nt = (roundSection[`NT${m}`] || "").trim();
      const at = roundSection[`AT${m}`] || "";
      const ti = roundSection[`TI${m}`] || "0";

      // Skip empty matches (ta=0 or tb=0)
      if (ta === 0 || tb === 0) continue;

      // Determine date from timestamp or D1/D2
      let matchDate = null;
      if (at && at !== "0" && at !== "") {
        const ts = parseInt(at);
        if (ts > 0) {
          const d = new Date(ts * 1000);
          matchDate = d.toISOString().split("T")[0];
        }
      }
      if (!matchDate && date1) {
        // Parse DD.MM.YYYY format
        const parts = date1.split(".");
        if (parts.length === 3) {
          matchDate = `${parts[2]}-${parts[1].padStart(2, "0")}-${parts[0].padStart(2, "0")}`;
        }
      }

      // Determine match time from timestamp
      let matchTime = null;
      if (at && at !== "0" && at !== "") {
        const ts = parseInt(at);
        if (ts > 0) {
          const d = new Date(ts * 1000);
          const h = d.getUTCHours().toString().padStart(2, "0");
          const min = d.getUTCMinutes().toString().padStart(2, "0");
          matchTime = `${h}:${min}`;
        }
      }

      // Determine status
      let status = "completed";
      const isWalkover = nt.toLowerCase().includes("walkover") || nt.toLowerCase().includes("walkower");
      const isMissing = ga === -1 || gb === -1;

      if (isMissing && !isWalkover) {
        // Missing data, skip or mark as unknown
        status = "completed"; // still happened, just no detailed score
      }

      // For walkover with TI flag
      if (ti === "1" || isWalkover) {
        if (ga > gb) status = "walkover_home";
        else if (gb > ga) status = "walkover_away";
        else status = "completed";
      }

      const homeGoals = (ga >= 0) ? ga : null;
      const awayGoals = (gb >= 0) ? gb : null;

      matches.push({
        round: r,
        homeTeamIndex: ta,
        awayTeamIndex: tb,
        homeGoals,
        awayGoals,
        date: matchDate,
        time: matchTime,
        notes: nt,
        status,
        isWalkover,
      });
    }
  }

  return {
    year,
    leaguePrefix,
    leagueName,
    teamsCount,
    roundsCount,
    teams,
    matches,
  };
}

// Normalize team name (to deduplicate across seasons)
function normalizeTeamName(name) {
  return name
    .replace(/\s+/g, " ")
    .replace(/^Fc\b/i, "FC")
    .replace(/\bSulejówek$/i, "")
    .replace(/\bSuperparkiet[._]pl$/i, "")
    .trim();
}

// Collect unique team key for deduplication
function teamKey(name) {
  return normalizeTeamName(name).toLowerCase().replace(/[^a-ząćęłńóśźż0-9]/gi, "");
}

// SQL escape
function esc(str) {
  if (str === null || str === undefined) return "NULL";
  return "'" + String(str).replace(/'/g, "''") + "'";
}

// ====== MAIN ======
function main() {
  const files = fs.readdirSync(ARCHIVE_DIR).filter(f => f.endsWith(".l98"));
  console.log(`Found ${files.length} L98 files`);

  const allData = [];
  for (const file of files) {
    const content = fs.readFileSync(path.join(ARCHIVE_DIR, file), "utf-8");
    const sections = parseL98(content);
    const data = extractData(sections, file);
    allData.push(data);
    console.log(`  ${file}: ${data.leaguePrefix} liga ${data.year} - ${data.teams.length} teams, ${data.matches.length} matches`);
  }

  // Collect all unique teams across all seasons
  const uniqueTeams = new Map(); // key -> { name, abbreviation, seasons }
  for (const data of allData) {
    for (const team of data.teams) {
      const key = teamKey(team.name);
      if (!key) continue;
      if (!uniqueTeams.has(key)) {
        uniqueTeams.set(key, {
          name: normalizeTeamName(team.name),
          abbreviation: team.abbreviation,
          seasons: [],
        });
      }
      uniqueTeams.get(key).seasons.push({ year: data.year, league: data.leaguePrefix });
    }
  }

  console.log(`\nUnique teams: ${uniqueTeams.size}`);

  // Collect all unique seasons
  const uniqueSeasons = new Set();
  for (const data of allData) {
    uniqueSeasons.add(data.year);
  }
  const sortedSeasons = [...uniqueSeasons].sort((a, b) => a - b);
  console.log(`Seasons: ${sortedSeasons.join(", ")}`);

  // Count total matches
  const totalMatches = allData.reduce((sum, d) => sum + d.matches.length, 0);
  console.log(`Total matches: ${totalMatches}`);

  // ====== Generate SQL ======
  const sql = [];

  sql.push("-- ==============================================");
  sql.push("-- Import archiwum MLPN 2003-2017");
  sql.push("-- Wygenerowano automatycznie z plików L98");
  sql.push(`-- ${files.length} plików, ${uniqueTeams.size} drużyn, ${totalMatches} meczów`);
  sql.push("-- ==============================================");
  sql.push("");
  sql.push("BEGIN;");
  sql.push("");

  // 1. Ensure leagues exist (kolumna 'code' w schemacie, nie 'abbreviation')
  sql.push("-- Ligi (użyj istniejących jeśli są)");
  for (const [prefix, league] of Object.entries(LEAGUE_MAP)) {
    sql.push(`INSERT INTO leagues (name, code, display_order) VALUES (${esc(league.name)}, ${esc(league.code)}, ${league.order}) ON CONFLICT DO NOTHING;`);
  }
  sql.push("");

  // 2. Create seasons (kolumna 'status' w schemacie, nie 'is_active')
  sql.push("-- Sezony archiwalne");
  for (const year of sortedSeasons) {
    sql.push(`INSERT INTO seasons (name, year, status) VALUES (${esc(`Sezon ${year}`)}, ${year}, 'completed') ON CONFLICT DO NOTHING;`);
  }
  sql.push("");

  // 3. Create teams (abbreviation ma UNIQUE constraint - musimy zapewnić unikalność)
  sql.push("-- Drużyny (unikalne)");
  const teamNames = [...uniqueTeams.values()].sort((a, b) => a.name.localeCompare(b.name, "pl"));
  const usedAbbreviations = new Set();
  for (const team of teamNames) {
    let abbr = (team.abbreviation.substring(0, 5).toUpperCase() || team.name.substring(0, 3).toUpperCase()).trim();
    if (!abbr) abbr = team.name.substring(0, 3).toUpperCase();
    // Ensure unique abbreviation
    let finalAbbr = abbr;
    let counter = 2;
    while (usedAbbreviations.has(finalAbbr)) {
      finalAbbr = abbr.substring(0, 4) + counter;
      counter++;
    }
    usedAbbreviations.add(finalAbbr);
    sql.push(`INSERT INTO teams (name, abbreviation, is_active) VALUES (${esc(team.name)}, ${esc(finalAbbr)}, true) ON CONFLICT (name) DO NOTHING;`);
  }
  sql.push("");

  sql.push("COMMIT;");
  sql.push("");

  // Write setup file
  const importDir = path.join(__dirname, "import");
  if (!fs.existsSync(importDir)) fs.mkdirSync(importDir, { recursive: true });

  const part1Text = sql.join("\n");
  const part1File = path.join(importDir, "00_setup.sql");
  fs.writeFileSync(part1File, part1Text, "utf-8");
  console.log(`\n00_setup.sql (${(part1Text.length / 1024).toFixed(1)} KB)`);

  // 4. Generate 1 file per season (year)
  const sortedData = allData.sort((a, b) => a.year - b.year || a.leaguePrefix.length - b.leaguePrefix.length);

  for (const year of sortedSeasons) {
    const yearData = sortedData.filter(d => d.year === year);
    const partSql = [];
    const yearMatches = yearData.reduce((s, d) => s + d.matches.length, 0);
    const yearTeams = yearData.reduce((s, d) => s + d.teams.length, 0);

    partSql.push(`-- Import archiwum MLPN - Sezon ${year}`);
    partSql.push(`-- ${yearData.length} lig, ${yearTeams} drużyn, ${yearMatches} meczów`);
    partSql.push(`-- Uruchom PO 00_setup.sql`);
    partSql.push("");

    for (const data of yearData) {
      const league = LEAGUE_MAP[data.leaguePrefix];
      if (!league) continue;

      partSql.push(`-- === ${data.leaguePrefix} liga ${data.year} (${data.teams.length} drużyn, ${data.matches.length} meczów) ===`);
      partSql.push("DO $$ DECLARE");
      partSql.push("  v_season_id uuid;");
      partSql.push("  v_league_id uuid;");
      partSql.push("  v_team_id uuid;");
      partSql.push("  v_home_id uuid;");
      partSql.push("  v_away_id uuid;");
      partSql.push("BEGIN");
      partSql.push(`  SELECT id INTO v_season_id FROM seasons WHERE year = ${data.year} LIMIT 1;`);
      partSql.push(`  SELECT id INTO v_league_id FROM leagues WHERE code = ${esc(league.code)} LIMIT 1;`);
      partSql.push("");

      partSql.push(`  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;`);

      for (const team of data.teams) {
        const tName = normalizeTeamName(team.name);
        if (!tName) continue;
        partSql.push(`  SELECT id INTO v_team_id FROM teams WHERE name = ${esc(tName)} LIMIT 1;`);
        partSql.push(`  IF v_team_id IS NOT NULL THEN`);
        partSql.push(`    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;`);
        partSql.push(`  END IF;`);
      }

      partSql.push("");
      partSql.push(`  -- Mecze`);
      for (const match of data.matches) {
        const homeTeam = data.teams.find(t => t.index === match.homeTeamIndex);
        const awayTeam = data.teams.find(t => t.index === match.awayTeamIndex);
        if (!homeTeam || !awayTeam) continue;

        const homeName = normalizeTeamName(homeTeam.name);
        const awayName = normalizeTeamName(awayTeam.name);
        if (!homeName || !awayName) continue;

        const dateVal = match.date ? esc(match.date) : "NULL";
        const timeVal = match.time ? esc(match.time) : "NULL";
        const homeGoals = match.homeGoals !== null ? match.homeGoals : "NULL";
        const awayGoals = match.awayGoals !== null ? match.awayGoals : "NULL";

        partSql.push(`  SELECT id INTO v_home_id FROM teams WHERE name = ${esc(homeName)} LIMIT 1;`);
        partSql.push(`  SELECT id INTO v_away_id FROM teams WHERE name = ${esc(awayName)} LIMIT 1;`);
        partSql.push(`  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN`);
        partSql.push(`    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)`);
        partSql.push(`    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, ${match.round}, ${dateVal}, ${timeVal}, ${homeGoals}, ${awayGoals}, ${esc(match.status)})`);
        partSql.push(`    ON CONFLICT DO NOTHING;`);
        partSql.push(`  END IF;`);
      }

      partSql.push("END $$;");
      partSql.push("");
    }

    partSql.push(`-- Gotowe! Sezon ${year} zaimportowany.`);

    const partFile = path.join(__dirname, "import", `${year}.sql`);
    const partText = partSql.join("\n");
    fs.writeFileSync(partFile, partText, "utf-8");
    console.log(`  ${year}.sql (${(partText.length / 1024).toFixed(1)} KB) - ${yearData.length} lig, ${yearMatches} meczów`);
  }

  console.log(`\nGotowe! Uruchom: 00_setup.sql → potem pliki roczne w kolejności`);
}

main();
