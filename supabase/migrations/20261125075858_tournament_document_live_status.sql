CREATE OR REPLACE FUNCTION public.validate_tournament_document() RETURNS trigger
LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
DECLARE d jsonb := NEW.document; item jsonb; team jsonb; person jsonb; event jsonb; k text; ids text[]; group_ids text[]; match_ids text[];
BEGIN
  IF jsonb_typeof(d) IS DISTINCT FROM 'object' OR pg_column_size(d)>1500000
    OR d->>'slug' IS DISTINCT FROM NEW.slug OR coalesce(length(btrim(d->>'name')),0) NOT BETWEEN 1 AND 180
    OR coalesce(d->>'id','') !~ '^[A-Za-z0-9_-]{1,120}$'
    OR coalesce(d->>'date','') !~ '^\d{4}-\d{2}-\d{2}$'
    OR coalesce(d->>'status','') NOT IN ('upcoming','live','completed','archived')
    OR jsonb_typeof(d->'teams') IS DISTINCT FROM 'array'
    OR jsonb_typeof(d->'groups') IS DISTINCT FROM 'array'
    OR jsonb_typeof(d->'matches') IS DISTINCT FROM 'array'
    OR jsonb_typeof(d->'rules') IS DISTINCT FROM 'object' THEN
    RAISE EXCEPTION 'Nieprawidłowe dane turnieju.' USING ERRCODE='22023';
  END IF;
  PERFORM (d->>'date')::date;
  IF jsonb_array_length(d->'teams')>128 OR jsonb_array_length(d->'groups')>64 OR jsonb_array_length(d->'matches')>2000 THEN
    RAISE EXCEPTION 'Przekroczono rozmiar turnieju.' USING ERRCODE='22023';
  END IF;
  FOREACH k IN ARRAY ARRAY['pointsWin','pointsDraw','pointsLoss'] LOOP
    IF d->'rules' ? k AND (jsonb_typeof(d->'rules'->k)<>'number' OR (d->'rules'->>k) !~ '^\d{1,2}$') THEN
      RAISE EXCEPTION 'Nieprawidłowa punktacja.' USING ERRCODE='22023';
    END IF;
  END LOOP;
  SELECT coalesce(array_agg(x->>'id'), ARRAY[]::text[]) INTO ids FROM jsonb_array_elements(d->'teams') x;
  SELECT coalesce(array_agg(x->>'id'), ARRAY[]::text[]) INTO group_ids FROM jsonb_array_elements(d->'groups') x;
  SELECT coalesce(array_agg(x->>'id'), ARRAY[]::text[]) INTO match_ids FROM jsonb_array_elements(d->'matches') x;
  IF cardinality(ids)<>(SELECT count(DISTINCT v) FROM unnest(ids) v)
     OR cardinality(group_ids)<>(SELECT count(DISTINCT v) FROM unnest(group_ids) v)
     OR cardinality(match_ids)<>(SELECT count(DISTINCT v) FROM unnest(match_ids) v) THEN
    RAISE EXCEPTION 'Powtórzone identyfikatory.' USING ERRCODE='22023';
  END IF;
  FOR team IN SELECT value FROM jsonb_array_elements(d->'teams') LOOP
    IF coalesce(team->>'id','') !~ '^[A-Za-z0-9_-]{1,120}$' OR coalesce(length(btrim(team->>'name')),0) NOT BETWEEN 1 AND 120
      OR jsonb_typeof(team->'players') IS DISTINCT FROM 'array'
      OR coalesce(team->>'logo','') !~ '^(https://|/[^/]|$)' THEN
      RAISE EXCEPTION 'Nieprawidłowa drużyna.' USING ERRCODE='22023';
    END IF;
    IF jsonb_array_length(team->'players')>100 THEN RAISE EXCEPTION 'Zbyt wielu zawodników.' USING ERRCODE='22023'; END IF;
    FOR person IN SELECT value FROM jsonb_array_elements(team->'players') LOOP
      IF coalesce(person->>'id','') !~ '^[A-Za-z0-9_-]{1,120}$' OR coalesce(length(btrim(person->>'name')),0) NOT BETWEEN 1 AND 160 THEN
        RAISE EXCEPTION 'Nieprawidłowy zawodnik.' USING ERRCODE='22023';
      END IF;
    END LOOP;
  END LOOP;
  IF (SELECT count(*) FROM jsonb_array_elements(d->'teams') t CROSS JOIN LATERAL jsonb_array_elements(t->'players') p)
     <> (SELECT count(DISTINCT p->>'id') FROM jsonb_array_elements(d->'teams') t CROSS JOIN LATERAL jsonb_array_elements(t->'players') p) THEN
    RAISE EXCEPTION 'Powtórzony zawodnik.' USING ERRCODE='22023';
  END IF;
  FOR item IN SELECT value FROM jsonb_array_elements(d->'groups') LOOP
    IF coalesce(item->>'id','') !~ '^[A-Za-z0-9_-]{1,120}$' OR jsonb_typeof(item->'teamIds') IS DISTINCT FROM 'array' THEN
      RAISE EXCEPTION 'Nieprawidłowa grupa.' USING ERRCODE='22023';
    END IF;
    IF EXISTS(SELECT 1 FROM jsonb_array_elements_text(item->'teamIds') v WHERE NOT(v=ANY(ids)))
      OR (SELECT count(*)<>count(DISTINCT v) FROM jsonb_array_elements_text(item->'teamIds') v) THEN
      RAISE EXCEPTION 'Nieprawidłowy skład grupy.' USING ERRCODE='22023';
    END IF;
  END LOOP;
  FOR item IN SELECT value FROM jsonb_array_elements(d->'matches') LOOP
    IF coalesce(item->>'id','') !~ '^[A-Za-z0-9_-]{1,120}$'
      OR coalesce(item->>'status','') NOT IN ('scheduled','live','finished')
      OR coalesce(item->>'stage','') NOT IN ('group','round16','quarterfinal','semifinal','third','final','playoff')
      OR (item->>'homeTeamId' IS NOT NULL AND NOT(item->>'homeTeamId'=ANY(ids)))
      OR (item->>'awayTeamId' IS NOT NULL AND NOT(item->>'awayTeamId'=ANY(ids)))
      OR item->>'homeTeamId'=item->>'awayTeamId'
      OR (item->>'groupId' IS NOT NULL AND NOT(item->>'groupId'=ANY(group_ids))) THEN
      RAISE EXCEPTION 'Nieprawidłowy mecz.' USING ERRCODE='22023';
    END IF;
    FOREACH k IN ARRAY ARRAY['homeScore','awayScore','homePenalties','awayPenalties'] LOOP
      IF item->>k IS NOT NULL AND (jsonb_typeof(item->k)<>'number' OR item->>k !~ '^\d{1,3}$') THEN
        RAISE EXCEPTION 'Wynik musi być nieujemną liczbą całkowitą.' USING ERRCODE='22023';
      END IF;
    END LOOP;
    IF item->>'status' IN ('live','finished') AND (item->>'homeScore' IS NULL OR item->>'awayScore' IS NULL OR item->>'homeTeamId' IS NULL OR item->>'awayTeamId' IS NULL) THEN
      RAISE EXCEPTION 'Brak drużyn lub wyniku meczu.' USING ERRCODE='22023';
    END IF;
    IF jsonb_typeof(item->'events') IS DISTINCT FROM 'array' OR jsonb_array_length(item->'events')>500 THEN
      RAISE EXCEPTION 'Nieprawidłowy protokół.' USING ERRCODE='22023';
    END IF;
    FOR event IN SELECT value FROM jsonb_array_elements(item->'events') LOOP
      IF coalesce(event->>'type','') NOT IN ('goal','assist','yellow','red') OR
        coalesce(event->>'teamId','') NOT IN (coalesce(item->>'homeTeamId',''),coalesce(item->>'awayTeamId','')) OR
        NOT EXISTS(SELECT 1 FROM jsonb_array_elements(d->'teams') t CROSS JOIN LATERAL jsonb_array_elements(t->'players') p WHERE t->>'id'=event->>'teamId' AND p->>'id'=event->>'playerId') THEN
        RAISE EXCEPTION 'Nieprawidłowe zdarzenie w meczu.' USING ERRCODE='22023';
      END IF;
    END LOOP;
  END LOOP;
  IF TG_OP='UPDATE' THEN
    IF NEW.slug<>OLD.slug OR d->>'id' IS DISTINCT FROM OLD.document->>'id' OR NEW.revision<>OLD.revision+1 THEN
      RAISE EXCEPTION 'Turniej został zmieniony. Wczytaj aktualne dane.' USING ERRCODE='40001';
    END IF;
  ELSIF NEW.revision<>1 THEN RAISE EXCEPTION 'Nieprawidłowa wersja turnieju.' USING ERRCODE='22023';
  END IF;
  NEW.updated_at := clock_timestamp();
  RETURN NEW;
END;
$$;
