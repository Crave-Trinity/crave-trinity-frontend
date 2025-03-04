//
//  AnalyticsManager.swift
//  CravePhone
//
//  Uncle Bob: A "Manager" here orchestrates multiple pieces in the domain layer.
//  It calls into repositories, coordinates aggregator logic, and can optionally
//  handle advanced use cases like pattern detection.
//
import Foundation
public final class AnalyticsManager {
    // MARK: - Dependencies
    private let repository: AnalyticsRepository
    private let aggregator: AnalyticsAggregatorProtocol
    private let patternDetection: PatternDetectionServiceProtocol
    
    // MARK: - Initialization
    public init(
        repository: AnalyticsRepository,
        aggregator: AnalyticsAggregatorProtocol,
        patternDetection: PatternDetectionServiceProtocol
    ) {
        self.repository = repository
        self.aggregator = aggregator
        self.patternDetection = patternDetection
    }
    
    // MARK: - Public Types
    
    public enum TimeFrame {
        case week, month, quarter, year
    }
    
    // MARK: - Public Methods
    
    /// Retrieves and aggregates CRAVING events for a specified time frame (week, month, etc.).
    public func getBasicStats(for timeFrame: TimeFrame) async throws -> BasicAnalyticsResult {
        let now = Date()
        let startDate: Date
        
        // 1) Determine the start date for the time frame
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
        
        // 2) Fetch the raw craving events in that period
        let events = try await repository.fetchCravingEvents(from: startDate, to: now)
        
        // 3) Aggregate them into a BasicAnalyticsResult
        let aggregated = try await aggregator.aggregate(events: events)
        
        // 4) (Optional) Do pattern detection, if needed. Currently commented out.
        // _ = try await patternDetection.detectPatterns(in: events)
        
        return aggregated
    }
}

