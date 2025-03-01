//
//  AppCoordinator.swift
//  CravePhone
//
//  Purpose:
//   - Provides methods for creating major feature views (Log Craving, Craving List, Analytics, AI Chat).
//   - Each method returns a SwiftUI view, using your DependencyContainer.
//
//  Usage:
//   - CRAVETabView calls these methods to render the correct tab contents.
//   - Confirm that "DependencyContainer" has the necessary "makeXYZViewModel()" methods.
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
        // Example: build the VM from your container, then return the view
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
    
    // MARK: - Optional “start()” if needed
    // If you still use CoordinatorHostView, you could do:
    public func start() -> some View {
        // e.g. return a NavigationView wrapping a main menu, or CRAVETabView
        CRAVETabView(coordinator: self)
    }
}
