//
//  AnalyticsAggregatorImpl.swift
//  CravePhone
//
//  Description:
//    Aggregates events for analytics.
//    Updated to use reduce(into:) and reference CravingEntity fields.
//
//  Uncle Bob & SOLID notes:
//    - Single Responsibility: focuses solely on turning raw CravingEvents into aggregated metrics.
//    - We assume the "resistance" & "intensity" values come from `cravingEntity.confidenceToResist`
//      and `cravingEntity.cravingStrength`.
//
//  Fixes:
//    - Missing argument label 'into:' by explicitly using reduce(into:).
//    - "Value of type 'CravingEvent' has no member 'resistance'" by
//      referencing event.cravingEntity.confidenceToResist instead.
//
import Foundation

public final class AnalyticsAggregatorImpl: AnalyticsAggregatorProtocol {
    
    private let storage: AnalyticsStorageProtocol
    
    public init(storage: AnalyticsStorageProtocol) {
        self.storage = storage
    }
    
    public func aggregate(events: [CravingEvent]) async throws -> AggregatedData {
        
        // (A) Count total events
        let total = events.count
        
        // (B) Sum "resistance" from cravingEntity.confidenceToResist using reduce(into:)
        let sumResistance = events.reduce(into: 0.0) { partial, event in
            partial += event.cravingEntity.confidenceToResist
        }
        let averageResistance = (total > 0) ? (sumResistance / Double(total)) : 0.0
        
        // (C) Sum "intensity" from cravingEntity.cravingStrength
        let sumIntensity = events.reduce(into: 0.0) { partial, event in
            partial += event.cravingEntity.cravingStrength
        }
        let averageIntensity = (total > 0) ? (sumIntensity / Double(total)) : 0.0
        
        // (D) Suppose "resisted" means confidenceToResist > 5.0
        let totalResisted = events.filter { $0.cravingEntity.confidenceToResist > 5.0 }.count
        
        // (E) Placeholders for grouping logic
        let cravingsByDate: [Date: Int] = [:]
        let cravingsByHour: [Int: Int] = [:]
        let cravingsByWeekday: [Int: Int] = [:]
        let commonTriggers: [String: Int] = [:]
        let timePatterns: [String] = []
        
        // (F) Return the aggregated data
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
