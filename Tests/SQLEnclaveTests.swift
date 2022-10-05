import SQLEnclave
import XCTest

class SQLEnclaveTests : XCTestCase {
    func testSQLEnclaveModule() throws {
        XCTAssertLessThanOrEqual(0_000_000, SQLEnclaveVersionNumber, "should have been version 0.0.0 or higher")
    }
}
