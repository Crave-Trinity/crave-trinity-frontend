//
//  CraveBackendAPIClient.swift
//  CravePhone/Data/DataSources/Remote
//
//  PURPOSE:
//  - Single Responsibility: Only talks to our Railway backend.
//  - Uncle Bob + GoF + Clean Architecture: This code is mighty and pure!
//  - “Designed for Steve Jobs”: minimal friction, well-commented.
//
//  LAST UPDATED: <today's date>
//

import Foundation

// MARK: - Data Transfer Objects (DTOs)

/// We will send this to our backend
public struct ChatRequestDTO: Encodable {
    public let userQuery: String
}

/// We get this back from our backend
public struct ChatResponseDTO: Decodable {
    public let message: String
}

// MARK: - CraveBackendAPIClient
public final class CraveBackendAPIClient {
    // 1) Adjust the URL to match your actual Railway link
    private let baseURL = URL(string: "https://crave-mvp-backend-production.up.railway.app")!
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    /// This function calls our backend to get a chat response
    public func fetchChatResponse(
        userQuery: String
    ) async throws -> String {
        // 2) The route is POST /api/v1/chat
        let endpoint = baseURL.appendingPathComponent("api/v1/chat")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        // 3) We want to send JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // 4) Build the request body
        let body = ChatRequestDTO(userQuery: userQuery)
        request.httpBody = try JSONEncoder().encode(body)

        // 5) Fire off the request
        let (data, response) = try await session.data(for: request)

        // 6) Check the status code: must be 200..299
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw BackendError.httpError(statusCode)
        }

        // 7) Decode the JSON into ChatResponseDTO
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
            return "An unknown backend error occurred: \(details ?? "No details available")"
        }
    }
}
