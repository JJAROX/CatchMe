import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Text("CatchMe")
                .font(.system(size: 26, weight: .regular))
                .foregroundColor(CatchMeTheme.primaryGreen)
                .padding(.top, 48)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 18) {
                Image(systemName: "key")
                    .font(.system(size: 20))
                    .foregroundColor(CatchMeTheme.primaryGreen)
                    .frame(width: 44, height: 44)
                    .background(CatchMeTheme.softGreen)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nie pamiętasz hasła?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    Text("Podaj adres e-mail powiązany z kontem. Wyślemy Ci link do ustawienia nowego hasła.")
                        .font(.system(size: 14))
                        .foregroundColor(CatchMeTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                CatchMeTextField(placeholder: "Adres e-mail", text: $email)
                    .padding(.top, 4)
                
                PrimaryButton(title: "Wyślij link do resetu") {
                    dismiss()
                }
                
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.left")
                            Text("Wróć do logowania")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(CatchMeTheme.primaryGreen)
                    }
                    Spacer()
                }
                .padding(.top, 6)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Text("Twoi ludzie będą tu na Ciebie czekać.")
                .font(.system(size: 12))
                .foregroundColor(CatchMeTheme.textSecondary)
                .padding(.bottom, 24)
        }
        .background(CatchMeTheme.background.ignoresSafeArea())
    }
}
