//CravePhone/Domain/UseCases/AiChatUseCase.swift

import Foundation

public protocol AiChatUseCaseProtocol {
    func sendMessage(_ userQuery: String) async throws -> String
}

/// Error type for the AI Chat Use Case
public enum AIChatError: Error {
    case noAuthToken
    case custom(String)
}

/// Concrete implementation bridging the presentation layer and the repository.
/// Follows the "Command" idea from GoF: we have a single operation (sendMessage).
public final class AiChatUseCase: AiChatUseCaseProtocol {
    private let repository: AiChatRepositoryProtocol
    
    public init(repository: AiChatRepositoryProtocol) {
        self.repository = repository
    }
    
    public func sendMessage(_ userQuery: String) async throws -> String {
        // Example: retrieving token from Keychain.
        // Adjust if you prefer an AuthRepository or a different mechanism.
        guard
            let tokenData = KeychainHelper.load(service: "com.crave.app", account: "authToken"),
            let token = String(data: tokenData, encoding: .utf8),
            !token.isEmpty
        else {
            throw AIChatError.noAuthToken
        }
        
        // Now pass the real token to the repository
        let aiResponse = try await repository.getAiResponse(for: userQuery, authToken: token)
        return aiResponse
    }
}
