//
//  AppCoordinator.swift
//  CravePhone/PhoneApp/Navigation
//
//  RESPONSIBILITY:
//    Coordinates root-level navigation in SwiftUI.
//    Designed for simplicity (Uncle Bob + Steve Jobs style).
//

import SwiftUI
// Ensure you import the module that contains AnalyticsDashboardView.

@MainActor
public final class AppCoordinator: ObservableObject {
    private let container: DependencyContainer

    public init(container: DependencyContainer) {
        self.container = container
    }

    public func makeLogCravingView() -> some View {
        KeyboardAdaptiveHostingView(
            LogCravingView(viewModel: self.container.makeLogCravingViewModel())
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    public func makeCravingListView() -> some View {
        CravingListView(viewModel: self.container.makeCravingListViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    public func makeAnalyticsDashboardView() -> some View {
        AnalyticsDashboardView(viewModel: self.container.makeAnalyticsViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    public func makeChatView() -> some View {
        ChatView(viewModel: self.container.makeChatViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    public func start() -> some View {
        CRAVETabView(coordinator: self)
    }
}
