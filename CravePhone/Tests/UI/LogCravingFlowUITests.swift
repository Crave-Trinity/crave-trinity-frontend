//
//  LogCravingFlowUITests.swift
//  CravePhoneUITests
//
//  Directory: CravePhoneUITests/UI/
//  PURPOSE: Tests the end-to-end "Log Craving" flow, including keyboard behavior,
//           character limits, submission, and UI component presence.
//  Follows SOLID principles by focusing each test on a single user interaction.
//

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

    /// Test that tapping the "Done" button dismisses the keyboard.
    func testKeyboardDismissalWithDoneButton() throws {
        app.tabBars.buttons["Log"].tap()

        let textEditor = app.textViews["CravingDescriptionEditor"]
        XCTAssertTrue(textEditor.exists, "CraveTextEditor should be visible.")

        textEditor.tap()
        textEditor.typeText("Test craving entry.")

        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.exists, "Done button should appear above the keyboard.")

        doneButton.tap()

        XCTAssertFalse(app.keyboards.element.exists, "Keyboard should be dismissed after tapping Done.")
    }

    /// Test that tapping on the background dismisses the keyboard.
    func testKeyboardDismissalWithBackgroundTap() throws {
        app.tabBars.buttons["Log"].tap()

        let textEditor = app.textViews["CravingDescriptionEditor"]
        XCTAssertTrue(textEditor.exists, "CraveTextEditor should be visible.")

        textEditor.tap()
        textEditor.typeText("Testing keyboard dismissal.")

        // Tap outside the text editor (on the background).
        app.otherElements.firstMatch.tap()

        XCTAssertFalse(app.keyboards.element.exists, "Keyboard should be dismissed when tapping the background.")
    }

    /// Test that the character limit of 300 characters is enforced.
    func testCravingDescriptionCharacterLimit() throws {
        app.tabBars.buttons["Log"].tap()

        let textEditor = app.textViews["CravingDescriptionEditor"]
        XCTAssertTrue(textEditor.exists, "CraveTextEditor should be visible.")

        textEditor.tap()

        // Generate a string longer than 300 characters.
        let longText = String(repeating: "A", count: 305)
        textEditor.typeText(longText)

        // Verify that the text editor only contains 300 characters.
        let textValue = textEditor.value as? String ?? ""
        XCTAssertEqual(textValue.count, 300, "Craving description should be limited to 300 characters.")
    }

    /// Test a successful log craving flow, including form reset and alert presentation.
    func testLogCravingSuccessFlow() throws {
        app.tabBars.buttons["Log"].tap()

        let textEditor = app.textViews["CravingDescriptionEditor"]
        XCTAssertTrue(textEditor.exists, "CraveTextEditor should be visible.")

        textEditor.tap()
        textEditor.typeText("Really craving a burger right now.")

        let logButton = app.buttons["Log Craving"]
        XCTAssertTrue(logButton.isEnabled, "Log button should be enabled after entering a description.")

        logButton.tap()

        // Expect a success alert to appear.
        let successAlert = app.alerts["Success"]
        XCTAssertTrue(successAlert.waitForExistence(timeout: 5), "Success alert should appear after logging a craving.")

        // Dismiss the alert.
        successAlert.buttons["OK"].tap()

        // Verify that the text editor has been reset.
        let textValue = textEditor.value as? String ?? ""
        XCTAssertEqual(textValue, "", "Craving description should be cleared after submission.")
    }
}
