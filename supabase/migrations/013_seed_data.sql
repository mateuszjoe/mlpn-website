-- ============================================================
-- MLPN - Migracja 013: Seed Data
-- Podstawowe dane startowe: ligi, sezony, strony statyczne
-- UWAGA: Druzyny i zawodnikow dodasz przez panel admina
-- ============================================================


-- ============================================================
-- LIGI (3 poziomy)
-- ============================================================
INSERT INTO leagues (code, name, display_order) VALUES
    ('1st', 'I Liga', 1),
    ('2nd', 'II Liga', 2),
    ('3rd', 'III Liga', 3);


-- ============================================================
-- SEZONY
-- ============================================================
INSERT INTO seasons (year, name, status, is_current, start_date, end_date) VALUES
    (2025, 'Sezon 2025', 'active', true, '2025-04-05', '2025-11-30');


-- ============================================================
-- KONFIGURACJA SEZON-LIGA (2025)
-- ============================================================
INSERT INTO season_leagues (season_id, league_id, points_win, points_draw, points_loss,
                           walkover_goals_winner, walkover_goals_loser,
                           promotion_spots, relegation_spots,
                           yellow_card_suspension_threshold)
SELECT
    s.id,
    l.id,
    3, 1, 0,    -- punktacja: W=3, R=1, P=0
    3, 0,        -- walkover: 3:0
    CASE l.code
        WHEN '3rd' THEN 2  -- z III ligi awansuja 2
        WHEN '2nd' THEN 2  -- z II ligi awansuja 2
        ELSE 0             -- z I ligi nie ma awansu
    END,
    CASE l.code
        WHEN '1st' THEN 2  -- z I ligi spadaja 2
        WHEN '2nd' THEN 2  -- z II ligi spadaja 2
        ELSE 0             -- z III ligi nie ma spadku
    END,
    3  -- pauza po 3 zoltej kartce i po kazdej kolejnej
FROM seasons s, leagues l
WHERE s.year = 2025;


-- ============================================================
-- STRONY STATYCZNE
-- ============================================================
INSERT INTO static_pages (slug, title, content) VALUES
(
    'about',
    'O nas',
    '# Mazowiecka Liga Pilki Noznej

MLPN to amatorska liga pilkarska dzialajaca na terenie Sulej0wka i okolic.

## Kontakt
- Email: kontakt@mlpn.pl
- Boisko: Narutowicza 10, 05-071 Sulejowek'
),
(
    'regulations',
    'Regulamin',
    '# Regulamin MLPN

*Regulamin zostanie uzupelniony przez admina.*'
),
(
    'rodo',
    'RODO',
    '# Klauzula informacyjna RODO

Administratorem danych osobowych jest MLPN.

*Pelna tresc klauzuli zostanie uzupelniona.*'
),
(
    'privacy',
    'Polityka prywatnosci',
    '# Polityka prywatnosci

*Tresc polityki prywatnosci zostanie uzupelniona.*'
);


-- ============================================================
-- INFORMACJA: Jak dodac pierwszego admina
-- ============================================================
-- 1. Zarejestruj konto w Supabase Auth (email + haslo)
-- 2. Skopiuj UUID uzytkownika z auth.users
-- 3. Uruchom ponizsze zapytanie (zamien UUID):
--
-- UPDATE profiles SET role = 'admin'
-- WHERE id = 'TWOJ-UUID-TUTAJ';
--
-- Od tego momentu ten uzytkownik ma pelny dostep do panelu admina.
