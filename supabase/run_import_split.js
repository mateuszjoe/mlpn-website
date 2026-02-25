/**
 * Import podzielonych plików bramek (z folderu split/)
 * Dla sezonów które się nie zmieściły w limicie czasu
 */

const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env.local") });
const { createClient } = require("@supabase/supabase-js");

const supabase = createClient(
  process.env.REACT_APP_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

const SPLIT_DIR = path.join(__dirname, "import", "split");

async function main() {
  console.log("=== Import podzielonych bramek ===\n");

  // Znajdź pliki do uruchomienia (2008, 2009, 2015, 2016)
  const files = fs.readdirSync(SPLIT_DIR)
    .filter(f => f.match(/goals_(2008|2009|2015|2016)_part\d+\.sql$/))
    .sort();

  console.log(`Plików: ${files.length}\n`);

  let success = 0;
  let errors = 0;

  for (let i = 0; i < files.length; i++) {
    const file = files[i];
    const filePath = path.join(SPLIT_DIR, file);
    const sql = fs.readFileSync(filePath, "utf-8");
    const sizeKB = (sql.length / 1024).toFixed(0);

    process.stdout.write(`[${i + 1}/${files.length}] ${file} (${sizeKB} KB)... `);
    const start = Date.now();
    const { error } = await supabase.rpc("exec_sql", { query: sql });
    const elapsed = ((Date.now() - start) / 1000).toFixed(1);

    if (error) {
      console.log(`BŁĄD (${elapsed}s): ${error.message.substring(0, 120)}`);
      errors++;
    } else {
      console.log(`OK (${elapsed}s)`);
      success++;
    }
  }

  console.log(`\n=== Gotowe ===`);
  console.log(`OK: ${success}, błędów: ${errors}`);

  const { count } = await supabase.from("match_events").select("*", { count: "exact", head: true });
  console.log(`Bramek/wydarzeń w bazie: ${count}`);
}

main().catch(err => { console.error(err); process.exit(1); });
