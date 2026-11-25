-- Run as the maintenance connection after the tournament validation migrations.
-- No credentials or profile identifiers are printed. The selected administrator
-- is temporarily demoted only inside subtransactions that deliberately roll
-- back; no other session can observe those changes. The outer transaction also
-- rolls back the synthetic document, its history and every session setting.
-- Execute the complete file. On any assertion failure, ROLLBACK the connection.
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET LOCAL statement_timeout = '30s';
SET LOCAL lock_timeout = '5s';

DO $test$
DECLARE
  v_slug constant text := 'mlpn-security-test-20261125';
  v_admin uuid;
  v_original_profile jsonb;
  v_document jsonb;
  v_live jsonb;
  v_invalid jsonb;
  v_saved public.tournament_documents%ROWTYPE;
  v_documents_before jsonb;
  v_history_before jsonb;
  v_documents_after jsonb;
  v_history_after jsonb;
  v_document_count bigint;
  v_history_count bigint;
  v_count bigint;
  v_changed bigint;
  v_profile_mode text;
  v_bad_score jsonb;
  v_invalid_case jsonb;
  v_cases jsonb;
  v_previous public.tournament_documents%ROWTYPE;
  v_verified_documents integer := 0;
  v_table text;
  v_counts_before jsonb := '{}'::jsonb;
