//  AiChatRepositoryProtocol.swift
//  CravePhone/Domain/Interfaces/Repositories
//

import Foundation

public protocol AiChatRepositoryProtocol {
    /// Submits a user query and returns the AI response as text.
    func getAiResponse(for userQuery: String, authToken: String) async throws -> String // Add authToken
    func getTestToken() async throws -> String // Add getTestToken
}
