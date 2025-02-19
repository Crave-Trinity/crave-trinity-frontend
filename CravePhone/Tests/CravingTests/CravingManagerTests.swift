//
//  CravingManagerTests.swift
//  CRAVE
//

import XCTest
import SwiftData
@testable import CRAVE

final class CravingManagerTests: XCTestCase {
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    var cravingManager: CravingManager!

    // MARK: - Setup Before Each Test
    override func setUpWithError() throws {
        modelContainer = try ModelContainer(for: CravingModel.self, configurations: .init(isStoredInMemoryOnly: true))
        modelContext = modelContainer.mainContext
        cravingManager = CravingManager()
        cravingManager.modelContext = modelContext // ✅ Inject test context
    }

    // MARK: - Cleanup After Each Test
    override func tearDownWithError() throws {
        modelContainer = nil
        modelContext = nil
        cravingManager = nil
    }

    // MARK: - Test Adding a Craving
    func testInsertCraving() throws {
        let craving = CravingModel(cravingText: "Chocolate", timestamp: Date())
        cravingManager.insert(craving)

        let cravings = try modelContext.fetch(FetchDescriptor<CravingModel>())
        XCTAssertEqual(cravings.count, 1)
        XCTAssertEqual(cravings.first?.cravingText, "Chocolate")
    }

    // MARK: - Test Fetching Only Active Cravings
    func testFetchActiveCravings() async throws {
        let craving1 = CravingModel(cravingText: "Ice Cream", timestamp: Date())
        let craving2 = CravingModel(cravingText: "Pizza", timestamp: Date(), isArchived: true)

        cravingManager.insert(craving1)
        cravingManager.insert(craving2)

        let activeCravings = await cravingManager.fetchAllActiveCravings()
        XCTAssertEqual(activeCravings.count, 1)
        XCTAssertEqual(activeCravings.first?.cravingText, "Ice Cream")
    }

    // MARK: - Test Soft Deletion
    func testSoftDeleteCraving() throws {
        let craving = CravingModel(cravingText: "Cookies", timestamp: Date())
        cravingManager.insert(craving)

        cravingManager.archiveCraving(craving)

        let cravings = try modelContext.fetch(FetchDescriptor<CravingModel>())
        XCTAssertEqual(cravings.count, 1)
        XCTAssertTrue(cravings.first!.isArchived) // ✅ Ensure craving is marked as archived
    }
}

