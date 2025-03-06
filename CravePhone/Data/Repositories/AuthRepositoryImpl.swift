// File: CravePhone/Data/Repositories/AuthRepositoryImpl.swift
// PURPOSE: Concrete implementation of AuthRepository for direct calls to the backend.
//          This repository handles authentication for both email/password login and Google OAuth,
//          as well as fetching the current user's details.
//          It follows Clean Architecture principles by injecting the network client dependency.
// AUTHOR: Uncle Bob / Steve Jobs Style
// -----------------------------------------------------------------------------

import Foundation

final class AuthRepositoryImpl: AuthRepository {
    // The network client injected via the initializer.
    private let backendClient: CraveBackendAPIClient
    
    // MARK: - Designated Initializer
    // Dependency injection ensures that this repository remains decoupled from the network details.
    init(backendClient: CraveBackendAPIClient) {
        self.backendClient = backendClient
    }
    
    // MARK: - Email/Password Login
    // Attempts to log in using email and password credentials.
    // - Parameters:
    //   - email: The user's email.
    //   - password: The user's password.
    // - Throws: APIError if the network call or decoding fails.
    // - Returns: An AuthResponseDTO containing the authentication details.
    func login(email: String, password: String) async throws -> AuthResponseDTO {
        // Construct the URL using the backend client's public baseURL.
        guard let url = URL(string: "\(backendClient.baseURL)/api/v1/auth/login") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the login request body.
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
    
    // MARK: - Google OAuth Login
    // Logs in using a Google OAuth idToken.
    // - Parameter idToken: The Google OAuth token.
    // - Throws: APIError if the network call or decoding fails.
    // - Returns: A GoogleOAuthResponseDTO containing the authentication details.
    func googleLogin(idToken: String) async throws -> GoogleOAuthResponseDTO {
        guard let url = URL(string: "\(backendClient.baseURL)/auth/oauth/google/login") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET" // ← This should be GET for OAuth initiation
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Typically, you don't send a request body when using GET for OAuth initiation.
        // Remove the body encoding entirely:
        // let body = GoogleOAuthRequestDTO(idToken: idToken)
        // request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200..<300:
            return try JSONDecoder().decode(GoogleOAuthResponseDTO.self, from: data)
        case 401:
            throw APIError.unauthorized
        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.invalidResponse
        }
    }
    // MARK: - Fetch Current User
    // Retrieves the current authenticated user's details using a valid access token.
    // - Parameter accessToken: A valid OAuth access token.
    // - Throws: APIError if the network call or decoding fails.
    // - Returns: A UserEntity representing the current user.
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
