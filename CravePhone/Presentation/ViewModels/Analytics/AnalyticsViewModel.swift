//
//  AnalyticsViewModel.swift
//  CravePhone
//
//  ViewModel for analytics data processing and visualization.
//

import Foundation
import SwiftUI

@MainActor
public class AnalyticsViewModel: ObservableObject {
    private let manager: AnalyticsManager
    
    // MARK: - Published Properties
    @Published var totalCravings: Int = 0
    @Published var averageIntensity: Double = 0.0
    @Published var averageResistance: Double = 0.0
    @Published var successRate: Double = 0.0
    
    // Data points for charts
    @Published var weeklyData: [DataPoint] = []
    @Published var hourlyData: [DataPoint] = []
    @Published var intensityTrend: [DataPoint] = []
    @Published var resistanceTrend: [DataPoint] = []
    @Published var weekdayHourHeatmap: [[Double]] = []
    @Published var monthlyTrend: [DataPoint] = []
    @Published var topTriggers: [DataPoint] = []
    @Published var emotionDistribution: [DataPoint] = []
    @Published var triggersByTimeOfDay: [[DataPoint]] = []
    @Published var triggerAnalysis: [TriggerAnalysis] = []
    
    // Insights and recommendations
    @Published var recentInsights: [String] = []
    @Published var keyInsights: [String] = []
    @Published var cravingPrediction: String = "Next likely craving: Tomorrow around 8 PM"
    @Published var detectedPatterns: [String] = []
    @Published var recommendations: [String] = []
    
    // MARK: - Initialization
    
    public init(manager: AnalyticsManager) {
        self.manager = manager
        loadSampleData()
    }
    
    // MARK: - Public Methods
    
    func fetchAnalytics(timeFrame: AnalyticsDashboardView.TimeFrame) async {
        // This would normally fetch real data from the analytics manager
        // For now, we'll just use our sample data
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        loadSampleData()
    }
    
    // MARK: - Private Methods
    
    private func loadSampleData() {
        // Summary metrics
        totalCravings = 42
        averageIntensity = 6.5
        averageResistance = 7.2
        successRate = 71.4
        
        // Chart data
        weeklyData = createSampleDataPoints(count: 7, labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"])
        hourlyData = createSampleDataPoints(count: 24, labels: (0..<24).map { "\($0):00" })
        intensityTrend = createSampleDataPoints(count: 30, labels: (1...30).map { "Day \($0)" })
        resistanceTrend = createSampleDataPoints(count: 30, labels: (1...30).map { "Day \($0)" })
        weekdayHourHeatmap = createSampleHeatmapData(rows: 7, cols: 24)
        monthlyTrend = createSampleDataPoints(count: 12, labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
        topTriggers = createSampleDataPoints(count: 5, labels: ["Stress", "Boredom", "Social", "Anxiety", "Routine"])
        emotionDistribution = createSampleDataPoints(count: 6, labels: ["Stress", "Boredom", "Anxiety", "Social", "Tired", "Hungry"])
        
        // Create grouped data for triggers by time of day
        let morningTriggers = createSampleDataPoints(count: 5, labels: ["Stress", "Routine", "Hunger", "Anxiety", "Tired"])
        let afternoonTriggers = createSampleDataPoints(count: 5, labels: ["Boredom", "Stress", "Social", "Hunger", "Anxiety"])
        let eveningTriggers = createSampleDataPoints(count: 5, labels: ["Social", "Boredom", "Stress", "Anxiety", "Relaxation"])
        triggersByTimeOfDay = [morningTriggers, afternoonTriggers, eveningTriggers]
        
        // Trigger analysis
        triggerAnalysis = [
            TriggerAnalysis(trigger: "Stress", averageIntensity: 8.2, frequency: 15),
            TriggerAnalysis(trigger: "Boredom", averageIntensity: 6.8, frequency: 12),
            TriggerAnalysis(trigger: "Social", averageIntensity: 7.5, frequency: 8),
            TriggerAnalysis(trigger: "Anxiety", averageIntensity: 8.7, frequency: 7)
        ]
        
        // Insights and recommendations
        recentInsights = [
            "Morning cravings are typically higher intensity (8.2/10 on average)",
            "Social settings increase craving frequency by 68%",
            "You resist cravings better on weekdays vs. weekends"
        ]
        
        keyInsights = [
            "Stress is your primary craving trigger (36% of cravings)",
            "Your resistance has improved 12% in the last month",
            "Weekend evenings show the highest craving intensity",
            "You have better resistance when you log your cravings consistently"
        ]
        
        detectedPatterns = [
            "Cravings spike 2-3 hours after work ends",
            "Weekend social events often lead to multiple cravings",
            "Morning routine is linked to habitual cravings"
        ]
        
        recommendations = [
            "Try a 5-minute meditation when stress triggers occur",
            "Plan structured activities for high-risk times",
            "Log your cravings consistently for better insights",
            "Practice resistance techniques before social events"
        ]
    }
    
    private func createSampleDataPoints(count: Int, labels: [String]) -> [DataPoint] {
        var points: [DataPoint] = []
        for i in 0..<count {
            let value = Double.random(in: 1...10)
            points.append(DataPoint(label: labels[i], value: value))
        }
        return points
    }
    
    private func createSampleHeatmapData(rows: Int, cols: Int) -> [[Double]] {
        var data: [[Double]] = []
        for _ in 0..<rows {
            var row: [Double] = []
            for _ in 0..<cols {
                row.append(Double.random(in: 0...10))
            }
            data.append(row)
        }
        return data
    }
}
