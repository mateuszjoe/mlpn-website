-- ============================================================
-- MLPN: AUDYT DUPLIKATOW (ZAWODNICY + DRUZYNY)
-- ============================================================
-- BEZPIECZNE: tylko SELECT-y (nic nie zmienia w bazie)
--
-- Jak uzywac:
-- 1) Supabase -> SQL Editor -> New query
-- 2) Wklej caly skrypt
-- 3) Run
-- 4) Zobacz kolejne tabele wynikow
--
-- Co oznacza:
-- - "candidate duplicates" = kandydaci do duplikatow (nie zawsze na 100%)
-- - szczegolnie zawodnicy o tym samym imieniu i nazwisku moga byc rozni
--
-- Uwaga:
-- - teams.name jest UNIQUE, wiec nie bedzie "dokladnych duplikatow" nazw
-- - dla druzyn wykrywamy podobne nazwy po normalizacji (np. spacje/znaki/diakrytyka)


-- ============================================================
-- 1) ZAWODNICY - KANDYDACI (po znormalizowanym display_name)
-- ============================================================
WITH players_base AS (
  SELECT
    p.id,
    p.first_name,
    p.last_name,
    p.display_name,
    p.birth_year,
    p.position,
    p.is_active,
    p.created_at,
    lower(
      regexp_replace(
        translate(
          p.display_name,
          'ąćęłńóśźżĄĆĘŁŃÓŚŹŻ',
          'acelnoszzACELNOSZZ'
        ),
        '[^a-zA-Z0-9]+',
        '',
        'g'
      )
    ) AS norm_key
  FROM players p
),
players_usage AS (
  SELECT
    pb.*,
    (SELECT COUNT(*) FROM team_players tp WHERE tp.player_id = pb.id) AS team_players_rows,
    (SELECT COUNT(*) FROM match_events me WHERE me.player_id = pb.id) AS match_events_rows,
    (SELECT COUNT(*) FROM match_events me WHERE me.assist_player_id = pb.id) AS assists_rows,
    (SELECT COUNT(*) FROM match_lineups ml WHERE ml.player_id = pb.id) AS lineups_rows,
    (SELECT COUNT(*) FROM player_season_stats pss WHERE pss.player_id = pb.id) AS pss_rows,
    (SELECT COUNT(*) FROM suspensions s WHERE s.player_id = pb.id) AS suspensions_rows,
    (SELECT COUNT(*) FROM matches m WHERE m.mvp_player_id = pb.id) AS mvp_rows
  FROM players_base pb
),
players_ranked AS (
  SELECT
    pu.*,
    (pu.team_players_rows + pu.match_events_rows + pu.assists_rows + pu.lineups_rows + pu.pss_rows + pu.suspensions_rows + pu.mvp_rows) AS usage_score,
    COUNT(*) OVER (PARTITION BY pu.norm_key) AS group_size
  FROM players_usage pu
  WHERE pu.norm_key <> ''
)
SELECT
  norm_key,
  group_size,
  id,
  display_name,
  birth_year,
  position,
  is_active,
  usage_score,
  team_players_rows,
  match_events_rows,
  assists_rows,
  lineups_rows,
  pss_rows,
  suspensions_rows,
  mvp_rows,
  created_at
FROM players_ranked
WHERE group_size > 1
ORDER BY norm_key, usage_score DESC, created_at ASC;


-- ============================================================
-- 2) DRUZYNY - KANDYDACI (po znormalizowanej nazwie)
-- ============================================================
WITH teams_base AS (
  SELECT
    t.id,
    t.name,
    t.short_name,
    t.abbreviation,
    t.is_active,
    t.created_at,
    lower(
      regexp_replace(
        translate(
          t.name,
          'ąćęłńóśźżĄĆĘŁŃÓŚŹŻ',
          'acelnoszzACELNOSZZ'
        ),
        '[^a-zA-Z0-9]+',
        '',
        'g'
      )
    ) AS norm_key
  FROM teams t
),
teams_usage AS (
  SELECT
    tb.*,
    (SELECT COUNT(*) FROM season_teams st WHERE st.team_id = tb.id) AS season_teams_rows,
    (SELECT COUNT(*) FROM team_players tp WHERE tp.team_id = tb.id) AS team_players_rows,
    (SELECT COUNT(*) FROM match_events me WHERE me.team_id = tb.id) AS match_events_rows,
    (SELECT COUNT(*) FROM match_lineups ml WHERE ml.team_id = tb.id) AS lineups_rows,
    (SELECT COUNT(*) FROM standings s WHERE s.team_id = tb.id) AS standings_rows,
    (SELECT COUNT(*) FROM player_season_stats pss WHERE pss.team_id = tb.id) AS pss_rows,
    (SELECT COUNT(*) FROM matches m WHERE m.home_team_id = tb.id OR m.away_team_id = tb.id) AS matches_rows
  FROM teams_base tb
),
teams_ranked AS (
  SELECT
    tu.*,
    (tu.season_teams_rows + tu.team_players_rows + tu.match_events_rows + tu.lineups_rows + tu.standings_rows + tu.pss_rows + tu.matches_rows) AS usage_score,
    COUNT(*) OVER (PARTITION BY tu.norm_key) AS group_size
  FROM teams_usage tu
  WHERE tu.norm_key <> ''
)
SELECT
  norm_key,
  group_size,
  id,
  name,
  short_name,
  abbreviation,
  is_active,
  usage_score,
  season_teams_rows,
  team_players_rows,
  match_events_rows,
  lineups_rows,
  standings_rows,
  pss_rows,
  matches_rows,
  created_at
FROM teams_ranked
WHERE group_size > 1
ORDER BY norm_key, usage_score DESC, created_at ASC;


-- ============================================================
-- 3) PODSUMOWANIE ILE MAMY KANDYDATOW
-- ============================================================
WITH players_norm AS (
  SELECT lower(regexp_replace(translate(display_name, 'ąćęłńóśźżĄĆĘŁŃÓŚŹŻ', 'acelnoszzACELNOSZZ'), '[^a-zA-Z0-9]+', '', 'g')) AS norm_key
  FROM players
),
teams_norm AS (
  SELECT lower(regexp_replace(translate(name, 'ąćęłńóśźżĄĆĘŁŃÓŚŹŻ', 'acelnoszzACELNOSZZ'), '[^a-zA-Z0-9]+', '', 'g')) AS norm_key
  FROM teams
),
player_groups AS (
  SELECT norm_key
  FROM players_norm
  WHERE norm_key <> ''
  GROUP BY norm_key
  HAVING COUNT(*) > 1
),
team_groups AS (
  SELECT norm_key
  FROM teams_norm
  WHERE norm_key <> ''
  GROUP BY norm_key
  HAVING COUNT(*) > 1
)
SELECT
  (SELECT COUNT(*) FROM player_groups) AS grupy_duplikatow_zawodnikow,
  (SELECT COUNT(*) FROM team_groups) AS grupy_duplikatow_druzyn;

