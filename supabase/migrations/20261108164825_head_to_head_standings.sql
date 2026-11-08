-- Equal league points are resolved by the mini-table of every team in the
-- tied group: head-to-head points, goal difference and goals scored, followed
-- by the overall goal difference and goals scored. Use the whole tied group
-- once (no recursive reapplication to subgroups), using results available now.
-- Stored totals are deliberately the source of truth, including imported or
-- administratively adjusted totals. This helper never writes any data.
CREATE OR REPLACE FUNCTION public.rank_existing_standings(
  p_season_id uuid,
  p_league_id uuid
)
RETURNS TABLE(team_id uuid, "position" integer)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
  WITH rules AS (
    SELECT
      COALESCE((SELECT sl.points_win FROM public.season_leagues sl
        WHERE sl.season_id = p_season_id AND sl.league_id = p_league_id), 3) AS win,
      COALESCE((SELECT sl.points_draw FROM public.season_leagues sl
        WHERE sl.season_id = p_season_id AND sl.league_id = p_league_id), 1) AS draw,
      COALESCE((SELECT sl.points_loss FROM public.season_leagues sl
        WHERE sl.season_id = p_season_id AND sl.league_id = p_league_id), 0) AS loss,
      COALESCE((SELECT sl.walkover_goals_winner FROM public.season_leagues sl
        WHERE sl.season_id = p_season_id AND sl.league_id = p_league_id), 3) AS wo_winner,
      COALESCE((SELECT sl.walkover_goals_loser FROM public.season_leagues sl
        WHERE sl.season_id = p_season_id AND sl.league_id = p_league_id), 0) AS wo_loser
  ), entries AS (
    SELECT s.team_id, s.points, s.goals_for, s.goals_against, t.name,
      (st.left_round IS NOT NULL) AS withdrawn
    FROM public.standings s
    JOIN public.teams t ON t.id = s.team_id
    LEFT JOIN public.season_teams st
      ON st.season_id = s.season_id AND st.league_id = s.league_id AND st.team_id = s.team_id
    WHERE s.season_id = p_season_id AND s.league_id = p_league_id
  ), direct_matches AS (
    SELECT m.home_team_id, m.away_team_id,
      CASE m.status WHEN 'walkover_home' THEN r.wo_winner
        WHEN 'walkover_away' THEN r.wo_loser ELSE m.home_goals END AS home_goals,
      CASE m.status WHEN 'walkover_away' THEN r.wo_winner
        WHEN 'walkover_home' THEN r.wo_loser ELSE m.away_goals END AS away_goals
    FROM public.matches m
    JOIN entries h ON h.team_id = m.home_team_id
    JOIN entries a ON a.team_id = m.away_team_id
      AND a.points = h.points AND a.withdrawn = h.withdrawn
    CROSS JOIN rules r
    WHERE m.season_id = p_season_id AND m.league_id = p_league_id
      AND (m.status IN ('walkover_home', 'walkover_away')
        OR (m.status = 'completed' AND m.home_goals IS NOT NULL AND m.away_goals IS NOT NULL))
  ), perspectives AS (
    SELECT d.home_team_id AS team_id, d.home_goals AS gf, d.away_goals AS ga FROM direct_matches d
    UNION ALL
    SELECT d.away_team_id AS team_id, d.away_goals AS gf, d.home_goals AS ga FROM direct_matches d
  ), mini_table AS (
    SELECT p.team_id,
      SUM(CASE WHEN p.gf > p.ga THEN r.win WHEN p.gf = p.ga THEN r.draw ELSE r.loss END) AS points,
      SUM(p.gf - p.ga) AS goal_difference, SUM(p.gf) AS goals_for
    FROM perspectives p CROSS JOIN rules r
    GROUP BY p.team_id
  )
  SELECT e.team_id,
    (ROW_NUMBER() OVER (ORDER BY e.withdrawn ASC, e.points DESC,
      COALESCE(mt.points, 0) DESC, COALESCE(mt.goal_difference, 0) DESC,
      COALESCE(mt.goals_for, 0) DESC, (e.goals_for - e.goals_against) DESC,
      e.goals_for DESC, e.name ASC, e.team_id ASC))::integer AS position
  FROM entries e LEFT JOIN mini_table mt ON mt.team_id = e.team_id
  ORDER BY position;
$$;

COMMENT ON FUNCTION public.rank_existing_standings(uuid, uuid) IS
  'Read-only ranking of stored league totals using the whole equal-points group mini-table; withdrawn teams rank separately and last.';

-- Internal helper, not a new public RPC. The existing trigger runs as its owner.
REVOKE ALL ON FUNCTION public.rank_existing_standings(uuid, uuid) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.rank_existing_standings(uuid, uuid) TO service_role;


