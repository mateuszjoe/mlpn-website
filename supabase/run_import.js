/**
 * Automatyczny import SQL do Supabase (przez RPC + service key)
 *
 * Uruchomienie: node supabase/run_import.js
 *
 * WYMAGANE:
 * 1. Funkcja exec_sql w bazie (jednorazowo w SQL Editor):
 *    CREATE OR REPLACE FUNCTION exec_sql(query text) RETURNS void
 *    LANGUAGE plpgsql SECURITY DEFINER AS $$ BEGIN EXECUTE query; END; $$;
 *
 * 2. W .env.local: SUPABASE_SERVICE_KEY=sb_secret_...
 */

const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env.local") });

const { createClient } = require("@supabase/supabase-js");

const SUPABASE_URL = process.env.REACT_APP_SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY;

if (!SUPABASE_URL || !SERVICE_KEY) {
  console.error("Brak REACT_APP_SUPABASE_URL lub SUPABASE_SERVICE_KEY w .env.local");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SERVICE_KEY);

const IMPORT_DIR = path.join(__dirname, "import");

// Kolejność importu — ważne! Zależności: players → rosters → goals
const FILES_ORDER = [
  // Faza 1: Zawodnicy
  "players_import.sql",
  "players_l98_supplement.sql",

  // Faza 2: Kadry
  "rosters_00_setup.sql",
  "rosters_l98_2003.sql",
  "rosters_l98_2004.sql",
  "rosters_l98_2005.sql",
  "rosters_l98_2006.sql",
  "rosters_l98_2007.sql",
  "rosters_l98_2008.sql",
  "rosters_l98_2009.sql",
  "rosters_l98_2010.sql",
  "rosters_l98_2011.sql",
  "rosters_l98_2012.sql",
  "rosters_l98_2013.sql",
  "rosters_l98_2014.sql",
  "rosters_l98_2015.sql",
  "rosters_l98_2016.sql",
  "rosters_l98_2017.sql",
  "rosters_2018.sql",
  "rosters_2019.sql",
  "rosters_2020.sql",
  "rosters_2021.sql",
  "rosters_2022.sql",
  "rosters_2023.sql",
  "rosters_2024.sql",
  "rosters_2025.sql",

  // Faza 3: Bramki
  "goals_2003.sql",
  "goals_2004.sql",
  "goals_2005.sql",
  "goals_2006.sql",
  "goals_2007.sql",
  "goals_2008.sql",
  "goals_2009.sql",
  "goals_2010.sql",
  "goals_2011.sql",
  "goals_2012.sql",
  "goals_2013.sql",
  "goals_2014.sql",
  "goals_2015.sql",
  "goals_2016.sql",
  "goals_2017.sql",
];

// Dzieli SQL na mniejsze bloki (po DO $$ ... END $$; lub grupy INSERT-ów)
function splitSql(sql, maxChunkSize = 500000) {
  // Jeśli plik mały — wyślij w całości
  if (sql.length <= maxChunkSize) return [sql];

  const chunks = [];

  // Sprawdź czy to plik z DO $$ blokami
  if (sql.includes("DO $$")) {
    // Podziel na poszczególne DO $$ ... END $$; bloki
    const blocks = sql.split(/(?=DO \$\$)/);
    let current = "";

    for (const block of blocks) {
      if (!block.trim()) continue;

      if (current.length + block.length > maxChunkSize && current.length > 0) {
        chunks.push(current);
        current = "";
      }
      current += block;
    }
    if (current.trim()) chunks.push(current);
  } else {
    // Plik z INSERT-ami — dziel po liniach
    const lines = sql.split("\n");
    let current = "";

    for (const line of lines) {
      if (current.length + line.length > maxChunkSize && current.length > 0) {
        chunks.push(current);
        current = "";
      }
      current += line + "\n";
    }
    if (current.trim()) chunks.push(current);
  }

  return chunks.length > 0 ? chunks : [sql];
}

