-- World Cup typer scoring.
-- This migration recalculates only score columns on typer_profiles.
-- It does not delete or rewrite accounts, profiles, or picks.

CREATE OR REPLACE FUNCTION public.calculate_typer_pick_score(
    p_match_status TEXT,
    p_match_stage TEXT,
    p_match_winner TEXT,
    p_home_team_id TEXT,
    p_away_team_id TEXT,
    p_match_home_score INTEGER,
    p_match_away_score INTEGER,
    p_pick_home_score INTEGER,
    p_pick_away_score INTEGER,
    p_pick_advance_team_id TEXT
)
RETURNS TABLE (
    points INTEGER,
    exact_hit INTEGER,
    result_hit INTEGER,
    advance_hit INTEGER
) AS $$
    WITH normalized AS (
        SELECT
            upper(coalesce(p_match_status, '')) = 'FINISHED'
                AND p_match_home_score IS NOT NULL
                AND p_match_away_score IS NOT NULL
                AND p_pick_home_score IS NOT NULL
                AND p_pick_away_score IS NOT NULL AS is_scored,
            CASE
                WHEN p_match_home_score IS NULL OR p_match_away_score IS NULL THEN NULL
                WHEN p_match_home_score > p_match_away_score THEN 'home'
                WHEN p_match_home_score < p_match_away_score THEN 'away'
                ELSE 'draw'
            END AS match_side,
            CASE
                WHEN p_pick_home_score IS NULL OR p_pick_away_score IS NULL THEN NULL
                WHEN p_pick_home_score > p_pick_away_score THEN 'home'
                WHEN p_pick_home_score < p_pick_away_score THEN 'away'
                ELSE 'draw'
            END AS pick_side,
            p_match_home_score = p_pick_home_score
                AND p_match_away_score = p_pick_away_score AS is_exact,
            CASE upper(coalesce(p_match_winner, ''))
                WHEN 'HOME_TEAM' THEN p_home_team_id
                WHEN 'AWAY_TEAM' THEN p_away_team_id
                ELSE nullif(p_match_winner, '')
            END AS winner_team_id
    ),
    scored AS (
        SELECT
            is_scored,
            is_exact,
            (NOT is_exact AND match_side IS NOT NULL AND match_side = pick_side) AS is_result,
            (
                lower(coalesce(p_match_stage, '')) <> 'group'
                AND match_side = 'draw'
                AND pick_side = 'draw'
                AND nullif(p_pick_advance_team_id, '') IS NOT NULL
                AND nullif(winner_team_id, '') IS NOT NULL
                AND p_pick_advance_team_id = winner_team_id
            ) AS is_advance
        FROM normalized
    )
    SELECT
        CASE
            WHEN NOT is_scored THEN 0
            ELSE
                (CASE WHEN is_exact THEN 3 WHEN is_result THEN 1 ELSE 0 END)
                + (CASE WHEN is_advance THEN 1 ELSE 0 END)
        END::INTEGER AS points,
        CASE WHEN is_scored AND is_exact THEN 1 ELSE 0 END::INTEGER AS exact_hit,
        CASE WHEN is_scored AND is_result THEN 1 ELSE 0 END::INTEGER AS result_hit,
        CASE WHEN is_scored AND is_advance THEN 1 ELSE 0 END::INTEGER AS advance_hit
    FROM scored;
$$ LANGUAGE sql IMMUTABLE;

CREATE OR REPLACE FUNCTION public.protect_typer_profile_moderation_fields()
RETURNS TRIGGER AS $$
BEGIN
    IF current_setting('app.typer_score_recalc', true) = 'on' THEN
        NEW.status = OLD.status;
        NEW.warnings_count = OLD.warnings_count;
        NEW.moderation_note = OLD.moderation_note;
        NEW.banned_at = OLD.banned_at;
        RETURN NEW;
    END IF;

    IF public.is_admin() THEN
        RETURN NEW;
    END IF;

    NEW.status = OLD.status;
    NEW.warnings_count = OLD.warnings_count;
    NEW.moderation_note = OLD.moderation_note;
    NEW.banned_at = OLD.banned_at;
    NEW.points = OLD.points;
    NEW.exact_hits = OLD.exact_hits;
    NEW.result_hits = OLD.result_hits;
    NEW.advance_hits = OLD.advance_hits;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS trg_typer_profiles_protect_moderation ON public.typer_profiles;
CREATE TRIGGER trg_typer_profiles_protect_moderation
    BEFORE UPDATE ON public.typer_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.protect_typer_profile_moderation_fields();

CREATE OR REPLACE FUNCTION public.recalculate_typer_profile_score(p_user_id UUID)
RETURNS VOID AS $$
DECLARE
    v_points INTEGER := 0;
    v_exact_hits INTEGER := 0;
    v_result_hits INTEGER := 0;
    v_advance_hits INTEGER := 0;
