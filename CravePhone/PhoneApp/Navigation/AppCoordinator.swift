//APPCOORDINATOR

import SwiftUI

/// AppCoordinator is responsible for managing the application's navigation and creating views.
@MainActor
public final class AppCoordinator: ObservableObject {
    
    private let container: DependencyContainer
    
    // MARK: - Initializer
    public init(container: DependencyContainer) {
        self.container = container
    }
    
    // MARK: - Root View
    /// Returns the root view for the app, which is typically the main tab view.
    /// This method is internal as it's part of the app's main logic and doesn't need to be exposed outside.
    func start() -> some View {
        // Returning the root view for the app. Keeping this method internal to avoid public exposure of internal views.
        CRAVETabView(coordinator: self)
    }
    
    // MARK: - Factory Methods (View Creation)
    func makeLogCravingView() -> LogCravingView {
        LogCravingView(viewModel: container.makeLogCravingViewModel())
    }
    
    func makeCravingListView() -> CravingListView {
        CravingListView(viewModel: container.makeCravingListViewModel())
    }
}
