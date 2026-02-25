-- ============================================================
-- MLPN - Migracja 012: Widoki (Views)
-- Wygodne widoki do czestych zapytan z frontendu
-- ============================================================


-- ============================================================
-- TABELA LIGOWA z nazwami druzyn
-- Najczesciej uzywany widok na stronie
-- ============================================================
CREATE OR REPLACE VIEW v_standings AS
SELECT
    s.id,
    s.season_id,
    s.league_id,
    s.team_id,
    s.position,
    s.played,
    s.won,
    s.drawn,
    s.lost,
    s.goals_for,
    s.goals_against,
    s.goal_difference,
    s.points,
    s.form_last5,
    s.streak_wins,
    s.streak_unbeaten,
    s.streak_winless,
    t.name AS team_name,
    t.abbreviation AS team_abbr,
    t.logo_url AS team_logo_url,
    l.code AS league_code,
    l.name AS league_name,
    se.year AS season_year,
    se.name AS season_name
FROM standings s
JOIN teams t ON t.id = s.team_id
JOIN leagues l ON l.id = s.league_id
JOIN seasons se ON se.id = s.season_id;


-- ============================================================
-- MECZE z nazwami druzyn
-- ============================================================
CREATE OR REPLACE VIEW v_matches AS
SELECT
    m.id,
    m.season_id,
    m.league_id,
    m.round,
    m.home_team_id,
    m.away_team_id,
    m.match_date,
    m.match_time,
    m.venue,
    m.home_goals,
    m.away_goals,
    m.status,
    m.video_url,
    m.gallery_url,
    m.referee,
    m.mvp_player_id,
    m.notes,
    m.created_at,
    ht.name AS home_team_name,
    ht.abbreviation AS home_team_abbr,
    ht.logo_url AS home_team_logo,
    awt.name AS away_team_name,
    awt.abbreviation AS away_team_abbr,
    awt.logo_url AS away_team_logo,
    l.code AS league_code,
    l.name AS league_name,
    se.year AS season_year,
    mvp.display_name AS mvp_name,
    mvp_tp.team_id AS mvp_team_id
FROM matches m
JOIN teams ht ON ht.id = m.home_team_id
JOIN teams awt ON awt.id = m.away_team_id
JOIN leagues l ON l.id = m.league_id
JOIN seasons se ON se.id = m.season_id
LEFT JOIN players mvp ON mvp.id = m.mvp_player_id
LEFT JOIN team_players mvp_tp ON mvp_tp.player_id = m.mvp_player_id
    AND mvp_tp.season_id = m.season_id
    AND mvp_tp.league_id = m.league_id
    AND mvp_tp.left_date IS NULL;


-- ============================================================
-- STRZELCY - ranking per sezon per liga
-- ============================================================
CREATE OR REPLACE VIEW v_top_scorers AS
SELECT
    pss.id,
    pss.player_id,
    pss.season_id,
    pss.league_id,
    pss.team_id,
    pss.goals,
    pss.assists,
    pss.appearances,
    pss.goals_per_match,
    p.first_name,
    p.last_name,
    p.display_name,
    p.position,
    t.name AS team_name,
    t.abbreviation AS team_abbr,
    t.logo_url AS team_logo_url,
    l.code AS league_code,
    l.name AS league_name,
    se.year AS season_year,
    RANK() OVER (
        PARTITION BY pss.season_id, pss.league_id
        ORDER BY pss.goals DESC, pss.assists DESC, p.last_name ASC
    ) AS rank
FROM player_season_stats pss
JOIN players p ON p.id = pss.player_id
JOIN teams t ON t.id = pss.team_id
JOIN leagues l ON l.id = pss.league_id
JOIN seasons se ON se.id = pss.season_id
WHERE pss.goals > 0;


-- ============================================================
-- ASYSTENCI - ranking per sezon per liga
-- ============================================================
CREATE OR REPLACE VIEW v_top_assists AS
SELECT
    pss.id,
    pss.player_id,
    pss.season_id,
    pss.league_id,
    pss.team_id,
    pss.assists,
    pss.goals,
    pss.appearances,
    p.first_name,
    p.last_name,
    p.display_name,
    p.position,
    t.name AS team_name,
    t.abbreviation AS team_abbr,
    t.logo_url AS team_logo_url,
    l.code AS league_code,
    l.name AS league_name,
    se.year AS season_year,
    RANK() OVER (
        PARTITION BY pss.season_id, pss.league_id
        ORDER BY pss.assists DESC, pss.goals DESC, p.last_name ASC
    ) AS rank
FROM player_season_stats pss
JOIN players p ON p.id = pss.player_id
JOIN teams t ON t.id = pss.team_id
JOIN leagues l ON l.id = pss.league_id
JOIN seasons se ON se.id = pss.season_id
WHERE pss.assists > 0;


