//=================================================
// FILE: AnalyticsFlowUITests.swift
// DIRECTORY: CravePhoneUITests
// PURPOSE: Tests the Analytics Dashboard tab flow.
//
// UNCLE BOB / SOLID:
// - Single Responsibility: Each test checks a main interaction
//   (e.g., switching time frames, tabs).
//
// GOF / STEVE JOBS:
// - Simple, direct user journeys.
//=================================================

import XCTest

final class AnalyticsFlowUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    /// Test navigating to Analytics tab and verifying the default content.
    func testNavigateToAnalytics() throws {
        app.tabBars.buttons["Analytics"].tap()
        
        // Check that we see a heading or text "Analytics" or "Find patterns and gain insights"
        XCTAssertTrue(app.staticTexts["📊 Analytics"].exists,
                      "Should see the analytics header.")
    }
    
    /// Test changing the time frame from "1 Week" to "1 Month" or others.
    func testSwitchTimeFrames() throws {
        app.tabBars.buttons["Analytics"].tap()
        
        let menuButton = app.buttons.containing(.staticText, identifier: "1 Week").element
        XCTAssertTrue(menuButton.exists, "Timeframe menu (initially '1 Week') should exist.")
        
        menuButton.tap()
        app.buttons["1 Month"].tap()
        
        // Check if something changes in the UI to reflect the new timeframe
        // (In real usage, you might see a chart or label update.)
        // We'll just ensure the button now says "1 Month"
        XCTAssertTrue(app.buttons.containing(.staticText, identifier: "1 Month").element.exists,
                      "Timeframe should now be '1 Month'.")
    }
    
    /// Test tab switching within analytics: "Overview", "Trends", "Triggers", "Insights".
    func testAnalyticsTabs() throws {
        app.tabBars.buttons["Analytics"].tap()
        
        let trendsTab = app.buttons["Trends"]
        let triggersTab = app.buttons["Triggers"]
        let insightsTab = app.buttons["Insights"]
        
        trendsTab.tap()
        XCTAssertTrue(app.staticTexts["Trends Tab Content"].exists,
                      "Trends content should be visible.")
        
        triggersTab.tap()
        XCTAssertTrue(app.staticTexts["Triggers Tab Content"].exists,
                      "Triggers content should be visible.")
        
        insightsTab.tap()
        XCTAssertTrue(app.staticTexts["Insights Tab Content"].exists,
                      "Insights content should be visible.")
    }
}
