// FILE: AppCoordinator.swift
// DESCRIPTION:
//  - Ensures each major feature view can expand within the navigation stack or tab setup.

import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject {
    private let container: DependencyContainer
    
    public init(container: DependencyContainer) {
        self.container = container
    }
    
    // Basic factories
    public func makeLogCravingView() -> some View {
        LogCravingView(viewModel: container.makeLogCravingViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    public func makeCravingListView() -> some View {
        CravingListView(viewModel: container.makeCravingListViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    public func makeAnalyticsDashboardView() -> some View {
        AnalyticsDashboardView(viewModel: container.makeAnalyticsViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    public func makeChatView() -> some View {
        ChatView(viewModel: container.makeChatViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Start
    public func start() -> some View {
        CRAVETabView(coordinator: self)
    }
}
