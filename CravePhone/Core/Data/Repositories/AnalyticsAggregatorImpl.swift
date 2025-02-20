//
//  AnalyticsAggregatorImpl.swift
//  CravePhone
//
//  Description:
//    Aggregates events for analytics.
//
//  If your container calls `AnalyticsAggregatorImpl(storage: analyticsStorage)`
//  you must define a matching init here.
//

import Foundation

public final class AnalyticsAggregatorImpl: AnalyticsAggregatorProtocol {
    
    private let storage: AnalyticsStorageProtocol
    
    public init(storage: AnalyticsStorageProtocol) {
        self.storage = storage
    }
    
    public func aggregate(events: [CravingEvent]) async throws -> AggregatedData {
        // Access `storage` if needed
        return AggregatedData(
            totalCravings: events.count,
            totalResisted: 0,
            averageIntensity: 0.0,
            cravingsByDate: [:],
            cravingsByHour: [:],
            cravingsByWeekday: [:],
            commonTriggers: [:],
            timePatterns: []
        )
    }
}
