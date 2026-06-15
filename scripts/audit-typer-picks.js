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
      console.log(`[typer-audit] Polaczono przez ${candidate.name}.`);
      return client;
    } catch (error) {
      lastError = error;
      await client.end().catch(() => {});
    }
  }

  throw lastError || new Error("Nie udalo sie polaczyc z baza.");
}

function number(value) {
  return Number(value || 0);
}

async function main() {
  const envFile = readEnvFile();
  const projectRef = getProjectRef(envFile);
  const password = process.env.SUPABASE_DB_PASSWORD || "";

  if (!projectRef) throw new Error("Nie moge ustalic project ref z REACT_APP_SUPABASE_URL.");
  if (!password) throw new Error("Brak SUPABASE_DB_PASSWORD w tym terminalu.");

  const client = await connect(projectRef, password);

  try {
    await client.query("SELECT public.recalculate_all_typer_scores()");

    const { rows: summaryRows } = await client.query(`
      WITH profile_scores AS (
        SELECT
          profile.user_id,
          profile.nickname,
          profile.email,
          profile.points,
          profile.exact_hits,
          profile.result_hits,
          profile.advance_hits,
          profile.avatar ->> 'source' AS avatar_source,
          count(pick.id) AS picks_total,
          count(pick.id) FILTER (WHERE pick.confirmed) AS confirmed_total,
          count(pick.id) FILTER (
            WHERE match.status = 'FINISHED'
              AND match.home_score IS NOT NULL
              AND match.away_score IS NOT NULL
          ) AS finished_picks,
          coalesce(sum(score.points), 0)::INTEGER AS calculated_points,
          coalesce(sum(score.exact_hit), 0)::INTEGER AS calculated_exact,
          coalesce(sum(score.result_hit), 0)::INTEGER AS calculated_result
        FROM public.typer_profiles profile
        LEFT JOIN public.typer_picks pick
          ON pick.user_id = profile.user_id
        LEFT JOIN public.typer_world_cup_matches match
          ON match.match_id = pick.match_id
        LEFT JOIN LATERAL public.calculate_typer_pick_score(
          match.status,
          match.stage,
          match.winner,
          match.home_team_id,
          match.away_team_id,
          match.home_score,
          match.away_score,
          pick.home_score,
          pick.away_score,
          pick.advance_team_id
        ) AS score ON pick.id IS NOT NULL
        GROUP BY profile.user_id
      )
      SELECT
        count(*) AS profiles,
        count(*) FILTER (WHERE avatar_source = 'profiles-backfill') AS placeholder_profiles,
        count(*) FILTER (WHERE points > 0) AS profiles_with_points,
        count(*) FILTER (WHERE picks_total > 0) AS profiles_with_any_picks,
        count(*) FILTER (WHERE finished_picks > 0) AS profiles_with_finished_picks,
        count(*) FILTER (WHERE points = 0 AND picks_total = 0) AS zero_points_no_picks,
        count(*) FILTER (WHERE points = 0 AND picks_total > 0 AND finished_picks = 0) AS zero_points_no_finished_picks,
        count(*) FILTER (WHERE points = 0 AND finished_picks > 0) AS zero_points_with_finished_picks,
        coalesce(sum(picks_total), 0)::INTEGER AS picks_total,
        coalesce(sum(confirmed_total), 0)::INTEGER AS confirmed_total,
        coalesce(sum(finished_picks), 0)::INTEGER AS finished_picks_total
      FROM profile_scores
    `);

    const { rows: finishedRows } = await client.query(`
      SELECT
        match.match_id,
        match.home_team_name,
        match.away_team_name,
        match.home_score,
        match.away_score,
        count(pick.id) AS picks,
        count(pick.id) FILTER (WHERE pick.confirmed) AS confirmed,
        coalesce(sum(score.points), 0)::INTEGER AS points_awarded,
        coalesce(sum(score.exact_hit), 0)::INTEGER AS exact_hits,
        coalesce(sum(score.result_hit), 0)::INTEGER AS result_hits
      FROM public.typer_world_cup_matches match
      LEFT JOIN public.typer_picks pick
        ON pick.match_id = match.match_id
      LEFT JOIN LATERAL public.calculate_typer_pick_score(
        match.status,
        match.stage,
        match.winner,
        match.home_team_id,
        match.away_team_id,
        match.home_score,
        match.away_score,
        pick.home_score,
        pick.away_score,
        pick.advance_team_id
      ) AS score ON pick.id IS NOT NULL
      WHERE match.status = 'FINISHED'
        AND match.home_score IS NOT NULL
        AND match.away_score IS NOT NULL
      GROUP BY match.match_id
      ORDER BY match.kickoff_at
    `);

    const { rows: profileRows } = await client.query(`
      WITH profile_scores AS (
        SELECT
          profile.nickname,
          profile.email,
          profile.points,
          profile.exact_hits,
          profile.result_hits,
          profile.avatar ->> 'source' AS avatar_source,
          count(pick.id) AS picks_total,
          count(pick.id) FILTER (WHERE pick.confirmed) AS confirmed_total,
          count(pick.id) FILTER (
            WHERE match.status = 'FINISHED'
              AND match.home_score IS NOT NULL
              AND match.away_score IS NOT NULL
          ) AS finished_picks
        FROM public.typer_profiles profile
        LEFT JOIN public.typer_picks pick
          ON pick.user_id = profile.user_id
        LEFT JOIN public.typer_world_cup_matches match
          ON match.match_id = pick.match_id
        GROUP BY profile.user_id
      )
      SELECT
        nickname,
        email,
        points,
        exact_hits,
        result_hits,
        picks_total,
        confirmed_total,
        finished_picks,
        avatar_source = 'profiles-backfill' AS placeholder
      FROM profile_scores
      ORDER BY points DESC, exact_hits DESC, finished_picks DESC, picks_total DESC, lower(nickname)
      LIMIT 80
    `);

    const summary = summaryRows[0] || {};
    console.log("[typer-audit] Podsumowanie:", {
      profiles: number(summary.profiles),
      placeholder_profiles: number(summary.placeholder_profiles),
      profiles_with_points: number(summary.profiles_with_points),
      profiles_with_any_picks: number(summary.profiles_with_any_picks),
      profiles_with_finished_picks: number(summary.profiles_with_finished_picks),
      zero_points_no_picks: number(summary.zero_points_no_picks),
      zero_points_no_finished_picks: number(summary.zero_points_no_finished_picks),
      zero_points_with_finished_picks: number(summary.zero_points_with_finished_picks),
      picks_total: number(summary.picks_total),
      confirmed_total: number(summary.confirmed_total),
      finished_picks_total: number(summary.finished_picks_total),
    });

    console.log("[typer-audit] Skonczone mecze:");
    console.table(
      finishedRows.map((row) => ({
        match: row.match_id,
        result: `${row.home_team_name} ${row.home_score}-${row.away_score} ${row.away_team_name}`,
        picks: number(row.picks),
        confirmed: number(row.confirmed),
        points: number(row.points_awarded),
        exact: number(row.exact_hits),
        result_hit: number(row.result_hits),
      }))
    );

    console.log("[typer-audit] Profile:");
    console.table(
      profileRows.map((row) => ({
        nick: row.nickname,
        points: number(row.points),
        exact: number(row.exact_hits),
        result: number(row.result_hits),
        picks: number(row.picks_total),
        finished_picks: number(row.finished_picks),
        confirmed: number(row.confirmed_total),
        placeholder: row.placeholder,
      }))
    );
  } finally {
    await client.end();
  }
}

main().catch((error) => {
  console.error(`[typer-audit] BLAD: ${error.message}`);
  process.exit(1);
});
