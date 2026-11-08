-- Run as the database owner after the head_to_head_standings migration.
-- Each scenario creates its own isolated dummy season and league in a separate
-- transaction. ROLLBACK removes every fixture and all trigger effects.
-- Existing standings and match records are verified unchanged in each scenario.

-- Scenario 1: Pair ranking and excluded match statuses.
BEGIN;

CREATE TEMP TABLE h2h_before_standings ON COMMIT DROP AS
  SELECT to_jsonb(s) AS row_data FROM public.standings s;
CREATE TEMP TABLE h2h_before_matches ON COMMIT DROP AS
  SELECT to_jsonb(m) AS row_data FROM public.matches m;

DO $$
DECLARE
  v_season uuid := gen_random_uuid();
  v_league uuid := gen_random_uuid();
  v_a uuid := gen_random_uuid();
  v_b uuid := gen_random_uuid();
  v_c uuid := gen_random_uuid();
  v_d uuid := gen_random_uuid();
  v_tag text := gen_random_uuid()::text;
  v_year integer := 9000;
  v_actual uuid[];
  v_before jsonb;
  v_after jsonb;
BEGIN
  WHILE EXISTS (SELECT 1 FROM public.seasons WHERE year = v_year) LOOP
    v_year := v_year + 1;
  END LOOP;
  INSERT INTO public.seasons (id, year, name, status, is_current)
    VALUES (v_season, v_year, 'Head-to-head rollback regression ' || v_tag, 'planned', false);
  INSERT INTO public.leagues (id, code, name)
    VALUES (v_league, 'h2h-' || v_tag, 'Head-to-head rollback regression');
  INSERT INTO public.season_leagues (season_id, league_id)
    VALUES (v_season, v_league);
  INSERT INTO public.teams (id, name, abbreviation) VALUES
    (v_a, 'A h2h ' || v_tag, 'A-' || v_tag),
    (v_b, 'B h2h ' || v_tag, 'B-' || v_tag),
    (v_c, 'C h2h ' || v_tag, 'C-' || v_tag),
    (v_d, 'D h2h ' || v_tag, 'D-' || v_tag);
  INSERT INTO public.season_teams (season_id, league_id, team_id)
    SELECT v_season, v_league, team FROM unnest(ARRAY[v_a, v_b, v_c, v_d]) team;

  -- Pair: A beats B directly despite B having a much better overall GD.
  INSERT INTO public.matches (season_id, league_id, round, home_team_id, away_team_id, home_goals, away_goals, status) VALUES
    (v_season, v_league, 1, v_a, v_b, 1, 0, 'completed'),
    (v_season, v_league, 2, v_b, v_d, 20, 0, 'completed'),
    (v_season, v_league, 3, v_c, v_a, 1, 0, 'completed'),
    (v_season, v_league, 4, v_c, v_d, 1, 0, 'completed');
  SELECT array_agg(s.team_id ORDER BY s.position) INTO v_actual
    FROM public.standings s WHERE s.season_id = v_season AND s.league_id = v_league;
  IF v_actual IS DISTINCT FROM ARRAY[v_c, v_a, v_b, v_d] THEN
    RAISE EXCEPTION 'Pair head-to-head ranking failed: %', v_actual;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.standings WHERE season_id = v_season
    AND team_id = v_b AND played = 2 AND points = 3 AND goals_for = 20 AND goals_against = 1) THEN
    RAISE EXCEPTION 'Existing totals calculation changed';
  END IF;

  -- Ongoing/unplayed scores never enter the completed head-to-head table.
  INSERT INTO public.matches (season_id, league_id, round, home_team_id, away_team_id, home_goals, away_goals, status) VALUES
    (v_season, v_league, 10, v_a, v_b, 0, 100, 'live'),
    (v_season, v_league, 11, v_a, v_b, NULL, NULL, 'scheduled'),
    (v_season, v_league, 12, v_a, v_b, 0, 100, 'cancelled'),
    (v_season, v_league, 13, v_a, v_b, NULL, NULL, 'postponed'),
    (v_season, v_league, 14, v_a, v_b, NULL, NULL, 'unplayed');
  SELECT array_agg(s.team_id ORDER BY s.position) INTO v_actual
    FROM public.standings s WHERE s.season_id = v_season AND s.league_id = v_league;
  IF v_actual IS DISTINCT FROM ARRAY[v_c, v_a, v_b, v_d] THEN
    RAISE EXCEPTION 'Pending/live/cancelled matches influenced official positions';
  END IF;

  -- The helper is not an exposed RPC and cannot bypass public table policies.
  IF has_function_privilege('anon', 'public.rank_existing_standings(uuid,uuid)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.rank_existing_standings(uuid,uuid)', 'EXECUTE') THEN
    RAISE EXCEPTION 'Internal ranking helper is publicly callable';
  END IF;
  IF (SELECT prosecdef FROM pg_proc WHERE oid = 'public.rank_existing_standings(uuid,uuid)'::regprocedure) THEN
    RAISE EXCEPTION 'Read-only helper must not be SECURITY DEFINER';
  END IF;

  IF EXISTS (
    (SELECT row_data FROM h2h_before_standings EXCEPT SELECT to_jsonb(s) FROM public.standings s WHERE s.season_id <> v_season)
    UNION ALL
    (SELECT to_jsonb(s) FROM public.standings s WHERE s.season_id <> v_season EXCEPT SELECT row_data FROM h2h_before_standings)
  ) THEN RAISE EXCEPTION 'Existing standings changed during isolated tests'; END IF;
  IF EXISTS (
    (SELECT row_data FROM h2h_before_matches EXCEPT SELECT to_jsonb(m) FROM public.matches m WHERE m.season_id <> v_season)
    UNION ALL
    (SELECT to_jsonb(m) FROM public.matches m WHERE m.season_id <> v_season EXCEPT SELECT row_data FROM h2h_before_matches)
  ) THEN RAISE EXCEPTION 'Existing match records changed during isolated tests'; END IF;
