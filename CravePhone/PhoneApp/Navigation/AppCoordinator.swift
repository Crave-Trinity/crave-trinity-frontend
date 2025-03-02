//=========================================
//  AppCoordinator.swift
//  CravePhone
//
//  DESCRIPTION:
//    - Manages each major feature view in the navigation or tab setup.
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: Provide creation for each screen.
//
//  LAST UPDATED: <today's date>
//=========================================
import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject {
    private let container: DependencyContainer
    
    public init(container: DependencyContainer) {
        self.container = container
    }
    
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
    
    public func start() -> some View {
        CRAVETabView(coordinator: self)
    }
}
