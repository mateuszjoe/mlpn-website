/**
 * Parser L98 → SQL do importu bramek (match_events) + brakujących graczy + kadr
 * Wyciąga strzelców z pola NT (notatki meczowe) z plików L98
 *
 * Uruchomienie: node supabase/parse_l98_goals.js
 * Wynik:
 *   supabase/import/players_l98_supplement.sql  (brakujący gracze - uruchom PIERWSZY)
 *   supabase/import/goals_l98_import.sql        (bramki → match_events)
 *   supabase/import/rosters_l98_import.sql      (kadry odtworzone ze strzelców)
 */

const fs = require("fs");
const path = require("path");

const ARCHIVE_DIR = path.join(__dirname, "..", "archiwum 2003-2017");
const IMPORT_DIR = path.join(__dirname, "import");

// ── Parser L98 (z parse_l98_import.js) ──
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

function extractMatchData(sections, fileName) {
  const opts = sections.Options || {};
  const year = parseInt(fileName.match(/(\d{4})/)?.[1]) || 0;
  const leaguePrefix = fileName.match(/^(I{1,3})_liga/)?.[1] || "I";
  const teamsCount = parseInt(opts.Teams) || 0;
  const roundsCount = parseInt(opts.Rounds) || 0;
  const matchesPerRound = parseInt(opts.Matches) || 0;

  const leagueMap = { I: "1st", II: "2nd", III: "3rd" };
  const leagueCode = leagueMap[leaguePrefix] || "1st";

  // Drużyny
  const teams = {};
  const teamsSection = sections.Teams || {};
  const teamkSection = sections.Teamk || {};
  const teammSection = sections.Teamm || {};
  for (let i = 1; i <= teamsCount; i++) {
    const name = (teamsSection[String(i)] || "").trim();
    const short = (teamkSection[String(i)] || "").trim();
    const med = (teammSection[String(i)] || "").trim();
    if (name) {
      teams[i] = { name, short, med };
    }
  }

  // Mecze z notkami
  const matches = [];
  for (let r = 1; r <= roundsCount; r++) {
    const roundSection = sections[`Round${r}`];
    if (!roundSection) continue;
    for (let m = 1; m <= matchesPerRound; m++) {
      const ta = parseInt(roundSection[`TA${m}`]) || 0;
      const tb = parseInt(roundSection[`TB${m}`]) || 0;
      const ga = parseInt(roundSection[`GA${m}`]);
      const gb = parseInt(roundSection[`GB${m}`]);
      const nt = (roundSection[`NT${m}`] || "").trim();
      const ti = roundSection[`TI${m}`] || "0";

      if (ta === 0 || tb === 0) continue;
      if (ga < 0 && gb < 0) continue; // brak danych

      const homeTeam = teams[ta];
      const awayTeam = teams[tb];
      if (!homeTeam || !awayTeam) continue;

      const isWalkover = ti === "1" || nt.toLowerCase().includes("walkover") || nt.toLowerCase().includes("walkower");

      matches.push({
        round: r,
        homeTeam,
        awayTeam,
        homeGoals: ga >= 0 ? ga : 0,
        awayGoals: gb >= 0 ? gb : 0,
        notes: nt,
        isWalkover,
      });
    }
  }

  return { year, leaguePrefix, leagueCode, teams, matches };
}

// ── Normalizacja nazw drużyn ──
function normalizeTeamName(name) {
  return name.replace(/\s+/g, " ").replace(/^Fc\b/i, "FC")
    .replace(/\bSulejówek$/i, "").replace(/\bSuperparkiet[._]pl$/i, "").trim();
}

