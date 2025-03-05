//
// AnalyticsAggregator.swift
// CravePhone
//
// Fully Corrected AnalyticsAggregator adhering to Uncle Bob's principles:
// Clear naming, single responsibility, explicit data flow.
//

import Foundation

public final class AnalyticsAggregator: AnalyticsAggregatorProtocol {

    /// Aggregates craving events into structured analytics for UI.
    public func aggregate(events: [CravingEvent]) async throws -> BasicAnalyticsResult {
        
        // 1. Total number of cravings
        let totalCravings = events.count

        // 2. Extract intensities and calculate average
        let intensities = events.compactMap { $0.metadata["intensity"] as? Double }
        let averageIntensity = intensities.isEmpty
            ? 0.0
            : intensities.reduce(0, +) / Double(intensities.count)

        // 3. Extract resistance and calculate average
        let resistances = events.compactMap { $0.metadata["resistance"] as? Double }
        let averageResistance = resistances.isEmpty
            ? 0.0
            : resistances.reduce(0, +) / Double(resistances.count)

        // 4. Count explicitly the resisted cravings
        let totalResisted = events.filter { ($0.metadata["resisted"] as? Bool) == true }.count

        // 5. Calculate the success rate clearly
        let successRate = events.isEmpty
            ? 0.0
            : Double(totalResisted) / Double(events.count) * 100.0

        // 6. Group cravings clearly by date (daily total)
        var cravingsByDate: [Date: Int] = [:]
        for event in events {
            let day = Calendar.current.startOfDay(for: event.timestamp)
            cravingsByDate[day, default: 0] += 1
        }

        // 7. Return explicitly structured analytics result (Corrected explicitly here!)
        return BasicAnalyticsResult(
            totalCravings: totalCravings,       // ✅ explicitly corrected to remove warning
            totalResisted: totalResisted,
            averageIntensity: averageIntensity,
            averageResistance: averageResistance,
            successRate: successRate,
            cravingsByDate: cravingsByDate
        )
    }
}
