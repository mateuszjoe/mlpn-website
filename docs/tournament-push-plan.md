# Turnieje MLPN — link, QR i powiadomienia

Stan: 24 listopada 2026. Prototyp początkowo lokalny, następnie przeznaczony do udostępnienia pod niepodlinkowanym adresem podglądu, zgodnie z decyzją właściciela.

## Działające elementy prototypu

- Bezpośredni link do turnieju zachowuje bieżącą domenę i przekazany `basePath`, również ukryty prefiks podglądu. Nie zastępuje go publicznym `/turnieje` ani pozornym adresem produkcyjnym.
- QR jest generowany w przeglądarce przez `qrcode`; adres nie trafia do zewnętrznego generatora. PNG można pobrać. Na localhost informujemy, że adres tego komputera nie stanie się adresem osiągalnym z telefonu przez samo zeskanowanie QR.
- Obserwowanie turnieju/drużyn zapisuje wyłącznie preferencje na bieżącym urządzeniu. Nie jest subskrypcją push i nie przesyła danych do serwera.
- Przycisk testowy uruchamia pytanie o zgodę oraz jedno lokalne powiadomienie systemowe. Samo otwarcie strony ani wybranie drużyny nie pyta o zgodę. Zablokowanie zgody pozostaje respektowane.
- Service worker ma zakres ograniczony do bazowej ścieżki turniejów. Skrypt jest kopiowany do folderu ukrytego podglądu w postbuild; nie przejmuje pozostałych sekcji strony i nie buforuje żądań. Kliknięcie powiadomienia otwiera tylko adres z jego własnego zakresu i domeny.
- Podgląd ma osobny manifest aplikacji z własnym identyfikatorem i adresem startowym. Po dodaniu do ekranu początkowego otwiera katalog podglądu. Publiczna strona zachowuje swój manifest; przejście poza podgląd przywraca poprzedni link. To nie dodaje trybu offline ani serwerowej wysyłki. [MDN: start_url](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Manifest/Reference/start_url), [scope](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Manifest/Reference/scope), [id](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Manifest/Reference/id).

Lokalny test potwierdza ścieżkę zgody i wyświetlania. Nie sprawdza jeszcze zdalnej dostawy po zamknięciu strony. Pokazanie powiadomienia podlega również ustawieniom systemu i trybowi skupienia. [Dokumentacja MDN: showNotification](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration/showNotification).

## Kolejny etap: rzeczywista wysyłka

1. HTTPS i zapis subskrypcji Push API po świadomej zgodzie użytkownika. Klucz prywatny VAPID wyłącznie na serwerze; endpointy subskrypcji nie mogą być publicznym katalogiem. Zdarzenie `push` jest obsługiwane przez service workera, także bez otwartej strony. [MDN: Push API](https://developer.mozilla.org/en-US/docs/Web/API/Push_API).
2. Zapis preferencji turniej/drużyny oraz typów powiadomień: mecz za kilka minut, rozpoczęcie, wynik końcowy, istotna zmiana godziny/boiska. Osobna opcja wyłączenia obserwowania i usunięcia subskrypcji.
3. Wiarygodne zdarzenia powstają po zatwierdzonym zapisie wyniku lub terminarza przez uprawnionego organizatora. Przeglądarka kibica nie może samodzielnie uruchamiać wysyłki do innych użytkowników.
4. Kolejka serwerowa z identyfikatorem zdarzenia, wersją meczu i deduplikacją na subskrypcję. Edycja godziny anuluje nieaktualne przypomnienia. Cofnięcie wyniku nie może pozostawić fałszywego komunikatu o awansie. Krótki TTL zapobiega późnemu dostarczeniu nieaktualnego przypomnienia; usuwamy wygasłe endpointy 404/410 i ograniczamy ponawianie prób.
5. Powiadomienie prowadzi do właściwego turnieju/meczu. `notificationclick` dopuszcza wyłącznie zaufaną domenę i ścieżkę, a otwarte okno może otrzymać fokus. [MDN: notificationclick](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerGlobalScope/notificationclick_event).
6. Przed turniejem test na Androidzie i iPhonie, przy zamkniętej karcie, odrzuconej zgodzie, utracie sieci i zmianie terminarza. Na iOS/iPadOS Web Push jest dostępny dla aplikacji dodanych do ekranu początkowego od wersji 16.4; zgoda musi wynikać z działania użytkownika. [WebKit: Web Push for Web Apps on iOS and iPadOS](https://webkit.org/blog/13878/web-push-for-web-apps-on-ios-and-ipados/).

Nie wprowadzono kluczy VAPID, zdalnych subskrypcji, migracji bazy ani automatycznej wysyłki do kibiców. Te elementy wymagają oddzielnej integracji i prób dostarczania; interfejs prototypu nie przedstawia ich jako już aktywnych.
