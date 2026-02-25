/**
 * Powtórzenie importu bramek które się nie zmieściły w limicie czasu
 * Dzieli na mniejsze kawałki (po ligach)
 */

const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env.local") });
const { createClient } = require("@supabase/supabase-js");

const supabase = createClient(
  process.env.REACT_APP_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

const IMPORT_DIR = path.join(__dirname, "import");

// Pliki do powtórzenia — te co miały "BŁĄD w części 2"
const RETRY_FILES = [
  "goals_2008.sql",
  "goals_2009.sql",
  "goals_2015.sql",
  "goals_2016.sql",
];

// Dzieli plik goals na kawałki po ligach (-- Liga:)
function splitByLeague(sql) {
  const chunks = [];

  // Wyciągnij header (DO $$ DECLARE ... do pierwszej -- Liga:)
  const firstLeagueIdx = sql.indexOf("-- Liga:");
  if (firstLeagueIdx === -1) return [sql]; // nie ma lig — wyślij całość

  const headerEnd = sql.lastIndexOf("\n", firstLeagueIdx);
  const header = sql.substring(0, headerEnd + 1);

  // Wyciągnij footer (END $$;)
  const lastEndIdx = sql.lastIndexOf("END $$;");

  // Znajdź pozycje "-- Liga:"
  const leaguePositions = [];
  let searchFrom = 0;
  while (true) {
    const idx = sql.indexOf("-- Liga:", searchFrom);
    if (idx === -1) break;
    leaguePositions.push(idx);
    searchFrom = idx + 1;
  }

  // Wyciągnij każdą ligę jako osobny DO $$ blok
  for (let i = 0; i < leaguePositions.length; i++) {
    const start = leaguePositions[i];
    const end = i + 1 < leaguePositions.length
      ? leaguePositions[i + 1]
      : lastEndIdx;

    const leagueBody = sql.substring(start, end).trim();

    // Zamień END IF; na końcu (zamknięcie IF v_league_id)
    // i dodaj header/footer
    const chunk = header + "\n" + leagueBody + "\n  END IF;\nEND $$;";

    // Sprawdź czy liga nie jest za duża — jeśli tak, podziel po rundach
    if (chunk.length > 400000) {
      // Podziel po "-- Runda"
      const subChunks = splitLeagueByRounds(leagueBody, header);
      chunks.push(...subChunks);
    } else {
      chunks.push(chunk);
    }
  }

  return chunks;
}

function splitLeagueByRounds(leagueBody, header) {
  const chunks = [];
  const lines = leagueBody.split("\n");

  // Pierwsza linia to "-- Liga: Xst" + SELECT league + IF
  // Znajdź header ligi (do pierwszej "-- Runda")
  let leagueHeader = "";
  let roundsStart = 0;
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].trim().startsWith("-- Runda") && i > 2) {
      roundsStart = i;
      break;
    }
    leagueHeader += lines[i] + "\n";
  }

  // Zbieraj rundy w grupy po ~200KB
  let currentGroup = "";
  const maxSize = 200000;

  for (let i = roundsStart; i < lines.length; i++) {
    const line = lines[i];
    if (line.trim().startsWith("-- Runda") && currentGroup.length > maxSize) {
      // Zapisz grupę
      chunks.push(
        header + "\n" + leagueHeader + currentGroup + "\n  END IF;\nEND $$;"
      );
      currentGroup = "";
    }
    currentGroup += line + "\n";
  }
  if (currentGroup.trim()) {
    chunks.push(
      header + "\n" + leagueHeader + currentGroup + "\n  END IF;\nEND $$;"
    );
  }

  return chunks;
}

async function main() {
  console.log("=== Powtórzenie importu bramek ===\n");

  // Test
  const { error: testErr } = await supabase.rpc("exec_sql", { query: "SELECT 1" });
  if (testErr) {
    console.error("Błąd połączenia:", testErr.message);
    process.exit(1);
  }

  let totalSuccess = 0;
  let totalErrors = 0;

  for (const file of RETRY_FILES) {
    const filePath = path.join(IMPORT_DIR, file);
    if (!fs.existsSync(filePath)) {
      console.log(`${file}: nie znaleziono — pomijam`);
      continue;
    }

    const sql = fs.readFileSync(filePath, "utf-8");
    const sizeKB = (sql.length / 1024).toFixed(0);
    const chunks = splitByLeague(sql);
    console.log(`${file} (${sizeKB} KB) → ${chunks.length} kawałków`);

    for (let c = 0; c < chunks.length; c++) {
      const chunkKB = (chunks[c].length / 1024).toFixed(0);
      process.stdout.write(`  [${c + 1}/${chunks.length}] (${chunkKB} KB)... `);
      const start = Date.now();
      const { error } = await supabase.rpc("exec_sql", { query: chunks[c] });
      const elapsed = ((Date.now() - start) / 1000).toFixed(1);
      if (error) {
        console.log(`BŁĄD (${elapsed}s): ${error.message.substring(0, 100)}`);
        totalErrors++;
      } else {
        console.log(`OK (${elapsed}s)`);
        totalSuccess++;
      }
    }
  }

  console.log(`\n=== Gotowe ===`);
  console.log(`Kawałków OK: ${totalSuccess}, błędów: ${totalErrors}`);

  // Weryfikacja bramek
  const { count } = await supabase.from("match_events").select("*", { count: "exact", head: true });
  console.log(`Bramek/wydarzeń w bazie: ${count}`);
}

main().catch(err => { console.error(err); process.exit(1); });
