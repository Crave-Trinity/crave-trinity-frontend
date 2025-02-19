//
//  WatchApp.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: The main entry point for the CraveWatch app.
//               Sets up top-level dependencies and SwiftData for watch-based cravings.
//

import SwiftUI
import WatchKit
import SwiftData

@main
struct WatchApp: App {
    // A single source-of-truth dependency container for watch services.
    @StateObject private var dependencyContainer = WatchDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                // The coordinator’s rootView determines the initial screen of the watch app.
                dependencyContainer.watchCoordinator.rootView
            }
            // IMPORTANT: Register your SwiftData model(s) here.
            .modelContainer(for: [WatchCravingEntity.self])
        }
    }
}
