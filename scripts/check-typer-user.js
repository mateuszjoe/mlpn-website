const fs = require("fs");
const path = require("path");
const { Client } = require("pg");

const email = process.argv[2];

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
      return client;
    } catch (error) {
      lastError = error;
      await client.end().catch(() => {});
    }
  }

  throw lastError || new Error("Nie udalo sie polaczyc z baza.");
}

async function main() {
  if (!email) {
    throw new Error("Podaj email, np. node scripts\\check-typer-user.js mateusz@example.com");
  }

  const envFile = readEnvFile();
  const projectRef = getProjectRef(envFile);
  const password = process.env.SUPABASE_DB_PASSWORD || "";

  if (!projectRef) throw new Error("Nie moge ustalic project ref z REACT_APP_SUPABASE_URL.");
  if (!password) throw new Error("Brak SUPABASE_DB_PASSWORD w tym terminalu.");

  const client = await connect(projectRef, password);

  try {
    const accountResult = await client.query(
      `
        SELECT id, email, display_name, account_status
        FROM public.profiles
        WHERE lower(email) = lower($1)
      `,
      [email]
    );

    if (!accountResult.rowCount) {
      console.log(`[check-typer-user] Nie znaleziono konta: ${email}`);
      return;
    }

    const account = accountResult.rows[0];

    const typerResult = await client.query(
      `
        SELECT
          user_id,
          nickname,
          avatar,
          champion_team_id,
          points,
          exact_hits,
          result_hits,
          advance_hits,
          updated_at
        FROM public.typer_profiles
        WHERE user_id = $1
      `,
      [account.id]
    );

    const picksResult = await client.query(
      `
        SELECT
          count(*) AS picks,
          count(*) FILTER (WHERE confirmed) AS confirmed,
          count(*) FILTER (
            WHERE match_id IN (
              SELECT match_id
              FROM public.typer_world_cup_matches
              WHERE status = 'FINISHED'
                AND home_score IS NOT NULL
                AND away_score IS NOT NULL
            )
          ) AS scored_pick_candidates
        FROM public.typer_picks
        WHERE user_id = $1
      `,
      [account.id]
    );

    const typer = typerResult.rows[0] || null;
    const picks = picksResult.rows[0];

    console.log("[check-typer-user] Konto:", {
      email: account.email,
      display_name: account.display_name,
      account_status: account.account_status,
    });

    if (!typer) {
      console.log("[check-typer-user] Profil typera: brak");
    } else {
      console.log("[check-typer-user] Profil typera:", {
        nickname: typer.nickname,
        placeholder: typer.avatar?.source === "profiles-backfill",
        champion_team_id: typer.champion_team_id,
        points: Number(typer.points || 0),
        exact_hits: Number(typer.exact_hits || 0),
        result_hits: Number(typer.result_hits || 0),
        advance_hits: Number(typer.advance_hits || 0),
        updated_at: typer.updated_at,
      });
    }

    console.log("[check-typer-user] Typy:", {
      saved: Number(picks.picks || 0),
      confirmed: Number(picks.confirmed || 0),
      for_finished_matches: Number(picks.scored_pick_candidates || 0),
    });
  } finally {
    await client.end();
  }
}

main().catch((error) => {
  console.error(`[check-typer-user] BLAD: ${error.message}`);
  process.exit(1);
});
