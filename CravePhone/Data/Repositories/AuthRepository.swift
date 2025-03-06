//
// AuthRepository.swift
// PURPOSE: Protocol for authentication repository to abstract auth implementation details.
//
import Foundation

protocol AuthRepository {
    func login(email: String, password: String) async throws -> AuthResponseDTO
    func googleLogin() async throws   // Definitively NO parameter here now (OAuth initiation is GET)
    func fetchCurrentUser(accessToken: String) async throws -> UserEntity
}
