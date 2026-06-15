const fs = require("fs");
const path = require("path");
const { Client } = require("pg");

const MIGRATIONS = [
  "024_world_cup_typer.sql",
  "025_world_cup_typer_matches.sql",
  "026_world_cup_typer_admin_lockdown.sql",
  "027_world_cup_typer_scoring.sql",
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
      host: `aws-1-eu-west-1.pooler.supabase.com`,
      port: 5432,
      user: `postgres.${projectRef}`,
      database: "postgres",
      password,
      ssl: { rejectUnauthorized: false },
    },
    {
      name: "pooler-transaction",
      host: `aws-1-eu-west-1.pooler.supabase.com`,
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
      console.log(`[typer-migrations] Polaczono przez ${candidate.name}.`);
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
    const before = await client.query(`
      SELECT
        to_regclass('public.typer_profiles') AS typer_profiles,
        to_regclass('public.typer_picks') AS typer_picks,
        to_regclass('public.typer_world_cup_matches') AS typer_world_cup_matches
    `);
    console.log("[typer-migrations] Przed:", before.rows[0]);

    for (const file of MIGRATIONS) {
      const migrationPath = path.resolve("supabase", "migrations", file);
      const sql = fs.readFileSync(migrationPath, "utf8");
      console.log(`[typer-migrations] Uruchamiam ${file}...`);
      await client.query(sql);
    }

    await client.query("SELECT public.recalculate_all_typer_scores()");
    await client.query("SELECT pg_notify('pgrst', 'reload schema')");

    const after = await client.query(`
      SELECT
        (SELECT count(*) FROM public.typer_profiles) AS profiles,
        (SELECT count(*) FROM public.typer_picks) AS picks,
        (SELECT count(*) FROM public.typer_world_cup_matches) AS matches
    `);
    console.log("[typer-migrations] Po:", after.rows[0]);
    console.log("[typer-migrations] Gotowe.");
  } finally {
    await client.end();
  }
}

main().catch((error) => {
  console.error(`[typer-migrations] BLAD: ${error.message}`);
  process.exit(1);
});
