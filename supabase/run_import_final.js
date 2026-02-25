const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env.local") });
const { createClient } = require("@supabase/supabase-js");

const sb = createClient(
  process.env.REACT_APP_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

const IMPORT_DIR = path.join(__dirname, "import");
const FILES = ["goals_2008.sql", "goals_2009.sql", "goals_2015.sql", "goals_2016.sql"];

async function main() {
  console.log("=== Import brakujących bramek (timeout 300s) ===\n");

  for (const file of FILES) {
    const filePath = path.join(IMPORT_DIR, file);
    const sql = fs.readFileSync(filePath, "utf-8");
    const sizeKB = (sql.length / 1024).toFixed(0);

    process.stdout.write(`${file} (${sizeKB} KB)... `);
    const start = Date.now();
    const { error } = await sb.rpc("exec_sql", { query: sql });
    const elapsed = ((Date.now() - start) / 1000).toFixed(1);

    if (error) {
      console.log(`BŁĄD (${elapsed}s): ${error.message.substring(0, 150)}`);
    } else {
      console.log(`OK (${elapsed}s)`);
    }
  }

  console.log("\n=== Weryfikacja ===");
  const { count } = await sb.from("match_events").select("*", { count: "exact", head: true });
  console.log(`Bramek/wydarzeń w bazie: ${count}`);
}

main().catch(err => { console.error(err); process.exit(1); });
