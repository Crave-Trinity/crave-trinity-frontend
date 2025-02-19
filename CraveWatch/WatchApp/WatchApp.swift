//
//  CRAVEWatchApp.swift
//  CraveWatch
//
//  Created by John H Jung on 2/18/25.
//  Description: The main entry point for the CraveWatch app.
//               Sets up top-level dependencies and SwiftData for watch-based cravings.
//
import SwiftUI
import WatchKit
import SwiftData  // Import SwiftData so we can call .modelContainer

@main
struct CRAVEWatchApp: App {
    // A single source-of-truth dependency container.
    @StateObject private var dependencyContainer = WatchDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                dependencyContainer.watchCoordinator.rootView
            }
            // IMPORTANT: Register your SwiftData model(s) here.
            .modelContainer(for: [WatchCravingEntity.self])
        }
    }
}
