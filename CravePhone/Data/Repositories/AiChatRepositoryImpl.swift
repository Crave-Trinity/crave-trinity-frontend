//
//  AiChatRepositoryImpl.swift
//  CravePhone/Data/Repositories
//
//  GOF/SOLID EXPLANATION:
//    - Single Responsibility: Only fetches & returns AI responses.
//    - Liskov Substitution: Conforms to AiChatRepositoryProtocol so it can be replaced by a mock/test repository.
//    - Error handling ensures minimal leakage of data-layer concerns.
//
import Foundation

public final class AiChatRepositoryImpl: AiChatRepositoryProtocol {
    
    private let apiClient: APIClient
    
    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    /// Invokes the OpenAI Chat Completion API and extracts the first choice.
    public func getAiResponse(for userQuery: String) async throws -> String {
        // Fire the network request
        let response = try await apiClient.fetchOpenAIResponse(prompt: userQuery)
        
        // Attempt to retrieve the first choice
        guard let firstChoice = response.choices.first else {
            throw ChatDataError.noResponse
        }
        
        // Return the trimmed content
        return firstChoice.message.content
            .trimmingCharacters(in: .whitespacesAndNewlines)
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
            return "The AI did not provide any choices."
        case .invalidDataFormat:
            return "The AI response was in an unexpected format."
        case .parsingFailed(let details):
            return "Failed to parse AI response: \(details)"
        }
    }
}
