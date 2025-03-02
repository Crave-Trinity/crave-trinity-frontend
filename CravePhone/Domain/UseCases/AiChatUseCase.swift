//=================================================================
// 4) AiChatUseCase.swift (Continued)
//   CravePhone/Domain/UseCases/AiChatUseCase.swift
//=================================================================

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
        // Add any pre or post processing logic here if necessary
        return try await repository.getAiResponse(for: userQuery)
    }
}

public enum ChatError: LocalizedError {
    case emptyQuery

    public var errorDescription: String? {
        switch self {
        case .emptyQuery:
            return "Please enter some text before sending a query to AI."
        }
    }
}
