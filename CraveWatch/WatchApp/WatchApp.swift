//
//  CraveWatchApp.swift
//  CraveWatch Watch App
//
//  Created by John H Jung on 2/18/25.
//

import SwiftUI
import WatchKit

@main
struct CRAVEWatchApp: App {
    // We reference our watch dependency container to provide single-source-of-truth services.
    @StateObject private var dependencyContainer = WatchDependencyContainer()

    var body: some Scene {
        WindowGroup {
            // Start with our optional watch coordinator, or a direct view if you want something simpler
            NavigationView {
                dependencyContainer.watchCoordinator.rootView
            }
        }
    }
}