END;
$$;
ROLLBACK;

-- Scenario 2: Three-team mini-table.
BEGIN;

CREATE TEMP TABLE h2h_before_standings ON COMMIT DROP AS
  SELECT to_jsonb(s) AS row_data FROM public.standings s;
CREATE TEMP TABLE h2h_before_matches ON COMMIT DROP AS
  SELECT to_jsonb(m) AS row_data FROM public.matches m;

DO $$
DECLARE
  v_season uuid := gen_random_uuid();
  v_league uuid := gen_random_uuid();
  v_a uuid := gen_random_uuid();
  v_b uuid := gen_random_uuid();
  v_c uuid := gen_random_uuid();
  v_d uuid := gen_random_uuid();
  v_tag text := gen_random_uuid()::text;
  v_year integer := 9000;
  v_actual uuid[];
  v_before jsonb;
  v_after jsonb;
BEGIN
  WHILE EXISTS (SELECT 1 FROM public.seasons WHERE year = v_year) LOOP
    v_year := v_year + 1;
  END LOOP;
  INSERT INTO public.seasons (id, year, name, status, is_current)
    VALUES (v_season, v_year, 'Head-to-head rollback regression ' || v_tag, 'planned', false);
  INSERT INTO public.leagues (id, code, name)
    VALUES (v_league, 'h2h-' || v_tag, 'Head-to-head rollback regression');
  INSERT INTO public.season_leagues (season_id, league_id)
    VALUES (v_season, v_league);
  INSERT INTO public.teams (id, name, abbreviation) VALUES
    (v_a, 'A h2h ' || v_tag, 'A-' || v_tag),
    (v_b, 'B h2h ' || v_tag, 'B-' || v_tag),
    (v_c, 'C h2h ' || v_tag, 'C-' || v_tag),
    (v_d, 'D h2h ' || v_tag, 'D-' || v_tag);
  INSERT INTO public.season_teams (season_id, league_id, team_id)
    SELECT v_season, v_league, team FROM unnest(ARRAY[v_a, v_b, v_c, v_d]) team;

  -- Three-team cycle: mini GD ties C/B; mini goals scored put C above B.
  INSERT INTO public.matches (season_id, league_id, round, home_team_id, away_team_id, home_goals, away_goals, status) VALUES
    (v_season, v_league, 1, v_a, v_b, 1, 0, 'completed'),
    (v_season, v_league, 2, v_b, v_c, 2, 0, 'completed'),
    (v_season, v_league, 3, v_c, v_a, 3, 0, 'completed');
  SELECT array_agg(s.team_id ORDER BY s.position) INTO v_actual
    FROM public.standings s WHERE s.season_id = v_season AND s.league_id = v_league;
  IF v_actual IS DISTINCT FROM ARRAY[v_c, v_b, v_a, v_d] THEN
    RAISE EXCEPTION 'Three-team mini-table ranking failed: %', v_actual;
  END IF;

  -- The helper is not an exposed RPC and cannot bypass public table policies.
  IF has_function_privilege('anon', 'public.rank_existing_standings(uuid,uuid)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.rank_existing_standings(uuid,uuid)', 'EXECUTE') THEN
    RAISE EXCEPTION 'Internal ranking helper is publicly callable';
  END IF;
  IF (SELECT prosecdef FROM pg_proc WHERE oid = 'public.rank_existing_standings(uuid,uuid)'::regprocedure) THEN
    RAISE EXCEPTION 'Read-only helper must not be SECURITY DEFINER';
  END IF;

  IF EXISTS (
    (SELECT row_data FROM h2h_before_standings EXCEPT SELECT to_jsonb(s) FROM public.standings s WHERE s.season_id <> v_season)
    UNION ALL
    (SELECT to_jsonb(s) FROM public.standings s WHERE s.season_id <> v_season EXCEPT SELECT row_data FROM h2h_before_standings)
  ) THEN RAISE EXCEPTION 'Existing standings changed during isolated tests'; END IF;
  IF EXISTS (
    (SELECT row_data FROM h2h_before_matches EXCEPT SELECT to_jsonb(m) FROM public.matches m WHERE m.season_id <> v_season)
    UNION ALL
    (SELECT to_jsonb(m) FROM public.matches m WHERE m.season_id <> v_season EXCEPT SELECT row_data FROM h2h_before_matches)
  ) THEN RAISE EXCEPTION 'Existing match records changed during isolated tests'; END IF;
