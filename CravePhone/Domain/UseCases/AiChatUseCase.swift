// DIRECTORY/FILENAME: CravePhone/Domain/UseCases/AiChatUseCase.swift
// PASTE & RUN (Removed getTestToken(); only real JWT usage remains)

import Foundation

public protocol AiChatUseCaseProtocol {
    func execute(userQuery: String, authToken: String) async throws -> String
}

public struct AiChatUseCase: AiChatUseCaseProtocol {
    private let repository: AiChatRepositoryProtocol
    
    public init(repository: AiChatRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(userQuery: String, authToken: String) async throws -> String {
        try await repository.getAiResponse(for: userQuery, authToken: authToken)
    }
}
