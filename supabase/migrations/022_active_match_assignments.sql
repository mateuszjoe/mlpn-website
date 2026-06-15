-- Przypisanie aktywnego meczu do dyzurnego.
-- Superadmin (role = admin) ma pelny dostep, zwykly dyzurny tylko do swojego meczu.

CREATE TABLE IF NOT EXISTS public.active_match_assignments (
    match_id                  UUID PRIMARY KEY REFERENCES public.matches(id) ON DELETE CASCADE,
    assigned_to               UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    assigned_to_name_snapshot TEXT,
    assigned_by               UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    assigned_by_name_snapshot TEXT,
    assigned_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_active_match_assignments_assigned_to
    ON public.active_match_assignments (assigned_to);

ALTER TABLE public.active_match_assignments ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION public.profile_admin_label(p_user_id UUID)
RETURNS TEXT AS $$
    SELECT COALESCE(
        NULLIF(BTRIM(CONCAT_WS(' ', p.first_name, p.last_name)), ''),
        NULLIF(BTRIM(p.display_name), ''),
        NULLIF(BTRIM(p.email), ''),
        p.id::TEXT
    )
    FROM public.profiles p
    WHERE p.id = p_user_id;
$$ LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public;

CREATE OR REPLACE FUNCTION public.profile_can_receive_active_match(p_user_id UUID)
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.profiles p
        WHERE p.id = p_user_id
          AND p.account_status = 'active'
          AND (
            p.role = 'admin'
            OR p.role = 'editor'
            OR COALESCE(jsonb_extract_path_text(p.permissions, 'results', 'enter') = 'true', false)
            OR COALESCE(jsonb_extract_path_text(p.permissions, 'results', 'edit') = 'true', false)
          )
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public;

CREATE OR REPLACE FUNCTION public.can_manage_active_match(p_match_id UUID)
RETURNS BOOLEAN AS $$
    SELECT
      public.is_admin()
      OR (
        public.has_any_permission(ARRAY['results.enter', 'results.edit'])
        AND EXISTS (
          SELECT 1
          FROM public.active_match_assignments ama
          WHERE ama.match_id = p_match_id
            AND ama.assigned_to = auth.uid()
        )
      );
$$ LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public;

CREATE OR REPLACE FUNCTION public.can_manage_match_result_row(p_match_id UUID, p_current_status TEXT)
RETURNS BOOLEAN AS $$
    SELECT CASE
      WHEN p_current_status = 'live' THEN public.can_manage_active_match(p_match_id)
      ELSE public.has_any_permission(ARRAY['schedule.edit', 'results.enter', 'results.edit', 'seasons.edit'])
    END;
$$ LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public;

CREATE OR REPLACE FUNCTION public.can_insert_match_event(p_match_id UUID)
RETURNS BOOLEAN AS $$
    SELECT CASE
      WHEN m.status = 'live' THEN public.can_manage_active_match(m.id)
      ELSE public.has_any_permission(ARRAY['results.enter', 'results.edit'])
    END
    FROM public.matches m
    WHERE m.id = p_match_id;
$$ LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public;

CREATE OR REPLACE FUNCTION public.can_edit_match_event(p_match_id UUID)
RETURNS BOOLEAN AS $$
    SELECT CASE
      WHEN m.status = 'live' THEN public.can_manage_active_match(m.id)
      ELSE public.has_permission('results.edit')
    END
    FROM public.matches m
    WHERE m.id = p_match_id;
$$ LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public;

CREATE OR REPLACE FUNCTION public.can_edit_match_lineup(p_match_id UUID)
RETURNS BOOLEAN AS $$
    SELECT CASE
      WHEN m.status = 'live' THEN public.can_manage_active_match(m.id)
      ELSE public.has_any_permission(ARRAY['results.enter', 'results.edit'])
    END
    FROM public.matches m
    WHERE m.id = p_match_id;
$$ LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public;

CREATE OR REPLACE FUNCTION public.sync_active_match_assignment()
RETURNS TRIGGER AS $$
DECLARE
    v_actor UUID := auth.uid();
    v_actor_name TEXT;
BEGIN
    IF NEW.status = 'live' AND OLD.status IS DISTINCT FROM 'live' THEN
        v_actor_name := public.profile_admin_label(v_actor);

        INSERT INTO public.active_match_assignments (
            match_id,
            assigned_to,
            assigned_to_name_snapshot,
            assigned_by,
            assigned_by_name_snapshot,
            assigned_at
        )
        VALUES (
            NEW.id,
            v_actor,
            COALESCE(v_actor_name, 'Nieprzypisany'),
            v_actor,
            COALESCE(v_actor_name, 'system'),
            now()
        )
        ON CONFLICT (match_id) DO UPDATE SET
            assigned_to = EXCLUDED.assigned_to,
            assigned_to_name_snapshot = EXCLUDED.assigned_to_name_snapshot,
            assigned_by = EXCLUDED.assigned_by,
            assigned_by_name_snapshot = EXCLUDED.assigned_by_name_snapshot,
            assigned_at = EXCLUDED.assigned_at,
            updated_at = now();
    ELSIF OLD.status = 'live' AND NEW.status IS DISTINCT FROM 'live' THEN
        DELETE FROM public.active_match_assignments
        WHERE match_id = NEW.id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS trg_sync_active_match_assignment ON public.matches;
CREATE TRIGGER trg_sync_active_match_assignment
    AFTER UPDATE OF status ON public.matches
    FOR EACH ROW
    EXECUTE FUNCTION public.sync_active_match_assignment();

INSERT INTO public.active_match_assignments (
    match_id,
    assigned_to,
    assigned_to_name_snapshot,
    assigned_by,
    assigned_by_name_snapshot,
    assigned_at
)
SELECT
    m.id,
    mre.edited_by,
    COALESCE(mre.editor_name_snapshot, public.profile_admin_label(mre.edited_by), 'Nieprzypisany'),
    mre.edited_by,
    COALESCE(mre.editor_name_snapshot, public.profile_admin_label(mre.edited_by), 'system'),
    COALESCE(mre.edited_at, now())
FROM public.matches m
LEFT JOIN public.match_result_edits mre ON mre.match_id = m.id
WHERE m.status = 'live'
ON CONFLICT (match_id) DO NOTHING;

CREATE OR REPLACE FUNCTION public.ensure_active_match_assignment(p_match_id UUID)
RETURNS VOID AS $$
DECLARE
    v_actor UUID := auth.uid();
    v_actor_name TEXT;
    v_match_status TEXT;
BEGIN
    IF NOT public.has_any_permission(ARRAY['results.enter', 'results.edit']) THEN
        RAISE EXCEPTION 'Insufficient permissions to assign active match';
    END IF;

    SELECT status INTO v_match_status
    FROM public.matches
    WHERE id = p_match_id;

    IF v_match_status IS DISTINCT FROM 'live' THEN
        RETURN;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM public.active_match_assignments
        WHERE match_id = p_match_id
    ) THEN
        RETURN;
    END IF;

    v_actor_name := public.profile_admin_label(v_actor);

    INSERT INTO public.active_match_assignments (
        match_id,
        assigned_to,
        assigned_to_name_snapshot,
        assigned_by,
        assigned_by_name_snapshot,
        assigned_at
    )
    VALUES (
        p_match_id,
        v_actor,
        COALESCE(v_actor_name, 'Nieprzypisany'),
        v_actor,
        COALESCE(v_actor_name, 'system'),
        now()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE OR REPLACE FUNCTION public.transfer_active_match_assignment(
    p_match_id UUID,
    p_assigned_to UUID
)
RETURNS public.active_match_assignments AS $$
DECLARE
    v_actor UUID := auth.uid();
    v_actor_name TEXT;
    v_target_name TEXT;
    v_match_status TEXT;
    v_current_assigned_to UUID;
    v_row public.active_match_assignments;
BEGIN
    IF NOT public.has_any_permission(ARRAY['results.enter', 'results.edit']) THEN
        RAISE EXCEPTION 'Insufficient permissions to transfer active match';
    END IF;

    SELECT status INTO v_match_status
    FROM public.matches
    WHERE id = p_match_id;

    IF v_match_status IS DISTINCT FROM 'live' THEN
        RAISE EXCEPTION 'Only live matches can be transferred';
    END IF;

    IF NOT public.profile_can_receive_active_match(p_assigned_to) THEN
        RAISE EXCEPTION 'Selected user cannot receive active match';
    END IF;

    SELECT assigned_to INTO v_current_assigned_to
    FROM public.active_match_assignments
    WHERE match_id = p_match_id;

    IF NOT public.is_admin() AND v_current_assigned_to IS DISTINCT FROM v_actor THEN
        RAISE EXCEPTION 'Only assigned duty user or superadmin can transfer active match';
    END IF;

    v_actor_name := public.profile_admin_label(v_actor);
    v_target_name := public.profile_admin_label(p_assigned_to);

    INSERT INTO public.active_match_assignments (
        match_id,
        assigned_to,
        assigned_to_name_snapshot,
        assigned_by,
        assigned_by_name_snapshot,
        assigned_at
    )
    VALUES (
        p_match_id,
        p_assigned_to,
        COALESCE(v_target_name, p_assigned_to::TEXT),
        v_actor,
        COALESCE(v_actor_name, v_actor::TEXT, 'system'),
        now()
    )
    ON CONFLICT (match_id) DO UPDATE SET
        assigned_to = EXCLUDED.assigned_to,
        assigned_to_name_snapshot = EXCLUDED.assigned_to_name_snapshot,
        assigned_by = EXCLUDED.assigned_by,
        assigned_by_name_snapshot = EXCLUDED.assigned_by_name_snapshot,
        assigned_at = EXCLUDED.assigned_at,
        updated_at = now()
    RETURNING * INTO v_row;

    RETURN v_row;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE OR REPLACE FUNCTION public.list_active_match_duty_users()
RETURNS TABLE (
    id UUID,
    label TEXT,
    role TEXT
) AS $$
BEGIN
    IF NOT public.has_any_permission(ARRAY['results.enter', 'results.edit']) THEN
        RAISE EXCEPTION 'Insufficient permissions to list duty users';
    END IF;

    RETURN QUERY
    SELECT
        p.id,
        COALESCE(
            NULLIF(BTRIM(CONCAT_WS(' ', p.first_name, p.last_name)), ''),
            NULLIF(BTRIM(p.display_name), ''),
            NULLIF(BTRIM(p.email), ''),
            p.id::TEXT
        ) AS label,
        p.role
    FROM public.profiles p
    WHERE p.account_status = 'active'
      AND public.profile_can_receive_active_match(p.id)
    ORDER BY
        CASE WHEN p.role = 'admin' THEN 0 ELSE 1 END,
        2 ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP POLICY IF EXISTS "active_match_assignments_read" ON public.active_match_assignments;
DROP POLICY IF EXISTS "active_match_assignments_admin_all" ON public.active_match_assignments;
CREATE POLICY "active_match_assignments_read" ON public.active_match_assignments
    FOR SELECT USING (public.has_any_permission(ARRAY['results.enter', 'results.edit']));
CREATE POLICY "active_match_assignments_admin_all" ON public.active_match_assignments
    FOR ALL USING (public.is_admin())
    WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "matches_editor_update" ON public.matches;
CREATE POLICY "matches_editor_update" ON public.matches
    FOR UPDATE USING (public.can_manage_match_result_row(id, status))
    WITH CHECK (public.has_any_permission(ARRAY['schedule.edit', 'results.enter', 'results.edit', 'seasons.edit']));

DROP POLICY IF EXISTS "match_events_editor_insert" ON public.match_events;
DROP POLICY IF EXISTS "match_events_editor_update" ON public.match_events;
DROP POLICY IF EXISTS "match_events_admin_delete" ON public.match_events;
CREATE POLICY "match_events_editor_insert" ON public.match_events
    FOR INSERT WITH CHECK (public.can_insert_match_event(match_id));
CREATE POLICY "match_events_editor_update" ON public.match_events
    FOR UPDATE USING (public.can_edit_match_event(match_id));
CREATE POLICY "match_events_admin_delete" ON public.match_events
    FOR DELETE USING (public.can_edit_match_event(match_id));

DROP POLICY IF EXISTS "match_lineups_editor_insert" ON public.match_lineups;
DROP POLICY IF EXISTS "match_lineups_editor_update" ON public.match_lineups;
DROP POLICY IF EXISTS "match_lineups_admin_delete" ON public.match_lineups;
CREATE POLICY "match_lineups_editor_insert" ON public.match_lineups
    FOR INSERT WITH CHECK (public.can_edit_match_lineup(match_id));
CREATE POLICY "match_lineups_editor_update" ON public.match_lineups
    FOR UPDATE USING (public.can_edit_match_lineup(match_id));
CREATE POLICY "match_lineups_admin_delete" ON public.match_lineups
    FOR DELETE USING (public.can_edit_match_lineup(match_id));
