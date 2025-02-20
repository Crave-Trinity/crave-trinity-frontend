//
//  PhoneApp.swift
//  CravePhone
//
//  Description:
//    The main SwiftUI entry point for the app.
//    Creates the DependencyContainer, passes it to CoordinatorHostView.
//
//  Created by ...
//  Updated by ChatGPT on ...
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
