//
//  CoordinatorHostView.swift
//  CravePhone
//
//  PURPOSE:
//    - Hosts the AppCoordinator’s main view in SwiftUI.
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: Just bootstrapping the coordinator’s main content.
//
//  LAST UPDATED: <today’s date>
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
