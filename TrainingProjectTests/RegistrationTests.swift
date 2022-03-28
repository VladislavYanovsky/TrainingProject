
import XCTest
@testable import TrainingProject

class RegistrationTests: XCTestCase {
    var model: Validator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        model = Validator()
    }

    override func tearDownWithError() throws {
        model = nil
        try super.tearDownWithError()
    }

    func validLogin() throws {
        XCTAssertTrue(model.validateEnter(login: "login", password: "password"))
    }
    
    func invalidLogin() throws {
        XCTAssertFalse(model.validateEnter(login: "t1", password: "2"))
    }
    
    func invalidLoginWithEmptyFields() throws {
        XCTAssertFalse(model.validateEnter(login: "", password: ""))
    }
}
