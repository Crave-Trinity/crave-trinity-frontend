//=================================================================
// 2) AiChatRepositoryImpl.swift
//   CravePhone/Data/Repositories/AiChatRepositoryImpl.swift
//=================================================================

import Foundation

public final class AiChatRepositoryImpl: AiChatRepositoryProtocol {

    private let apiClient: APIClient
    // Remove baseURL, as it's handled within APIClient

    public init(apiClient: APIClient) { // Simplified initializer
        self.apiClient = apiClient
    }

    /// Gets an AI-generated response from the OpenAI service for a user query.
    public func getAiResponse(for userQuery: String) async throws -> String {
        // Directly use the decoded response from the API client
        let response = try await apiClient.fetchOpenAIResponse(prompt: userQuery)

        // Access the content of the first choice's message
        guard let firstChoice = response.choices.first else {
            throw ChatDataError.noResponse // Handle case where no choices are returned
        }
        return firstChoice.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - AiChatRepository Errors
public enum ChatDataError: Error, LocalizedError {
    case noResponse // Add an error for when OpenAI returns no response
    case invalidDataFormat
    case parsingFailed(String)

    public var errorDescription: String? {
        switch self {
        case .noResponse:
            return "The AI did not provide a response."
        case .invalidDataFormat:
            return "The response from OpenAI was not in the expected format."
        case .parsingFailed(let details):
            return "Failed to parse AI response. Details: \(details)"
        }
    }
}
