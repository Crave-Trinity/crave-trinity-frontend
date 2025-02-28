//
//  AiChatRepositoryProtocol.swift
//  CravePhone
//
//  Description:
//    Domain-level interface describing how we get AI chat responses from the backend.
//
import Foundation

public protocol AiChatRepositoryProtocol {
    /// Submits a user query (like "Why do I crave sugar at night?")
    /// and returns the AI or RAG-based response text.
    func getAiResponse(for userQuery: String) async throws -> String
}
