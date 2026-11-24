import SwiftUI

struct LocationOption: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let icon: String
}

struct LocationVoteView: View {
    let slotTitle: String
    let dateShort: String
    let groupName: String
    
    @EnvironmentObject var appData: AppDataViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOptionName = "Pizzeria"
    @State private var hasVoted = false
    @State private var voteError: String?
    
    private let options: [LocationOption] = [
        LocationOption(name: "Pub", subtitle: "Swobodnie, przy dobrych rozmowach", icon: "wineglass"),
        LocationOption(name: "Pizzeria", subtitle: "Wspólny stół i ulubiona pizza", icon: "fork.knife"),
        LocationOption(name: "Plener / Park", subtitle: "Trochę zieleni i świeżego powietrza", icon: "leaf")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            CatchMeBackHeader(title: "Wybór lokalizacji")
            
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 16))
                    .foregroundColor(CatchMeTheme.primaryGreen)
                    .frame(width: 38, height: 38)
                    .background(CatchMeTheme.softGreen)
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Spotkanie: \(slotTitle)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    Text("\(dateShort) · \(groupName)")
                        .font(.system(size: 12))
                        .foregroundColor(CatchMeTheme.textSecondary)
                }
                
                Spacer()
            }
            .padding(14)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(CatchMeTheme.borderGray, lineWidth: 1)
            )
            .cornerRadius(14)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Gdzie się spotkamy?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(CatchMeTheme.textPrimary)
                
                Text("Wybierz jedno miejsce. Niech zdecyduje ekipa.")
                    .font(.system(size: 14))
                    .foregroundColor(CatchMeTheme.textSecondary)
            }
            
            VStack(spacing: 12) {
                ForEach(options) { option in
                    let isSelected = option.name == selectedOptionName
                    
                    Button {
                        selectedOptionName = option.name
                        hasVoted = false
                        voteError = nil
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: option.icon)
                                .font(.system(size: 16))
                                .foregroundColor(isSelected ? CatchMeTheme.primaryGreen : CatchMeTheme.textSecondary)
                                .frame(width: 40, height: 40)
                                .background(isSelected ? Color.white : CatchMeTheme.surfaceGray)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(option.name)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(CatchMeTheme.textPrimary)
                                
                                Text(option.subtitle)
                                    .font(.system(size: 12))
                                    .foregroundColor(CatchMeTheme.textSecondary)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .stroke(isSelected ? CatchMeTheme.primaryGreen : CatchMeTheme.borderGray, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                
                                if isSelected {
                                    Circle()
                                        .fill(CatchMeTheme.primaryGreen)
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                        .padding(14)
                        .background(isSelected ? CatchMeTheme.softGreen : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? CatchMeTheme.primaryGreen : CatchMeTheme.borderGray, lineWidth: 1)
                        )
                        .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            if let voteError {
                Text(voteError)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            VStack(spacing: 10) {
                Text(hasVoted ? "Zapisano w bazie: \(selectedOptionName)" : "Twój wybór: \(selectedOptionName)")
                    .font(.system(size: 13))
                    .foregroundColor(hasVoted ? CatchMeTheme.primaryGreen : CatchMeTheme.textSecondary)
                
                if appData.isSubmitting {
                    ProgressView("Zapisywanie głosu...")
                        .tint(CatchMeTheme.primaryGreen)
                        .frame(height: 52)
                } else {
                    PrimaryButton(title: hasVoted ? "Wróć" : "Oddaj głos") {
                        if hasVoted {
                            dismiss()
                        } else {
                            let dayPart = dateShort.components(separatedBy: " ").first ?? "23"
                            Task {
                                let success = await appData.submitLocationVote(
                                    dayLabel: dayPart,
                                    monthLabel: "PAŹ",
                                    slotTitle: slotTitle,
                                    groupName: groupName,
                                    locationChoice: selectedOptionName
                                )
                                if success {
                                    hasVoted = true
                                } else {
                                    voteError = appData.errorMessage ?? "Nie udało się zapisać głosu."
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(CatchMeTheme.background)
        .toolbar(.hidden, for: .navigationBar)
    }
}
