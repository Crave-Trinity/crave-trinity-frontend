//  BasicAnalyticsResult.swift
//  CravePhone
//
//  The single analytics result struct, no duplicates!

import Foundation

public struct BasicAnalyticsResult {
    public let totalCravings: Int
    public let totalResisted: Int
    public let averageIntensity: Double
    public let averageResistance: Double
    public let successRate: Double
    
    public let cravingsByDate: [Date: Int]
    
    public init(
        totalCravings: Int,
        totalResisted: Int,
        averageIntensity: Double,
        averageResistance: Double,
        successRate: Double,
        cravingsByDate: [Date: Int]
    ) {
        self.totalCravings = totalCravings
        self.totalResisted = totalResisted
        self.averageIntensity = averageIntensity
        self.averageResistance = averageResistance
        self.successRate = successRate
        self.cravingsByDate = cravingsByDate
    }
}
