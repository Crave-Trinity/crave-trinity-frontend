// CraveWatch/WatchApp/WatchApp.swift (CORRECTED - TabView)
import SwiftUI

@main
struct WatchApp: App {
    @StateObject private var dependencyContainer = WatchDependencyContainer()

    var body: some Scene {
        WindowGroup {
            // Use TabView as the root
            TabView {
                NavigationView{ //wrap in navigation
                    dependencyContainer.watchCoordinator.rootView
                }
                .tabItem {
                    Label("Log", systemImage: "pencil.line") // Add a tab item
                }
                // Add other tabs here later (Emergency, Voice)
            }
            .environmentObject(dependencyContainer) // Pass the dependency container
        }
    }
}
