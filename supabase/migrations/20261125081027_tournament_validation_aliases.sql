CREATE OR REPLACE FUNCTION public.validate_tournament_document_results() RETURNS trigger
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
      IF (SELECT count(*) FROM jsonb_array_elements(m->'events') event_row WHERE event_row->>'teamId'=team_id AND event_row->>'type'='goal')>score OR
         (SELECT count(*) FROM jsonb_array_elements(m->'events') event_row WHERE event_row->>'teamId'=team_id AND event_row->>'type'='assist')>score THEN
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
    SELECT match_row.value->>'id' id,source_row.value->>'matchId' dependency FROM jsonb_array_elements(d->'matches') AS match_row(value)
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_build_array(match_row.value->'homeSource',match_row.value->'awaySource')) AS source_row(value)
    WHERE source_row.value->>'type' IN ('winner','loser')
  ), paths AS (
    SELECT id,dependency,ARRAY[id] visited,false cycle FROM edges
    UNION ALL
    SELECT edge_row.id,edge_row.dependency,p.visited||edge_row.id,edge_row.id=ANY(p.visited)
    FROM paths p JOIN edges edge_row ON edge_row.id=p.dependency WHERE NOT p.cycle
  ) SELECT EXISTS(SELECT 1 FROM paths WHERE cycle) INTO cycle_found;
  IF cycle_found THEN RAISE EXCEPTION 'Drabinka zawiera cykliczne awanse.' USING ERRCODE='22023'; END IF;
  RETURN NEW;
END;
$$;
