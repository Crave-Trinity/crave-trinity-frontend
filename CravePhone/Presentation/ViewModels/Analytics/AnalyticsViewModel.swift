//
//  AnalyticsViewModel.swift
//  CravePhone
//
//  Description:
//    SwiftUI ViewModel that calls AnalyticsManager to fetch & display real stats.
//
import SwiftUI
import Foundation

@MainActor
public final class AnalyticsViewModel: ObservableObject {
    private let manager: AnalyticsManager
    
    @Published public var totalCravings: Int = 0
    @Published public var averageIntensity: Double = 0
    @Published public var averageResistance: Double = 0
    @Published public var successRate: Double = 0
    @Published public var cravingsByDate: [Date: Int] = [:]
    
    // NEW: Detected patterns property used in the triggers tab.
    @Published public var detectedPatterns: [String] = []
    
    public init(manager: AnalyticsManager) {
        self.manager = manager
    }
    
    public func fetchAnalytics(timeFrame: AnalyticsManager.TimeFrame) async {
        do {
            let result = try await manager.getBasicStats(for: timeFrame)
            self.totalCravings = result.totalCravings
            self.averageIntensity = result.averageIntensity
            self.averageResistance = result.averageResistance
            self.successRate = result.successRate
            self.cravingsByDate = result.cravingsByDate
            
            // If pattern detection is implemented, update detectedPatterns accordingly.
            // For now, assign an empty array.
            self.detectedPatterns = []
        } catch {
            print("Error fetching analytics:", error)
        }
    }
}