-- ============================================================
-- KARTKI - ranking zoltych per sezon per liga
-- ============================================================
CREATE OR REPLACE VIEW v_top_yellow_cards AS
SELECT
    pss.id,
    pss.player_id,
    pss.season_id,
    pss.league_id,
    pss.team_id,
    pss.yellow_cards,
    pss.red_cards,
    pss.appearances,
    p.first_name,
    p.last_name,
    p.display_name,
    p.position,
    t.name AS team_name,
    t.abbreviation AS team_abbr,
    t.logo_url AS team_logo_url,
    l.code AS league_code,
    se.year AS season_year,
    RANK() OVER (
        PARTITION BY pss.season_id, pss.league_id
        ORDER BY pss.yellow_cards DESC, pss.red_cards DESC
    ) AS rank
FROM player_season_stats pss
JOIN players p ON p.id = pss.player_id
JOIN teams t ON t.id = pss.team_id
JOIN leagues l ON l.id = pss.league_id
JOIN seasons se ON se.id = pss.season_id
WHERE pss.yellow_cards > 0;


-- ============================================================
-- KARIERA ZAWODNIKA (wszystkie sezony zagregowane)
-- ============================================================
CREATE OR REPLACE VIEW v_player_career AS
SELECT
    p.id AS player_id,
    p.first_name,
    p.last_name,
    p.display_name,
    p.position,
    p.birth_year,
    p.city,
    p.photo_url,
    SUM(COALESCE(pss.appearances, 0)) AS total_appearances,
    SUM(COALESCE(pss.goals, 0)) AS total_goals,
    SUM(COALESCE(pss.assists, 0)) AS total_assists,
    SUM(COALESCE(pss.yellow_cards, 0)) AS total_yellow_cards,
    SUM(COALESCE(pss.red_cards, 0)) AS total_red_cards,
    COUNT(DISTINCT pss.season_id) AS seasons_played
FROM players p
LEFT JOIN player_season_stats pss ON pss.player_id = p.id
WHERE p.is_active = true
GROUP BY p.id, p.first_name, p.last_name, p.display_name,
         p.position, p.birth_year, p.city, p.photo_url;


-- ============================================================
-- KADRA DRUZYNY (aktualna per sezon per liga)
-- ============================================================
CREATE OR REPLACE VIEW v_team_roster AS
SELECT
    tp.id AS roster_id,
    tp.team_id,
    tp.player_id,
    tp.season_id,
    tp.league_id,
    tp.joined_date,
    tp.left_date,
    tp.is_captain,
    tp.shirt_number,
    p.first_name,
    p.last_name,
    p.display_name,
    p.position,
    p.birth_year,
    p.photo_url,
    t.name AS team_name,
    t.logo_url AS team_logo_url,
    se.year AS season_year,
    COALESCE(pss.goals, 0) AS goals,
    COALESCE(pss.assists, 0) AS assists,
    COALESCE(pss.yellow_cards, 0) AS yellow_cards,
    COALESCE(pss.red_cards, 0) AS red_cards,
    COALESCE(pss.appearances, 0) AS appearances
FROM team_players tp
JOIN players p ON p.id = tp.player_id
JOIN teams t ON t.id = tp.team_id
JOIN seasons se ON se.id = tp.season_id
LEFT JOIN player_season_stats pss
    ON pss.player_id = tp.player_id
    AND pss.season_id = tp.season_id
    AND pss.league_id = tp.league_id;


-- ============================================================
-- AKTYWNE PAUZY (zawieszenia)
-- ============================================================
CREATE OR REPLACE VIEW v_active_suspensions AS
SELECT
    s.id,
    s.player_id,
    s.season_id,
    s.league_id,
    s.suspension_type,
    s.reason,
    s.start_round,
    s.end_round,
    s.matches_remaining,
    s.is_served,
    p.display_name AS player_name,
    p.position AS player_position,
    t.name AS team_name,
    t.logo_url AS team_logo_url,
    l.code AS league_code,
    se.year AS season_year,
    sl.current_round
FROM suspensions s
JOIN players p ON p.id = s.player_id
JOIN seasons se ON se.id = s.season_id
JOIN leagues l ON l.id = s.league_id
JOIN season_leagues sl ON sl.season_id = s.season_id AND sl.league_id = s.league_id
LEFT JOIN team_players tp
    ON tp.player_id = s.player_id
    AND tp.season_id = s.season_id
    AND tp.league_id = s.league_id
    AND tp.left_date IS NULL
LEFT JOIN teams t ON t.id = tp.team_id
WHERE s.is_served = false;
