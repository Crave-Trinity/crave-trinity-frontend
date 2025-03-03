//
//  AiChatRepositoryImpl.swift
//  CravePhone/Data/Repositories
//
//  PURPOSE:
//  - Single Responsibility: fetch & return chat from our *Railway* backend.
//  - Uncle Bob & Clean Arch: data layer code, hides backend details from the Domain.
//
//  LAST UPDATED: <today's date>
//

import Foundation

public final class AiChatRepositoryImpl: AiChatRepositoryProtocol {

    // Replace old APIClient with our new CraveBackendAPIClient
    private let backendClient: CraveBackendAPIClient

    public init(backendClient: CraveBackendAPIClient) {
        self.backendClient = backendClient
    }

    public func getAiResponse(for userQuery: String) async throws -> String {
        // 1) Call the backend
        let responseText = try await backendClient.fetchChatResponse(userQuery: userQuery)

        // 2) Clean or filter the text
        let cleaned = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else {
            // If it's empty, throw an error
            throw ChatDataError.noResponse
        }

        // 3) Return the cleaned text
        return cleaned
    }
}

// MARK: - ChatDataError
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
