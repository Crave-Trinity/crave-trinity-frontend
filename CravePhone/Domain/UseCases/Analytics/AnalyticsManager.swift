//
//  AnalyticsManager.swift
//  CravePhone
//
//  This version handles different time frames (week, month, quarter, year)
//  to fetch and aggregate real analytics data.
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
    
    /// Returns basic analytics stats for a given time frame.
    public func getBasicStats(for timeFrame: AnalyticsDashboardView.TimeFrame) async throws -> BasicAnalyticsResult {
        let now = Date()
        let startDate: Date
        
        // Choose the start date based on the selected time frame.
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
        
        // Fetch events, aggregate data, and detect patterns.
        let cravingEvents = try await repository.fetchCravingEvents(from: startDate, to: now)
        let aggregatedData = try await aggregator.aggregate(events: cravingEvents)
        let detectedPatterns = try await patternDetection.detectPatterns(in: cravingEvents)
        
        // Merge the aggregated data with detected patterns into the final result.
        return BasicAnalyticsResult(
            totalCravings: aggregatedData.totalCravings,
            totalResisted: aggregatedData.totalResisted,
            averageIntensity: aggregatedData.averageIntensity,
            averageResistance: aggregatedData.averageResistance,
            cravingsByDate: aggregatedData.cravingsByDate,
            cravingsByHour: aggregatedData.cravingsByHour,
            cravingsByWeekday: aggregatedData.cravingsByWeekday,
            commonTriggers: aggregatedData.commonTriggers,
            timePatterns: aggregatedData.timePatterns,
            detectedPatterns: detectedPatterns
        )
    }
}

