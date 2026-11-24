import SwiftUI

enum CatchMeTheme {
    // Główne kolory marki
    static let primaryGreen = Color(hex: "2F6652")
    static let softGreen = Color(hex: "EAF3EE")
    static let softGreenBorder = Color(hex: "C5DDD1")
    
    // Tła i obramowania
    static let background = Color.white
    static let surfaceGray = Color(hex: "F7F8F8")
    static let borderGray = Color(hex: "E6EAE8")
    
    // Typografia
    static let textPrimary = Color(hex: "1C2420")
    static let textSecondary = Color(hex: "76807B")
    
    // Pastelowe ikony grup
    static let iconBeigeBg = Color(hex: "F5EFE6")
    static let iconBeigeFg = Color(hex: "9C7B56")
    static let iconPurpleBg = Color(hex: "F1EEF8")
    static let iconPurpleFg = Color(hex: "7C6BA0")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
