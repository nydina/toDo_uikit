import Foundation

class TaskListPresenter {
    weak var view: TaskListView?
    let recordService = RecordService()

    init(view: TaskListView) {
        self.view = view
    }

    func fetchData() {
        Task {
            do {
                let tasks = try await recordService.getTasks()
                view?.displayTasks(tasks)
            } catch {
                view?.displayError(message: error.localizedDescription)
            }
        }
    }
}


