//
//  WatchApp.swift
//  CraveWatch
//
//  Description: The main entry point for the CraveWatch app.
//               Sets up top-level dependencies and SwiftData for watch-based cravings.
//

import SwiftUI
import WatchKit
import SwiftData  // Import SwiftData so we can call .modelContainer

@main
struct WatchApp: App {
    // A single source-of-truth dependency container for watch services.
    @StateObject private var dependencyContainer = WatchDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                // Your coordinator’s rootView determines the app’s initial screen.
                // Could be a CravingLogView or any other watch screen.
                dependencyContainer.watchCoordinator.rootView
            }
            // IMPORTANT: Register your SwiftData model(s) here.
            .modelContainer(for: [WatchCravingEntity.self])
        }
    }
}
