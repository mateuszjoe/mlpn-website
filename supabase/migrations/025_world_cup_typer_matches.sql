-- ============================================================
-- MLPN - Migracja 025: Mecze MŚ 2026 dla Typera
-- Dane są publicznie czytane przez stronę. Aktualizuje je robot
-- z football-data.org przy użyciu klucza serwisowego Supabase.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.typer_world_cup_matches (
    match_id         TEXT PRIMARY KEY,
    stage            TEXT,
    group_code       TEXT,
    matchday         INTEGER,
    kickoff_at       TIMESTAMPTZ,
    home_team_id     TEXT,
    home_team_name   TEXT,
    home_team_crest  TEXT,
    away_team_id     TEXT,
    away_team_name   TEXT,
    away_team_crest  TEXT,
    status           TEXT NOT NULL DEFAULT 'TIMED',
    duration         TEXT NOT NULL DEFAULT 'REGULAR',
    winner           TEXT,
    home_score       INTEGER,
    away_score       INTEGER,
    source_payload   JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_typer_world_cup_matches_kickoff
    ON public.typer_world_cup_matches (kickoff_at);

CREATE INDEX IF NOT EXISTS idx_typer_world_cup_matches_stage
    ON public.typer_world_cup_matches (stage, matchday, group_code);

DROP TRIGGER IF EXISTS trg_typer_world_cup_matches_touch ON public.typer_world_cup_matches;
CREATE TRIGGER trg_typer_world_cup_matches_touch
    BEFORE UPDATE ON public.typer_world_cup_matches
    FOR EACH ROW
    EXECUTE FUNCTION public.touch_typer_updated_at();

ALTER TABLE public.typer_world_cup_matches ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "typer_world_cup_matches_public_read" ON public.typer_world_cup_matches;
CREATE POLICY "typer_world_cup_matches_public_read" ON public.typer_world_cup_matches
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "typer_world_cup_matches_admin_insert" ON public.typer_world_cup_matches;
CREATE POLICY "typer_world_cup_matches_admin_insert" ON public.typer_world_cup_matches
    FOR INSERT WITH CHECK (public.has_permission('typer.edit'));

DROP POLICY IF EXISTS "typer_world_cup_matches_admin_update" ON public.typer_world_cup_matches;
CREATE POLICY "typer_world_cup_matches_admin_update" ON public.typer_world_cup_matches
    FOR UPDATE USING (public.has_permission('typer.edit'))
    WITH CHECK (public.has_permission('typer.edit'));

DROP POLICY IF EXISTS "typer_world_cup_matches_admin_delete" ON public.typer_world_cup_matches;
CREATE POLICY "typer_world_cup_matches_admin_delete" ON public.typer_world_cup_matches
    FOR DELETE USING (public.has_permission('typer.delete'));
