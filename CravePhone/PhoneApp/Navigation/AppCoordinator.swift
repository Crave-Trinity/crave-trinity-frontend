//
//  AppCoordinator.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    Coordinates root-level navigation in SwiftUI.
//
//  "DESIGNED FOR STEVE JOBS, CODED LIKE UNCLE BOB":
//    - Single Responsibility: Provide top-level views.
//    - Minimal knowledge of the rest of the system.
//
import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject {
    private let container: DependencyContainer

    public init(container: DependencyContainer) {
        self.container = container
    }

    public func makeLogCravingView() -> some View {
        // NEW: Wrap the SwiftUI LogCravingView in our KeyboardAdaptiveHostingView
        KeyboardAdaptiveHostingView(
            LogCravingView(viewModel: container.makeLogCravingViewModel())
        )
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
