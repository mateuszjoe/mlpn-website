# Typer MŚ 2026 — opis projektu i przewodnik wdrożenia na stronie ligi

> Dokument dla osoby/AI (Codex/Claude), która ma **odtworzyć ten sam typer**
> Mistrzostw Świata 2026 na stronie **amatorskiej ligi** (backend: **Supabase**).
> Opisuje zamysł działania, mechanikę i co dostosować. Źródło prawdy z dokładną
> logiką: repo `github.com/mateuszjoe/WC2026Buk` (pliki: `app.js`, `styles.css`,
> `firestore.rules`, `data/settings.json`, `data/matches.json`,
> `scripts/update-data.mjs`, `scripts/send-push.mjs`, `sw.js`, `manifest.webmanifest`).

---

## 1. Co to jest

Webowy **typer (zakłady na punkty)** na Mistrzostwa Świata 2026. Gracze typują
wyniki meczów, dostają punkty za trafienia, rywalizują w rankingu. Wersja
oryginalna jest dla znajomych (gra o pulę pieniędzy, język wulgarny/żartobliwy).

**Wersja dla ligi (TEN nowy projekt) — różnice:**
- **Backend: Supabase** (PostgreSQL + Auth + Realtime + RLS), nie Firebase.
- **Bez wulgaryzmów** — ton kulturalny, kibicowski. (W oryginale w wielu
  komunikatach jest celowo ostry język — patrz §9. Trzeba go przepisać.)
- **Konta kibiców** — trzeba dodać rejestrację/logowanie zwykłych użytkowników.
  Obecnie strona ligi ma tylko logowanie admina i kilku osób wpisujących wyniki.
  W oryginale logowanie jest przez Google (Firebase Auth) — tu raczej e‑mail+hasło
  lub magic link w Supabase Auth.
