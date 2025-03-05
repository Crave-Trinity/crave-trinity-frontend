//
//  AuthRepository.swift
//  CravePhone/Data/Repositories
//
//  PURPOSE: Interface for all auth-related operations (login, Google OAuth, etc.)
//
import Foundation

protocol AuthRepository {
    /// Normal email/password login
    func login(email: String, password: String) async throws -> AuthResponseDTO

    /// Google OAuth login
    func googleLogin(idToken: String) async throws -> GoogleOAuthResponseDTO
    
    /// Possibly fetch user profile after login
    func fetchCurrentUser(accessToken: String) async throws -> UserEntity
}
