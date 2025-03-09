// File: SplashViewModel.swift
// PURPOSE: Checks Keychain for a valid token and directs the app flow accordingly.
import SwiftUI

@MainActor
class SplashViewModel: ObservableObject {
    private let coordinator: AppCoordinator
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    func onAppear() {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // Brief delay for splash
            if let tokenData = KeychainHelper.load(service: "com.crave.app", account: "authToken"),
               !tokenData.isEmpty {
                coordinator.setLoggedIn()
            } else {
                coordinator.setLoggedOut()
            }
        }
    }
}
