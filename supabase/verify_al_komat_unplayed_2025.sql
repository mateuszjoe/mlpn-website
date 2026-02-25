-- AL-Komat / III liga / sezon 2025
-- Cel:
-- 1) Zweryfikowac mecze z 1 rundy (kolejki 1-9), ktore nie byly grane po dolaczeniu druzyny w 2 rundzie
-- 2) Oznaczyc je statusem "unplayed" (Nierozegrany), aby postep ligi liczyl sie np. 81/81 zamiast 81/90
--
-- Uwaga:
-- - Skrypt najpierw pokazuje liste kandydatow i podsumowanie
-- - UPDATE jest na koncu i ograniczony do statusow scheduled/postponed
-- - Jesli zobaczysz eventy/lineupy > 0, zatrzymaj sie i sprawdz przed UPDATE

-- KROK 1: Podglad kandydatow (AL-Komat, III liga, sezon 2025, kolejki 1-9)
SELECT
  m.id,
  s.year AS sezon,
  l.code AS liga,
  m.round AS kolejka,
  th.name AS gospodarz,
  ta.name AS gosc,
  m.status,
  m.match_date,
  m.home_goals,
  m.away_goals,
  (SELECT COUNT(*) FROM match_events me WHERE me.match_id = m.id) AS eventy,
  (SELECT COUNT(*) FROM match_lineups ml WHERE ml.match_id = m.id) AS sklady
FROM matches m
JOIN seasons s ON s.id = m.season_id
JOIN leagues l ON l.id = m.league_id
JOIN teams th ON th.id = m.home_team_id
JOIN teams ta ON ta.id = m.away_team_id
WHERE s.year = 2025
  AND l.code = '3rd'
  AND m.round BETWEEN 1 AND 9
  AND (th.name = 'AL-Komat' OR ta.name = 'AL-Komat')
ORDER BY m.round, m.match_date, gospodarz, gosc;

-- KROK 2: Podsumowanie statusow kandydatow
SELECT
  m.status,
  COUNT(*) AS ile
FROM matches m
JOIN seasons s ON s.id = m.season_id
JOIN leagues l ON l.id = m.league_id
JOIN teams th ON th.id = m.home_team_id
JOIN teams ta ON ta.id = m.away_team_id
WHERE s.year = 2025
  AND l.code = '3rd'
  AND m.round BETWEEN 1 AND 9
  AND (th.name = 'AL-Komat' OR ta.name = 'AL-Komat')
GROUP BY m.status
ORDER BY m.status;

-- KROK 3: UPDATE (odkomentuj i uruchom po weryfikacji)
-- UPDATE matches m
-- SET
--   status = 'unplayed',
--   home_goals = NULL,
--   away_goals = NULL,
--   updated_at = now()
-- FROM seasons s, leagues l, teams th, teams ta
-- WHERE s.id = m.season_id
--   AND l.id = m.league_id
--   AND th.id = m.home_team_id
--   AND ta.id = m.away_team_id
--   AND s.year = 2025
--   AND l.code = '3rd'
--   AND m.round BETWEEN 1 AND 9
--   AND (th.name = 'AL-Komat' OR ta.name = 'AL-Komat')
--   AND m.status IN ('scheduled', 'postponed');

-- KROK 4: Szybka kontrola po UPDATE (81/81 w III lidze)
-- SELECT
--   COUNT(*) FILTER (WHERE status IN ('completed', 'walkover_home', 'walkover_away')) AS rozegrane,
--   COUNT(*) FILTER (WHERE status NOT IN ('cancelled', 'unplayed')) AS planowane_do_liczenia,
--   COUNT(*) FILTER (WHERE status = 'unplayed') AS nierozegrane
-- FROM matches m
-- JOIN seasons s ON s.id = m.season_id
-- JOIN leagues l ON l.id = m.league_id
-- WHERE s.year = 2025
--   AND l.code = '3rd';
