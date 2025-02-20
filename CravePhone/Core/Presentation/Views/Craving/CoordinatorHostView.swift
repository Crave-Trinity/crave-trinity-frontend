//
//  CoordinatorHostView.swift
//  CravePhone
//
//  Description:
//    A simple view that owns an AppCoordinator as a @StateObject.
//    Then displays coordinator.start().
//
//  Created by ...
//  Updated by ChatGPT on ...
//

import SwiftUI

@MainActor
public struct CoordinatorHostView: View {
    @StateObject private var coordinator: AppCoordinator
    
    public init(container: DependencyContainer) {
        // We must create the coordinator here:
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }
    
    public var body: some View {
        coordinator.start()
    }
}
