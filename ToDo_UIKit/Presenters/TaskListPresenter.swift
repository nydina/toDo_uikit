import Foundation

class TaskListPresenter {
    weak private var view: TaskListView?
    private let recordService : APIService
    private var tasks: [Record] = []


    init(view: TaskListView, recordService: APIService) {
        self.view = view
        self.recordService = recordService
    }

    func getTasks() async throws {
        tasks = try await recordService.getTasks()
        view?.displayTasks(tasks)
    }

    private func updateTask(_ record: Record) async throws {
        let updatedIsComplete = record.fields.isComplete ?? false // Use a default value if isComplete is nil

        let dataToUpdate: [String: Any] = [
            "records": [
                [
                    "id": record.id,
                    "fields": ["Done": updatedIsComplete]
                ]
            ]
        ]

        try await recordService.patchTask(dataToUpdate: dataToUpdate)

        if let index = tasks.firstIndex(where: {
            $0.id == record.id
        }) {
            tasks[index] = record
        }

        view?.displayTasks(tasks)
    }

    func completeTask(_ record: Record) async throws {
        var record = record
        record.fields.isComplete = record.fields.isComplete ?? false
        record.fields.isComplete?.toggle()

        try await updateTask(record)
    }

}


