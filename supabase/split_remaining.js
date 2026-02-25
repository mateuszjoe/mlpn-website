/**
 * Precyzyjne dzielenie goals_2008.sql i goals_2015.sql na 3 części (po lidze)
 */

const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env.local") });
const { createClient } = require("@supabase/supabase-js");

const sb = createClient(
  process.env.REACT_APP_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

const IMPORT_DIR = path.join(__dirname, "import");
const FILES = ["goals_2008.sql", "goals_2015.sql"];

function makeBlock(year, leagueCode, leagueBody) {
  return `DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_match_id uuid;
  v_team_id uuid;
  v_player_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = ${year} LIMIT 1;
  IF v_season_id IS NULL THEN RETURN; END IF;

  SELECT id INTO v_league_id FROM leagues WHERE code = '${leagueCode}' LIMIT 1;
  IF v_league_id IS NOT NULL THEN
${leagueBody}
  END IF;
END $$;`;
}

async function main() {
  console.log("=== Import bramek 2008 + 2015 (po lidze) ===\n");

  for (const file of FILES) {
    const filePath = path.join(IMPORT_DIR, file);
    const content = fs.readFileSync(filePath, "utf-8");
    const lines = content.split("\n");
    const yearMatch = file.match(/(\d{4})/);
    const year = yearMatch[1];

    // Znajdź granice lig
    const leagueStarts = [];
    for (let i = 0; i < lines.length; i++) {
      const m = lines[i].match(/^\s*-- Liga: (\w+)/);
      if (m) {
        leagueStarts.push({ line: i, code: m[1] });
      }
    }

    // Znajdź koniec bloku (linia z "END $$;")
    let blockEnd = lines.length - 1;
    for (let i = lines.length - 1; i >= 0; i--) {
      if (lines[i].trim() === "END $$;") { blockEnd = i; break; }
    }

    // Dla każdej ligi wyciągnij treść
    console.log(`${file}: ${leagueStarts.length} ligi`);

    for (let li = 0; li < leagueStarts.length; li++) {
      const league = leagueStarts[li];
      const nextStart = li + 1 < leagueStarts.length
        ? leagueStarts[li + 1].line
        : blockEnd;

      // Wyciągnij linie od tej ligi do następnej (pomijając nagłówek -- Liga: i SELECT/IF)
      // Znajdź pierwszą "-- Runda" w tej lidze
      let roundStart = league.line;
      for (let i = league.line + 1; i < nextStart; i++) {
        if (lines[i].trim().startsWith("-- Runda")) {
          roundStart = i;
          break;
        }
      }

      // Znajdź ostatni END IF; przed następną ligą (zamyka IF v_league_id)
      let endIfLine = nextStart - 1;
      for (let i = nextStart - 1; i > league.line; i--) {
        if (lines[i].trim() === "END IF;") {
          endIfLine = i;
          break;
        }
      }

      // Wyciągnij treść rund (bez END IF zamykającego ligę)
      const body = lines.slice(roundStart, endIfLine).join("\n");
      const block = makeBlock(year, league.code, body);
      const sizeKB = (block.length / 1024).toFixed(0);

      process.stdout.write(`  Liga ${league.code} (${sizeKB} KB)... `);
      const start = Date.now();
      const { error } = await sb.rpc("exec_sql", { query: block });
      const elapsed = ((Date.now() - start) / 1000).toFixed(1);

      if (error) {
        console.log(`BŁĄD (${elapsed}s): ${error.message.substring(0, 120)}`);
      } else {
        console.log(`OK (${elapsed}s)`);
      }
    }
  }

  console.log("\n=== Weryfikacja ===");
  const { count } = await sb.from("match_events").select("*", { count: "exact", head: true });
  console.log(`Bramek/wydarzeń w bazie: ${count}`);
}

main().catch(err => { console.error(err); process.exit(1); });
