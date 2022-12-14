import XCTest
import SQLEnclave

private struct TestError : Error { }

class EnumeratedCursorTests: SQLEnclaveTestCase {
    
    func testEnumeratedCursorFromCursor() throws {
        let base = AnyCursor(["foo", "bar"])
        let cursor = base.enumerated()
        var (n, x) = try cursor.next()!
        XCTAssertEqual(x, "foo")
        XCTAssertEqual(n, 0)
        (n, x) = try cursor.next()!
        XCTAssertEqual(x, "bar")
        XCTAssertEqual(n, 1)
        XCTAssertTrue(try cursor.next() == nil) // end
        XCTAssertTrue(try cursor.next() == nil) // past the end
    }
    
    func testEnumeratedCursorFromThrowingCursor() throws {
        var i = 0
        let strings = ["foo", "bar"]
        let base: AnyCursor<String> = AnyCursor {
            guard i < strings.count else { throw TestError() }
            defer { i += 1 }
            return strings[i]
        }
        let cursor = base.enumerated()
        var (n, x) = try cursor.next()!
        XCTAssertEqual(x, "foo")
        XCTAssertEqual(n, 0)
        (n, x) = try cursor.next()!
        XCTAssertEqual(x, "bar")
        XCTAssertEqual(n, 1)
        do {
            _ = try cursor.next()
            XCTFail()
        } catch is TestError {
        } catch {
            XCTFail()
        }
    }
}
