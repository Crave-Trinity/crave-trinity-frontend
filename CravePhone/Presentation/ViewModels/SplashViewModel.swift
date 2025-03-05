//=================================================================
// File: CravePhone/Presentation/ViewModels/SplashViewModel.swift
// PURPOSE:
//  - Checks for existing token in Keychain; directs user to Login or Main.
//
// UNCLE BOB + STEVE JOBS STYLE – COMPLETE PASTE & RUN
//=================================================================

import SwiftUI

@MainActor
class SplashViewModel: ObservableObject {
    private let coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    func onAppear() {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // brief visual splash delay
            
            let tokenData = KeychainHelper.load(service: "com.crave.app", account: "authToken")
            if let tokenData = tokenData, !tokenData.isEmpty {
                coordinator.setLoggedIn()
            } else {
                coordinator.setLoggedOut()
            }
        }
    }
}
