import class Foundation.Bundle
import class Foundation.NSDictionary

// This class supports extracting the version information of the runtime.

// MARK: SQLEnclave Module Metadata

/// The bundle for the `SQLEnclave` module.
public let SQLEnclaveBundle = Foundation.Bundle.module

/// The information plist for the `SQLEnclave` module, which is stored in `Resources/SQLEnclave.plist` (until SPM supports `Info.plist`).
private let SQLEnclavePlist = SQLEnclaveBundle.url(forResource: "SQLEnclave", withExtension: "plist")!

/// The info dictionary for the `SQLEnclave` module.
public let SQLEnclaveInfo = NSDictionary(contentsOf: SQLEnclavePlist)

/// The bundle identifier of the `SQLEnclave` module as specified by the `CFBundleIdentifier` of the `SQLEnclaveInfo`.
public let SQLEnclaveBundleIdentifier: String! = SQLEnclaveInfo?["CFBundleIdentifier"] as? String

/// The version of the `SQLEnclave` module as specified by the `CFBundleShortVersionString` of the `SQLEnclaveInfo`.
public let SQLEnclaveVersion: String! = SQLEnclaveInfo?["CFBundleShortVersionString"] as? String

/// The version components of the `CFBundleShortVersionString` of the `SQLEnclaveInfo`, such as `[0, 0, 1]` for "0.0.1" ` or `[1, 2]` for "1.2"
private let SQLEnclaveV = { SQLEnclaveVersion.components(separatedBy: .decimalDigits.inverted).compactMap({ Int($0) }).dropFirst($0).first }

/// The major, minor, and patch version components of the `SQLEnclave` module's `CFBundleShortVersionString`
public let (SQLEnclaveVersionMajor, SQLEnclaveVersionMinor, SQLEnclaveVersionPatch) = (SQLEnclaveV(0), SQLEnclaveV(1), SQLEnclaveV(2))

/// A comparable representation of ``SQLEnclaveVersion``, which can be used for comparing known versions and sorting via semver semantics.
///
/// The form of the number is `(major*1M)+(minor*1K)+patch`, so version "1.2.3" becomes `001_002_003`.
/// Caveat: any minor or patch version components over `999` will break the comparison expectation.
public let SQLEnclaveVersionNumber = ((SQLEnclaveVersionMajor ?? 0) * 1_000_000) + ((SQLEnclaveVersionMinor ?? 0) * 1_000) + (SQLEnclaveVersionPatch ?? 0)
