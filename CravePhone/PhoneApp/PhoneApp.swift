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
                // Full-screen expansion
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // Extend background across safe areas if needed
                .ignoresSafeArea(edges: .all)
        }
    }
}

