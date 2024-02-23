import UIKit

extension TaskDetailViewController {
    enum Row: Hashable {
        case date
        case notes
        case priority
        case title

        var imageName: String? {
            switch self {
            case .date: return "calendar.circle"
            case .notes: return "square.and.pencil"
            case .priority: return "exclamationmark.bubble"
            default: return nil
            }
        }

        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }

        var textStyle: UIFont.TextStyle {
            switch self {
            case .title: return .headline
            default: return .subheadline
            }
        }

        func text(record: Record) -> String {
            switch self {
            case .date:
                let dateString = record.fields.toDoBefore
                let formattedDate = dateFormatter(inputString: dateString)
                return formattedDate ?? dateString
            case .notes:
                return record.fields.task
            case .priority:
                return "\(record.fields.priority) priority"
            case .title:
                return record.fields.task
            }
        }
    }
}
