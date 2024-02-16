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

    func testPatchTaskSuccess() async throws {
        // When
        try await presenter.updateTask(withId: "1", isComplete: mockAPI.expectedTasks[1].fields.isComplete!)

        // Then
        XCTAssertEqual(1, mockAPI.patchTaskCallCount)
        XCTAssertEqual(mockAPI.expectedTasks[1].fields.isComplete, true)
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

// Create a mock implementation of the service
class MockAPIService: APIService {
    var expectedTasks: [Record] = [
        Record(id: "1", createdTime: "2022-02-15", fields: TaskItem(toDoBefore: "2022-02-20", priority: "High", task: "Task 1", isComplete: false)),
        Record(id: "2", createdTime: "2022-02-16", fields: TaskItem(toDoBefore: "2022-02-25", priority: "Medium", task: "Task 2", isComplete: true))
    ]
    private(set) var patchTaskCallCount = 0

    func getTasks() async throws -> [Record] {
        return expectedTasks
    }

    func patchTask(dataToUpdate: [String: Any]) async throws {
        guard let records = dataToUpdate["records"] as? [[String: Any]], !records.isEmpty else {
            fatalError()
        }

        for record in records {
            if let recordId = record["id"] as? String, var fields = record["fields"] as? [String: Any] {
                // Assuming the "Done" field represents the completion status
                if let currentStatus = fields["Done"] as? Bool {
                    // Toggle the completion status
                    fields["Done"] = !currentStatus

                    // Create a new Record instance with the updated fields
                    let updatedRecord = Record(id: recordId, createdTime: "someDate", fields: TaskItem(toDoBefore: "someDate", priority: "somePriority", task: "someTask", isComplete: fields["Done"] as? Bool ?? false))

                    // Update your expectedTasks with the new Record
                    if let index = expectedTasks.firstIndex(where: { $0.id == recordId }) {
                        expectedTasks[index] = updatedRecord
                    }
                }
            }
        }

        patchTaskCallCount += 1
    }
}