END;
$$;
ROLLBACK;

-- Scenario 3: Home and away walkovers.
BEGIN;

CREATE TEMP TABLE h2h_before_standings ON COMMIT DROP AS
  SELECT to_jsonb(s) AS row_data FROM public.standings s;
CREATE TEMP TABLE h2h_before_matches ON COMMIT DROP AS
  SELECT to_jsonb(m) AS row_data FROM public.matches m;

DO $$
DECLARE
  v_season uuid := gen_random_uuid();
  v_league uuid := gen_random_uuid();
  v_a uuid := gen_random_uuid();
  v_b uuid := gen_random_uuid();
  v_c uuid := gen_random_uuid();
  v_d uuid := gen_random_uuid();
  v_tag text := gen_random_uuid()::text;
  v_year integer := 9000;
  v_actual uuid[];
  v_before jsonb;
  v_after jsonb;
BEGIN
  WHILE EXISTS (SELECT 1 FROM public.seasons WHERE year = v_year) LOOP
    v_year := v_year + 1;
  END LOOP;
  INSERT INTO public.seasons (id, year, name, status, is_current)
    VALUES (v_season, v_year, 'Head-to-head rollback regression ' || v_tag, 'planned', false);
  INSERT INTO public.leagues (id, code, name)
    VALUES (v_league, 'h2h-' || v_tag, 'Head-to-head rollback regression');
  INSERT INTO public.season_leagues (season_id, league_id)
    VALUES (v_season, v_league);
  INSERT INTO public.teams (id, name, abbreviation) VALUES
    (v_a, 'A h2h ' || v_tag, 'A-' || v_tag),
    (v_b, 'B h2h ' || v_tag, 'B-' || v_tag),
    (v_c, 'C h2h ' || v_tag, 'C-' || v_tag),
    (v_d, 'D h2h ' || v_tag, 'D-' || v_tag);
  INSERT INTO public.season_teams (season_id, league_id, team_id)
    SELECT v_season, v_league, team FROM unnest(ARRAY[v_a, v_b, v_c, v_d]) team;

  -- Walkovers use the season's awarded score in either home/away direction.
  UPDATE public.season_leagues SET walkover_goals_winner = 5, walkover_goals_loser = 1
    WHERE season_id = v_season AND league_id = v_league;
  INSERT INTO public.matches (season_id, league_id, round, home_team_id, away_team_id, home_goals, away_goals, status) VALUES
    (v_season, v_league, 1, v_a, v_b, 0, 3, 'walkover_away'),
    (v_season, v_league, 2, v_a, v_d, 20, 0, 'completed'),
    (v_season, v_league, 3, v_c, v_b, 1, 0, 'completed'),
    (v_season, v_league, 4, v_c, v_d, 1, 0, 'completed');
  SELECT array_agg(s.team_id ORDER BY s.position) INTO v_actual
    FROM public.standings s WHERE s.season_id = v_season AND s.league_id = v_league;
  IF v_actual IS DISTINCT FROM ARRAY[v_c, v_b, v_a, v_d] THEN
    RAISE EXCEPTION 'Away walkover ranking failed';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.standings WHERE season_id = v_season
    AND team_id = v_b AND goals_for = 5 AND goals_against = 2) THEN
    RAISE EXCEPTION 'Configured walkover score was not preserved';
  END IF;
  UPDATE public.matches SET home_team_id = v_b, away_team_id = v_a,
    home_goals = 3, away_goals = 0, status = 'walkover_home'
    WHERE season_id = v_season AND round = 1;
  SELECT array_agg(s.team_id ORDER BY s.position) INTO v_actual
    FROM public.standings s WHERE s.season_id = v_season AND s.league_id = v_league;
  IF v_actual IS DISTINCT FROM ARRAY[v_c, v_b, v_a, v_d] THEN
    RAISE EXCEPTION 'Home walkover ranking failed';
  END IF;

  -- The helper is not an exposed RPC and cannot bypass public table policies.
  IF has_function_privilege('anon', 'public.rank_existing_standings(uuid,uuid)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.rank_existing_standings(uuid,uuid)', 'EXECUTE') THEN
    RAISE EXCEPTION 'Internal ranking helper is publicly callable';
  END IF;
  IF (SELECT prosecdef FROM pg_proc WHERE oid = 'public.rank_existing_standings(uuid,uuid)'::regprocedure) THEN
    RAISE EXCEPTION 'Read-only helper must not be SECURITY DEFINER';
  END IF;

  IF EXISTS (
    (SELECT row_data FROM h2h_before_standings EXCEPT SELECT to_jsonb(s) FROM public.standings s WHERE s.season_id <> v_season)
    UNION ALL
    (SELECT to_jsonb(s) FROM public.standings s WHERE s.season_id <> v_season EXCEPT SELECT row_data FROM h2h_before_standings)
  ) THEN RAISE EXCEPTION 'Existing standings changed during isolated tests'; END IF;
  IF EXISTS (
    (SELECT row_data FROM h2h_before_matches EXCEPT SELECT to_jsonb(m) FROM public.matches m WHERE m.season_id <> v_season)
    UNION ALL
    (SELECT to_jsonb(m) FROM public.matches m WHERE m.season_id <> v_season EXCEPT SELECT row_data FROM h2h_before_matches)
  ) THEN RAISE EXCEPTION 'Existing match records changed during isolated tests'; END IF;
