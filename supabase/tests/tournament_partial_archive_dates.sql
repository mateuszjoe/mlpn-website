-- Run the complete file as the maintenance connection after the date migration.
-- All synthetic documents and history entries roll back; existing rows are read only.
BEGIN;
SET LOCAL statement_timeout = '30s';
SET LOCAL lock_timeout = '5s';

DO $test$
DECLARE
  v_slug constant text := 'mlpn-partial-archive-date-test-20261125';
  v_document jsonb;
  v_changed jsonb;
  v_patch jsonb;
  v_year integer;
  v_count integer;
  v_revision integer;
BEGIN
  IF EXISTS (SELECT 1 FROM public.tournament_documents WHERE slug = v_slug)
    OR EXISTS (SELECT 1 FROM public.tournament_document_history WHERE slug = v_slug) THEN
    RAISE EXCEPTION 'Reserved test slug already exists; nothing was changed.';
  END IF;
  PERFORM set_config('request.jwt.claim.sub', '', true);
  PERFORM set_config('request.jwt.claims', '{}', true);
  v_document := jsonb_build_object(
    'id', 'partial-archive-date-test-20261125', 'slug', v_slug,
    'name', 'Test niepełnego archiwum', 'date', NULL, 'year', 2023,
    'isPartialArchive', true, 'status', 'archived',
    'rules', jsonb_build_object('pointsWin', 3, 'pointsDraw', 1, 'pointsLoss', 0),
    'teams', '[]'::jsonb, 'groups', '[]'::jsonb, 'matches', '[]'::jsonb
  );
  INSERT INTO public.tournament_documents(slug, document) VALUES(v_slug, v_document);
  IF NOT EXISTS(SELECT 1 FROM public.tournament_documents
    WHERE slug = v_slug AND document->'date' = 'null'::jsonb AND document->'year' = '2023'::jsonb AND revision = 1) THEN
    RAISE EXCEPTION 'The partial archive lost its unknown date or original year.';
  END IF;

  v_changed := v_document || jsonb_build_object('description', 'Potwierdzona klasyfikacja końcowa.');
  UPDATE public.tournament_documents SET document = v_changed, revision = revision + 1
    WHERE slug = v_slug AND revision = 1;
  GET DIAGNOSTICS v_count = ROW_COUNT;
  IF v_count <> 1 THEN RAISE EXCEPTION 'Compare-and-swap update did not save exactly one document.'; END IF;
  IF NOT EXISTS(SELECT 1 FROM public.tournament_document_history
    WHERE slug = v_slug AND revision = 1 AND document = v_document)
    OR NOT EXISTS(SELECT 1 FROM public.tournament_document_history
    WHERE slug = v_slug AND revision = 2 AND document = v_changed) THEN
    RAISE EXCEPTION 'Partial archive history was not preserved.';
  END IF;
  UPDATE public.tournament_documents SET document = v_document, revision = revision + 1
    WHERE slug = v_slug AND revision = 1;
  GET DIAGNOSTICS v_count = ROW_COUNT;
  IF v_count <> 0 THEN RAISE EXCEPTION 'A stale revision overwrote the archive.'; END IF;

  FOR v_patch IN SELECT value FROM jsonb_array_elements('[
    {"isPartialArchive":false}, {"isPartialArchive":"true"}, {"isPartialArchive":null},
    {"status":"upcoming"}, {"status":"live"}, {"status":"finished"},
    {"year":null}, {"year":"2023"}, {"year":2023.5}, {"year":1899}, {"year":2101},
    {"date":""}, {"date":"2023"}, {"date":"2023-02-30"}
  ]'::jsonb) LOOP
    BEGIN
      UPDATE public.tournament_documents SET document = v_changed || v_patch, revision = revision + 1
        WHERE slug = v_slug AND revision = 2;
      RAISE EXCEPTION 'Invalid date exception was accepted: %', v_patch;
    EXCEPTION WHEN SQLSTATE '22023' OR SQLSTATE '22008' THEN NULL;
    END;
  END LOOP;
  BEGIN
    UPDATE public.tournament_documents SET document = v_changed - 'date', revision = revision + 1
      WHERE slug = v_slug AND revision = 2;
    RAISE EXCEPTION 'Missing date key was silently treated as a verified unknown date.';
  EXCEPTION WHEN SQLSTATE '22023' THEN NULL;
  END;
  BEGIN
    UPDATE public.tournament_documents SET document = v_changed - 'year', revision = revision + 1
      WHERE slug = v_slug AND revision = 2;
    RAISE EXCEPTION 'Partial archive without a year was accepted.';
  EXCEPTION WHEN SQLSTATE '22023' THEN NULL;
  END;

  FOREACH v_year IN ARRAY ARRAY[1900, 2100] LOOP
    BEGIN
      UPDATE public.tournament_documents SET document = v_changed || jsonb_build_object('year', v_year, 'status', 'completed'), revision = revision + 1
        WHERE slug = v_slug AND revision = 2;
      SELECT revision INTO STRICT v_revision FROM public.tournament_documents WHERE slug = v_slug;
      IF v_revision <> 3 THEN RAISE EXCEPTION 'A valid historical year boundary was rejected.'; END IF;
      RAISE EXCEPTION 'Restore valid year fixture' USING ERRCODE = 'ZT001';
    EXCEPTION WHEN SQLSTATE 'ZT001' THEN NULL;
    END;
  END LOOP;
  BEGIN
    UPDATE public.tournament_documents SET document = (v_changed - 'year' - 'isPartialArchive')
      || jsonb_build_object('date', '2026-12-20', 'status', 'upcoming'), revision = revision + 1
      WHERE slug = v_slug AND revision = 2;
    SELECT revision INTO STRICT v_revision FROM public.tournament_documents WHERE slug = v_slug;
    IF v_revision <> 3 THEN RAISE EXCEPTION 'Ordinary dated tournaments no longer validate.'; END IF;
    RAISE EXCEPTION 'Restore ordinary fixture' USING ERRCODE = 'ZT001';
  EXCEPTION WHEN SQLSTATE 'ZT001' THEN NULL;
  END;
  IF NOT EXISTS(SELECT 1 FROM public.tournament_documents WHERE slug = v_slug AND document = v_changed AND revision = 2)
    OR (SELECT count(*) FROM public.tournament_document_history WHERE slug = v_slug) <> 2 THEN
    RAISE EXCEPTION 'Rejected or temporary test updates changed the document/history.';
  END IF;
  RAISE NOTICE 'PASS: partial dates, strict year/status guards, ordinary dates, CAS and history.';
END;
$test$;
ROLLBACK;
