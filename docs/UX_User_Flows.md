# User Flows i Stany Systemu — Aplikacja CatchMe

Dokument prezentuje pełne schematy ścieżek użytkownika (sukcesy oraz obsługę błędów), zdefiniowane stany systemu (**ładowanie**, **stan pusty**, **stan błędu**) oraz bezpośrednie powiązanie każdego kroku z makietami High-Fidelity.

**Legenda kolorów na diagramach:**
* **Zielony** — ekrany High-Fi i stany sukcesu
* **Niebieski** — stany ładowania (komunikacja z API / PostgreSQL)
* **Żółty** — stany puste (brak danych)
* **Czerwony** — stany błędne i walidacja

---

## Flow 1: Autoryzacja, Rejestracja i Reset Hasła

Obejmuje makiety: **Ekran logowania**, **Rejestracja**, **Resetowanie hasła**, **Ekran główny**.

```mermaid
flowchart TD
    Start(["Uruchomienie aplikacji CatchMe"]) --> SessionCheck{"Czy istnieje aktywna sesja?"}
    SessionCheck -- "Tak" --> LoadHome["Stan ładowania: Pobieranie danych użytkownika"]
    SessionCheck -- "Nie" --> Login["Makieta: Ekran logowania"]

    %% Ścieżka logowania
    Login --> LoginAction{"Akcja użytkownika"}
    LoginAction -- "Wpisuje dane i klika Zaloguj się" --> LoginVal{"Walidacja pól lokalna"}
    LoginVal -- "Puste pola / zły format" --> LoginValErr["Stan błędu: Uzupełnij wymagane pola"]
    LoginValErr --> Login
    LoginVal -- "Poprawne" --> LoginLoad["Stan ładowania: POST /api/auth/login"]
    LoginLoad --> LoginRes{"Odpowiedź serwera"}
    LoginRes -- "200 OK" --> LoadHome
    LoginRes -- "401 Błędne dane" --> LoginAuthErr["Stan błędu: Nieprawidłowy e-mail lub hasło"]
    LoginRes -- "Błąd sieci / 500" --> LoginNetErr["Stan błędu: Brak połączenia — Spróbuj ponownie"]
    LoginAuthErr --> Login
    LoginNetErr --> Login

    %% Ścieżka rejestracji
    LoginAction -- "Klika Załóż konto" --> Register["Makieta: Rejestracja"]
    Register --> RegBack{"Akcja"}
    RegBack -- "Klika Zaloguj się" --> Login
    RegBack -- "Klika Utwórz konto" --> RegVal{"Walidacja: imię, e-mail, hasło >= 8 znaków"}
    RegVal -- "Błąd walidacji" --> RegValErr["Stan błędu: Hasło musi mieć min. 8 znaków / poprawny e-mail"]
    RegValErr --> Register
    RegVal -- "Poprawne" --> RegLoad["Stan ładowania: POST /api/auth/register"]
    RegLoad --> RegRes{"Odpowiedź serwera"}
    RegRes -- "201 Created" --> LoadHome
    RegRes -- "409 E-mail zajęty" --> RegDupErr["Stan błędu: Konto z tym adresem już istnieje"]
    RegRes -- "Błąd sieci / 500" --> RegNetErr["Stan błędu: Nie udało się utworzyć konta"]
    RegDupErr --> Register
    RegNetErr --> Register

    %% Ścieżka resetu hasła
    LoginAction -- "Klika Zapomniałem hasła" --> Forgot["Makieta: Resetowanie hasła"]
    Forgot --> ForgotAction{"Akcja"}
    ForgotAction -- "Klika Wróć do logowania" --> Login
    ForgotAction -- "Klika Wyślij link do resetu" --> ForgotVal{"Poprawny e-mail?"}
    ForgotVal -- "Nie" --> ForgotErr["Stan błędu: Podaj poprawny adres e-mail"]
    ForgotErr --> Forgot
    ForgotVal -- "Tak" --> ForgotLoad["Stan ładowania: POST /api/auth/reset"]
    ForgotLoad --> ForgotRes{"Odpowiedź serwera"}
    ForgotRes -- "200 OK" --> ForgotOk["Sukces: Wysłano link na e-mail"] --> Login
    ForgotRes -- "Błąd sieci / 500" --> ForgotNetErr["Stan błędu: Nie udało się wysłać linku"] --> Forgot

    LoadHome --> Home["Makieta: Ekran główny"]

    classDef screen fill:#EAF3EE,stroke:#2F6652,color:#1C2420,stroke-width:1.5px;
    classDef loading fill:#E8F1FA,stroke:#3A6EA5,color:#1C2420;
    classDef error fill:#FDECEC,stroke:#C93B3B,color:#7A1C1C;
    class Login,Register,Forgot,Home,ForgotOk screen;
    class LoadHome,LoginLoad,RegLoad,ForgotLoad loading;
    class LoginValErr,LoginAuthErr,LoginNetErr,RegValErr,RegDupErr,RegNetErr,ForgotErr,ForgotNetErr error;
```

