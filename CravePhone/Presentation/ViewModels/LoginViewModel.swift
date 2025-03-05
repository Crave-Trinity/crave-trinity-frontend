//=================================================================
// File: CravePhone/Presentation/ViewModels/LoginViewModel.swift
// PURPOSE:
//  - Orchestrates login logic for email/password and Google OAuth.
//  - Adjusted initializer access level to match internal types.
// UNCLE BOB + STEVE JOBS STYLE – COMPLETE PASTE & RUN
//=================================================================

import SwiftUI
import GoogleSignIn

public class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let authRepository: AuthRepository
    
    // Removed 'public' from the initializer to avoid exposing internal types.
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
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
                guard let idToken = result.user.idToken?.tokenString else {
                    self.errorMessage = "Failed to get Google ID Token."
                    return
                }
                do {
                    let response = try await self.authRepository.googleLogin(idToken: idToken)
                    KeychainHelper.save(
                        data: Data(response.accessToken.utf8),
                        service: "com.crave.app",
                        account: "authToken"
                    )
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
