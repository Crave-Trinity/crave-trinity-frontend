//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │ CravePhone/Data/Repositories/AiChatRepositoryImpl.swift
//  └───────────────────────────────────────────────────────────────────────┘
//  Description:
//     Concrete implementation of `AiChatRepositoryProtocol`.
//     It delegates the actual network call to `APIClient`.
//
//  S.O.L.I.D. in action:
//   - (S)ingle Responsibility: This repository only deals with how to fetch AI chat data
//     and transform it into domain-friendly types (String responses).
//   - (D)ependency Inversion: We rely on an abstract `APIClient` instead of
//     any ephemeral, direct, or ephemeral usage of secrets.
//
import Foundation

public final class AiChatRepositoryImpl: AiChatRepositoryProtocol {
    
    private let apiClient: APIClient
    private let baseURL: URL // optional if your architecture calls for it
    
    public init(apiClient: APIClient, baseURL: URL) {
        self.apiClient = apiClient
        self.baseURL   = baseURL
    }
    
    /// Gets an AI-generated response from the OpenAI service for a user query.
    /// - Parameter userQuery: The question or content from the user.
    /// - Returns: The raw text content from the AI.
    public func getAiResponse(for userQuery: String) async throws -> String {
        // 1) Fetch data from the API client
        let data = try await apiClient.fetchOpenAIResponse(prompt: userQuery)
        
        // 2) Parse JSON
        do {
            if let root = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = root["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let responseContent = message["content"] as? String {
                return responseContent.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                throw ChatDataError.invalidDataFormat
            }
        } catch {
            throw ChatDataError.parsingFailed(error.localizedDescription)
        }
    }
}

// MARK: - AiChatRepository Errors
public enum ChatDataError: Error, LocalizedError {
    case invalidDataFormat
    case parsingFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidDataFormat:
            return "The response from OpenAI was not in the expected format."
        case .parsingFailed(let details):
            return "Failed to parse AI response. Details: \(details)"
        }
    }
}