BEGIN
  SELECT id, to_jsonb(p) INTO v_admin, v_original_profile
    FROM public.profiles p WHERE p.role = 'admin' AND p.account_status = 'active'
    ORDER BY id LIMIT 1;
  IF v_admin IS NULL THEN RAISE EXCEPTION 'Test requires an existing active administrator.'; END IF;
  IF EXISTS (SELECT 1 FROM public.tournament_documents WHERE slug = v_slug)
    OR EXISTS (SELECT 1 FROM public.tournament_document_history WHERE slug = v_slug) THEN
    RAISE EXCEPTION 'Reserved test slug already exists; no data was changed.';
  END IF;

  SELECT count(*), coalesce(jsonb_agg(to_jsonb(d) ORDER BY slug), '[]'::jsonb)
    INTO v_document_count, v_documents_before FROM public.tournament_documents d;
  SELECT count(*), coalesce(jsonb_agg(to_jsonb(h) ORDER BY slug, revision), '[]'::jsonb)
    INTO v_history_count, v_history_before FROM public.tournament_document_history h;
  FOREACH v_table IN ARRAY ARRAY['profiles', 'matches', 'tournaments', 'tournament_teams', 'tournament_matches', 'tournament_group_standings'] LOOP
    IF to_regclass('public.' || v_table) IS NOT NULL THEN
      EXECUTE format('SELECT count(*) FROM public.%I', v_table) INTO v_count;
      v_counts_before := v_counts_before || jsonb_build_object(v_table, v_count);
    END IF;
  END LOOP;
  v_document := jsonb_build_object(
    'id', 'security-test-20261125', 'slug', v_slug, 'name', 'Test zapisu turnieju',
    'date', '2026-12-20', 'status', 'upcoming', 'location', 'Halinów',
    'rules', jsonb_build_object('pointsWin', 3, 'pointsDraw', 1, 'pointsLoss', 0),
    'teams', jsonb_build_array(
      jsonb_build_object('id', 'test-a', 'name', 'Drużyna A', 'logo', '', 'players', jsonb_build_array(jsonb_build_object('id', 'test-player-a', 'name', 'Zawodnik A'))),
      jsonb_build_object('id', 'test-b', 'name', 'Drużyna B', 'logo', '', 'players', jsonb_build_array(jsonb_build_object('id', 'test-player-b', 'name', 'Zawodnik B')))
    ),
    'groups', jsonb_build_array(jsonb_build_object('id', 'test-group', 'name', 'Grupa A', 'phase', 0, 'teamIds', jsonb_build_array('test-a', 'test-b'))),
    'matches', jsonb_build_array(jsonb_build_object(
      'id', 'test-match', 'stage', 'group', 'groupId', 'test-group', 'status', 'scheduled',
      'homeTeamId', 'test-a', 'awayTeamId', 'test-b', 'homeScore', NULL, 'awayScore', NULL,
      'homePenalties', NULL, 'awayPenalties', NULL, 'events', '[]'::jsonb
    ))
  );

  -- Anonymous readers can see public documents, never history or write APIs.
  PERFORM set_config('request.jwt.claim.sub', '', true);
  PERFORM set_config('request.jwt.claim.role', 'anon', true);
  PERFORM set_config('request.jwt.claims', '{"role":"anon","user_metadata":{"role":"admin"}}', true);
  EXECUTE 'SET LOCAL ROLE anon';
  SELECT count(*) INTO v_count FROM public.tournament_documents;
  IF v_count <> v_document_count THEN RAISE EXCEPTION 'Anonymous document reads are unavailable.'; END IF;
  BEGIN
    PERFORM public.save_tournament_document(v_document, 0);
    RAISE EXCEPTION 'Anonymous RPC write unexpectedly succeeded.';
  EXCEPTION WHEN SQLSTATE '42501' THEN NULL;
  END;
  BEGIN
    INSERT INTO public.tournament_documents(slug, document) VALUES(v_slug, v_document);
    RAISE EXCEPTION 'Anonymous direct insert unexpectedly succeeded.';
  EXCEPTION WHEN SQLSTATE '42501' THEN NULL;
  END;
  BEGIN
    PERFORM 1 FROM public.tournament_document_history LIMIT 1;
    RAISE EXCEPTION 'Anonymous history access unexpectedly succeeded.';
  EXCEPTION WHEN SQLSTATE '42501' THEN NULL;
  END;
  EXECUTE 'RESET ROLE';

  -- One real active administrator creates the disposable document atomically.
  PERFORM set_config('request.jwt.claim.sub', v_admin::text, true);
  PERFORM set_config('request.jwt.claim.role', 'authenticated', true);
  PERFORM set_config('request.jwt.claims', jsonb_build_object('sub', v_admin, 'role', 'authenticated')::text, true);
  EXECUTE 'SET LOCAL ROLE authenticated';
  SELECT * INTO STRICT v_saved FROM public.save_tournament_document(v_document, 0);
  IF v_saved.slug <> v_slug OR v_saved.document <> v_document OR v_saved.revision <> 1 THEN
    RAISE EXCEPTION 'Initial save returned an incorrect receipt.';
  END IF;
  SELECT count(*) INTO v_count FROM public.tournament_document_history
    WHERE slug = v_slug AND revision = 1 AND document = v_document AND saved_by = v_admin;
  IF v_count <> 1 THEN RAISE EXCEPTION 'Initial save did not preserve its attributed history.'; END IF;
  EXECUTE 'RESET ROLE';

  -- Role decisions come from the active profile, not either JWT metadata map.
  -- The sentinel exception restores every profile field and temporary role.
  FOREACH v_profile_mode IN ARRAY ARRAY['viewer', 'editor', 'suspended', 'banned'] LOOP
    BEGIN
      UPDATE public.profiles SET
        role = CASE WHEN v_profile_mode IN ('viewer', 'editor') THEN v_profile_mode ELSE 'admin' END,
        account_status = CASE WHEN v_profile_mode IN ('suspended', 'banned') THEN v_profile_mode ELSE 'active' END
        WHERE id = v_admin;
      PERFORM set_config('request.jwt.claim.sub', v_admin::text, true);
      PERFORM set_config('request.jwt.claim.role', 'authenticated', true);
      PERFORM set_config('request.jwt.claims', jsonb_build_object(
        'sub', v_admin, 'role', 'authenticated',
        'user_metadata', jsonb_build_object('role', 'admin', 'account_status', 'active'),
        'app_metadata', jsonb_build_object('role', 'admin', 'account_status', 'active')
      )::text, true);
      EXECUTE 'SET LOCAL ROLE authenticated';
      IF public.is_admin() THEN RAISE EXCEPTION 'Metadata incorrectly granted administrator access.'; END IF;
      BEGIN
        PERFORM public.save_tournament_document(v_document, 1);
        RAISE EXCEPTION 'Non-admin RPC write unexpectedly succeeded for %.', v_profile_mode;
      EXCEPTION WHEN SQLSTATE '42501' THEN NULL;
      END;
      BEGIN
        INSERT INTO public.tournament_documents(slug, document)
          VALUES(v_slug || '-blocked', jsonb_set(v_document, '{slug}', to_jsonb(v_slug || '-blocked')));
        RAISE EXCEPTION 'Non-admin direct insert unexpectedly succeeded for %.', v_profile_mode;
      EXCEPTION WHEN SQLSTATE '42501' THEN NULL;
      END;
      UPDATE public.tournament_documents SET document = v_document, revision = revision + 1 WHERE slug = v_slug;
      GET DIAGNOSTICS v_changed = ROW_COUNT;
      IF v_changed <> 0 THEN RAISE EXCEPTION 'Non-admin direct update bypassed row security.'; END IF;
      SELECT count(*) INTO v_count FROM public.tournament_document_history WHERE slug = v_slug;
      IF v_count <> 0 THEN RAISE EXCEPTION 'Non-admin history rows became visible.'; END IF;
      BEGIN
        DELETE FROM public.tournament_documents WHERE slug = v_slug;
        RAISE EXCEPTION 'Non-admin direct delete unexpectedly succeeded.';
      EXCEPTION WHEN SQLSTATE '42501' THEN NULL;
      END;
      EXECUTE 'RESET ROLE';
      RAISE EXCEPTION 'Restore role fixture' USING ERRCODE = 'ZT001';
    EXCEPTION WHEN SQLSTATE 'ZT001' THEN NULL;
    END;
  END LOOP;
  IF (SELECT to_jsonb(p) FROM public.profiles p WHERE id = v_admin) <> v_original_profile THEN
    RAISE EXCEPTION 'Profile fixture was not restored completely.';
  END IF;

  -- An authorized revision is visible immediately; stale revisions never win.
  PERFORM set_config('request.jwt.claim.sub', v_admin::text, true);
  PERFORM set_config('request.jwt.claim.role', 'authenticated', true);
  PERFORM set_config('request.jwt.claims', jsonb_build_object('sub', v_admin, 'role', 'authenticated')::text, true);
  EXECUTE 'SET LOCAL ROLE authenticated';
  v_live := jsonb_set(jsonb_set(jsonb_set(jsonb_set(v_document,
    '{status}', '"live"'), '{matches,0,status}', '"live"'), '{matches,0,homeScore}', '1'), '{matches,0,awayScore}', '0');
  v_live := jsonb_set(v_live, '{matches,0,events}', jsonb_build_array(jsonb_build_object(
    'id', 'test-goal', 'type', 'goal', 'teamId', 'test-a', 'playerId', 'test-player-a', 'minute', 2
  )));
  SELECT * INTO STRICT v_saved FROM public.save_tournament_document(v_live, 1);
  IF v_saved.document <> v_live OR v_saved.revision <> 2 THEN RAISE EXCEPTION 'Live save returned an incorrect receipt.'; END IF;
  BEGIN
    PERFORM public.save_tournament_document(v_document, 1);
    RAISE EXCEPTION 'Stale expected revision overwrote a newer save.';
  EXCEPTION WHEN SQLSTATE '40001' THEN NULL;
  END;
  BEGIN
    PERFORM public.save_tournament_document(v_document, -1);
    RAISE EXCEPTION 'Negative expected revision was accepted.';
  EXCEPTION WHEN SQLSTATE '22023' THEN NULL;
  END;
  FOR v_bad_score IN SELECT value FROM jsonb_array_elements('[-1, 1.5, "2"]'::jsonb) LOOP
    v_invalid := jsonb_set(v_live, '{matches,0,homeScore}', v_bad_score);
    BEGIN
      PERFORM public.save_tournament_document(v_invalid, 2);
      RAISE EXCEPTION 'Invalid score was accepted.';
    EXCEPTION WHEN SQLSTATE '22023' THEN NULL;
    END;
  END LOOP;

  -- These cases bypass JavaScript deliberately. The database must reject each
  -- before it can poison a public document or create a new history revision.
  v_cases := jsonb_build_array(
    jsonb_build_object('case', 'scheduled score and events', 'document', jsonb_set(v_live, '{matches,0,status}', '"scheduled"')),
    jsonb_build_object('case', 'more goal events than the score', 'document', jsonb_set(v_live, '{matches,0,homeScore}', '0')),
    jsonb_build_object('case', 'more assists than the score', 'document', jsonb_set(jsonb_set(v_live, '{matches,0,homeScore}', '0'), '{matches,0,events,0,type}', '"assist"')),
    jsonb_build_object('case', 'unknown group', 'document', jsonb_set(v_live, '{matches,0,groupId}', '"unknown-group"')),
    jsonb_build_object('case', 'unknown team', 'document', jsonb_set(v_live, '{matches,0,homeTeamId}', '"unknown-team"')),
    jsonb_build_object('case', 'team outside the referenced group', 'document', jsonb_set(v_live, '{groups,0,teamIds}', '["test-a"]')),
    jsonb_build_object('case', 'unknown source match', 'document', jsonb_set(v_live, '{matches,0,homeSource}', '{"type":"winner","matchId":"unknown-match"}')),
    jsonb_build_object('case', 'unknown source group', 'document', jsonb_set(v_live, '{matches,0,homeSource}', '{"type":"group","groupId":"unknown-group","position":1}')),
    jsonb_build_object('case', 'source group position outside its table', 'document', jsonb_set(v_live, '{matches,0,homeSource}', '{"type":"group","groupId":"test-group","position":3}')),
    jsonb_build_object('case', 'self-referencing advancement', 'document', jsonb_set(v_live, '{matches,0,homeSource}', '{"type":"winner","matchId":"test-match"}')),
    jsonb_build_object('case', 'two-match advancement cycle', 'document', jsonb_set(v_live, '{matches}', jsonb_build_array(
      jsonb_set(v_live#>'{matches,0}', '{homeSource}', '{"type":"winner","matchId":"test-match-two"}'),
      jsonb_set(jsonb_set(v_live#>'{matches,0}', '{id}', '"test-match-two"'), '{homeSource}', '{"type":"winner","matchId":"test-match"}')
    ))),
    jsonb_build_object('case', 'undecided knockout draw', 'document', jsonb_set(jsonb_set(jsonb_set(jsonb_set(v_live,
      '{matches,0,stage}', '"final"'), '{matches,0,groupId}', 'null'), '{matches,0,status}', '"finished"'), '{matches,0,awayScore}', '1')),
    jsonb_build_object('case', 'penalties in a group match', 'document', jsonb_set(jsonb_set(jsonb_set(v_live,
      '{matches,0,status}', '"finished"'), '{matches,0,homePenalties}', '3'), '{matches,0,awayPenalties}', '2')),
    jsonb_build_object('case', 'duplicate event identifiers', 'document', jsonb_set(jsonb_set(v_live,
      '{matches,0,homeScore}', '2'), '{matches,0,events}', jsonb_build_array(v_live#>'{matches,0,events,0}', v_live#>'{matches,0,events,0}'))),
    jsonb_build_object('case', 'empty event identifier', 'document', jsonb_set(v_live, '{matches,0,events,0,id}', '""')),
    jsonb_build_object('case', 'negative event minute', 'document', jsonb_set(v_live, '{matches,0,events,0,minute}', '-1')),
    jsonb_build_object('case', 'fractional event minute', 'document', jsonb_set(v_live, '{matches,0,events,0,minute}', '1.5')),
    jsonb_build_object('case', 'string event minute', 'document', jsonb_set(v_live, '{matches,0,events,0,minute}', '"2"')),
    jsonb_build_object('case', 'event player from the other team', 'document', jsonb_set(v_live, '{matches,0,events,0,playerId}', '"test-player-b"'))
  );
  FOR v_invalid_case IN SELECT value FROM jsonb_array_elements(v_cases) LOOP
    BEGIN
      PERFORM public.save_tournament_document(v_invalid_case->'document', 2);
      RAISE EXCEPTION 'Database accepted inconsistent data: %.', v_invalid_case->>'case';
    EXCEPTION WHEN SQLSTATE '22023' THEN NULL;
    END;
  END LOOP;
  SELECT * INTO STRICT v_saved FROM public.tournament_documents WHERE slug = v_slug;
  IF v_saved.document <> v_live OR v_saved.revision <> 2 THEN RAISE EXCEPTION 'A rejected write changed the saved document.'; END IF;
  SELECT count(*) INTO v_count FROM public.tournament_document_history WHERE slug = v_slug;
  IF v_count <> 2 THEN RAISE EXCEPTION 'Rejected writes added unexpected history revisions.'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.tournament_document_history WHERE slug = v_slug AND revision = 1 AND document = v_document)
     OR NOT EXISTS (SELECT 1 FROM public.tournament_document_history WHERE slug = v_slug AND revision = 2 AND document = v_live AND saved_by = v_admin) THEN
    RAISE EXCEPTION 'Revision history was overwritten or is incomplete.';
  END IF;

  -- Even an active administrator cannot forge, edit or erase history directly.
  BEGIN
    INSERT INTO public.tournament_document_history(slug, revision, document) VALUES(v_slug, 99, v_document);
    RAISE EXCEPTION 'Administrator forged a history revision.';
  EXCEPTION WHEN SQLSTATE '42501' THEN NULL;
  END;
  BEGIN
    UPDATE public.tournament_document_history SET document = v_live WHERE slug = v_slug AND revision = 1;
    RAISE EXCEPTION 'Administrator edited a history revision.';
  EXCEPTION WHEN SQLSTATE '42501' THEN NULL;
  END;
  BEGIN
    DELETE FROM public.tournament_document_history WHERE slug = v_slug;
    RAISE EXCEPTION 'Administrator deleted history.';
  EXCEPTION WHEN SQLSTATE '42501' THEN NULL;
  END;
  BEGIN
    DELETE FROM public.tournament_documents WHERE slug = v_slug;
    RAISE EXCEPTION 'Administrator deleted a document outside the save API.';
  EXCEPTION WHEN SQLSTATE '42501' THEN NULL;
  END;
  EXECUTE 'RESET ROLE';

  PERFORM set_config('request.jwt.claim.sub', '', true);
  PERFORM set_config('request.jwt.claim.role', 'anon', true);
  PERFORM set_config('request.jwt.claims', '{"role":"anon"}', true);
  EXECUTE 'SET LOCAL ROLE anon';
  SELECT * INTO STRICT v_saved FROM public.tournament_documents WHERE slug = v_slug;
  IF v_saved.document <> v_live OR v_saved.revision <> 2 THEN RAISE EXCEPTION 'Public readers did not see the confirmed latest revision.'; END IF;
  EXECUTE 'RESET ROLE';

  -- Every existing real tournament must still pass the tightened validator.
  -- Roll back this fixture before checking that all original rows are intact.
  BEGIN
    PERFORM set_config('request.jwt.claim.sub', v_admin::text, true);
    PERFORM set_config('request.jwt.claim.role', 'authenticated', true);
    PERFORM set_config('request.jwt.claims', jsonb_build_object('sub', v_admin, 'role', 'authenticated')::text, true);
    EXECUTE 'SET LOCAL ROLE authenticated';
    FOR v_previous IN SELECT * FROM public.tournament_documents WHERE slug <> v_slug ORDER BY slug LOOP
      SELECT * INTO STRICT v_saved FROM public.save_tournament_document(v_previous.document, v_previous.revision);
      IF v_saved.document <> v_previous.document OR v_saved.revision <> v_previous.revision + 1 THEN
        RAISE EXCEPTION 'A real tournament failed its unchanged-document save.';
      END IF;
      v_verified_documents := v_verified_documents + 1;
    END LOOP;
    EXECUTE 'RESET ROLE';
    RAISE EXCEPTION 'Restore existing document fixture' USING ERRCODE = 'ZT002';
  EXCEPTION WHEN SQLSTATE 'ZT002' THEN NULL;
  END;
  IF v_verified_documents <> v_document_count THEN RAISE EXCEPTION 'Not every existing document was verified.'; END IF;

  -- Verify untouched documents/history as well as league and profile row counts.
  SELECT coalesce(jsonb_agg(to_jsonb(d) ORDER BY slug), '[]'::jsonb) INTO v_documents_after
    FROM public.tournament_documents d WHERE slug <> v_slug;
  SELECT coalesce(jsonb_agg(to_jsonb(h) ORDER BY slug, revision), '[]'::jsonb) INTO v_history_after
    FROM public.tournament_document_history h WHERE slug <> v_slug;
  IF v_documents_after <> v_documents_before OR v_history_after <> v_history_before THEN
    RAISE EXCEPTION 'The test changed pre-existing tournament data.';
  END IF;
  IF (SELECT count(*) FROM public.tournament_documents) <> v_document_count + 1
    OR (SELECT count(*) FROM public.tournament_document_history) <> v_history_count + 2 THEN
    RAISE EXCEPTION 'Unexpected tournament or history row count.';
  END IF;
  FOR v_table IN SELECT jsonb_object_keys(v_counts_before) LOOP
    EXECUTE format('SELECT count(*) FROM public.%I', v_table) INTO v_count;
    IF v_count <> (v_counts_before->>v_table)::bigint THEN RAISE EXCEPTION 'Unrelated row count changed: %.', v_table; END IF;
  END LOOP;
  RAISE NOTICE 'Tournament management checks passed; all test writes will now roll back.';
END;
$test$;

ROLLBACK;
