//
//  AppCoordinator.swift
//  CravePhone
//
//  Description:
//    A simple coordinator that tracks which tab is selected
//    and orchestrates navigation across tabs.
//

import SwiftUI
import Combine

public class AppCoordinator: ObservableObject {
    @Published var selectedTab: Int = 0
    private let container: DependencyContainer
    private var cancellables = Set<AnyCancellable>()

    public init(container: DependencyContainer) {
        self.container = container
    }

    public func start() -> some View {
        CRAVETabView(container: container)
    }
}
