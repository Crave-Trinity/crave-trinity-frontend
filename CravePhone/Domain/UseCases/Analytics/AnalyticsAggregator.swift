// File: Core/Domain/UseCases/Analytics/AnalyticsAggregator.swift

import Foundation

@MainActor
public final class AnalyticsAggregator: ObservableObject {
    private let storage: AnalyticsStorageProtocol
    
    public init(storage: AnalyticsStorageProtocol) {
        self.storage = storage
    }
    
    public func aggregate(events: [any AnalyticsEvent]) async throws -> BasicAnalyticsResult {
        let totalCravings = events.count
        let totalResisted = events.filter { ($0.metadata["resisted"] as? Bool) ?? false }.count
        let intensities = events.compactMap { $0.metadata["intensity"] as? Double }
        let averageIntensity = intensities.isEmpty ? 0 : intensities.reduce(0, +) / Double(intensities.count)
        
        var cravingsByDate: [Date: Int] = [:]
        var cravingsByHour: [Int: Int] = [:]
        var cravingsByWeekday: [Int: Int] = [:]
        var commonTriggers: [String: Int] = [:]
        let timePatterns: [String] = []  // Placeholder, not mutated
        
        for event in events {
            let date = Calendar.current.startOfDay(for: event.timestamp)
            cravingsByDate[date, default: 0] += 1
            
            let hour = Calendar.current.component(.hour, from: event.timestamp)
            cravingsByHour[hour, default: 0] += 1
            
            let weekday = Calendar.current.component(.weekday, from: event.timestamp)
            cravingsByWeekday[weekday, default: 0] += 1
            
            if let trigger = event.metadata["trigger"] as? String {
                commonTriggers[trigger, default: 0] += 1
            }
        }
        
        return BasicAnalyticsResult(
            totalCravings: totalCravings,
            totalResisted: totalResisted,
            averageIntensity: averageIntensity,
            cravingsByDate: cravingsByDate,
            cravingsByHour: cravingsByHour,
            cravingsByWeekday: cravingsByWeekday,
            commonTriggers: commonTriggers,
            timePatterns: timePatterns,
            detectedPatterns: []
        )
    }
}
