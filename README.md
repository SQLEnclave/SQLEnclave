SQL Enclave
===========

SQL Enclave is an encrypted data substrate for Swift apps based on SQLite and SQLCipher. It is a cross-platform Darwin (macOS, iOS, tvOS, watchOS) and Linux SPM module with no external dependencies.

SQLEnclave can be included in your project with:

```swift

```

## Example

### Connecting to an encrypted database

```swift

```

### Changing the key of an encrypted database

```swift

```

### Binding Swift types to database schema

```swift

```

## Provenance

SQL Enclave is mostly a re-packaging of multiple independent projects:

 - [SQLite][] by D. Richard Hipp: the ubiquitous embedded SQL database
 - [SQLCipher][] by : patches to SQLite and [GRDB][] ([contributed by DuckDuckGo](https://github.com/duckduckgo/GRDB.swift)) to integrate the SQLCipher encryption suite
 - [GRDBQuery][] by Gwendal Roué: Swift bindings for SQLite
 - A bit of jiggery-pokery to get Linux passing
 
Browse the [API Documentation].

## Frequently Asked Questions

1. What cryptography libraries does SQLEnclave use?

    SQLCipher (and therefore also SQLEnclave) uses CommonCrypto on Darwin platforms and OpenSSL on Linux to implement cryptography features.

1. Is SQLEnclave compatible with SQLite?

    SQLEnclave embeds SQLite itself, and so it can interact seamlessly with `.sqlite3` databases created with other apps. Note, however, that an encrypted `.enclave` database will not be readable by most `sqlite3` executables found on other platforms.

1. How does SQLEnclave compare with the built-in SQLite framework on iOS?

    The version of SQLite that ships with Darwin platforms does not have any encryption capabilities. Other than that, the two frameworks are identical.

    SQLEnclave will run slower in Debug mode than the built-in SQLite module, but in Release mode the performance of unencrypted operations should be comparable. 

1. Can I trust the format of the SQLite database for long-term data storage?

    SQLite is one of four formats (along with XML, JSON, and CSV) recommended for [long-term storage of datasets](https://www.sqlite.org/locrsf.html) by the United States Library of Congress.



[SQLCipher Community Edition](https://www.zetetic.net/sqlcipher/open-source/)

[Swift Package Manager]: https://swift.org/package-manager
[API Documentation]: https://www.sqlenclave.org/SQLEnclave/documentation/sqlenclave/

[ProjectLink]: https://github.com/SQLEnclave/SQLEnclave
[ActionsLink]: https://github.com/SQLEnclave/SQLEnclave/actions
[API Documentation]: https://www.sqlenclave.org/SQLEnclave/documentation/sqlenclave/

[Swift]: https://swift.org/
[SQLite]: https://sqlite.org/
[SQLCipher]: https://www.zetetic.net/sqlcipher/
[GRDB]: https://github.com/groue/GRDB.swift
[GRDBQuery]: https://github.com/groue/GRDBQuery

[GitHubActionBadge]: https://img.shields.io/github/workflow/status/SQLEnclave/SQLEnclave/SQLEnclave%20CI

[Swift5Badge]: https://img.shields.io/badge/swift-5-orange.svg?style=flat
[Swift5Link]: https://developer.apple.com/swift/
[SwiftPlatforms]: https://img.shields.io/badge/Platforms-macOS%20|%20iOS%20|%20tvOS%20|%20Linux-teal.svg





