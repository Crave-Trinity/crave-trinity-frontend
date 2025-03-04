//  AnalyticsAggregator.swift
//  CravePhone
//
//  Description:
//    Single aggregator implementing AnalyticsAggregatorProtocol, returning BasicAnalyticsResult.

import Foundation

public final class AnalyticsAggregator: AnalyticsAggregatorProtocol {
    public init() {}
    
    public func aggregate(events: [CravingEvent]) async throws -> BasicAnalyticsResult {
        let total = events.count
        
        // "resisted" from metadata
        let totalResisted = events.filter {
            ($0.metadata["resisted"] as? Bool) == true
        }.count
        
        // Averages
        let intensities = events.compactMap { $0.metadata["intensity"] as? Double }
        let averageIntensity = intensities.isEmpty ? 0 : intensities.reduce(0, +) / Double(intensities.count)
        
        let resistances = events.compactMap { $0.metadata["resistance"] as? Double }
        let averageResistance = resistances.isEmpty ? 0 : resistances.reduce(0, +) / Double(resistances.count)
        
        let successRate = (total > 0)
            ? (Double(totalResisted) / Double(total)) * 100.0
            : 0.0
        
        // Optional grouping by date
        var cravingsByDate: [Date: Int] = [:]
        for event in events {
            let day = Calendar.current.startOfDay(for: event.timestamp)
            cravingsByDate[day, default: 0] += 1
        }
        
        // Return the unified BasicAnalyticsResult
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
