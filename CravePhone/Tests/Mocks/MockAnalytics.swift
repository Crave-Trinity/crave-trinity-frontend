#if DEBUG
//
//  MockAnalytics.swift
//  CravePhone
//
//  Purpose:
//    Quick mock implementations for previews/tests so SwiftUI can compile and see them.
//    These classes are only included in DEBUG builds.
//  Usage:
//    Called by AnalyticsDashboardView_Previews.
//
import Foundation
// MARK: - Mock Analytics Repository
// Change from AnalyticsRepositoryProtocol to AnalyticsRepository
final class MockAnalyticsRepository: AnalyticsRepository {
    
    // Returns an empty array (for previews)
    func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [CravingEvent] {
        return []
    }
    
    // Stub: No-op implementation for storing a craving event
    func storeCravingEvent(from craving: CravingEntity) async throws {
        // Do nothing for preview/mock purposes.
    }
}
// MARK: - Mock Analytics Aggregator
final class MockAnalyticsAggregator: AnalyticsAggregatorProtocol {
    // Returns dummy aggregated data for preview purposes
    func aggregate(events: [CravingEvent]) async throws -> BasicAnalyticsResult {
        return BasicAnalyticsResult(
            totalCravings: 10,
            totalResisted: 4,
            averageIntensity: 2.5,
            averageResistance: 3.2,
            successRate: 40.0,
            cravingsByDate: [:]
        )
    }
}
// MARK: - Mock Pattern Detection Service
final class MockPatternDetectionService: PatternDetectionServiceProtocol {
    // Returns a couple of mock pattern strings
    func detectPatterns(in events: [CravingEvent]) async throws -> [String] {
        return ["Mocked pattern 1", "Mocked pattern 2"]
    }
}
#endif
