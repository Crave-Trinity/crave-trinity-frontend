//
//  CoordinatorHostView.swift
//  CravePhone
//
//  - Hosts the AppCoordinator’s main view in SwiftUI.
//  - No .ignoresSafeArea(). Each child decides its own approach.
//

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
