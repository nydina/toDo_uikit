import Foundation

func dateFormatter(inputString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: inputString) {
        dateFormatter.dateFormat = "MMMM d, yyyy"

        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    } else {
        return nil
    }
}


