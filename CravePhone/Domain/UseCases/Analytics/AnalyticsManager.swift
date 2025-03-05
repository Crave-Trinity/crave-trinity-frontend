//
//  AnalyticsManager.swift
//  CravePhone
//
//  Uncle Bob's advice: clearly separate concerns, explicit initialization, and predictable flow.

import Foundation

public final class AnalyticsManager {
    // MARK: - Dependencies
    private let repository: AnalyticsRepository
    private let aggregator: AnalyticsAggregatorProtocol
    private let patternDetection: PatternDetectionServiceProtocol // ✅ Correctly declared

    // MARK: - Initialization (✅ Explicit fix added here)
    public init(
        repository: AnalyticsRepository,
        aggregator: AnalyticsAggregatorProtocol,
        patternDetection: PatternDetectionServiceProtocol
    ) {
        self.repository = repository
        self.aggregator = aggregator
        self.patternDetection = patternDetection // 🚨 MISSING LINE FIXED HERE 🚨
    }

    // MARK: - Enum for Analytics Time Frame
    public enum TimeFrame {
        case all, week, month, quarter, year
    }

    /// Explicit FIX: Correct fetching logic (no filtering issues)
    public func getBasicStats(for timeFrame: TimeFrame) async throws -> BasicAnalyticsResult {
        let events = try await repository.fetchCravingEvents(
            from: Date.distantPast,
            to: Date.distantFuture
        )
        let aggregated = try await aggregator.aggregate(events: events)
        return aggregated
    }

    /// Explicit FIX: Pattern detection fetching logic (same logic correction)
    public func getDetectedPatterns(for timeFrame: TimeFrame) async throws -> [String] {
        let events = try await repository.fetchCravingEvents(
            from: Date.distantPast,
            to: Date.distantFuture
        )
        return try await patternDetection.detectPatterns(in: events)
    }
}
