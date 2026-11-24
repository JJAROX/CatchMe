import SwiftUI
import Combine

@MainActor
final class AppDataViewModel: ObservableObject {
    @Published var groups: [GroupModel] = []
    @Published var meetings: [MeetingModel] = []
    
    @Published var isLoading = false
    @Published var isSubmitting = false
    @Published var errorMessage: String?
    
    func loadAll() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let fetchedGroups = APIService.shared.fetchGroups()
            async let fetchedMeetings = APIService.shared.fetchMeetings()
            
            let (groupsResult, meetingsResult) = try await (fetchedGroups, fetchedMeetings)
            self.groups = groupsResult
            self.meetings = meetingsResult
        } catch {
            self.errorMessage = "Nie udało się połączyć z serwerem. Upewnij się, że backend działa."
        }
        
        isLoading = false
    }
    
    func createGroup(name: String) async -> GroupModel? {
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        
        do {
            let newGroup = try await APIService.shared.createGroup(name: name)
            groups.insert(newGroup, at: 0)
            return newGroup
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
    
    func submitLocationVote(
        dayLabel: String,
        monthLabel: String,
        slotTitle: String,
        groupName: String,
        locationChoice: String
    ) async -> Bool {
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        
        do {
            let newMeeting = try await APIService.shared.createMeetingVote(
                dayLabel: dayLabel,
                monthLabel: monthLabel,
                slotTitle: slotTitle,
                groupName: groupName,
                locationChoice: locationChoice
            )
            meetings.insert(newMeeting, at: 0)
            // Odświeżenie opisu najbliższego spotkania w grupach
            if let updatedGroups = try? await APIService.shared.fetchGroups() {
                groups = updatedGroups
            }
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
