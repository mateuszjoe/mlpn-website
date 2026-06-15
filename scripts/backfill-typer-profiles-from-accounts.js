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
      console.log(`[typer-backfill] Polaczono przez ${candidate.name}.`);
      return client;
    } catch (error) {
      lastError = error;
      await client.end().catch(() => {});
    }
  }

  throw lastError || new Error("Nie udalo sie polaczyc z baza.");
}

function normalizeNickname(value, fallback) {
  const raw = String(value || fallback || "Kibic MLPN").trim();
  const withoutEmailDomain = raw.includes("@") ? raw.split("@")[0] : raw;
  const compact = withoutEmailDomain.replace(/[_-]+/g, " ").replace(/\s+/g, " ").trim();
  const base = compact.length >= 3 ? compact : "Kibic MLPN";
  return base.slice(0, 28).trim() || "Kibic MLPN";
}

function makeUniqueNickname(base, usedNicknames) {
  let candidate = base;
  let index = 2;

  while (usedNicknames.has(candidate.toLowerCase())) {
    const suffix = ` ${index}`;
    candidate = `${base.slice(0, 28 - suffix.length).trim()}${suffix}`;
    index += 1;
  }

  usedNicknames.add(candidate.toLowerCase());
  return candidate;
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
    const accountsResult = await client.query(`
      SELECT
        p.id,
        p.email,
        NULLIF(trim(p.display_name), '') AS display_name,
        NULLIF(trim(concat_ws(' ', p.first_name, p.last_name)), '') AS full_name
      FROM public.profiles p
      WHERE coalesce(p.account_status, 'active') = 'active'
      ORDER BY p.created_at ASC
    `);

    const existingResult = await client.query(`
      SELECT user_id, nickname
      FROM public.typer_profiles
    `);

    const existingUserIds = new Set(existingResult.rows.map((row) => row.user_id));
    const usedNicknames = new Set(existingResult.rows.map((row) => String(row.nickname || "").toLowerCase()));
    const missingAccounts = accountsResult.rows.filter((row) => !existingUserIds.has(row.id));

    console.log(`[typer-backfill] Aktywne konta: ${accountsResult.rowCount}`);
    console.log(`[typer-backfill] Istniejace profile typera: ${existingResult.rowCount}`);
    console.log(`[typer-backfill] Do dodania: ${missingAccounts.length}`);

    await client.query("BEGIN");

    for (const account of missingAccounts) {
      const baseNickname = normalizeNickname(
        account.display_name || account.full_name || account.email,
        "Kibic MLPN"
      );
      const nickname = makeUniqueNickname(baseNickname, usedNicknames);

      await client.query(
        `
          INSERT INTO public.typer_profiles (
            user_id,
            email,
            nickname,
            avatar,
            status,
            warnings_count
          )
          VALUES ($1, $2, $3, $4::jsonb, 'approved', 0)
          ON CONFLICT (user_id) DO NOTHING
        `,
        [
          account.id,
          account.email || null,
          nickname,
          JSON.stringify({ type: "default", id: "playmaker-01", source: "profiles-backfill" }),
        ]
      );
    }

    await client.query("SELECT public.recalculate_all_typer_scores()");
    await client.query("SELECT pg_notify('pgrst', 'reload schema')");
    await client.query("COMMIT");

    const after = await client.query(`
      SELECT
        count(*) AS profiles,
        count(*) FILTER (WHERE avatar->>'source' = 'profiles-backfill') AS placeholders
      FROM public.typer_profiles
    `);

    console.log("[typer-backfill] Po:", after.rows[0]);
    console.log("[typer-backfill] Gotowe.");
  } catch (error) {
    await client.query("ROLLBACK").catch(() => {});
    throw error;
  } finally {
    await client.end();
  }
}

main().catch((error) => {
  console.error(`[typer-backfill] BLAD: ${error.message}`);
  process.exit(1);
});
