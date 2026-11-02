import Foundation

class DashboardViewModel: ObservableObject {
    @Published var activeDyspos: [Dyspo] = []
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        let now = Date()
        activeDyspos = [
            Dyspo(userName: "Marcin Krawiec", locationZone: "Miasteczko (Klub Studio)", intentIcon: "🍻", endTime: now.addingTimeInterval(3600)),
            Dyspo(userName: "Mateusz Krawiec", locationZone: "Budynek B5 - Lab", intentIcon: "💻", endTime: now.addingTimeInterval(1800)),
            Dyspo(userName: "Gabrysia Krawiec", locationZone: "Kawiarnia (Z Kółkiem)", intentIcon: "☕️", endTime: now.addingTimeInterval(5400))
        ]
    }
    
    func addMyDyspo(location: String, intent: String, durationMinutes: Double) {
        let newDyspo = Dyspo(
            userName: "Ja",
            locationZone: location,
            intentIcon: intent,
            endTime: Date().addingTimeInterval(durationMinutes * 60)
        )
        activeDyspos.insert(newDyspo, at: 0)
    }
}
