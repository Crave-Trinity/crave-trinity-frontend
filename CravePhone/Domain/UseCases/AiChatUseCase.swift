// DIRECTORY/FILENAME: CravePhone/Domain/UseCases/AiChatUseCase.swift
// PASTE & RUN (Removed getTestToken(); only real JWT usage remains)

import Foundation

/// High-level business logic for AI chat.
/// Follows the Command pattern from the GoF:
/// "sendMessage" is the single operation we can invoke.
public protocol AiChatUseCaseProtocol {
    func sendMessage(_ userQuery: String) async throws -> String
}

/// Concrete implementation bridging the presentation layer and the repository.
public final class AiChatUseCase: AiChatUseCaseProtocol {
    private let repository: AiChatRepositoryProtocol
    
    public init(repository: AiChatRepositoryProtocol) {
        self.repository = repository
    }
    
    public func sendMessage(_ userQuery: String) async throws -> String {
        // In a real app, you'd fetch the auth token from Keychain or an AuthRepository:
        let token = "DummyAuthTokenForPreview"
        return try await repository.getAiResponse(for: userQuery, authToken: token)
    }
}
