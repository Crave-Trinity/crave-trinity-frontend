// File: CravePhone/Data/DataSources/Remote/CraveBackendAPIClient.swift
// PURPOSE: Provides a centralized network client for backend calls, including OAuth-based requests.
//          This client exposes the base URL and wraps common network logic for sending chat messages
//          and generating test tokens. It also defines APIError and ChatResponse for consistent error handling.
// AUTHOR: Uncle Bob / Steve Jobs Style
// -----------------------------------------------------------------------------

import Foundation

// MARK: - API Error Definitions
public enum APIError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case networkError(URLError)
    case decodingError(Error)
    case unauthorized
    case serverError(Int)
    case other(String)
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL:           return "Invalid URL."
        case .invalidResponse:      return "Invalid server response."
        case .networkError(let e):  return "Network error: \(e.localizedDescription)"
        case .decodingError(let e): return "Decoding error: \(e.localizedDescription)"
        case .unauthorized:         return "Unauthorized (401)."
        case .serverError(let c):   return "Server error (code \(c))."
        case .other(let msg):       return msg
        }
    }
    
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.unauthorized, .unauthorized):
            return true
        case (.networkError(let l), .networkError(let r)):
            return l.code == r.code
        case (.serverError(let l), .serverError(let r)):
            return l == r
        case (.decodingError, .decodingError):
            return true
        case (.other(let l), .other(let r)):
            return l == r
        default:
            return false
        }
    }
}

// MARK: - Chat Response Model
// Represents the backend's expected response for chat requests.
public struct ChatResponse: Decodable {
    public let message: String
}

// MARK: - CraveBackendAPIClient
// This class encapsulates all network operations related to backend communication.
// The public baseURL allows other classes (e.g., AuthRepositoryImpl) to construct endpoints.
public class CraveBackendAPIClient {
    // Make the base URL public so that dependent classes can access it.
    public let baseURL: String = "https://crave-mvp-backend-production-a001.up.railway.app"
    
    // Designated initializer.
    public init() {}
    
    // MARK: - sendMessage(userQuery:authToken:)
    // Sends a chat message to the backend.
    // - Parameters:
    //   - userQuery: The user's query/message.
    //   - authToken: A valid OAuth access token.
    // - Throws: APIError if the network call or decoding fails.
    // - Returns: The response message from the backend.
    public func sendMessage(userQuery: String, authToken: String) async throws -> String {
        print("DEBUG: sendMessage(...) with token:", authToken)
        
        guard let url = URL(string: "\(baseURL)/api/v1/chat") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let payload = ["userQuery": userQuery]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        print("DEBUG: Chat request status code:", httpResponse.statusCode)
        let rawBody = String(data: data, encoding: .utf8) ?? "nil"
        print("DEBUG: Chat raw response body:", rawBody)
        
        switch httpResponse.statusCode {
        case 200..<300:
            do {
                let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
                return decoded.message
            } catch {
                throw APIError.decodingError(error)
            }
        case 401:
            throw APIError.unauthorized
        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.invalidResponse
        }
    }
    
    // MARK: - generateTestToken()
    // Generates a test token from the backend, useful for development or debugging OAuth flows.
    // - Throws: APIError if the network call or decoding fails.
    // - Returns: A test token as a String.
    public func generateTestToken() async throws -> String {
        guard let url = URL(string: "\(baseURL)/api/admin/generate-test-token") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        print("DEBUG: Test token request status code:", httpResponse.statusCode)
        let rawBody = String(data: data, encoding: .utf8) ?? "nil"
        print("DEBUG: Test token raw response body:", rawBody)
        
        switch httpResponse.statusCode {
        case 200..<300:
            let dict = try JSONDecoder().decode([String: String].self, from: data)
            return dict["token"] ?? ""
        case 401:
            throw APIError.unauthorized
        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.invalidResponse
        }
    }
}