END;
$$;
ROLLBACK;

-- Scenario 4: Withdrawn team and position-only repair.
BEGIN;

CREATE TEMP TABLE h2h_before_standings ON COMMIT DROP AS
  SELECT to_jsonb(s) AS row_data FROM public.standings s;
CREATE TEMP TABLE h2h_before_matches ON COMMIT DROP AS
  SELECT to_jsonb(m) AS row_data FROM public.matches m;

DO $$
DECLARE
  v_season uuid := gen_random_uuid();
  v_league uuid := gen_random_uuid();
  v_a uuid := gen_random_uuid();
  v_b uuid := gen_random_uuid();
  v_c uuid := gen_random_uuid();
  v_d uuid := gen_random_uuid();
  v_tag text := gen_random_uuid()::text;
  v_year integer := 9000;
  v_actual uuid[];
  v_before jsonb;
  v_after jsonb;
BEGIN
  WHILE EXISTS (SELECT 1 FROM public.seasons WHERE year = v_year) LOOP
    v_year := v_year + 1;
  END LOOP;
  INSERT INTO public.seasons (id, year, name, status, is_current)
    VALUES (v_season, v_year, 'Head-to-head rollback regression ' || v_tag, 'planned', false);
  INSERT INTO public.leagues (id, code, name)
    VALUES (v_league, 'h2h-' || v_tag, 'Head-to-head rollback regression');
  INSERT INTO public.season_leagues (season_id, league_id)
    VALUES (v_season, v_league);
  INSERT INTO public.teams (id, name, abbreviation) VALUES
    (v_a, 'A h2h ' || v_tag, 'A-' || v_tag),
    (v_b, 'B h2h ' || v_tag, 'B-' || v_tag),
    (v_c, 'C h2h ' || v_tag, 'C-' || v_tag),
    (v_d, 'D h2h ' || v_tag, 'D-' || v_tag);
  INSERT INTO public.season_teams (season_id, league_id, team_id)
    SELECT v_season, v_league, team FROM unnest(ARRAY[v_a, v_b, v_c, v_d]) team;

  -- Withdrawn C has equal stored points, but must not influence A/B's mini-table.
  INSERT INTO public.matches (season_id, league_id, round, home_team_id, away_team_id, home_goals, away_goals, status) VALUES
    (v_season, v_league, 1, v_a, v_b, 1, 0, 'completed'),
    (v_season, v_league, 2, v_b, v_c, 5, 0, 'completed'),
    (v_season, v_league, 3, v_c, v_a, 5, 0, 'completed');
  UPDATE public.season_teams SET left_round = 4 WHERE season_id = v_season AND team_id = v_c;
  UPDATE public.standings SET points = 10, form_last5 = '[{"result":"W"}]'::jsonb,
    streak_unbeaten = 7, streak_wins = 2, streak_winless = 1
    WHERE season_id = v_season AND team_id IN (v_a, v_b, v_c);
  SELECT jsonb_agg(to_jsonb(s) - 'position' ORDER BY s.team_id) INTO v_before
    FROM public.standings s WHERE s.season_id = v_season;
  UPDATE public.standings s SET position = r.position
    FROM public.rank_existing_standings(v_season, v_league) r
    WHERE s.season_id = v_season AND s.league_id = v_league AND s.team_id = r.team_id;
  SELECT array_agg(s.team_id ORDER BY s.position) INTO v_actual
    FROM public.standings s WHERE s.season_id = v_season AND s.league_id = v_league;
  IF v_actual IS DISTINCT FROM ARRAY[v_a, v_b, v_d, v_c] THEN
    RAISE EXCEPTION 'Withdrawn team polluted active mini-table: %', v_actual;
  END IF;
  SELECT jsonb_agg(to_jsonb(s) - 'position' ORDER BY s.team_id) INTO v_after
    FROM public.standings s WHERE s.season_id = v_season;
  IF v_before IS DISTINCT FROM v_after THEN
    RAISE EXCEPTION 'Position-only repair altered stored totals/form/row metadata';
  END IF;

  -- The helper is not an exposed RPC and cannot bypass public table policies.
  IF has_function_privilege('anon', 'public.rank_existing_standings(uuid,uuid)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.rank_existing_standings(uuid,uuid)', 'EXECUTE') THEN
    RAISE EXCEPTION 'Internal ranking helper is publicly callable';
  END IF;
  IF (SELECT prosecdef FROM pg_proc WHERE oid = 'public.rank_existing_standings(uuid,uuid)'::regprocedure) THEN
    RAISE EXCEPTION 'Read-only helper must not be SECURITY DEFINER';
  END IF;

  IF EXISTS (
    (SELECT row_data FROM h2h_before_standings EXCEPT SELECT to_jsonb(s) FROM public.standings s WHERE s.season_id <> v_season)
    UNION ALL
    (SELECT to_jsonb(s) FROM public.standings s WHERE s.season_id <> v_season EXCEPT SELECT row_data FROM h2h_before_standings)
  ) THEN RAISE EXCEPTION 'Existing standings changed during isolated tests'; END IF;
  IF EXISTS (
    (SELECT row_data FROM h2h_before_matches EXCEPT SELECT to_jsonb(m) FROM public.matches m WHERE m.season_id <> v_season)
    UNION ALL
    (SELECT to_jsonb(m) FROM public.matches m WHERE m.season_id <> v_season EXCEPT SELECT row_data FROM h2h_before_matches)
  ) THEN RAISE EXCEPTION 'Existing match records changed during isolated tests'; END IF;
