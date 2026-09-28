-- Run against a database with the persistent_match_attendance migration applied.
-- All fixtures and their trigger effects are rolled back; real match data is untouched.
BEGIN;
DO $$
DECLARE
  v_match public.matches;
  v_id UUID := gen_random_uuid();
  v_duty UUID;
  v_other UUID;
  v_player UUID;
  v_away_player UUID;
  v_count INTEGER;
  v_blocked BOOLEAN;
BEGIN
  SELECT id INTO STRICT v_duty FROM public.profiles
    WHERE role <> 'admin' AND public.profile_can_receive_active_match(id) LIMIT 1;
  SELECT id INTO STRICT v_other FROM public.profiles
    WHERE id <> v_duty AND role <> 'admin' AND public.profile_can_receive_active_match(id) LIMIT 1;
  SELECT m.* INTO STRICT v_match FROM public.matches m
    JOIN public.seasons s ON s.id = m.season_id
    WHERE s.status = 'active' AND m.status = 'scheduled'
      AND EXISTS (SELECT 1 FROM public.team_players tp WHERE tp.team_id = m.home_team_id AND tp.season_id = m.season_id AND tp.league_id = m.league_id AND tp.left_date IS NULL)
      AND EXISTS (SELECT 1 FROM public.team_players tp WHERE tp.team_id = m.away_team_id AND tp.season_id = m.season_id AND tp.league_id = m.league_id AND tp.left_date IS NULL)
    LIMIT 1;
  SELECT player_id INTO STRICT v_player FROM public.team_players
    WHERE team_id = v_match.home_team_id AND season_id = v_match.season_id AND league_id = v_match.league_id AND left_date IS NULL LIMIT 1;
  SELECT player_id INTO STRICT v_away_player FROM public.team_players
    WHERE team_id = v_match.away_team_id AND season_id = v_match.season_id AND league_id = v_match.league_id AND left_date IS NULL AND player_id <> v_player LIMIT 1;

  INSERT INTO public.matches (id, season_id, league_id, round, home_team_id, away_team_id, status)
    VALUES (v_id, v_match.season_id, v_match.league_id, 999999, v_match.home_team_id, v_match.away_team_id, 'scheduled');

  PERFORM set_config('request.jwt.claims', jsonb_build_object('sub', v_duty, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  PERFORM public.ensure_active_match_assignment(v_id);
  IF (SELECT status FROM public.matches WHERE id = v_id) <> 'scheduled' THEN RAISE EXCEPTION 'Opening attendance started the match'; END IF;
  PERFORM public.set_match_attendance(v_id, v_match.home_team_id, v_player, true);
  PERFORM public.set_match_attendance(v_id, v_match.home_team_id, v_player, true);
  IF (SELECT count(*) FROM public.match_lineups WHERE match_id = v_id) <> 1 THEN RAISE EXCEPTION 'Presence is not idempotent'; END IF;

  v_blocked := false;
  BEGIN
    PERFORM public.set_match_attendance(v_id, v_match.away_team_id, v_player, true);
  EXCEPTION WHEN OTHERS THEN v_blocked := true;
  END;
  IF NOT v_blocked THEN RAISE EXCEPTION 'Wrong-team attendance accepted'; END IF;

  PERFORM set_config('request.jwt.claims', jsonb_build_object('sub', v_other, 'role', 'authenticated')::text, true);
  v_blocked := false;
  BEGIN
    PERFORM public.ensure_active_match_assignment(v_id);
  EXCEPTION WHEN OTHERS THEN v_blocked := true;
  END;
  IF NOT v_blocked THEN RAISE EXCEPTION 'Another duty stole the assignment'; END IF;
  v_blocked := false;
  BEGIN
    PERFORM public.set_match_attendance(v_id, v_match.home_team_id, v_player, false);
  EXCEPTION WHEN OTHERS THEN v_blocked := true;
  END;
  IF NOT v_blocked THEN RAISE EXCEPTION 'Another duty changed attendance'; END IF;
  DELETE FROM public.match_lineups WHERE match_id = v_id;
  GET DIAGNOSTICS v_count = ROW_COUNT;
  IF v_count <> 0 THEN RAISE EXCEPTION 'RLS allowed another duty to delete attendance'; END IF;

  PERFORM set_config('request.jwt.claims', jsonb_build_object('sub', v_duty, 'role', 'authenticated')::text, true);
  UPDATE public.matches SET status = 'live', home_goals = 0, away_goals = 0 WHERE id = v_id;
  PERFORM public.set_match_attendance(v_id, v_match.away_team_id, v_away_player, true);
  UPDATE public.matches SET status = 'completed', home_goals = 4, away_goals = 2 WHERE id = v_id;
  IF (SELECT assigned_to FROM public.active_match_assignments WHERE match_id = v_id) IS DISTINCT FROM v_duty THEN RAISE EXCEPTION 'Finishing lost duty'; END IF;
  PERFORM public.set_match_attendance(v_id, v_match.home_team_id, v_player, false);
  PERFORM public.set_match_attendance(v_id, v_match.home_team_id, v_player, true);
  IF NOT EXISTS (SELECT 1 FROM public.matches WHERE id = v_id AND status = 'completed' AND home_goals = 4 AND away_goals = 2) THEN RAISE EXCEPTION 'Attendance changed completed score/status'; END IF;
  IF (SELECT count(*) FROM public.match_lineups WHERE match_id = v_id) <> 2 THEN RAISE EXCEPTION 'Late correction lost attendance'; END IF;

  -- An invalid insert happens after DELETE inside the RPC; all of it must roll back.
  v_blocked := false;
  BEGIN
    PERFORM public.save_match_lineups(v_id, jsonb_build_array(jsonb_build_object('match_id', v_id, 'team_id', v_match.home_team_id, 'player_id', gen_random_uuid())));
  EXCEPTION WHEN foreign_key_violation THEN v_blocked := true;
  END;
  IF NOT v_blocked OR (SELECT count(*) FROM public.match_lineups WHERE match_id = v_id) <> 2 THEN RAISE EXCEPTION 'Failed bulk save lost previous attendance'; END IF;

  PERFORM public.transfer_active_match_assignment(v_id, v_other);
  v_blocked := false;
  BEGIN
    PERFORM public.set_match_attendance(v_id, v_match.home_team_id, v_player, false);
  EXCEPTION WHEN OTHERS THEN v_blocked := true;
  END;
  IF NOT v_blocked THEN RAISE EXCEPTION 'Previous duty retained access after transfer'; END IF;
  PERFORM set_config('request.jwt.claims', jsonb_build_object('sub', v_other, 'role', 'authenticated')::text, true);
  PERFORM public.set_match_attendance(v_id, v_match.home_team_id, v_player, false);
  IF (SELECT count(*) FROM public.match_lineups WHERE match_id = v_id) <> 1 THEN RAISE EXCEPTION 'New duty cannot correct completed attendance'; END IF;

  PERFORM set_config('role', 'anon', true);
  PERFORM set_config('request.jwt.claims', '{"role":"anon"}', true);
  v_blocked := false;
  BEGIN
    PERFORM public.set_match_attendance(v_id, v_match.home_team_id, v_player, true);
  EXCEPTION WHEN insufficient_privilege THEN v_blocked := true;
  END;
  IF NOT v_blocked THEN RAISE EXCEPTION 'Anonymous attendance allowed'; END IF;
  PERFORM set_config('role', 'postgres', true);
END;
$$;
ROLLBACK;
SELECT 'PASS: lifecycle, persistence, idempotence, RLS, team validation, rollback, transfer and anonymous denial' AS result;
