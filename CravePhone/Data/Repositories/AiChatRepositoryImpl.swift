// File: AiChatRepositoryImpl.swift
// PURPOSE: Implements the network call to the backend’s /ai/chat endpoint.
import Foundation

public final class AiChatRepositoryImpl: AiChatRepositoryProtocol {
    private let backendClient: CraveBackendAPIClient
    public init(backendClient: CraveBackendAPIClient) {
        self.backendClient = backendClient
    }
    
    public func getAiResponse(for userQuery: String, authToken: String) async throws -> String {
        return try await backendClient.sendMessage(userQuery: userQuery, authToken: authToken)
    }
}
