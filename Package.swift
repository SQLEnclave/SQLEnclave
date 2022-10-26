// swift-tools-version:5.6
import PackageDescription

extension Platform {
#if os(macOS)
	static let current: Platform = .macOS
#elseif os(iOS)
	static let current: Platform = .iOS
#elseif os(tvOS)
	static let current: Platform = .tvOS
#elseif os(watchOS)
	static let current: Platform = .watchOS
#elseif os(Linux)
	static let current: Platform = .linux
#elseif os(Windows)
	static let current: Platform = .windows
#else
#error("Unsupported platform.")
#endif
}

#if canImport(Combine)
let hasCombine = true
#else
let hasCombine = false
#endif

let package = Package(
    name: "SQLEnclave",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        .library(name: "SQLEnclave", targets: ["SQLEnclave"]),
    ],
    dependencies: [
        hasCombine ? nil : .package(url: "https://github.com/OpenCombine/OpenCombine.git", from: "0.13.0"),
    ].compactMap({ $0 }),
    targets: [
        .systemLibrary(
            name: "OpenSSL",
            pkgConfig: "openssl",
            providers: [
                .apt(["openssl libssl-dev"]),
                .brew(["openssl"])
            ]
        ),
        .target(
            name: "SQLEnclave",
            dependencies: [
                "SQLCipher",
                Platform.current == .linux ? "OpenSSL" : nil,
                hasCombine ? nil : .product(name: "OpenCombineShim", package: "OpenCombine"),
            ].compactMap({ $0 }),
            resources: [.process("Resources")],
            cSettings: [
                 .define("SQLITE_HAS_CODEC"),
                 .define("SQLITE_TEMP_STORE", to: "2"),
                 .define("SQLITE_SOUNDEX"),
                 .define("SQLITE_THREADSAFE"),
                 .define("SQLITE_ENABLE_RTREE"),
                 .define("SQLITE_ENABLE_STAT3"),
                 .define("SQLITE_ENABLE_STAT4"),
                 .define("SQLITE_ENABLE_COLUMN_METADATA"),
                 .define("SQLITE_ENABLE_MEMORY_MANAGEMENT"),
                 .define("SQLITE_ENABLE_LOAD_EXTENSION"),
                 .define("SQLITE_ENABLE_FTS4"),
                 .define("SQLITE_ENABLE_FTS4_UNICODE61"),
                 .define("SQLITE_ENABLE_FTS3_PARENTHESIS"),
                 .define("SQLITE_ENABLE_UNLOCK_NOTIFY"),
                 .define("SQLITE_ENABLE_JSON1"),
                 .define("SQLITE_ENABLE_FTS5"),
                 .define("SQLCIPHER_CRYPTO_CC"),
                 .define("HAVE_USLEEP", to: "1"),
                 .define("SQLITE_MAX_VARIABLE_NUMBER", to: "99999")
             ],
             swiftSettings: [
                 .define("SQLITE_HAS_CODEC"),
                 .define("SQL_ENCLAVE_CIPHER"),
                 .define("SQLITE_ENABLE_FTS5")
             ]),
        .target(
             name: "SQLCipher",
             cSettings: [
                 // .unsafeFlags(["-Wno-conversion"]), // causes: "error: the target 'SQLCipher' in product 'SQLEnclave' contains unsafe build flags" so we add the following to sqlite.c instead: #pragma clang diagnostic ignored "-Wconversion"
                 .define("NDEBUG"),
                 .define("SQLITE_HAS_CODEC"),
                 .define("SQLITE_TEMP_STORE", to: "2"),
                 .define("SQLITE_SOUNDEX"),
                 .define("SQLITE_THREADSAFE"),
                 .define("SQLITE_ENABLE_RTREE"),
                 .define("SQLITE_ENABLE_STAT3"),
                 .define("SQLITE_ENABLE_STAT4"),
                 .define("SQLITE_ENABLE_COLUMN_METADATA"),
                 .define("SQLITE_ENABLE_MEMORY_MANAGEMENT"),
                 .define("SQLITE_ENABLE_LOAD_EXTENSION"),
                 .define("SQLITE_ENABLE_FTS4"),
                 .define("SQLITE_ENABLE_FTS4_UNICODE61"),
                 .define("SQLITE_ENABLE_FTS3_PARENTHESIS"),
                 .define("SQLITE_ENABLE_UNLOCK_NOTIFY"),
                 .define("SQLITE_ENABLE_JSON1"),
                 .define("SQLITE_ENABLE_FTS5"),
                 .define(Platform.current == .linux ? "SQLCIPHER_CRYPTO_OPENSSL" : "SQLCIPHER_CRYPTO_CC"),
                 //.define("LDFLAGS", to: "/usr/lib/x86_64-linux-gnu/libcrypto.a"),
                 .define("HAVE_USLEEP", to: "1"),
                 .define("SQLITE_MAX_VARIABLE_NUMBER", to: "99999"),
                 .define("HAVE_GETHOSTUUID", to: "0"),
                 // .unsafeFlags(["-w"])
             ]),
        .testTarget(
            name: "SQLEnclaveTests",
            dependencies: ["SQLEnclave"],
            path: "Tests")
    ],
    swiftLanguageVersions: [.v5],
    cLanguageStandard: CLanguageStandard.gnu11,
    cxxLanguageStandard: .cxx14
)
