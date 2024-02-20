import Foundation

protocol TaskDetailView: AnyObject {
    func displayTask()
}
class TaskDetailPresenter {
    weak private var view: TaskDetailView?

    init(view: TaskDetailView?) {
        self.view = view
    }

    func displayTask() {
        view?.displayTask()
    }
}
