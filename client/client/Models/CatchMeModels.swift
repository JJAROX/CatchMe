import SwiftUI

struct GroupModel: Identifiable, Codable {
    let id: Int
    let name: String
    let membersCount: Int
    let nextMeeting: String
    let inviteLink: String
    let icon: String
    let colorTheme: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, icon
        case membersCount = "members_count"
        case nextMeeting = "next_meeting"
        case inviteLink = "invite_link"
        case colorTheme = "color_theme"
    }
    
    var iconBg: Color {
        switch colorTheme {
        case "beige": return CatchMeTheme.iconBeigeBg
        case "purple": return CatchMeTheme.iconPurpleBg
        default: return CatchMeTheme.softGreen
        }
    }
    
    var iconFg: Color {
        switch colorTheme {
        case "beige": return CatchMeTheme.iconBeigeFg
        case "purple": return CatchMeTheme.iconPurpleFg
        default: return CatchMeTheme.primaryGreen
        }
    }
}

struct MeetingModel: Identifiable, Codable {
    let id: Int
    let dayLabel: String
    let monthLabel: String
    let title: String
    let details: String
    let groupName: String
    let locationChoice: String
    let isHighlighted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, details
        case dayLabel = "day_label"
        case monthLabel = "month_label"
        case groupName = "group_name"
        case locationChoice = "location_choice"
        case isHighlighted = "is_highlighted"
    }
}
