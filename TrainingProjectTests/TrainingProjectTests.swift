//
import XCTest
@testable import TrainingProject

class TrainingProjectTests: XCTestCase {


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
    }
    
    /*func testEmptyPasswordFail() throws {
     // Configure
     viewModel.onError = { [weak self] error in
         // Check
         XCTAssertEqual(error as? SignupError, SignupError.emptyPassword)
         self?.viewModelOnErrorExpectation.fulfill()
     }
     // Act
     viewModel.signup(username: "testUsername", password: nil)
     // Wait
     wait(for: [viewModelOnErrorExpectation], timeout: timeout)
 }*/

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
