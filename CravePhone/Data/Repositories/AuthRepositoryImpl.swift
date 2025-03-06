// File: AuthRepositoryImpl.swift
// PURPOSE: Implements authentication logic (email/password and native Google sign‑in)
// AUTHOR: Uncle Bob / Steve Jobs Style

import Foundation
import SwiftUI

final class AuthRepositoryImpl: AuthRepository {
    private let backendClient: CraveBackendAPIClient
    
    // MARK: - Designated Initializer
    init(backendClient: CraveBackendAPIClient) {
        self.backendClient = backendClient
    }
    
    // MARK: - Email/Password Login
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
    
    // MARK: - Native Google Sign-In Verification
    func verifyGoogleIdToken(idToken: String) async throws -> AuthResponseDTO {
        guard let url = URL(string: "\(backendClient.baseURL)/api/v1/auth/verify-google-id-token") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["id_token": idToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        print("HTTP Status Code: \(httpResponse.statusCode)")
        if let responseBody = String(data: data, encoding: .utf8) {
            print("Response Body: \(responseBody)")
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
    
    // MARK: - Fetch Current User
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
