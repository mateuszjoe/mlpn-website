-- Minimalna korekta terminarza II ligi, Sezon 2026.
--
-- Cel:
--   * globalna K10: tylko dwa mecze w sobote (Slimak-Tidy, Gosuansa-Detox),
--   * pozostale trzy mecze K10 w niedziele,
--   * pauza PJM w K10 i Joga Finito w K17,
--   * zachowanie wszystkich 55 ID, par, statusow, wynikow, notatek i statystyk.
--
-- Skrypt jest chroniony fingerprintem konkretnego stanu wejsciowego. Przed
-- wykonaniem produkcyjnym uruchom jego kopie z ROLLBACK zamiast COMMIT.

BEGIN ISOLATION LEVEL SERIALIZABLE;

SELECT pg_advisory_xact_lock(
  hashtextextended('mlpn:2026:second-league:k10-saturday', 0)
);

LOCK TABLE public.matches IN ACCESS EXCLUSIVE MODE;

CREATE TEMP TABLE mlpn_k10_before ON COMMIT DROP AS
SELECT m.*
FROM public.matches m
WHERE m.season_id = 'aac58f00-5579-4f26-a1a4-786702fcc595'::uuid
  AND m.league_id = 'd0531b2b-b561-490c-9c5c-489ffcb22da2'::uuid
  AND m.round BETWEEN 10 AND 20;

CREATE TEMP TABLE mlpn_k10_protected_before ON COMMIT DROP AS
SELECT m.id, to_jsonb(m) AS row_data
FROM public.matches m
WHERE m.id IN (
  '34ca790c-9128-48ce-9c74-8c18f069e9f1'::uuid, -- STM FC - PJM, zalegly
  'a0f80fe6-9292-4222-bad4-ba0d5b8970cd'::uuid, -- Joga Finito - Tidy Team, zalegly
  '2a9b5cde-310b-4f5f-adb3-7986658d33d8'::uuid  -- RKS - Nankatsu, walkower
);

CREATE TEMP TABLE mlpn_k10_stats_before ON COMMIT DROP AS
SELECT
  md5(COALESCE((
    SELECT string_agg(to_jsonb(s)::text, E'\n' ORDER BY s.id)
    FROM public.standings s
    WHERE s.season_id = 'aac58f00-5579-4f26-a1a4-786702fcc595'::uuid
      AND s.league_id = 'd0531b2b-b561-490c-9c5c-489ffcb22da2'::uuid
  ), '')) AS standings_hash,
  md5(COALESCE((
    SELECT string_agg(to_jsonb(ps)::text, E'\n' ORDER BY ps.id)
    FROM public.player_season_stats ps
    WHERE ps.season_id = 'aac58f00-5579-4f26-a1a4-786702fcc595'::uuid
      AND ps.league_id = 'd0531b2b-b561-490c-9c5c-489ffcb22da2'::uuid
  ), '')) AS player_stats_hash;

DO $$
DECLARE
  v_fingerprint text;
  v_reference_count integer;
