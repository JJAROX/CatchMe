import SwiftUI

// MARK: - Nagłówek aplikacji (Logo + Avatar)
struct CatchMeTopHeader: View {
    var initials: String = "AN"
    
    var body: some View {
        HStack {
            Text("CatchMe")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(CatchMeTheme.primaryGreen)
            
            Spacer()
            
            Text(initials)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(CatchMeTheme.primaryGreen)
                .frame(width: 34, height: 34)
                .background(CatchMeTheme.softGreen)
                .clipShape(Circle())
        }
    }
}

// MARK: - Główny przycisk
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(CatchMeTheme.primaryGreen)
                .cornerRadius(12)
        }
    }
}

// MARK: - Pole tekstowe w stylu makiet
struct CatchMeTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @State private var showPassword = false
    
    var body: some View {
        HStack {
            if isSecure && !showPassword {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 15))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 15))
                    .textInputAutocapitalization(.never)
            }
            
            if isSecure {
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye" : "eye.slash")
                        .foregroundColor(CatchMeTheme.textSecondary)
                        .font(.system(size: 15))
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(CatchMeTheme.surfaceGray)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(CatchMeTheme.borderGray, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

// MARK: - Zakładki i niestandardowy dolny pasek (Tab Bar)
enum AppTab: Int, CaseIterable {
    case groups, calendar, home, friends, settings
    
    var icon: String {
        switch self {
        case .groups: return "person.2"
        case .calendar: return "calendar"
        case .home: return "house"
        case .friends: return "person"
        case .settings: return "gearshape"
        }
    }
}

struct CatchMeTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        VStack(spacing: 0) {
            Divider().background(CatchMeTheme.borderGray)
            
            HStack {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(selectedTab == tab ? CatchMeTheme.primaryGreen : CatchMeTheme.textSecondary)
                                .frame(width: 44, height: 36)
                                .background(selectedTab == tab ? CatchMeTheme.softGreen : Color.clear)
                                .cornerRadius(10)
                            
                            Circle()
                                .fill(selectedTab == tab ? CatchMeTheme.primaryGreen : Color.clear)
                                .frame(width: 4, height: 4)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 6)
            .background(Color.white)
        }
    }
}

// MARK: - Pasek wyszukiwania
struct CatchMeSearchBar: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(CatchMeTheme.textSecondary)
                .font(.system(size: 15))
            
            TextField(placeholder, text: $text)
                .font(.system(size: 15))
        }
        .padding(.horizontal, 14)
        .frame(height: 44)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(CatchMeTheme.borderGray, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

// MARK: - Nagłówek podstrony z przyciskiem wstecz
struct CatchMeBackHeader: View {
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(CatchMeTheme.textPrimary)
                    .frame(width: 34, height: 34)
                    .background(CatchMeTheme.surfaceGray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(CatchMeTheme.borderGray, lineWidth: 1)
                    )
                    .cornerRadius(10)
            }
            
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(CatchMeTheme.textPrimary)
            
            Spacer()
        }
    }
}

// MARK: - Karta stanu pustego (Empty State)
struct EmptyStateCard: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(CatchMeTheme.primaryGreen)
                .frame(width: 48, height: 48)
                .background(CatchMeTheme.softGreen)
                .cornerRadius(12)
            
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(CatchMeTheme.textPrimary)
            
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundColor(CatchMeTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(CatchMeTheme.surfaceGray)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(CatchMeTheme.borderGray, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

// MARK: - Karta stanu błędu (Error State)
struct ErrorStateCard: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 24))
                .foregroundColor(.red.opacity(0.8))
            
            Text(message)
                .font(.system(size: 13))
                .foregroundColor(CatchMeTheme.textPrimary)
                .multilineTextAlignment(.center)
            
            Button("Spróbuj ponownie", action: onRetry)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(CatchMeTheme.primaryGreen)
                .cornerRadius(10)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.red.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.red.opacity(0.25), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}