BEGIN
    IF p_user_id IS NULL THEN
        RETURN;
    END IF;

    SELECT
        coalesce(sum(score.points), 0)::INTEGER,
        coalesce(sum(score.exact_hit), 0)::INTEGER,
        coalesce(sum(score.result_hit), 0)::INTEGER,
        coalesce(sum(score.advance_hit), 0)::INTEGER
    INTO v_points, v_exact_hits, v_result_hits, v_advance_hits
    FROM public.typer_picks pick
    JOIN public.typer_world_cup_matches match
        ON match.match_id = pick.match_id
    CROSS JOIN LATERAL public.calculate_typer_pick_score(
        match.status,
        match.stage,
        match.winner,
        match.home_team_id,
        match.away_team_id,
        match.home_score,
        match.away_score,
        pick.home_score,
        pick.away_score,
        pick.advance_team_id
    ) AS score
    WHERE pick.user_id = p_user_id;

    PERFORM set_config('app.typer_score_recalc', 'on', true);

    UPDATE public.typer_profiles
    SET
        points = v_points,
        exact_hits = v_exact_hits,
        result_hits = v_result_hits,
        advance_hits = v_advance_hits,
        updated_at = now()
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE OR REPLACE FUNCTION public.recalculate_all_typer_scores()
RETURNS VOID AS $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT user_id FROM public.typer_profiles LOOP
        PERFORM public.recalculate_typer_profile_score(r.user_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE OR REPLACE FUNCTION public.recalculate_typer_scores_for_match(p_match_id TEXT)
RETURNS VOID AS $$
DECLARE
    r RECORD;
BEGIN
    IF p_match_id IS NULL THEN
        RETURN;
    END IF;

    FOR r IN
        SELECT DISTINCT user_id
        FROM public.typer_picks
        WHERE match_id = p_match_id
    LOOP
        PERFORM public.recalculate_typer_profile_score(r.user_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE OR REPLACE FUNCTION public.trg_recalculate_typer_score_from_pick()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        PERFORM public.recalculate_typer_profile_score(OLD.user_id);
        RETURN OLD;
    END IF;

    PERFORM public.recalculate_typer_profile_score(NEW.user_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS trg_recalculate_typer_score_from_pick ON public.typer_picks;
CREATE TRIGGER trg_recalculate_typer_score_from_pick
    AFTER INSERT OR UPDATE OR DELETE ON public.typer_picks
    FOR EACH ROW
    EXECUTE FUNCTION public.trg_recalculate_typer_score_from_pick();

CREATE OR REPLACE FUNCTION public.trg_recalculate_typer_scores_from_match()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        PERFORM public.recalculate_typer_scores_for_match(OLD.match_id);
        RETURN OLD;
    END IF;

    IF TG_OP = 'UPDATE' AND OLD.match_id IS DISTINCT FROM NEW.match_id THEN
        PERFORM public.recalculate_typer_scores_for_match(OLD.match_id);
    END IF;

    PERFORM public.recalculate_typer_scores_for_match(NEW.match_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS trg_recalculate_typer_scores_from_match ON public.typer_world_cup_matches;
CREATE TRIGGER trg_recalculate_typer_scores_from_match
    AFTER INSERT OR UPDATE OF match_id, status, winner, home_score, away_score, home_team_id, away_team_id OR DELETE
    ON public.typer_world_cup_matches
    FOR EACH ROW
    EXECUTE FUNCTION public.trg_recalculate_typer_scores_from_match();

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
        EXECUTE 'REVOKE SELECT ON public.typer_profiles FROM anon';
        EXECUTE 'GRANT SELECT (user_id, nickname, avatar, champion_team_id, status, warnings_count, points, exact_hits, result_hits, advance_hits, updated_at) ON public.typer_profiles TO anon';
        EXECUTE 'GRANT SELECT ON public.typer_world_cup_matches TO anon';
    END IF;

    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
        EXECUTE 'REVOKE SELECT ON public.typer_profiles FROM authenticated';
        EXECUTE 'GRANT SELECT (user_id, nickname, avatar, champion_team_id, status, warnings_count, points, exact_hits, result_hits, advance_hits, updated_at) ON public.typer_profiles TO authenticated';
        EXECUTE 'GRANT INSERT, UPDATE ON public.typer_profiles TO authenticated';
        EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON public.typer_picks TO authenticated';
        EXECUTE 'GRANT SELECT ON public.typer_world_cup_matches TO authenticated';
        EXECUTE 'GRANT SELECT, INSERT ON public.typer_moderation_actions TO authenticated';
    END IF;

    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
        EXECUTE 'GRANT ALL ON public.typer_profiles TO service_role';
        EXECUTE 'GRANT ALL ON public.typer_picks TO service_role';
        EXECUTE 'GRANT ALL ON public.typer_world_cup_matches TO service_role';
        EXECUTE 'GRANT ALL ON public.typer_moderation_actions TO service_role';
        EXECUTE 'GRANT EXECUTE ON FUNCTION public.recalculate_typer_profile_score(UUID) TO service_role';
        EXECUTE 'GRANT EXECUTE ON FUNCTION public.recalculate_all_typer_scores() TO service_role';
    END IF;
END $$;

SELECT public.recalculate_all_typer_scores();
