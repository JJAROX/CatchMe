import SwiftUI

struct LoginView: View {
    var onLoginSuccess: () -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showForgotPassword = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("CatchMe")
                .font(.system(size: 26, weight: .regular))
                .foregroundColor(CatchMeTheme.primaryGreen)
                .padding(.top, 60)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Dobrze Cię widzieć")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    Text("Zaloguj się i wróć do swoich ludzi.")
                        .font(.system(size: 14))
                        .foregroundColor(CatchMeTheme.textSecondary)
                }
                
                VStack(spacing: 12) {
                    CatchMeTextField(placeholder: "E-mail lub Login", text: $email)
                    CatchMeTextField(placeholder: "Hasło", text: $password, isSecure: true)
                }
                
                HStack {
                    Spacer()
                    Button("Zapomniałem hasła") {
                        showForgotPassword = true
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(CatchMeTheme.primaryGreen)
                }
                .padding(.top, -4)
                
                PrimaryButton(title: "Zaloguj się") {
                    onLoginSuccess()
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Nie masz konta?")
                    .foregroundColor(CatchMeTheme.textSecondary)
                Button("Załóż konto") {
                    showRegister = true
                }
                .fontWeight(.semibold)
                .foregroundColor(CatchMeTheme.primaryGreen)
            }
            .font(.system(size: 14))
            .padding(.bottom, 24)
        }
        .background(CatchMeTheme.background.ignoresSafeArea())
        .fullScreenCover(isPresented: $showRegister) {
            RegisterView(onAuthSuccess: {
                showRegister = false
                onLoginSuccess()
            })
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView()
                .presentationDragIndicator(.visible)
        }
    }
}
