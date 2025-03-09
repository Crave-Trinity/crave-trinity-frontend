//CravePhone/Data/Repositories/AiChatRepositoryImpl.swift

import Foundation

public final class AiChatRepositoryImpl: AiChatRepositoryProtocol {
    private let backendClient: CraveBackendAPIClient
    
    public init(backendClient: CraveBackendAPIClient) {
        self.backendClient = backendClient
    }
    
    public func getAiResponse(for userQuery: String, authToken: String) async throws -> String {
        // The real network call to the backend:
        return try await backendClient.sendMessage(userQuery: userQuery, authToken: authToken)
    }
}
