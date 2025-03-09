//CravePhone/Domain/Interfaces/Repositories/AiChatRepositoryProtocol.swift

import Foundation

/// Conforms to DIP by abstracting the data layer for AI Chat.
public protocol AiChatRepositoryProtocol {
    /// Sends userQuery to the server, returning an AI-generated message string.
    func getAiResponse(for userQuery: String, authToken: String) async throws -> String
}

/// Possible error types for AI Chat (example).
public enum ChatDataError: Error {
    case invalidToken
    case serverError(String)
    case unknown
}
