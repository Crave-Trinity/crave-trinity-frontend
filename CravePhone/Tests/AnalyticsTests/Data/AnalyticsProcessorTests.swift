// File: AnalyticsProcessorTests.swift
// Purpose: Test suite for analytics processing functionality

import XCTest
import Combine
@testable import CRAVE

final class AnalyticsProcessorTests: XCTestCase {
    var sut: AnalyticsProcessor!
    var storage: MockAnalyticsStorage!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        storage = MockAnalyticsStorage()
        sut = AnalyticsProcessor(
            configuration: .preview,
            storage: storage
        )
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        storage = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Immediate Processing Tests
    func testImmediateProcessing() async throws {
        // Create critical priority event
        let event = MockAnalyticsEvent(
            priority: .critical,
            metadata: ["test": "data"]
        )
        
        // Process event
        try await sut.process(event)
        
        // Verify immediate processing
        XCTAssertEqual(storage.storedEvents.count, 1)
        XCTAssertEqual(sut.processingState, .idle)
        XCTAssertNotNil(sut.lastProcessingTime)
    }
    
    // MARK: - Batch Processing Tests
    func testBatchProcessing() async throws {
        // Create batch of events
        let events = (0..<5).map { i in
            MockAnalyticsEvent(
                priority: .normal,
                metadata: ["index": "\(i)"]
            )
        }
        
        // Process batch
        try await sut.processBatch(events)
        
        // Verify batch processing
        XCTAssertEqual(storage.storedEvents.count, 5)
        XCTAssertEqual(sut.processingMetrics.lastBatchSize, 5)
    }
    
    // MARK: - Queue Tests
    func testQueueProcessing() async throws {
        // Add events to queue
        let events = (0..<3).map { i in
            MockAnalyticsEvent(
                priority: .low,
                metadata: ["index": "\(i)"]
            )
        }
        
        // Process events individually
        for event in events {
            try await sut.process(event)
        }
        
        // Flush queue
        try await sut.flushQueue()
        
        // Verify queue processing
        XCTAssertEqual(storage.storedEvents.count, 3)
    }
    
    // MARK: - Error Handling Tests
    func testInvalidEventProcessing() async {
        let invalidEvent = MockAnalyticsEvent(
            priority: .normal,
            metadata: [:],
            isValid: false
        )
        
        do {
            try await sut.process(invalidEvent)
            XCTFail("Expected invalid event error")
        } catch ProcessingError.invalidEvent {
            // Expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Metrics Tests
    func testProcessingMetrics() async throws {
        // Process multiple batches
        let batch1 = [MockAnalyticsEvent(priority: .normal)]
        let batch2 = [MockAnalyticsEvent(priority: .normal)]
        
        try await sut.processBatch(batch1)
        try await sut.processBatch(batch2)
        
        // Verify metrics
        XCTAssertEqual(sut.processingMetrics.totalProcessed, 2)
        XCTAssertGreaterThan(sut.processingMetrics.averageProcessingTime, 0)
    }
    
    // MARK: - Configuration Tests
    func testConfigurationUpdates() {
        let expectation = expectation(description: "Configuration update")
        
        sut.$processingState
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.post(
            name: .analyticsConfigurationUpdated,
            object: nil
        )
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Performance Tests
    func testProcessingPerformance() {
        measure {
            let events = (0..<100).map { _ in
                MockAnalyticsEvent(priority: .normal)
            }
            
            Task {
                try? await self.sut.processBatch(events)
            }
        }
    }
}

// MARK: - Mock Types
class MockAnalyticsStorage: AnalyticsStorage {
    var storedEvents: [AnalyticsEvent] = []
    
    override func store(_ event: AnalyticsEvent) async throws {
        storedEvents.append(event)
    }
    
    override func storeBatch(_ events: [AnalyticsEvent]) async throws {
        storedEvents.append(contentsOf: events)
    }
}

struct MockAnalyticsEvent: AnalyticsEvent {
    let id = UUID()
    let timestamp = Date()
    let eventType: AnalyticsEventType = .appLaunch
    let metadata: [String: AnyHashable]
    let priority: EventPriority
    let isValid: Bool
    
    init(
        priority: EventPriority = .normal,
        metadata: [String: AnyHashable] = [:],
        isValid: Bool = true
    ) {
        self.priority = priority
        self.metadata = metadata
        self.isValid = isValid
    }
}

