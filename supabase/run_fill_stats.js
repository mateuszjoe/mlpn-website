#!/usr/bin/env node
/**
 * Skrypt uzupełniający player_season_stats z team_players.
 *
 * Problem: Wielu zawodników ma wpisy w team_players (kadry),
 * ale nie ma wpisów w player_season_stats, bo trigger
 * uzupełnia stats tylko przy match_events (bramki/kartki).
 *
 * Uruchomienie: node supabase/run_fill_stats.js
 */

const { Client } = require('pg');

const DB_HOST = 'db.npbpegyfsxbsuzlixqva.supabase.co';
const DB_PORT = 5432;
const DB_NAME = 'postgres';
const DB_USER = 'postgres';
const DB_PASS = '1tVvZofrnRpUrW9a';

async function main() {
  const client = new Client({
    host: DB_HOST,
    port: DB_PORT,
    database: DB_NAME,
    user: DB_USER,
    password: DB_PASS,
    ssl: { rejectUnauthorized: false },
  });

  try {
    console.log('Łączenie z bazą Supabase...');
    await client.connect();
    console.log('Połączono!\n');

    // Stan PRZED
    const before = await client.query(`
      SELECT COUNT(*) AS cnt FROM player_season_stats
    `);
    console.log(`player_season_stats PRZED: ${before.rows[0].cnt} rekordów`);

    const tpCount = await client.query(`
      SELECT COUNT(DISTINCT (player_id, season_id, league_id)) AS cnt FROM team_players
    `);
    console.log(`team_players (unikalne player+season+league): ${tpCount.rows[0].cnt}`);

    const missing = await client.query(`
      SELECT COUNT(*) AS cnt FROM (
        SELECT DISTINCT tp.player_id, tp.season_id, tp.league_id
        FROM team_players tp
        WHERE NOT EXISTS (
          SELECT 1 FROM player_season_stats pss
          WHERE pss.player_id = tp.player_id
            AND pss.season_id = tp.season_id
            AND pss.league_id = tp.league_id
        )
      ) x
    `);
    console.log(`Brakujących wpisów do uzupełnienia: ${missing.rows[0].cnt}\n`);

    // KROK 1: Wstaw brakujące
    console.log('KROK 1: Wstawianie brakujących wpisów player_season_stats...');
    const insertResult = await client.query(`
      INSERT INTO player_season_stats (
          player_id, season_id, league_id, team_id,
          appearances, goals, assists, yellow_cards, red_cards
      )
      SELECT DISTINCT ON (tp.player_id, tp.season_id, tp.league_id)
          tp.player_id,
          tp.season_id,
          tp.league_id,
          tp.team_id,
          -- appearances: policz mecze drużyny w tym sezonie/lidze
          COALESCE((
              SELECT COUNT(*)
              FROM matches m
              WHERE m.season_id = tp.season_id
                AND m.league_id = tp.league_id
                AND (m.home_team_id = tp.team_id OR m.away_team_id = tp.team_id)
                AND m.status IN ('completed', 'walkover_home', 'walkover_away')
          ), 0),
          -- goals
          COALESCE((
              SELECT COUNT(*)
              FROM match_events me
              JOIN matches m ON m.id = me.match_id
              WHERE me.player_id = tp.player_id
                AND me.event_type = 'GOAL'
                AND me.is_own_goal = false
                AND m.season_id = tp.season_id
                AND m.league_id = tp.league_id
          ), 0),
          -- assists
          COALESCE((
              SELECT COUNT(*)
              FROM match_events me
              JOIN matches m ON m.id = me.match_id
              WHERE me.assist_player_id = tp.player_id
                AND me.event_type = 'GOAL'
                AND m.season_id = tp.season_id
                AND m.league_id = tp.league_id
          ), 0),
          -- yellow_cards
          COALESCE((
              SELECT COUNT(*)
              FROM match_events me
              JOIN matches m ON m.id = me.match_id
              WHERE me.player_id = tp.player_id
                AND me.event_type = 'YELLOW_CARD'
                AND m.season_id = tp.season_id
                AND m.league_id = tp.league_id
          ), 0),
          -- red_cards
          COALESCE((
              SELECT COUNT(*)
              FROM match_events me
              JOIN matches m ON m.id = me.match_id
              WHERE me.player_id = tp.player_id
                AND me.event_type = 'RED_CARD'
                AND m.season_id = tp.season_id
                AND m.league_id = tp.league_id
          ), 0)
      FROM team_players tp
      WHERE NOT EXISTS (
          SELECT 1 FROM player_season_stats pss
          WHERE pss.player_id = tp.player_id
            AND pss.season_id = tp.season_id
            AND pss.league_id = tp.league_id
      )
      ORDER BY tp.player_id, tp.season_id, tp.league_id, tp.joined_date ASC
      ON CONFLICT (player_id, season_id, league_id) DO NOTHING
    `);
    console.log(`  Wstawiono: ${insertResult.rowCount} nowych wpisów\n`);

    // KROK 2: Zaktualizuj istniejące wpisy z appearances=0
    console.log('KROK 2: Aktualizowanie istniejących wpisów (appearances=0)...');
    const updateResult = await client.query(`
      UPDATE player_season_stats pss
      SET
          appearances = COALESCE((
              SELECT COUNT(*)
              FROM matches m
              WHERE m.season_id = pss.season_id
                AND m.league_id = pss.league_id
                AND (m.home_team_id = pss.team_id OR m.away_team_id = pss.team_id)
                AND m.status IN ('completed', 'walkover_home', 'walkover_away')
          ), 0),
          goals = COALESCE((
              SELECT COUNT(*)
              FROM match_events me
              JOIN matches m ON m.id = me.match_id
              WHERE me.player_id = pss.player_id
                AND me.event_type = 'GOAL'
                AND me.is_own_goal = false
                AND m.season_id = pss.season_id
                AND m.league_id = pss.league_id
          ), 0),
          assists = COALESCE((
              SELECT COUNT(*)
              FROM match_events me
              JOIN matches m ON m.id = me.match_id
              WHERE me.assist_player_id = pss.player_id
                AND me.event_type = 'GOAL'
                AND m.season_id = pss.season_id
                AND m.league_id = pss.league_id
          ), 0),
          yellow_cards = COALESCE((
              SELECT COUNT(*)
              FROM match_events me
              JOIN matches m ON m.id = me.match_id
              WHERE me.player_id = pss.player_id
                AND me.event_type = 'YELLOW_CARD'
                AND m.season_id = pss.season_id
                AND m.league_id = pss.league_id
          ), 0),
          red_cards = COALESCE((
              SELECT COUNT(*)
              FROM match_events me
              JOIN matches m ON m.id = me.match_id
              WHERE me.player_id = pss.player_id
                AND me.event_type = 'RED_CARD'
                AND m.season_id = pss.season_id
                AND m.league_id = pss.league_id
          ), 0),
          updated_at = now()
      WHERE pss.appearances = 0
    `);
    console.log(`  Zaktualizowano: ${updateResult.rowCount} wpisów\n`);

    // KROK 3: Podsumowanie
    console.log('KROK 3: Podsumowanie per sezon:');
    const summary = await client.query(`
      SELECT
          s.year AS sezon,
          COUNT(*) AS zawodnikow,
          SUM(pss.goals) AS gole,
          SUM(pss.assists) AS asysty,
          SUM(pss.yellow_cards) AS zolte,
          SUM(pss.red_cards) AS czerwone,
          SUM(CASE WHEN pss.goals > 0 THEN 1 ELSE 0 END) AS strzelcy,
          ROUND(AVG(pss.appearances), 1) AS sr_mecze
      FROM player_season_stats pss
      JOIN seasons s ON s.id = pss.season_id
      GROUP BY s.year
      ORDER BY s.year
    `);

    console.log('Sezon | Zawod. | Gole | Asysty | Żółte | Czerw. | Strzelcy | Śr.Mecze');
    console.log('------|--------|------|--------|-------|--------|----------|--------');
    for (const row of summary.rows) {
      console.log(
        `${row.sezon}  | ${String(row.zawodnikow).padStart(6)} | ${String(row.gole).padStart(4)} | ${String(row.asysty).padStart(6)} | ${String(row.zolte).padStart(5)} | ${String(row.czerwone).padStart(6)} | ${String(row.strzelcy).padStart(8)} | ${row.sr_mecze}`
      );
    }

    // Stan PO
    const after = await client.query(`
      SELECT COUNT(*) AS cnt FROM player_season_stats
    `);
    console.log(`\nplayer_season_stats PO: ${after.rows[0].cnt} rekordów`);
    console.log(`Dodano: ${after.rows[0].cnt - before.rows[0].cnt} nowych rekordów`);

  } catch (err) {
    console.error('BŁĄD:', err.message);
    process.exit(1);
  } finally {
    await client.end();
    console.log('\nRozłączono z bazą.');
  }
}

main();
