//
//  AnalyticsTypes.swift
//  CravePhone
//
//  Uncle Bob & GOF - Single Responsibility:
//    - Separate file containing analytics-specific data models
//      that are used by both the ViewModel and the View.
//

import Foundation

public struct DataPoint: Identifiable {
    public let id = UUID()
    public let label: String
    public let value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
}

public struct TriggerAnalysis: Identifiable {
    public let id = UUID()
    public let trigger: String
    public let averageIntensity: Double
    public let frequency: Int
    
    public init(trigger: String, averageIntensity: Double, frequency: Int) {
        self.trigger = trigger
        self.averageIntensity = averageIntensity
        self.frequency = frequency
    }
}
