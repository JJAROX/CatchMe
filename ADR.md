# Rejestr Decyzji Architektonicznych (ADR) - Projekt CatchMe

## ADR 1: Wybór architektury warstwy klienckiej (iOS)

**Data:** 2 Listopada 2026
**Status:** Zaakceptowano

### Kontekst
Aplikacja kliencka tworzona jest natywnie dla systemu iOS przy użyciu frameworka SwiftUI. Konieczne było zdefiniowanie wzorca architektonicznego, który zapewni wysoką testowalność (wymaganą w specyfikacji projektu), separację logiki biznesowej od widoków oraz łatwość współbieżnego tworzenia interfejsu i komunikacji z API (Node.js).

### Decyzja
Zdecydowano o zastosowaniu wzorca **MVVM (Model-View-ViewModel)**. 
- **Model:** Struktury danych (np. `Dyspo`) reprezentujące encje i prostą walidację.
- **View:** Widoki w SwiftUI (np. `ContentView`, `AddDyspoView`) odpowiedzialne wyłącznie za warstwę prezentacji.
- **ViewModel:** Klasy konformujące do `ObservableObject` (np. `DashboardViewModel`), zarządzające stanem aplikacji i komunikujące się z backendem.

### Konsekwencje
**Zalety:**
* Pełna zgodność z deklaratywnym charakterem SwiftUI (wykorzystanie `@StateObject`, `@Published`).
* Czysty podział obowiązków ułatwiający tworzenie testów jednostkowych dla logiki (testujemy sam ViewModel, ignorując renderowanie UI).
* Mniejsza zależność widoków od formatowania danych wejściowych z API.

**Wady:**
* Konieczność tworzenia dodatkowych klas pośredniczących (ViewModeli) nawet dla najprostszych ekranów.
* Ryzyko rozrostu plików ViewModel do tzw. "Massive View Model", co będzie wymagało rygorystycznego podziału na serwisy sieciowe w przyszłości.