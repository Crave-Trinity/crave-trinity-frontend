//DependencyContainer+Preview
#if DEBUG
import SwiftUI
import SwiftData

extension DependencyContainer {
    static var preview: DependencyContainer {
        let container = DependencyContainer()
        // For preview, you can override real repos with mocks if you want:
        // container.cravingRepository = MockCravingRepository()
        // container.aiChatRepository = MockAiChatRepository()
        return container
    }
}

// MARK: - Mock Repository Implementations for Previews

private final class MockCravingRepository: CravingRepository {
    func addCraving(_ craving: CravingEntity) async throws {}
    func fetchActiveCravings() async throws -> [CravingEntity] { [] }
    func archiveCraving(_ craving: CravingEntity) async throws {}
    func deleteCraving(_ craving: CravingEntity) async throws {}
    func fetchCravings() async throws -> [CravingEntity] { [] }
    func saveCraving(_ craving: CravingEntity) async throws -> CravingEntity { craving }
}

private final class MockAiChatRepository: AiChatRepositoryProtocol {
    func getAiResponse(for userQuery: String, authToken: String) async throws -> String {
        return "Mock AI response for preview: \"\(userQuery)\""
    }
}
#endif
