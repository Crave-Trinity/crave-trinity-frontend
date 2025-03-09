// File: LoginViewModel.swift
// PURPOSE: Manages login interactions (Email/Password and Google Sign-In).
import SwiftUI
import GoogleSignIn

@MainActor
public class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let authRepository: AuthRepository
    private let coordinator: AppCoordinator
    
    init(authRepository: AuthRepository, coordinator: AppCoordinator) {
        self.authRepository = authRepository
        self.coordinator = coordinator
    }
    
    public func loginWithEmailPassword() {
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                let _ = try await authRepository.login(email: email, password: password)
                coordinator.setLoggedIn()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    public func loginWithGoogle(presentingWindow: UIWindowScene?) {
        guard let scene = presentingWindow,
              let rootVC = scene.windows.first?.rootViewController else {
            self.errorMessage = "Unable to get window scene."
            return
        }
        isLoading = true
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
            guard let self = self else { return }
            defer { self.isLoading = false }
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            guard let idToken = result?.user.idToken?.tokenString else {
                self.errorMessage = "No ID token received."
                return
            }
            Task {
                do {
                    let _ = try await self.authRepository.verifyGoogleIdToken(idToken: idToken)
                    self.coordinator.setLoggedIn()
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    public func logout() {
        authRepository.logout()
        coordinator.setLoggedOut()
    }
}
