//CravePhone/Data/DataSources/Remote/CraveBackendAPIClient.swift

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
public struct ChatResponse: Decodable {
    public let message: String
}

// MARK: - CraveBackendAPIClient
public class CraveBackendAPIClient {
    // If you prefer retrieving baseURL from SecretsManager, do so here.
    // Otherwise, keep it hard-coded.
    //public let baseURL: String = (try? SecretsManager.baseURL()) ?? "https://your-default-backend.com"
    public let baseURL: String = "https://crave-mvp-backend-production-a001.up.railway.app"
    private let chatEndpoint = "/ai/chat" // Avoid magic strings
    
    public init() {}
    
    /// Sends a user query to the server's AI chat endpoint.
    /// Expects a JSON response containing { "message": "<AI reply>" }
    public func sendMessage(userQuery: String, authToken: String) async throws -> String {
        guard let url = URL(string: baseURL + chatEndpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let payload = ["userQuery": userQuery]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        do {
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
            case 400, 402..<500:
                throw APIError.other("Client error: \(httpResponse.statusCode)")
            case 500..<600:
                throw APIError.serverError(httpResponse.statusCode)
            default:
                throw APIError.invalidResponse
            }
        } catch let urlError as URLError {
            throw APIError.networkError(urlError)
        } catch {
            throw APIError.other(error.localizedDescription)
        }
    }
}
