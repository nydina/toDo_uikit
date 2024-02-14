import Foundation

class RecordService {
    var tasks: [TaskItem] = []
    func getTasks() async throws -> [TaskItem] {
        guard let url = URL(string: Constants.urlAPI)
        else {
            fatalError("Missing URL")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(Constants.token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else {
            fatalError("Error while fetching data")
        }
        let decoded = try JSONDecoder().decode(RecordsResponse.self, from: data)
        tasks = decoded.records.compactMap { $0.fields }
        return tasks
    }
}
