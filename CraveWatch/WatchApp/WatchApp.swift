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

/// The main entry point for the WatchOS application.
/// This struct defines the app’s life cycle and manages high-level dependency injection.
@main
struct WatchApp: App {
    /// A shared container for dependencies, injected into the environment.
    @StateObject private var dependencyContainer = WatchDependencyContainer()
    
    /// SwiftData model container responsible for persisting and managing the WatchCravingEntity.
    /// It is initialized at launch for watchOS 10+.
    @State private var modelContainer: ModelContainer? = {
        do {
            // Attempt to create a ModelContainer for the WatchCravingEntity data model.
            let container = try ModelContainer(for: WatchCravingEntity.self)
            return container
        } catch {
            // Log the error with details if initialization fails.
            print("SwiftData creation error: \(error.localizedDescription)")
            return nil
        }
    }()
    
    /// State to control whether to show the splash screen.
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if let container = modelContainer {
                if showSplash {
                    SplashScreenView()
                        .onAppear {
                            // Display the splash screen for 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showSplash = false
                                }
                            }
                        }
                        .modelContainer(container)
                        .environmentObject(dependencyContainer)
                } else {
                    contentView
                        .modelContainer(container)
                        .environmentObject(dependencyContainer)
                }
            } else {
                // Display an error message if the data container fails to initialize.
                Text("Failed to load data store.")
            }
        }
    }
    
    /// The primary user interface of the app, organized as a TabView.
    /// Currently, it displays a NavigationView that holds the root view provided by the watch coordinator.
    @ViewBuilder
    private var contentView: some View {
        TabView {
            NavigationView {
                dependencyContainer.watchCoordinator.rootView
            }
            .tabItem {
                Label("Log", systemImage: "pencil.line")
            }
            // Future tabs can be added here as needed.
        }
    }
}

/// A simple splash screen view displayed on app launch.
struct SplashScreenView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Replace "AppLogo" with your actual asset name.
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            Text("CRAVE")
                .font(.title)
                .fontWeight(.bold)
            Text("Because No One Should Have to Fight Alone.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
