//
//  BasicAnalyticsResult.swift
//  CravePhone
//
//  Description:
//    A domain struct capturing high-level analytics results
//    for display in the UI.
//
//  Uncle Bob + SOLID notes:
//    - Single Responsibility: Holds final analytics fields consumed by the UI.
//    - Open/Closed: We added 'averageResistance' here without breaking older usage of existing fields.
//
import Foundation

public struct BasicAnalyticsResult {
    public let totalCravings: Int
    public let totalResisted: Int
    public let averageIntensity: Double
    public let averageResistance: Double  // New field
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
        averageResistance: Double,
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
        self.averageResistance = averageResistance   // store it
        self.cravingsByDate = cravingsByDate
        self.cravingsByHour = cravingsByHour
        self.cravingsByWeekday = cravingsByWeekday
        self.commonTriggers = commonTriggers
        self.timePatterns = timePatterns
        self.detectedPatterns = detectedPatterns
    }
}
