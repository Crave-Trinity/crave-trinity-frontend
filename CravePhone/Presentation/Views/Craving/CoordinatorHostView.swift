/*
 ┌───────────────────────────────────────────────────────┐
 │  Directory: CravePhone/Views/Craving                 │
 │  Production-Ready SwiftUI Cleanup: CoordinatorHostView│
 │  Notes:                                              │
 │   - No nested NavigationView.                        │
 │   - Simplified hosting for AppCoordinator.           │
 └───────────────────────────────────────────────────────┘
*/

import SwiftUI

@MainActor
public struct CoordinatorHostView: View {
    @StateObject private var coordinator: AppCoordinator
    
    public init(container: DependencyContainer) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }
    
    public var body: some View {
        // Single point of navigation hosting
        coordinator.start()
    }
}

