# MLPN Web - Notatki projektowe

> **ZASADA:** Po KAŻDYM zadaniu zapisuj tutaj notatki. NIE przepisuj kodu - zapisuj tylko ustalenia, wymagania, wytyczne i decyzje. Celem jest szybkie odzyskanie kontekstu przy minimalnym zużyciu tokenów. Gdy użytkownik napisze "zrób notatki", "pamiętaj o notatkach" itp. = zaktualizuj ten plik.

---

## Projekt
- **MLPN** = Mazowiecka Liga Piłki Nożnej, amatorska liga w Sulejówku
- React SPA, migracja z mockData na Supabase
- Użytkownik NIE jest programistą - komunikacja po polsku, bez żargonu

## Architektura
- `src/App.js` - monolith ~9300 linii, routing przez `activeContext`
- Konteksty: home | 1st | 2nd | 3rd | tournaments | info | admin
- `src/contexts/AuthContext.jsx` - hook useAuth()
- `src/lib/supabase.js` - klient Supabase
- Tailwind CSS via CDN + custom 3D design (e3d-card, e3d-btn, e3d-tab)
- Dark mode via boolean prop
- TypeScript częściowo (index.tsx, reszta JS, allowJs + noEmit)

## Supabase
- Projekt: "mlpn" (free tier)
- URL: `https://npbpegyfsxbsuzlixqva.supabase.co`
- Anon key w `.env.local` (gitignored)
- Admin: mateuszjoe@gmail.com, UUID: f2bb4bd4-2b99-471f-8794-46bd8fdd61d9
- **30 tabel** z RLS, triggerami, widokami - GOTOWE
- **Storage buckety**: NIE utworzone (team-logos, player-photos)

## Panel admina (GOTOWY - 14 plików)
- Ścieżka: `src/pages/admin/`
- Komponenty: AdminFormField, AdminTable, AdminModal, AdminAlert, AdminImageUpload
- Strony: AdminLogin, AdminDashboard, AdminPanel, AdminSeasons, AdminTeams, AdminPlayers, AdminRosters, AdminSchedule, AdminMatchResults
- Integracja z App.js: import na linii 29, routing `activeContext === 'admin'` na linii 3307
- Przycisk Admin w nawigacji (desktop + mobile), sidebar ukryty w trybie admina
- Logowanie: ikona LogIn gdy niezalogowany, LogOut + trybik gdy admin

## Import archiwum (GOTOWE - 2026-02-21)
- Pliki SQL w `supabase/import/`
- Kolejność: 00_setup.sql -> 01_setup_2018-2025.sql -> 2003.sql do 2025.sql
- **00_setup.sql**: sezony 2003-2017 + 142 drużyny archiwalne
- **01_setup_2018-2025.sql**: sezony 2018-2025 + 71 drużyn z mlpn.pl (z logo_url)
- **2003.sql-2025.sql**: mecze poszczególnych sezonów (season_leagues, season_teams, matches)
- **NAPRAWIONY BUG**: oryginalne pliki miały `BEGIN/COMMIT` transakcję + `ON CONFLICT (name)` - jeśli jeden INSERT failował, cofało WSZYSTKO. Naprawione: usunięto transakcje, zmieniono na `ON CONFLICT DO NOTHING` (łapie każdy conflict)
- **Stan**: WSZYSTKO ZAIMPORTOWANE (sezony 2003-2025)

## Import zawodników, kadr i bramek (GOTOWE - 2026-02-22)
- **Skrypt**: `supabase/run_import.js` — automatyczny import przez Supabase RPC (exec_sql)
- **Metoda**: service key (sb_secret_*) w `.env.local` + funkcja exec_sql() w bazie
- **Zawodnicy**: `players_import.sql` (WordPress XML) + `players_l98_supplement.sql` (L98 strzelcy)
- **Kadry**: `rosters_l98_2003-2017.sql` + `rosters_2018-2025.sql` → tabela `team_players`
- **Bramki 2003-2017**: `goals_2003-2017.sql` → tabela `match_events` (22861 zdarzeń)
- **Duże pliki**: dzielone po ligach (split_remaining.js) bo Supabase ma timeout ~25s
- **Stan bazy po imporcie**:
  - 24 sezony, 187 drużyn, 6830 zawodników
  - 7805 meczów, 22861 bramek, 8639 przypisań gracz→drużyna
  - 3 ligi, 68 season_leagues, 778 tabel ligowych

