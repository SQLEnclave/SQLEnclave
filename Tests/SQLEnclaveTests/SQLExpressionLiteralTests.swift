#if DEBUG // for @testable
import XCTest
@testable import SQLEnclave

class SQLExpressionLiteralTests: SQLEnclaveTestCase {
    
    func testWithArguments() throws {
        try DatabaseQueue().inDatabase { db in
            let expression = Column("foo").collating(.nocase) == "'fooÃ©Ä±ð¨ð¨ð¿ð«ð·ð¨ð®'" && Column("baz") >= 1
            let context = SQLGenerationContext(db)
            let sql = try expression.sql(context, wrappedInParenthesis: true)
            XCTAssertEqual(sql, "((\"foo\" = ? COLLATE NOCASE) AND (\"baz\" >= ?))")
            let values = context.arguments.values
            XCTAssertEqual(values.count, 2)
            XCTAssertEqual(values[0], "'fooÃ©Ä±ð¨ð¨ð¿ð«ð·ð¨ð®'".databaseValue)
            XCTAssertEqual(values[1], 1.databaseValue)
        }
    }
    
    func testWithoutArguments() throws {
        try DatabaseQueue().inDatabase { db in
            let expression = Column("foo").collating(.nocase) == "'fooÃ©Ä±ð¨ð¨ð¿ð«ð·ð¨ð®'" && Column("baz") >= 1
            let context = SQLGenerationContext(db, argumentsSink: .forRawSQL)
            let sql = try expression.sql(context, wrappedInParenthesis: true)
            XCTAssert(context.arguments.isEmpty)
            XCTAssertEqual(sql, "((\"foo\" = '''fooÃ©Ä±ð¨ð¨ð¿ð«ð·ð¨ð®''' COLLATE NOCASE) AND (\"baz\" >= 1))")
        }
    }
}
#endif