END;
$$;
ROLLBACK;

-- Scenario 5: No direct games fallback.
BEGIN;

CREATE TEMP TABLE h2h_before_standings ON COMMIT DROP AS
  SELECT to_jsonb(s) AS row_data FROM public.standings s;
CREATE TEMP TABLE h2h_before_matches ON COMMIT DROP AS
  SELECT to_jsonb(m) AS row_data FROM public.matches m;

DO $$
DECLARE
  v_season uuid := gen_random_uuid();
  v_league uuid := gen_random_uuid();
  v_a uuid := gen_random_uuid();
  v_b uuid := gen_random_uuid();
  v_c uuid := gen_random_uuid();
  v_d uuid := gen_random_uuid();
  v_tag text := gen_random_uuid()::text;
  v_year integer := 9000;
  v_actual uuid[];
  v_before jsonb;
  v_after jsonb;
BEGIN
  WHILE EXISTS (SELECT 1 FROM public.seasons WHERE year = v_year) LOOP
    v_year := v_year + 1;
  END LOOP;
  INSERT INTO public.seasons (id, year, name, status, is_current)
    VALUES (v_season, v_year, 'Head-to-head rollback regression ' || v_tag, 'planned', false);
  INSERT INTO public.leagues (id, code, name)
    VALUES (v_league, 'h2h-' || v_tag, 'Head-to-head rollback regression');
  INSERT INTO public.season_leagues (season_id, league_id)
    VALUES (v_season, v_league);
  INSERT INTO public.teams (id, name, abbreviation) VALUES
    (v_a, 'A h2h ' || v_tag, 'A-' || v_tag),
    (v_b, 'B h2h ' || v_tag, 'B-' || v_tag),
    (v_c, 'C h2h ' || v_tag, 'C-' || v_tag),
    (v_d, 'D h2h ' || v_tag, 'D-' || v_tag);
  INSERT INTO public.season_teams (season_id, league_id, team_id)
    SELECT v_season, v_league, team FROM unnest(ARRAY[v_a, v_b, v_c, v_d]) team;

  INSERT INTO public.standings (season_id, league_id, team_id)
    SELECT v_season, v_league, team FROM unnest(ARRAY[v_a, v_b, v_c, v_d]) team;
  UPDATE public.season_teams SET left_round = 4 WHERE season_id = v_season AND team_id = v_c;
  -- No direct games: fallback remains overall GD, then GF, then stable name/id.
  UPDATE public.standings SET points = 10, goals_for = CASE WHEN team_id = v_b THEN 8 ELSE 3 END,
    goals_against = 1 WHERE season_id = v_season AND team_id IN (v_a, v_b);
  SELECT array_agg(r.team_id ORDER BY r.position) INTO v_actual
    FROM public.rank_existing_standings(v_season, v_league) r;
  IF v_actual IS DISTINCT FROM ARRAY[v_b, v_a, v_d, v_c] THEN
    RAISE EXCEPTION 'No-direct-game fallback failed';
  END IF;

  -- The helper is not an exposed RPC and cannot bypass public table policies.
  IF has_function_privilege('anon', 'public.rank_existing_standings(uuid,uuid)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.rank_existing_standings(uuid,uuid)', 'EXECUTE') THEN
    RAISE EXCEPTION 'Internal ranking helper is publicly callable';
  END IF;
  IF (SELECT prosecdef FROM pg_proc WHERE oid = 'public.rank_existing_standings(uuid,uuid)'::regprocedure) THEN
    RAISE EXCEPTION 'Read-only helper must not be SECURITY DEFINER';
  END IF;

  IF EXISTS (
    (SELECT row_data FROM h2h_before_standings EXCEPT SELECT to_jsonb(s) FROM public.standings s WHERE s.season_id <> v_season)
    UNION ALL
    (SELECT to_jsonb(s) FROM public.standings s WHERE s.season_id <> v_season EXCEPT SELECT row_data FROM h2h_before_standings)
  ) THEN RAISE EXCEPTION 'Existing standings changed during isolated tests'; END IF;
  IF EXISTS (
    (SELECT row_data FROM h2h_before_matches EXCEPT SELECT to_jsonb(m) FROM public.matches m WHERE m.season_id <> v_season)
    UNION ALL
    (SELECT to_jsonb(m) FROM public.matches m WHERE m.season_id <> v_season EXCEPT SELECT row_data FROM h2h_before_matches)
  ) THEN RAISE EXCEPTION 'Existing match records changed during isolated tests'; END IF;
END;
$$;
ROLLBACK;

SELECT 'PASS: pair, three-team mini-table, match status filtering, both walkovers, withdrawals, stored totals, fallback, permissions and unchanged real data' AS result;
