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
    /// Launches the Google Sign-In flow from a UIWindowScene
    func loginWithGoogle(presentingWindow: UIWindowScene?) {
        // Check if we have a valid window scene
        guard let windowScene = presentingWindow else {
            self.errorMessage = "No UIWindowScene found."
            return
        }
        
        // Get the root view controller from the first window in the scene
        // This is needed because Google Sign-In requires a UIViewController to present its UI
        guard let rootViewController = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "Could not find root view controller."
            return
        }
        
        // Set loading state
        isLoading = true
        
        // Launch Google Sign-In flow with the root view controller
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        ) { [weak self] signInResult, error in
            // Capture self weakly to avoid retain cycles
            guard let self = self else { return }
            
            Task {
                // Ensure loading state is set to false when task completes
                defer { self.isLoading = false }
                
                // Handle any errors from the sign-in process
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                // Verify we have a valid sign-in result
                guard let result = signInResult else {
                    self.errorMessage = "Google sign in result is nil."
                    return
                }
                
                // Extract the ID token which will be sent to our backend
                guard let idToken = result.user.idToken?.tokenString else {
                    self.errorMessage = "Failed to get Google ID Token."
                    return
                }
                
                do {
                    // Send the Google ID token to our backend for verification
                    let response = try await self.authRepository.googleLogin(idToken: idToken)
                    
                    // Save the received access token in the keychain
                    KeychainHelper.save(
                        data: Data(response.accessToken.utf8),
                        service: "com.crave.app",
                        account: "authToken"
                    )
                    
                    // If needed, fetch user profile:
                    // let user = try await self.authRepository.fetchCurrentUser(accessToken: response.accessToken)
                } catch {
                    // Handle any errors from our backend
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
