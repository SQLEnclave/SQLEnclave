import SQLEnclave
import XCTest

class SQLEnclaveTests : XCTestCase {
    func testSQLEnclaveModule() throws {
        XCTAssertLessThanOrEqual(0_000_001, SQLEnclaveVersionNumber, "should have been version 0.0.0 or higher")
    }
}
