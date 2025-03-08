// DIRECTORY/FILENAME: CravePhone/Presentation/Common/Extensions/DependencyContainer+Preview.swift
// PASTE & RUN (Removed mock getTestToken())

import Foundation
import SwiftUI
import SwiftData

extension DependencyContainer {
    static var preview: DependencyContainer {
        let container = DependencyContainer()
        return container
    }
}

// MARK: - Mock Repository Implementations for Previews
class MockCravingRepository: CravingRepository {
    func addCraving(_ craving: CravingEntity) async throws {}
    func fetchActiveCravings() async throws -> [CravingEntity] { [] }
    func archiveCraving(_ craving: CravingEntity) async throws {}
    func deleteCraving(_ craving: CravingEntity) async throws {}
    func fetchCravings() async throws -> [CravingEntity] { [] }
    func saveCraving(_ craving: CravingEntity) async throws -> CravingEntity { craving }
}

class MockAiChatRepository: AiChatRepositoryProtocol {
    func getAiResponse(for userQuery: String, authToken: String) async throws -> String {
        return "Mock AI response to: \"\(userQuery)\""
    }
}
