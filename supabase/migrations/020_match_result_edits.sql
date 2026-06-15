-- Ostatnia edycja wyniku meczu w panelu admina.
CREATE TABLE IF NOT EXISTS public.match_result_edits (
    match_id             UUID PRIMARY KEY REFERENCES public.matches(id) ON DELETE CASCADE,
    edited_by            UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    editor_name_snapshot TEXT,
    edited_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_match_result_edits_edited_at
    ON public.match_result_edits (edited_at DESC);

ALTER TABLE public.match_result_edits ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "match_result_edits_results_read" ON public.match_result_edits;
CREATE POLICY "match_result_edits_results_read" ON public.match_result_edits
    FOR SELECT USING (
        public.has_any_permission(ARRAY['results.enter', 'results.edit'])
    );

CREATE OR REPLACE FUNCTION public.record_match_result_edit()
RETURNS TRIGGER AS $$
DECLARE
    v_editor UUID := auth.uid();
    v_editor_name TEXT;
BEGIN
    IF (
        OLD.home_goals IS DISTINCT FROM NEW.home_goals
        OR OLD.away_goals IS DISTINCT FROM NEW.away_goals
        OR OLD.status IS DISTINCT FROM NEW.status
    ) THEN
        SELECT COALESCE(
            NULLIF(BTRIM(CONCAT_WS(' ', p.first_name, p.last_name)), ''),
            NULLIF(BTRIM(p.display_name), ''),
            NULLIF(BTRIM(p.email), '')
        )
        INTO v_editor_name
        FROM public.profiles p
        WHERE p.id = v_editor;

        INSERT INTO public.match_result_edits (
            match_id,
            edited_by,
            editor_name_snapshot,
            edited_at
        )
        VALUES (
            NEW.id,
            v_editor,
            COALESCE(v_editor_name, v_editor::TEXT, 'system'),
            now()
        )
        ON CONFLICT (match_id) DO UPDATE SET
            edited_by = EXCLUDED.edited_by,
            editor_name_snapshot = EXCLUDED.editor_name_snapshot,
            edited_at = EXCLUDED.edited_at;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS trg_record_match_result_edit ON public.matches;
CREATE TRIGGER trg_record_match_result_edit
    AFTER UPDATE ON public.matches
    FOR EACH ROW
    EXECUTE FUNCTION public.record_match_result_edit();

CREATE OR REPLACE FUNCTION public.touch_match_result_edit(p_match_id UUID)
RETURNS VOID AS $$
DECLARE
    v_editor UUID := auth.uid();
    v_editor_name TEXT;
BEGIN
    IF NOT public.has_any_permission(ARRAY['results.enter', 'results.edit']) THEN
        RAISE EXCEPTION 'Insufficient permissions to record match result edit';
    END IF;

    SELECT COALESCE(
        NULLIF(BTRIM(CONCAT_WS(' ', p.first_name, p.last_name)), ''),
        NULLIF(BTRIM(p.display_name), ''),
        NULLIF(BTRIM(p.email), '')
    )
    INTO v_editor_name
    FROM public.profiles p
    WHERE p.id = v_editor;

    INSERT INTO public.match_result_edits (
        match_id,
        edited_by,
        editor_name_snapshot,
        edited_at
    )
    VALUES (
        p_match_id,
        v_editor,
        COALESCE(v_editor_name, v_editor::TEXT, 'system'),
        now()
    )
    ON CONFLICT (match_id) DO UPDATE SET
        edited_by = EXCLUDED.edited_by,
        editor_name_snapshot = EXCLUDED.editor_name_snapshot,
        edited_at = EXCLUDED.edited_at;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
