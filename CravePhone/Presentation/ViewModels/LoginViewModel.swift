// File: LoginViewModel.swift
// PURPOSE: Orchestrates login logic for both email/password and native Google sign‑in.
// AUTHOR: Uncle Bob / Steve Jobs Style – Clean MVVM Implementation

import SwiftUI
import GoogleSignIn

public class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let authRepository: AuthRepository
    
    // MARK: - Initializer
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
    
    // MARK: - Native Google Sign-In Login
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
        
        // Initiate Google sign-in with the provided root view controller.
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            guard let self = self else { return }
            defer { self.isLoading = false }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            // Extract the ID token from the sign-in result.
            guard let idToken = signInResult?.user.idToken?.tokenString else {
                self.errorMessage = "Google sign in did not return an ID token."
                return
            }
            
            // Call the new backend endpoint to verify the Google ID token.
            Task {
                do {
                    let response = try await self.authRepository.verifyGoogleIdToken(idToken: idToken)
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
