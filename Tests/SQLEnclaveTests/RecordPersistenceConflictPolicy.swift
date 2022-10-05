import XCTest
import SQLEnclave

class RecordWithoutPersistenceConflictPolicy : Record {
}

class RecordWithPersistenceConflictPolicy : Record {
    override class var persistenceConflictPolicy: PersistenceConflictPolicy {
        PersistenceConflictPolicy(insert: .fail, update: .ignore)
    }
}

class RecordPersistenceConflictPolicyTests: SQLEnclaveTestCase {
    
    func testDefaultPersistenceConflictPolicy() {
        let record = RecordWithoutPersistenceConflictPolicy()
        let policy = type(of: record as MutablePersistableRecord).persistenceConflictPolicy
        XCTAssertEqual(policy.conflictResolutionForInsert, .abort)
        XCTAssertEqual(policy.conflictResolutionForUpdate, .abort)
    }
    
    func testConfigurablePersistenceConflictPolicy() {
        let record = RecordWithPersistenceConflictPolicy()
        let policy = type(of: record as MutablePersistableRecord).persistenceConflictPolicy
        XCTAssertEqual(policy.conflictResolutionForInsert, .fail)
        XCTAssertEqual(policy.conflictResolutionForUpdate, .ignore)
    }

}
