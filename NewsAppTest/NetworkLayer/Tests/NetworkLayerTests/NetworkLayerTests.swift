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
    
    func testApiCallAsync() async throws {
        // Given
        let endpoint = SampleEndPoint(method: .get, endPoint: "example_endpoint")
        let mockService = MockDataServices()
        
        // When
        do {
            let response: SampleResponseModel = try await endpoint.request(fromService: mockService)
            // Assert on response
            XCTAssertNotNil(response)
        } catch {
            // Handle error or assert failure
            XCTFail("API Call failed with error: \(error)")
        }
    }
}

struct SampleEndPoint: EndPoint {
    let method: HTTPMethod
    let endPoint: String
    let queryParams: [String: Any]
    let bodyParams: [String: Any]
    
    init(method: HTTPMethod, endPoint: String, queryParams: [String: Any] = [:], bodyParams: [String: Any] = [:]) {
        self.method = method
        self.endPoint = endPoint
        self.queryParams = queryParams
        self.bodyParams = bodyParams
    }
}

struct SampleResponseModel: Codable {
    let id: Int
    let title: String
}
