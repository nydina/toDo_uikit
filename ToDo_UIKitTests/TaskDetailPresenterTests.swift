@testable import ToDo_UIKit
import XCTest

final class TaskDetailPresenterTests: XCTestCase {
    var presenter: TaskDetailPresenter!
    var mockView: MockTaskDetailView!

    override func setUp() {
        super.setUp()
        mockView = MockTaskDetailView()
        presenter = TaskDetailPresenter(view: mockView)
    }

    func testDisplayTaskSuccess() async throws {
        // When
        presenter.displayTask()
        
        // Then
        await fulfillment(of: [mockView.expectDisplayTaskWasCalled], timeout: 1)
    }

}

class MockTaskDetailView: TaskDetailView {
    let expectDisplayTaskWasCalled = XCTestExpectation(description: "display task is successful")
    
    func displayTask() {
        expectDisplayTaskWasCalled.fulfill()
    }
    

}
