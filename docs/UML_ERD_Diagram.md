# Diagram Modelu Danych (ERD)

Przedstawia encje w relacyjnej bazie danych PostgreSQL oraz powiązania między nimi.

```mermaid
erDiagram
    USER ||--o{ DYSPO : "tworzy (1:N)"
    USER ||--o{ FRIENDSHIP : "nawiązuje (1:N)"
    
    USER {
        uuid id PK
        string full_name
        string email
        string oauth_provider
        datetime created_at
    }
    
    DYSPO {
        uuid id PK
        uuid user_id FK
        string location_zone
        string intent_icon
        datetime start_time
        datetime end_time
    }
    
    FRIENDSHIP {
        uuid id PK
        uuid user_id FK
        uuid friend_id FK
        string status "np. pending, accepted"
    }