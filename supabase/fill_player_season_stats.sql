-- ============================================================
-- Uzupełnienie player_season_stats z team_players
--
-- Problem: Wielu zawodników ma wpisy w team_players (kadry),
-- ale nie ma wpisów w player_season_stats, bo trigger
-- uzupełnia stats tylko przy match_events (bramki/kartki).
--
-- To oznacza, że w profilu zawodnika brakuje sezonów
-- w których grał, ale nie strzelił gola.
--
-- Ten skrypt:
-- 1. Tworzy brakujące wpisy w player_season_stats
--    dla każdego zawodnika z team_players
-- 2. Przelicza bramki z match_events dla istniejących wpisów
-- 3. Ustawia appearances na liczbę meczów drużyny w sezonie
--    (bo nie mamy danych match_lineups)
-- ============================================================

-- KROK 1: Wstaw brakujące wpisy player_season_stats
-- dla zawodników z team_players, którzy nie mają jeszcze statystyk
INSERT INTO player_season_stats (
    player_id, season_id, league_id, team_id,
    appearances, goals, assists, yellow_cards, red_cards
)
SELECT DISTINCT
    tp.player_id,
    tp.season_id,
    tp.league_id,
    tp.team_id,
    -- appearances: policz mecze drużyny w tym sezonie/lidze (przybliżenie)
    COALESCE((
        SELECT COUNT(*)
        FROM matches m
        WHERE m.season_id = tp.season_id
          AND m.league_id = tp.league_id
          AND (m.home_team_id = tp.team_id OR m.away_team_id = tp.team_id)
          AND m.status IN ('completed', 'walkover_home', 'walkover_away')
    ), 0),
    -- goals
    COALESCE((
        SELECT COUNT(*)
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.player_id = tp.player_id
          AND me.event_type = 'GOAL'
          AND me.is_own_goal = false
          AND m.season_id = tp.season_id
          AND m.league_id = tp.league_id
    ), 0),
    -- assists
    COALESCE((
        SELECT COUNT(*)
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.assist_player_id = tp.player_id
          AND me.event_type = 'GOAL'
          AND m.season_id = tp.season_id
          AND m.league_id = tp.league_id
    ), 0),
    -- yellow_cards
    COALESCE((
        SELECT COUNT(*)
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.player_id = tp.player_id
          AND me.event_type = 'YELLOW_CARD'
          AND m.season_id = tp.season_id
          AND m.league_id = tp.league_id
    ), 0),
    -- red_cards
    COALESCE((
        SELECT COUNT(*)
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.player_id = tp.player_id
          AND me.event_type = 'RED_CARD'
          AND m.season_id = tp.season_id
          AND m.league_id = tp.league_id
    ), 0)
FROM team_players tp
WHERE NOT EXISTS (
    SELECT 1 FROM player_season_stats pss
    WHERE pss.player_id = tp.player_id
      AND pss.season_id = tp.season_id
      AND pss.league_id = tp.league_id
)
ON CONFLICT (player_id, season_id, league_id) DO NOTHING;

-- KROK 2: Zaktualizuj istniejące wpisy (które mają goals ale appearances=0)
-- Ustaw appearances = liczba meczów drużyny w sezonie
UPDATE player_season_stats pss
SET
    appearances = COALESCE((
        SELECT COUNT(*)
        FROM matches m
        WHERE m.season_id = pss.season_id
          AND m.league_id = pss.league_id
          AND (m.home_team_id = pss.team_id OR m.away_team_id = pss.team_id)
          AND m.status IN ('completed', 'walkover_home', 'walkover_away')
    ), 0),
    -- Przelicz bramki (na wypadek gdyby trigger nie zadziałał poprawnie)
    goals = COALESCE((
        SELECT COUNT(*)
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.player_id = pss.player_id
          AND me.event_type = 'GOAL'
          AND me.is_own_goal = false
          AND m.season_id = pss.season_id
          AND m.league_id = pss.league_id
    ), 0),
    -- Przelicz asysty
    assists = COALESCE((
        SELECT COUNT(*)
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.assist_player_id = pss.player_id
          AND me.event_type = 'GOAL'
          AND m.season_id = pss.season_id
          AND m.league_id = pss.league_id
    ), 0),
    -- Przelicz żółte kartki
    yellow_cards = COALESCE((
        SELECT COUNT(*)
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.player_id = pss.player_id
          AND me.event_type = 'YELLOW_CARD'
          AND m.season_id = pss.season_id
          AND m.league_id = pss.league_id
    ), 0),
    -- Przelicz czerwone kartki
    red_cards = COALESCE((
        SELECT COUNT(*)
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.player_id = pss.player_id
          AND me.event_type = 'RED_CARD'
          AND m.season_id = pss.season_id
          AND m.league_id = pss.league_id
    ), 0),
    updated_at = now()
WHERE pss.appearances = 0;

-- KROK 3: Pokaż podsumowanie
SELECT
    s.year AS sezon,
    COUNT(*) AS zawodnikow_ze_statystykami,
    SUM(pss.goals) AS suma_goli,
    SUM(pss.assists) AS suma_asyst,
    SUM(CASE WHEN pss.goals > 0 THEN 1 ELSE 0 END) AS strzelcy,
    ROUND(AVG(pss.appearances), 1) AS srednie_mecze
FROM player_season_stats pss
JOIN seasons s ON s.id = pss.season_id
GROUP BY s.year
ORDER BY s.year;
