import UIKit

extension TaskListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Record>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Record>

    var recordCompletedValue: String {
         NSLocalizedString("Completed", comment: "Record completed value")
     }
     var recordNotCompletedValue: String {
         NSLocalizedString("Not completed", comment: "Record not completed value")
     }


    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, record: Record) {
        // Access the TaskItem from the Record
        let taskItem = record.fields

        let dueDate = taskItem.toDoBefore
        let formatedDueDate = dateFormatter(inputString: dueDate)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = taskItem.task
        contentConfiguration.secondaryText = formatedDueDate ?? dueDate
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(
            forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration

        var doneButtonConfiguration = doneButtonConfiguration(for: record)
        doneButtonConfiguration.tintColor = .systemPurple
       
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: record)]
        cell.accessibilityValue =
        record.fields.isComplete ?? false ? recordCompletedValue : recordNotCompletedValue
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)
        ]
    }

    private func doneButtonAccessibilityAction(for record: Record) -> UIAccessibilityCustomAction
       {
           let name = NSLocalizedString(
               "Toggle completion", comment: "Record done button accessibility label")
           let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
               Task {
                   do {
                       try await self?.presenter.completeTask(record)

                   } catch {

                   }
               }
               return true
           }
           return action
       }

    private func doneButtonConfiguration(
        for record: Record) -> UICellAccessory.CustomViewConfiguration {
            let symbolName = record.fields.isComplete ?? false ? "checkmark.circle.fill" : "circle"
            let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
            let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)

            let button = UIButton()
            button.setImage(image, for: .normal)

            button.addAction(UIAction { [weak self] _ in
                // Call the updateTask method in the presenter with the recordId
                Task {
                    do {
                        try await self?.presenter.completeTask(record)

                    } catch {

                    }
                }
            }, for: .touchUpInside)

            return UICellAccessory.CustomViewConfiguration(
                customView: button,
                placement: .leading(displayed: .always)
            )
        }



}
