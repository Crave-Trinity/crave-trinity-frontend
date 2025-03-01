//
//  AppCoordinator.swift
//  CravePhone
//
//  Description:
//    An ObservableObject responsible for wiring up dependency containers
//    and returning the core SwiftUI Views.
//
//  Uncle Bob notes:
//    - Single Responsibility: Creates Views from container (MVVM).
//    - Open/Closed: We can add new 'make' methods for new flows without breaking existing ones.
//  GoF & SOLID:
//    - Abstract Factory / Factory Method approach for generating each screen.
//    - Minimizes direct coupling with view constructors.
//
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
