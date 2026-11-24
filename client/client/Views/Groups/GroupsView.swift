import SwiftUI

struct GroupsView: View {
    @EnvironmentObject var appData: AppDataViewModel
    @State private var searchText = ""
    
    var filteredGroups: [GroupModel] {
        if searchText.isEmpty { return appData.groups }
        return appData.groups.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    CatchMeTopHeader(initials: "AN")
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Grupy")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(CatchMeTheme.textPrimary)
                        
                        Text("Wspólne pasje. Wspólne plany.")
                            .font(.system(size: 14))
                            .foregroundColor(CatchMeTheme.textSecondary)
                    }
                    
                    CatchMeSearchBar(placeholder: "Szukaj grupy", text: $searchText)
                    
                    if appData.isLoading {
                        HStack {
                            Spacer()
                            ProgressView("Pobieranie grup...")
                                .tint(CatchMeTheme.primaryGreen)
                            Spacer()
                        }
                        .padding(.vertical, 30)
                    } else if let error = appData.errorMessage {
                        ErrorStateCard(message: error) {
                            Task { await appData.loadAll() }
                        }
                    } else {
                        HStack {
                            Text("Twoje grupy")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(CatchMeTheme.textPrimary)
                            
                            Spacer()
                            
                            Text("\(filteredGroups.count) grupy")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(CatchMeTheme.primaryGreen)
                        }
                        
                        if filteredGroups.isEmpty {
                            EmptyStateCard(
                                icon: "magnifyingglass",
                                title: searchText.isEmpty ? "Brak grup" : "Nic nie znaleziono",
                                subtitle: searchText.isEmpty
                                    ? "Utwórz pierwszą grupę poniżej i wyślij link znajomym."
                                    : "Żadna grupa nie pasuje do frazy „\(searchText)”."
                            )
                        } else {
                            VStack(spacing: 12) {
                                ForEach(filteredGroups) { group in
                                    NavigationLink {
                                        FindTimeView(groupName: group.name)
                                    } label: {
                                        GroupListCard(group: group)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    
                    NavigationLink {
                        CreateGroupView()
                    } label: {
                        Text("Utwórz grupę")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(CatchMeTheme.primaryGreen)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(CatchMeTheme.softGreen)
                            .cornerRadius(12)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .refreshable {
                await appData.loadAll()
            }
            .background(CatchMeTheme.background)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct GroupListCard: View {
    let group: GroupModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: group.icon)
                    .font(.system(size: 17))
                    .foregroundColor(group.iconFg)
                    .frame(width: 40, height: 40)
                    .background(group.iconBg)
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(group.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    Text("\(group.membersCount) członków")
                        .font(.system(size: 12))
                        .foregroundColor(CatchMeTheme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(CatchMeTheme.textSecondary)
            }
            
            Text(group.nextMeeting)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(CatchMeTheme.primaryGreen)
        }
        .padding(14)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(CatchMeTheme.borderGray, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}
