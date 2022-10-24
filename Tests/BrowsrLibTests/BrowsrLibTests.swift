import XCTest
@testable import BrowsrLib
import Combine

final class BrowsrLibTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testFetchOrganizations() throws {
        
        var error: GetOrganizationsError?
        var organizations: [Organization] = []
        
        let expectation = expectation(description: "Organizations Fetched")
        
        BrowsrLib.getOrganizations()
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
    
    func testSearchOrganizations() throws {
        
        var error: SearchOrganizationsError?
        var organizations: [Organization] = []
        
        let expectation = expectation(description: "Organizations Searched")
        
        BrowsrLib.searchOrganizations(search: "")
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
