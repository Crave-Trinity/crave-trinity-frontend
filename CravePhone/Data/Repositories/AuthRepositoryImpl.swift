//
// AuthRepositoryImpl.swift
// PURPOSE: Handles authentication (email/password & Google OAuth initiation).
// AUTHOR: Uncle Bob/Steve Jobs Style
// -----------------------------------------------------------------------------

import Foundation
import UIKit

final class AuthRepositoryImpl: AuthRepository {
    private let backendClient: CraveBackendAPIClient
    
    // MARK: - Definitive Designated Initializer
    init(backendClient: CraveBackendAPIClient) {
        self.backendClient = backendClient
    }

    // MARK: - Email/Password Login (correct POST)
    func login(email: String, password: String) async throws -> AuthResponseDTO {
        guard let url = URL(string: "\(backendClient.baseURL)/api/v1/auth/login") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = AuthRequestDTO(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return try JSONDecoder().decode(AuthResponseDTO.self, from: data)
        case 401:
            throw APIError.unauthorized
        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.invalidResponse
        }
    }

    // MARK: - Definitive Google OAuth initiation (GET, no body, opens browser)
    func googleLogin() async throws {
        guard let url = URL(string: "\(backendClient.baseURL)/auth/oauth/google/login") else {
            throw APIError.invalidURL
        }

        await MainActor.run {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Fetch Current User (correct GET)
    func fetchCurrentUser(accessToken: String) async throws -> UserEntity {
        guard let url = URL(string: "\(backendClient.baseURL)/api/v1/auth/me") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return try JSONDecoder().decode(UserEntity.self, from: data)
        case 401:
            throw APIError.unauthorized
        default:
            throw APIError.invalidResponse
        }
    }
}
