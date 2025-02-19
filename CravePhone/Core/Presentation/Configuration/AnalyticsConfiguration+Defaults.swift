/// This extension adds default computed properties to AnalyticsConfiguration that are used
/// in pattern detection for the CRAVE app. It provides a default threshold and time window for
/// high frequency craving events.

import Foundation

public extension AnalyticsConfiguration {
    var highFrequencyThreshold: Int {
        return 3
    }
    
    var timeWindowForHighFrequency: TimeInterval {
        return 3600
    }
}
