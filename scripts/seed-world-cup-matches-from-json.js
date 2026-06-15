const fs = require("fs");
const path = require("path");
const { Client } = require("pg");

function readEnvFile() {
  const envPath = path.resolve(".env.local");
  const values = {};

  if (!fs.existsSync(envPath)) return values;

  for (const line of fs.readFileSync(envPath, "utf8").split(/\r?\n/)) {
    const match = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$/);
    if (!match) continue;

    let value = match[2].trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    values[match[1]] = value;
  }

  return values;
}

function getProjectRef(envFile) {
  const supabaseUrl = process.env.REACT_APP_SUPABASE_URL || envFile.REACT_APP_SUPABASE_URL || "";

  try {
    return new URL(supabaseUrl).host.replace(/\.supabase\.co$/, "");
  } catch {
    return "";
  }
}

function createCandidates(projectRef, password) {
  return [
    {
      name: "pooler-session",
      host: "aws-1-eu-west-1.pooler.supabase.com",
      port: 5432,
      user: `postgres.${projectRef}`,
      database: "postgres",
      password,
      ssl: { rejectUnauthorized: false },
    },
    {
      name: "pooler-transaction",
      host: "aws-1-eu-west-1.pooler.supabase.com",
      port: 6543,
      user: `postgres.${projectRef}`,
      database: "postgres",
      password,
      ssl: { rejectUnauthorized: false },
    },
    {
      name: "direct",
      host: `db.${projectRef}.supabase.co`,
      port: 5432,
      user: "postgres",
      database: "postgres",
      password,
      ssl: { rejectUnauthorized: false },
    },
  ];
}

async function connect(projectRef, password) {
  let lastError = null;

  for (const candidate of createCandidates(projectRef, password)) {
    const client = new Client(candidate);
    try {
      await client.connect();
      console.log(`[wc-seed] Polaczono przez ${candidate.name}.`);
      return client;
    } catch (error) {
      lastError = error;
      await client.end().catch(() => {});
    }
  }

  throw lastError || new Error("Nie udalo sie polaczyc z baza.");
}

async function main() {
  const envFile = readEnvFile();
  const projectRef = getProjectRef(envFile);
  const password = process.env.SUPABASE_DB_PASSWORD || "";
  const matchesPath = path.resolve("src", "data", "wc2026Matches.json");
  const matches = JSON.parse(fs.readFileSync(matchesPath, "utf8"));

  if (!projectRef) {
    throw new Error("Nie moge ustalic project ref z REACT_APP_SUPABASE_URL.");
  }

  if (!password) {
    throw new Error("Brak SUPABASE_DB_PASSWORD w tym terminalu.");
  }

  if (!Array.isArray(matches) || matches.length < 64) {
    throw new Error(`Plik wc2026Matches.json ma niepoprawna liczbe meczow: ${matches.length || 0}.`);
  }

  const client = await connect(projectRef, password);

  try {
    await client.query("BEGIN");

    for (const match of matches) {
      await client.query(
        `
          INSERT INTO public.typer_world_cup_matches (
            match_id,
            stage,
            group_code,
            matchday,
            kickoff_at,
            home_team_id,
            home_team_name,
            home_team_crest,
            away_team_id,
            away_team_name,
            away_team_crest,
            status,
            duration,
            winner,
            home_score,
            away_score,
            source_payload
          )
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17::jsonb)
          ON CONFLICT (match_id) DO UPDATE SET
            stage = EXCLUDED.stage,
            group_code = EXCLUDED.group_code,
            matchday = EXCLUDED.matchday,
            kickoff_at = EXCLUDED.kickoff_at,
            home_team_id = EXCLUDED.home_team_id,
            home_team_name = EXCLUDED.home_team_name,
            home_team_crest = EXCLUDED.home_team_crest,
            away_team_id = EXCLUDED.away_team_id,
            away_team_name = EXCLUDED.away_team_name,
            away_team_crest = EXCLUDED.away_team_crest,
            status = EXCLUDED.status,
            duration = EXCLUDED.duration,
            winner = EXCLUDED.winner,
            home_score = EXCLUDED.home_score,
            away_score = EXCLUDED.away_score,
            source_payload = EXCLUDED.source_payload
        `,
        [
          match.id,
          match.stage || null,
          match.group || null,
          match.matchday || null,
          match.kickoffAt || null,
          match.homeTeam?.id || null,
          match.homeTeam?.name || "TBD",
          match.homeTeam?.crest || "",
          match.awayTeam?.id || null,
          match.awayTeam?.name || "TBD",
          match.awayTeam?.crest || "",
          match.status || "TIMED",
          match.duration || "REGULAR",
          match.winner || null,
          match.homeScore ?? null,
          match.awayScore ?? null,
          JSON.stringify(match),
        ]
      );
    }

    await client.query("SELECT public.recalculate_all_typer_scores()");
    await client.query("SELECT pg_notify('pgrst', 'reload schema')");
    await client.query("COMMIT");

    const { rows } = await client.query(`
      SELECT
        count(*) AS matches,
        count(*) FILTER (WHERE home_score IS NOT NULL AND away_score IS NOT NULL) AS scored_matches
      FROM public.typer_world_cup_matches
    `);

    console.log("[wc-seed] Po:", rows[0]);
    console.log("[wc-seed] Gotowe.");
  } catch (error) {
    await client.query("ROLLBACK").catch(() => {});
    throw error;
  } finally {
    await client.end();
  }
}

main().catch((error) => {
  console.error(`[wc-seed] BLAD: ${error.message}`);
  process.exit(1);
});
