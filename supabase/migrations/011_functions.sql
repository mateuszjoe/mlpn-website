-- ============================================================
-- MLPN - Migracja 011: Funkcje bazodanowe
-- Generate Round Robin, inne utility functions
-- ============================================================


-- ============================================================
-- GENEROWANIE TERMINARZA (double round-robin)
-- Obsluguje dowolna liczbe druzyn (parzysta i nieparzysta)
-- Wywolanie: SELECT generate_round_robin('season-uuid', 'league-uuid', '2025-04-05');
-- ============================================================
CREATE OR REPLACE FUNCTION generate_round_robin(
    p_season_id UUID,
    p_league_id UUID,
    p_start_date DATE DEFAULT CURRENT_DATE
)
RETURNS TABLE(matches_created INTEGER, rounds_total INTEGER) AS $$
DECLARE
    v_teams UUID[];
    v_team_count INTEGER;
    v_rounds INTEGER;
    v_half INTEGER;
    v_round INTEGER;
    v_i INTEGER;
    v_home UUID;
    v_away UUID;
    v_match_date DATE;
    v_time_slots TIME[] := ARRAY['14:30'::TIME, '15:30'::TIME, '16:30'::TIME, '17:30'::TIME, '18:30'::TIME];
    v_match_count INTEGER := 0;
    v_list UUID[];
    v_last UUID;
    v_effective_count INTEGER;
    v_has_bye BOOLEAN := false;
BEGIN
    -- Pobierz druzyny z season_teams
    SELECT ARRAY_AGG(st.team_id ORDER BY t.name)
    INTO v_teams
    FROM season_teams st
    JOIN teams t ON t.id = st.team_id
    WHERE st.season_id = p_season_id AND st.league_id = p_league_id;

    v_team_count := COALESCE(array_length(v_teams, 1), 0);

    IF v_team_count < 2 THEN
        RAISE EXCEPTION 'Potrzeba minimum 2 druzyn, znaleziono: %', v_team_count;
    END IF;

    -- Dla nieparzystej liczby druzyn - dodaj "BYE" (NULL)
    IF v_team_count % 2 = 1 THEN
        v_teams := v_teams || ARRAY[NULL::UUID];
        v_effective_count := v_team_count + 1;
        v_has_bye := true;
    ELSE
        v_effective_count := v_team_count;
    END IF;

    v_rounds := v_effective_count - 1;
    v_half := v_effective_count / 2;
    v_list := v_teams;

    -- ====== PIERWSZA RUNDA (single round-robin) ======
    FOR v_round IN 1..v_rounds LOOP
        v_match_date := p_start_date + ((v_round - 1) * 7);

        FOR v_i IN 1..v_half LOOP
            -- Wyznacz pare
            IF v_round % 2 = 0 THEN
                v_home := v_list[v_i];
                v_away := v_list[v_effective_count + 1 - v_i];
            ELSE
                v_home := v_list[v_effective_count + 1 - v_i];
                v_away := v_list[v_i];
            END IF;

            -- Pomin pary z BYE (NULL)
            IF v_home IS NOT NULL AND v_away IS NOT NULL THEN
                INSERT INTO matches (
                    season_id, league_id, round,
                    home_team_id, away_team_id,
                    match_date, match_time, status
                ) VALUES (
                    p_season_id, p_league_id, v_round,
                    v_home, v_away,
                    v_match_date,
                    v_time_slots[((v_i - 1) % array_length(v_time_slots, 1)) + 1],
                    'scheduled'
                );
                v_match_count := v_match_count + 1;
            END IF;
        END LOOP;

        -- Rotacja (pierwszy element staly, reszta rotuje)
        v_last := v_list[v_effective_count];
        FOR v_i IN REVERSE v_effective_count..3 LOOP
            v_list[v_i] := v_list[v_i - 1];
        END LOOP;
        v_list[2] := v_last;
    END LOOP;

    -- ====== REWANZ (swap home/away) ======
    -- Reset listy
    v_list := v_teams;

    FOR v_round IN 1..v_rounds LOOP
        v_match_date := p_start_date + ((v_rounds + v_round - 1) * 7);

        FOR v_i IN 1..v_half LOOP
            -- Swap home/away wzgledem pierwszej rundy
            IF v_round % 2 = 0 THEN
                v_away := v_list[v_i];
                v_home := v_list[v_effective_count + 1 - v_i];
            ELSE
                v_away := v_list[v_effective_count + 1 - v_i];
                v_home := v_list[v_i];
            END IF;

            IF v_home IS NOT NULL AND v_away IS NOT NULL THEN
                INSERT INTO matches (
                    season_id, league_id, round,
                    home_team_id, away_team_id,
                    match_date, match_time, status
                ) VALUES (
                    p_season_id, p_league_id, v_rounds + v_round,
                    v_home, v_away,
                    v_match_date,
                    v_time_slots[((v_i - 1) % array_length(v_time_slots, 1)) + 1],
                    'scheduled'
                );
                v_match_count := v_match_count + 1;
            END IF;
        END LOOP;

        -- Ta sama rotacja
        v_last := v_list[v_effective_count];
        FOR v_i IN REVERSE v_effective_count..3 LOOP
            v_list[v_i] := v_list[v_i - 1];
        END LOOP;
        v_list[2] := v_last;
    END LOOP;

    -- Zaktualizuj total_rounds w season_leagues
    UPDATE season_leagues
    SET total_rounds = v_rounds * 2
    WHERE season_id = p_season_id AND league_id = p_league_id;

    -- Zwroc wynik
    matches_created := v_match_count;
    rounds_total := v_rounds * 2;
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- INICJALIZACJA STANDINGS
-- Tworzy puste rekordy standings dla wszystkich druzyn w lidze
-- Wywolanie: SELECT initialize_standings('season-uuid', 'league-uuid');
-- ============================================================
CREATE OR REPLACE FUNCTION initialize_standings(
    p_season_id UUID,
    p_league_id UUID
)
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    INSERT INTO standings (season_id, league_id, team_id, position)
    SELECT
        p_season_id,
        p_league_id,
        st.team_id,
        ROW_NUMBER() OVER (ORDER BY t.name)
    FROM season_teams st
    JOIN teams t ON t.id = st.team_id
    WHERE st.season_id = p_season_id AND st.league_id = p_league_id
    ON CONFLICT (season_id, league_id, team_id) DO NOTHING;

    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
