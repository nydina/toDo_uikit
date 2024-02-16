import UIKit

extension TaskListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Record>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Record>

    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, record: Record) {
        // Extract the id from the Record
        let recordId = record.id

        // Access the TaskItem from the Record
        let taskItem = record.fields

        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = taskItem.task
        contentConfiguration.secondaryText = taskItem.toDoBefore
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(
            forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration

        var doneButtonConfiguration = doneButtonConfiguration(for: taskItem, recordId: recordId)
        doneButtonConfiguration.tintColor = .systemPurple

        cell.accessories = [
            .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)
        ]
    }

    private func doneButtonConfiguration(for taskItem: TaskItem, recordId: String) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = taskItem.isComplete ?? false ? "checkmark.circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)

        let button = UIButton()
        button.setImage(image, for: .normal)

        button.addAction(UIAction { [weak self] _ in
            // Call the updateTask method in the presenter with the recordId
            Task{ do {try await self?.presenter.updateTask(withId: recordId, isComplete: !(taskItem.isComplete ?? false))}catch{} }
        }, for: .touchUpInside)

        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }



}
