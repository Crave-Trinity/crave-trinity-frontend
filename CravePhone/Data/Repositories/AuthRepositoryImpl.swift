//
//  AuthRepositoryImpl.swift
//  CravePhone/Data/Repositories
//
//  PURPOSE: Concrete implementation of AuthRepository for direct calls to the backend.
//  Assumes your backend has routes at: /api/v1/auth/login and /api/v1/auth/google-oauth
//  (Adjust as needed.)
//
import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let baseURLString = "https://crave-mvp-backend-production-a001.up.railway.app"
    
    // MARK: - Normal Email/Password Login
    func login(email: String, password: String) async throws -> AuthResponseDTO {
        guard let url = URL(string: "\(baseURLString)/api/v1/auth/login") else {
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
    
    // MARK: - Google OAuth Login
    func googleLogin(idToken: String) async throws -> GoogleOAuthResponseDTO {
        // Adjust the route if your backend is different
        guard let url = URL(string: "\(baseURLString)/api/v1/auth/google-oauth") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = GoogleOAuthRequestDTO(idToken: idToken)
        request.httpBody = try JSONEncoder().encode(body)
        
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
    func fetchCurrentUser(accessToken: String) async throws -> UserEntity {
        guard let url = URL(string: "\(baseURLString)/api/v1/auth/me") else {
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
