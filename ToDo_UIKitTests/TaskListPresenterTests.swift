@testable import ToDo_UIKit
import XCTest

final class TaskListPresenterTests: XCTestCase {
    var presenter: TaskListPresenter!
    var mockView: MockTaskListView!
    var mockAPI: MockAPIService!

    override func setUp() {
        super.setUp()
        // Given
        mockView = MockTaskListView()
        mockAPI = MockAPIService()
        presenter = TaskListPresenter(view: mockView, recordService: mockAPI)
    }

    func testGetTasksSuccess() async throws {
        // When
        try await presenter.getTasks()
        let displayedTasks = mockView.displayedTasks

        // Then
        XCTAssertEqual(displayedTasks, mockAPI.expectedTasks)
    }

    func testCompleteTaskSuccess() async throws {
        // Given
        var record = Record(id: "1", createdTime: "2022-02-15", fields: TaskItem(toDoBefore: "2022-02-20", priority: "High", task: "Task 1", isComplete: false))

        // When
        try await presenter.completeTask(record)

        // Then
        await fulfillment(of: [mockAPI.expectPatchTaskWasCalled], timeout: 1)
    }




}

// Mock inputs
// Mock view for testing
class MockTaskListView: TaskListView {
    var displayedTasks: [Record] = []

    func displayTasks(_ tasks: [Record]) {
        displayedTasks = tasks
    }
}

class MockAPIService: APIService {
    let expectPatchTaskWasCalled = XCTestExpectation(description: "patch task is successful")
    var expectedTasks: [Record] = [
        Record(id: "1", createdTime: "2022-02-15", fields: TaskItem(toDoBefore: "2022-02-20", priority: "High", task: "Task 1", isComplete: false)),
        Record(id: "2", createdTime: "2022-02-16", fields: TaskItem(toDoBefore: "2022-02-25", priority: "Medium", task: "Task 2", isComplete: true))
    ]

    func getTasks() async throws -> [Record] {
        return expectedTasks
    }

    func patchTask(dataToUpdate: [String: Any]) async throws {
           expectPatchTaskWasCalled.fulfill()
    }
}
