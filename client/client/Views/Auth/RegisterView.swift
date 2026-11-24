import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    var onAuthSuccess: () -> Void
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Text("CatchMe")
                .font(.system(size: 26, weight: .regular))
                .foregroundColor(CatchMeTheme.primaryGreen)
                .padding(.top, 60)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Poznaj swoich ludzi")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    Text("Załóż konto i planujcie wspólny czas.")
                        .font(.system(size: 14))
                        .foregroundColor(CatchMeTheme.textSecondary)
                }
                
                VStack(spacing: 12) {
                    CatchMeTextField(placeholder: "Imię", text: $name)
                    CatchMeTextField(placeholder: "Adres e-mail", text: $email)
                    CatchMeTextField(placeholder: "Hasło", text: $password, isSecure: true)
                }
                
                Text("Użyj co najmniej 8 znaków.")
                    .font(.system(size: 12))
                    .foregroundColor(CatchMeTheme.textSecondary)
                    .padding(.top, -6)
                
                Text("Tworząc konto, akceptujesz **Regulamin** i **Politykę prywatności**.")
                    .font(.system(size: 12))
                    .foregroundColor(CatchMeTheme.textSecondary)
                    .tint(CatchMeTheme.primaryGreen)
                
                PrimaryButton(title: "Utwórz konto") {
                    onAuthSuccess()
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Masz już konto?")
                    .foregroundColor(CatchMeTheme.textSecondary)
                Button("Zaloguj się") {
                    dismiss()
                }
                .fontWeight(.semibold)
                .foregroundColor(CatchMeTheme.primaryGreen)
            }
            .font(.system(size: 14))
            .padding(.bottom, 24)
        }
        .background(CatchMeTheme.background.ignoresSafeArea())
    }
}