// ── SQL escape ──
function esc(str) {
  if (str === null || str === undefined) return "NULL";
  return "'" + String(str).replace(/'/g, "''") + "'";
}

// ══════════════════════════════════════════════
// PARSER BRAMEK z tekstu NT
// ══════════════════════════════════════════════

/**
 * Parsuj tekst notatki meczowej i wyciągnij strzelców bramek.
 * Zwraca: [{ name, count, teamHint, isOwnGoal }]
 *
 * Formaty:
 * A (2003-2012): "Bramki: Matwiejczyk Daniel 2, Cymborski Łukasz (PKKL) - Dobosz Michał (Colgate)."
 * B (2013-2014): "Bramki: Keller 4, Kilimnik (Joga); Orzoł (E.M.)"
 * C (2015-2017): "Bramki: Lech (Pjm) ; Dubaj (Lider)"
 * Specjalne: "Bramka: X (Team)." (singular)
 */
function parseGoalScorers(notes, homeTeam, awayTeam) {
  if (!notes) return [];

  // Wyciągnij tekst po "Bramki:" lub "Bramka:"
  const goalMatch = notes.match(/Bramki?:\s*(.*?)(?:\.\s*Sędzi[aąo]|$)/i);
  if (!goalMatch) return [];

  let goalText = goalMatch[1].trim();
  if (!goalText) return [];

  // Usuń trailing dot
  goalText = goalText.replace(/\.\s*$/, "").trim();

  // Podziel na stronę gospodarzy i gości
  // Separatory: " - " (dash), " ; " (semicolon), " : " (colon between teams)
  // Ale separator między drużynami to zwykle " - " (2003-2014) lub " ; " / " : " (2015+)

  const sides = splitTeamSides(goalText, homeTeam, awayTeam);
  const scorers = [];

  for (const side of sides) {
    const parsed = parseOneSide(side.text, side.teamHint, homeTeam, awayTeam);
    scorers.push(...parsed);
  }

  return scorers;
}

/**
 * Podziel tekst bramkowy na strony (gospodarze vs goście)
 */
function splitTeamSides(text, homeTeam, awayTeam) {
  // Próbuj rozdzielić po " - " (2003-2014 format)
  // Ale uważaj na myślniki w nazwiskach (np. "Kowalski-Nowak")
  // Separator " - " z spacjami po obu stronach jest bezpieczny

  // Sprawdź czy są 2 drużyny w nawiasach
  const teamMentions = [];
  const re = /\(([^)]+)\)/g;
  let m;
  while ((m = re.exec(text)) !== null) {
    teamMentions.push(m[1].trim());
  }

  // Jeśli jest separator ; lub : między blokami z różnymi drużynami
  for (const sep of [" ; ", " - ", " : "]) {
    const idx = text.indexOf(sep);
    if (idx > 0) {
      const left = text.substring(0, idx).trim();
      const right = text.substring(idx + sep.length).trim();

      // Sprawdź czy obie strony mają jakieś dane
      if (left && right) {
        const leftTeam = guessTeam(left, homeTeam, awayTeam);
        const rightTeam = guessTeam(right, homeTeam, awayTeam);

        return [
          { text: left, teamHint: leftTeam || "home" },
          { text: right, teamHint: rightTeam || "away" },
        ];
      }
    }
  }

  // Tylko jedna strona - spróbuj określić drużynę
  const team = guessTeam(text, homeTeam, awayTeam);
  return [{ text, teamHint: team || "unknown" }];
}

/**
 * Zgadnij drużynę z tekstu bramkowego (po nazwie w nawiasie)
 */
function guessTeam(text, homeTeam, awayTeam) {
  const teamRe = /\(([^)]+)\)\s*$/;
  const m = text.match(teamRe);
  if (!m) return null;

  const hint = m[1].trim().toLowerCase();

  // Porównaj z nazwami drużyn
  const homeLow = homeTeam.name.toLowerCase();
  const awayLow = awayTeam.name.toLowerCase();
  const homeShort = (homeTeam.short || "").toLowerCase();
  const awayShort = (awayTeam.short || "").toLowerCase();
  const homeMed = (homeTeam.med || "").toLowerCase();
  const awayMed = (awayTeam.med || "").toLowerCase();

  if (hint === homeLow || hint === homeShort || hint === homeMed ||
      homeLow.includes(hint) || hint.includes(homeLow.split(" ")[0])) {
    return "home";
  }
  if (hint === awayLow || hint === awayShort || hint === awayMed ||
      awayLow.includes(hint) || hint.includes(awayLow.split(" ")[0])) {
    return "away";
  }

  return null;
}

