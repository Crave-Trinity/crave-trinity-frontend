//
//  AppCoordinator.swift
//  CravePhone
//
//  Description:
//    A basic Coordinator that sets up the root SwiftUI View.
//    Marked @MainActor so its methods are safely called from SwiftUI.
//
//  Created by ...
//  Updated by ChatGPT on ...
//

import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject {
    
    private let container: DependencyContainer
    
    public init(container: DependencyContainer) {
        self.container = container
    }
    
    // The root SwiftUI view for this coordinator
    public func start() -> some View {
        CRAVETabView(coordinator: self)
    }
    
    // MARK: - Factory Methods
    public func makeLogCravingView() -> LogCravingView {
        LogCravingView(viewModel: container.makeLogCravingViewModel())
    }
    
    public func makeCravingListView() -> CravingListView {
        CravingListView(viewModel: container.makeCravingListViewModel())
    }
    
    // Example if you want an Analytics screen:
    // public func makeAnalyticsView() -> AnalyticsDashboardView {
    //     AnalyticsDashboardView(viewModel: container.makeAnalyticsDashboardViewModel())
    // }
}
