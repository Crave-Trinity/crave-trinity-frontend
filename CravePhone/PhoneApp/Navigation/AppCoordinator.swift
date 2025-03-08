//
// File: CravePhone/PhoneApp/Navigation/AppCoordinator.swift
// PURPOSE:
//  - Coordinates root-level navigation in SwiftUI, now includes a splash flow.
//  - Uses the DependencyContainer factory methods for Splash and Login.
// UNCLE BOB + STEVE JOBS STYLE – COMPLETE PASTE & RUN
//
import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject {
    
    public enum AppState {
        case splash
        case loggedOut
        case loggedIn
    }
    
    @Published public var appState: AppState = .splash
    
    private let container: DependencyContainer
    
    // 1) Make this init NON-public if `DependencyContainer` is internal
    init(container: DependencyContainer) {
        self.container = container
    }
    
    // MARK: - State Transitions
    public func setLoggedIn() {
        appState = .loggedIn
    }
    
    public func setLoggedOut() {
        appState = .loggedOut
    }
    
    // MARK: - View Builders
    func makeLogCravingView() -> some View {
        KeyboardAdaptiveHostingView(
            LogCravingView(viewModel: self.container.makeLogCravingViewModel()) // use self.container
        )
        .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
    }
    
    func makeCravingListView() -> some View {
        CravingListView(viewModel: self.container.makeCravingListViewModel())
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
    }
    
    func makeAnalyticsDashboardView() -> some View {
        AnalyticsDashboardView(viewModel: self.container.makeAnalyticsViewModel())
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
    }
    
    func makeChatView() -> some View {
        ChatView(viewModel: self.container.makeChatViewModel())
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
    }
    
    // MARK: - Start Root Flow
    public func start() -> some View {
        switch appState {
        case .splash:
            return AnyView(
                SplashView(viewModel: self.container.makeSplashViewModel(coordinator: self))
            )
        case .loggedOut:
            return AnyView(
                LoginView(viewModel: self.container.makeLoginViewModel(coordinator: self))
            )
        case .loggedIn:
            return AnyView(
                CRAVETabView(coordinator: self)
            )
        }
    }
}
