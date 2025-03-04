//
//  AppCoordinator.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    Coordinates root-level navigation in SwiftUI.
//    "DESIGNED FOR STEVE JOBS, CODED LIKE UNCLE BOB":
//      - Single Responsibility: Provide top-level views.
//      - Minimal knowledge of the rest of the system.
//      - Correct explicit capture in closures by using `self`.
//      - Wraps views in layout modifiers as needed.
//
//  FIX:
//    The error "Reference to property 'container' in closure requires explicit use of 'self'"
//    is fixed by explicitly referencing `self.container` in each view-creation method.
//

import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject {
    private let container: DependencyContainer

    public init(container: DependencyContainer) {
        self.container = container
    }

    public func makeLogCravingView() -> some View {
        // Wrap LogCravingView in KeyboardAdaptiveHostingView for proper keyboard handling
        return KeyboardAdaptiveHostingView(
            LogCravingView(viewModel: self.container.makeLogCravingViewModel())
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    public func makeCravingListView() -> some View {
        return CravingListView(viewModel: self.container.makeCravingListViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    public func makeAnalyticsDashboardView() -> some View {
        return AnalyticsDashboardView(viewModel: self.container.makeAnalyticsViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    public func makeChatView() -> some View {
        // Ensure .frame() is applied to ChatView (not its view model)
        return ChatView(viewModel: self.container.makeChatViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    public func start() -> some View {
        return CRAVETabView(coordinator: self)
    }
}

