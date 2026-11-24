# User Journey — Aplikacja CatchMe

Dokument definiuje dwie główne Persony aplikacji **CatchMe** oraz pełne mapy ich podróży do kluczowych celów biznesowych, powiązane bezpośrednio z makietami High-Fidelity.

---

## Persona 1: Anna Nowak (Organizatorka)

* **Wiek / Rola:** 23 lata, studentka, nieformalna „koordynatorka” spotkań w swojej grupie znajomych.
* **Kontekst:** Korzysta z Kalendarza Google (zajęcia, praca dorywcza, treningi), organizuje wyjścia ze znajomymi na kawę, planszówki i spacery.
* **Główny cel biznesowy:** Założenie grupy znajomych, automatyczne znalezienie wspólnego wolnego terminu bez przekopywania się przez dziesiątki wiadomości na czacie oraz szybki wybór miejsca spotkania.
* **Główne frustracje przed użyciem aplikacji:** Niekończące się ankiety na komunikatorach, brak odpowiedzi od części grupy, ręczne porównywanie grafików.

### Mapa podróży (User Journey) — Anna Nowak

| Etap podróży | Działania i kroki użytkownika | Touchpoint (Makieta High-Fi) | Nastawienie | Punkty bólu (Pain Points) | Szanse (Opportunities) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1. Wejście i rejestracja** | Pobiera aplikację, wpisuje imię, adres e-mail i hasło (min. 8 znaków), akceptuje regulamin i zakłada konto. | **Rejestracja** *(alternatywnie: **Ekran logowania**)* | Ciekawość, chęć szybkiego startu | Konieczność ręcznego wpisywania danych i pilnowania wymogów hasła; obawa przed długim onboardingiem. | Minimalistyczny formularz (3 pola), wyraźny podgląd hasła (ikona oka), w przyszłości szybkie logowanie Apple/Google. |
| **2. Synchronizacja kalendarza** | Wchodzi w ustawienia konta i łączy aplikację z Google Calendar, aby nie wpisywać dostępności ręcznie. | **Ustawienia** → **Integracje kalendarza** | Ostrożność (obawa o prywatność) | Strach, że znajomi zobaczą prywatne nazwy wydarzeń (np. wizyta u lekarza, randka). | Jawny komunikat zaufania (*„Twoje plany zostają Twoje — grupa zobaczy tylko dostępność”*) oraz możliwość odłączenia jednym kliknięciem. |
| **3. Utworzenie grupy i zaproszenie ekipy** | Przechodzi do zakładki grup, klika „Utwórz grupę”, podaje nazwę (np. *Planszówkowa ekipa*), generuje link i kopiuje go do schowka, by wysłać znajomym. | **Ekran główny** → **Grupy** → **Nowa grupa** | Zaangażowanie, motywacja | Ręczne dodawanie każdej osoby po mailu zniechęcałoby organizatora; obawa, że do grupy dołączy ktoś obcy. | Jedno kliknięcie do wygenerowania i skopiowania linku (`catchme.app/join/...`) oraz jasna informacja o prywatności (*„Do grupy dołączą tylko osoby z linkiem”*). |
| **4. Znalezienie wspólnego terminu** | Wybiera grupę lub ikonę `+` w kalendarzu, wskazuje przedział (*Najbliższy weekend* lub *Ten tydzień*) i uruchamia dopasowanie wspólnego czasu. | **Kalendarz** → **Szukaj terminu** | Ulga, oczekiwanie na wynik | Ryzyko, że nikomu nie pasuje ten sam dzień lub dane z kalendarzy są nieaktualne. | Ranking proponowanych slotów z liczbą dostępnych osób (*„8 z 8 osób”*) oraz wyraźne oznaczenie *„Najlepszy termin”*. |
| **5. Wybór lokalizacji i potwierdzenie** | Klika najlepszy termin, przegląda kategorie miejsc (*Pub*, *Pizzeria*, *Plener / Park*), oddaje głos i wraca na ekran główny, gdzie widzi nadchodzące spotkanie. | **Wybór lokalizacji** → **Ekran główny** | Satysfakcja, poczucie sprawczości | Długie dyskusje „gdzie idziemy?” potrafią zabić nawet ustalony termin. | Proste głosowanie jednokrotnego wyboru z gotowymi kategoriami i natychmiastowe podsumowanie na karcie *Nadchodzące spotkania*. |

