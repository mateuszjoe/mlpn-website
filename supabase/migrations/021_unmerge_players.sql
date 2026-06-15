-- Kontrolowane odscalanie zawodnikow po omylkowym scaleniu.
CREATE OR REPLACE FUNCTION public.unmerge_player_contexts(
    p_source_player_id UUID,
    p_target_player_id UUID,
    p_contexts JSONB
)
RETURNS TABLE (
    team_rows INTEGER,
    stat_rows INTEGER,
    lineup_rows INTEGER,
    event_rows INTEGER,
    assist_rows INTEGER,
    suspension_rows INTEGER,
    mvp_rows INTEGER
) AS $$
DECLARE
    v_match_id UUID;
BEGIN
    IF p_source_player_id IS NULL OR p_target_player_id IS NULL THEN
        RAISE EXCEPTION 'Source and target player ids are required';
    END IF;

    IF p_source_player_id = p_target_player_id THEN
        RAISE EXCEPTION 'Source and target player must be different';
    END IF;

    IF NOT (
        public.has_permission('players.edit')
        AND public.has_permission('rosters.edit')
        AND public.has_permission('results.edit')
    ) THEN
        RAISE EXCEPTION 'Insufficient permissions to unmerge players';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM public.players WHERE id = p_source_player_id) THEN
        RAISE EXCEPTION 'Source player does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM public.players WHERE id = p_target_player_id) THEN
        RAISE EXCEPTION 'Target player does not exist';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.players_private pp
        WHERE pp.player_id = p_source_player_id
          AND pp.notes LIKE ('%[MERGED_TO:' || p_target_player_id::TEXT || ']%')
    ) THEN
        RAISE EXCEPTION 'Source player is not marked as merged into target player';
    END IF;

    IF p_contexts IS NULL OR jsonb_typeof(p_contexts) <> 'array' THEN
        RAISE EXCEPTION 'Contexts must be a JSON array';
    END IF;

    DROP TABLE IF EXISTS pg_temp.tmp_unmerge_contexts;
    CREATE TEMP TABLE tmp_unmerge_contexts (
        season_id UUID NOT NULL,
        league_id UUID NOT NULL,
        team_id UUID NOT NULL,
        PRIMARY KEY (season_id, league_id, team_id)
    ) ON COMMIT DROP;

    INSERT INTO tmp_unmerge_contexts (season_id, league_id, team_id)
    SELECT DISTINCT x.season_id, x.league_id, x.team_id
    FROM jsonb_to_recordset(p_contexts) AS x(
        season_id UUID,
        league_id UUID,
        team_id UUID
    )
    WHERE x.season_id IS NOT NULL
      AND x.league_id IS NOT NULL
      AND x.team_id IS NOT NULL;

    IF NOT EXISTS (SELECT 1 FROM tmp_unmerge_contexts) THEN
        RAISE EXCEPTION 'Select at least one season/team context to unmerge';
    END IF;

    DROP TABLE IF EXISTS pg_temp.tmp_unmerge_affected_matches;
    CREATE TEMP TABLE tmp_unmerge_affected_matches (
        match_id UUID PRIMARY KEY
    ) ON COMMIT DROP;

    INSERT INTO tmp_unmerge_affected_matches (match_id)
    SELECT DISTINCT ml.match_id
    FROM public.match_lineups ml
    JOIN public.matches m ON m.id = ml.match_id
    JOIN tmp_unmerge_contexts c
      ON c.season_id = m.season_id
     AND c.league_id = m.league_id
     AND c.team_id = ml.team_id
    WHERE ml.player_id = p_target_player_id
    ON CONFLICT DO NOTHING;

    INSERT INTO tmp_unmerge_affected_matches (match_id)
    SELECT DISTINCT me.match_id
    FROM public.match_events me
    JOIN public.matches m ON m.id = me.match_id
    JOIN tmp_unmerge_contexts c
      ON c.season_id = m.season_id
     AND c.league_id = m.league_id
     AND c.team_id = me.team_id
    WHERE me.player_id = p_target_player_id
       OR me.assist_player_id = p_target_player_id
    ON CONFLICT DO NOTHING;

    INSERT INTO tmp_unmerge_affected_matches (match_id)
    SELECT DISTINCT m.id
    FROM public.matches m
    JOIN tmp_unmerge_contexts c
      ON c.season_id = m.season_id
     AND c.league_id = m.league_id
     AND (c.team_id = m.home_team_id OR c.team_id = m.away_team_id)
    WHERE m.mvp_player_id = p_target_player_id
    ON CONFLICT DO NOTHING;

    team_rows := 0;
    stat_rows := 0;
    lineup_rows := 0;
    event_rows := 0;
    assist_rows := 0;
    suspension_rows := 0;
    mvp_rows := 0;

    UPDATE public.players
    SET is_active = true
    WHERE id = p_source_player_id;

    UPDATE public.players_private
    SET notes = NULLIF(
        BTRIM(
            regexp_replace(
                COALESCE(notes, ''),
                E'\\[MERGED_TO:' || p_target_player_id::TEXT || E'\\][^\\n\\r]*(\\r?\\n)?',
                '',
                'g'
            )
        ),
        ''
    )
    WHERE player_id = p_source_player_id;

    WITH moved AS (
        SELECT tp.*
        FROM public.team_players tp
        JOIN tmp_unmerge_contexts c
          ON c.season_id = tp.season_id
         AND c.league_id = tp.league_id
         AND c.team_id = tp.team_id
        WHERE tp.player_id = p_target_player_id
    ),
    upserted AS (
        INSERT INTO public.team_players (
            team_id,
            player_id,
            season_id,
            league_id,
            joined_date,
            left_date,
            is_captain,
            shirt_number
        )
        SELECT
            team_id,
            p_source_player_id,
            season_id,
            league_id,
            joined_date,
            left_date,
            is_captain,
            shirt_number
        FROM moved
        ON CONFLICT (player_id, season_id, league_id, team_id) DO UPDATE SET
            joined_date = EXCLUDED.joined_date,
            left_date = EXCLUDED.left_date,
            is_captain = EXCLUDED.is_captain,
            shirt_number = EXCLUDED.shirt_number
        RETURNING 1
    ),
    deleted AS (
        DELETE FROM public.team_players tp
        USING moved
        WHERE tp.id = moved.id
        RETURNING 1
    )
    SELECT COUNT(*) INTO team_rows FROM deleted;

    WITH moved AS (
        SELECT pss.*
        FROM public.player_season_stats pss
        JOIN tmp_unmerge_contexts c
          ON c.season_id = pss.season_id
         AND c.league_id = pss.league_id
         AND c.team_id = pss.team_id
        WHERE pss.player_id = p_target_player_id
    ),
    upserted AS (
        INSERT INTO public.player_season_stats (
            player_id,
            season_id,
            league_id,
            team_id,
            appearances,
            goals,
            assists,
            yellow_cards,
            red_cards
        )
        SELECT
            p_source_player_id,
            season_id,
            league_id,
            team_id,
            appearances,
            goals,
            assists,
            yellow_cards,
            red_cards
        FROM moved
        ON CONFLICT (player_id, season_id, league_id) DO UPDATE SET
            team_id = EXCLUDED.team_id,
            appearances = EXCLUDED.appearances,
            goals = EXCLUDED.goals,
            assists = EXCLUDED.assists,
            yellow_cards = EXCLUDED.yellow_cards,
            red_cards = EXCLUDED.red_cards,
            updated_at = now()
        RETURNING 1
    ),
    deleted AS (
        DELETE FROM public.player_season_stats pss
        USING moved
        WHERE pss.id = moved.id
        RETURNING 1
    )
    SELECT COUNT(*) INTO stat_rows FROM deleted;

    WITH moved AS (
        SELECT ml.*
        FROM public.match_lineups ml
        JOIN public.matches m ON m.id = ml.match_id
        JOIN tmp_unmerge_contexts c
          ON c.season_id = m.season_id
         AND c.league_id = m.league_id
         AND c.team_id = ml.team_id
        WHERE ml.player_id = p_target_player_id
    ),
    upserted AS (
        INSERT INTO public.match_lineups (
            match_id,
            team_id,
            player_id,
            is_starter,
            shirt_number,
            position_played
        )
        SELECT
            match_id,
            team_id,
            p_source_player_id,
            is_starter,
            shirt_number,
            position_played
        FROM moved
        ON CONFLICT (match_id, player_id) DO UPDATE SET
            team_id = EXCLUDED.team_id,
            is_starter = EXCLUDED.is_starter,
            shirt_number = EXCLUDED.shirt_number,
            position_played = EXCLUDED.position_played
        RETURNING 1
    ),
    deleted AS (
        DELETE FROM public.match_lineups ml
        USING moved
        WHERE ml.id = moved.id
        RETURNING 1
    )
    SELECT COUNT(*) INTO lineup_rows FROM deleted;

    UPDATE public.match_events me
    SET player_id = p_source_player_id
    FROM public.matches m, tmp_unmerge_contexts c
    WHERE me.match_id = m.id
      AND c.season_id = m.season_id
      AND c.league_id = m.league_id
      AND c.team_id = me.team_id
      AND me.player_id = p_target_player_id;
    GET DIAGNOSTICS event_rows = ROW_COUNT;

    UPDATE public.match_events me
    SET assist_player_id = p_source_player_id
    FROM public.matches m, tmp_unmerge_contexts c
    WHERE me.match_id = m.id
      AND c.season_id = m.season_id
      AND c.league_id = m.league_id
      AND c.team_id = me.team_id
      AND me.assist_player_id = p_target_player_id;
    GET DIAGNOSTICS assist_rows = ROW_COUNT;

    UPDATE public.suspensions s
    SET player_id = p_source_player_id
    WHERE s.player_id = p_target_player_id
      AND EXISTS (
        SELECT 1
        FROM tmp_unmerge_contexts c
        WHERE c.season_id = s.season_id
          AND c.league_id = s.league_id
      );
    GET DIAGNOSTICS suspension_rows = ROW_COUNT;

    UPDATE public.matches m
    SET mvp_player_id = p_source_player_id
    FROM tmp_unmerge_contexts c
    WHERE m.mvp_player_id = p_target_player_id
      AND c.season_id = m.season_id
      AND c.league_id = m.league_id
      AND (c.team_id = m.home_team_id OR c.team_id = m.away_team_id);
    GET DIAGNOSTICS mvp_rows = ROW_COUNT;

    FOR v_match_id IN SELECT match_id FROM tmp_unmerge_affected_matches LOOP
        PERFORM public.recalculate_single_player_stats(v_match_id, p_source_player_id);
        PERFORM public.recalculate_single_player_stats(v_match_id, p_target_player_id);
    END LOOP;

    RETURN NEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
