// Core/Domain/Entities/Analytics/BasicAnalyticsResult.swift

import Foundation

// Make this struct public
public struct BasicAnalyticsResult {
    public let totalCravings: Int
    public let totalResisted: Int
    public let averageIntensity: Double
    public let cravingsByDate: [Date: Int]
    public let cravingsByHour: [Int: Int]
    public let cravingsByWeekday: [Int: Int]
    public let commonTriggers: [String: Int]
    public let timePatterns: [String]
    public let detectedPatterns: [String] // Make sure this is the correct type


    // Public initializer
    public init(totalCravings: Int, totalResisted: Int, averageIntensity: Double, cravingsByDate: [Date : Int], cravingsByHour: [Int : Int], cravingsByWeekday: [Int : Int], commonTriggers: [String : Int], timePatterns: [String], detectedPatterns: [String]) {
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