/**
 * Parsuj jedną stronę bramkową (np. "Matwiejczyk Daniel 2, Cymborski Łukasz (PKKL)")
 * Zwraca: [{ lastName, firstName, count, isOwnGoal, teamHint }]
 */
function parseOneSide(text, teamHint, homeTeam, awayTeam) {
  if (!text) return [];

  // Usuń nazwę drużyny z końca (w nawiasie)
  let cleaned = text.replace(/\s*\([^)]+\)\s*$/, "").trim();
  if (!cleaned) return [];

  // Podziel na poszczególnych strzelców
  // Separatory: ", " lub ","
  const parts = cleaned.split(/\s*,\s*/);
  const scorers = [];

  for (let part of parts) {
    part = part.trim();
    if (!part) continue;
    if (part === "???" || part === "?") continue;

    // Sprawdź samobójczą
    let isOwnGoal = false;
    if (/samob[oó]jcz[aey]/i.test(part)) {
      isOwnGoal = true;
      part = part.replace(/\s*samob[oó]jcz[aey]\s*/i, " ").trim();
    }
    if (part === "samobójcza" || part === "samobojcza") continue;

    // Wyciągnij liczbę bramek (na końcu)
    let count = 1;
    const countMatch = part.match(/\s+(\d+)\s*$/);
    if (countMatch) {
      count = parseInt(countMatch[1]);
      if (count > 20) count = 1; // nie jest to liczba bramek, tylko coś innego
      part = part.substring(0, countMatch.index).trim();
    }

    // Też sprawdź format "D.Gomulski 2" → initial prefix
    const initialCountMatch = part.match(/^([A-ZĄĆĘŁŃÓŚŹŻ]\.?\s*)(.+?)(\s+\d+)?$/i);

    // Parsuj imię i nazwisko
    // Formaty: "Matwiejczyk Daniel", "Matwiejczyk", "D.Gomulski", "Ł.Żaboklicki"
    let lastName = "";
    let firstName = "";

    // Format z inicjałem: "D.Musz", "M.Czesuch", "A.Raczkowski"
    const initialMatch = part.match(/^([A-ZĄĆĘŁŃÓŚŹŻ])\.?\s*(\S+)$/i);
    if (initialMatch) {
      firstName = initialMatch[1].toUpperCase() + ".";
      lastName = initialMatch[2];
    }
    // Format "Nazwisko Imię" (pełne - 2003-2014)
    else if (part.includes(" ")) {
      const words = part.split(/\s+/);
      // Zwykle: Nazwisko Imię (polska konwencja w sportach)
      lastName = words[0];
      firstName = words.slice(1).join(" ");
    }
    // Samo nazwisko (2015+)
    else {
      lastName = part;
    }

    if (!lastName) continue;

    // Oczyść z ewentualnych nawiasów
    lastName = lastName.replace(/[()]/g, "").trim();
    firstName = firstName.replace(/[()]/g, "").trim();

    scorers.push({
      lastName,
      firstName,
      count,
      isOwnGoal,
      teamHint,
    });
  }

  return scorers;
}

// ══════════════════════════════════════════════
// GŁÓWNA FUNKCJA
// ══════════════════════════════════════════════

