//
//  AnalyticsAggregatorProtocol.swift
//  CravePhone
//
//  Description:
//    Domain interface that aggregates craving events into
//    some intermediate data structure (e.g., an "AggregatedData").
//

import Foundation

public struct AggregatedData {
    public let totalCravings: Int
    public let totalResisted: Int
    public let averageIntensity: Double
    public let cravingsByDate: [Date: Int]
    public let cravingsByHour: [Int: Int]
    public let cravingsByWeekday: [Int: Int]
    public let commonTriggers: [String: Int]
    public let timePatterns: [String]

    public init(
        totalCravings: Int,
        totalResisted: Int,
        averageIntensity: Double,
        cravingsByDate: [Date: Int],
        cravingsByHour: [Int: Int],
        cravingsByWeekday: [Int: Int],
        commonTriggers: [String: Int],
        timePatterns: [String]
    ) {
        self.totalCravings = totalCravings
        self.totalResisted = totalResisted
        self.averageIntensity = averageIntensity
        self.cravingsByDate = cravingsByDate
        self.cravingsByHour = cravingsByHour
        self.cravingsByWeekday = cravingsByWeekday
        self.commonTriggers = commonTriggers
        self.timePatterns = timePatterns
    }
}

public protocol AnalyticsAggregatorProtocol: AnyObject {
    func aggregate(events: [CravingEvent]) async throws -> AggregatedData
}
