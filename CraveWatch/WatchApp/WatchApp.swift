//
//  WatchApp.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: The main entry point for the watch app. Sets up SwiftData and a top-level navigation via a dependency container.
//

import SwiftUI
import WatchKit
import SwiftData

@main
struct WatchApp: App {
    // Create the dependency container for watch services.
    @StateObject private var dependencyContainer = WatchDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                // The watch coordinator provides the root view.
                dependencyContainer.watchCoordinator.rootView
            }
            // Registers the SwiftData model container for WatchCravingEntity.
            .modelContainer(for: [WatchCravingEntity.self])
        }
    }
}

