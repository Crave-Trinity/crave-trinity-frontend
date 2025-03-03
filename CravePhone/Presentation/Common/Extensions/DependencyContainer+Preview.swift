// DependencyContainer+Preview.swift

import Foundation
import SwiftUI
import SwiftData

// MARK: - Preview Factory
extension DependencyContainer {
    static var preview: DependencyContainer {
        let container = DependencyContainer()

        // We can't modify private properties dynamically, so we'll use a simpler approach
        // that doesn't require modifying private vars with Objective-C runtime

        return container
    }
}

// MARK: - Mock Repository Implementations for Previews
class MockCravingRepository: CravingRepository {
    func addCraving(_ craving: CravingEntity) async throws {
        // No-op for preview
    }

    func fetchActiveCravings() async throws -> [CravingEntity] {
        return [
            CravingEntity.preview(description: "Chocolate craving after dinner", intensity: 8.0, resistance: 4.0),
            CravingEntity.preview(description: "Morning coffee craving", intensity: 6.0, resistance: 7.0),
            CravingEntity.preview(description: "Social drinking urge", intensity: 9.0, resistance: 3.0)
        ]
    }

    func archiveCraving(_ craving: CravingEntity) async throws {
        // No-op for preview
    }

    func deleteCraving(_ craving: CravingEntity) async throws {
        // No-op for preview
    }

    // Bridge methods from extensions
    func fetchCravings() async throws -> [CravingEntity] {
        return try await fetchActiveCravings()
    }

    func saveCraving(_ craving: CravingEntity) async throws -> CravingEntity {
        try await addCraving(craving)
        return craving
    }
}

class MockAiChatRepository: AiChatRepositoryProtocol {
    func getAiResponse(for userQuery: String, authToken: String) async throws -> String { // Added authToken
        return "This is a sample AI response to your query: \"\(userQuery)\". In a real implementation, this would be fetched from your AI service."
    }

    // Add the getTestToken method
    func getTestToken() async throws -> String {
        return "mock-auth-token" // Return a hardcoded token for previews
    }
}
