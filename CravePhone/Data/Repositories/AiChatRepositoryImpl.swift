//  AiChatRepositoryImpl.swift
//  CravePhone/Data/Repositories
//

import Foundation

public final class AiChatRepositoryImpl: AiChatRepositoryProtocol {
    private let backendClient: CraveBackendAPIClient // This was the issue:  Should not be public

    public init(backendClient: CraveBackendAPIClient) {
        self.backendClient = backendClient
    }

    public func getAiResponse(for userQuery: String, authToken: String) async throws -> String {
        // 1) Call the backend, passing the token
        let responseText = try await backendClient.sendMessage(userQuery: userQuery, authToken: authToken) // Corrected method name

        // 2) Clean or filter the text
        let cleaned = responseText.trimmingCharacters(in: .whitespacesAndNewlines) // Corrected this line
        guard !cleaned.isEmpty else {
            throw ChatDataError.noResponse
        }

        // 3) Return the cleaned text
        return cleaned
    }

    // Implement getTestToken in the repository
    public func getTestToken() async throws -> String {  // Added public
        try await backendClient.generateTestToken()
    }
}

// MARK: - ChatDataError
public enum ChatDataError: Error, LocalizedError {
    case noResponse
    case invalidDataFormat
    case parsingFailed(String)

    public var errorDescription: String? {
        switch self {
        case .noResponse:
            return "The backend returned an empty message."
        case .invalidDataFormat:
            return "The chat response wasn't in the format we expected."
        case .parsingFailed(let details):
            return "Failed to parse chat data: \(details)"
        }
    }
}
