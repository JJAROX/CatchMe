import SwiftUI

struct CreateGroupView: View {
    @EnvironmentObject var appData: AppDataViewModel
    
    @State private var groupName = ""
    @State private var generatedLink = "catchme.app/join/xyz"
    @State private var isCreated = false
    @State private var copied = false
    @State private var validationError: String?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                CatchMeBackHeader(title: "Nowa grupa")
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Zbierz swoją ekipę")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    Text("Jedna grupa, wspólne plany. Zacznij od nazwy i zaproś znajomych do środka.")
                        .font(.system(size: 14))
                        .foregroundColor(CatchMeTheme.textSecondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nazwa grupy")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    CatchMeTextField(placeholder: "Nazwa grupy (np. Planszówkowa ekipa)", text: $groupName)
                    
                    if let validationError {
                        Text(validationError)
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                    } else {
                        Text("Wybierz nazwę, którą rozpozna cała ekipa.")
                            .font(.system(size: 12))
                            .foregroundColor(CatchMeTheme.textSecondary)
                    }
                }
                
                if appData.isSubmitting {
                    HStack {
                        Spacer()
                        ProgressView("Zapisywanie w bazie danych...")
                            .tint(CatchMeTheme.primaryGreen)
                        Spacer()
                    }
                    .frame(height: 52)
                } else {
                    PrimaryButton(title: isCreated ? "Zapisano w bazie" : "Utwórz i wygeneruj link") {
                        let trimmed = groupName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else {
                            validationError = "Wpisz nazwę grupy przed zapisaniem."
                            return
                        }
                        validationError = nil
                        
                        Task {
                            if let savedGroup = await appData.createGroup(name: trimmed) {
                                generatedLink = savedGroup.inviteLink
                                isCreated = true
                            } else {
                                validationError = appData.errorMessage ?? "Nie udało się zapisać grupy."
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Link do grupy")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(CatchMeTheme.textPrimary)
                        
                        Spacer()
                        
                        Text(isCreated ? "Aktywny link" : "Podgląd po utworzeniu")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(CatchMeTheme.primaryGreen)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(CatchMeTheme.softGreen)
                            .cornerRadius(20)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(CatchMeTheme.textSecondary)
                            
                            Text(generatedLink)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(CatchMeTheme.textPrimary)
                            
                            Spacer()
                            
                            Button {
                                UIPasteboard.general.string = "https://\(generatedLink)"
                                copied = true
                            } label: {
                                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                                    .font(.system(size: 14))
                                    .foregroundColor(CatchMeTheme.primaryGreen)
                                    .frame(width: 36, height: 36)
                                    .background(CatchMeTheme.softGreen)
                                    .cornerRadius(10)
                            }
                        }
                        
                        Text("Tak będzie wyglądać Twoje zaproszenie. Po utworzeniu grupy skopiuj link i wyślij go znajomym.")
                            .font(.system(size: 12))
                            .foregroundColor(CatchMeTheme.textSecondary)
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
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(CatchMeTheme.background)
        .toolbar(.hidden, for: .navigationBar)
    }
}