BEGIN
  SELECT md5(string_agg(
    concat_ws('|',
      id::text,
      home_team_id::text,
      away_team_id::text,
      round::text,
      match_date::text,
      match_time::text,
      status,
      COALESCE(notes, '')
    ),
    E'\n' ORDER BY id
  ))
  INTO v_fingerprint
  FROM mlpn_k10_before;

  IF (SELECT count(*) FROM mlpn_k10_before) <> 55 THEN
    RAISE EXCEPTION 'Oczekiwano 55 meczow K10-K20 II ligi.';
  END IF;

  IF v_fingerprint <> '805b0edb9c082c9d34e67d8675e8bbde' THEN
    RAISE EXCEPTION 'Fingerprint terminarza zmienil sie: %', v_fingerprint;
  END IF;

  IF (
    SELECT count(DISTINCT (
      least(home_team_id, away_team_id)::text || '|' ||
      greatest(home_team_id, away_team_id)::text
    ))
    FROM mlpn_k10_before
  ) <> 55 THEN
    RAISE EXCEPTION 'Stan wejsciowy nie zawiera 55 unikalnych par.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_k10_before
    WHERE status <> 'scheduled'
       OR home_goals IS NOT NULL
       OR away_goals IS NOT NULL
       OR notes NOT LIKE '%[MLPN_SCHEDULE_HIDDEN]%'
  ) THEN
    RAISE EXCEPTION 'Mecz K10-K20 ma wynik, inny status albo brak markera ukrycia.';
  END IF;

  SELECT sum(reference_count)::integer
  INTO v_reference_count
  FROM (
    SELECT count(*) reference_count FROM public.active_match_assignments WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.gallery_albums WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.match_events WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.match_lineups WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.match_result_edits WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.news WHERE related_match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.typer_aggregates WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.typer_predictions WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.typer_round_config_matches WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.typer_picks WHERE match_id IN (SELECT id::text FROM mlpn_k10_before)
  ) refs;

  IF COALESCE(v_reference_count, 0) <> 0 THEN
    RAISE EXCEPTION 'Przyszly terminarz ma % powiazanych rekordow; przerwano.', v_reference_count;
  END IF;

  IF (SELECT count(*) FROM mlpn_k10_protected_before) <> 3 THEN
    RAISE EXCEPTION 'Nie znaleziono wszystkich trzech chronionych meczow spoza etapu.';
  END IF;
END $$;

CREATE TEMP TABLE mlpn_k10_desired (
  match_id uuid PRIMARY KEY,
  target_round integer NOT NULL,
  target_date date NOT NULL,
  target_time time NOT NULL
) ON COMMIT DROP;

-- Relabeling Detox <-> PJM daje poprawna pelna faktoryzacje przy najmniejszej
-- liczbie zmian. Slot z kazdego meczu zrodłowego przejmuje istniejacy rekord
-- docelowej, nieuporzadkowanej pary; ID i orientacja home/away pozostaja stale.
WITH mapped_slots AS (
  SELECT
    source.*,
    CASE source.home_team_id
      WHEN '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid
        THEN 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid
      WHEN 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid
        THEN '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid
      ELSE source.home_team_id
    END AS mapped_home,
    CASE source.away_team_id
      WHEN '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid
        THEN 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid
      WHEN 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid
        THEN '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid
      ELSE source.away_team_id
    END AS mapped_away
  FROM mlpn_k10_before source
)
INSERT INTO mlpn_k10_desired (match_id, target_round, target_date, target_time)
SELECT
  target.id,
  source.round,
  source.match_date,
  source.match_time
FROM mapped_slots source
JOIN mlpn_k10_before target
  ON least(target.home_team_id, target.away_team_id) =
     least(source.mapped_home, source.mapped_away)
 AND greatest(target.home_team_id, target.away_team_id) =
     greatest(source.mapped_home, source.mapped_away);

CREATE TEMP TABLE mlpn_k10_fixed_slots (
  team_a uuid NOT NULL,
  team_b uuid NOT NULL,
  target_date date NOT NULL,
  target_time time NOT NULL
) ON COMMIT DROP;

INSERT INTO mlpn_k10_fixed_slots (team_a, team_b, target_date, target_time)
VALUES
  (
    '7631e392-d4fd-4b7e-8fd1-f3b6513087ca'::uuid, -- FC Slimak Halinow
    '51b657ca-44dd-485a-9287-d48dfca482c7'::uuid, -- Tidy Team
    DATE '2026-09-05', TIME '18:10'
  ),
  (
    'c02b7728-ab92-4889-91ab-f0a1726ebe39'::uuid, -- Gosuansa
    '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid, -- Detox
    DATE '2026-09-05', TIME '20:30'
  ),
  (
    '7d4d6fdc-c4fc-4120-8953-189c08e00106'::uuid, -- Faludza
    '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid, -- STM FC
    DATE '2026-09-06', TIME '13:40'
  ),
  (
    '777e2624-6a7b-44c9-8948-488ab6e41f41'::uuid, -- Tiger Wolomin
    '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid, -- Joga Finito
    DATE '2026-09-06', TIME '14:50'
  ),
  (
    '58829f1d-c80e-4feb-8918-6d76d1d84489'::uuid, -- RKS Pendrachy
    '2c57c925-c479-40e6-85be-362c78ab43af'::uuid, -- Rayo Vallerano
    DATE '2026-09-06', TIME '16:00'
  );

