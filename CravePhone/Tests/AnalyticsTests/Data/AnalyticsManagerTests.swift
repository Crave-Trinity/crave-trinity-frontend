// AnalyticsManagerTests.swift


import XCTest
import SwiftData
@testable import CRAVE

final class AnalyticsManagerTests: XCTestCase {
    var sut: AnalyticsManager!
    var modelContext: ModelContext!
    
    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: CravingModel.self, configurations: config)
        modelContext = container.mainContext
        sut = AnalyticsManager(modelContext: modelContext)
    }
    
    override func tearDown() {
        sut = nil
        modelContext = nil
        super.tearDown()
    }
    
    // MARK: - Processing Tests
    func testProcessNewCraving() async throws {
        let craving = CravingModel(cravingText: "Test Craving")
        try await sut.processNewCraving(craving)
        
        XCTAssertNotNil(sut.currentAnalytics)
        XCTAssertEqual(sut.processingState, .idle)
    }
    
    // Add more tests...
}

