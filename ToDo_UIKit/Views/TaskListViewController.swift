import UIKit

protocol TaskListView: AnyObject {
    func displayTasks(_ tasks: [String])
    func displayError(message: String)
}

class TaskListViewController: UICollectionViewController, TaskListView {
    var presenter: TaskListPresenter!

    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout

        let cellRegistration = UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = itemIdentifier
            cell.contentConfiguration = contentConfiguration
        }

        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        collectionView.dataSource = dataSource

        // Initialize the presenter and fetch data
        presenter = TaskListPresenter(view: self)
        presenter.fetchData()
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

    // Protocol conformance for TaskListView
    func displayTasks(_ tasks: [String]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(tasks)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func displayError(message: String) {
        print("Error: \(message)")
    }
}
