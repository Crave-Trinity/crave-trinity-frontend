//
//  WatchApp.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: The main entry point for the watch app.
//               Sets up SwiftData and a top-level navigation.
//

import SwiftUI
import WatchKit
import SwiftData

@main
struct WatchApp: App {
    // Dependency container for watch services
    @StateObject private var dependencyContainer = WatchDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                // The watch coordinator’s root view
                dependencyContainer.watchCoordinator.rootView
            }
            // Register the SwiftData model
            .modelContainer(for: [WatchCravingEntity.self])
        }
    }
}
