-- ============================================================
-- MLPN - Migracja 028: Ranking NA ŻYWO dla Typera MŚ 2026
-- Funkcja liczy tymczasowe punkty wszystkich graczy na podstawie
-- wyników na żywo przekazanych z przeglądarki (z ESPN), NIE ujawniając
-- cudzych typów (zwraca tylko zsumy punktów per gracz).
--
-- Wynik bieżący/końcowy z ESPN jest tu "nakładką live": liczymy go tylko dla
-- meczów, które NIE są jeszcze zakończone w bazie (te są już w oficjalnych
-- punktach z recalculate_all_typer_scores), więc nic nie liczy się podwójnie.
-- ============================================================

CREATE OR REPLACE FUNCTION public.typer_live_leaderboard(p_live_scores JSONB)
RETURNS TABLE (
    user_id UUID,
    live_points INTEGER,
    live_exact INTEGER,
    live_result INTEGER,
    live_advance INTEGER
) AS $$
    WITH live_input AS (
        SELECT
            (item->>'match_id')::TEXT AS match_id,
            (item->>'home_score')::INTEGER AS home_score,
            (item->>'away_score')::INTEGER AS away_score
        FROM jsonb_array_elements(coalesce(p_live_scores, '[]'::jsonb)) AS item
    ),
    -- Tylko mecze, które NIE są jeszcze finalne w bazie (FINISHED/AWARDED).
    -- Dla finalnych liczy się oficjalny wynik, nie nakładka live.
    live_matches AS (
        SELECT
            li.match_id,
            li.home_score,
            li.away_score,
            m.stage,
            m.home_team_id,
            m.away_team_id
        FROM live_input li
        JOIN public.typer_world_cup_matches m ON m.match_id = li.match_id
        WHERE upper(coalesce(m.status, '')) NOT IN ('FINISHED', 'AWARDED')
          AND li.home_score IS NOT NULL
          AND li.away_score IS NOT NULL
    ),
    scored AS (
        SELECT
            pick.user_id,
            score.points,
            score.exact_hit,
            score.result_hit,
            score.advance_hit
        FROM public.typer_picks pick
        JOIN live_matches lm ON lm.match_id = pick.match_id
        CROSS JOIN LATERAL public.calculate_typer_pick_score(
            'FINISHED',           -- wymuszamy policzenie wyniku bieżącego
            lm.stage,
            NULL,                 -- zwycięzca dogrywki/karnych nieznany na żywo -> brak bonusu za awans
            lm.home_team_id,
            lm.away_team_id,
            lm.home_score,
            lm.away_score,
            pick.home_score,
            pick.away_score,
            pick.advance_team_id
        ) AS score
    )
    SELECT
        s.user_id,
        coalesce(sum(s.points), 0)::INTEGER AS live_points,
        coalesce(sum(s.exact_hit), 0)::INTEGER AS live_exact,
        coalesce(sum(s.result_hit), 0)::INTEGER AS live_result,
        coalesce(sum(s.advance_hit), 0)::INTEGER AS live_advance
    FROM scored s
    GROUP BY s.user_id;
$$ LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
        EXECUTE 'GRANT EXECUTE ON FUNCTION public.typer_live_leaderboard(JSONB) TO anon';
    END IF;
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
        EXECUTE 'GRANT EXECUTE ON FUNCTION public.typer_live_leaderboard(JSONB) TO authenticated';
    END IF;
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
        EXECUTE 'GRANT EXECUTE ON FUNCTION public.typer_live_leaderboard(JSONB) TO service_role';
    END IF;
END $$;
