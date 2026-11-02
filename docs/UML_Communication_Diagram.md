```markdown
# Diagram Komunikacji (UML Communication Diagram)

Przedstawia strukturalny przepływ komunikatów (numerowanych sekwencyjnie) pomiędzy współpracującymi obiektami.

```mermaid
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