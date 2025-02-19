import Foundation
import Combine

/// A public class that handles analytics operations for the CRAVE app.
@MainActor
public final class AnalyticsManager: ObservableObject {
    
    // Dependencies exposed as public types (via their public protocols or classes)
    private let repository: AnalyticsRepository
    private let aggregator: AnalyticsAggregator
    private let patternDetection: PatternDetectionService
    
    // Public initializer: all dependency types must be public.
    public init(repository: AnalyticsRepository,
                aggregator: AnalyticsAggregator,
                patternDetection: PatternDetectionService) {
        self.repository = repository
        self.aggregator = aggregator
        self.patternDetection = patternDetection
    }
    
    // Public method to fetch basic analytics data.
    public func getBasicStats() async throws -> BasicAnalyticsResult {
        let now = Date()
        guard let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: now) else {
            throw NSError(domain: "AnalyticsManager",
                          code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to calculate start date"])
        }
        let cravingEvents = try await repository.fetchCravingEvents(from: sevenDaysAgo, to: now)
        let aggregatedData = try await aggregator.aggregate(events: cravingEvents)
        let detectedPatterns = try await patternDetection.detectPatterns(in: cravingEvents)
        
        return BasicAnalyticsResult(
            totalCravings: aggregatedData.totalCravings,
            totalResisted: aggregatedData.totalResisted,
            averageIntensity: aggregatedData.averageIntensity,
            cravingsByDate: aggregatedData.cravingsByDate,
            cravingsByHour: aggregatedData.cravingsByHour,
            cravingsByWeekday: aggregatedData.cravingsByWeekday,
            commonTriggers: aggregatedData.commonTriggers,
            timePatterns: aggregatedData.timePatterns,
            detectedPatterns: detectedPatterns
        )
    }
}
