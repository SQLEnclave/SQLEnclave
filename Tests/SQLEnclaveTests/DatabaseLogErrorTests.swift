import XCTest
import SQLEnclave

class DatabaseLogErrorTests: SQLEnclaveTestCase {
    
    func testErrorLog() throws {
        // TODO: understand why this test fails on iOS 13 with system SQLite
        #if SQL_ENCLAVE_CUSTOMSQLITE || SQLITE_HAS_CODEC
        let dbQueue = try makeDatabaseQueue()
        dbQueue.inDatabase { db in
            _ = try? db.execute(sql: "Abracadabra")
        }
        XCTAssertEqual(lastResultCode!, ResultCode.SQLITE_ERROR)
        // Don't check for exact error message because it depends on SQLite version
        XCTAssert(lastMessage!.contains("syntax error"))
        XCTAssert(lastMessage!.contains("Abracadabra"))
        #endif
    }
}