---

## Persona 2: Michał Kamiński (Uczestnik / Zapracowany znajomy)

* **Wiek / Rola:** 24 lata, student pracujący na część etatu, aktywny sportowo (grupa *Aktywnie w Warszawie*).
* **Kontekst:** Ma mało wolnego czasu i często zapomina hasła do rzadziej używanych aplikacji; nie lubi organizować spotkań, ale chętnie dołącza, gdy dostanie konkretną propozycję.
* **Główny cel biznesowy:** Szybkie odzyskanie dostępu do konta, zaakceptowanie zaproszenia od znajomych, zagłosowanie na miejsce i upewnienie się, że nie przegapi spotkania.
* **Główne frustracje przed użyciem aplikacji:** Przegapianie ustaleń w zalewie wiadomości grupowych, brak przypomnień, zbyt skomplikowane narzędzia do planowania.

### Mapa podróży (User Journey) — Michał Kamiński

| Etap podróży | Działania i kroki użytkownika | Touchpoint (Makieta High-Fi) | Nastawienie | Punkty bólu (Pain Points) | Szanse (Opportunities) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1. Powrót i odzyskanie konta** | Otwiera aplikację po dłuższym czasie, nie pamięta hasła, klika „Zapomniałem hasła”, podaje e-mail i resetuje dostęp. | **Ekran logowania** → **Resetowanie hasła** | Lekka irytacja | Przerwanie głównego zadania przez zablokowane logowanie; obawa, że link nie przyjdzie. | Prosty ekran resetu z jednym polem e-mail, jasnym komunikatem zwrotnym i natychmiastowym powrotem do logowania. |
| **2. Akceptacja relacji ze znajomymi** | Otwiera zakładkę Znajomi, widzi oczekujące zaproszenie (z informacją z jakiej jest grupy) i klika „Akceptuj”. | **Znajomi** | Pozytywne zaskoczenie | Brak kontekstu przy zaproszeniu od osoby o popularnym nazwisku utrudnia decyzję. | Wyświetlanie wspólnej grupy pod nazwiskiem (*„Z grupy Aktywnie w Warszawie”*) i przyciski akcji *Akceptuj / Odrzuć* bezpośrednio na karcie. |
| **3. Udostępnienie dostępności** | Sprawdza ustawienia powiadomień oraz łączy swój kalendarz, żeby aplikacja automatycznie brała pod uwagę jego wolne okienka. | **Ustawienia** → **Integracje kalendarza** | Spokój, pragmatyzm | Zbyt nachalne powiadomienia albo brak przypomnienia w dniu spotkania. | Oddzielne przełączniki dla *Powiadomień* oraz *Przypomnień o spotkaniach* oraz bezobsługowa synchronizacja zajętości. |
| **4. Szybki głos na miejsce spotkania** | Otrzymuje info o dopasowanym terminie, sprawdza podsumowanie (*Spotkanie: Piątek, 19:00*), wybiera opcję (np. *Pizzeria*) i klika „Oddaj głos”. | **Wybór lokalizacji** | Wygoda, brak wysiłku | Brak czasu na czytanie dyskusji i porównywanie lokali w kilku aplikacjach. | Decyzja zredukowana do 2 kliknięć: zaznaczenie kafelka + przycisk *Oddaj głos* z czytelnym podsumowaniem u dołu. |
| **5. Śledzenie planu tygodnia** | Sprawdza na pulpicie oraz w widoku miesięcznym kalendarza wszystkie potwierdzone spotkania wraz z godziną i lokalizacją. | **Ekran główny** → **Kalendarz** | Pewność, kontrola nad czasem | Zapominanie szczegółów spotkania (godzina, adres, z którą ekipą się widzi). | Jedna spójna karta wydarzenia (data, godzina, miejsce, kolorowa kropka grupy) oraz oznaczenia dni z wydarzeniami w kalendarzu. |