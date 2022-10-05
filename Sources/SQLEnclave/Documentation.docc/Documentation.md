# ``SQLEnclave``

The SwiftUI companion for SQLEnclave

## Overview

This library helps building SwiftUI applications that access "services", such as a local database, through the SwiftUI environment.

## What's in the Box?

SQLEnclave provides two property wrappers:

- With **`@Query`**, SwiftUI views can display database values, and automatically update when database content changes. Generally speaking, `@Query` helps subscribing to Combine publishers defined from the SwiftUI environment:

    ```swift
    /// A view that displays an always up-to-date list of players in the database.
    struct PlayerList: View {
        @Query(PlayersRequest())
        var players: [Player]
        
        var body: some View {
            List(players) { player in Text(player.name) }
        }
    }
    ```

- With **`@EnvironmentStateObject`**, applications can build observable objects that find their dependencies in the SwiftUI environment:

    ```swift
    /// A view that displays the list of players provided by its view model.
    struct PlayerList: View {
        @EnvironmentStateObject var viewModel: PlayerListViewModel
        
        init() {
            _viewModel = EnvironmentStateObject { env in
                PlayerListViewModel(database: env.database)
            }
        }
        
        var body: some View {
            List(viewModel.players) { player in Text(player.name) }
        }
    }
    ```
    
    `@EnvironmentStateObject` is a general-purpose property wrapper, akin to the SwiftUI `@Environment`, `@EnvironmentObject`, `@ObservedObject`, and `@StateObject`.
    
    It fits well the view models of the MVVM architecture, as well as dependency injection. 

Both property wrappers can work together, so that developers can run quick experiments, build versatile previews, and also apply strict patterns and conventions. Pick `@Query`, or `@EnvironmentStateObject`, depending on your needs!

[Download SQLEnclave on GitHub](http://github.com/sqlenclave/SQLEnclave)

## Topics

### The @Query property wrapper

- <doc:GettingStarted>
- <doc:QueryableParameters>
- ``Query``
- ``QueryObservation``
- ``Queryable``

### The MVVM architecture

- <doc:MVVM>
- ``EnvironmentStateObject``

[SQLEnclave]: http://github.com/sqlenclave/SQLEnclave