function main() {
  const files = fs.readdirSync(ARCHIVE_DIR).filter(f => f.endsWith(".l98"));
  console.log(`Znaleziono ${files.length} plików L98`);

  // Wczytaj istniejących graczy (z pliku SQL importu)
  const existingPlayers = loadExistingPlayers();
  console.log(`Istniejących graczy w bazie: ${existingPlayers.size}`);

  const allGoals = []; // { year, leagueCode, round, homeName, awayName, scorer, teamSide }
  const allRosterEntries = new Set(); // "year|leagueCode|teamName|lastName|firstName"
  const unknownPlayers = new Map(); // "lastName|firstName" → { lastName, firstName, count }
  let totalNotes = 0;
  let notesWithGoals = 0;
  let parsedGoals = 0;
  let matchedGoals = 0;

  for (const file of files.sort()) {
    const content = fs.readFileSync(path.join(ARCHIVE_DIR, file), "utf-8");
    const sections = parseL98(content);
    const data = extractMatchData(sections, file);

    let fileGoals = 0;

    for (const match of data.matches) {
      if (!match.notes) continue;
      totalNotes++;

      const scorers = parseGoalScorers(match.notes, match.homeTeam, match.awayTeam);
      if (scorers.length === 0) continue;
      notesWithGoals++;

      for (const scorer of scorers) {
        parsedGoals += scorer.count;

        // Określ drużynę strzelca
        let teamName = "";
        let teamSide = scorer.teamHint;
        if (teamSide === "home") {
          teamName = normalizeTeamName(match.homeTeam.name);
        } else if (teamSide === "away") {
          teamName = normalizeTeamName(match.awayTeam.name);
        }

        // Szukaj gracza w bazie
        const playerKey = `${scorer.lastName.toLowerCase()}|${scorer.firstName.toLowerCase()}`;
        const playerKeyReversed = `${scorer.firstName.toLowerCase()}|${scorer.lastName.toLowerCase()}`;
        const isKnown = existingPlayers.has(playerKey) || existingPlayers.has(playerKeyReversed)
          || (scorer.firstName.endsWith(".") && findByInitial(existingPlayers, scorer.lastName, scorer.firstName));

        if (isKnown) {
          matchedGoals += scorer.count;
        } else if (scorer.lastName && !scorer.lastName.match(/^[?.]+$/)) {
          // Brakujący gracz
          const key = scorer.firstName
            ? `${scorer.lastName.toLowerCase()}|${scorer.firstName.toLowerCase()}`
            : `${scorer.lastName.toLowerCase()}|`;
          if (!unknownPlayers.has(key)) {
            unknownPlayers.set(key, { lastName: scorer.lastName, firstName: scorer.firstName || "", count: 0 });
          }
          unknownPlayers.get(key).count += scorer.count;
        }

        // Dodaj do listy bramek
        for (let g = 0; g < scorer.count; g++) {
          allGoals.push({
            year: data.year,
            leagueCode: data.leagueCode,
            round: match.round,
            homeName: normalizeTeamName(match.homeTeam.name),
            awayName: normalizeTeamName(match.awayTeam.name),
            lastName: scorer.lastName,
            firstName: scorer.firstName,
            teamSide,
            isOwnGoal: scorer.isOwnGoal,
            eventOrder: g + 1,
          });
          fileGoals++;
        }

        // Dodaj do kadr
        if (teamName && scorer.lastName) {
          const rosterKey = `${data.year}|${data.leagueCode}|${teamName}|${scorer.lastName}|${scorer.firstName}`;
          allRosterEntries.add(rosterKey);
        }
      }
    }

    console.log(`  ${file}: ${data.matches.length} meczów, ${fileGoals} bramek`);
  }

  console.log(`\n=== Statystyki ===`);
  console.log(`Notatek meczowych: ${totalNotes}`);
  console.log(`Z bramkami: ${notesWithGoals}`);
  console.log(`Bramek sparsowanych: ${parsedGoals}`);
  console.log(`Dopasowanych do graczy: ${matchedGoals}`);
  console.log(`Brakujących graczy: ${unknownPlayers.size}`);
  console.log(`Wpisów kadrowych: ${allRosterEntries.size}`);

  if (!fs.existsSync(IMPORT_DIR)) fs.mkdirSync(IMPORT_DIR, { recursive: true });

  // ── Plik 1: Brakujący gracze ──
  generateMissingPlayers(unknownPlayers);

  // ── Plik 2: Bramki ──
  generateGoals(allGoals);

  // ── Plik 3: Kadry ──
  generateRosters(allRosterEntries);
}

/**
 * Wczytaj istniejących graczy (z pliku SQL importu)
 */
