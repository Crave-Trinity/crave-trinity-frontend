//
//  AnalyticsViewModel.swift
//  CravePhone
//
//  This version no longer calls loadSampleData().
//  It now fetches real analytics by asking AnalyticsManager for basic stats,
//  passing in a timeFrame, and then updating the published properties.
//

import SwiftUI
import Foundation

@MainActor
public class AnalyticsViewModel: ObservableObject {
    private let manager: AnalyticsManager
    
    // MARK: - Published Properties (to be displayed in the UI)
    @Published var totalCravings: Int = 0
    @Published var averageIntensity: Double = 0.0
    @Published var averageResistance: Double = 0.0
    @Published var successRate: Double = 0.0
    
    // Example aggregated data (add more as needed)
    @Published var cravingsByDate: [Date: Int] = [:]
    @Published var cravingsByHour: [Int: Int] = [:]
    @Published var detectedPatterns: [String] = []
    
    // MARK: - Initialization
    public init(manager: AnalyticsManager) {
        self.manager = manager
    }
    
    // MARK: - Public Methods
    
    /// Fetches analytics data for the given timeFrame.
    /// This method calls the AnalyticsManager's getBasicStats(for:) method.
    func fetchAnalytics(timeFrame: AnalyticsDashboardView.TimeFrame) async {
        do {
            // The manager now accepts a timeFrame argument.
            let stats = try await manager.getBasicStats(for: timeFrame)
            
            // Update the published properties with real data.
            self.totalCravings = stats.totalCravings
            self.averageIntensity = stats.averageIntensity
            self.averageResistance = stats.averageResistance
            self.successRate = stats.totalCravings > 0 ? (Double(stats.totalResisted) / Double(stats.totalCravings)) * 100.0 : 0
            self.cravingsByDate = stats.cravingsByDate
            self.cravingsByHour = stats.cravingsByHour
            self.detectedPatterns = stats.detectedPatterns
        } catch {
            print("Error fetching analytics: \(error)")
        }
    }
}

