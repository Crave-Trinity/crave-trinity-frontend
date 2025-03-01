//
//  AppCoordinator.swift
//  CravePhone
//
//  Purpose:
//   - Provides methods for creating major feature views (Log Craving, Craving List, Analytics, AI Chat).
//   - Each method returns a SwiftUI view, using your DependencyContainer.
//

import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject {
    private let container: DependencyContainer
    
    public init(container: DependencyContainer) {
        self.container = container
    }
    
    // MARK: - View Constructors
    
    public func makeLogCravingView() -> some View {
        let vm = container.makeLogCravingViewModel()
        return LogCravingView(viewModel: vm)
    }
    
    public func makeCravingListView() -> some View {
        let vm = container.makeCravingListViewModel()
        return CravingListView(viewModel: vm)
    }
    
    public func makeAnalyticsDashboardView() -> some View {
        let vm = container.makeAnalyticsViewModel()
        return AnalyticsDashboardView(viewModel: vm)
    }
    
    public func makeChatView() -> some View {
        let vm = container.makeChatViewModel()
        return ChatView(viewModel: vm)
    }
    
    // If you still use a root coordinator approach:
    public func start() -> some View {
        // Return a tab view or main NavView
        CRAVETabView(coordinator: self)
    }
}
