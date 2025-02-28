// AppCoordinator.swift
import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject {
    
    private let container: DependencyContainer
    
    public init(container: DependencyContainer) {
        self.container = container
    }
    
    func start() -> some View {
        CRAVETabView(coordinator: self)
    }
    
    // MARK: - Factory Methods (Views)
    func makeLogCravingView() -> LogCravingView {
        LogCravingView(viewModel: container.makeLogCravingViewModel())
    }
    
    func makeCravingListView() -> CravingListView {
        CravingListView(viewModel: container.makeCravingListViewModel())
    }
    
    func makeAnalyticsDashboardView() -> AnalyticsDashboardView {
        AnalyticsDashboardView(viewModel: container.makeAnalyticsViewModel())
    }
    
    func makeChatView() -> ChatView {
        ChatView(viewModel: container.makeChatViewModel())
    }
}
