//
//  MockAnalytics.swift
//  CravePhone
//
//  Purpose:
//    Quick mock implementations for previews/tests
//    so SwiftUI can compile and see them.
//
//  Usage:
//    Called by AnalyticsDashboardView_Previews.
//
//  Target Membership:
//    Make sure this file is part of the "CravePhone" target (not just "Tests").
//

import Foundation

// MARK: - Mock Analytics Repository

final class MockAnalyticsRepository: AnalyticsRepositoryProtocol {
    // Protocol requirement
    func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [CravingEvent] {
        []  // Return empty array for previews
    }
}

// MARK: - Mock Analytics Aggregator

final class MockAnalyticsAggregator: AnalyticsAggregatorProtocol {
    // Protocol requirement
    func aggregate(events: [CravingEvent]) async throws -> AggregatedData {
        // Provide some dummy data so the preview shows interesting results if needed
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
    // Protocol requirement
    func detectPatterns(in events: [CravingEvent]) async throws -> [String] {
        ["Mocked pattern 1", "Mocked pattern 2"]
    }
}
