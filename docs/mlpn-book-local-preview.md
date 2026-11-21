# Księga MLPN — podgląd dostępny przez bezpośredni link

Stan: 21 listopada 2026. Użytkownik zatwierdził wdrożenie podglądu pod osobnym adresem, bez odnośników w publicznej nawigacji. Podgląd nie jest zabezpieczony hasłem: każdy posiadający link może go otworzyć.

## Audyt zakresu historycznego — 21 listopada

Po uwadze użytkownika przebudowano domyślny zakres z ostatniego sezonu na lata 2003–2026. Zakładka „Kluby” zawiera 814 bilansów z 68 edycji lig, pogrupowanych w 176 wpisów; wpisy nie są równoznaczne z liczbą odrębnych klubów. Nieustalone zmiany tożsamości pozostają oddzielne.

Nowe dane:

- `src/data/mlpnBookAllTimeTeams.json`: wszystkie źródłowe bilanse, korekty bramek z oryginalnych plików, nazwy klubów właściwe dla sezonu, aktualne zakończenie 2026.
- `src/data/mlpnBookAllTimePlayers.json`: odtworzone osiągnięcia zawodników i 24 udokumentowane edycje Kamila Szlejzera. Usunięto z widocznego zestawienia błędny rekord 21 lat wynikający z niepełnej migracji profilu.
- `src/data/mlpnBookAllTimeMatches.json`: maksima zachowanych wyników od 2003 roku i porównanie datowanych serii w ramach pojedynczego sezonu.
- `scripts/buildMlpnBookAllTimeTeams.cjs` oraz `scripts/buildMlpnBookArchiveMatches.cjs`: odtwarzalne obliczenia offline z oryginałów i jawnych migawek odczytu.

Ważne rozróżnienia: 1835 goli Starszaków obejmuje wyniki administracyjne z tabel, 1832 w prezentacji wykluczało walkower 2026. Obie liczby opisują różne zakresy. Puste miejsca WordPress zapisane jako 0:0 nie są meczami remisowymi. Do odrzucenia takich wpisów użyto tytułów z „Pauza”/„przerwa” oraz drugiego importu, w którym wynik nie istnieje. Prawdziwy wynik 0:0 pozostaje prawidłowym remisem.

Nadal nie ustalono pełnej klasyfikacji goli kariery ani rekordów serii przechodzących pomiędzy sezonami. Historyczne protokoły nie są kompletne; etykiety przy rekordach określają ten limit.

Testy archiwum: `node scripts/testMlpnBookAllTimeTeams.cjs` oraz `node --test scripts/lib/mlpnBookArchiveValidation.test.cjs scripts/lib/mlpnBookTeamRecords.test.cjs`. Testy komponentu obejmują oddzielenie historii od sezonu 2026; kontrola w przeglądarce obejmuje pięć zakładek na pięciu szerokościach 320–1440 px.

## Nawigacja

- Adres podglądu określa `src/data/bookPreviewConfig.json`. Nie jest dodawany do menu, mapy witryny ani robots.txt.
- `/archiwum` zachowuje dotychczasowy publiczny widok. `/ksiega-mlpn` nie otwiera Księgi.
- Postbuild tworzy osobny plik HTML podglądu z `noindex, nofollow, noarchive` oraz `referrer=no-referrer`. Zwykłe strony nie otrzymują tych ustawień. Przy opuszczeniu podglądu przez nawigację aplikacji jego metadane są usuwane.
- Sekcja jest ładowana na żądanie, żeby dane archiwalne nie powiększały początkowego pakietu strony głównej.

## Dane i źródła

To zapis danych, a nie automatycznie odświeżana usługa rekordów. Nie dodano zapisu do bazy ani nowych uprawnień.

- `src/data/mlpnBookPlayerRecords.json`: odczyt zapisanych bramek, asyst i zgłoszeń do kadr. Brakujące strzelce oraz powielone historyczne zdarzenia są opisane w `verification` i przy rekordach.
- `src/data/mlpnBookTeamRecords.json`: wyniki, bilanse tabel i serie sezonu 2026 oraz osobno opisany audyt historycznych bramek drużyn.
- `src/data/mlpnBookHistory.js`: podium I ligi 2003–2026; agregaty tytułów, medali i kolejnych sezonów na podium są wyliczane z jednej listy.
- `scripts/lib/mlpnBookTeamRecords.cjs`: obliczenia serii, sprawdzenie kompletności par terminarza i ranking z remisami. Funkcje nie łączą się z siecią.

Materiały w nadrzędnym katalogu roboczym:

- `prezentacja-2026/materialy-robocze/wszech-czasow/podium-I-ligi-2003-2026.csv`.
- `prezentacja-2026/materialy-robocze/wszech-czasow/bilans-weryfikacja.json` i `kontrola-z-archiwum.csv`.
- `prezentacja-2026/gala/Audyt prezentacji MLPN 2026.md` — poprawione fakty historyczne; sumy sezonu w tym audycie są sprzed ostatnich trzech meczów, więc nie zastępują odczytu wyników z 21 listopada.
- `Mecze Dziadków i PKKL 2003-2017.csv` — odzyskane historyczne wpisy.

Nie należy używać bez sprawdzenia wcześniejszego pliku `rekordy-i-ciekawostki-2026.md`: późniejszy audyt poprawił część jego wniosków.

## Reguły

Rekordy na boisku pomijają walkowery. Boiskowe serie biegną według daty i godziny, a wynik administracyjny lub nieznany przerywa serię. Spotkania anulowane wskutek wycofania drużyn są wyłączone. Niepełna chronologia lub brak oczekiwanej pary wyklucza daną drużynę z porównania serii. Serie nie przechodzą między sezonami.

Potwierdzone edycje Kamila Szlejzera opierają się na źródłowych zapisach bramek z każdego roku. Wcześniejszy rekord liczony z niepełnych zgłoszeń do kadr został wycofany. Rekord kariery w golach pozostaje nieustalony. Różne zakresy nie mogą zostać połączone pod etykietą „rekord wszech czasów”.

## Weryfikacja

Testy aplikacji: `react-scripts test --watchAll=false --runInBand --env=jsdom` z `CI=true`.

Obliczenia serii: `node --test scripts/lib/mlpnBookTeamRecords.test.cjs`.

Testy podglądu: `node --test scripts/lib/bookPreviewHtml.test.cjs` oraz `src/lib/bookPreview.test.js`. Po wdrożeniu należy sprawdzić HTTP 200 i literalne noindex podglądu, brak tych metadanych na stronie głównej oraz brak odnośników do Księgi w menu. Dane pozostają migawką; mechanizm ich automatycznego odświeżania nie jest częścią tego wdrożenia.
