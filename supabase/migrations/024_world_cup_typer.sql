-- ============================================================
-- MLPN - Migracja 024: Typer MŚ 2026
-- Profile typera, typy meczów, historia moderacji i storage
-- avatarów użytkowników.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.typer_profiles (
    user_id           UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    nickname          TEXT NOT NULL,
    avatar            JSONB NOT NULL DEFAULT '{"type":"default","id":"playmaker-01"}'::jsonb,
    avatar_url        TEXT,
    email             TEXT,
    champion_team_id  TEXT,
    points            INTEGER NOT NULL DEFAULT 0,
    exact_hits        INTEGER NOT NULL DEFAULT 0,
    result_hits       INTEGER NOT NULL DEFAULT 0,
    advance_hits      INTEGER NOT NULL DEFAULT 0,
    warnings_count    INTEGER NOT NULL DEFAULT 0,
    status            TEXT NOT NULL DEFAULT 'approved',
    moderation_note   TEXT,
    banned_at         TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'typer_profiles_status_check'
    ) THEN
        ALTER TABLE public.typer_profiles
            ADD CONSTRAINT typer_profiles_status_check
            CHECK (status IN ('approved', 'warning', 'blocked', 'banned'));
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'typer_profiles_nickname_len_check'
    ) THEN
        ALTER TABLE public.typer_profiles
            ADD CONSTRAINT typer_profiles_nickname_len_check
            CHECK (char_length(trim(nickname)) BETWEEN 3 AND 28);
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS idx_typer_profiles_nickname_unique
    ON public.typer_profiles (lower(nickname));

CREATE INDEX IF NOT EXISTS idx_typer_profiles_status_points
    ON public.typer_profiles (status, points DESC, exact_hits DESC);

CREATE TABLE IF NOT EXISTS public.typer_picks (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    match_id        TEXT NOT NULL,
    home_score      INTEGER NOT NULL DEFAULT 0 CHECK (home_score >= 0 AND home_score <= 99),
    away_score      INTEGER NOT NULL DEFAULT 0 CHECK (away_score >= 0 AND away_score <= 99),
    advance_team_id TEXT,
    confirmed       BOOLEAN NOT NULL DEFAULT false,
    locked_at       TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE (user_id, match_id)
);

CREATE INDEX IF NOT EXISTS idx_typer_picks_match
    ON public.typer_picks (match_id);

CREATE INDEX IF NOT EXISTS idx_typer_picks_user_updated
    ON public.typer_picks (user_id, updated_at DESC);

CREATE TABLE IF NOT EXISTS public.typer_moderation_actions (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    moderator_id    UUID DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE SET NULL,
    action          TEXT NOT NULL,
    reason          TEXT,
    previous_status TEXT,
    next_status     TEXT,
    metadata        JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'typer_moderation_actions_action_check'
    ) THEN
        ALTER TABLE public.typer_moderation_actions
            ADD CONSTRAINT typer_moderation_actions_action_check
            CHECK (action IN ('approve', 'warn', 'reset_nick', 'block', 'ban', 'unban', 'reject'));
    END IF;
END $$;

ALTER TABLE public.typer_moderation_actions
    ALTER COLUMN moderator_id SET DEFAULT auth.uid();

