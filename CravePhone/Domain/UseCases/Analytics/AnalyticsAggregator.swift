//
//  AnalyticsAggregator.swift
//  CravePhone
//
//  Uncle Bob: An Aggregator's sole job is to compute metrics from a list of
//  domain events. Keep it stateless and side-effect free if possible.
//
import Foundation
public final class AnalyticsAggregator: AnalyticsAggregatorProtocol {
    public init() {}
    
    // MARK: - Public Methods
    
    /// Aggregates the provided CravingEvents to produce a BasicAnalyticsResult.
    public func aggregate(events: [CravingEvent]) async throws -> BasicAnalyticsResult {
        // Count total events
        let total = events.count
        
        // Count those flagged as 'resisted'
        let totalResisted = events.filter {
            ($0.metadata["resisted"] as? Bool) == true
        }.count
        
        // Calculate average intensity
        let intensities = events.compactMap { $0.metadata["intensity"] as? Double }
        let averageIntensity = intensities.isEmpty ? 0 : intensities.reduce(0, +) / Double(intensities.count)
        
        // Calculate average resistance
        let resistances = events.compactMap { $0.metadata["resistance"] as? Double }
        let averageResistance = resistances.isEmpty ? 0 : resistances.reduce(0, +) / Double(resistances.count)
        
        // Compute success rate (resisted vs. total)
        let successRate = total > 0 ? (Double(totalResisted) / Double(total)) * 100.0 : 0.0
        
        // Group cravings by date, ignoring time-of-day to get daily counts
        var cravingsByDate: [Date: Int] = [:]
        for event in events {
            let day = Calendar.current.startOfDay(for: event.timestamp)
            cravingsByDate[day, default: 0] += 1
        }
        
        // Return the aggregated result
        return BasicAnalyticsResult(
            totalCravings: total,
            totalResisted: totalResisted,
            averageIntensity: averageIntensity,
            averageResistance: averageResistance,
            successRate: successRate,
            cravingsByDate: cravingsByDate
        )
    }
}






