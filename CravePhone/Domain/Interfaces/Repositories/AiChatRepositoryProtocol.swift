//=================================================================
// 4) AiChatRepositoryProtocol.swift
//    CravePhone/Domain/Interfaces/Repositories/AiChatRepositoryProtocol.swift
//=================================================================

import Foundation

public protocol AiChatRepositoryProtocol {
    /// Submits a user query and returns the AI response as text.
    func getAiResponse(for userQuery: String) async throws -> String
}
