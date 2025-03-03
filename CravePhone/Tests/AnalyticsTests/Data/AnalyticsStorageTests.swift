//
//  AnalyticsStorageTests.swift
//  CraveTrinityTests
//
//
//  Description:
//    This test file validates the AnalyticsStorage functionality using an in‑memory
//    ModelContext from SwiftData. The tests check that:
//      - A single AnalyticsDTO can be stored and then fetched by a date range.
//      - A batch of events can be stored and then cleaned up based on a cutoff date.
//      - Events can be filtered by event type.
//      - AnalyticsMetadata for a given craving ID can be retrieved.
//    Each test is written following the single-responsibility principle, ensuring clarity and modularity.
//

import XCTest
@testable import CraveTrinity

final class AnalyticsStorageTests: XCTestCase {

    // MARK: - Test Properties

    /// The in-memory container for testing our SwiftData models.
    var container: ModelContainer!
    /// The main model context used to insert and fetch models.
    var context: ModelContext!
    /// The AnalyticsStorage instance under test.
    var storage: AnalyticsStorage!

    // MARK: - Setup & Teardown

    override func setUpWithError() throws {
        // Create an in-memory container that handles both AnalyticsDTO and AnalyticsMetadata.
        container = try ModelContainer(for: AnalyticsDTO.self, AnalyticsMetadata.self, configurations: .init(isStoredInMemoryOnly: true))
        context = container.mainContext
        storage = AnalyticsStorage(modelContext: context)
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
        storage = nil
    }

    // MARK: - Test: Store and Fetch Single Event

    /// Tests that storing a single AnalyticsDTO event works and that it can be fetched
    /// within an appropriate date range.
    func testStoreAndFetchEvent() async throws {
        let now = Date()
        let eventType = "testEvent"
        let metadata: [String: Any] = ["foo": "bar", "count": 42]
        
        // Create and store an event.
        let event = AnalyticsDTO(id: UUID(), timestamp: now, eventType: eventType, metadata: metadata)
        try await storage.store(event)
        
        // Fetch events within a 10-second window around 'now'.
        let fetchedEvents = try await storage.fetchEvents(from: now.addingTimeInterval(-10), to: now.addingTimeInterval(10))
        XCTAssertEqual(fetchedEvents.count, 1, "Expected one event to be fetched.")
        
        // Verify the event's properties.
        if let fetchedEvent = fetchedEvents.first {
            XCTAssertEqual(fetchedEvent.eventType, eventType, "Event type should match the stored value.")
            let fetchedMetadata = fetchedEvent.metadata
            XCTAssertEqual(fetchedMetadata["foo"] as? String, "bar", "Metadata key 'foo' should equal 'bar'.")
            XCTAssertEqual(fetchedMetadata["count"] as? Int, 42, "Metadata key 'count' should equal 42.")
        } else {
            XCTFail("No event was fetched.")
        }
    }

    // MARK: - Test: Store Batch and Cleanup Old Data

    /// Tests that storing a batch of events and then cleaning up events older than a cutoff date
    /// removes the expected events.
    func testStoreBatchAndCleanup() async throws {
        let now = Date()
        // Create three events at different times.
        let event1 = AnalyticsDTO(id: UUID(), timestamp: now.addingTimeInterval(-3600), eventType: "batch", metadata: [:])
        let event2 = AnalyticsDTO(id: UUID(), timestamp: now.addingTimeInterval(-1800), eventType: "batch", metadata: [:])
        let event3 = AnalyticsDTO(id: UUID(), timestamp: now, eventType: "batch", metadata: [:])
        
        try await storage.storeBatch([event1, event2, event3])
        
        // Define a cutoff so that events older than 45 minutes ago are removed.
        let cutoff = now.addingTimeInterval(-2700) // 45 minutes ago
        try await storage.cleanupData(before: cutoff)
        
        // Fetch all events from 2 hours ago to 1 minute in the future.
        let remainingEvents = try await storage.fetchEvents(from: now.addingTimeInterval(-7200), to: now.addingTimeInterval(60))
        XCTAssertEqual(remainingEvents.count, 2, "Expected two events to remain after cleanup.")
    }

    // MARK: - Test: Fetch Events by Event Type

    /// Tests that events can be filtered by a specified event type.
    func testFetchEventsOfType() async throws {
        let now = Date()
        let eventA = AnalyticsDTO(id: UUID(), timestamp: now, eventType: "A", metadata: [:])
        let eventB = AnalyticsDTO(id: UUID(), timestamp: now, eventType: "B", metadata: [:])
        
        try await storage.storeBatch([eventA, eventB])
        
        let eventsOfTypeA = try await storage.fetchEvents(ofType: "A")
        XCTAssertEqual(eventsOfTypeA.count, 1, "Should fetch one event for event type 'A'.")
        XCTAssertEqual(eventsOfTypeA.first?.eventType, "A", "Fetched event type should match 'A'.")
    }
    
    // MARK: - Test: Fetch Metadata for a Given Craving ID

    /// Tests that AnalyticsMetadata can be fetched for a specific craving ID.
    func testFetchMetadata() async throws {
        let metaId = UUID()
        // Create an AnalyticsMetadata instance with a dummy user action.
        let metadataInstance = AnalyticsMetadata(id: metaId, userActions: [AnalyticsMetadata.UserAction(actionType: "test", timestamp: Date(), details: "detail")])
        
        // Insert and save metadata into the context.
        context.insert(metadataInstance)
        try context.save()
        
        let fetchedMetadata = try await storage.fetchMetadata(forCravingId: metaId)
        XCTAssertNotNil(fetchedMetadata, "Expected metadata to be fetched.")
        XCTAssertEqual(fetchedMetadata?.id, metaId, "Fetched metadata ID should match the provided ID.")
    }
}