function loadExistingPlayers() {
  const players = new Map(); // "lastName|firstName" → true

  const sqlFile = path.join(IMPORT_DIR, "players_import.sql");
  if (!fs.existsSync(sqlFile)) {
    console.log("UWAGA: Brak pliku players_import.sql - nie mogę sprawdzić istniejących graczy");
    return players;
  }

  const content = fs.readFileSync(sqlFile, "utf-8");
  // Format: INSERT INTO players (...) VALUES ('Imię', 'Nazwisko', ...);
  const re = /VALUES\s*\('([^']*(?:''[^']*)*)',\s*'([^']*(?:''[^']*)*)'/g;
  let m;
  while ((m = re.exec(content)) !== null) {
    const firstName = m[1].replace(/''/g, "'");
    const lastName = m[2].replace(/''/g, "'");
    players.set(`${lastName.toLowerCase()}|${firstName.toLowerCase()}`, true);
  }

  return players;
}

/**
 * Szukaj gracza po inicjale (np. "D." + "Gomulski")
 */
function findByInitial(players, lastName, firstInitial) {
  const initial = firstInitial.replace(".", "").toLowerCase();
  for (const key of players.keys()) {
    const [ln, fn] = key.split("|");
    if (ln === lastName.toLowerCase() && fn.startsWith(initial)) {
      return true;
    }
  }
  return false;
}

/**
 * Generuj SQL dla brakujących graczy
 */
function generateMissingPlayers(unknownPlayers) {
  const sql = [];
  sql.push(`-- Brakujący gracze z L98 (strzelcy bramek nieznani w bazie)`);
  sql.push(`-- Wygenerowano: ${new Date().toISOString()}`);
  sql.push(`-- Uruchom PRZED goals_l98_import.sql!`);
  sql.push(``);

  // Filtruj: tylko gracze z pełnym imieniem i nazwiskiem (inicjały pomiń)
  let count = 0;
  for (const [, player] of [...unknownPlayers.entries()].sort((a, b) => a[1].lastName.localeCompare(b[1].lastName, "pl"))) {
    if (!player.lastName || player.lastName.length < 2) continue;
    if (player.firstName && player.firstName.endsWith(".")) continue; // inicjał - nie dodawaj

    const fn = player.firstName || "?";
    const ln = player.lastName;

    sql.push(`INSERT INTO players (first_name, last_name, position, is_active) VALUES (${esc(fn)}, ${esc(ln)}, 'POM', false) ON CONFLICT DO NOTHING;`);
    count++;
  }

  const outFile = path.join(IMPORT_DIR, "players_l98_supplement.sql");
  fs.writeFileSync(outFile, sql.join("\n"), "utf-8");
  console.log(`\nplayers_l98_supplement.sql: ${count} brakujących graczy (${(fs.statSync(outFile).size / 1024).toFixed(1)} KB)`);
}

/**
 * Generuj SQL dla bramek (match_events)
 */
function generateGoals(allGoals) {
  // Grupuj po roku
  const byYear = new Map();
  for (const goal of allGoals) {
    if (!byYear.has(goal.year)) byYear.set(goal.year, []);
    byYear.get(goal.year).push(goal);
  }

  let totalCount = 0;
  const files = [];

  for (const [year, goals] of [...byYear.entries()].sort((a, b) => a[0] - b[0])) {
    const sql = [];
    sql.push(`-- Bramki z L98 - Sezon ${year}`);
    sql.push(`-- ${goals.length} bramek`);
    sql.push(`-- Uruchom PO players_l98_supplement.sql`);
    sql.push(``);

    sql.push(`DO $$ DECLARE`);
    sql.push(`  v_season_id uuid;`);
    sql.push(`  v_league_id uuid;`);
    sql.push(`  v_match_id uuid;`);
    sql.push(`  v_team_id uuid;`);
    sql.push(`  v_player_id uuid;`);
    sql.push(`BEGIN`);
    sql.push(`  SELECT id INTO v_season_id FROM seasons WHERE year = ${year} LIMIT 1;`);
    sql.push(`  IF v_season_id IS NULL THEN RETURN; END IF;`);
    sql.push(``);

    // Grupuj po lidze
    const byLeague = new Map();
    for (const g of goals) {
      if (!byLeague.has(g.leagueCode)) byLeague.set(g.leagueCode, []);
      byLeague.get(g.leagueCode).push(g);
    }

    for (const [leagueCode, leagueGoals] of [...byLeague.entries()].sort()) {
      sql.push(`  -- Liga: ${leagueCode}`);
      sql.push(`  SELECT id INTO v_league_id FROM leagues WHERE code = ${esc(leagueCode)} LIMIT 1;`);
      sql.push(`  IF v_league_id IS NOT NULL THEN`);

      // Grupuj po meczu (round + home + away)
      const byMatch = new Map();
      for (const g of leagueGoals) {
        const key = `${g.round}|${g.homeName}|${g.awayName}`;
        if (!byMatch.has(key)) byMatch.set(key, { ...g, goals: [] });
        byMatch.get(key).goals.push(g);
      }

      for (const [, matchData] of [...byMatch.entries()].sort((a, b) => a[1].round - b[1].round)) {
        sql.push(`    -- Runda ${matchData.round}: ${matchData.homeName} vs ${matchData.awayName}`);
        sql.push(`    SELECT m.id INTO v_match_id FROM matches m`);
        sql.push(`      JOIN teams th ON th.id = m.home_team_id`);
        sql.push(`      JOIN teams ta ON ta.id = m.away_team_id`);
        sql.push(`      WHERE m.season_id = v_season_id AND m.league_id = v_league_id`);
        sql.push(`        AND m.round = ${matchData.round}`);
        sql.push(`        AND th.name = ${esc(matchData.homeName)}`);
        sql.push(`        AND ta.name = ${esc(matchData.awayName)} LIMIT 1;`);
        sql.push(`    IF v_match_id IS NOT NULL THEN`);

        let eventOrder = 1;
        for (const goal of matchData.goals) {
          const fn = esc(goal.firstName);
          const ln = esc(goal.lastName);

          // Określ drużynę
          if (goal.teamSide === "home") {
            sql.push(`      SELECT m.home_team_id INTO v_team_id FROM matches m WHERE m.id = v_match_id;`);
          } else if (goal.teamSide === "away") {
            sql.push(`      SELECT m.away_team_id INTO v_team_id FROM matches m WHERE m.id = v_match_id;`);
          } else {
            sql.push(`      v_team_id := NULL;`);
          }

          // Szukaj gracza (oba warianty imię/nazwisko)
          if (goal.firstName && !goal.firstName.endsWith(".")) {
            sql.push(`      SELECT id INTO v_player_id FROM players WHERE (last_name = ${ln} AND first_name = ${fn}) OR (last_name = ${fn} AND first_name = ${ln}) LIMIT 1;`);
          } else if (goal.firstName && goal.firstName.endsWith(".")) {
            // Inicjał
            const initial = goal.firstName.replace(".", "").toLowerCase();
            sql.push(`      SELECT id INTO v_player_id FROM players WHERE last_name = ${ln} AND lower(left(first_name, 1)) = ${esc(initial)} LIMIT 1;`);
          } else {
            // Tylko nazwisko
            sql.push(`      SELECT id INTO v_player_id FROM players WHERE last_name = ${ln} LIMIT 1;`);
          }

          sql.push(`      IF v_player_id IS NOT NULL AND v_team_id IS NOT NULL THEN`);
          sql.push(`        INSERT INTO match_events (match_id, event_type, team_id, player_id, is_own_goal, event_order, notes)`);
          sql.push(`        VALUES (v_match_id, 'GOAL', v_team_id, v_player_id, ${goal.isOwnGoal}, ${eventOrder}, 'Import z L98')`);
          sql.push(`        ON CONFLICT DO NOTHING;`);
          sql.push(`      END IF;`);
          eventOrder++;
        }

        sql.push(`    END IF;`);
      }

      sql.push(`  END IF;`);
    }

    sql.push(`END $$;`);

    const outFile = path.join(IMPORT_DIR, `goals_${year}.sql`);
    fs.writeFileSync(outFile, sql.join("\n"), "utf-8");
    totalCount += goals.length;
    files.push(`goals_${year}.sql (${(fs.statSync(outFile).size / 1024).toFixed(1)} KB) - ${goals.length} bramek`);
  }

  console.log(`\nBramki - ${totalCount} łącznie:`);
  for (const f of files) console.log(`  ${f}`);
}

/**
 * Generuj SQL dla kadr odtworzonych ze strzelców (L98)
 */
function generateRosters(rosterEntries) {
  // Grupuj po roku
  const byYear = new Map();
  for (const entry of rosterEntries) {
    const [year, leagueCode, teamName, lastName, firstName] = entry.split("|");
    const y = parseInt(year);
    if (!byYear.has(y)) byYear.set(y, []);
    byYear.get(y).push({ leagueCode, teamName, lastName, firstName });
  }

  let totalCount = 0;
  const files = [];

  for (const [year, entries] of [...byYear.entries()].sort((a, b) => a[0] - b[0])) {
    const sql = [];
    sql.push(`-- Kadry odtworzone ze strzelców bramek L98 - Sezon ${year}`);
    sql.push(`-- ${entries.length} wpisów`);
    sql.push(`-- Uruchom PO players_l98_supplement.sql`);
    sql.push(``);

    sql.push(`DO $$ DECLARE`);
    sql.push(`  v_season_id uuid;`);
    sql.push(`  v_league_id uuid;`);
    sql.push(`  v_team_id uuid;`);
    sql.push(`  v_player_id uuid;`);
    sql.push(`BEGIN`);
    sql.push(`  SELECT id INTO v_season_id FROM seasons WHERE year = ${year} LIMIT 1;`);
    sql.push(`  IF v_season_id IS NULL THEN RETURN; END IF;`);
    sql.push(``);

    // Grupuj po lidze
    const byLeague = new Map();
    for (const e of entries) {
      if (!byLeague.has(e.leagueCode)) byLeague.set(e.leagueCode, []);
      byLeague.get(e.leagueCode).push(e);
    }

    for (const [leagueCode, leagueEntries] of [...byLeague.entries()].sort()) {
      sql.push(`  SELECT id INTO v_league_id FROM leagues WHERE code = ${esc(leagueCode)} LIMIT 1;`);
      sql.push(`  IF v_league_id IS NOT NULL THEN`);

      // Grupuj po drużynie
      const byTeam = new Map();
      for (const e of leagueEntries) {
        if (!byTeam.has(e.teamName)) byTeam.set(e.teamName, []);
        byTeam.get(e.teamName).push(e);
      }

      for (const [teamName, teamEntries] of [...byTeam.entries()].sort()) {
        sql.push(`    SELECT id INTO v_team_id FROM teams WHERE name = ${esc(teamName)} LIMIT 1;`);
        sql.push(`    IF v_team_id IS NOT NULL THEN`);

        for (const entry of teamEntries) {
          const fn = esc(entry.firstName);
          const ln = esc(entry.lastName);

          if (entry.firstName && !entry.firstName.endsWith(".")) {
            sql.push(`      SELECT id INTO v_player_id FROM players WHERE (last_name = ${ln} AND first_name = ${fn}) OR (last_name = ${fn} AND first_name = ${ln}) LIMIT 1;`);
          } else if (entry.firstName && entry.firstName.endsWith(".")) {
            const initial = entry.firstName.replace(".", "").toLowerCase();
            sql.push(`      SELECT id INTO v_player_id FROM players WHERE last_name = ${ln} AND lower(left(first_name, 1)) = ${esc(initial)} LIMIT 1;`);
          } else {
            sql.push(`      SELECT id INTO v_player_id FROM players WHERE last_name = ${ln} LIMIT 1;`);
          }

          sql.push(`      IF v_player_id IS NOT NULL THEN`);
          sql.push(`        INSERT INTO team_players (team_id, player_id, season_id, league_id, joined_date) VALUES (v_team_id, v_player_id, v_season_id, v_league_id, '${year}-01-01') ON CONFLICT (player_id, season_id, league_id, team_id) DO NOTHING;`);
          sql.push(`      END IF;`);
        }

        sql.push(`    END IF;`);
      }

      sql.push(`  END IF;`);
    }

    sql.push(`END $$;`);

    const outFile = path.join(IMPORT_DIR, `rosters_l98_${year}.sql`);
    fs.writeFileSync(outFile, sql.join("\n"), "utf-8");
    totalCount += entries.length;
    files.push(`rosters_l98_${year}.sql (${(fs.statSync(outFile).size / 1024).toFixed(1)} KB) - ${entries.length} wpisów`);
  }

  console.log(`\nKadry L98 - ${totalCount} łącznie:`);
  for (const f of files) console.log(`  ${f}`);
}

main();
