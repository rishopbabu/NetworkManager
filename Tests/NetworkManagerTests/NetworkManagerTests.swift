import XCTest
@testable import NetworkManager

final class NetworkManagerTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
    
    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(MockURLProtocol.self)
    }
        
    override func tearDown() {
        super.tearDown()
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
    
    func testSuccessfulRequest() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let request = NetworkRequest(url: url)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = """
            {
                "userId": 1,
                "id": 1,
                "title": "delectus aut autem",
                "completed": false
            }
            """.data(using: .utf8)!
            return (response, data)
        }
        
        let manager = NetworkManager(session: makeMockSession())
        
        let expectation = XCTestExpectation(description: "Download todo item")
        
        manager.sendRequest(request: request, responseType: Todo.self) { result in
            switch result {
            case .success(let todo):
                XCTAssertEqual(todo.id, 1)
                expectation.fulfill()
            case .failure:
                XCTFail("Request failed")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRequestFailed() {
            let url = URL(string: "https://jsonplaceholder.typicode.com/invalid_endpoint")!
            let request = NetworkRequest(url: url)
            let manager = NetworkManager()
            
            let expectation = XCTestExpectation(description: "Request should fail")
            
            manager.sendRequest(request: request, responseType: Todo.self) { result in
                switch result {
                case .success:
                    XCTFail("Request should not succeed")
                case .failure(let error):
                    switch error {
                    case .invalidResponse:
                        expectation.fulfill()
                    default:
                        XCTFail("Expected invalidResponse error")
                    }
                }
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    
    func testInvalidResponse() {
            let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
            let request = NetworkRequest(url: url)
            
            let expectation = XCTestExpectation(description: "Request should fail with invalid response")
            
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
                return (response, nil)
            }
            
            let manager = NetworkManager(session: makeMockSession())
            
            manager.sendRequest(request: request, responseType: Todo.self) { result in
                switch result {
                case .success:
                    XCTFail("Request should not succeed")
                case .failure(let error):
                    switch error {
                    case .invalidResponse:
                        expectation.fulfill()
                    default:
                        XCTFail("Expected invalidResponse error")
                    }
                }
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    
    func testDecodingFailed() {
            let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
            let request = NetworkRequest(url: url)
            
            let expectation = XCTestExpectation(description: "Decoding should fail")
            
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                let data = """
                {
                    "userId": 1,
                    "id": 1,
                    "title": "Test Title"
                }
                """.data(using: .utf8)!
                return (response, data)
            }
            
            let manager = NetworkManager(session: makeMockSession())
            
            manager.sendRequest(request: request, responseType: InvalidTodo.self) { result in
                switch result {
                case .success:
                    XCTFail("Decoding should not succeed")
                case .failure(let error):
                    switch error {
                    case .decodingFailed:
                        expectation.fulfill()
                    default:
                        XCTFail("Expected decodingFailed error")
                    }
                }
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    
    func testUnknownError() {
            let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
            let request = NetworkRequest(url: url)
            
            let expectation = XCTestExpectation(description: "Request should fail with unknown error")
            
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, nil) // Return a valid HTTP response with nil data
            }
            
            let manager = NetworkManager(session: makeMockSession())
            
            manager.sendRequest(request: request, responseType: Todo.self) { result in
                switch result {
                case .success:
                    XCTFail("Request should not succeed")
                case .failure(let error):
                    switch error {
                    case .unknown:
                        expectation.fulfill()
                    default:
                        XCTFail("Expected unknown error, got \(error)")
                    }
                }
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    
    private func makeMockSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}


struct Todo: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

struct InvalidTodo: Decodable {
    let invalidField: String
    // Missing other fields to force a decoding error
}
