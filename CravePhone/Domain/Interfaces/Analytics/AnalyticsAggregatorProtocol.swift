//
//  AnalyticsAggregatorProtocol.swift
//  CravePhone
//
//  Description:
//    Domain interface that aggregates craving events into
//    an "AggregatedData" struct.
//
//  Uncle Bob notes:
//    - Single Responsibility: 'AggregatedData' just stores the analytics sums/averages.
//    - Open/Closed: We can add fields (like 'averageResistance') without breaking older usage.
//
import Foundation

public struct AggregatedData {
    public let totalCravings: Int
    public let totalResisted: Int
    public let averageIntensity: Double
    
    // New: add averageResistance
    public let averageResistance: Double
    
    public let cravingsByDate: [Date: Int]
    public let cravingsByHour: [Int: Int]
    public let cravingsByWeekday: [Int: Int]
    public let commonTriggers: [String: Int]
    public let timePatterns: [String]
    
    public init(
        totalCravings: Int,
        totalResisted: Int,
        averageIntensity: Double,
        averageResistance: Double,  // <-- add to init
        cravingsByDate: [Date: Int],
        cravingsByHour: [Int: Int],
        cravingsByWeekday: [Int: Int],
        commonTriggers: [String: Int],
        timePatterns: [String]
    ) {
        self.totalCravings = totalCravings
        self.totalResisted = totalResisted
        self.averageIntensity = averageIntensity
        self.averageResistance = averageResistance // store new field
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
