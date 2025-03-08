//
//  CoordinatorHostView.swift
//  CravePhone
//
//  PURPOSE:
//    - Hosts the AppCoordinator's main view in SwiftUI.
//    - Bootstraps the coordinator's main content.
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: Only responsible for hosting coordinator-driven UI.
//
//  LAST UPDATED: <today's date>
//
import SwiftUI

@MainActor
internal struct CoordinatorHostView: View {
    @StateObject private var coordinator: AppCoordinator
    
    // Make the initializer internal to match the internal DependencyContainer
    internal init(container: DependencyContainer) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }
    
    internal var body: some View {
        // coordinator.start() returns the appropriate root view
        coordinator.start()
    }
}