-- Keep the existing totals/form calculation and trigger identity/permissions.
CREATE OR REPLACE FUNCTION public.recalculate_standings()
RETURNS TRIGGER AS $$
DECLARE
    v_season_id UUID;
    v_league_id UUID;
    v_points_win INTEGER;
    v_points_draw INTEGER;
    v_points_loss INTEGER;
    v_wo_goals_winner INTEGER;
    v_wo_goals_loser INTEGER;
BEGIN
    -- Okresl ktory sezon/liga
    IF TG_OP = 'DELETE' THEN
        v_season_id := OLD.season_id;
        v_league_id := OLD.league_id;
    ELSE
        v_season_id := NEW.season_id;
        v_league_id := NEW.league_id;
    END IF;

    -- Pobierz konfiguracje punktacji
    SELECT
        COALESCE(points_win, 3),
        COALESCE(points_draw, 1),
        COALESCE(points_loss, 0),
        COALESCE(walkover_goals_winner, 3),
        COALESCE(walkover_goals_loser, 0)
    INTO v_points_win, v_points_draw, v_points_loss, v_wo_goals_winner, v_wo_goals_loser
    FROM public.season_leagues
    WHERE season_id = v_season_id AND league_id = v_league_id;

    -- Domyslne wartosci jesli brak konfiguracji
    v_points_win := COALESCE(v_points_win, 3);
    v_points_draw := COALESCE(v_points_draw, 1);
    v_points_loss := COALESCE(v_points_loss, 0);
    v_wo_goals_winner := COALESCE(v_wo_goals_winner, 3);
    v_wo_goals_loser := COALESCE(v_wo_goals_loser, 0);

    -- Usun stare standings dla tej ligi w tym sezonie
    DELETE FROM public.standings
    WHERE season_id = v_season_id AND league_id = v_league_id;

    -- Przelicz i wstaw nowe standings
    INSERT INTO public.standings (
        season_id, league_id, team_id,
        played, won, drawn, lost,
        goals_for, goals_against, points, position,
        form_last5, streak_wins, streak_unbeaten, streak_winless
    )
    WITH match_results AS (
        -- Perspektywa gospodarza
        SELECT
            home_team_id AS team_id,
            round,
            CASE
                WHEN status IN ('walkover_home') THEN v_wo_goals_winner
                WHEN status IN ('walkover_away') THEN v_wo_goals_loser
                ELSE COALESCE(home_goals, 0)
            END AS gf,
            CASE
                WHEN status IN ('walkover_home') THEN v_wo_goals_loser
                WHEN status IN ('walkover_away') THEN v_wo_goals_winner
                ELSE COALESCE(away_goals, 0)
            END AS ga,
            CASE
                WHEN status = 'walkover_home' THEN 'W'
                WHEN status = 'walkover_away' THEN 'L'
                WHEN home_goals > away_goals THEN 'W'
                WHEN home_goals = away_goals THEN 'D'
                ELSE 'L'
            END AS result,
            away_team_id AS opponent_id,
            home_goals || ':' || away_goals AS score_str
        FROM public.matches
        WHERE season_id = v_season_id
          AND league_id = v_league_id
          AND status IN ('completed', 'walkover_home', 'walkover_away')

        UNION ALL

        -- Perspektywa goscia
        SELECT
            away_team_id AS team_id,
            round,
            CASE
                WHEN status IN ('walkover_away') THEN v_wo_goals_winner
                WHEN status IN ('walkover_home') THEN v_wo_goals_loser
                ELSE COALESCE(away_goals, 0)
            END AS gf,
            CASE
                WHEN status IN ('walkover_away') THEN v_wo_goals_loser
                WHEN status IN ('walkover_home') THEN v_wo_goals_winner
                ELSE COALESCE(home_goals, 0)
            END AS ga,
            CASE
                WHEN status = 'walkover_away' THEN 'W'
                WHEN status = 'walkover_home' THEN 'L'
                WHEN away_goals > home_goals THEN 'W'
                WHEN home_goals = away_goals THEN 'D'
                ELSE 'L'
            END AS result,
            home_team_id AS opponent_id,
            home_goals || ':' || away_goals AS score_str
        FROM public.matches
        WHERE season_id = v_season_id
          AND league_id = v_league_id
          AND status IN ('completed', 'walkover_home', 'walkover_away')
    ),
    -- Agregacja punktow i bramek
    aggregated AS (
        SELECT
            team_id,
            COUNT(*) AS played,
            SUM(CASE WHEN result = 'W' THEN 1 ELSE 0 END) AS won,
            SUM(CASE WHEN result = 'D' THEN 1 ELSE 0 END) AS drawn,
            SUM(CASE WHEN result = 'L' THEN 1 ELSE 0 END) AS lost,
            SUM(gf) AS goals_for,
            SUM(ga) AS goals_against,
            SUM(CASE
                WHEN result = 'W' THEN v_points_win
                WHEN result = 'D' THEN v_points_draw
                ELSE v_points_loss
            END) AS points
        FROM match_results
        GROUP BY team_id
    ),
    -- Forma last 5 (JSON)
    form_data AS (
        SELECT
            team_id,
            jsonb_agg(
                jsonb_build_object(
                    'result', result,
                    'opponent', t_opp.name,
                    'score', score_str
                ) ORDER BY round DESC
            ) FILTER (WHERE rn <= 5) AS form_last5,
            -- Seria wygranych (od konca)
            (SELECT COUNT(*) FROM (
                SELECT result, ROW_NUMBER() OVER (ORDER BY round DESC) AS rn2
                FROM match_results mr2
                WHERE mr2.team_id = mr_ranked.team_id
            ) s WHERE rn2 <= (
                SELECT COALESCE(MIN(rn2) - 1, COUNT(*)) FROM (
                    SELECT result, ROW_NUMBER() OVER (ORDER BY round DESC) AS rn2
                    FROM match_results mr3
                    WHERE mr3.team_id = mr_ranked.team_id
                ) s2 WHERE result != 'W'
            )) AS streak_wins
        FROM (
            SELECT mr.*, ROW_NUMBER() OVER (PARTITION BY mr.team_id ORDER BY mr.round DESC) AS rn
            FROM match_results mr
        ) mr_ranked
        LEFT JOIN public.teams t_opp ON t_opp.id = mr_ranked.opponent_id
        GROUP BY mr_ranked.team_id
    ),
    -- Wszystkie druzyny w lidze (w tym te bez meczow)
    all_teams AS (
        SELECT st.team_id
        FROM public.season_teams st
        WHERE st.season_id = v_season_id AND st.league_id = v_league_id
    ),
    -- Ranking
    ranked AS (
        SELECT
            at.team_id,
            COALESCE(a.played, 0) AS played,
            COALESCE(a.won, 0) AS won,
            COALESCE(a.drawn, 0) AS drawn,
            COALESCE(a.lost, 0) AS lost,
            COALESCE(a.goals_for, 0) AS goals_for,
            COALESCE(a.goals_against, 0) AS goals_against,
            COALESCE(a.points, 0) AS points,
            COALESCE(fd.form_last5, '[]'::jsonb) AS form_last5,
            COALESCE(fd.streak_wins, 0) AS streak_wins,
            ROW_NUMBER() OVER (
                ORDER BY
                    COALESCE(a.points, 0) DESC,
                    (COALESCE(a.goals_for, 0) - COALESCE(a.goals_against, 0)) DESC,
                    COALESCE(a.goals_for, 0) DESC,
                    t.name ASC
            ) AS position
        FROM all_teams at
        LEFT JOIN aggregated a ON a.team_id = at.team_id
        LEFT JOIN form_data fd ON fd.team_id = at.team_id
        JOIN public.teams t ON t.id = at.team_id
    )
    SELECT
        v_season_id, v_league_id, team_id,
        played, won, drawn, lost,
        goals_for, goals_against, points,
        position::INTEGER,
        form_last5,
        streak_wins,
        -- streak_unbeaten: ile W/D od konca
        0, -- obliczany uproszczenie, dokladnie ponizej
        -- streak_winless: ile D/L od konca
        0
    FROM ranked;

    -- Reorder only after totals/form have been calculated by the existing logic.
    UPDATE public.standings AS s
    SET position = ranked.position
    FROM public.rank_existing_standings(v_season_id, v_league_id) AS ranked
    WHERE s.season_id = v_season_id AND s.league_id = v_league_id
      AND s.team_id = ranked.team_id AND s.position IS DISTINCT FROM ranked.position;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- Repair only the current 2026 tables. Do not rebuild archived/imported totals,
-- rerun match triggers, or change results, form, points or player statistics.
WITH affected_leagues AS (
  SELECT DISTINCT s.season_id, s.league_id
  FROM public.standings s
  JOIN public.seasons se ON se.id = s.season_id
  WHERE se.year = 2026
), ranked AS (
  SELECT l.season_id, l.league_id, r.team_id, r.position
  FROM affected_leagues l
  CROSS JOIN LATERAL public.rank_existing_standings(l.season_id, l.league_id) r
)
UPDATE public.standings AS s
SET position = ranked.position
FROM ranked
WHERE s.season_id = ranked.season_id AND s.league_id = ranked.league_id
  AND s.team_id = ranked.team_id AND s.position IS DISTINCT FROM ranked.position;
