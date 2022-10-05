import Foundation

/// A LockedBox protects a value with an ``NSLock``.
@propertyWrapper
public final class LockedBox<T> {
    private var _wrappedValue: T
    private var lock = NSLock()
    
    public var wrappedValue: T {
        get { read { $0 } }
        set { update { $0 = newValue } }
    }
    
    public var projectedValue: LockedBox<T> { self }
    
    public init(wrappedValue: T) {
        _wrappedValue = wrappedValue
    }
    
    public func read<U>(_ block: (T) throws -> U) rethrows -> U {
        lock.lock()
        defer { lock.unlock() }
        return try block(_wrappedValue)
    }
    
    public func update<U>(_ block: (inout T) throws -> U) rethrows -> U {
        lock.lock()
        defer { lock.unlock() }
        return try block(&_wrappedValue)
    }
}

extension LockedBox where T: Numeric {
    @discardableResult
    public func increment() -> T {
        update { n in
            n += 1
            return n
        }
    }
    
    @discardableResult
    public func decrement() -> T {
        update { n in
            n -= 1
            return n
        }
    }
}
