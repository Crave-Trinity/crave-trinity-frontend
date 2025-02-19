// File: AnalyticsCoordinatorTests.swift
// Purpose: Test suite for analytics coordination functionality

import XCTest
import SwiftData
import Combine
@testable import CRAVE

final class AnalyticsCoordinatorTests: XCTestCase {
    var sut: AnalyticsCoordinator!
    var mockAnalyticsService: MockAnalyticsService!
    var mockEventTrackingService: MockEventTrackingService!
    var mockPatternDetectionService: MockPatternDetectionService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAnalyticsService = MockAnalyticsService()
        mockEventTrackingService = MockEventTrackingService()
        mockPatternDetectionService = MockPatternDetectionService()
        
        sut = AnalyticsCoordinator(
            analyticsService: mockAnalyticsService,
            eventTrackingService: mockEventTrackingService,
            patternDetectionService: mockPatternDetectionService,
            configuration: .preview
        )
        
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockAnalyticsService = nil
        mockEventTrackingService = nil
        mockPatternDetectionService = nil
        super.tearDown()
    }
    
    // MARK: - Lifecycle Tests
    func testStartupSequence() async throws {
        // Test startup
        await sut.start()
        
        XCTAssertEqual(sut.coordinatorState, .active)
        XCTAssertEqual(sut.processingMetrics.totalProcessingRuns, 0)
    }
    
    func testShutdownSequence() async throws {
        // Start first
        await sut.start()
        
        // Test shutdown
        await sut.stop()
        
        XCTAssertEqual(sut.coordinatorState, .inactive)
    }
    
    // MARK: - Processing Tests
    func testAnalyticsProcessing() async throws {
        await sut.start()
        
        try await sut.processAnalytics()
        
        XCTAssertEqual(sut.coordinatorState, .active)
        XCTAssertNotNil(sut.lastProcessingTime)
        XCTAssertEqual(sut.processingMetrics.totalProcessingRuns, 1)
    }
    
    func testProcessingNotification() async throws {
        let expectation = expectation(description: "Processing completed notification")
        
        NotificationCenter.default
            .publisher(for: .analyticsProcessingCompleted)
            .sink { notification in
                XCTAssertNotNil(notification.userInfo?["patterns"])
                XCTAssertNotNil(notification.userInfo?["insights"])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await sut.start()
        try await sut.processAnalytics()
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    // MARK: - Report Generation Tests
    func testReportGeneration() async throws {
        await sut.start()
        
        let report = try await sut.generateReport(type: .daily)
        
        XCTAssertNotNil(report)
        XCTAssertEqual(sut.processingMetrics.totalReportsGenerated, 1)
    }
    
    // MARK: - Reset Tests
    func testAnalyticsReset() async throws {
        await sut.start()
        
        try await sut.resetAnalytics()
        
        XCTAssertEqual(sut.coordinatorState, .active)
        XCTAssertEqual(mockAnalyticsService.resetCount, 1)
    }
    
    // MARK: - Error Handling Tests
    func testProcessingError() async {
        await sut.start()
        mockAnalyticsService.shouldSimulateError = true
        
        do {
            try await sut.processAnalytics()
            XCTFail("Expected processing error")
        } catch {
            XCTAssertEqual(sut.processingMetrics.totalErrors, 1)
            if case .error = sut.coordinatorState {
                // Expected state
            } else {
                XCTFail("Expected error state")
            }
        }
    }
    
    // MARK: - State Change Tests
    func testStateTransitions() async {
        let stateChanges = expectation(description: "State changes")
        var states: [CoordinatorState] = []
        
        sut.$coordinatorState
            .sink { state in
                states.append(state)
                if states.count >= 3 { // inactive -> starting -> active
                    stateChanges.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await sut.start()
        
        await fulfillment(of: [stateChanges], timeout: 5.0)
        
        XCTAssertEqual(states[0], .inactive)
        XCTAssertEqual(states[1], .starting)
        XCTAssertEqual(states[2], .active)
    }
    
    // MARK: - Performance Tests
    func testCoordinatorPerformance() {
        measure {
            let expectation = expectation(description: "Processing performance")
            
            Task {
                await sut.start()
                try? await sut.processAnalytics()
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    }
}

// MARK: - Mock Services
class MockAnalyticsService: AnalyticsService {
    var shouldSimulateError = false
    var resetCount = 0
    
    override func processAnalytics() async throws {
        if shouldSimulateError {
            throw CoordinatorError.processingFailed(NSError(domain: "test", code: 1))
        }
    }
    
    override func reset() async throws {
        resetCount += 1
    }
}

class MockEventTrackingService: EventTrackingService {
    var trackingEnabled = true
}

class MockPatternDetectionService: PatternDetectionService {
    override func detectPatterns() async throws -> [DetectedPattern] {
        return []
    }
}

