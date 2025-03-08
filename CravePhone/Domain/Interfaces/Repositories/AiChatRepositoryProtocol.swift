// DIRECTORY/FILENAME: CravePhone/Domain/Interfaces/Repositories/AiChatRepositoryProtocol.swift
// PASTE & RUN (Removed getTestToken())

import Foundation

public protocol AiChatRepositoryProtocol {
    func getAiResponse(for userQuery: String, authToken: String) async throws -> String
}

// MARK: - Chat Data Errors
public enum ChatDataError: Error, LocalizedError {
    case noResponse
    case invalidDataFormat
    case parsingFailed(String)

    public var errorDescription: String? {
        switch self {
        case .noResponse:
            return "The backend returned an empty message."
        case .invalidDataFormat:
            return "The chat response wasn't in the expected format."
        case .parsingFailed(let details):
            return "Failed to parse chat data: \(details)"
        }
    }
}
