-- A duty and its attendance survive opening, starting and finishing a match.
-- No existing match, score or lineup data is rewritten by this migration.

CREATE OR REPLACE FUNCTION public.ensure_active_match_assignment(p_match_id UUID)
RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_actor UUID := auth.uid();
  v_status TEXT;
  v_name TEXT;
BEGIN
  IF v_actor IS NULL OR NOT public.has_any_permission(ARRAY['results.enter', 'results.edit']) THEN
    RAISE EXCEPTION 'Brak uprawnień do prowadzenia listy obecności';
  END IF;
  SELECT status INTO v_status FROM public.matches WHERE id = p_match_id FOR UPDATE;
  IF v_status IS NULL OR v_status NOT IN ('scheduled', 'live', 'completed') THEN
    RAISE EXCEPTION 'Lista obecności jest dostępna przed meczem, w trakcie i po zakończeniu';
  END IF;
  v_name := public.profile_admin_label(v_actor);
  INSERT INTO public.active_match_assignments (
    match_id, assigned_to, assigned_to_name_snapshot, assigned_by, assigned_by_name_snapshot, assigned_at
  ) VALUES (p_match_id, v_actor, v_name, v_actor, v_name, now())
  ON CONFLICT (match_id) DO UPDATE SET
    assigned_to = EXCLUDED.assigned_to,
    assigned_to_name_snapshot = EXCLUDED.assigned_to_name_snapshot,
    assigned_by = EXCLUDED.assigned_by,
    assigned_by_name_snapshot = EXCLUDED.assigned_by_name_snapshot,
    assigned_at = now(), updated_at = now()
  WHERE active_match_assignments.assigned_to IS NULL;
  IF NOT public.can_manage_active_match(p_match_id) THEN
    RAISE EXCEPTION 'Ten mecz jest przypisany do innego dyżurnego';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.sync_active_match_assignment()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF NEW.status = 'live' AND OLD.status IS DISTINCT FROM 'live' THEN
    -- Retain the duty claimed while taking attendance before kickoff.
    IF auth.uid() IS NOT NULL AND public.has_any_permission(ARRAY['results.enter', 'results.edit']) THEN
      PERFORM public.ensure_active_match_assignment(NEW.id);
    END IF;
  END IF;
  -- Keep the assignment when the match ends; the duty can correct attendance.
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.can_edit_match_lineup(p_match_id UUID)
RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public AS $$
  SELECT auth.uid() IS NOT NULL AND CASE
    WHEN m.status = 'live' OR EXISTS (
      SELECT 1 FROM public.active_match_assignments a
      WHERE a.match_id = m.id AND a.assigned_to IS NOT NULL
    ) THEN public.can_manage_active_match(m.id)
    ELSE public.has_any_permission(ARRAY['results.enter', 'results.edit'])
  END
  FROM public.matches m WHERE m.id = p_match_id;
$$;

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
    IF v_actor IS NULL OR NOT public.has_any_permission(ARRAY['results.enter', 'results.edit']) THEN
        RAISE EXCEPTION 'Insufficient permissions to transfer active match';
    END IF;

    SELECT status INTO v_match_status
    FROM public.matches
    WHERE id = p_match_id FOR UPDATE;

    IF v_match_status IS NULL OR v_match_status NOT IN ('scheduled', 'live', 'completed') THEN
        RAISE EXCEPTION 'Nie można przekazać dyżuru dla tego statusu meczu';
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



-- Invoker functions keep RLS in force. A match-row lock serializes attendance
-- saves with duty transfers and status changes. Only one player is changed.
CREATE OR REPLACE FUNCTION public.set_match_attendance(
  p_match_id UUID, p_team_id UUID, p_player_id UUID, p_present BOOLEAN
)
RETURNS SETOF public.match_lineups LANGUAGE plpgsql SECURITY INVOKER SET search_path = public AS $$
DECLARE
  v_match public.matches;
