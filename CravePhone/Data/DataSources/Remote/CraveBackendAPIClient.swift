//=================================================================
// 1) CraveBackendAPIClient.swift
//    CravePhone/Data/DataSources/Remote/CraveBackendAPIClient.swift
//
//  PURPOSE:
//  - Single Responsibility: Communicates ONLY with our Railway backend.
//  - Clean Architecture & SOLID: Minimal code, easy to read.
//
//  NOTE: Points to https://crave-mvp-backend-production-a001.up.railway.app
//  Calls POST /api/v1/chat
//
//  LAST UPDATED: <today's date>
//=================================================================

import Foundation

// MARK: - Data Transfer Objects (DTOs)
public struct ChatRequestDTO: Encodable {
    public let userQuery: String
}
public struct ChatResponseDTO: Decodable {
    public let message: String
}

// MARK: - CraveBackendAPIClient
public final class CraveBackendAPIClient {
    private let baseURL = URL(string: "https://crave-mvp-backend-production-a001.up.railway.app")!
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetchChatResponse(
        userQuery: String
    ) async throws -> String {
        let endpoint = baseURL.appendingPathComponent("api/v1/chat")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ChatRequestDTO(userQuery: userQuery)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw BackendError.httpError(code)
        }
        
        do {
            let decoded = try JSONDecoder().decode(ChatResponseDTO.self, from: data)
            return decoded.message
        } catch {
            throw BackendError.decodingError(error)
        }
    }
}

// MARK: - Backend Errors
public enum BackendError: Error, LocalizedError {
    case httpError(Int)
    case decodingError(Error)
    case invalidURL
    case unknown(String?)
    
    public var errorDescription: String? {
        switch self {
        case .httpError(let code):
            return "Backend returned HTTP error code: \(code)"
        case .decodingError(let err):
            return "Failed to decode backend response: \(err.localizedDescription)"
        case .invalidURL:
            return "Invalid backend URL."
        case .unknown(let details):
            return "An unknown backend error occurred: \(details ?? "No details")"
        }
    }
}
