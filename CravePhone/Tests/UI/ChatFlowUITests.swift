//=================================================
// FILE: ChatFlowUITests.swift
// DIRECTORY: CravePhoneUITests
// PURPOSE: Tests the Chat tab flow (sending messages, AI response).
//
// UNCLE BOB / SOLID:
// - Each method tests a single scenario.
// - Clear, minimal code.
//
// GOF / STEVE JOBS:
// - Minimal friction for the user path (open Chat, type message, see response).
//=================================================

import XCTest

final class ChatFlowUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    /// Test that we can open chat and see a welcome message.
    func testOpenChat() throws {
        app.tabBars.buttons["Chat"].tap()
        
        // If your chat view displays a "Thinking..." spinner or a default "Hello" message:
        let welcomeMessage = app.staticTexts["Welcome! How can I help?"] // example placeholder
        XCTAssertTrue(welcomeMessage.waitForExistence(timeout: 5),
                      "Welcome message or initial AI message should appear in Chat.")
    }
    
    /// Test sending a user message and receiving an AI response.
    func testSendMessageAndReceiveAIResponse() throws {
        app.tabBars.buttons["Chat"].tap()
        
        let inputField = app.textFields["Type a message..."]
        XCTAssertTrue(inputField.exists, "Chat input text field must exist.")
        
        inputField.tap()
        inputField.typeText("Hello AI!")
        
        // Tap send button
        let sendButton = app.buttons["arrow.up.circle.fill"]
        XCTAssertTrue(sendButton.exists, "Send button must exist in chat input bar.")
        
        sendButton.tap()
        
        // AI response may take time; let's see if a message bubble with AI content appears
        let aiResponse = app.staticTexts["This is a sample AI response"]
        XCTAssertTrue(aiResponse.waitForExistence(timeout: 5),
                      "AI response bubble should appear after a short delay.")
    }
}