---

## Flow 2: Ekran główny, Grupy, Znajomi oraz Ustawienia i Integracje

Obejmuje makiety: **Ekran główny**, **Grupy**, **Nowa grupa**, **Znajomi**, **Ustawienia**, **Integracje kalendarza**.

```mermaid
flowchart TD
    HomeLoad["Stan ładowania: GET /api/dashboard"] --> HomeRes{"Wynik"}
    HomeRes -- "Błąd sieci / 500" --> HomeErr["Stan błędu: Nie udało się pobrać danych + Spróbuj ponownie"]
    HomeErr --> HomeLoad
    HomeRes -- "Brak spotkań i grup" --> HomeEmpty["Stan pusty: Brak nadchodzących spotkań — Utwórz pierwszą grupę"]
    HomeRes -- "Sukces" --> Home["Makieta: Ekran główny"]
    HomeEmpty --> TabNav

    Home --> TabNav{"Nawigacja Dolny Pasek / Akcje"}

    %% Gałąź Grupy
    TabNav -- "Zakładka Grupy / Zobacz wszystkie" --> GroupsLoad["Stan ładowania: GET /api/groups"]
    GroupsLoad --> GroupsRes{"Wynik"}
    GroupsRes -- "Błąd" --> GroupsErr["Stan błędu: Błąd pobierania grup + Odśwież"] --> GroupsLoad
    GroupsRes -- "0 grup" --> GroupsEmpty["Stan pusty: Nie należysz jeszcze do żadnej grupy"]
    GroupsRes -- "Lista grup" --> Groups["Makieta: Grupy"]
    GroupsEmpty --> CreateGroup
    Groups -- "Wpisuje frazę w Szukaj grupy" --> GroupsSearch{"Czy znaleziono?"}
    GroupsSearch -- "Nie" --> GroupsSearchEmpty["Stan pusty: Brak grup pasujących do wyszukiwania"]
    GroupsSearch -- "Tak" --> Groups
    Groups -- "Klika Utwórz grupę" --> CreateGroup["Makieta: Nowa grupa"]
    CreateGroup -- "Klika Utwórz i wygeneruj link" --> CGVal{"Czy nazwa grupy niepusta?"}
    CGVal -- "Pusta" --> CGValErr["Stan błędu: Wpisz nazwę grupy"] --> CreateGroup
    CGVal -- "Poprawna" --> CGLoad["Stan ładowania: POST /api/groups"]
    CGLoad --> CGRes{"Odpowiedź DB"}
    CGRes -- "201 Created" --> CGLink["Sukces: Wyświetlenie i kopiowanie linku zaproszenia"] --> Groups
    CGRes -- "Błąd zapisu" --> CGErr["Stan błędu: Nie udało się zapisać grupy"] --> CreateGroup

    %% Gałąź Znajomi
    TabNav -- "Zakładka Znajomi" --> FriendsLoad["Stan ładowania: GET /api/friends"]
    FriendsLoad --> FriendsRes{"Wynik"}
    FriendsRes -- "Błąd" --> FriendsErr["Stan błędu: Nie udało się załadować znajomych"] --> FriendsLoad
    FriendsRes -- "Brak znajomych i zaproszeń" --> FriendsEmpty["Stan pusty: Zaproś znajomych do wspólnych planów"]
    FriendsRes -- "Sukces" --> Friends["Makieta: Znajomi"]
    Friends -- "Zaproszenie: Akceptuj / Odrzuć" --> InviteLoad["Stan ładowania: PATCH /api/friendships"]
    InviteLoad --> InviteRes{"Odpowiedź DB"}
    InviteRes -- "200 OK" --> Friends
    InviteRes -- "Błąd" --> InviteErr["Stan błędu: Nie udało się zaktualizować zaproszenia"] --> Friends

    %% Gałąź Ustawienia i Integracje
    TabNav -- "Zakładka Ustawienia" --> Settings["Makieta: Ustawienia"]
    Settings -- "Przełącza Powiadomienia / Przypomnienia" --> PrefSave["Zapis preferencji"]
    Settings -- "Klika Wyloguj się" --> Logout(["Powrót do: Ekran logowania"])
    Settings -- "Klika Integracje kalendarza" --> Integrations["Makieta: Integracje kalendarza"]
    Integrations -- "Klika Połącz z Google Calendar" --> OAuthLoad["Stan ładowania: Autoryzacja OAuth Google"]
    OAuthLoad --> OAuthRes{"Wynik OAuth"}
    OAuthRes -- "Zgoda i token zapisany" --> OAuthOk["Sukces: Połączono z Google Calendar"]
    OAuthRes -- "Anulowano / Błąd tokenu" --> OAuthErr["Stan błędu: Synchronizacja nie powiodła się"] --> Integrations

    classDef screen fill:#EAF3EE,stroke:#2F6652,color:#1C2420,stroke-width:1.5px;
    classDef loading fill:#E8F1FA,stroke:#3A6EA5,color:#1C2420;
    classDef empty fill:#FFF8E6,stroke:#C9932B,color:#5C4008;
    classDef error fill:#FDECEC,stroke:#C93B3B,color:#7A1C1C;
    class Home,Groups,CreateGroup,CGLink,Friends,Settings,Integrations,OAuthOk screen;
    class HomeLoad,GroupsLoad,CGLoad,FriendsLoad,InviteLoad,OAuthLoad loading;
    class HomeEmpty,GroupsEmpty,GroupsSearchEmpty,FriendsEmpty empty;
    class HomeErr,GroupsErr,CGValErr,CGErr,FriendsErr,InviteErr,OAuthErr error;
```

