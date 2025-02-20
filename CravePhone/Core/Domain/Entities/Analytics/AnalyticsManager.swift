//
//  AnalyticsManager.swift
//  CravePhone
//
//  Description:
//    A high-level domain service that orchestrates fetching events,
//    aggregating them, detecting patterns, and returning a BasicAnalyticsResult.
//
//  Note: We now rely on protocol-based dependencies for flexibility.
//

import Foundation

@MainActor
public final class AnalyticsManager: ObservableObject {
    
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
    
    public func getBasicStats() async throws -> BasicAnalyticsResult {
        let now = Date()
        guard let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: now) else {
            throw NSError(domain: "AnalyticsManager",
                          code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to calculate start date"])
        }
        
        // 1) Fetch events
        let cravingEvents = try await repository.fetchCravingEvents(from: sevenDaysAgo, to: now)
        
        // 2) Aggregate them
        let aggregatedData = try await aggregator.aggregate(events: cravingEvents)
        
        // 3) Detect patterns
        let detectedPatterns = try await patternDetection.detectPatterns(in: cravingEvents)
        
        // 4) Merge aggregator data + detected patterns into final BasicAnalyticsResult
        return BasicAnalyticsResult(
            totalCravings: aggregatedData.totalCravings,
            totalResisted: aggregatedData.totalResisted,
            averageIntensity: aggregatedData.averageIntensity,
            cravingsByDate: aggregatedData.cravingsByDate,
            cravingsByHour: aggregatedData.cravingsByHour,
            cravingsByWeekday: aggregatedData.cravingsByWeekday,
            commonTriggers: aggregatedData.commonTriggers,
            timePatterns: aggregatedData.timePatterns,
            detectedPatterns: detectedPatterns
        )
    }
}
