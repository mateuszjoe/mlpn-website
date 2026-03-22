-- ============================================================
-- MLPN - Migracja 010: Triggery bazodanowe
-- Automatyczne przeliczanie: standings, player stats,
-- suspensions, poll aggregates, typer aggregates
-- ============================================================


-- ============================================================
-- 1. PRZELICZANIE TABELI LIGOWEJ (standings)
-- Uruchamiany po INSERT/UPDATE/DELETE na matches
-- Przelicza CALA tabele danej ligi od zera
-- ============================================================
CREATE OR REPLACE FUNCTION recalculate_standings()
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
    FROM season_leagues
    WHERE season_id = v_season_id AND league_id = v_league_id;

    -- Domyslne wartosci jesli brak konfiguracji
    v_points_win := COALESCE(v_points_win, 3);
    v_points_draw := COALESCE(v_points_draw, 1);
    v_points_loss := COALESCE(v_points_loss, 0);
    v_wo_goals_winner := COALESCE(v_wo_goals_winner, 3);
    v_wo_goals_loser := COALESCE(v_wo_goals_loser, 0);

    -- Usun stare standings dla tej ligi w tym sezonie
    DELETE FROM standings
    WHERE season_id = v_season_id AND league_id = v_league_id;

    -- Przelicz i wstaw nowe standings
    INSERT INTO standings (
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
        FROM matches
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
        FROM matches
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
        LEFT JOIN teams t_opp ON t_opp.id = mr_ranked.opponent_id
        GROUP BY mr_ranked.team_id
    ),
    -- Wszystkie druzyny w lidze (w tym te bez meczow)
    all_teams AS (
        SELECT st.team_id
        FROM season_teams st
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
        JOIN teams t ON t.id = at.team_id
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

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_recalculate_standings
    AFTER INSERT OR UPDATE OR DELETE ON matches
    FOR EACH ROW
    EXECUTE FUNCTION recalculate_standings();


-- ============================================================
-- 2. PRZELICZANIE STATYSTYK ZAWODNIKOW
-- Uruchamiany po INSERT/UPDATE/DELETE na match_events
-- ============================================================
CREATE OR REPLACE FUNCTION recalculate_player_stats()
RETURNS TRIGGER AS $$
DECLARE
    v_match RECORD;
    v_player_id UUID;
    v_assist_player_id UUID;
BEGIN
    -- Pobierz dane meczu
    IF TG_OP = 'DELETE' THEN
        SELECT * INTO v_match FROM matches WHERE id = OLD.match_id;
        v_player_id := OLD.player_id;
        v_assist_player_id := OLD.assist_player_id;
    ELSE
        SELECT * INTO v_match FROM matches WHERE id = NEW.match_id;
        v_player_id := NEW.player_id;
        v_assist_player_id := NEW.assist_player_id;
    END IF;

    IF v_match IS NULL THEN RETURN NULL; END IF;

    -- Przelicz statystyki glownego zawodnika
    INSERT INTO player_season_stats (
        player_id, season_id, league_id, team_id,
        appearances, goals, assists, yellow_cards, red_cards
    )
    SELECT
        v_player_id,
        v_match.season_id,
        v_match.league_id,
        COALESCE(
            (SELECT team_id FROM team_players
             WHERE player_id = v_player_id
               AND season_id = v_match.season_id
               AND league_id = v_match.league_id
               AND left_date IS NULL
             LIMIT 1),
            (SELECT team_id FROM match_lineups
             WHERE player_id = v_player_id AND match_id = v_match.id
             LIMIT 1),
            (SELECT team_id FROM match_events
             WHERE player_id = v_player_id AND match_id = v_match.id
             LIMIT 1)
        ),
        -- appearances
        (SELECT COUNT(DISTINCT ml.match_id)
         FROM match_lineups ml
         JOIN matches m ON m.id = ml.match_id
         WHERE ml.player_id = v_player_id
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        -- goals
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.player_id = v_player_id
           AND me.event_type = 'GOAL'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        -- assists
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.assist_player_id = v_player_id
           AND me.event_type = 'GOAL'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        -- yellow_cards
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.player_id = v_player_id
           AND me.event_type = 'YELLOW_CARD'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        -- red_cards
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.player_id = v_player_id
           AND me.event_type = 'RED_CARD'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id)
    ON CONFLICT (player_id, season_id, league_id) DO UPDATE SET
        team_id = EXCLUDED.team_id,
        appearances = EXCLUDED.appearances,
        goals = EXCLUDED.goals,
        assists = EXCLUDED.assists,
        yellow_cards = EXCLUDED.yellow_cards,
        red_cards = EXCLUDED.red_cards,
        updated_at = now();

    -- Przelicz tez asystenta jesli to byl gol z asysta
    IF v_assist_player_id IS NOT NULL THEN
        INSERT INTO player_season_stats (
            player_id, season_id, league_id, team_id,
            appearances, goals, assists, yellow_cards, red_cards
        )
        SELECT
            v_assist_player_id,
            v_match.season_id,
            v_match.league_id,
            COALESCE(
                (SELECT team_id FROM team_players
                 WHERE player_id = v_assist_player_id
                   AND season_id = v_match.season_id
                   AND league_id = v_match.league_id
                   AND left_date IS NULL
                 LIMIT 1),
                (SELECT team_id FROM match_lineups
                 WHERE player_id = v_assist_player_id AND match_id = v_match.id
                 LIMIT 1)
            ),
            (SELECT COUNT(DISTINCT ml.match_id)
             FROM match_lineups ml
             JOIN matches m ON m.id = ml.match_id
             WHERE ml.player_id = v_assist_player_id
               AND m.season_id = v_match.season_id
               AND m.league_id = v_match.league_id),
            (SELECT COUNT(*) FROM match_events me
             JOIN matches m ON m.id = me.match_id
             WHERE me.player_id = v_assist_player_id
               AND me.event_type = 'GOAL'
               AND m.season_id = v_match.season_id
               AND m.league_id = v_match.league_id),
            (SELECT COUNT(*) FROM match_events me
             JOIN matches m ON m.id = me.match_id
             WHERE me.assist_player_id = v_assist_player_id
               AND me.event_type = 'GOAL'
               AND m.season_id = v_match.season_id
               AND m.league_id = v_match.league_id),
            (SELECT COUNT(*) FROM match_events me
             JOIN matches m ON m.id = me.match_id
             WHERE me.player_id = v_assist_player_id
               AND me.event_type = 'YELLOW_CARD'
               AND m.season_id = v_match.season_id
               AND m.league_id = v_match.league_id),
            (SELECT COUNT(*) FROM match_events me
             JOIN matches m ON m.id = me.match_id
             WHERE me.player_id = v_assist_player_id
               AND me.event_type = 'RED_CARD'
               AND m.season_id = v_match.season_id
               AND m.league_id = v_match.league_id)
        ON CONFLICT (player_id, season_id, league_id) DO UPDATE SET
            team_id = EXCLUDED.team_id,
            appearances = EXCLUDED.appearances,
            goals = EXCLUDED.goals,
            assists = EXCLUDED.assists,
            yellow_cards = EXCLUDED.yellow_cards,
            red_cards = EXCLUDED.red_cards,
            updated_at = now();
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_recalculate_player_stats
    AFTER INSERT OR UPDATE OR DELETE ON match_events
    FOR EACH ROW
    EXECUTE FUNCTION recalculate_player_stats();


-- ============================================================
-- 3. AUTOMATYCZNE PAUZY ZA KARTKI
-- Uruchamiany po INSERT na match_events
-- ============================================================
CREATE OR REPLACE FUNCTION check_auto_suspension()
RETURNS TRIGGER AS $$
DECLARE
    v_match RECORD;
    v_threshold INTEGER;
    v_yellow_count INTEGER;
BEGIN
    -- Tylko kartki
    IF NEW.event_type NOT IN ('YELLOW_CARD', 'RED_CARD') THEN
        RETURN NEW;
    END IF;

    SELECT * INTO v_match FROM matches WHERE id = NEW.match_id;

    -- CZERWONA KARTKA = automatyczna 1 mecz pauzy
    IF NEW.event_type = 'RED_CARD' THEN
        INSERT INTO suspensions (
            player_id, season_id, league_id, suspension_type,
            reason, start_round, end_round, matches_remaining,
            triggering_event_id
        ) VALUES (
            NEW.player_id, v_match.season_id, v_match.league_id,
            'red_card',
            'Automatyczna pauza za czerwona kartke',
            v_match.round + 1, v_match.round + 1, 1,
            NEW.id
        );
        RETURN NEW;
    END IF;

    -- ZOLTA KARTKA - sprawdz akumulacje
    IF NEW.event_type = 'YELLOW_CARD' THEN
        SELECT COALESCE(yellow_card_suspension_threshold, 3) INTO v_threshold
        FROM season_leagues
        WHERE season_id = v_match.season_id AND league_id = v_match.league_id;

        v_threshold := COALESCE(v_threshold, 3);

        -- Licz zolte w tym sezonie w tej lidze
        SELECT COUNT(*) INTO v_yellow_count
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.player_id = NEW.player_id
          AND me.event_type = 'YELLOW_CARD'
          AND m.season_id = v_match.season_id
          AND m.league_id = v_match.league_id;

        -- Sprawdz prog (od v_threshold zoltych kazda kolejna daje pauze)
        IF v_yellow_count >= v_threshold THEN
            INSERT INTO suspensions (
                player_id, season_id, league_id, suspension_type,
                reason, start_round, end_round, matches_remaining,
                triggering_event_id
            ) VALUES (
                NEW.player_id, v_match.season_id, v_match.league_id,
                'yellow_accumulation',
                format('Automatyczna pauza: %s zoltych kartek (od progu %s, kazda kolejna kartka = kolejna pauza)', v_yellow_count, v_threshold),
                v_match.round + 1, v_match.round + 1, 1,
                NEW.id
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_check_auto_suspension
    AFTER INSERT ON match_events
    FOR EACH ROW
    EXECUTE FUNCTION check_auto_suspension();


-- ============================================================
-- 4. AGREGACJA GLOSOW W ANKIETACH
-- Uruchamiany po INSERT/UPDATE/DELETE na poll_votes
-- ============================================================
CREATE OR REPLACE FUNCTION update_poll_aggregates()
RETURNS TRIGGER AS $$
DECLARE
    v_poll_id UUID;
    v_total INTEGER;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_poll_id := OLD.poll_id;
    ELSE
        v_poll_id := NEW.poll_id;
    END IF;

    -- Policz glosy
    SELECT COUNT(*) INTO v_total
    FROM poll_votes WHERE poll_id = v_poll_id;

    -- Zaktualizuj kazda opcje
    UPDATE poll_options po SET
        vote_count = (
            SELECT COUNT(*) FROM poll_votes pv
            WHERE pv.option_id = po.id AND pv.poll_id = v_poll_id
        ),
        vote_percentage = CASE
            WHEN v_total > 0 THEN
                ROUND(
                    (SELECT COUNT(*) FROM poll_votes pv
                     WHERE pv.option_id = po.id AND pv.poll_id = v_poll_id
                    )::NUMERIC / v_total * 100,
                    2
                )
            ELSE 0
        END
    WHERE po.poll_id = v_poll_id;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_update_poll_aggregates
    AFTER INSERT OR UPDATE OR DELETE ON poll_votes
    FOR EACH ROW
    EXECUTE FUNCTION update_poll_aggregates();


-- ============================================================
-- 5. AGREGACJA PREDYKCJI W TYPERZE
-- Uruchamiany po INSERT/UPDATE/DELETE na typer_predictions
-- ============================================================
CREATE OR REPLACE FUNCTION update_typer_aggregates()
RETURNS TRIGGER AS $$
DECLARE
    v_match_id UUID;
    v_total INTEGER;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_match_id := OLD.match_id;
    ELSE
        v_match_id := NEW.match_id;
    END IF;

    SELECT COUNT(*) INTO v_total
    FROM typer_predictions WHERE match_id = v_match_id;

    INSERT INTO typer_aggregates (match_id, total_votes, home_win_pct, draw_pct, away_win_pct)
    VALUES (
        v_match_id,
        v_total,
        CASE WHEN v_total > 0 THEN
            ROUND((SELECT COUNT(*) FROM typer_predictions
                   WHERE match_id = v_match_id AND prediction = '1'
                  )::NUMERIC / v_total * 100, 2)
        ELSE 0 END,
        CASE WHEN v_total > 0 THEN
            ROUND((SELECT COUNT(*) FROM typer_predictions
                   WHERE match_id = v_match_id AND prediction = 'X'
                  )::NUMERIC / v_total * 100, 2)
        ELSE 0 END,
        CASE WHEN v_total > 0 THEN
            ROUND((SELECT COUNT(*) FROM typer_predictions
                   WHERE match_id = v_match_id AND prediction = '2'
                  )::NUMERIC / v_total * 100, 2)
        ELSE 0 END
    )
    ON CONFLICT (match_id) DO UPDATE SET
        total_votes = EXCLUDED.total_votes,
        home_win_pct = EXCLUDED.home_win_pct,
        draw_pct = EXCLUDED.draw_pct,
        away_win_pct = EXCLUDED.away_win_pct,
        updated_at = now();

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_update_typer_aggregates
    AFTER INSERT OR UPDATE OR DELETE ON typer_predictions
    FOR EACH ROW
    EXECUTE FUNCTION update_typer_aggregates();
