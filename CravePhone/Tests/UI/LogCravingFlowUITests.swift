//=================================================
// FILE: LogCravingFlowUITests.swift
// DIRECTORY: CravePhoneUITests
// PURPOSE: Thoroughly tests the "Log Craving" flow.
//
// ARCHITECTURE (SOLID + Uncle Bob):
// - Single Responsibility: This file tests the log flow end-to-end.
// - Open/Closed: Additional test methods can be added without modifying existing ones.
// - Interface Segregation: Each test focuses on one scenario at a time.
//
// GOF / STEVE JOBS DESIGN:
// - Strategy: Each test method is like a strategy for verifying a user path.
// - Simple, minimal friction with clear naming and comments.
//=================================================

import XCTest

final class LogCravingFlowUITests: XCTestCase {
    
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
    
    // MARK: - Test Cases
    
    /// Test that we can navigate to "Log" tab and see expected UI elements.
    func testNavigateToLogCravingTab() throws {
        // Tap the "Log" tab in your CRAVETabView
        app.tabBars.buttons["Log"].tap()
        
        // Check that the text field or text editor for craving description is present
        XCTAssertTrue(app.textViews["CravingDescriptionEditor"].exists
                      || app.textFields["CravingDescriptionEditor"].exists,
                      "The description text field or editor should be visible.")
        
        // Check mic button
        XCTAssertTrue(app.buttons["Mic"].exists,
                      "The mic toggle button should be visible on the Log Craving screen.")
        
        // Check "Log Craving" button
        XCTAssertTrue(app.buttons["Log Craving"].exists,
                      "Log Craving button should be visible.")
    }
    
    /// Test toggling speech recognition.
    /// (Note: actual speech recognition text might not work in the simulator reliably.)
    func testSpeechToggle() throws {
        app.tabBars.buttons["Log"].tap()
        
        let micButton = app.buttons["Mic"]
        XCTAssertTrue(micButton.exists, "Mic button should exist.")
        
        // Tap to turn on speech recognition
        micButton.tap()
        // Possibly check if there's a label or icon that changes state
        // e.g., "Recording" label or a 'Stop' button
        // Adjust the line below to match your actual UI changes
        XCTAssertTrue(app.staticTexts["Recording"].exists, "Should show 'Recording' state.")
        
        // Tap to turn it off
        micButton.tap()
        // Check if state reverts
        XCTAssertFalse(app.staticTexts["Recording"].exists, "Recording label should disappear.")
    }
    
    /// Test typing text into the craving description field and verifying it.
    func testEnterCravingDescription() throws {
        app.tabBars.buttons["Log"].tap()
        
        let descriptionEditor = app.textViews["CravingDescriptionEditor"]
        if descriptionEditor.exists {
            descriptionEditor.tap()
            descriptionEditor.typeText("Testing chocolate craving")
            // Verify the typed text
            XCTAssertTrue(descriptionEditor.value as? String == "Testing chocolate craving",
                          "Typed text should match 'Testing chocolate craving'")
        } else {
            XCTFail("Craving description text view not found.")
        }
    }
    
    /// Test adjusting the "Intensity" and "Resistance" sliders.
    func testAdjustSliders() throws {
        app.tabBars.buttons["Log"].tap()
        
        // Suppose you have accessibility IDs "IntensitySlider" and "ResistanceSlider"
        let intensitySlider = app.sliders["IntensitySlider"]
        let resistanceSlider = app.sliders["ResistanceSlider"]
        
        // Ensure they exist
        XCTAssertTrue(intensitySlider.exists, "Intensity slider should be present.")
        XCTAssertTrue(resistanceSlider.exists, "Resistance slider should be present.")
        
        // Move the intensity slider to 8/10
        intensitySlider.adjust(toNormalizedSliderPosition: 0.7) // approximate
        // Move the resistance slider to 3/10
        resistanceSlider.adjust(toNormalizedSliderPosition: 0.2)
        
        // You could do more checks if your UI displays the numeric slider value
    }
    
    /// Test selecting multiple emotion chips and verifying selection.
    func testSelectEmotions() throws {
        app.tabBars.buttons["Log"].tap()
        
        // Example emotion chips: "Hungry", "Angry", "Lonely", "Tired", etc.
        let hungryChip = app.buttons["Hungry"]
        let lonelyChip = app.buttons["Lonely"]
        
        // Tap them
        hungryChip.tap()
        lonelyChip.tap()
        
        // If your chips visually change or have a selected state,
        // you could verify by checking isSelected or color changes
        // (in pure SwiftUI, you might rely on the label text still).
        // This example just ensures they exist:
        XCTAssertTrue(hungryChip.exists, "'Hungry' chip should exist and be selectable.")
        XCTAssertTrue(lonelyChip.exists, "'Lonely' chip should exist and be selectable.")
    }
    
    /// Test a successful craving log flow: fill in data, tap "Log Craving", confirm success alert.
    func testLogCravingSuccessFlow() throws {
        app.tabBars.buttons["Log"].tap()
        
        // Type something
        let descriptionEditor = app.textViews["CravingDescriptionEditor"]
        guard descriptionEditor.exists else {
            XCTFail("No description editor found.")
            return
        }
        descriptionEditor.tap()
        descriptionEditor.typeText("Really want a donut right now.")
        
        // Suppose we only require a non-empty description for "Log Craving" to enable
        let logButton = app.buttons["Log Craving"]
        XCTAssertTrue(logButton.isEnabled, "Log button should be enabled after typing description.")
        
        // Tap "Log Craving"
        logButton.tap()
        
        // Expect a success alert to appear
        let successAlert = app.alerts["Success"]
        XCTAssertTrue(successAlert.waitForExistence(timeout: 5),
                      "Success alert should appear after logging a craving.")
        
        // Dismiss alert
        successAlert.buttons["OK"].tap()
        
        // Possibly confirm the form is reset
        XCTAssertEqual((descriptionEditor.value as? String) ?? "", "",
                       "Description should be cleared after logging.")
    }
    
    /// Test an error scenario: tries to log with an empty description
    func testLogCravingEmptyDescriptionError() throws {
        app.tabBars.buttons["Log"].tap()
        
        let logButton = app.buttons["Log Craving"]
        // If your code disables the button, check that it's disabled:
        XCTAssertFalse(logButton.isEnabled,
                       "Log button should be disabled with no description input.")
        
        // Or if your code shows an error alert, tap the button and check alert
        // (Adjust depending on your actual validation flow.)
    }
}
