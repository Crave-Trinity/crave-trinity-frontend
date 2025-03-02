//
//  AiChatUseCase.swift
//  CravePhone/Domain/UseCases
//
//  GOF/SOLID EXPLANATION:
//   - Command pattern: 'execute' encapsulates the operation of requesting an AI response.
//   - Single Responsibility: Only orchestrates AI request via the repository.
//   - Dependency Inversion: Depends on AiChatRepositoryProtocol, not a concrete class.
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
    
    /// Validates user input, then calls the repository for the AI response.
    public func execute(userQuery: String) async throws -> String {
        let trimmedQuery = userQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            throw ChatError.emptyQuery
        }
        
        // Potentially add advanced pre-processing of the query here
        
        let response = try await repository.getAiResponse(for: trimmedQuery)
        
        // Potentially add advanced post-processing (e.g., sentiment analysis) here
        return response
    }
}

// MARK: - ChatError
public enum ChatError: LocalizedError {
    case emptyQuery
    
    public var errorDescription: String? {
        switch self {
        case .emptyQuery:
            return "Please enter some text before sending a query to the AI."
        }
    }
}
