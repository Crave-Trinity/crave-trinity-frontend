#if DEBUG
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
final class MockAnalyticsRepository: AnalyticsRepositoryProtocol {
    // Returns an empty array (for previews)
    func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [CravingEvent] {
        return []
    }
}

// MARK: - Mock Analytics Aggregator
final class MockAnalyticsAggregator: AnalyticsAggregatorProtocol {
    // Returns dummy aggregated data for preview purposes
    func aggregate(events: [CravingEvent]) async throws -> AggregatedData {
        AggregatedData(
            totalCravings: 10,
            totalResisted: 4,
            averageIntensity: 2.5,
            averageResistance: 3.2,
            cravingsByDate: [:],
            cravingsByHour: [:],
            cravingsByWeekday: [:],
            commonTriggers: [:],
            timePatterns: []
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

