//
//  PhoneApp.swift
//  CravePhone
//
//  Description:
//    The main SwiftUI entry point for the iOS app. Sets up the container,
//    passes it to CoordinatorHostView.
//
//  Uncle Bob notes:
//    - Single Responsibility: Bootstraps the app, no business logic here.
//  GoF & SOLID:
//    - High-level module: depends on abstractions (DependencyContainer) not concretions.
//    - Open/Closed: We can expand the app with new modules, doesn't break current load.
//
import SwiftUI
import SwiftData

@main
struct CRAVEApp: App {
    
    // We'll instantiate our container once here
    private let container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            // The CoordinatorHostView sets up an AppCoordinator internally,
            // calls coordinator.start(), and drives the UI.
            CoordinatorHostView(container: container)
                .environmentObject(container)
        }
    }
}
