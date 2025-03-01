//
//  CoordinatorHostView.swift
//  CravePhone
//
//  Hosts the AppCoordinator’s main view in a SwiftUI-friendly way.
//
//  Make sure this file (and AppCoordinator.swift) are in the same
//  target, so SwiftUI can see them.
//

import SwiftUI

@MainActor
public struct CoordinatorHostView: View {
    // StateObject for the Coordinator
    @StateObject private var coordinator: AppCoordinator
    
    // Inject the DependencyContainer in the initializer
    public init(container: DependencyContainer) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }
    
    // The coordinator’s "start()" method returns a SwiftUI view
    public var body: some View {
        coordinator.start()
    }
}
