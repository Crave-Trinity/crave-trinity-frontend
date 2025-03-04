//
//  AnalyticsAggregator.swift
//  CravePhone
//
//  Description:
//   Implements AnalyticsAggregatorProtocol. It computes totals, averages, and groups events by date.
//   (Designed to be simple, extensible, and maintainable.)
//

import Foundation

public final class AnalyticsAggregator: AnalyticsAggregatorProtocol {
    public init() {}
    
    public func aggregate(events: [CravingEvent]) async throws -> BasicAnalyticsResult {
        let total = events.count
        
        // Count events flagged as "resisted" in metadata.
        let totalResisted = events.filter {
            ($0.metadata["resisted"] as? Bool) == true
        }.count
        
        // Compute average intensity.
        let intensities = events.compactMap { $0.metadata["intensity"] as? Double }
        let averageIntensity = intensities.isEmpty ? 0 : intensities.reduce(0, +) / Double(intensities.count)
        
        // Compute average resistance.
        let resistances = events.compactMap { $0.metadata["resistance"] as? Double }
        let averageResistance = resistances.isEmpty ? 0 : resistances.reduce(0, +) / Double(resistances.count)
        
        // Compute success rate.
        let successRate = total > 0 ? (Double(totalResisted) / Double(total)) * 100.0 : 0.0
        
        // Group events by date.
        var cravingsByDate: [Date: Int] = [:]
        for event in events {
            let day = Calendar.current.startOfDay(for: event.timestamp)
            cravingsByDate[day, default: 0] += 1
        }
        
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