UPDATE mlpn_k10_desired desired
SET
  target_round = 10,
  target_date = fixed.target_date,
  target_time = fixed.target_time
FROM mlpn_k10_before target
JOIN mlpn_k10_fixed_slots fixed
  ON least(target.home_team_id, target.away_team_id) = least(fixed.team_a, fixed.team_b)
 AND greatest(target.home_team_id, target.away_team_id) = greatest(fixed.team_a, fixed.team_b)
WHERE target.id = desired.match_id;

DO $$
DECLARE
  v_pjm uuid := 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid;
  v_joga uuid := '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid;
BEGIN
  IF (SELECT count(*) FROM mlpn_k10_desired) <> 55 THEN
    RAISE EXCEPTION 'Plan docelowy nie ma 55 rekordow.';
  END IF;

  IF (SELECT count(*) FROM mlpn_k10_desired d JOIN mlpn_k10_before b ON b.id = d.match_id
      WHERE (d.target_round, d.target_date, d.target_time)
            IS DISTINCT FROM (b.round, b.match_date, b.match_time)) <> 21 THEN
    RAISE EXCEPTION 'Plan powinien zmieniac dokladnie 21 z 55 rekordow.';
  END IF;

  IF EXISTS (
    SELECT 1 FROM mlpn_k10_desired GROUP BY target_round HAVING count(*) <> 5
  ) OR (SELECT count(DISTINCT target_round) FROM mlpn_k10_desired) <> 11 THEN
    RAISE EXCEPTION 'Kazda z K10-K20 musi miec dokladnie 5 meczow.';
  END IF;

  IF EXISTS (
    WITH appearances AS (
      SELECT d.target_round, b.home_team_id AS team_id
      FROM mlpn_k10_desired d JOIN mlpn_k10_before b ON b.id = d.match_id
      UNION ALL
      SELECT d.target_round, b.away_team_id
      FROM mlpn_k10_desired d JOIN mlpn_k10_before b ON b.id = d.match_id
    )
    SELECT 1 FROM appearances GROUP BY target_round, team_id HAVING count(*) > 1
  ) THEN
    RAISE EXCEPTION 'Druzyna wystepuje dwa razy w tej samej kolejce.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_k10_desired
    GROUP BY target_date, target_time
    HAVING count(*) > 1
  ) THEN
    RAISE EXCEPTION 'Dwa planowane mecze zajmuja ten sam slot.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_k10_desired d
    JOIN public.matches other
      ON other.id NOT IN (SELECT id FROM mlpn_k10_before)
     AND other.match_date = d.target_date
     AND other.match_time = d.target_time
     AND other.status NOT IN ('cancelled', 'unplayed')
  ) THEN
    RAISE EXCEPTION 'Plan koliduje godzinowo z meczem spoza poprawianego etapu.';
  END IF;

  IF EXISTS (
    WITH appearances AS (
      SELECT d.target_date, b.home_team_id AS team_id
      FROM mlpn_k10_desired d JOIN mlpn_k10_before b ON b.id = d.match_id
      UNION ALL
      SELECT d.target_date, b.away_team_id
      FROM mlpn_k10_desired d JOIN mlpn_k10_before b ON b.id = d.match_id
    )
    SELECT 1
    FROM appearances a
    JOIN public.matches other
      ON other.id NOT IN (SELECT id FROM mlpn_k10_before)
     AND other.match_date = a.target_date
     AND a.team_id IN (other.home_team_id, other.away_team_id)
     AND other.status NOT IN ('cancelled', 'unplayed')
  ) THEN
    RAISE EXCEPTION 'Druzyna ma inny mecz w tym samym dniu.';
  END IF;

  IF (SELECT count(*) FROM mlpn_k10_desired WHERE target_round = 10 AND target_date = DATE '2026-09-05') <> 2
     OR (SELECT count(*) FROM mlpn_k10_desired WHERE target_round = 10 AND target_date = DATE '2026-09-06') <> 3
     OR EXISTS (
       SELECT 1 FROM mlpn_k10_desired
       WHERE target_round = 10
         AND target_date NOT IN (DATE '2026-09-05', DATE '2026-09-06')
     ) THEN
    RAISE EXCEPTION 'K10 nie ma ukladu 2 mecze w sobote + 3 w niedziele.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_k10_fixed_slots fixed
    WHERE NOT EXISTS (
      SELECT 1
      FROM mlpn_k10_desired d
      JOIN mlpn_k10_before b ON b.id = d.match_id
      WHERE d.target_round = 10
        AND d.target_date = fixed.target_date
        AND d.target_time = fixed.target_time
        AND least(b.home_team_id, b.away_team_id) = least(fixed.team_a, fixed.team_b)
        AND greatest(b.home_team_id, b.away_team_id) = greatest(fixed.team_a, fixed.team_b)
    )
  ) THEN
    RAISE EXCEPTION 'Nie wszystkie wymagane pary K10 trafily do swoich slotow.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_k10_desired d
    JOIN mlpn_k10_before b ON b.id = d.match_id
    WHERE d.target_round = 10
      AND v_pjm IN (b.home_team_id, b.away_team_id)
  ) THEN
    RAISE EXCEPTION 'PJM nie pauzuje w K10.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_k10_desired d
    JOIN mlpn_k10_before b ON b.id = d.match_id
    WHERE d.target_round = 17
      AND v_joga IN (b.home_team_id, b.away_team_id)
  ) THEN
    RAISE EXCEPTION 'Joga Finito nie pauzuje w K17.';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM mlpn_k10_before
    WHERE id = '73bed1d3-7159-41be-8ec9-ae4483e81e7d'::uuid
      AND home_team_id = v_pjm
      AND away_team_id = '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid
  ) THEN
    RAISE EXCEPTION 'Chronione ID normalnego rewanzu PJM - STM FC nie pasuje.';
  END IF;
