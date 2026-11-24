# Podgląd centrum turniejów

Centrum jest dostępne pod osobnym adresem z `src/data/tournamentPreviewConfig.json`. Publiczne menu i dotychczasowa strona `/turnieje` pozostają bez zmian. Nie dodajemy adresu podglądu do mapy strony ani publicznych odnośników. To podgląd nieindeksowany, a nie strona chroniona hasłem: odbiorca linku może przekazać go dalej.

Postbuild tworzy osobne pliki HTML dla katalogu, turniejów, zakładek i profili. Każdy zawiera `noindex, nofollow, noarchive` oraz `no-referrer` przed uruchomieniem JavaScript. Kod QR prowadzi do konkretnego turnieju w tym samym ukrytym obszarze. Osobny manifest zachowuje ten adres po dodaniu strony do ekranu początkowego. Publiczny HTML, manifest i fallback 404 nie są zastępowane wersją podglądu.

## Dane archiwalne

Publiczne dane Tournify pobrano 24 listopada 2026. Do aplikacji trafiają wyłącznie jawnie wybrane pola sportowe; surowe eksporty nie są częścią repozytorium ani wdrożenia.

| Archiwum | Drużyny | Mecze | Zachowane wyniki |
| --- | ---: | ---: | ---: |
| halinowcup2025 | 30 | 80 | 78 |
| pucharsulejowka2025 | 16 | 52 | 52 |
| pucharburmistrza2025 | 14 | 42 | 38 |
| halinowcup2024 | 20 | 56 | 56 |
| mlpntest | 20 | 56 | 56 |
| Razem | 100 | 286 | 280 |

Brakujące wyniki pozostają nieznane. W zapisanych wynikach jest 776 goli. Cztery archiwa nie zawierają składów ani strzelców. `mlpntest` zawiera 78 zawodników, z których 6 jest przypisanych do nieistniejących w eksporcie drużyn; pozostają dostępni osobno. Tylko 37 ze 161 goli tego turnieju ma zachowanego autora. Nie odtwarzamy brakujących statystyk przez zgadywanie.

Tabela każdego turnieju używa źródłowej kolejności kryteriów. Dwie fazy grupowe Halinowa 2025 i Pucharu Sulejówka 2025 porównano niezależnie z publicznym widokiem Tournify: 15 tabel i 66 wierszy bez różnic w kolejności, punktach i bilansach.

## Kopie do testów

Archiwum można otworzyć w zakładce Organizator i utworzyć jego kopię. Zmiany wyników i zdarzeń zapisują się tylko w przeglądarce użytkownika. Odświeżenie odtwarza kopię, a przywrócenie danych usuwa jej lokalne zmiany. Edytowanie kopii nie zmienia importu ani bazy MLPN.

49 potwierdzonych powiązań fazy pucharowej aktualizuje uczestników kolejnych meczów. Zmiana uczestnika usuwa wynik i zdarzenia, które dotyczyły poprzedniej pary. Jedna niejednoznaczna obsada barażu oraz przejścia pomiędzy kolejnymi fazami grupowymi pozostają zgodne z archiwum. Ograniczenie jest opisane także na stronie.

Osobny turniej demonstracyjny ma fikcyjne zdarzenia do testowania. Zapowiedź Halinowa 20 grudnia 2026 zawiera jedynie potwierdzoną datę i miejscowość, bez fikcyjnych zgłoszeń lub wyników.

## Powiadomienia

Obserwowane drużyny zapisują się lokalnie. Przycisk testowy może wyświetlić pojedyncze powiadomienie po zgodzie użytkownika. Wersja podglądowa nie rozsyła automatycznych powiadomień o meczach; plan podłączenia wysyłki jest w `tournament-push-plan.md`. Worker i manifest pod ukrytym adresem powstają podczas `npm run build`, dlatego ich test wymaga serwowania gotowego katalogu `build`, nie samego serwera developerskiego CRA.

## Odtworzenie importu

`node scripts/importTournifyArchives.cjs <katalog-eksportów>` odczytuje pięć katalogów `<slug>/public-export.json` i odtwarza `src/data/tournamentArchives.json`. Domyślne wejście to lokalny, niewysyłany katalog `../.local/tournify-source`. Testy importu sprawdzają zgodność ze snapshotami, jeśli znajdują się lokalnie; testy aplikacji obejmują zachowanie zapisanych archiwów niezależnie od ich dostępności.
