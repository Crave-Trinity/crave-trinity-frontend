//
//  CraveBackendAPIClient.swift
//  CravePhone/Data/DataSources/Remote
//
//  PURPOSE:
//   - Makes direct HTTP requests to your Railway backend.
//   - Exposes methods for generating a test JWT and sending AI chat messages.
//
//  NOTE: This is where the 401, 500, etc. are interpreted as APIError.
//

import Foundation

// Define a custom error enum for API-related errors
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
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .networkError(let urlError):
            return "Network error: \(urlError.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized (401)."
        case .serverError(let code):
            return "Server error (code \(code))."
        case .other(let message):
            return message
        }
    }
    
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case (.invalidResponse, .invalidResponse): return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.code == rhsError.code
        case (.decodingError, .decodingError): return true
        case (.unauthorized, .unauthorized): return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.other(let lhsMsg), .other(let rhsMsg)):
            return lhsMsg == rhsMsg
        default:
            return false
        }
    }
}

// Decodable structs that match the backend's JSON response
public struct TokenResponse: Decodable {
    public let token: String
}

public struct ChatResponse: Decodable {
    public let response: String
}

public class CraveBackendAPIClient {
    private let baseURLString = "https://crave-mvp-backend-production.up.railway.app" // or your actual base
    
    // 1) Generate a test token
    public func generateTestToken() async throws -> String {
        guard let url = URL(string: "\(baseURLString)/api/admin/generate-test-token") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // optional body if needed, but in this case we only call it
        request.timeoutInterval = 10.0
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            print("HTTP Status Code (generateTestToken): \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            } else if httpResponse.statusCode >= 500 {
                throw APIError.serverError(httpResponse.statusCode)
            } else if !(200...299).contains(httpResponse.statusCode) {
                throw APIError.invalidResponse
            }
            
            do {
                let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
                return decoded.token
            } catch {
                print("JSON Decoding Error (generateTestToken): \(error)")
                throw APIError.decodingError(error)
            }
            
        } catch {
            // Check if it's a URLError
            if let urlError = error as? URLError {
                throw APIError.networkError(urlError)
            } else {
                throw APIError.other("Networking or other Error: \(error.localizedDescription)")
            }
        }
    }
    
    // 2) Send chat message using the given auth token
    public func sendMessage(userQuery: String, authToken: String) async throws -> String {
        guard let url = URL(string: "\(baseURLString)/api/v1/chat") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // IMPORTANT: attach the JWT
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["userQuery": userQuery]  // Must match ChatRequestDTO in Python
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 60.0
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            print("HTTP Status Code (sendMessage): \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            } else if httpResponse.statusCode >= 500 {
                throw APIError.serverError(httpResponse.statusCode)
            } else if !(200...299).contains(httpResponse.statusCode) {
                throw APIError.invalidResponse
            }
            
            do {
                let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
                return decoded.response
            } catch {
                print("JSON Decoding Error (sendMessage): \(error)")
                throw APIError.decodingError(error)
            }
            
        } catch {
            if let urlError = error as? URLError {
                throw APIError.networkError(urlError)
            } else {
                throw APIError.other("Networking or other Error: \(error.localizedDescription)")
            }
        }
    }
}
