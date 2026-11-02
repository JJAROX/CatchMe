# Widok logiczny (UML Class Diagram) - Architektura MVVM

Poniższy diagram przedstawia relacje między komponentami w zaimplementowanej historii użytkownika (MVP).

```mermaid
classDiagram
    %% Deklaracja Klas
    class Dyspo {
        +UUID id
        +String userName
        +String locationZone
        +String intentIcon
        +Date endTime
        +Bool isActive
    }

    class DashboardViewModel {
        +List~Dyspo~ activeDyspos
        +loadMockData() void
        +addMyDyspo(location: String, intent: String, duration: Double) void
    }

    class ContentView {
        -DashboardViewModel viewModel
        -Bool showingAddSheet
        +body View
    }

    class AddDyspoView {
        -DashboardViewModel viewModel
        -String selectedZone
        -String selectedIntent
        -Double duration
        +body View
    }

    class DyspoRow {
        +Dyspo dyspo
        +body View
    }

    %% Relacje
    ContentView ..> DashboardViewModel : obserwuje (@StateObject)
    AddDyspoView ..> DashboardViewModel : modyfikuje (@ObservedObject)
    ContentView *-- DyspoRow : renderuje
    DyspoRow --> Dyspo : wyświetla dane
    DashboardViewModel "1" *-- "*" Dyspo : zarządza (Kolekcja)