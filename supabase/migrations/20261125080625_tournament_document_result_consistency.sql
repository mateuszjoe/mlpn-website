CREATE FUNCTION public.validate_tournament_document_results() RETURNS trigger
LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
DECLARE d jsonb := NEW.document; m jsonb; g jsonb; s jsonb; e jsonb; team_id text; score integer; has_penalties boolean; cycle_found boolean;
BEGIN
  FOR m IN SELECT value FROM jsonb_array_elements(d->'matches') LOOP
    IF m->>'status'='scheduled' AND (m->>'homeScore' IS NOT NULL OR m->>'awayScore' IS NOT NULL OR m->>'homePenalties' IS NOT NULL OR m->>'awayPenalties' IS NOT NULL OR jsonb_array_length(m->'events')>0) THEN
      RAISE EXCEPTION 'Nadchodzący mecz nie może mieć wyniku ani zdarzeń.' USING ERRCODE='22023';
    END IF;
    IF m->>'stage'='group' THEN
      SELECT value INTO g FROM jsonb_array_elements(d->'groups') WHERE value->>'id'=m->>'groupId';
      IF g IS NULL OR NOT(g->'teamIds' ? (m->>'homeTeamId')) OR NOT(g->'teamIds' ? (m->>'awayTeamId')) THEN
        RAISE EXCEPTION 'Uczestnicy meczu nie należą do jego grupy.' USING ERRCODE='22023';
      END IF;
    END IF;
    has_penalties := m->>'homePenalties' IS NOT NULL OR m->>'awayPenalties' IS NOT NULL;
    IF has_penalties AND (m->>'stage'='group' OR m->>'status'<>'finished' OR m->>'homeScore'<>m->>'awayScore'
      OR m->>'homePenalties' IS NULL OR m->>'awayPenalties' IS NULL) THEN
      RAISE EXCEPTION 'Karne są dozwolone tylko w zakończonym remisem meczu pucharowym.' USING ERRCODE='22023';
    END IF;
    IF m->>'stage'<>'group' AND m->>'status'='finished' AND m->>'homeScore'=m->>'awayScore'
      AND (NOT has_penalties OR m->>'homePenalties'=m->>'awayPenalties')
      AND coalesce(m->>'reportedWinnerId','') NOT IN (m->>'homeTeamId',m->>'awayTeamId') THEN
      RAISE EXCEPTION 'Remis w fazie pucharowej wymaga rozstrzygnięcia.' USING ERRCODE='22023';
    END IF;
    IF (SELECT count(*)<>count(DISTINCT value->>'id') FROM jsonb_array_elements(m->'events')) THEN
      RAISE EXCEPTION 'Powtórzone zdarzenie.' USING ERRCODE='22023';
    END IF;
    FOR e IN SELECT value FROM jsonb_array_elements(m->'events') LOOP
      IF coalesce(length(e->>'id'),0)=0 OR (e->>'minute' IS NOT NULL AND (jsonb_typeof(e->'minute')<>'number' OR e->>'minute' !~ '^\d{1,4}$')) THEN
        RAISE EXCEPTION 'Nieprawidłowa minuta lub identyfikator zdarzenia.' USING ERRCODE='22023';
      END IF;
    END LOOP;
    FOREACH team_id IN ARRAY ARRAY[m->>'homeTeamId',m->>'awayTeamId'] LOOP
      score := CASE WHEN team_id=m->>'homeTeamId' THEN (m->>'homeScore')::integer ELSE (m->>'awayScore')::integer END;
      IF (SELECT count(*) FROM jsonb_array_elements(m->'events') e WHERE e->>'teamId'=team_id AND e->>'type'='goal')>score OR
         (SELECT count(*) FROM jsonb_array_elements(m->'events') e WHERE e->>'teamId'=team_id AND e->>'type'='assist')>score THEN
        RAISE EXCEPTION 'Liczba goli lub asyst w protokole przekracza wynik.' USING ERRCODE='22023';
      END IF;
    END LOOP;
    FOR s IN SELECT value FROM jsonb_array_elements(jsonb_build_array(m->'homeSource',m->'awaySource')) WHERE value<>'null'::jsonb LOOP
      IF s->>'type'='group' THEN
        SELECT value INTO g FROM jsonb_array_elements(d->'groups') WHERE value->>'id'=s->>'groupId';
        IF g IS NULL OR coalesce(s->>'position','') !~ '^[1-9]\d{0,2}$' THEN
          RAISE EXCEPTION 'Nieprawidłowe źródło awansu z grupy.' USING ERRCODE='22023';
        END IF;
        IF (s->>'position')::integer>jsonb_array_length(g->'teamIds') THEN
          RAISE EXCEPTION 'Nieprawidłowe miejsce awansu.' USING ERRCODE='22023';
        END IF;
      ELSIF s->>'type' IN ('winner','loser') THEN
        IF NOT EXISTS(SELECT 1 FROM jsonb_array_elements(d->'matches') other WHERE other->>'id'=s->>'matchId') THEN
          RAISE EXCEPTION 'Awans wskazuje nieistniejący mecz.' USING ERRCODE='22023';
        END IF;
      ELSE RAISE EXCEPTION 'Nieprawidłowe źródło awansu.' USING ERRCODE='22023';
      END IF;
    END LOOP;
  END LOOP;
  WITH RECURSIVE edges AS (
    SELECT m->>'id' id,s->>'matchId' dependency FROM jsonb_array_elements(d->'matches') m
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_build_array(m->'homeSource',m->'awaySource')) s
    WHERE s->>'type' IN ('winner','loser')
  ), paths AS (
    SELECT id,dependency,ARRAY[id] visited,false cycle FROM edges
    UNION ALL
    SELECT e.id,e.dependency,p.visited||e.id,e.id=ANY(p.visited)
    FROM paths p JOIN edges e ON e.id=p.dependency WHERE NOT p.cycle
  ) SELECT EXISTS(SELECT 1 FROM paths WHERE cycle) INTO cycle_found;
  IF cycle_found THEN RAISE EXCEPTION 'Drabinka zawiera cykliczne awanse.' USING ERRCODE='22023'; END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public.validate_tournament_document_results() FROM PUBLIC, anon, authenticated;
CREATE TRIGGER validate_tournament_document_results BEFORE INSERT OR UPDATE ON public.tournament_documents FOR EACH ROW EXECUTE FUNCTION public.validate_tournament_document_results();
