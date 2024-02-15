import UIKit

extension TaskListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, TaskItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TaskItem>

    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, task: TaskItem) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = task.task
        contentConfiguration.secondaryText = task.toDoBefore
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(
            forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration

        var doneButtonConfiguration = doneButtonConfiguration(for: task)
                doneButtonConfiguration.tintColor = .systemPurple

                cell.accessories = [
                    .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)
                ]
    }

    private func doneButtonConfiguration(for task: TaskItem)
        -> UICellAccessory.CustomViewConfiguration
        {
            let symbolName = task.isComplete ?? false ? "checkmark.circle.fill" : "circle"
            let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
            let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
                    let button = UIButton()
            button.setImage(image, for: .normal)
            return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
        }
}