---

## Flow 3: Planowanie spotkania — Kalendarz, Szukaj terminu i Wybór lokalizacji

Obejmuje główny cel biznesowy aplikacji na makietach: **Kalendarz**, **Grupy**, **Szukaj terminu**, **Wybór lokalizacji**, **Ekran główny**.

```mermaid
flowchart TD
    Entry{"Wejście w planowanie"} -- "Zakładka Kalendarz" --> CalLoad["Stan ładowania: GET /api/meetings"]
    CalLoad --> CalRes{"Wynik"}
    CalRes -- "Błąd sieci / 500" --> CalErr["Stan błędu: Nie udało się załadować kalendarza"] --> CalLoad
    CalRes -- "Brak wydarzeń" --> CalEmpty["Stan pusty: Brak zaplanowanych spotkań w tym miesiącu"]
    CalRes -- "Sukces" --> Calendar["Makieta: Kalendarz"]
    CalEmpty --> Calendar

    Calendar -- "Klika przycisk +" --> FindTime["Makieta: Szukaj terminu"]
    Entry -- "Kliknięcie grupy w Makiecie: Grupy" --> FindTime

    FindTime -- "Wybiera przedział: Najbliższy weekend / Ten tydzień i klika Dopasuj wspólny czas" --> MatchLoad["Stan ładowania: POST /api/meetings/match-slots"]
    MatchLoad --> MatchRes{"Wynik algorytmu dopasowania"}
    MatchRes -- "Błąd API / brak synchronizacji" --> MatchErr["Stan błędu: Nie udało się obliczyć wspólnych terminów"] --> FindTime
    MatchRes -- "Brak pokrywających się okienek" --> MatchEmpty["Stan pusty: Brak wspólnego terminu — wybierz inny przedział"] --> FindTime
    MatchRes -- "Znaleziono propozycje np. 8 z 8 osób" --> SlotsList["Makieta: Szukaj terminu — Lista zaproponowanych terminów"]

    SlotsList -- "Wybiera termin np. Piątek 19:00" --> LocationVote["Makieta: Wybór lokalizacji"]
    LocationVote -- "Zaznacza opcję: Pub / Pizzeria / Plener i klika Oddaj głos" --> VoteVal{"Czy wybrano miejsce?"}
    VoteVal -- "Nie" --> VoteValErr["Stan błędu: Wybierz jedną lokalizację"] --> LocationVote
    VoteVal -- "Tak" --> VoteLoad["Stan ładowania: POST /api/meetings/vote"]
    VoteLoad --> VoteRes{"Odpowiedź PostgreSQL"}
    VoteRes -- "Błąd zapisu / 500" --> VoteErr["Stan błędu: Nie udało się zapisać głosu — Spróbuj ponownie"] --> LocationVote
    VoteRes -- "201 Created" --> VoteOk["Sukces: Głos zapisany, spotkanie dodane do harmonogramu"] --> HomeUpdated["Makieta: Ekran główny + Kalendarz zaktualizowane"]

    classDef screen fill:#EAF3EE,stroke:#2F6652,color:#1C2420,stroke-width:1.5px;
    classDef loading fill:#E8F1FA,stroke:#3A6EA5,color:#1C2420;
    classDef empty fill:#FFF8E6,stroke:#C9932B,color:#5C4008;
    classDef error fill:#FDECEC,stroke:#C93B3B,color:#7A1C1C;
    class Calendar,FindTime,SlotsList,LocationVote,VoteOk,HomeUpdated screen;
    class CalLoad,MatchLoad,VoteLoad loading;
    class CalEmpty,MatchEmpty empty;
    class CalErr,MatchErr,VoteValErr,VoteErr error;
```

