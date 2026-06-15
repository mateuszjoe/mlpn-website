const fs = require("fs");
const path = require("path");
const { Client } = require("pg");

const RESULTS = [
  {
    match_id: "wc-537327",
    home_score: 2,
    away_score: 0,
    winner: "HOME_TEAM",
    note: "Mexico 2-0 South Africa",
  },
  {
    match_id: "wc-537328",
    home_score: 2,
    away_score: 1,
    winner: "HOME_TEAM",
    note: "Korea Republic 2-1 Czechia",
  },
];

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
      console.log(`[wc-results] Polaczono przez ${candidate.name}.`);
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

  if (!projectRef) {
    throw new Error("Nie moge ustalic project ref z REACT_APP_SUPABASE_URL.");
  }

  if (!password) {
    throw new Error("Brak SUPABASE_DB_PASSWORD w tym terminalu.");
  }

  const client = await connect(projectRef, password);

  try {
    await client.query("BEGIN");

    for (const result of RESULTS) {
      const update = await client.query(
        `
          UPDATE public.typer_world_cup_matches
          SET
            status = 'FINISHED',
            home_score = $2,
            away_score = $3,
            winner = $4,
            updated_at = now()
          WHERE match_id = $1
          RETURNING match_id, home_team_name, away_team_name, home_score, away_score, status
        `,
        [result.match_id, result.home_score, result.away_score, result.winner]
      );

      if (!update.rowCount) {
        throw new Error(`Nie znaleziono meczu ${result.match_id} (${result.note}).`);
      }

      console.log("[wc-results] Zapisano:", update.rows[0]);
    }

    await client.query("SELECT public.recalculate_all_typer_scores()");
    await client.query("SELECT pg_notify('pgrst', 'reload schema')");
    await client.query("COMMIT");

    const { rows } = await client.query(`
      SELECT
        count(*) AS matches,
        count(*) FILTER (WHERE status = 'FINISHED') AS finished,
        count(*) FILTER (WHERE home_score IS NOT NULL AND away_score IS NOT NULL) AS scored
      FROM public.typer_world_cup_matches
    `);

    console.log("[wc-results] Po:", rows[0]);
    console.log("[wc-results] Gotowe.");
  } catch (error) {
    await client.query("ROLLBACK").catch(() => {});
    throw error;
  } finally {
    await client.end();
  }
}

main().catch((error) => {
  console.error(`[wc-results] BLAD: ${error.message}`);
  process.exit(1);
});
