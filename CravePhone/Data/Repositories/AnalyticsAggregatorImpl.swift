//
//  AnalyticsAggregatorImpl.swift
//  CravePhone
//
//  Uncle Bob & SOLID notes:
//    - Uses event.cravingEntity.confidenceToResist / cravingStrength for sums.
//    - Clean reduce(into:) usage.
//    - No more missing members due to renamed entity fields.
//

import Foundation

public final class AnalyticsAggregatorImpl: AnalyticsAggregatorProtocol {
    
    private let storage: AnalyticsStorageProtocol
    
    public init(storage: AnalyticsStorageProtocol) {
        self.storage = storage
    }
    
    public func aggregate(events: [CravingEvent]) async throws -> AggregatedData {
        let total = events.count
        
        // Sum confidenceToResist
        let sumResistance = events.reduce(into: 0.0) { partial, event in
            partial += event.cravingEntity.confidenceToResist
        }
        let averageResistance = (total > 0) ? (sumResistance / Double(total)) : 0.0
        
        // Sum cravingStrength
        let sumIntensity = events.reduce(into: 0.0) { partial, event in
            partial += event.cravingEntity.cravingStrength
        }
        let averageIntensity = (total > 0) ? (sumIntensity / Double(total)) : 0.0
        
        // Example usage
        let totalResisted = events.filter { $0.cravingEntity.confidenceToResist > 5.0 }.count
        
        // Placeholders for advanced groupings
        let cravingsByDate: [Date: Int] = [:]
        let cravingsByHour: [Int: Int] = [:]
        let cravingsByWeekday: [Int: Int] = [:]
        let commonTriggers: [String: Int] = [:]
        let timePatterns: [String] = []
        
        return AggregatedData(
            totalCravings: total,
            totalResisted: totalResisted,
            averageIntensity: averageIntensity,
            averageResistance: averageResistance,
            cravingsByDate: cravingsByDate,
            cravingsByHour: cravingsByHour,
            cravingsByWeekday: cravingsByWeekday,
            commonTriggers: commonTriggers,
            timePatterns: timePatterns
        )
    }
}