## Import bramek/kartek 2018-2025 (GOTOWE - 2026-02-22)
- **Źródło**: backup bazy WordPress (`baza 2018-2025/backup_*-db.sql.gz`)
- **Metoda**: parsowanie SQL dumpu WordPressa (tabele JoomSport) → import do Supabase
- **Skrypt**: `supabase/import_wp_goals.js`
- **Tabele JoomSport użyte**: `wp_joomsport_match_events`, `wp_joomsport_matches`, `wp_posts` (gracze/drużyny/sezony)
- **Typy zdarzeń WP**: 5=Gol, 6=Samobój, 7=Żółta, 8=Druga żółta, 9=Czerwona, 10=MOTM
- **Dozwolone typy w Supabase**: GOAL, YELLOW_CARD, RED_CARD (check constraint)
- **Wynik importu**:
  - 12,412 zdarzeń zaimportowanych (0 błędów)
  - 10,985 bramek (w tym 21 samobójów), 1,373 żółtych kartek, 54 czerwone
  - Pominięte: 1,745 MOTM, 1,103 mecze bez mapowania (turnieje?), 35 graczy bez mapowania
- **Stan bazy po imporcie**:
  - 35,273 match_events łącznie (22,861 + 12,412)
  - Bramki per sezon 2018-2025: 2216, 1645, 885, 1200, 1081, 1364, 1498, 1096
- **WAŻNE**: przy imporcie trzeba wyłączyć triggery USER na match_events (player_season_stats trigger crashuje)
- **WAŻNE**: 16 graczy niezmapowanych (dziwne nazwy: "---Michał Jerzak---", jednoczłonowe itp.)
- **WAŻNE**: tabela kadr to `team_players` (NIE `rosters`)
- **WAŻNE**: pozycje graczy — 94% ma domyślne POM (pomocnik), bo WordPress nie miał tych danych

## Zasady ligi
- 3 pkt wygrana, 1 remis, 0 przegrana, walkover 3:0
- Pauza: co 2 żółte karty, 1 mecz za czerwoną
- 3 ligi (I, II, III), 2 awanse/spadki
- Sortowanie tabeli: punkty > różnica bramek > strzelone > alfabetycznie

## Znane problemy i rozwiązania
- **signOut wisi**: czyszczenie localStorage (klucze `sb-*`) + window.location.reload()
- **handle_new_user trigger**: był zepsuty, profil trzeba było ręcznie INSERT'ować
- **Dark mode dropdowns**: natywne `<option>` wymagają explicit style={{ backgroundColor, color }}
- **AuthContext loading**: może się zaciąć - usunięto spinner z AdminPanel
- **Import SQL transakcje**: NIE używać BEGIN/COMMIT w Supabase SQL Editor dla dużych importów - jeden błąd cofa wszystko

## Frontend publiczny — PODŁĄCZONY DO SUPABASE (2026-02-22)

### Dane z Supabase (useMLPNData hook)
- `src/hooks/useMLPNData.js` — główny hook, ładuje wszystko z Supabase
- `src/services/supabaseQueries.js` — zapytania do widoków (v_matches, v_standings, v_top_scorers, itp.)
- **Tabele, wyniki, kalendarz, statystyki strzelców** — działają od razu z Supabase
- `buildSeasonData()` i `simulateMatch()` w App.js to **martwy kod** — nie jest wywoływany

### Zdarzenia meczowe (bramki, kartki) — GOTOWE
- `fetchAllMatches()` zwraca mecze z `events: []` (puste)
- `fetchMatchDetails(matchId)` pobiera eventy on-demand z `match_events`
- **MatchDetailsInline** i **MatchDetails** — lazy-loading: useEffect + fetchMatchDetails po kliknięciu meczu
- Transformacja typów: `YELLOW_CARD → YELLOW`, `RED_CARD → RED`, `GOAL → GOAL`
- **Fix**: `team: e.teams?.name` zamiast `team: e.team_id` (UUID → nazwa drużyny)

