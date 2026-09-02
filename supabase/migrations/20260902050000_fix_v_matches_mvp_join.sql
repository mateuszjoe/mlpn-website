-- Keep v_matches at one row per match even when an MVP has more than one
-- active team_players registration in the same season and league.
CREATE OR REPLACE VIEW public.v_matches AS
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
    COALESCE(r.full_name, m.referee) AS referee,
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
    mvp_tp.team_id AS mvp_team_id,
    m.referee_id AS referee_id
FROM public.matches m
JOIN public.teams ht ON ht.id = m.home_team_id
JOIN public.teams awt ON awt.id = m.away_team_id
JOIN public.leagues l ON l.id = m.league_id
JOIN public.seasons se ON se.id = m.season_id
LEFT JOIN public.players mvp ON mvp.id = m.mvp_player_id
LEFT JOIN LATERAL (
    SELECT tp.team_id
    FROM public.team_players tp
    WHERE tp.player_id = m.mvp_player_id
      AND tp.season_id = m.season_id
      AND tp.league_id = m.league_id
    ORDER BY
        (tp.team_id IN (m.home_team_id, m.away_team_id)) DESC,
        (
            m.match_date IS NOT NULL
            AND tp.joined_date <= m.match_date
            AND (tp.left_date IS NULL OR tp.left_date >= m.match_date)
        ) DESC,
        (tp.left_date IS NULL) DESC,
        tp.joined_date DESC,
        tp.created_at DESC,
        tp.id DESC
    LIMIT 1
) mvp_tp ON true
LEFT JOIN public.referees r ON r.id = m.referee_id;
