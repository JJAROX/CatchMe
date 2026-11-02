# Widok Procesu - Diagramy UML

Proces: Dodawanie nowej dyspozycyjności ("Dyspo") przez użytkownika.

## 1. Diagram Sekwencji (UML Sequence Diagram)
Przedstawia ułożony w czasie przebieg komunikacji pomiędzy aktorem a komponentami systemu.

```mermaid
sequenceDiagram
    actor U as Użytkownik
    participant V as AddDyspoView (iOS UI)
    participant VM as DashboardViewModel
    participant API as Node.js (Express API)
    participant DB as PostgreSQL

    U->>V: Wybiera strefę, intencję i czas trwania
    U->>V: Klika "Rzuć Dyspo"
    V->>VM: addMyDyspo(location, intent, duration)
    
    rect rgb(240, 248, 255)
    Note over VM,DB: Komunikacja sieciowa (Docelowa)
    VM->>API: HTTP POST /api/dyspo (JSON)
    API->>DB: INSERT INTO dyspos (...)
    DB-->>API: Status zapisu (Sukces)
    API-->>VM: HTTP 201 Created (Zwraca obiekt)
    end
    
    VM-->>V: Aktualizacja listy `activeDyspos` (@Published)
    V-->>U: Arkusz znika, nowe dyspo widoczne na liście

    
flowchart LR
    U((Użytkownik))
    V[AddDyspoView]
    VM[DashboardViewModel]
    API[Node.js API]
    DB[(PostgreSQL)]

    U -- "1: Wypełnia formularz" --> V
    V -- "2: addMyDyspo()" --> VM
    VM -- "3: POST /api/dyspo" --> API
    API -- "4: Wykonanie INSERT" --> DB
    DB -- "5: Potwierdzenie DB" --> API
    API -- "6: Zwraca odpowiedź 201" --> VM
    VM -- "7: Renderuje nowy stan" --> V    