//=================================================================
// 2) AiChatRepositoryImpl.swift
//    CravePhone/Data/Repositories/AiChatRepositoryImpl.swift
//
//  PURPOSE:
//  - Fetch & return chat from our *Railway* backend using CraveBackendAPIClient.
//  - Clean Architecture: data layer code that hides backend details from Domain.
//
//=================================================================

import Foundation

public final class AiChatRepositoryImpl: AiChatRepositoryProtocol {
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
