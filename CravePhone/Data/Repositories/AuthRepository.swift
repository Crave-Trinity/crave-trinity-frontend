// File: AuthRepository.swift
// PURPOSE: Protocol to abstract authentication operations.
// DESIGN: Defines all necessary methods, including logout(), so that any implementation (like AuthRepositoryImpl) conforms completely.
import Foundation

protocol AuthRepository {
    // Email/Password login
    func login(email: String, password: String) async throws -> AuthResponseDTO
    // Native Google Sign-In: send the ID token obtained from Google to backend
    func verifyGoogleIdToken(idToken: String) async throws -> AuthResponseDTO
    // Fetch the currently logged-in user (using your internal JWT)
    func fetchCurrentUser(accessToken: String) async throws -> UserEntity
    // Logout to clear tokens from storage
    func logout()
}
