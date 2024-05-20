import XCTest
@testable import NetworkLayer

final class NetworkLayerTests: XCTestCase {
    var mockService: MockDataServices!
    
    override func setUp() {
        super.setUp()
        mockService = MockDataServices()
    }
    
    override func tearDown() {
        mockService = nil
        super.tearDown()
    }
    
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}
