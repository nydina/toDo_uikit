import Foundation

class TaskListPresenter {
    weak var view: TaskListView?
    let recordService = RecordService()
    var tasks: [Record] = []


    init(view: TaskListView) {
        self.view = view
    }

    func getTasks() {
        Task {
            do {
                tasks = try await recordService.getTasks()
                view?.displayTasks(tasks)
            } catch {
                view?.displayError(message: error.localizedDescription)
            }
        }
    }

    func updateTask(withId recordId: String, isComplete: Bool) {
        Task {
            do {
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
            } catch {
                view?.displayError(message: error.localizedDescription)
            }
        }
    }

}


