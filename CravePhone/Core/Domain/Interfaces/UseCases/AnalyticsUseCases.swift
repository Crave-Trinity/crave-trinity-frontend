import Foundation

public protocol GetBasicAnalyticsUseCaseProtocol {
    func execute() async throws -> BasicAnalyticsResult
}

public final class GetBasicAnalyticsUseCase: GetBasicAnalyticsUseCaseProtocol {
    private let analyticsManager: AnalyticsManager

    public init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    public func execute() async throws -> BasicAnalyticsResult {
        return try await analyticsManager.getBasicStats()
    }
}