BEGIN
  IF auth.uid() IS NULL OR NOT COALESCE(public.can_edit_match_lineup(p_match_id), false) THEN
    RAISE EXCEPTION 'Brak uprawnień do tej listy obecności';
  END IF;
  SELECT * INTO v_match FROM public.matches WHERE id = p_match_id FOR UPDATE;
  IF NOT FOUND OR v_match.status NOT IN ('scheduled', 'live', 'completed') THEN
    RAISE EXCEPTION 'Ten mecz nie obsługuje listy obecności';
  END IF;
  -- Recheck after the lock, in case another duty transferred the match.
  IF NOT COALESCE(public.can_edit_match_lineup(p_match_id), false) THEN
    RAISE EXCEPTION 'Dyżur został przekazany innej osobie';
  END IF;
  IF p_team_id IS NULL OR p_team_id NOT IN (v_match.home_team_id, v_match.away_team_id) OR p_present IS NULL THEN
    RAISE EXCEPTION 'Nieprawidłowa drużyna lub obecność';
  END IF;
  IF p_present THEN
    IF NOT EXISTS (
      SELECT 1 FROM public.team_players tp WHERE tp.player_id = p_player_id
        AND tp.team_id = p_team_id AND tp.season_id = v_match.season_id
        AND tp.league_id = v_match.league_id AND tp.left_date IS NULL
    ) AND NOT EXISTS (
      SELECT 1 FROM public.match_lineups ml WHERE ml.match_id = p_match_id
        AND ml.team_id = p_team_id AND ml.player_id = p_player_id
    ) THEN
      RAISE EXCEPTION 'Zawodnik nie należy do kadry tej drużyny';
    END IF;
    INSERT INTO public.match_lineups (match_id, team_id, player_id, is_starter, shirt_number)
    VALUES (p_match_id, p_team_id, p_player_id, true, (
      SELECT tp.shirt_number FROM public.team_players tp WHERE tp.player_id = p_player_id
        AND tp.team_id = p_team_id AND tp.season_id = v_match.season_id
        AND tp.league_id = v_match.league_id AND tp.left_date IS NULL LIMIT 1
    )) ON CONFLICT (match_id, player_id) DO NOTHING;
    IF NOT EXISTS (SELECT 1 FROM public.match_lineups WHERE match_id = p_match_id AND player_id = p_player_id AND team_id = p_team_id) THEN
      RAISE EXCEPTION 'Zawodnik jest już wpisany w drugiej drużynie';
    END IF;
  ELSE
    DELETE FROM public.match_lineups WHERE match_id = p_match_id AND team_id = p_team_id AND player_id = p_player_id;
  END IF;
  PERFORM public.touch_match_result_edit(p_match_id);
  RETURN QUERY SELECT * FROM public.match_lineups WHERE match_id = p_match_id AND team_id = p_team_id AND player_id = p_player_id;
END;
$$;

-- The existing result editor also saves attendance atomically. A failed insert
-- must never leave the previous list deleted.
CREATE OR REPLACE FUNCTION public.save_match_lineups(p_match_id UUID, p_lineups JSONB)
RETURNS VOID LANGUAGE plpgsql SECURITY INVOKER SET search_path = public AS $$
DECLARE
  v_match public.matches;
BEGIN
  IF auth.uid() IS NULL OR NOT COALESCE(public.can_edit_match_lineup(p_match_id), false) THEN
    RAISE EXCEPTION 'Brak uprawnień do tej listy obecności';
  END IF;
  SELECT * INTO v_match FROM public.matches WHERE id = p_match_id FOR UPDATE;
  IF NOT FOUND OR NOT COALESCE(public.can_edit_match_lineup(p_match_id), false) THEN
    RAISE EXCEPTION 'Brak dostępu do meczu';
  END IF;
  IF p_lineups IS NULL OR jsonb_typeof(p_lineups) <> 'array' THEN
    RAISE EXCEPTION 'Nieprawidłowa lista obecności';
  END IF;
  IF EXISTS (
    SELECT 1 FROM jsonb_to_recordset(p_lineups) AS r(match_id UUID, team_id UUID, player_id UUID)
    WHERE r.match_id IS DISTINCT FROM p_match_id OR r.player_id IS NULL OR r.team_id IS NULL
       OR r.team_id NOT IN (v_match.home_team_id, v_match.away_team_id)
  ) THEN
    RAISE EXCEPTION 'Nieprawidłowy zawodnik, mecz lub drużyna';
  END IF;
  DELETE FROM public.match_lineups WHERE match_id = p_match_id;
  INSERT INTO public.match_lineups (match_id, team_id, player_id, is_starter, shirt_number, position_played)
  SELECT p_match_id, r.team_id, r.player_id, COALESCE(r.is_starter, true), r.shirt_number, r.position_played
  FROM jsonb_to_recordset(p_lineups) AS r(team_id UUID, player_id UUID, is_starter BOOLEAN, shirt_number INTEGER, position_played TEXT);
END;
$$;

REVOKE ALL ON FUNCTION public.ensure_active_match_assignment(UUID) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.transfer_active_match_assignment(UUID, UUID) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.set_match_attendance(UUID, UUID, UUID, BOOLEAN) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.save_match_lineups(UUID, JSONB) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.ensure_active_match_assignment(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.transfer_active_match_assignment(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.set_match_attendance(UUID, UUID, UUID, BOOLEAN) TO authenticated;
GRANT EXECUTE ON FUNCTION public.save_match_lineups(UUID, JSONB) TO authenticated;
