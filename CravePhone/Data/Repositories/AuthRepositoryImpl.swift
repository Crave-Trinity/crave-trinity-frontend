// File: AuthRepositoryImpl.swift
// PURPOSE: Implements authentication logic (Email/Password and Google OAuth),
//          saving tokens to the Keychain and providing a logout method.
// DESIGN: Single Responsibility; uses Dependency Inversion for testability.
import Foundation
import SwiftUI

final class AuthRepositoryImpl: AuthRepository {
    private let backendClient: CraveBackendAPIClient
    private let keychainService = "com.crave.app"
    private let jwtAccount = "authToken"
    private let refreshAccount = "refreshToken"
    
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
            let authResponse = try JSONDecoder().decode(AuthResponseDTO.self, from: data)
            // Save the access token
            KeychainHelper.save(data: Data(authResponse.accessToken.utf8),
                                service: keychainService,
                                account: jwtAccount)
            // Save the refresh token if provided
            if let refresh = authResponse.refreshToken, !refresh.isEmpty {
                KeychainHelper.save(data: Data(refresh.utf8),
                                    service: keychainService,
                                    account: refreshAccount)
            }
            return authResponse
        case 401:
            throw APIError.unauthorized
        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.invalidResponse
        }
    }
    
    // MARK: - Google OAuth Verification
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
        switch httpResponse.statusCode {
        case 200..<300:
            let authResponse = try JSONDecoder().decode(AuthResponseDTO.self, from: data)
            KeychainHelper.save(data: Data(authResponse.accessToken.utf8),
                                service: keychainService,
                                account: jwtAccount)
            if let refresh = authResponse.refreshToken, !refresh.isEmpty {
                KeychainHelper.save(data: Data(refresh.utf8),
                                    service: keychainService,
                                    account: refreshAccount)
            }
            return authResponse
        case 401:
            throw APIError.unauthorized
        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.invalidResponse
        }
    }
    
    // MARK: - Fetch Current User (via token)
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
    
    // MARK: - Logout
    func logout() {
        KeychainHelper.delete(service: keychainService, account: jwtAccount)
        KeychainHelper.delete(service: keychainService, account: refreshAccount)
        print("✅ [AuthRepositoryImpl] User logged out, tokens removed.")
    }
}
