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
                let taskTitles = tasks.map { $0.task }
                view?.displayTasks(taskTitles)
            } catch {
                view?.displayError(message: error.localizedDescription)
            }
        }
    }
}

