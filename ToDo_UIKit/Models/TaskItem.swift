import Foundation

// MARK: - RecordsResponse
struct RecordsResponse: Codable {
    let records: [Record]
    let offset: String?
}

// MARK: - Record
struct Record: Codable {
    let id, createdTime: String
    let fields: TaskItem
}

// MARK: - TaskItem
struct TaskItem: Codable {
    let toDoBefore, priority, task: String

    enum CodingKeys: String, CodingKey {
        case toDoBefore = "To do before"
        case priority = "Priority"
        case task = "Task"
    }
}


