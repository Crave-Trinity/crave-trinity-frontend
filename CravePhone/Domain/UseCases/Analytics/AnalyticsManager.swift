//
//  AnalyticsManager.swift
//  CravePhone
//
//  Description:
//   Orchestrates fetching analytics events, aggregating them, and optionally detecting patterns.
//   Returns a unified BasicAnalyticsResult. Pattern detection is currently optional.
//   (Uncle Bob: Simple, clear orchestration.)
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
        
        // Determine start date based on selected time frame.
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
        
        // 1) Retrieve events from the repository.
        let events = try await repository.fetchCravingEvents(from: startDate, to: now)
        
        // 2) Aggregate events into BasicAnalyticsResult.
        let aggregated = try await aggregator.aggregate(events: events)
        
        // 3) (Optional) Detect patterns. (Currently unused.)
        // _ = try await patternDetection.detectPatterns(in: events)
        
        return aggregated
    }
}
