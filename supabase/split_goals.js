/**
 * Dzieli duże pliki goals_YYYY.sql na mniejsze części
 * Każda część to osobny blok DO $$ ... END $$;
 *
 * Uruchomienie: node supabase/split_goals.js
 */

const fs = require("fs");
const path = require("path");

const IMPORT_DIR = path.join(__dirname, "import");
const SPLIT_DIR = path.join(__dirname, "import", "split");
const MAX_LINES = 3000; // max linii na część

// Nagłówek DO $$ block dla każdej części
function makeHeader(year) {
  return [
    `DO $$ DECLARE`,
    `  v_season_id uuid;`,
    `  v_league_id uuid;`,
    `  v_match_id uuid;`,
    `  v_team_id uuid;`,
    `  v_player_id uuid;`,
    `BEGIN`,
    `  SELECT id INTO v_season_id FROM seasons WHERE year = ${year} LIMIT 1;`,
    `  IF v_season_id IS NULL THEN RETURN; END IF;`,
    ``,
  ];
}

// Stopka DO $$ block
function makeFooter(leagueOpen) {
  const lines = [];
  if (leagueOpen) {
    lines.push(`  END IF;`); // zamknij IF v_league_id
  }
  lines.push(`END $$;`);
  return lines;
}

function main() {
  // Utwórz folder split
  if (!fs.existsSync(SPLIT_DIR)) fs.mkdirSync(SPLIT_DIR, { recursive: true });

  // Znajdź pliki goals_YYYY.sql
  const files = fs.readdirSync(IMPORT_DIR)
    .filter(f => f.match(/^goals_\d{4}\.sql$/))
    .sort();

  let totalParts = 0;
  let splitFiles = 0;

  for (const file of files) {
    const filePath = path.join(IMPORT_DIR, file);
    const content = fs.readFileSync(filePath, "utf-8");
    const lines = content.split("\n");
    const yearMatch = file.match(/goals_(\d{4})/);
    const year = yearMatch[1];

    // Jeśli plik jest mały — nie dziel
    if (lines.length <= MAX_LINES + 500) {
      console.log(`${file}: ${lines.length} linii — OK, nie trzeba dzielić`);
      continue;
    }

    console.log(`${file}: ${lines.length} linii — dzielę...`);
    splitFiles++;

    // Znajdź pozycje "-- Liga:" i "-- Runda N:"
    // Szukamy linii, które są dobrymi punktami podziału
    const splitPoints = []; // indeksy linii, gdzie można bezpiecznie podzielić
    let currentLeagueCode = null;
    let currentLeagueLine = -1;

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();

      if (line.startsWith("-- Liga:")) {
        currentLeagueCode = line.replace("-- Liga:", "").trim();
        currentLeagueLine = i;
        splitPoints.push({ line: i, type: "league", code: currentLeagueCode });
      } else if (line.match(/^-- Runda \d+:/)) {
        splitPoints.push({ line: i, type: "runda", league: currentLeagueCode });
      }
    }

    // Teraz grupuj w kawałki po MAX_LINES
    // Każdy kawałek musi zaczynać się od punktu podziału
    const parts = [];
    let currentPart = [];
    let currentPartStart = 0;
    let currentLeague = null;
    let partLeagueOpen = false;

    // Pomiń header (DO $$ DECLARE ... BEGIN ... season lookup)
    // Znajdź pierwszą "-- Liga:" linię
    const firstSplit = splitPoints[0];
    if (!firstSplit) {
      console.log(`  Brak punktów podziału — pomijam`);
      continue;
    }

    // Przetwarzaj punkt po punkcie
    for (let sp = 0; sp < splitPoints.length; sp++) {
      const point = splitPoints[sp];
      const nextPoint = splitPoints[sp + 1];
      const endLine = nextPoint ? nextPoint.line : lines.length;
      const chunkLines = lines.slice(point.line, endLine);

      // Jeśli to nowa liga, zapamiętaj
      if (point.type === "league") {
        // Jeśli mamy otwartą część z poprzednią ligą, zamknij ją
        if (currentPart.length > 0 && partLeagueOpen) {
          currentPart.push(`  END IF;`); // zamknij stary IF v_league_id
          partLeagueOpen = false;
        }
        currentLeague = point.code;
      }

      // Czy dodanie tego kawałka przekroczy limit?
      if (currentPart.length + chunkLines.length > MAX_LINES && currentPart.length > 0) {
        // Zapisz bieżącą część
        parts.push({ lines: currentPart, leagueOpen: partLeagueOpen });
        currentPart = [];
        partLeagueOpen = false;
      }

      // Jeśli to runda i nie mamy otwartej ligi — dodaj nagłówek ligi
      if (point.type === "runda" && !partLeagueOpen) {
        // Musimy otworzyć blok ligi
        const leagueCode = point.league || currentLeague;
        currentPart.push(`  -- Liga: ${leagueCode} (kontynuacja)`);
        currentPart.push(`  SELECT id INTO v_league_id FROM leagues WHERE code = '${leagueCode}' LIMIT 1;`);
        currentPart.push(`  IF v_league_id IS NOT NULL THEN`);
        partLeagueOpen = true;
      }

      // Jeśli to liga — otwarcie bloku ligi jest w chunkLines
      if (point.type === "league") {
        partLeagueOpen = true; // IF v_league_id jest w chunkLines
      }

      // Dodaj linie
      for (const l of chunkLines) {
        currentPart.push(l);
      }
    }

    // Ostatnia część
    if (currentPart.length > 0) {
      // Znajdź END IF; i END $$; na końcu pliku — nie dodawaj ich tutaj
      // Bo oryginalny plik kończy się END IF; END $$;
      // Musimy usunąć je z ostatniego kawałka i pozwolić makeFooter dodać

      // Usuń trailing END IF; / END $$; z ostatnich linii
      while (currentPart.length > 0) {
        const last = currentPart[currentPart.length - 1].trim();
        if (last === "END $$;" || last === "END IF;" || last === "") {
          if (last === "END IF;") partLeagueOpen = false;
          currentPart.pop();
        } else {
          break;
        }
      }

      parts.push({ lines: currentPart, leagueOpen: partLeagueOpen });
    }

    // Zapisz części
    for (let p = 0; p < parts.length; p++) {
      const part = parts[p];
      const partNum = p + 1;
      const fileName = `goals_${year}_part${partNum}.sql`;
      const filePath = path.join(SPLIT_DIR, fileName);

      const header = makeHeader(year);
      const footer = makeFooter(part.leagueOpen);
      const allLines = [
        `-- ${file} — część ${partNum}/${parts.length}`,
        ``,
        ...header,
        ...part.lines,
        ``,
        ...footer,
      ];

      fs.writeFileSync(filePath, allLines.join("\n"), "utf-8");
      const lineCount = allLines.length;
      console.log(`  → ${fileName}: ${lineCount} linii`);
    }

    totalParts += parts.length;
  }

  console.log(`\n=== Gotowe ===`);
  console.log(`Podzielono ${splitFiles} plików na ${totalParts} części`);
  console.log(`Pliki zapisane w: ${SPLIT_DIR}`);
  console.log(`\nKolejność wklejania w Supabase SQL Editor:`);

  // Wylistuj pliki w kolejności
  if (fs.existsSync(SPLIT_DIR)) {
    const splitFiles2 = fs.readdirSync(SPLIT_DIR).filter(f => f.endsWith(".sql")).sort();
    for (const f of splitFiles2) {
      const size = fs.statSync(path.join(SPLIT_DIR, f)).size;
      console.log(`  ${f} (${(size / 1024).toFixed(1)} KB)`);
    }
  }

  // Wylistuj małe pliki, które nie potrzebowały dzielenia
  console.log(`\nPliki, które nie wymagają dzielenia (wklejaj bezpośrednio):`);
  for (const file of files) {
    const filePath = path.join(IMPORT_DIR, file);
    const content = fs.readFileSync(filePath, "utf-8");
    const lineCount = content.split("\n").length;
    if (lineCount <= MAX_LINES + 500) {
      console.log(`  ${file} (${lineCount} linii)`);
    }
  }
}

main();
