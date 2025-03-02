//
//  CoordinatorHostView.swift
//  CravePhone
//
//  PURPOSE:
//    - Hosts the AppCoordinator's main view in SwiftUI.
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: Bootstraps the coordinator's main content.
//
//  LAST UPDATED: <today's date>
//
import SwiftUI

@MainActor
public struct CoordinatorHostView: View {
    @StateObject private var coordinator: AppCoordinator
    
    public init(container: DependencyContainer) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }
    
    public var body: some View {
        // The coordinator.start() returns a `View` (like CRAVETabView).
        // We do not need extra geometry fixes here since we already
        // applied the .modifier(SafeAreaInsetsEnvironmentReader()) in PhoneApp.swift.
        coordinator.start()
    }
}
