//
//  AnalyticsManager.swift
//  CravePhone
//
//  Description:
//    Orchestrates the aggregator, returning BasicAnalyticsResult with no confusion.
//    It fetches craving events, aggregates them, and (optionally) detects patterns.
//    Currently, pattern detection is not integrated into the final result.
//    (Uncle Bob style: Keep it simple and remove unused variables.)
//

import Foundation

public final class AnalyticsManager {
    private let repository: AnalyticsRepositoryProtocol
    private let aggregator: AnalyticsAggregatorProtocol
    private let patternDetection: PatternDetectionServiceProtocol
    
    public init(
        repository: AnalyticsRepositoryProtocol,
        aggregator: AnalyticsAggregatorProtocol,
        patternDetection: PatternDetectionServiceProtocol
    ) {
        self.repository = repository
        self.aggregator = aggregator
        self.patternDetection = patternDetection
    }
    
    public enum TimeFrame {
        case week, month, quarter, year
    }
    
    public func getBasicStats(for timeFrame: TimeFrame) async throws -> BasicAnalyticsResult {
        let now = Date()
        let startDate: Date
        
        // Determine the start date based on the time frame.
        switch timeFrame {
        case .week:
            startDate = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: now) ?? now
        case .quarter:
            startDate = Calendar.current.date(byAdding: .month, value: -3, to: now) ?? now
        case .year:
            startDate = Calendar.current.date(byAdding: .year, value: -1, to: now) ?? now
        }
        
        // 1) Get events from the repository.
        let events = try await repository.fetchCravingEvents(from: startDate, to: now)
        
        // 2) Aggregate events into a BasicAnalyticsResult.
        let aggregated = try await aggregator.aggregate(events: events)
        
        // 3) Optionally detect patterns. Currently unused.
        // _ = try await patternDetection.detectPatterns(in: events)
        
        // 4) Return the final aggregated result.
        return aggregated
    }
}
