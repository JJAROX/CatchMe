import SwiftUI

struct CalendarIntegrationsView: View {
    @State private var isConnected = false
    
    var body: some View {
        VStack(spacing: 0) {
            CatchMeBackHeader(title: "Integracje")
                .padding(.horizontal, 20)
                .padding(.top, 12)
            
            Spacer()
            
            VStack(spacing: 18) {
                Image(systemName: "calendar")
                    .font(.system(size: 28))
                    .foregroundColor(CatchMeTheme.primaryGreen)
                    .frame(width: 68, height: 68)
                    .background(CatchMeTheme.softGreen)
                    .cornerRadius(18)
                
                VStack(spacing: 8) {
                    Text("Zsynchronizuj swój czas")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                    
                    Text("Połącz kalendarz i znajdź więcej czasu na spotkania z Twoimi ludźmi.")
                        .font(.system(size: 14))
                        .foregroundColor(CatchMeTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                PrimaryButton(title: isConnected ? "Odłącz Google Calendar" : "Połącz z Google Calendar") {
                    withAnimation { isConnected.toggle() }
                }
                .padding(.top, 6)
                
                HStack(spacing: 6) {
                    Image(systemName: isConnected ? "checkmark.circle.fill" : "link")
                    Text(isConnected ? "Połączono z Google Calendar" : "Kalendarz nie jest jeszcze połączony")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isConnected ? CatchMeTheme.primaryGreen : CatchMeTheme.textSecondary)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.shield")
                        .foregroundColor(CatchMeTheme.primaryGreen)
                    Text("Twoje plany zostają Twoje")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CatchMeTheme.textPrimary)
                }
                
                Text("Grupa zobaczy tylko Twoją dostępność, nie szczegóły wydarzeń. Połączenie możesz w każdej chwili usunąć.")
                    .font(.system(size: 12))
                    .foregroundColor(CatchMeTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(CatchMeTheme.borderGray, lineWidth: 1)
            )
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(CatchMeTheme.background)
        .toolbar(.hidden, for: .navigationBar)
    }
}