CREATE INDEX IF NOT EXISTS idx_typer_moderation_actions_user
    ON public.typer_moderation_actions (user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_typer_moderation_actions_moderator
    ON public.typer_moderation_actions (moderator_id, created_at DESC);

CREATE OR REPLACE FUNCTION public.touch_typer_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_typer_profiles_touch ON public.typer_profiles;
CREATE TRIGGER trg_typer_profiles_touch
    BEFORE UPDATE ON public.typer_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.touch_typer_updated_at();

DROP TRIGGER IF EXISTS trg_typer_picks_touch ON public.typer_picks;
CREATE TRIGGER trg_typer_picks_touch
    BEFORE UPDATE ON public.typer_picks
    FOR EACH ROW
    EXECUTE FUNCTION public.touch_typer_updated_at();

CREATE OR REPLACE FUNCTION public.protect_typer_profile_moderation_fields()
RETURNS TRIGGER AS $$
BEGIN
    IF public.has_any_permission(ARRAY['typer.edit', 'typer.delete']) THEN
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
    WHEN (OLD.user_id = auth.uid())
    EXECUTE FUNCTION public.protect_typer_profile_moderation_fields();

ALTER TABLE public.typer_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.typer_picks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.typer_moderation_actions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "typer_profiles_public_read" ON public.typer_profiles;
CREATE POLICY "typer_profiles_public_read" ON public.typer_profiles
    FOR SELECT USING (
        status <> 'banned'
        OR user_id = auth.uid()
        OR public.has_any_permission(ARRAY['typer.edit', 'typer.delete'])
    );

DROP POLICY IF EXISTS "typer_profiles_own_insert" ON public.typer_profiles;
CREATE POLICY "typer_profiles_own_insert" ON public.typer_profiles
    FOR INSERT WITH CHECK (
        user_id = auth.uid()
        AND status = 'approved'
        AND warnings_count = 0
    );

DROP POLICY IF EXISTS "typer_profiles_own_update" ON public.typer_profiles;
CREATE POLICY "typer_profiles_own_update" ON public.typer_profiles
    FOR UPDATE USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS "typer_profiles_admin_update" ON public.typer_profiles;
CREATE POLICY "typer_profiles_admin_update" ON public.typer_profiles
    FOR UPDATE USING (public.has_permission('typer.edit'))
    WITH CHECK (public.has_permission('typer.edit'));

DROP POLICY IF EXISTS "typer_profiles_admin_delete" ON public.typer_profiles;
CREATE POLICY "typer_profiles_admin_delete" ON public.typer_profiles
    FOR DELETE USING (public.has_permission('typer.delete'));

DROP POLICY IF EXISTS "typer_picks_own_read" ON public.typer_picks;
CREATE POLICY "typer_picks_own_read" ON public.typer_picks
    FOR SELECT USING (
        user_id = auth.uid()
        OR public.has_any_permission(ARRAY['typer.edit', 'typer.delete'])
    );

DROP POLICY IF EXISTS "typer_picks_own_insert" ON public.typer_picks;
CREATE POLICY "typer_picks_own_insert" ON public.typer_picks
    FOR INSERT WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS "typer_picks_own_update" ON public.typer_picks;
CREATE POLICY "typer_picks_own_update" ON public.typer_picks
    FOR UPDATE USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS "typer_picks_own_delete" ON public.typer_picks;
CREATE POLICY "typer_picks_own_delete" ON public.typer_picks
    FOR DELETE USING (user_id = auth.uid());

DROP POLICY IF EXISTS "typer_picks_admin_delete" ON public.typer_picks;
CREATE POLICY "typer_picks_admin_delete" ON public.typer_picks
    FOR DELETE USING (public.has_permission('typer.delete'));

DROP POLICY IF EXISTS "typer_moderation_own_read" ON public.typer_moderation_actions;
CREATE POLICY "typer_moderation_own_read" ON public.typer_moderation_actions
    FOR SELECT USING (
        user_id = auth.uid()
        OR public.has_any_permission(ARRAY['typer.edit', 'typer.delete'])
    );

DROP POLICY IF EXISTS "typer_moderation_admin_insert" ON public.typer_moderation_actions;
CREATE POLICY "typer_moderation_admin_insert" ON public.typer_moderation_actions
    FOR INSERT WITH CHECK (public.has_permission('typer.edit'));

DROP POLICY IF EXISTS "typer_moderation_admin_delete" ON public.typer_moderation_actions;
CREATE POLICY "typer_moderation_admin_delete" ON public.typer_moderation_actions
    FOR DELETE USING (public.has_permission('typer.delete'));

-- Storage: własne avatary użytkowników.
INSERT INTO storage.buckets (id, name, public)
VALUES ('typer-avatars', 'typer-avatars', true)
ON CONFLICT (id) DO UPDATE SET public = EXCLUDED.public;

DROP POLICY IF EXISTS "typer_avatars_public_read" ON storage.objects;
CREATE POLICY "typer_avatars_public_read" ON storage.objects
    FOR SELECT USING (bucket_id = 'typer-avatars');

DROP POLICY IF EXISTS "typer_avatars_own_insert" ON storage.objects;
CREATE POLICY "typer_avatars_own_insert" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'typer-avatars'
        AND auth.uid() IS NOT NULL
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

DROP POLICY IF EXISTS "typer_avatars_own_update" ON storage.objects;
CREATE POLICY "typer_avatars_own_update" ON storage.objects
    FOR UPDATE USING (
        bucket_id = 'typer-avatars'
        AND (
            (storage.foldername(name))[1] = auth.uid()::text
            OR public.has_permission('typer.edit')
        )
    );

DROP POLICY IF EXISTS "typer_avatars_own_delete" ON storage.objects;
CREATE POLICY "typer_avatars_own_delete" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'typer-avatars'
        AND (
            (storage.foldername(name))[1] = auth.uid()::text
            OR public.has_permission('typer.delete')
        )
    );
