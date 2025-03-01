//
//  AnalyticsAggregator.swift
//  CravePhone
//
//  Description:
//    A high-level domain service that orchestrates fetching events,
//    aggregating them, detecting patterns, and returning a BasicAnalyticsResult.
//    Now includes computation for averageResistance.
//
//  Uncle Bob & SOLID notes:
//    - Single Responsibility: This class converts raw AnalyticsEvents into a
//      BasicAnalyticsResult for display.
//    - Open/Closed: Additional metrics can be added without modifying existing logic.
//  GoF Principles:
//    - Encapsulates aggregation logic, keeping the UI and repository layers decoupled.
//
import Foundation

@MainActor
public final class AnalyticsAggregator: ObservableObject {
    private let storage: AnalyticsStorageProtocol
    
    public init(storage: AnalyticsStorageProtocol) {
        self.storage = storage
    }
    
    public func aggregate(events: [any AnalyticsEvent]) async throws -> BasicAnalyticsResult {
        // 1) Count total events
        let totalCravings = events.count
        
        // 2) Determine total number of resisted events from metadata ("resisted" key)
        let totalResisted = events.filter { ($0.metadata["resisted"] as? Bool) ?? false }.count
        
        // 3) Compute average intensity from metadata "intensity"
        let intensities = events.compactMap { $0.metadata["intensity"] as? Double }
        let averageIntensity = intensities.isEmpty ? 0 : intensities.reduce(0, +) / Double(intensities.count)
        
        // 4) Compute average resistance from metadata "resistance"
        let resistances = events.compactMap { $0.metadata["resistance"] as? Double }
        let averageResistance = resistances.isEmpty ? 0 : resistances.reduce(0, +) / Double(resistances.count)
        
        // 5) Aggregate additional data by date, hour, and weekday
        var cravingsByDate: [Date: Int] = [:]
        var cravingsByHour: [Int: Int] = [:]
        var cravingsByWeekday: [Int: Int] = [:]
        var commonTriggers: [String: Int] = [:]
        let timePatterns: [String] = []  // Placeholder for future pattern logic
        
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
        
        // 6) Return the final BasicAnalyticsResult, including the new averageResistance value.
        return BasicAnalyticsResult(
            totalCravings: totalCravings,
            totalResisted: totalResisted,
            averageIntensity: averageIntensity,
            averageResistance: averageResistance,  // <-- New argument passed here
            cravingsByDate: cravingsByDate,
            cravingsByHour: cravingsByHour,
            cravingsByWeekday: cravingsByWeekday,
            commonTriggers: commonTriggers,
            timePatterns: timePatterns,
            detectedPatterns: []  // Empty; can be populated by pattern detection logic
        )
    }
}
