//
//  LoginViewModel.swift
//  CravePhone/Presentation/ViewModels
//
//  PURPOSE: Orchestrates login logic for both email/password and Google OAuth.
//  Uses Google's iOS SDK to retrieve `idToken`, then calls the backend via AuthRepository.
//
import SwiftUI
import GoogleSignIn

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let authRepository: AuthRepository
    
    // MARK: - Init
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // MARK: - Email/Password Login
    func loginWithEmailPassword() {
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                let response = try await authRepository.login(email: email, password: password)
                // Save token in Keychain
                KeychainHelper.save(
                    data: Data(response.accessToken.utf8),
                    service: "com.crave.app",
                    account: "authToken"
                )
                // Optionally fetch user here:
                // let user = try await authRepository.fetchCurrentUser(accessToken: response.accessToken)
                // handle user...
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Google OAuth Login
    /// 1) Launch Google sign-in flow
    func loginWithGoogle(presentingWindow: UIWindowScene?) {
        guard let presentingWindow = presentingWindow else {
            self.errorMessage = "No UIWindowScene found."
            return
        }
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingWindow
        ) { [weak self] signInResult, error in
            guard let self = self else { return }
            Task {
                defer { self.isLoading = false }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let result = signInResult else {
                    self.errorMessage = "Google sign in result is nil."
                    return
                }
                
                // We only need the ID token for the backend
                guard let idToken = result.user.idToken?.tokenString else {
                    self.errorMessage = "Failed to get Google ID Token."
                    return
                }
                
                do {
                    let response = try await self.authRepository.googleLogin(idToken: idToken)
                    // Save token in Keychain
                    KeychainHelper.save(
                        data: Data(response.accessToken.utf8),
                        service: "com.crave.app",
                        account: "authToken"
                    )
                    // If needed, fetch user profile:
                    // let user = try await self.authRepository.fetchCurrentUser(accessToken: response.accessToken)
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
