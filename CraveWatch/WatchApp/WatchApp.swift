//  CRAVE
//  Because No One Should Have to Fight Alone.
//
//  In Memoriam:
//  - Juice WRLD (Jarad Higgins) [21]
//  - Lil Peep (Gustav Åhr) [21]
//  - Mac Miller (Malcolm McCormick) [26]
//  - Amy Winehouse [27]
//  - Jimi Hendrix [27]
//  - Heath Ledger [28]
//  - Chris Farley [33]
//  - Pimp C (Chad Butler) [33]
//  - Whitney Houston [48]
//  - Chandler Bing (Matthew Perry) [54]
//
//  And to all those lost to addiction,
//  whose names are remembered in silence.
//
//  Rest in power.
//  This is for you.
//
//  =========================================
//
//  WatchApp.swift
//  CraveWatch
//
//  Entry point for the CRAVE watchOS app.
//  - Initializes the SwiftData ModelContainer.
//  - Injects dependencies.
//  - Uses TabView with CravingLogView as root.
//
//  (C) 2030 – Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

@main
struct WatchApp: App {
    @StateObject private var dependencyContainer = WatchDependencyContainer()

    // Create the SwiftData container at launch (watchOS 10+).
    // We have just ONE SwiftData model: WatchCravingEntity.
    @State private var modelContainer: ModelContainer? = {
        do {
            let container = try ModelContainer(for: WatchCravingEntity.self)
            return container
        } catch {
            // Print the real error to the console to see what's wrong
            print("SwiftData creation error: \(error.localizedDescription)")
            return nil
        }
    }()

    var body: some Scene {
        WindowGroup {
            if let container = modelContainer {
                // Provide the container to the environment so @Environment(\.modelContext) works
                contentView
                    .modelContainer(container)
                    .environmentObject(dependencyContainer)
            } else {
                // If we couldn’t init the container, show an error
                Text("Failed to load data store.")
            }
        }
    }
    
    // The main UI
    @ViewBuilder
    private var contentView: some View {
        TabView {
            NavigationView {
                dependencyContainer.watchCoordinator.rootView
            }
            .tabItem {
                Label("Log", systemImage: "pencil.line")
            }
            // Add other tabs if needed
        }
    }
}