END $$;

-- Zmiana rundy/daty/godziny nie powinna przebudowywac tabeli. Wylaczenie
-- triggera standings jest transakcyjne; po bledzie ROLLBACK przywraca stan.
ALTER TABLE public.matches DISABLE TRIGGER trg_recalculate_standings;

CREATE TEMP TABLE mlpn_k10_updated_ids ON COMMIT DROP AS
WITH updated AS (
  UPDATE public.matches live
  SET
    round = desired.target_round,
    match_date = desired.target_date,
    match_time = desired.target_time
  FROM mlpn_k10_desired desired
  WHERE live.id = desired.match_id
    AND (live.round, live.match_date, live.match_time)
        IS DISTINCT FROM
        (desired.target_round, desired.target_date, desired.target_time)
  RETURNING live.id
)
SELECT id FROM updated;

ALTER TABLE public.matches ENABLE TRIGGER trg_recalculate_standings;

DO $$
DECLARE
  v_standings_hash text;
  v_player_stats_hash text;
  v_reference_count integer;
BEGIN
  IF (SELECT count(*) FROM mlpn_k10_updated_ids) <> 21 THEN
    RAISE EXCEPTION 'Zaktualizowano % rekordow zamiast 21.',
      (SELECT count(*) FROM mlpn_k10_updated_ids);
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_k10_desired desired
    JOIN public.matches live ON live.id = desired.match_id
    WHERE (live.round, live.match_date, live.match_time)
          IS DISTINCT FROM
          (desired.target_round, desired.target_date, desired.target_time)
  ) THEN
    RAISE EXCEPTION 'Nie wszystkie rekordy maja docelowy termin.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_k10_before before
    JOIN public.matches live ON live.id = before.id
    WHERE (live.home_team_id, live.away_team_id, live.status,
           live.home_goals, live.away_goals, live.notes,
           live.video_url, live.gallery_url, live.referee,
           live.referee_id, live.mvp_player_id, live.created_at)
          IS DISTINCT FROM
          (before.home_team_id, before.away_team_id, before.status,
           before.home_goals, before.away_goals, before.notes,
           before.video_url, before.gallery_url, before.referee,
           before.referee_id, before.mvp_player_id, before.created_at)
  ) THEN
    RAISE EXCEPTION 'Poza runda/data/godzina zmienilo sie pole meczu.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_k10_protected_before before
    JOIN public.matches live ON live.id = before.id
    WHERE to_jsonb(live) IS DISTINCT FROM before.row_data
  ) THEN
    RAISE EXCEPTION 'Chroniony mecz spoza etapu zostal zmieniony.';
  END IF;

  SELECT md5(COALESCE(string_agg(to_jsonb(s)::text, E'\n' ORDER BY s.id), ''))
  INTO v_standings_hash
  FROM public.standings s
  WHERE s.season_id = 'aac58f00-5579-4f26-a1a4-786702fcc595'::uuid
    AND s.league_id = 'd0531b2b-b561-490c-9c5c-489ffcb22da2'::uuid;

  SELECT md5(COALESCE(string_agg(to_jsonb(ps)::text, E'\n' ORDER BY ps.id), ''))
  INTO v_player_stats_hash
  FROM public.player_season_stats ps
  WHERE ps.season_id = 'aac58f00-5579-4f26-a1a4-786702fcc595'::uuid
    AND ps.league_id = 'd0531b2b-b561-490c-9c5c-489ffcb22da2'::uuid;

  IF v_standings_hash <> (SELECT standings_hash FROM mlpn_k10_stats_before)
     OR v_player_stats_hash <> (SELECT player_stats_hash FROM mlpn_k10_stats_before) THEN
    RAISE EXCEPTION 'Tabela ligowa albo statystyki zawodnikow ulegly zmianie.';
  END IF;

  SELECT sum(reference_count)::integer
  INTO v_reference_count
  FROM (
    SELECT count(*) reference_count FROM public.active_match_assignments WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.gallery_albums WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.match_events WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.match_lineups WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.match_result_edits WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.news WHERE related_match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.typer_aggregates WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.typer_predictions WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.typer_round_config_matches WHERE match_id IN (SELECT id FROM mlpn_k10_before)
    UNION ALL SELECT count(*) FROM public.typer_picks WHERE match_id IN (SELECT id::text FROM mlpn_k10_before)
  ) refs;

  IF COALESCE(v_reference_count, 0) <> 0 THEN
    RAISE EXCEPTION 'Po korekcie pojawily sie nieoczekiwane zaleznosci.';
  END IF;
END $$;

COMMIT;

SELECT jsonb_build_object(
  'updated_rows', 21,
  'stage_rows', count(*),
  'unique_pairs', count(DISTINCT (
    least(home_team_id, away_team_id)::text || '|' ||
    greatest(home_team_id, away_team_id)::text
  )),
  'hidden_rows', count(*) FILTER (WHERE notes LIKE '%[MLPN_SCHEDULE_HIDDEN]%')
) AS applied_summary
FROM public.matches
WHERE season_id = 'aac58f00-5579-4f26-a1a4-786702fcc595'::uuid
  AND league_id = 'd0531b2b-b561-490c-9c5c-489ffcb22da2'::uuid
  AND round BETWEEN 10 AND 20;
