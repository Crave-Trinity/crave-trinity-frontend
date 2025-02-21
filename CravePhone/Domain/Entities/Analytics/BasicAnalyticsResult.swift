//
//  BasicAnalyticsResult.swift
//  CravePhone
//
//  Description:
//    A domain struct capturing high-level analytics results
//    for display in the UI.
//

import Foundation

public struct BasicAnalyticsResult {
    public let totalCravings: Int
    public let totalResisted: Int
    public let averageIntensity: Double
    public let cravingsByDate: [Date: Int]
    public let cravingsByHour: [Int: Int]
    public let cravingsByWeekday: [Int: Int]
    public let commonTriggers: [String: Int]
    public let timePatterns: [String]
    public let detectedPatterns: [String]

    public init(
        totalCravings: Int,
        totalResisted: Int,
        averageIntensity: Double,
        cravingsByDate: [Date: Int],
        cravingsByHour: [Int: Int],
        cravingsByWeekday: [Int: Int],
        commonTriggers: [String: Int],
        timePatterns: [String],
        detectedPatterns: [String]
    ) {
        self.totalCravings = totalCravings
        self.totalResisted = totalResisted
        self.averageIntensity = averageIntensity
        self.cravingsByDate = cravingsByDate
        self.cravingsByHour = cravingsByHour
        self.cravingsByWeekday = cravingsByWeekday
        self.commonTriggers = commonTriggers
        self.timePatterns = timePatterns
        self.detectedPatterns = detectedPatterns
    }
}
