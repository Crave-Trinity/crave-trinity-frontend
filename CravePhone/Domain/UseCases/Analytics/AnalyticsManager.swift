//
//  AnalyticsManager.swift
//  CravePhone
//
//  Uncle Bob's advice: clearly separate concerns, explicit initialization, and predictable flow.
//
//  AnalyticsManager.swift:
//  Retrieves, aggregates, and presents analytics clearly and consistently.
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

    // MARK: - Enum for Analytics Time Frame
    public enum TimeFrame {
        case week, month, quarter, year
    }

    // MARK: - Public Methods

    /// Retrieves and aggregates CRAVING events for a specified time frame.
    public func getBasicStats(for timeFrame: TimeFrame) async throws -> BasicAnalyticsResult {
        // Correctly initialize the date range using clearly defined variables.
        let now = Date()
        let startDate: Date  // Explicitly define startDate to ensure proper initialization.

        // Use a switch statement to set the correct startDate based on the selected timeframe.
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

        // Fetch craving events from the repository within the specified time frame.
        let events = try await repository.fetchCravingEvents(from: startDate, to: now)

        // Aggregate events using the injected aggregator.
        let aggregated = try await aggregator.aggregate(events: events)

        return aggregated
    }

    /// Retrieves patterns detected from craving events.
    public func getDetectedPatterns(for timeFrame: TimeFrame) async throws -> [String] {
        let now = Date()
        let startDate: Date

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

        // Fetch events again explicitly for pattern detection.
        let events = try await repository.fetchCravingEvents(from: startDate, to: now)

        // Use the injected pattern detection service to analyze the events.
        let patterns = try await patternDetection.detectPatterns(in: events)

        return patterns
    }
}
