import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case serverError(String)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Nieprawidłowy adres serwera API."
        case .serverError(let message):
            return message
        case .decodingError:
            return "Błąd odczytu danych z serwera."
        }
    }
}

final class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:3000/api"
    
    private init() {}
    
    func fetchGroups() async throws -> [GroupModel] {
        try await getRequest(endpoint: "/groups")
    }
    
    func createGroup(name: String) async throws -> GroupModel {
        let body = ["name": name]
        return try await postRequest(endpoint: "/groups", body: body)
    }
    
    func fetchMeetings() async throws -> [MeetingModel] {
        try await getRequest(endpoint: "/meetings")
    }
    
    func createMeetingVote(
        dayLabel: String,
        monthLabel: String,
        slotTitle: String,
        groupName: String,
        locationChoice: String
    ) async throws -> MeetingModel {
        let body: [String: String] = [
            "day_label": dayLabel,
            "month_label": monthLabel,
            "slot_title": slotTitle,
            "group_name": groupName,
            "location_choice": locationChoice
        ]
        return try await postRequest(endpoint: "/meetings", body: body)
    }
    
    // MARK: - Prywatne metody pomocnicze
    private func getRequest<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else { throw APIError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        return try handleResponse(data: data, response: response)
    }
    
    private func postRequest<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response)
    }
    
    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.serverError("Brak odpowiedzi z serwera.")
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            if let errorPayload = try? JSONDecoder().decode([String: String].self, from: data),
               let msg = errorPayload["error"] {
                throw APIError.serverError(msg)
            }
            throw APIError.serverError("Błąd serwera (kod \(httpResponse.statusCode)).")
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}
