import Foundation

class RecordService {
    var tasks: [TaskItem] = []

    func getTasks() async throws -> [TaskItem] {
        guard let url = URL(string: Constants.urlAPI) else {
            throw ServiceError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(Constants.token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServiceError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(RecordsResponse.self, from: data)
        tasks = decoded.records.compactMap { $0.fields }
        return tasks
    }
}

enum ServiceError: Error {
    case invalidURL
    case invalidResponse
}
