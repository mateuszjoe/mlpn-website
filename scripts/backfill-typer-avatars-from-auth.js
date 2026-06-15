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
      console.log(`[typer-avatar-backfill] Polaczono przez ${candidate.name}.`);
      return client;
    } catch (error) {
      lastError = error;
      await client.end().catch(() => {});
    }
  }

  throw lastError || new Error("Nie udalo sie polaczyc z baza.");
}

function metadataString(data, keys) {
  for (const key of keys) {
    const value = data?.[key];
    if (typeof value === "string" && value.trim()) return value.trim();
  }
  return "";
}

function avatarFromProvider(provider, data) {
  const directUrl = metadataString(data, ["avatar_url", "picture"]);
  const nestedUrl = typeof data?.picture?.data?.url === "string" ? data.picture.data.url : "";
  const providerId = metadataString(data, ["sub", "id", "user_id"]);
  const url =
    directUrl ||
    nestedUrl ||
    (provider === "facebook" && providerId ? `https://graph.facebook.com/${providerId}/picture?type=large` : "");

  if (!url) return null;

  return {
    type: provider === "google" || provider === "facebook" ? provider : "upload",
    url,
    source: "auth-metadata",
  };
}

function avatarFromAuth(row) {
  const identities = Array.isArray(row.identities) ? row.identities : [];
  const preferredProviders = ["google", "facebook"];

  for (const provider of preferredProviders) {
    const identity = identities.find((item) => item.provider === provider);
    const avatar = avatarFromProvider(provider, identity?.identity_data || {});
    if (avatar) return avatar;
  }

  for (const identity of identities) {
    const avatar = avatarFromProvider(identity.provider, identity.identity_data || {});
    if (avatar) return avatar;
  }

  const metadataUrl = metadataString(row.raw_user_meta_data || {}, ["avatar_url", "picture"]);
  if (metadataUrl) {
    return { type: "upload", url: metadataUrl, source: "auth-metadata" };
  }

  return null;
}

async function main() {
  const envFile = readEnvFile();
  const projectRef = getProjectRef(envFile);
  const password = process.env.SUPABASE_DB_PASSWORD || "";

  if (!projectRef) throw new Error("Nie moge ustalic project ref z REACT_APP_SUPABASE_URL.");
  if (!password) throw new Error("Brak SUPABASE_DB_PASSWORD w tym terminalu.");

  const client = await connect(projectRef, password);

  try {
    const { rows } = await client.query(`
      SELECT
        profile.user_id,
        profile.nickname,
        profile.avatar,
        auth_user.raw_user_meta_data,
        coalesce(
          jsonb_agg(
            jsonb_build_object(
              'provider', identity.provider,
              'identity_data', identity.identity_data
            )
          ) FILTER (WHERE identity.id IS NOT NULL),
          '[]'::jsonb
        ) AS identities
      FROM public.typer_profiles profile
      JOIN auth.users auth_user
        ON auth_user.id = profile.user_id
      LEFT JOIN auth.identities identity
        ON identity.user_id = auth_user.id
      WHERE profile.avatar ->> 'source' = 'profiles-backfill'
      GROUP BY profile.user_id, auth_user.id
      ORDER BY profile.created_at
    `);

    let updated = 0;
    let skipped = 0;

    await client.query("BEGIN");

    for (const row of rows) {
      const avatar = avatarFromAuth(row);

      if (!avatar?.url) {
        skipped += 1;
        continue;
      }

      await client.query(
        `
          UPDATE public.typer_profiles
          SET
            avatar = $2::jsonb,
            avatar_url = $3,
            updated_at = now()
          WHERE user_id = $1
            AND avatar ->> 'source' = 'profiles-backfill'
        `,
        [row.user_id, JSON.stringify(avatar), avatar.url]
      );
      updated += 1;
    }

    await client.query("SELECT pg_notify('pgrst', 'reload schema')");
    await client.query("COMMIT");

    console.log("[typer-avatar-backfill] Po:", {
      checked: rows.length,
      updated,
      skipped_without_auth_avatar: skipped,
    });
    console.log("[typer-avatar-backfill] Gotowe.");
  } catch (error) {
    await client.query("ROLLBACK").catch(() => {});
    throw error;
  } finally {
    await client.end();
  }
}

main().catch((error) => {
  console.error(`[typer-avatar-backfill] BLAD: ${error.message}`);
  process.exit(1);
});
