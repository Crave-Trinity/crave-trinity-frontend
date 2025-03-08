// DIRECTORY/FILENAME: CravePhone/Data/Repositories/AiChatRepositoryImpl.swift
// PASTE & RUN (No more getTestToken() references)

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
}
