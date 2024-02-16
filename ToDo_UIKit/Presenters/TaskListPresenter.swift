import Foundation

class TaskListPresenter {
    weak var view: TaskListView?
    let recordService : APIService
    var tasks: [Record] = []


    init(view: TaskListView, recordService: APIService) {
        self.view = view
        self.recordService = recordService
    }

    func getTasks() async throws {
        tasks = try await recordService.getTasks()
        view?.displayTasks(tasks)
    }

    func updateTask(withId recordId: String, isComplete: Bool) async throws {
        let dataToUpdate: [String: Any] = [
            "records": [
                [
                    "id": recordId,
                    "fields": ["Done": isComplete]
                ]
            ]
        ]

        // Update the task using the provided data
        try await recordService.patchTask(dataToUpdate: dataToUpdate)

        // Fetch and display the updated tasks
        tasks = try await recordService.getTasks()
        view?.displayTasks(tasks)
    }
}


