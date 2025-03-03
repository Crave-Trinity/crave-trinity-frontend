//
//  CraveBackendAPIClient.swift
//  CravePhone/Data/DataSources/Remote
//
//  PASTE & RUN (No Explanations):
//   - Contains sendMessage(...) and generateTestToken(...)
//   - Fixes "no member" errors in AiChatRepositoryImpl
//

import Foundation

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

// Matches the backend's JSON: { "message": "..." }
public struct ChatResponse: Decodable {
    public let message: String
}

public class CraveBackendAPIClient {
    private let baseURLString = "https://crave-mvp-backend-production.up.railway.app"
    
    public init() {}
    
    public func sendMessage(userQuery: String, authToken: String) async throws -> String {
        guard let url = URL(string: "\(baseURLString)/api/v1/chat") else {
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
    
    public func generateTestToken() async throws -> String {
        guard let url = URL(string: "\(baseURLString)/api/admin/generate-test-token") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
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
