import SwiftUI

struct HomeView: View {
    var onSeeAllGroups: () -> Void
    @EnvironmentObject var appData: AppDataViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                CatchMeTopHeader(initials: "AN")
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cześć Ania")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    Text("Dobry dzień na spotkanie.")
                        .font(.system(size: 14))
                        .foregroundColor(CatchMeTheme.textSecondary)
                }
                
                if appData.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Ładowanie danych z bazy...")
                            .tint(CatchMeTheme.primaryGreen)
                        Spacer()
                    }
                    .padding(.vertical, 40)
                } else if let error = appData.errorMessage {
                    ErrorStateCard(message: error) {
                        Task { await appData.loadAll() }
                    }
                } else {
                    // Nadchodzące spotkania
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Nadchodzące spotkania")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(CatchMeTheme.textPrimary)
                            
                            Spacer()
                            
                            Text("\(appData.meetings.count)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(CatchMeTheme.primaryGreen)
                                .frame(width: 24, height: 24)
                                .background(CatchMeTheme.softGreen)
                                .clipShape(Circle())
                        }
                        
                        if appData.meetings.isEmpty {
                            EmptyStateCard(
                                icon: "calendar.badge.clock",
                                title: "Brak nadchodzących spotkań",
                                subtitle: "Wybierz grupę lub otwórz Kalendarz, aby zaplanować wspólny termin."
                            )
                        } else {
                            VStack(spacing: 10) {
                                ForEach(appData.meetings) { meeting in
                                    MeetingCardRow(meeting: meeting)
                                }
                            }
                        }
                    }
                    
                    // Twoje grupy
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Twoje grupy")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(CatchMeTheme.textPrimary)
                            
                            Spacer()
                            
                            Button("Zobacz wszystkie", action: onSeeAllGroups)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(CatchMeTheme.primaryGreen)
                        }
                        
                        if appData.groups.isEmpty {
                            EmptyStateCard(
                                icon: "person.2",
                                title: "Nie masz jeszcze grup",
                                subtitle: "Przejdź do zakładki Grupy i utwórz swoją pierwszą ekipę."
                            )
                        } else {
                            HStack(spacing: 12) {
                                ForEach(appData.groups.prefix(2)) { group in
                                    HomeGroupCard(group: group)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .refreshable {
            await appData.loadAll()
        }
        .background(CatchMeTheme.background)
    }
}

struct MeetingCardRow: View {
    let meeting: MeetingModel
    
    var body: some View {
        HStack(spacing: 14) {
            VStack(spacing: 2) {
                Text(meeting.dayLabel)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(meeting.isHighlighted ? CatchMeTheme.primaryGreen : CatchMeTheme.textPrimary)
                Text(meeting.monthLabel)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(CatchMeTheme.textSecondary)
            }
            .frame(width: 50, height: 54)
            .background(meeting.isHighlighted ? CatchMeTheme.softGreen : CatchMeTheme.surfaceGray)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meeting.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(CatchMeTheme.textPrimary)
                
                Text(meeting.details)
                    .font(.system(size: 12))
                    .foregroundColor(CatchMeTheme.textSecondary)
                
                HStack(spacing: 5) {
                    Circle()
                        .fill(CatchMeTheme.primaryGreen)
                        .frame(width: 5, height: 5)
                    Text(meeting.groupName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(CatchMeTheme.primaryGreen)
                }
            }
            
            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(meeting.isHighlighted ? CatchMeTheme.softGreenBorder : CatchMeTheme.borderGray, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

struct HomeGroupCard: View {
    let group: GroupModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Image(systemName: group.icon)
                    .font(.system(size: 16))
                    .foregroundColor(group.iconFg)
                    .frame(width: 38, height: 38)
                    .background(group.iconBg)
                    .cornerRadius(10)
                
                Spacer()
                
                Circle()
                    .fill(CatchMeTheme.primaryGreen)
                    .frame(width: 6, height: 6)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(CatchMeTheme.textPrimary)
                    .lineLimit(1)
                
                Text("\(group.membersCount) członków")
                    .font(.system(size: 12))
                    .foregroundColor(CatchMeTheme.textSecondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(CatchMeTheme.borderGray, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}
