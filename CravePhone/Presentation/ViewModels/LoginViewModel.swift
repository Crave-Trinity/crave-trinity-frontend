//
//  LoginViewModel.swift
//  CravePhone/Presentation/ViewModels
//
//  PURPOSE:
//    - Orchestrates login logic explicitly for email/password and Google OAuth.
//    - Visibility matches DependencyContainer explicitly.
//  UNCLE BOB + STEVE JOBS STYLE – COMPLETE PASTE & RUN
//=================================================================

import SwiftUI
import GoogleSignIn

public class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let authRepository: AuthRepository
    
    // MARK: - Definitively Corrected Internal Initializer
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // MARK: - Email/Password Login
    public func loginWithEmailPassword() {
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                let response = try await authRepository.login(email: email, password: password)
                KeychainHelper.save(
                    data: Data(response.accessToken.utf8),
                    service: "com.crave.app",
                    account: "authToken"
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Google OAuth Login (Corrected explicitly)
    public func loginWithGoogle(presentingWindow: UIWindowScene?) {
        guard let windowScene = presentingWindow else {
            self.errorMessage = "No UIWindowScene found."
            return
        }
        
        guard let rootViewController = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "Could not find root view controller."
            return
        }
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        ) { [weak self] signInResult, error in
            guard let self = self else { return }
            
            defer { self.isLoading = false }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard signInResult != nil else {
                self.errorMessage = "Google sign in result is nil."
                return
            }
            
            Task {
                do {
                    try await self.authRepository.googleLogin()
                    // OAuth continues via browser. Callback handles final steps.
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