### Profil gracza — GOTOWE
- `fetchPlayerProfile(playerId)` — dane gracza + historia kariery z `player_season_stats`
- PlayerProfile przyjmuje `playerId` (UUID) zamiast obiektu `player`
- Lazy-loading wewnątrz komponentu (useState + useEffect)
- Wyświetla: imię/nazwisko, pozycja, wiek, miasto, noga, kariera per sezon
- `buildCareerHistory()` — **martwy kod** (fikcyjne dane, nie jest używany)

### Profil drużyny — GOTOWE
- `fetchTeamProfile(teamName)` — dane drużyny z tabeli `teams` (founded_year, district)
- `fetchTeamRoster(teamName, seasonYear)` — kadra z widoku `v_team_roster` ze statystykami
- `fetchTeamHistory(teamName)` — historia sezonów z `season_teams` (pozycje, awanse, spadki)
- TeamProfile: lazy-loading kadry, historii i danych drużyny
- Kadra wyświetla: numer, nazwisko, pozycja + ikony bramek/kartek
- Historia: sezon, liga, miejsce + ikony mistrz/awans/spadek
- Prop `currentSeason` dodany, `players` prop usunięty
- `buildTeamHistory()` — **martwy kod** (nie jest używany)
- Sekcja "Słowo od kapitana" — **usunięta** (była fikcyjna)

## Znane klucze/połączenia
- **Anon key**: w `.env.local` jako `REACT_APP_SUPABASE_ANON_KEY`
- **Service key**: w `.env.local` jako `SUPABASE_SERVICE_KEY` (sb_secret_*)
- **DB password**: w `.env.local` jako `SUPABASE_DB_PASSWORD`
- **Session Pooler**: `aws-1-eu-west-1.pooler.supabase.com:5432` (user: postgres.npbpegyfsxbsuzlixqva)
- **Bezpośrednie połączenie**: NIE działa (IPv4 only, baza wymaga IPv6)
- **exec_sql()**: funkcja w bazie umożliwiająca wykonywanie SQL przez RPC (SECURITY DEFINER, timeout 300s)

## Audyt sezonu 2025 (2026-02-22)
- **312 meczów** (I Liga: 90, II Liga: 132, III Liga: 90)
- **281 rozegranych**, 31 zaplanowanych (I Liga kompletna, II brakuje 22, III brakuje 9)
- **1790 bramek** z wyników, **1096 ze strzelcami** (61.2% pokrycie)
- **694 bramek bez strzelca** — luki w oryginalnych danych WordPress
- **113 meczów z bramkami ale bez żadnych strzelców** (609 brakujących bramek)
- **21 prawdopodobnych walkowerów** (3:0/0:3 bez eventów) — nie mają statusu walkover w bazie
- **9 meczów z nadmiarowymi eventami** — prawie wszystkie z KS ProBram24 (duplikaty/błędy importu)
- Pokrycie per liga: II Liga 70.1% (najlepsze), I Liga 62.3%, III Liga 47.1% (najgorsze)
- **Decyzja**: zostawiamy jak jest — dane pokazują się tam gdzie są, gdzie nie ma — nie pokazują się

## Co jeszcze do zrobienia
- [x] Dokończyć import archiwum (2003-2025) ✅
- [x] Import zawodników, kadr, bramek (2003-2017) ✅
- [x] Import bramek/kartek 2018-2025 z WordPress backup ✅
- [x] Podłączyć frontend publiczny do Supabase ✅
- [x] Zdarzenia meczowe (bramki/kartki) z Supabase ✅
- [x] Profil gracza z Supabase ✅
- [x] Profil drużyny z Supabase (kadra, historia, dane) ✅
- [ ] Storage buckety (team-logos, player-photos) + polityki
- [ ] Korekta pozycji graczy (94% ma domyślne POM)
- [ ] Oznaczyć walkowery statusem walkover_home/walkover_away (21 meczów w 2025)
- [ ] Sprawdzić nadmiarowe eventy KS ProBram24 (9 meczów z duplikatami)
