const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env.local") });
const { createClient } = require("@supabase/supabase-js");

const sb = createClient(
  process.env.REACT_APP_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

async function main() {
  console.log("=== Weryfikacja importu MLPN ===\n");

  // Główne tabele
  const tables = ["seasons", "teams", "players", "matches", "match_events", "rosters", "roster_players", "leagues", "season_leagues", "season_teams", "standings"];
  for (const t of tables) {
    const { count, error } = await sb.from(t).select("*", { count: "exact", head: true });
    console.log(`${t}: ${error ? "BŁĄD - " + error.message : count}`);
  }

  // Sezony
  console.log("\n=== Sezony ===");
  const { data: seasons } = await sb.from("seasons").select("year, name, status").order("year");
  for (const s of seasons) {
    console.log(`  ${s.year}: ${s.name} (${s.status})`);
  }

  // Bramki per sezon
  console.log("\n=== Bramki per sezon ===");
  const { data: events } = await sb.rpc("exec_sql", {
    query: "SELECT 1" // dummy - just to test
  });

  // Użyj zwykłego zapytania
  const { data: matchesBySeason } = await sb
    .from("matches")
    .select("season_id, seasons(year)")
    .not("season_id", "is", null);

  // Policz bramki per sezon przez match_events
  const { data: goalsBySeason } = await sb
    .from("match_events")
    .select("match_id, matches(season_id, seasons(year))")
    .eq("event_type", "GOAL")
    .limit(50000);

  if (goalsBySeason) {
    const countByYear = {};
    for (const g of goalsBySeason) {
      const year = g.matches?.seasons?.year;
      if (year) countByYear[year] = (countByYear[year] || 0) + 1;
    }
    for (const [year, count] of Object.entries(countByYear).sort()) {
      console.log(`  ${year}: ${count} bramek`);
    }
  }

  // Pozycje zawodników
  console.log("\n=== Pozycje zawodników ===");
  const { data: positions } = await sb.from("players").select("position");
  const posCounts = {};
  for (const p of positions || []) {
    posCounts[p.position || "brak"] = (posCounts[p.position || "brak"] || 0) + 1;
  }
  for (const [pos, count] of Object.entries(posCounts).sort()) {
    console.log(`  ${pos}: ${count}`);
  }

  // Aktywni vs nieaktywni
  const { count: active } = await sb.from("players").select("*", { count: "exact", head: true }).eq("is_active", true);
  const { count: inactive } = await sb.from("players").select("*", { count: "exact", head: true }).eq("is_active", false);
  console.log(`\n  Aktywni: ${active}, Nieaktywni: ${inactive}`);
}

main().catch(err => { console.error(err); process.exit(1); });
