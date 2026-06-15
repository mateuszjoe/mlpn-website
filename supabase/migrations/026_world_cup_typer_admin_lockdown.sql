-- World Cup typer moderation is reserved for full administrators.
-- Limited admin/editor permissions stay unchanged for the rest of the site.

CREATE OR REPLACE FUNCTION public.protect_typer_profile_moderation_fields()
RETURNS TRIGGER AS $$
BEGIN
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

DROP POLICY IF EXISTS "typer_profiles_public_read" ON public.typer_profiles;
CREATE POLICY "typer_profiles_public_read" ON public.typer_profiles
    FOR SELECT USING (
        status <> 'banned'
        OR user_id = auth.uid()
        OR public.is_admin()
    );

DROP POLICY IF EXISTS "typer_profiles_admin_update" ON public.typer_profiles;
CREATE POLICY "typer_profiles_admin_update" ON public.typer_profiles
    FOR UPDATE USING (public.is_admin())
    WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "typer_profiles_admin_delete" ON public.typer_profiles;
CREATE POLICY "typer_profiles_admin_delete" ON public.typer_profiles
    FOR DELETE USING (public.is_admin());

DROP POLICY IF EXISTS "typer_picks_own_read" ON public.typer_picks;
CREATE POLICY "typer_picks_own_read" ON public.typer_picks
    FOR SELECT USING (
        user_id = auth.uid()
        OR public.is_admin()
    );

DROP POLICY IF EXISTS "typer_picks_admin_delete" ON public.typer_picks;
CREATE POLICY "typer_picks_admin_delete" ON public.typer_picks
    FOR DELETE USING (public.is_admin());

DROP POLICY IF EXISTS "typer_moderation_own_read" ON public.typer_moderation_actions;
CREATE POLICY "typer_moderation_own_read" ON public.typer_moderation_actions
    FOR SELECT USING (
        user_id = auth.uid()
        OR public.is_admin()
    );

DROP POLICY IF EXISTS "typer_moderation_admin_insert" ON public.typer_moderation_actions;
CREATE POLICY "typer_moderation_admin_insert" ON public.typer_moderation_actions
    FOR INSERT WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "typer_moderation_admin_delete" ON public.typer_moderation_actions;
CREATE POLICY "typer_moderation_admin_delete" ON public.typer_moderation_actions
    FOR DELETE USING (public.is_admin());

DROP POLICY IF EXISTS "typer_world_cup_matches_admin_insert" ON public.typer_world_cup_matches;
CREATE POLICY "typer_world_cup_matches_admin_insert" ON public.typer_world_cup_matches
    FOR INSERT WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "typer_world_cup_matches_admin_update" ON public.typer_world_cup_matches;
CREATE POLICY "typer_world_cup_matches_admin_update" ON public.typer_world_cup_matches
    FOR UPDATE USING (public.is_admin())
    WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "typer_world_cup_matches_admin_delete" ON public.typer_world_cup_matches;
CREATE POLICY "typer_world_cup_matches_admin_delete" ON public.typer_world_cup_matches
    FOR DELETE USING (public.is_admin());
