//
//  AiChatUseCase.swift
//  CravePhone/Domain/UseCases
//
//  PURPOSE:
//   - Provides a clean domain-level interface to get a test token or send user queries.
//   - The ChatViewModel calls these methods.

import Foundation

public protocol AiChatUseCaseProtocol {
    func execute(userQuery: String, authToken: String) async throws -> String
    func getTestToken() async throws -> String
}

public struct AiChatUseCase: AiChatUseCaseProtocol {
    private let repository: AiChatRepositoryProtocol
    
    public init(repository: AiChatRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(userQuery: String, authToken: String) async throws -> String {
        try await repository.getAiResponse(for: userQuery, authToken: authToken)
    }
    
    public func getTestToken() async throws -> String {
        try await repository.getTestToken()
    }
}