- **Gra o punkty, nie o kasę** — zwycięzca dostaje **nagrodę od ligi**. Wszędzie,
  gdzie oryginał mówi o „puli/składce/wpłacie", zamień na „nagroda od ligi"
  (albo usuń baner składki/zrzutki — patrz §6 „Baner").

---

## 2. Stos oryginału vs liga

| Element            | Oryginał (WC2026Buk)                          | Liga (do zrobienia)                          |
|--------------------|-----------------------------------------------|----------------------------------------------|
| Frontend           | Czysty JS (bez frameworka, bez builda), 1 plik `app.js` renderujący stringi HTML | Dostosować do stosu strony ligi |
| Hosting            | GitHub Pages (deploy = push na `main`)        | Hosting strony ligi                          |
| Baza + auth        | Firebase Firestore + Firebase Auth (Google)   | **Supabase** (Postgres + Auth + RLS)         |
| Realtime           | Firestore `onSnapshot`                        | **Supabase Realtime** (subskrypcje zmian)    |
| Reguły dostępu     | `firestore.rules`                             | **RLS policies** (SQL)                       |
| Robot danych/wyniki| GitHub Action + `firebase-admin` co 30 min    | GitHub Action / Edge Function + `supabase-js`|
| Powiadomienia push | Web Push (VAPID) + Service Worker + robot     | To samo (Web Push standardowy)               |
| Avatary (upload)   | kompresja do data URL w dokumencie            | Supabase Storage lub data URL w wierszu      |

---

## 3. Model danych (Firestore → tabele Supabase)

Oryginał trzyma w Firestore kolekcje. Propozycja mapowania na tabele Postgres:

### `profiles` (gracz/kibic)  — odpowiednik kolekcji `predictions`
- `user_id` (PK, = auth.users.id)
- `name` (nick, widoczny w rankingu; ustawiany raz)
- `name_set` (bool — nick zablokowany po ustawieniu)
- `avatar` (string: emoji, URL, albo data URL zdjęcia; `"none"` = inicjały)
- `email`
- `approved` (bool — **poczekalnia**: nowy kibic czeka na zgodę admina; patrz §6)
- `paid`/`prize_eligible` (bool — w lidze: np. „uregulował zgłoszenie"/nieistotne)
- `champion` (typ na mistrza turnieju — id drużyny)
- `created_at`, `updated_at`

### `predictions` (typy meczów) — w oryginale zagnieżdżone w dokumencie gracza
Lepiej osobna tabela w Postgresie:
- `user_id` (FK), `match_id` (FK) — PK złożony
- `home` (int), `away` (int) — typowany wynik
- `adv` (`'h'`/`'a'`/null — w pucharach: która drużyna awansuje; patrz §4)
- (opcjonalnie `confirmed` — patrz §9, ale **NIE** używać do ukrywania typu!)

### `matches` (terminarz + wyniki) — w oryginale plik `data/matches.json`
- `id`, `stage` (`'group'` | `'1/16 finału'` | `'1/8 finału'` | `'ćwierćfinał'`
  | `'półfinał'` | `'mecz o 3. miejsce'` | `'finał'`)
- `group` (A..L lub null), `matchday` (1/2/3 dla fazy grupowej)
- `kickoff_at` (timestamptz, UTC)
- `home_team` / `away_team` (id, name, crest)
- `status`, `duration` (`REGULAR`/`EXTRA_TIME`/`PENALTY_SHOOTOUT`)
- `winner` (`HOME_TEAM`/`AWAY_TEAM`/null — faktyczny zwycięzca, też po dogrywce)
- `home_score`, `away_score` (wynik z API; patrz §4 o czasie regulaminowym)

### `admin_state` — wyniki ręczne admina + mistrz
- `results` (mapa match_id -> {h,a} — ręczne nadpisanie wyniku 90')
- `champion_team_id` (ręczne ustawienie mistrza)

### `chat` + `chat_reads` (opcjonalnie — czat)
- `chat`: id, user_id, name, avatar, text, image (data URL), created_at
- `chat_reads`: user_id -> last_read_ms (potwierdzenia „przeczytano")

### `push_subs` — subskrypcje Web Push (per użytkownik)
### `push_state` — stan robota powiadomień (dedup: co już wysłano)

### `settings` — konfiguracja punktacji i blokad (w oryginale `data/settings.json`)
```json
{
  "tournamentName": "Mistrzostwa Świata 2026",
  "points": { "correctResult": 1, "exactScore": 3, "tournamentWinner": 10, "advanceBonus": 1 },
  "lockPredictionsAtKickoff": true,
  "championLockAt": "2026-06-18T03:45:00.000Z",
  "adminEmail": "<admin>"
}
```

---

## 4. Punktacja i zasady (NAJWAŻNIEJSZE — odtworzyć 1:1)

**Punkty za mecz:**
- **3 pkt** — dokładny wynik (typ == wynik, np. 2:1 i pada 2:1).
- **1 pkt** — trafiony rezultat (1/X/2), gdy wynik nie jest dokładny.
- **0 pkt** — nietrafiony rezultat.
- **10 pkt** — trafiony **zwycięzca całego turnieju** (typ na mistrza).

**Faza pucharowa — czas regulaminowy (KLUCZOWE, częste źródło błędów):**
- Typy dotyczą **regulaminowego czasu gry (90 min)**. **Dogrywka i karne NIE
  liczą się** do punktów za wynik/rezultat.
- Technicznie: jeśli mecz rozstrzygnięto po dogrywce (`duration != REGULAR`),
  auto‑wynik z API zawiera dogrywkę — **nie używamy go**; 90‑minutowy wynik
  (remis) wpisuje admin ręcznie. Mecze rozstrzygnięte w 90' liczą się automatem.
- **Mistrz turnieju** = faktyczny zdobywca pucharu (tu dogrywka/karne **liczą
  się** — z pola `winner`), niezależnie od czasu regulaminowego.

**Dodatkowy typ „kto awansuje" (tylko puchary):**
- Przy meczu pucharowym gracz może wskazać drużynę, która awansuje (pole `adv`).
- **+1 pkt** TYLKO gdy: w 90' był **remis** ORAZ gracz **typował remis** (czyli
  trafił rezultat) ORAZ wskazał właściwą drużynę awansującą (po dogrywce/karnych,
  z pola `winner`).
- Jeśli gracz typuje remis, a drużyna awansuje wygraną w 90' (nie było remisu) —
  rezultat nietrafiony, **0 pkt**, bonus nie przysługuje.

**Remisy w rankingu (kolejność rozstrzygania):**
suma → więcej dokładnych wyników → trafiony mistrz → więcej trafionych rezultatów
→ bonusy za awans → jak daleko zaszedł typowany mistrz → nazwa.

**Blokady typowania:**
- Mecz: typ można wpisać/zmienić najpóźniej **5 minut PRZED** pierwszym gwizdkiem.
- Mistrz: można zmieniać tylko **do końca 1. kolejki** fazy grupowej.
  „Koniec 1. kolejki" = **start ostatniego meczu 1. kolejki + 90 min + 15 min
  przerwy (= +105 min)**. Liczone arytmetyką znaczników czasu (само ogarnia
  przejście przez północ). 1. kolejka = mecze `matchday == 1` (albo, jeśli brak
  pola: liczba_grup × 2 najwcześniejszych meczów grupowych).

---

## 5. Ekrany / zakładki

1. **Ranking** — tabela: miejsce, gracz (avatar+nick), suma, rozbicie (dokł./rez./
   🎯 awans/mistrz). Publiczny (widoczny też dla niezalogowanych — zachęta).
   Routing po `#hash`, żeby odświeżenie wracało na tę samą zakładkę.
2. **Mecze** — terminarz + wyniki + tabele grup. Przełącznik widoku **„Wg grup /
   Wg dat"**. Tabele grupowe liczone z wyników.
3. **Moje typy** — formularz typowania (tylko zalogowany i zatwierdzony):
   - wynik wpisywany ręcznie ORAZ klikany **+/−** (wygodne na telefonie),
   - przycisk **„Zatwierdź typ"** (kosmetyczny znacznik — NIE może ukrywać typu!),
   - przycisk **„✕ wyczyść"** (realne usunięcie typu),
   - w pucharach picker **„kto awansuje"**,
   - wybór **mistrza turnieju** (do końca 1. kolejki),
   - auto‑zapis (z debounce).
4. **Profil** — nick (raz), avatar: emoji (gradientowe kółka), wgrane zdjęcie
   z **kadrowaniem w kółku** (kompresja), zdjęcie z konta, własny link, inicjały.
   Włączanie powiadomień push.
5. **Regulamin** — punktacja, zasady typowania, faza pucharowa (90 min + awans),
   nagroda (w lidze: „nagroda od ligi", bez kasy/zrzutki).
6. **Panel admina** (tylko admin/osoby wpisujące wyniki):
   - wpisywanie wyników meczów (ręczne nadpisanie automatu; dla pucharów po
     dogrywce **wpisać wynik 90'**),
   - ręczne ustawienie mistrza,
   - **Gracze**: lista z usuwaniem, edycją nicku, oznaczaniem statusu,
   - **Poczekalnia**: zatwierdzanie/odrzucanie nowych kont (patrz §6),
   - klik w gracza → podgląd jego typów (BEZ e‑maila; cudze typy widoczne
     dopiero po starcie meczu — uczciwa gra).
7. **(Opcjonalnie) Czat** — pływający dymek w rogu z licznikiem nieprzeczytanych,
   linki/obrazki/GIF z URL, wgrywanie zdjęć. **Bez wulgaryzmów.**

---

## 6. Poczekalnia (zamknięta lista) + Baner

**Poczekalnia / zatwierdzanie kont:** lista uczestników jest „zamknięta" — nowy
zalogowany kibic trafia do poczekalni (`approved = false`), widzi ekran „czekasz
na zgodę", **nie typuje, nie liczy się w rankingu**, dopóki admin go nie wpuści.
Admin w panelu ma sekcję „Poczekalnia" (Wpuść/Odrzuć) + plakietkę z liczbą +
powiadomienie o nowym oczekującym. Ważne (RLS): **gracz nie może sam zmienić
swojego `approved`** — tylko admin. Istniejące konta bez pola = zatwierdzone.

**Baner składki (oryginał):** w lidze **nie ma kasy** — usuń baner zrzutki/składki
albo zamień na neutralny komunikat „Gra o nagrodę od ligi". (W oryginale baner jest
zwijany, świadomy opłat — w lidze to zbędne.)

---

## 7. Auth na Supabase (do zaprojektowania)

- **Role:** admin, osoby wpisujące wyniki (result‑editors), zwykli kibice.
- **Kibice:** rejestracja e‑mail+hasło lub magic link (Supabase Auth). Po
  pierwszym logowaniu tworzy się wiersz w `profiles` z `approved = false`
  (poczekalnia). Trigger SQL `on auth.user created` może tworzyć profil.
- **RLS (odpowiednik `firestore.rules`):**
  - `matches`, `admin_state`, `profiles` (do rankingu) — **odczyt publiczny**.
  - `profiles`: właściciel edytuje swój wiersz, ale **nie pole `approved`**;
    admin/edytorzy mogą wszystko. Usuwanie: admin lub właściciel.
  - `predictions`: właściciel zapisuje/edytuje/usuwa **tylko swoje**.
  - `admin_state`: zapis tylko admin/edytorzy.
  - `chat`: odczyt publiczny; zapis tylko własne wiadomości; usuwanie autor/admin.
  - `push_subs`: tylko własne.
- **Realtime:** subskrybuj zmiany `predictions`, `matches`/`admin_state`, `chat`,
  `profiles` → przeliczaj ranking na żywo (jak `onSnapshot` w oryginale).

---

## 8. Robot: dane meczów + powiadomienia push

**Źródło wyników:** API **football-data.org** (competition `WC`), token w sekrecie
`FOOTBALL_DATA_TOKEN`. Robot (GitHub Action co 30 min lub Supabase Edge Function
na cron) pobiera mecze i zapisuje do tabeli `matches`. Z API bierzemy: `stage`,
`group`, `matchday`, `utcDate`, drużyny, `score.fullTime`, `score.duration`,
`score.winner`.

**Zabezpieczenia robota (WAŻNE — wnioski z produkcji):**
- Jeśli API zwróci błąd / zerwie połączenie (`fetch failed`) / poda **za mało
  meczów** (np. pustą listę przy rate‑limicie) — **NIE nadpisuj** terminarza i
  **zakończ sukcesem** (exit 0), zostawiając ostatnią dobrą wersję. Inaczej
  terminarz/typy „znikają", a CI wysyła maile o błędach. (MŚ = 104 mecze; próg np.
  „< 64 = pomiń zapis".) Łap też `unhandledRejection`/`uncaughtException` → exit 0.

**Powiadomienia push (Web Push / VAPID + Service Worker):**
- Subskrypcje w `push_subs`. Stan dedup w `push_state`.
- **Wyniki meczów** (po zakończeniu), **nowy lider rankingu** — komunikaty
  spersonalizowane (ale **kulturalne**, bez wulgaryzmów!).
- **Ogłoszenia faz** (~4h przed pierwszym meczem fazy, raz każda):
  start turnieju (z parą 1. meczu), 2. i 3. kolejka grupowa (3. = „decyduje o
  awansie"), każda runda pucharowa **z parami „kto z kim"** (tylko realne, znane
  drużyny).
  - **ZASADA bezpieczeństwa treści:** NIE ogłaszać przedwcześnie losów drużyn
    (żadnego „X odpada" / „Y musi wygrać"). Podawać tylko fakty: runda + realne
    pary. Pełne liczenie „kto już awansował" (format 12 grup + najlepsze z 3.
    miejsc) jest zawodne i rodzi bzdury — celowo tego unikać.
- **Przypomnienia o typowaniu** (per gracz, raz dziennie po ~8:00 czasu PL):
  jeśli gracz ma na DZIŚ nierozpoczęte, nieobstawione mecze → push z liczbą.
  Czas i „dziś" liczone w strefie **Europe/Warsaw**. Poczekalnia pominięta.

---

## 9. Pułapki/wnioski (NIE powtarzać błędów oryginału)

1. **Nie bramkować punktacji „zatwierdzeniem typu".** Był błąd: edytowany,
   niezatwierdzony typ znikał z rankingu. **Typ ZAWSZE się liczy** (auto‑zapis);
   „Zatwierdź" może być tylko kosmetycznym znacznikiem.
2. **Nie nadpisywać nicku/typów przed wczytaniem danych.** Był błąd: formularz
   zasiewał się pusty zanim doszły dane gracza, a zapis nadpisywał nick „domyślną"
   nazwą. Zasiewaj dane DOPIERO po wczytaniu profilu; blokuj zapisy do tego czasu.
3. **Usuwanie typu musi realnie kasować w bazie.** W Firestore `merge` nie kasuje
   kluczy mapy (typ „wracał" po odświeżeniu) — trzeba było `deleteField`. W
   Postgresie po prostu `DELETE` wiersza z `predictions` (prościej).
4. **Czas regulaminowy w pucharach** (patrz §4) — najczęstsze źródło pomyłek.
5. **Robot: nie nadpisuj pustką + nie wywalaj joba** (patrz §8).
6. **Treści powiadomień o awansie** — tylko fakty, bez przepowiadania losów (§8).
7. **Strefa czasowa** — „dziś"/godziny licz w Europe/Warsaw, mecze trzymaj w UTC.
8. (Oryginał, Google/Firebase) logowanie OAuth nie działa w przeglądarkach
   wbudowanych w Messenger/FB/IG — nieistotne, jeśli liga użyje e‑mail+hasło.

---

## 10. Czego NIE przenosić / co zmienić w lidze

- **Wulgaryzmy** — w oryginale są w komunikatach powiadomień (`scripts/send-push.mjs`
  i in‑app `notify*` w `app.js`), w pustych stanach, w panelu, w stopce
  („Wóda! Szlugi! Grube baby!"), w grafice hero. **Wszystko przepisać na ton
  kulturalny/kibicowski.** Grafiki/hero z oryginału NIE używać.
- **Kasa/zrzutka/składka** → „gra o punkty, nagroda od ligi". Usunąć baner zrzutki.
- **Logowanie Google** → Supabase Auth (e‑mail+hasło / magic link).
- **Branding** → kolory/logo ligi.

---

## 11. Kolejność wdrożenia (sugestia)

1. Tabele Supabase + RLS + Auth (kibice, admin/edytorzy) + trigger tworzący profil.
2. Import terminarza MŚ 2026 do `matches` (robot football-data.org) + zabezpieczenia.
3. Ekrany: Ranking, Mecze (wg grup/dat), Moje typy (z punktacją §4), Profil, Regulamin.
4. Punktacja + blokady (§4) + ranking realtime.
5. Panel admina (wyniki, mistrz, gracze, poczekalnia).
6. Poczekalnia/zatwierdzanie kont kibiców.
7. Powiadomienia push (wyniki, lider, fazy, przypomnienia) — kulturalne treści.
8. (Opcjonalnie) czat.

> Dokładną logikę (wzory punktów, blokady, format komunikatów, kadrowanie avatara,
> obliczanie „końca 1. kolejki", parsowanie API) najlepiej podejrzeć wprost w
> plikach repo `WC2026Buk` wymienionych na górze i przenieść 1:1, zmieniając tylko
> warstwę danych (Firestore → Supabase) i ton komunikatów.
