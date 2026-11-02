# Diagram Przepływu Danych (DFD - Poziom 1)

Przedstawia przepływ informacji pomiędzy aktorem, głównymi procesami systemu a magazynami danych (bazą).

```mermaid
flowchart TD
    User((Użytkownik\nStudent))
    
    subgraph System CatchMe
        P1((1. Zarządzanie\nProfilem))
        P2((2. Przetwarzanie\nDyspo))
        P3((3. Wyszukiwanie\nPokryć Czasowych))
    end

    D1[(D1: Baza Użytkowników)]
    D2[(D2: Baza Dyspozycji)]

    User -- "Dane autoryzacyjne (OAuth)" --> P1
    P1 -- "Zapis/Odczyt" --> D1
    P1 -- "Token sesji" --> User

    User -- "Czas, Strefa, Intencja" --> P2
    P2 -- "Zapis nowego rekordu" --> D2
    
    User -- "Żądanie odświeżenia tablicy" --> P3
    P3 -- "Pytanie o aktywne okienka" --> D2
    D2 -- "Zwrócenie pasujących rekordów" --> P3
    P3 -- "Lista znajomych w okolicy" --> User