---

## Zbiorcza macierz stanów systemu dla makiet High-Fi

| Makieta High-Fi | Stan ładowania (Loading) | Stan pusty (Empty) | Stan błędu (Error) | Stan sukcesu (Success) |
| :--- | :--- | :--- | :--- | :--- |
| **Ekran logowania** | Spinner wewnątrz przycisku *Zaloguj się*, zablokowane pola. | Domyślny pusty formularz przy pierwszym uruchomieniu. | Czerwona ramka pola + komunikat (*„Nieprawidłowy e-mail lub hasło”* / *„Brak sieci”*). | Przejście do **Ekranu głównego**. |
| **Rejestracja** | Spinner na przycisku *Utwórz konto*. | Pusty formularz z podpowiedzią *„Użyj co najmniej 8 znaków”*. | Komunikat walidacji (za krótkie hasło, zajęty e-mail). | Utworzenie rekordu w `users` i wejście do aplikacji. |
| **Resetowanie hasła** | Spinner na przycisku *Wyślij link do resetu*. | Puste pole *Adres e-mail*. | Niepoprawny format adresu lub błąd wysyłki z serwera. | Baner potwierdzający wysłanie linku i powrót do logowania. |
| **Ekran główny** | Karty szkieletowe (skeleton cards) w sekcjach *Nadchodzące spotkania* i *Twoje grupy*. | *„Brak nadchodzących spotkań”* + przycisk CTA *„Zaplanuj pierwsze spotkanie”*. | Karta błędu z przyciskiem *„Spróbuj ponownie”* (pull-to-refresh). | Wyświetlenie aktualnej liczby spotkań, kart wydarzeń i skrótów grup. |
| **Grupy** | Lista szkieletowa podczas pobierania `GET /api/groups`. | *„Nie masz jeszcze grup”* lub *„Brak wyników dla frazy...”* po wyszukiwaniu. | Komunikat błędu pobierania z przyciskiem odświeżenia. | Lista aktywnych grup z liczbą członków i najbliższym spotkaniem. |
| **Nowa grupa** | Spinner podczas `POST /api/groups`. | Podgląd placeholderowy linku (*„Podgląd po utworzeniu”*). | Walidacja pustej nazwy grupy lub błąd zapisu w PostgreSQL. | Wygenerowany aktywny link zaproszenia + ikona *checkmark* po skopiowaniu. |
| **Kalendarz** | Wskaźnik ładowania pod siatką dni przy zmianie miesiąca. | Brak kropek pod dniami + *„Brak spotkań w tym okresie”*. | Baner błędu synchronizacji wydarzeń z opcją ponowienia. | Zaznaczony aktywny dzień, kropki wydarzeń i pełna lista spotkań. |
| **Szukaj terminu** | Spinner w przycisku *Dopasuj wspólny czas* + placeholder propozycji. | *„Nie znaleziono wspólnych okienek w wybranym przedziale — zmień zakres”*. | Błąd obliczania dostępności (np. brak połączenia z backendem). | Posortowana lista terminów z etykietą *„Najlepszy termin”* i frekwencją. |
| **Wybór lokalizacji** | Spinner na przycisku *Oddaj głos* przy zapisie do bazy. | Brak wybranej opcji (przycisk *Oddaj głos* nieaktywny). | Komunikat *„Nie udało się zapisać głosu — spróbuj ponownie”*. | Potwierdzenie *„Głos oddany na: ...”* i aktualizacja wydarzenia. |
| **Znajomi** | Skeleton loader dla zaproszeń i listy znajomych. | Ukryta sekcja *Zaproszenia* (gdy 0 nowych); *„Brak znajomych — dodaj pierwszą osobę”*. | Błąd przy akceptacji/odrzuceniu zaproszenia lub brak sieci. | Lista znajomych; po kliknięciu *Akceptuj* płynne przeniesienie osoby na listę. |
| **Ustawienia** | Subtelny wskaźnik przy zapisie zmian preferencji. | Brak danych (nie dotyczy zalogowanego konta). | Błąd zapisu preferencji z cofnięciem stanu przełącznika. | Zapisane ustawienia powiadomień lub poprawne wylogowanie. |
| **Integracje kalendarza** | Ekran pośredni podczas logowania OAuth do Google Calendar. | Status *„Kalendarz nie jest jeszcze połączony”*. | Komunikat *„Nie udało się połączyć z Google Calendar — spróbuj ponownie”*. | Zielony status *„Połączono z Google Calendar”* i opcja odłączenia. |