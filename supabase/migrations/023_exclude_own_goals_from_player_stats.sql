-- ============================================================
-- MLPN - Migracja 023: Samoboje bez bramek w statystykach gracza
-- ============================================================

CREATE OR REPLACE FUNCTION public.recalculate_single_player_stats(
    p_match_id UUID,
    p_player_id UUID
)
RETURNS void AS $$
DECLARE
    v_match RECORD;
    v_team_id UUID;
    v_appearances INTEGER;
    v_goals INTEGER;
    v_assists INTEGER;
    v_yellow_cards INTEGER;
    v_red_cards INTEGER;
BEGIN
    IF p_match_id IS NULL OR p_player_id IS NULL THEN
        RETURN;
    END IF;

    SELECT * INTO v_match FROM public.matches WHERE id = p_match_id;
    IF v_match IS NULL THEN
        RETURN;
    END IF;

    SELECT COUNT(DISTINCT ml.match_id) INTO v_appearances
    FROM public.match_lineups ml
    JOIN public.matches m ON m.id = ml.match_id
    WHERE ml.player_id = p_player_id
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    SELECT COUNT(*) INTO v_goals
    FROM public.match_events me
    JOIN public.matches m ON m.id = me.match_id
    WHERE me.player_id = p_player_id
      AND me.event_type = 'GOAL'
      AND COALESCE(me.is_own_goal, false) = false
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    SELECT COUNT(*) INTO v_assists
    FROM public.match_events me
    JOIN public.matches m ON m.id = me.match_id
    WHERE me.assist_player_id = p_player_id
      AND me.event_type = 'GOAL'
      AND COALESCE(me.is_own_goal, false) = false
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    SELECT COUNT(*) INTO v_yellow_cards
    FROM public.match_events me
    JOIN public.matches m ON m.id = me.match_id
    WHERE me.player_id = p_player_id
      AND me.event_type = 'YELLOW_CARD'
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    SELECT COUNT(*) INTO v_red_cards
    FROM public.match_events me
    JOIN public.matches m ON m.id = me.match_id
    WHERE me.player_id = p_player_id
      AND me.event_type = 'RED_CARD'
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    IF COALESCE(v_appearances, 0) = 0
       AND COALESCE(v_goals, 0) = 0
       AND COALESCE(v_assists, 0) = 0
       AND COALESCE(v_yellow_cards, 0) = 0
       AND COALESCE(v_red_cards, 0) = 0 THEN
        DELETE FROM public.player_season_stats
        WHERE player_id = p_player_id
          AND season_id = v_match.season_id
          AND league_id = v_match.league_id;
        RETURN;
    END IF;

    SELECT COALESCE(
        (SELECT team_id FROM public.team_players
         WHERE player_id = p_player_id
           AND season_id = v_match.season_id
           AND league_id = v_match.league_id
           AND left_date IS NULL
         LIMIT 1),
        (SELECT ml.team_id
         FROM public.match_lineups ml
         JOIN public.matches m ON m.id = ml.match_id
         WHERE ml.player_id = p_player_id
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id
         ORDER BY ml.created_at DESC
         LIMIT 1),
        (SELECT me.team_id
         FROM public.match_events me
         JOIN public.matches m ON m.id = me.match_id
         WHERE me.player_id = p_player_id
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id
         ORDER BY me.created_at DESC
         LIMIT 1)
    ) INTO v_team_id;

    IF v_team_id IS NULL THEN
        RETURN;
    END IF;

    INSERT INTO public.player_season_stats (
        player_id, season_id, league_id, team_id,
        appearances, goals, assists, yellow_cards, red_cards
    ) VALUES (
        p_player_id, v_match.season_id, v_match.league_id, v_team_id,
        COALESCE(v_appearances, 0),
        COALESCE(v_goals, 0),
        COALESCE(v_assists, 0),
        COALESCE(v_yellow_cards, 0),
        COALESCE(v_red_cards, 0)
    )
    ON CONFLICT (player_id, season_id, league_id) DO UPDATE SET
        team_id = EXCLUDED.team_id,
        appearances = EXCLUDED.appearances,
        goals = EXCLUDED.goals,
        assists = EXCLUDED.assists,
        yellow_cards = EXCLUDED.yellow_cards,
        red_cards = EXCLUDED.red_cards,
        updated_at = now();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT DISTINCT match_id, player_id
        FROM public.match_events
        WHERE event_type = 'GOAL'
          AND COALESCE(is_own_goal, false) = true
          AND player_id IS NOT NULL
        UNION
        SELECT DISTINCT match_id, assist_player_id AS player_id
        FROM public.match_events
        WHERE event_type = 'GOAL'
          AND COALESCE(is_own_goal, false) = true
          AND assist_player_id IS NOT NULL
    LOOP
        PERFORM public.recalculate_single_player_stats(r.match_id, r.player_id);
    END LOOP;
END $$;
