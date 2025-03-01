//
//  ┌────────────────────────────────────────────────────┐
//  │ CravePhone/Domain/UseCases/AiChatUseCase.swift
//  └────────────────────────────────────────────────────┘
//  Description:
//     A use case that orchestrates retrieving an AI-generated response
//     for a user’s query—business logic for the AI chat feature.
//
//  S.O.L.I.D.:
//   - Stays domain-focused and minimal, delegating data concerns to the repository.
//
import Foundation

public protocol AiChatUseCaseProtocol {
    func execute(userQuery: String) async throws -> String
}

public final class AiChatUseCase: AiChatUseCaseProtocol {
    
    private let repository: AiChatRepositoryProtocol
    
    public init(repository: AiChatRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Executes the AI chat logic for the provided user query.
    /// - Parameter userQuery: The user’s text input.
    /// - Returns: The AI’s textual response.
    /// - Throws: `ChatError.emptyQuery` if `userQuery` is blank,
    ///           plus any underlying repository or networking errors.
    public func execute(userQuery: String) async throws -> String {
        guard !userQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ChatError.emptyQuery
        }
        return try await repository.getAiResponse(for: userQuery)
    }
}

// MARK: - Use Case Errors
public enum ChatError: LocalizedError {
    case emptyQuery
    
    public var errorDescription: String? {
        switch self {
        case .emptyQuery:
            return "Please enter some text before sending a query to AI."
        }
    }
}

