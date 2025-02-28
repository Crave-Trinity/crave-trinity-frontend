//
//  AiChatUseCase.swift
//  CravePhone
//
//  Description:
//    A clean use case that orchestrates retrieving AI chat responses.
//    Aligns with Uncle Bob’s approach: domain logic + error handling here.
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
    
    public func execute(userQuery: String) async throws -> String {
        guard !userQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ChatError.emptyQuery
        }
        return try await repository.getAiResponse(for: userQuery)
    }
}

// Example domain-level error
public enum ChatError: LocalizedError {
    case emptyQuery
    
    public var errorDescription: String? {
        switch self {
        case .emptyQuery:
            return "Please enter something before asking for insights."
        }
    }
}
