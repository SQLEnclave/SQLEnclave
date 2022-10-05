Custom SQLite Builds
====================

By default, SQLEnclave uses the version of SQLite that ships with the target operating system.

**You can build SQLEnclave with a custom build of [SQLite 3.33.0](https://www.sqlite.org/changes.html).**

A custom SQLite build can activate extra SQLite features, and extra SQLEnclave features as well, such as support for the [FTS5 full-text search engine](../../../#full-text-search), and [SQLite Pre-Update Hooks](../../../#support-for-sqlite-pre-update-hooks).

SQLEnclave builds SQLite with [swiftlyfalling/SQLiteLib](https://github.com/swiftlyfalling/SQLiteLib), which uses the same SQLite configuration as the one used by Apple in its operating systems, and lets you add extra compilation options that leverage the features you need.

**To install SQLEnclave with a custom SQLite build:**

1. Clone the SQLEnclave git repository, checkout the latest tagged version:
    
    ```sh
    cd [SQLEnclave directory]
    git checkout [latest tag]
    git submodule update --init SQLiteCustom/src
    ```
    
2. Choose your [extra compilation options](https://www.sqlite.org/compile.html). For example, `SQLITE_ENABLE_FTS5`, `SQLITE_ENABLE_PREUPDATE_HOOK`.
    
    It is recommended that you enable the `SQLITE_ENABLE_SNAPSHOT` option. It allows SQLEnclave to optimize [ValueObservation](../README.md#valueobservation) when you use a [Database Pool](../README.md#database-pools).

3. Create a folder named `SQLEnclaveCustomSQLite` somewhere in your project directory.

4. Create four files in the `SQLEnclaveCustomSQLite` folder:

    - `SQLiteLib-USER.xcconfig`: this file sets the extra SQLite compilation flags.
        
        ```xcconfig
        // As many -D options as there are custom SQLite compilation options
        // Note: there is no space between -D and the option name.
        CUSTOM_SQLLIBRARY_CFLAGS = -DSQLITE_ENABLE_SNAPSHOT -DSQLITE_ENABLE_FTS5
        ```
    
    - `SQLEnclaveCustomSQLite-USER.xcconfig`: this file lets SQLEnclave know about extra compilation flags, and enables extra SQLEnclave APIs.
        
        ```xcconfig
        // As many -D options as there are custom SQLite compilation options
        // Note: there is one space between -D and the option name.
        CUSTOM_OTHER_SWIFT_FLAGS = -D SQLITE_ENABLE_SNAPSHOT -D SQLITE_ENABLE_FTS5
        ```
    
    - `SQLEnclaveCustomSQLite-USER.h`: this file lets your application know about extra compilation flags.
        
        ```c
        // As many #define as there are custom SQLite compilation options
        #define SQLITE_ENABLE_SNAPSHOT
        #define SQLITE_ENABLE_FTS5
        ```
    
    - `SQLEnclaveCustomSQLite-INSTALL.sh`: this file installs the three other files.
        
        ```sh
        # License: MIT License
        # https://github.com/swiftlyfalling/SQLiteLib/blob/master/LICENSE
        #
        #######################################################
        #                   PROJECT PATHS
        #  !! MODIFY THESE TO MATCH YOUR PROJECT HIERARCHY !!
        #######################################################
        
        # The path to the folder containing SQLEnclaveCustom.xcodeproj:
        SQLEnclave_SOURCE_PATH="${PROJECT_DIR}/SQLEnclave"
        
        # The path to your custom "SQLiteLib-USER.xcconfig":
        SQLITELIB_XCCONFIG_USER_PATH="${PROJECT_DIR}/SQLEnclaveCustomSQLite/SQLiteLib-USER.xcconfig"
        
        # The path to your custom "SQLEnclaveCustomSQLite-USER.xcconfig":
        CUSTOMSQLITE_XCCONFIG_USER_PATH="${PROJECT_DIR}/SQLEnclaveCustomSQLite/SQLEnclaveCustomSQLite-USER.xcconfig"
        
        # The path to your custom "SQLEnclaveCustomSQLite-USER.h":
        CUSTOMSQLITE_H_USER_PATH="${PROJECT_DIR}/SQLEnclaveCustomSQLite/SQLEnclaveCustomSQLite-USER.h"
        
        #######################################################
        #
        #######################################################
        
        
        if [ ! -d "$SQLEnclave_SOURCE_PATH" ];
        then
        echo "error: Path to SQLEnclave source (SQLEnclave_SOURCE_PATH) missing/incorrect: $SQLEnclave_SOURCE_PATH"
        exit 1
        fi
        
        SyncFileChanges () {
            SOURCE=$1
            DESTINATIONPATH=$2
            DESTINATIONFILENAME=$3
            DESTINATION="${DESTINATIONPATH}/${DESTINATIONFILENAME}"
            
            if [ ! -f "$SOURCE" ];
            then
            echo "error: Source file missing: $SOURCE"
            exit 1
            fi
            
            rsync -a "$SOURCE" "$DESTINATION"
        }
        
        SyncFileChanges $SQLITELIB_XCCONFIG_USER_PATH "${SQLEnclave_SOURCE_PATH}/SQLiteCustom/src" "SQLiteLib-USER.xcconfig"
        SyncFileChanges $CUSTOMSQLITE_XCCONFIG_USER_PATH "${SQLEnclave_SOURCE_PATH}/SQLiteCustom" "SQLEnclaveCustomSQLite-USER.xcconfig"
        SyncFileChanges $CUSTOMSQLITE_H_USER_PATH "${SQLEnclave_SOURCE_PATH}/SQLiteCustom" "SQLEnclaveCustomSQLite-USER.h"
        
        echo "Finished syncing"
        ```
        
        Modify the top of `SQLEnclaveCustomSQLite-INSTALL.sh` file so that it contains correct paths.

5. Embed the `SQLEnclaveCustom.xcodeproj` project in your own project.

6. Add the `SQLEnclaveCustomSQLiteOSX` or `SQLEnclaveCustomSQLiteiOS` target in the **Target Dependencies** section of the **Build Phases** tab of your **application target**.

7. Add the `SQLEnclaveCustomSQLite.framework` from the targeted platform to the **Embedded Binaries** section of the **General**  tab of your **application target**.

8. Add a Run Script phase for your target in the **Pre-actions** section of the **Build** tab of your **application scheme**:
    
    ```sh
    source "${PROJECT_DIR}/SQLEnclaveCustomSQLite/SQLEnclaveCustomSQLite-INSTALL.sh"
    ```
    
    The path should be the path to your `SQLEnclaveCustomSQLite-INSTALL.sh` file.
    
    Select your application target in the "Provide build settings from" menu.

9. Check the "Shared" checkbox of your application scheme (this lets you commit the pre-action in your Version Control System).

Now you can use SQLEnclave with your custom SQLite build:

```swift
import SQLEnclave

let dbQueue = try DatabaseQueue(...)
```
