//
//  WatchApp.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: The main entry point for the watch app. Sets up SwiftData and top-level navigation via a dependency container.
import SwiftUI
import WatchKit
import SwiftData

@main
struct WatchApp: App {
    @StateObject private var dependencyContainer = WatchDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                // Set CravingPagesView as the root view.
                CravingPagesView(connectivityService: dependencyContainer.connectivityService)
            }
            .modelContainer(for: [WatchCravingEntity.self])
        }
    }
}

