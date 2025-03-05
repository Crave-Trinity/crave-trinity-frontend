//=================================================================
// File: CravePhone/PhoneApp/Navigation/AppCoordinator.swift
// PURPOSE:
//  - Coordinates root-level navigation in SwiftUI, now includes a splash flow.
//  - Uses the DependencyContainer factory methods for Splash and Login.
// UNCLE BOB + STEVE JOBS STYLE – COMPLETE PASTE & RUN
//=================================================================

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
    
    public init(container: DependencyContainer) {
        self.container = container
    }
    
    public func setLoggedIn() {
        appState = .loggedIn
    }
    
    public func setLoggedOut() {
        appState = .loggedOut
    }
    
    public func makeLogCravingView() -> some View {
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
        switch appState {
        case .splash:
            return AnyView(
                SplashView(viewModel: self.container.makeSplashViewModel(coordinator: self))
            )
        case .loggedOut:
            return AnyView(
                LoginView(viewModel: self.container.makeLoginViewModel())
            )
        case .loggedIn:
            return AnyView(
                CRAVETabView(coordinator: self)
            )
        }
    }
}
