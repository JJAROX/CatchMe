import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var appData: AppDataViewModel
    @State private var selectedDay = 18
    
    private let weekDays = ["Pn", "Wt", "Śr", "Cz", "Pt", "So", "Nd"]
    private let calendarDays: [(day: Int, inCurrentMonth: Bool)] = [
        (28, false), (29, false), (30, false), (1, true), (2, true), (3, true), (4, true),
        (5, true), (6, true), (7, true), (8, true), (9, true), (10, true), (11, true),
        (12, true), (13, true), (14, true), (15, true), (16, true), (17, true), (18, true),
        (19, true), (20, true), (21, true), (22, true), (23, true), (24, true), (25, true),
        (26, true), (27, true), (28, true), (29, true), (30, true), (31, true), (1, false)
    ]
    
    private var eventDays: Set<Int> {
        Set(appData.meetings.compactMap { Int($0.dayLabel) })
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    CatchMeTopHeader(initials: "AN")
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Kalendarz")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(CatchMeTheme.textPrimary)
                            
                            Text("Zaplanuj czas dla swoich ludzi.")
                                .font(.system(size: 14))
                                .foregroundColor(CatchMeTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            FindTimeView(groupName: appData.groups.first?.name ?? "Planszówkowa ekipa")
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(CatchMeTheme.primaryGreen)
                                .frame(width: 38, height: 38)
                                .background(CatchMeTheme.softGreen)
                                .cornerRadius(10)
                        }
                    }
                    
                    // Karta kalendarza miesięcznego
                    VStack(spacing: 14) {
                        HStack {
                            Text("Październik 2026")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(CatchMeTheme.textPrimary)
                            
                            Spacer()
                            
                            HStack(spacing: 16) {
                                Image(systemName: "chevron.left")
                                Image(systemName: "chevron.right")
                            }
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(CatchMeTheme.textSecondary)
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                            ForEach(weekDays, id: \.self) { day in
                                Text(day)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(CatchMeTheme.textSecondary)
                            }
                            
                            ForEach(Array(calendarDays.enumerated()), id: \.offset) { _, item in
                                let isSelected = item.inCurrentMonth && item.day == selectedDay
                                let hasEvent = item.inCurrentMonth && eventDays.contains(item.day)
                                
                                Button {
                                    if item.inCurrentMonth { selectedDay = item.day }
                                } label: {
                                    VStack(spacing: 2) {
                                        Text("\(item.day)")
                                            .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                                            .foregroundColor(
                                                isSelected ? .white :
                                                    (item.inCurrentMonth ? CatchMeTheme.textPrimary : CatchMeTheme.borderGray)
                                            )
                                            .frame(width: 32, height: 32)
                                            .background(isSelected ? CatchMeTheme.primaryGreen : Color.clear)
                                            .clipShape(Circle())
                                        
                                        Circle()
                                            .fill(hasEvent && !isSelected ? CatchMeTheme.primaryGreen : Color.clear)
                                            .frame(width: 4, height: 4)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(CatchMeTheme.borderGray, lineWidth: 1)
                    )
                    .cornerRadius(16)
                    
                    HStack {
                        Text("Nadchodzące spotkania")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(CatchMeTheme.textPrimary)
                        
                        Spacer()
                        
                        Text("\(appData.meetings.count) spotkania")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(CatchMeTheme.primaryGreen)
                    }
                    
                    if appData.isLoading {
                        ProgressView().tint(CatchMeTheme.primaryGreen)
                            .frame(maxWidth: .infinity)
                    } else if let error = appData.errorMessage {
                        ErrorStateCard(message: error) {
                            Task { await appData.loadAll() }
                        }
                    } else if appData.meetings.isEmpty {
                        EmptyStateCard(
                            icon: "calendar",
                            title: "Brak zaplanowanych spotkań",
                            subtitle: "Kliknij przycisk +, aby dopasować termin i oddać głos."
                        )
                    } else {
                        VStack(spacing: 10) {
                            ForEach(appData.meetings) { meeting in
                                MeetingCardRow(meeting: meeting)
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
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
