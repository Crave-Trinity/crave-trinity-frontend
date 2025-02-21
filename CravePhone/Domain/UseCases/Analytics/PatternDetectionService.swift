import Foundation

@MainActor
public final class PatternDetectionService {
    private let storage: AnalyticsStorageProtocol
    private let configuration: AnalyticsConfiguration
    
    // Public initializer.
    public init(storage: AnalyticsStorageProtocol, configuration: AnalyticsConfiguration) {
        self.storage = storage
        self.configuration = configuration
    }
    
    // Public method to detect patterns in events.
    public func detectPatterns(in events: [any AnalyticsEvent]) async throws -> [String] {
        let threshold = configuration.highFrequencyThreshold
        let window = configuration.timeWindowForHighFrequency
        
        var patterns: [String] = []
        for i in 0..<events.count {
            let windowStart = events[i].timestamp
            let windowEnd = windowStart.addingTimeInterval(window)
            let eventsInWindow = events.filter { $0.timestamp >= windowStart && $0.timestamp <= windowEnd }
            if eventsInWindow.count > threshold {
                patterns.append("High frequency craving detected at \(windowStart)")
            }
        }
        return patterns
    }
}
