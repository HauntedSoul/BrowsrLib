import XCTest
@testable import BrowsrLib
import Combine

final class BrowsrLibTests: XCTestCase {
//    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(BrowsrLib().text, "Hello, World!")
//    }
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testFetchOrganizations() throws {
        
        let browsrlLib = BrowsrLib()
        var error: GetOrganizationsError?
        var organizations: [Organization] = []
        
        let expectation = expectation(description: "Organizations Fetched")
        
        browsrlLib.getOrganizations()
            .sink { result in
                switch result {
                case .failure(let resultError):
                    print("ERROR: \(resultError.localizedDescription)")
                    error = resultError
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { value in
                organizations = value
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssert(!organizations.isEmpty)

    }
}
