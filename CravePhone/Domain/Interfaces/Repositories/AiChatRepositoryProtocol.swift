// DIRECTORY/FILENAME: CravePhone/Domain/Interfaces/Repositories/AiChatRepositoryProtocol.swift
// PASTE & RUN (Removed getTestToken())

import Foundation

/// Conforms to DIP (Dependency Inversion Principle) by abstracting the data layer for AI Chat.
public protocol AiChatRepositoryProtocol {
    /// Returns a string response from AI given the user's query and a valid auth token.
    func getAiResponse(for userQuery: String, authToken: String) async throws -> String
}

/// Example error type for AI Chat.
/// If you already have ChatDataError defined somewhere else, remove or rename one.
public enum ChatDataError: Error {
    case invalidToken
    case serverError(String)
    case unknown
}
