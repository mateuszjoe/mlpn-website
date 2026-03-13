-- ============================================================
-- MLPN - Migracja 014: Odswiezanie statystyk po zmianie skladu
-- ============================================================

DROP TRIGGER IF EXISTS trg_recalculate_player_stats ON match_events;

CREATE OR REPLACE FUNCTION recalculate_single_player_stats(
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

    SELECT * INTO v_match FROM matches WHERE id = p_match_id;
    IF v_match IS NULL THEN
        RETURN;
    END IF;

    SELECT COUNT(DISTINCT ml.match_id) INTO v_appearances
    FROM match_lineups ml
    JOIN matches m ON m.id = ml.match_id
    WHERE ml.player_id = p_player_id
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    SELECT COUNT(*) INTO v_goals
    FROM match_events me
    JOIN matches m ON m.id = me.match_id
    WHERE me.player_id = p_player_id
      AND me.event_type = 'GOAL'
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    SELECT COUNT(*) INTO v_assists
    FROM match_events me
    JOIN matches m ON m.id = me.match_id
    WHERE me.assist_player_id = p_player_id
      AND me.event_type = 'GOAL'
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    SELECT COUNT(*) INTO v_yellow_cards
    FROM match_events me
    JOIN matches m ON m.id = me.match_id
    WHERE me.player_id = p_player_id
      AND me.event_type = 'YELLOW_CARD'
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    SELECT COUNT(*) INTO v_red_cards
    FROM match_events me
    JOIN matches m ON m.id = me.match_id
    WHERE me.player_id = p_player_id
      AND me.event_type = 'RED_CARD'
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    IF COALESCE(v_appearances, 0) = 0
       AND COALESCE(v_goals, 0) = 0
       AND COALESCE(v_assists, 0) = 0
       AND COALESCE(v_yellow_cards, 0) = 0
       AND COALESCE(v_red_cards, 0) = 0 THEN
        DELETE FROM player_season_stats
        WHERE player_id = p_player_id
          AND season_id = v_match.season_id
          AND league_id = v_match.league_id;
        RETURN;
    END IF;

    SELECT COALESCE(
        (SELECT team_id FROM team_players
         WHERE player_id = p_player_id
           AND season_id = v_match.season_id
           AND league_id = v_match.league_id
           AND left_date IS NULL
         LIMIT 1),
        (SELECT ml.team_id
         FROM match_lineups ml
         JOIN matches m ON m.id = ml.match_id
         WHERE ml.player_id = p_player_id
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id
         ORDER BY ml.created_at DESC
         LIMIT 1),
        (SELECT me.team_id
         FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.player_id = p_player_id
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id
         ORDER BY me.created_at DESC
         LIMIT 1)
    ) INTO v_team_id;

    IF v_team_id IS NULL THEN
        RETURN;
    END IF;

    INSERT INTO player_season_stats (
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

CREATE OR REPLACE FUNCTION trg_recalculate_player_stats_from_events()
RETURNS TRIGGER AS $$
DECLARE
    v_match_id UUID;
    v_player_id UUID;
    v_assist_player_id UUID;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_match_id := OLD.match_id;
        v_player_id := OLD.player_id;
        v_assist_player_id := OLD.assist_player_id;
    ELSE
        v_match_id := NEW.match_id;
        v_player_id := NEW.player_id;
        v_assist_player_id := NEW.assist_player_id;
    END IF;

    PERFORM recalculate_single_player_stats(v_match_id, v_player_id);

    IF v_assist_player_id IS NOT NULL THEN
        PERFORM recalculate_single_player_stats(v_match_id, v_assist_player_id);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_recalculate_player_stats
    AFTER INSERT OR UPDATE OR DELETE ON match_events
    FOR EACH ROW
    EXECUTE FUNCTION trg_recalculate_player_stats_from_events();

DROP TRIGGER IF EXISTS trg_recalculate_player_stats_lineup ON match_lineups;

CREATE OR REPLACE FUNCTION trg_recalculate_player_stats_from_lineups()
RETURNS TRIGGER AS $$
DECLARE
    v_match_id UUID;
    v_player_id UUID;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_match_id := OLD.match_id;
        v_player_id := OLD.player_id;
    ELSE
        v_match_id := NEW.match_id;
        v_player_id := NEW.player_id;
    END IF;

    PERFORM recalculate_single_player_stats(v_match_id, v_player_id);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_recalculate_player_stats_lineup
    AFTER INSERT OR UPDATE OR DELETE ON match_lineups
    FOR EACH ROW
    EXECUTE FUNCTION trg_recalculate_player_stats_from_lineups();
