
//=================================================
// FILE: CravingListFlowUITests.swift
// DIRECTORY: CravePhoneUITests
// PURPOSE: Tests the Craving List screen (search, filter, archive).
//
// UNCLE BOB / SOLID:
// - Each test method has a single responsibility to verify one feature.
// - Clear naming, minimal duplication.
//
// GOF / STEVE JOBS DESIGN:
// - Strategy pattern: each test covers a distinct user strategy
// - Minimal friction: straightforward test code with clarity.
//=================================================

import XCTest

final class CravingListFlowUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    /// Test navigation to "Cravings" tab and ensuring the list loads.
    func testNavigateToCravingsList() throws {
        app.tabBars.buttons["Cravings"].tap()
        
        // Check if the "Search cravings" text field is there
        XCTAssertTrue(app.textFields["Search cravings"].exists,
                      "Search field should be visible on CravingListView.")
        
        // Possibly check if there's a "Loading cravings..." indicator before data loads
        // Adjust or remove based on your code
    }
    
    /// Test searching for a known craving text (assuming one is in the list).
    func testSearchForCraving() throws {
        app.tabBars.buttons["Cravings"].tap()
        
        let searchField = app.textFields["Search cravings"]
        XCTAssertTrue(searchField.exists, "Search text field must exist.")
        
        searchField.tap()
        searchField.typeText("Chocolate")
        
        // Possibly check if a list cell contains "Chocolate"
        XCTAssertTrue(app.staticTexts["Chocolate craving after dinner"].exists,
                      "Craving list should show 'Chocolate craving...' when searching 'Chocolate'.")
    }
    
    /// Test applying a filter chip, e.g., "High Intensity" or "Recent".
    func testFilterHighIntensity() throws {
        app.tabBars.buttons["Cravings"].tap()
        
        let highChip = app.buttons["High Intensity"]
        XCTAssertTrue(highChip.exists, "High intensity filter chip must exist.")
        
        highChip.tap()
        
        // Check that results reflect only high-intensity cravings
        // This is domain-specific; adjust the following line
        // Example: A cell that has intensity >= 7
        XCTAssertTrue(app.staticTexts["Intensity: 8/10"].exists
                      || app.staticTexts["Intensity: 9/10"].exists,
                      "At least one high-intensity craving should be visible after filter.")
    }
    
    /// Test archiving a craving from the list via context menu or button.
    func testArchiveCraving() throws {
        app.tabBars.buttons["Cravings"].tap()
        
        // Identify a specific craving cell
        let cravingCell = app.staticTexts["Social drinking urge"] // example
        XCTAssertTrue(cravingCell.exists, "Expected 'Social drinking urge' in the list.")
        
        // Long press or use context menu to archive
        cravingCell.press(forDuration: 1.0)
        
        let archiveButton = app.buttons["Archive"]
        XCTAssertTrue(archiveButton.exists, "Archive option in context menu should be visible.")
        
        archiveButton.tap()
        
        // Confirm it’s removed from active list
        XCTAssertFalse(cravingCell.exists,
                       "Craving should disappear after archiving from the list.")
    }
}
