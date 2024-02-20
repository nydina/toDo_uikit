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
                record.fields.toDoBefore
            case .notes:
                record.fields.task
            case .priority:
                record.fields.priority
            case .title:
                record.fields.task
            }
        }
    }
}
