// CoordinatorHostView.swift
// CravePhone
//
// Description: A simple view that owns an AppCoordinator as a @StateObject.
// It displays coordinator.start().

import SwiftUI

@MainActor
public struct CoordinatorHostView: View {
    @StateObject private var coordinator: AppCoordinator
    
    public init(container: DependencyContainer) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }
    
    public var body: some View {
        coordinator.start()
    }
}
