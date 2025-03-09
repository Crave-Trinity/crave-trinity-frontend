// File: AiChatUseCase.swift
// PURPOSE: Retrieves the JWT from Keychain and uses it to query the AI chat backend.
import Foundation

public protocol AiChatUseCaseProtocol {
    func sendMessage(_ userQuery: String) async throws -> String
}

public enum AIChatError: Error {
    case noAuthToken
    case custom(String)
}

public final class AiChatUseCase: AiChatUseCaseProtocol {
    private let repository: AiChatRepositoryProtocol
    private let keychainService = "com.crave.app"
    private let jwtAccount = "authToken"
    
    public init(repository: AiChatRepositoryProtocol) {
        self.repository = repository
    }
    
    public func sendMessage(_ userQuery: String) async throws -> String {
        guard let tokenData = KeychainHelper.load(service: keychainService, account: jwtAccount),
              let tokenString = String(data: tokenData, encoding: .utf8),
              !tokenString.isEmpty else {
            throw AIChatError.noAuthToken
        }
        return try await repository.getAiResponse(for: userQuery, authToken: tokenString)
    }
}
