// Associated Test File: AnalyticsInsightTests.swift

import XCTest
@testable import CRAVE

final class AnalyticsInsightTests: XCTestCase {
    // MARK: - Base Insight Tests
    func testBaseInsightValidation() {
        let validInsight = BaseInsight(
            type: .timePattern,
            title: "Test",
            description: "Description",
            confidence: 0.8
        )
        XCTAssertTrue(validInsight.validate())
        
        let invalidInsight = BaseInsight(
            type: .timePattern,
            title: "",
            description: "",
            confidence: 1.5
        )
        XCTAssertFalse(invalidInsight.validate())
    }
    
    // MARK: - Time Pattern Insight Tests
    func testTimePatternInsight() {
        let insight = TimePatternInsight(
            peakHours: [14, 15],
            averageIntensity: 7.5,
            confidence: 0.85
        )
        
        XCTAssertTrue(insight.validate())
        XCTAssertTrue(insight.description.contains("14:00"))
        XCTAssertTrue(insight.description.contains("7.5"))
    }
    
    // MARK: - Insight Generator Tests
    func testInsightGenerator() {
        let generator = InsightGenerator()
        let analytics = AnalyticsData.mock()
        
        let insights = generator.generateInsights(from: analytics)
        
        XCTAssertFalse(insights.isEmpty)
        XCTAssertTrue(insights.allSatisfy { $0.validate() })
    }
    
    // MARK: - Relevance Tests
    func testRelevanceCalculation() {
        let insight = BaseInsight.mock()
        XCTAssertTrue(insight.relevanceScore >= 0 && insight.relevanceScore <= 1)
    }
}

// MARK: - Test Helpers
extension AnalyticsData {
    static func mock() -> AnalyticsData {
        // Create mock analytics data
        return AnalyticsData()
    }
}

