//
//  AiChatRepositoryImpl.swift
//  CravePhone/Data/Repositories
//
//  PASTE & RUN (No Explanations):
//   - Adjusted trimmingCharacters(...) to use CharacterSet.whitespacesAndNewlines
//   - Uses sendMessage(...) & generateTestToken(...) from CraveBackendAPIClient
//

import Foundation

public final class AiChatRepositoryImpl: AiChatRepositoryProtocol {
    private let backendClient: CraveBackendAPIClient

    public init(backendClient: CraveBackendAPIClient) {
        self.backendClient = backendClient
    }

    public func getAiResponse(for userQuery: String, authToken: String) async throws -> String {
        let raw = try await backendClient.sendMessage(userQuery: userQuery, authToken: authToken)
        let cleaned = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else {
            throw ChatDataError.noResponse
        }
        return cleaned
    }

    public func getTestToken() async throws -> String {
        try await backendClient.generateTestToken()
    }
}

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
