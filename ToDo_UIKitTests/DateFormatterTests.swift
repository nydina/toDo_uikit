@testable import ToDo_UIKit
import XCTest

final class DateFormaterTests: XCTestCase {
    func testDateFormaterSuccess() {
        // Given
        let dateString = "2024/11/02"

        // When
        let returnString = dateFormatter(inputString: dateString)

        // Then
        XCTAssertEqual("November 2, 2024", returnString)
    }

    func testDateFormatterReturnsNil() {
        // Given non date string
        let dateString = "02"

        // When
        let returnString = dateFormatter(inputString: dateString)

        // Then
        XCTAssertEqual(nil, returnString)
    }
}
