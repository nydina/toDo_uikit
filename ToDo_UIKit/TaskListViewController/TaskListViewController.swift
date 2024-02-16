import UIKit

protocol TaskListView: AnyObject {
    func displayTasks(_ tasks: [Record])
    func displayError(message: String)
}


class TaskListViewController: UICollectionViewController {
    var presenter: TaskListPresenter!


    var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout

        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, taskItem: Record) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: taskItem)
        }

        collectionView.dataSource = dataSource

        // Initialize the presenter and fetch data
        presenter = TaskListPresenter(view: self)
        presenter.getTasks()
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }


}

extension TaskListViewController: TaskListView {
    func displayTasks(_ tasks: [Record]) {
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(tasks)
            dataSource.apply(snapshot, animatingDifferences: true)
        }

    func displayError(message: String) {
        print("Error: \(message)")
    }
}
