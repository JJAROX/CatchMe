import SwiftUI

struct SettingsView: View {
    var onLogout: () -> Void
    
    @State private var notificationsEnabled = true
    @State private var remindersEnabled = true
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    CatchMeTopHeader(initials: "AN")
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ustawienia")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(CatchMeTheme.textPrimary)
                        
                        Text("Twoje konto, na Twoich zasadach.")
                            .font(.system(size: 14))
                            .foregroundColor(CatchMeTheme.textSecondary)
                    }
                    
                    // Karta profilu
                    HStack(spacing: 12) {
                        Text("AN")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(CatchMeTheme.primaryGreen)
                            .frame(width: 46, height: 46)
                            .background(CatchMeTheme.softGreen)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Anna Nowak")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(CatchMeTheme.textPrimary)
                            
                            Text("anna.nowak@email.pl")
                                .font(.system(size: 13))
                                .foregroundColor(CatchMeTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13))
                            .foregroundColor(CatchMeTheme.textSecondary)
                    }
                    .padding(14)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(CatchMeTheme.borderGray, lineWidth: 1)
                    )
                    .cornerRadius(16)
                    
                    // Sekcja Konto
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Konto")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(CatchMeTheme.textPrimary)
                        
                        VStack(spacing: 0) {
                            SettingsNavRow(icon: "key", title: "Zmień hasło")
                            Divider().padding(.leading, 44)
                            SettingsNavRow(icon: "shield", title: "Prywatność")
                            Divider().padding(.leading, 44)
                            NavigationLink {
                                CalendarIntegrationsView()
                            } label: {
                                SettingsNavRow(icon: "calendar.badge.plus", title: "Integracje kalendarza")
                            }
                            .buttonStyle(.plain)
                        }
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(CatchMeTheme.borderGray, lineWidth: 1)
                        )
                        .cornerRadius(16)
                    }
                    
                    // Sekcja Preferencje
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Preferencje")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(CatchMeTheme.textPrimary)
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 12) {
                                Image(systemName: "bell")
                                    .foregroundColor(CatchMeTheme.textSecondary)
                                    .frame(width: 22)
                                Text("Powiadomienia")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(CatchMeTheme.textPrimary)
                                Spacer()
                                Toggle("", isOn: $notificationsEnabled)
                                    .labelsHidden()
                                    .tint(CatchMeTheme.primaryGreen)
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 52)
                            
                            Divider().padding(.leading, 44)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .foregroundColor(CatchMeTheme.textSecondary)
                                    .frame(width: 22)
                                Text("Przypomnienia o spotkaniach")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(CatchMeTheme.textPrimary)
                                Spacer()
                                Toggle("", isOn: $remindersEnabled)
                                    .labelsHidden()
                                    .tint(CatchMeTheme.primaryGreen)
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 52)
                            
                            Divider().padding(.leading, 44)
                            
                            SettingsNavRow(icon: "globe", title: "Język aplikacji", trailingText: "Polski")
                        }
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(CatchMeTheme.borderGray, lineWidth: 1)
                        )
                        .cornerRadius(16)
                    }
                    
                    // Wyloguj się + stopka
                    VStack(spacing: 12) {
                        Button(action: onLogout) {
                            HStack(spacing: 8) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Wyloguj się")
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(CatchMeTheme.primaryGreen)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }
                        
                        Text("Pomoc · Regulamin · Wersja 1.0")
                            .font(.system(size: 12))
                            .foregroundColor(CatchMeTheme.textSecondary)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(CatchMeTheme.background)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct SettingsNavRow: View {
    let icon: String
    let title: String
    var trailingText: String? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(CatchMeTheme.textSecondary)
                .frame(width: 22)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(CatchMeTheme.textPrimary)
            
            Spacer()
            
            if let trailingText {
                Text(trailingText)
                    .font(.system(size: 13))
                    .foregroundColor(CatchMeTheme.textSecondary)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(CatchMeTheme.textSecondary)
        }
        .padding(.horizontal, 14)
        .frame(height: 52)
    }
}
