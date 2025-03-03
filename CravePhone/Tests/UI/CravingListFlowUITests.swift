//
//  CravingListFlowUITests.swift
//  CravePhoneUITests
//
//  Directory: CravePhoneUITests/UI/
//  PURPOSE: Tests the "Cravings" list screen, including navigation, search, filtering, and archiving.
//  Each test method targets a distinct user strategy following SOLID principles.
//

import XCTest

final class CravingListFlowUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    /// Test navigation to the "Cravings" tab and verify the search field is present.
    func testNavigateToCravingsList() throws {
        app.tabBars.buttons["Cravings"].tap()
        
        XCTAssertTrue(app.textFields["Search cravings"].exists,
                      "The search text field should be visible on the Cravings list screen.")
    }
    
    /// Test searching for a craving.
    func testSearchForCraving() throws {
        app.tabBars.buttons["Cravings"].tap()
        
        let searchField = app.textFields["Search cravings"]
        XCTAssertTrue(searchField.exists, "Search text field must exist.")
        
        searchField.tap()
        searchField.typeText("Chocolate")
        
        // Check if a cell with expected text appears.
        XCTAssertTrue(app.staticTexts["Chocolate craving after dinner"].exists,
                      "The cravings list should display a cell matching the search query.")
    }
    
    /// Test applying a filter (e.g., high intensity).
    func testFilterHighIntensity() throws {
        app.tabBars.buttons["Cravings"].tap()
        
        let highIntensityChip = app.buttons["High Intensity"]
        XCTAssertTrue(highIntensityChip.exists, "High Intensity filter chip should be visible.")
        
        highIntensityChip.tap()
        
        // Check that at least one high-intensity craving cell appears.
        XCTAssertTrue(app.staticTexts["Intensity: 8/10"].exists ||
                      app.staticTexts["Intensity: 9/10"].exists,
                      "At least one high-intensity craving should be visible after filtering.")
    }
    
    /// Test archiving a craving from the list.
    func testArchiveCraving() throws {
        app.tabBars.buttons["Cravings"].tap()
        
        // Find a specific craving cell by its label.
        let cravingCell = app.staticTexts["Social drinking urge"]
        XCTAssertTrue(cravingCell.exists, "The 'Social drinking urge' cell should exist in the list.")
        
        // Long press to activate the context menu.
        cravingCell.press(forDuration: 1.0)
        
        let archiveButton = app.buttons["Archive"]
        XCTAssertTrue(archiveButton.exists, "Archive option should be available in the context menu.")
        
        archiveButton.tap()
        
        // Verify that the cell is no longer visible.
        XCTAssertFalse(cravingCell.exists, "The craving should be removed from the list after archiving.")
    }
}
