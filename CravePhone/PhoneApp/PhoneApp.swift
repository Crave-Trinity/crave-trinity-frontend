// CRAVEApp.swift
import SwiftUI
import SwiftData

@main
struct CRAVEApp: App {
    @StateObject private var container: DependencyContainer  = DependencyContainer() // Create it here, ONCE.

    var body: some Scene {
        WindowGroup {
            CRAVETabView(container: container) //Pass container
                .environmentObject(container) // Inject into environment
        }
    }
}