async function main() {
  // Sprawdź które pliki istnieją
  const filesToRun = [];
  const missing = [];
  for (const file of FILES_ORDER) {
    const filePath = path.join(IMPORT_DIR, file);
    if (fs.existsSync(filePath)) {
      const size = fs.statSync(filePath).size;
      filesToRun.push({ name: file, path: filePath, size });
    } else {
      missing.push(file);
    }
  }

  if (missing.length > 0) {
    console.log(`Brakujące pliki (pominięte): ${missing.join(", ")}`);
  }

  const totalSize = filesToRun.reduce((sum, f) => sum + f.size, 0);
  console.log(`\n=== Import SQL do Supabase ===`);
  console.log(`Plików do uruchomienia: ${filesToRun.length}`);
  console.log(`Łączny rozmiar: ${(totalSize / 1024 / 1024).toFixed(1)} MB`);
  console.log(`Metoda: Supabase RPC (exec_sql)\n`);

  // Test połączenia
  process.stdout.write("Test połączenia... ");
  const { error: testErr } = await supabase.rpc("exec_sql", { query: "SELECT 1" });
  if (testErr) {
    console.log("BŁĄD!");
    console.error(`→ ${testErr.message}`);
    if (testErr.message.includes("exec_sql")) {
      console.error("\nFunkcja exec_sql nie istnieje w bazie.");
      console.error("Wklej w Supabase SQL Editor:");
      console.error("  CREATE OR REPLACE FUNCTION exec_sql(query text) RETURNS void");
      console.error("  LANGUAGE plpgsql SECURITY DEFINER AS $$ BEGIN EXECUTE query; END; $$;");
    }
    process.exit(1);
  }
  console.log("OK!\n");

  let success = 0;
  let errors = 0;
  const startTime = Date.now();

  for (let i = 0; i < filesToRun.length; i++) {
    const file = filesToRun[i];
    const num = `[${i + 1}/${filesToRun.length}]`;
    const sizeKB = (file.size / 1024).toFixed(0);
    process.stdout.write(`${num} ${file.name} (${sizeKB} KB)... `);

    try {
      const sql = fs.readFileSync(file.path, "utf-8");
      const chunks = splitSql(sql);
      const fileStart = Date.now();

      if (chunks.length > 1) {
        process.stdout.write(`${chunks.length} części... `);
      }

      let chunkErrors = 0;
      for (let c = 0; c < chunks.length; c++) {
        const { error } = await supabase.rpc("exec_sql", { query: chunks[c] });
        if (error) {
          chunkErrors++;
          if (chunkErrors === 1) {
            console.log(`\n   BŁĄD w części ${c + 1}: ${error.message.substring(0, 150)}`);
          }
        }
      }

      const elapsed = ((Date.now() - fileStart) / 1000).toFixed(1);
      if (chunkErrors === 0) {
        console.log(`OK (${elapsed}s)`);
        success++;
      } else {
        console.log(`   ${chunks.length - chunkErrors}/${chunks.length} części OK (${elapsed}s)`);
        errors++;
      }
    } catch (err) {
      console.log(`BŁĄD!`);
      console.error(`   → ${err.message.substring(0, 200)}`);
      errors++;
    }
  }

  const totalTime = ((Date.now() - startTime) / 1000).toFixed(0);

  console.log(`\n=== GOTOWE (${totalTime}s) ===`);
  console.log(`Udanych: ${success}`);
  console.log(`Błędów: ${errors}`);

  // Weryfikacja
  console.log(`\n=== Weryfikacja ===`);
  try {
    const { count: playerCount } = await supabase.from("players").select("*", { count: "exact", head: true });
    console.log(`Zawodników: ${playerCount}`);

    const { count: rosterCount } = await supabase.from("rosters").select("*", { count: "exact", head: true });
    console.log(`Kadr: ${rosterCount}`);

    const { count: rpCount } = await supabase.from("roster_players").select("*", { count: "exact", head: true });
    console.log(`Przypisań gracz→kadra: ${rpCount}`);

    const { count: eventCount } = await supabase.from("match_events").select("*", { count: "exact", head: true });
    console.log(`Bramek/wydarzeń: ${eventCount}`);

    const { count: matchCount } = await supabase.from("matches").select("*", { count: "exact", head: true });
    console.log(`Meczów: ${matchCount}`);

    const { count: seasonCount } = await supabase.from("seasons").select("*", { count: "exact", head: true });
    console.log(`Sezonów: ${seasonCount}`);

    const { count: teamCount } = await supabase.from("teams").select("*", { count: "exact", head: true });
    console.log(`Drużyn: ${teamCount}`);
  } catch (err) {
    console.error("Błąd weryfikacji:", err.message);
  }
}

main().catch(err => {
  console.error("Krytyczny błąd:", err);
  process.exit(1);
});
