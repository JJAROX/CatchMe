import SwiftUI

struct MainTabView: View {
    var onLogout: () -> Void
    @State private var selectedTab: AppTab = .home
    @StateObject private var appData = AppDataViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case .groups:
                    GroupsView()
                case .calendar:
                    CalendarView()
                case .home:
                    HomeView(onSeeAllGroups: { selectedTab = .groups })
                case .friends:
                    FriendsView()
                case .settings:
                    SettingsView(onLogout: onLogout)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CatchMeTabBar(selectedTab: $selectedTab)
        }
        .environmentObject(appData)
        .background(CatchMeTheme.background)
        .task {
            await appData.loadAll()
        }
    }
}
