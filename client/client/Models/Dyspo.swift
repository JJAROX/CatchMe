import Foundation

struct Dyspo: Identifiable {
    let id = UUID()
    let userName: String
    let locationZone: String
    let intentIcon: String
    let endTime: Date
    
    var isActive: Bool {
        Date() < endTime
    }
}
