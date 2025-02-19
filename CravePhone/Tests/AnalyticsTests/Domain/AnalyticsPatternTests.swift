// Associated Test File: AnalyticsPatternTests.swift

import XCTest
@testable import CRAVE

final class AnalyticsPatternTests: XCTestCase {
    // MARK: - Time-Based Pattern Tests
    func testTimeBasedPatternMatching() {
        let pattern = TimeBasedPattern(hour: 14, windowMinutes: 60)
        
        // Test matching time
        let matchingAnalytics = CravingAnalytics.mock(
            timestamp: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date())!
        )
        XCTAssertTrue(pattern.matches(matchingAnalytics))
        
        // Test non-matching time
        let nonMatchingAnalytics = CravingAnalytics.mock(
            timestamp: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
        )
        XCTAssertFalse(pattern.matches(nonMatchingAnalytics))
    }
    
    // MARK: - Trigger-Based Pattern Tests
    func testTriggerBasedPatternMatching() {
        let pattern = TriggerBasedPattern(triggers: ["stress", "boredom"])
        
        // Test matching triggers
        let matchingAnalytics = CravingAnalytics.mock(triggers: ["stress", "hunger"])
        XCTAssertTrue(pattern.matches(matchingAnalytics))
        
        // Test non-matching triggers
        let nonMatchingAnalytics = CravingAnalytics.mock(triggers: ["hunger", "tiredness"])
        XCTAssertFalse(pattern.matches(nonMatchingAnalytics))
    }
    
    // MARK: - Pattern Confidence Tests
    func testPatternConfidenceCalculation() {
        let pattern = BasePattern.mock()
        
        // Test initial confidence
        XCTAssertEqual(pattern.confidence, 0.0)
        
        // Test confidence after updates
        let analytics = CravingAnalytics.mock()
        pattern.updateWith(analytics)
        
        XCTAssertGreaterThan(pattern.confidence, 0.0)
    }
    
    // MARK: - Pattern Recognition Engine Tests
    func testPatternRecognitionEngine() {
        let engine = PatternRecognitionEngine()
        
        // Test pattern detection
        let analytics = CravingAnalytics.mock()
        engine.processAnalytics(analytics)
        
        // Add more specific assertions based on your pattern recognition logic
    }
}

// MARK: - Test Helpers
extension CravingAnalytics {
    static func mock(
        timestamp: Date = Date(),
        triggers: Set<String> = ["test_trigger"]
    ) -> CravingAnalytics {
        CravingAnalytics(
            id: UUID(),
            timestamp: timestamp,
            intensity: 5,
            triggers: triggers,
            metadata: [:]
        )
    }
}

