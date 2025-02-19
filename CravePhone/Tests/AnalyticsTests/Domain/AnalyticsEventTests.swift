

// File: AnalyticsEventTests.swift
// Purpose: Tests for the analytics event system

import XCTest
@testable import CRAVE

final class AnalyticsEventTests: XCTestCase {
    var pipeline: AnalyticsEventPipeline!
    
    override func setUp() {
        super.setUp()
        pipeline = AnalyticsEventPipeline()
    }
    
    override func tearDown() {
        pipeline = nil
        super.tearDown()
    }
    
    // MARK: - Event Creation Tests
    func testEventCreation() {
        let event = BaseAnalyticsEvent.mock()
        XCTAssertNotNil(event.id)
        XCTAssertEqual(event.eventType, .cravingCreated)
        XCTAssertEqual(event.priority, .normal)
    }
    
    // MARK: - Event Processing Tests
    func testEventProcessing() async throws {
        let event = BaseAnalyticsEvent.mock(priority: .critical)
        try await pipeline.process(event)
        // Add assertions based on your processing requirements
    }
    
    // MARK: - Priority Tests
    func testEventPriorities() {
        XCTAssertEqual(EventPriority.critical.processingDelay, 0)
        XCTAssertEqual(EventPriority.normal.processingDelay, 60)
    }
    
    // Add more tests...
}
