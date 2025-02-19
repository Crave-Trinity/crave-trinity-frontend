// File: AnalyticsAggregatorTests.swift
// Purpose: Test suite for AnalyticsAggregator functionality

import XCTest
import SwiftData
@testable import CRAVE

final class AnalyticsAggregatorTests: XCTestCase {
    var sut: AnalyticsAggregator!
    var modelContext: ModelContext!
    
    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: CravingModel.self)
        modelContext = container.mainContext
        sut = AnalyticsAggregator(modelContext: modelContext)
    }
    
    override func tearDown() {
        sut = nil
        modelContext = nil
        super.tearDown()
    }
    
    // MARK: - Daily Aggregation Tests
    func testDailyAggregation() async throws {
        // Create test analytics data
        let analytics = CravingAnalytics.mock(
            timestamp: Date(),
            intensity: 5,
            triggers: Set(["stress", "boredom"])
        )
        
        // Perform aggregation
        try await sut.aggregate(analytics)
        
        // Verify daily aggregates
        let result = try await sut.getAggregates(for: .day(Date()))
        guard case .daily(let dailyAggregate) = result else {
            XCTFail("Expected daily aggregate")
            return
        }
        
        XCTAssertEqual(dailyAggregate.cravingCount, 1)
        XCTAssertEqual(dailyAggregate.totalIntensity, 5)
        XCTAssertEqual(dailyAggregate.triggerPatterns["stress"], 1)
    }
    
    // MARK: - Weekly Aggregation Tests
    func testWeeklyAggregation() async throws {
        // Create test data across multiple days
        let today = Date()
        let analytics1 = CravingAnalytics.mock(timestamp: today)
        let analytics2 = CravingAnalytics.mock(timestamp: today.addingTimeInterval(-86400)) // Yesterday
        
        // Perform aggregations
        try await sut.aggregate(analytics1)
        try await sut.aggregate(analytics2)
        
        // Verify weekly aggregates
        let result = try await sut.getAggregates(for: .week(today))
        guard case .weekly(let weeklyAggregate) = result else {
            XCTFail("Expected weekly aggregate")
            return
        }
        
        XCTAssertTrue(weeklyAggregate.dailyDistribution.values.reduce(0, +) == 2)
    }
    
    // MARK: - Monthly Aggregation Tests
    func testMonthlyAggregation() async throws {
        // Create test data across multiple weeks
        let today = Date()
        let analytics1 = CravingAnalytics.mock(timestamp: today)
        let analytics2 = CravingAnalytics.mock(timestamp: today.addingTimeInterval(-7 * 86400)) // Last week
        
        // Perform aggregations
        try await sut.aggregate(analytics1)
        try await sut.aggregate(analytics2)
        
        // Verify monthly aggregates
        let result = try await sut.getAggregates(for: .month(today))
        guard case .monthly(let monthlyAggregate) = result else {
            XCTFail("Expected monthly aggregate")
            return
        }
        
        XCTAssertTrue(monthlyAggregate.weeklyDistribution.values.reduce(0, +) == 2)
    }
    
    // MARK: - Custom Range Tests
    func testCustomRangeAggregation() async throws {
        let startDate = Date().addingTimeInterval(-7 * 86400) // 7 days ago
        let endDate = Date()
        
        // Create test data within range
        let analytics = CravingAnalytics.mock(timestamp: Date().addingTimeInterval(-3 * 86400))
        try await sut.aggregate(analytics)
        
        // Verify custom range aggregates
        let result = try await sut.getAggregates(for: .custom(startDate, endDate))
        guard case .custom(let customAggregate) = result else {
            XCTFail("Expected custom range aggregate")
            return
        }
        
        XCTAssertEqual(customAggregate.start, startDate)
        XCTAssertEqual(customAggregate.end, endDate)
    }
    
    // MARK: - Error Handling Tests
    func testNoDataAvailable() async {
        let future = Date().addingTimeInterval(86400) // Tomorrow
        
        do {
            _ = try await sut.getAggregates(for: .day(future))
            XCTFail("Expected error for future date")
        } catch AnalyticsAggregator.AggregationError.noDataAvailable {
            // Success
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Performance Tests
    func testAggregationPerformance() throws {
        measure {
            // Create and aggregate 100 analytics entries
            Task {
                for _ in 0..<100 {
                    let analytics = CravingAnalytics.mock()
                    try? await self.sut.aggregate(analytics)
                }
            }
        }
    }
}

// MARK: - Test Helpers
extension CravingAnalytics {
    static func mock(
        timestamp: Date = Date(),
        intensity: Int = 5,
        triggers: Set<String> = ["test_trigger"]
    ) -> CravingAnalytics {
        CravingAnalytics(
            id: UUID(),
            timestamp: timestamp,
            intensity: intensity,
            triggers: triggers,
            metadata: [:]
        )
    }
}
