// FILE: PhoneApp.swift
// DESCRIPTION:
//  - Ensures the root container expands fully.
//  - Minimal safe-area fixes for consistent top-to-bottom usage.

import SwiftUI
import SwiftData

@main
struct CRAVEApp: App {
    
    private let container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            CoordinatorHostView(container: container)
                .environmentObject(container)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // We only ignore safe areas for backgrounds if needed
                .ignoresSafeArea(.container, edges: [])
        }
    }
}
