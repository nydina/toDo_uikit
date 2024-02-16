import Foundation
protocol APIService: AnyObject {
    func getTasks() async throws -> [Record]
    func patchTask(dataToUpdate: [String: Any]) async throws
}

class RecordService: APIService {
    func getTasks() async throws -> [Record] {
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
         return decoded.records
    }

    func patchTask(dataToUpdate: [String: Any]) async throws {
        guard let url = URL(string: Constants.urlAPI) else {
            throw ServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("Bearer \(Constants.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dataToUpdate)
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw ServiceError.invalidResponse
            }

            if let responseData = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("PATCH Response:", responseData)
            }
        } catch {
            throw error
        }
    }
}

enum ServiceError: Error {
    case invalidURL
    case invalidResponse
}
