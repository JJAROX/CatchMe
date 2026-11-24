import SwiftUI

struct ProposedSlot: Identifiable {
    let id = UUID()
    let title: String
    let dateSubtitle: String
    let attendance: String
    let isBest: Bool
}

struct FindTimeView: View {
    let groupName: String
    @State private var selectedRangeIndex = 0
    
    private let proposedSlots: [ProposedSlot] = [
        ProposedSlot(title: "Piątek 19:00", dateSubtitle: "23 października", attendance: "8 z 8 osób", isBest: true),
        ProposedSlot(title: "Sobota 18:30", dateSubtitle: "24 października", attendance: "7 z 8 osób", isBest: false),
        ProposedSlot(title: "Niedziela 16:00", dateSubtitle: "25 października", attendance: "6 z 8 osób", isBest: false)
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                CatchMeBackHeader(title: "Szukaj terminu")
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Kiedy się widzimy?")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    Text("Znajdź termin, który pasuje Waszej ekipie.")
                        .font(.system(size: 14))
                        .foregroundColor(CatchMeTheme.textSecondary)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Wybierz przedział czasowy")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    HStack(spacing: 12) {
                        TimeRangeCard(
                            dates: "23–25 paź",
                            label: "Najbliższy weekend",
                            isSelected: selectedRangeIndex == 0
                        ) {
                            selectedRangeIndex = 0
                        }
                        
                        TimeRangeCard(
                            dates: "19–25 paź",
                            label: "Ten tydzień",
                            isSelected: selectedRangeIndex == 1
                        ) {
                            selectedRangeIndex = 1
                        }
                    }
                }
                
                PrimaryButton(title: "Dopasuj wspólny czas") {
                    // W kolejnym kroku: strzał do API analizującego dostępne okienka
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Zaproponowane terminy")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(CatchMeTheme.textPrimary)
                        
                        Spacer()
                        
                        Text("\(proposedSlots.count)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(CatchMeTheme.primaryGreen)
                    }
                    
                    VStack(spacing: 10) {
                        ForEach(proposedSlots) { slot in
                            NavigationLink {
                                LocationVoteView(slotTitle: slot.title, dateShort: "23 paź", groupName: groupName)
                            } label: {
                                ProposedSlotRow(slot: slot)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    Text("Na podstawie dostępności 8 osób z grupy.")
                        .font(.system(size: 12))
                        .foregroundColor(CatchMeTheme.textSecondary)
                        .padding(.top, 2)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(CatchMeTheme.background)
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct TimeRangeCard: View {
    let dates: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(dates)
                        .font(.system(size: 12))
                        .foregroundColor(CatchMeTheme.textSecondary)
                    
                    Spacer()
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 16))
                        .foregroundColor(isSelected ? CatchMeTheme.primaryGreen : CatchMeTheme.borderGray)
                }
                
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? CatchMeTheme.primaryGreen : CatchMeTheme.textPrimary)
                    .lineLimit(1)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? CatchMeTheme.softGreen : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? CatchMeTheme.primaryGreen : CatchMeTheme.borderGray, lineWidth: 1)
            )
            .cornerRadius(14)
        }
        .buttonStyle(.plain)
    }
}

struct ProposedSlotRow: View {
    let slot: ProposedSlot
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock")
                .font(.system(size: 16))
                .foregroundColor(slot.isBest ? CatchMeTheme.primaryGreen : CatchMeTheme.textSecondary)
                .frame(width: 40, height: 40)
                .background(slot.isBest ? CatchMeTheme.softGreen : CatchMeTheme.surfaceGray)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(slot.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(CatchMeTheme.textPrimary)
                
                Text(slot.dateSubtitle)
                    .font(.system(size: 12))
                    .foregroundColor(CatchMeTheme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                if slot.isBest {
                    Text("Najlepszy termin")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(CatchMeTheme.primaryGreen)
                }
                Text(slot.attendance)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(slot.isBest ? CatchMeTheme.primaryGreen : CatchMeTheme.textSecondary)
            }
        }
        .padding(14)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(slot.isBest ? CatchMeTheme.softGreenBorder : CatchMeTheme.borderGray, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}
