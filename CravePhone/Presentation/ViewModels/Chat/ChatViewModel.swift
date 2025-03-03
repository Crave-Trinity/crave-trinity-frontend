//
//  ChatViewModel.swift
//  CravePhone/Presentation/ViewModels/Chat
//
//  GOF/SOLID NOTES:
//   - Single Responsibility: Maintains chat messages & orchestrates calls to AiChatUseCase.
//   - Open/Closed: We can adjust disclaimers or text w/o rewriting the entire logic.
//   - Liskov Substitution: This ViewModel could be replaced by a test double in unit tests.
//

import SwiftUI
import Combine
import Security // Import the Security framework for Keychain access

@MainActor
public final class ChatViewModel: ObservableObject {

    // MARK: - Nested Type: Chat Message
    public struct Message: Identifiable {
        public let id = UUID()
        public let content: String
        public let isUser: Bool
        public let timestamp: Date = Date()
    }

    // MARK: - Published Properties
    @Published public var messages: [Message] = []
    @Published public var userInput: String = ""
    @Published public var isLoading: Bool = false
    @Published public var alertInfo: AlertInfo? // For displaying errors (e.g., "Empty Input")

    // MARK: - Dependencies
    private let aiChatUseCase: AiChatUseCaseProtocol

    // MARK: - Authentication Properties (NEW)
    private var authToken: String?
    private let keychainService = "com.yourcompany.CraveTrinity" // Replace with a unique identifier!  VERY IMPORTANT
    private let keychainAccount = "userAuthToken"


    // MARK: - Initialization
    public init(aiChatUseCase: AiChatUseCaseProtocol) {
        self.aiChatUseCase = aiChatUseCase
        loadAuthToken() // Load the token when the ViewModel is created
    }

    // MARK: - Authentication Methods (NEW)

    // Function to load the token from the Keychain
    func loadAuthToken() {
        guard let tokenData = KeychainHelper.load(service: keychainService, account: keychainAccount),
              let token = String(data: tokenData, encoding: .utf8) else {
            // Handle the case where the token isn't found (e.g., user not logged in)
            self.alertInfo = AlertInfo(title: "Authentication", message: "Authentication token not found.")
            print("Authentication token not found")
            return
        }
        self.authToken = token
        print("Token loaded successfully: \(token)") // Keep this for debugging
    }

    // Function to save the token to the Keychain
    func saveAuthToken(token: String) {
        guard let tokenData = token.data(using: .utf8) else {
            print("Error encoding token to data")
            return
        }
        KeychainHelper.save(data: tokenData, service: keychainService, account: keychainAccount)
        self.authToken = token
        print("Token saved successfully") // Add logging
    }

    // Function to clear the token (on logout or 401 error)
    func clearAuthToken() {
        KeychainHelper.delete(service: keychainService, account: keychainAccount)
        self.authToken = nil
        print("Token cleared") // Add logging
    }


    // MARK: - Public Methods
    func getTestToken() {
        Task {
            do {
                let token = try await aiChatUseCase.getTestToken() // Get token via UseCase
                print("Received token: \(token)") //VERY IMPORTANT FOR DEBUGGING
                saveAuthToken(token: token) // Save to keychain
                self.alertInfo = AlertInfo(title: "Success", message: "Test token retrieved!") // Inform the user
            } catch {
                print("Error getting test token: \(error)")
                DispatchQueue.main.async {
                    self.alertInfo = AlertInfo(title: "Error", message: "Failed to get test token: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Sends user's current `userInput` to the AI, appends responses to `messages`.
    public func sendMessage() async {

        // 1) Trim input
        let query = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            // Show an alert if user tries to send an empty string
            alertInfo = AlertInfo(
                title: "Empty Input",
                message: "Please type something before sending."
            )
            return
        }

        // 2) Immediately append user’s message to the chat
        appendMessage(query, isUser: true)

        // 3) Clear the userInput so the TextField resets
        userInput = ""

          // 4) Check for auth token.  MUST be done AFTER processing user input.
        guard let token = authToken else {
            DispatchQueue.main.async {
                self.alertInfo = AlertInfo(title: "Authentication", message: "Not authenticated. Please log in.") // Or show a login screen
            }
            print("No auth token, cannot send message")
            return
        }
        print("Current auth token: \(token)") // VERY IMPORTANT - Keep this for debugging


        do {
            // 5) Indicate loading
            isLoading = true

            // 6) Ask the AiChatUseCase for a response, passing the token
            let aiResponse = try await aiChatUseCase.execute(userQuery: query, authToken: token) // PASS THE TOKEN

            // 7) Append the AI's response
            appendMessage(aiResponse, isUser: false)

        } catch {
            // 8) Handle any thrown errors, including 401s
            print("Error in ChatViewModel.sendMessage(): \(error)")
            if let apiError = error as? APIError, apiError == .unauthorized { // Check for our custom error
                 DispatchQueue.main.async {
                    self.clearAuthToken() // Clear the invalid token
                    self.alertInfo = AlertInfo(title: "Authentication", message: "Your session has expired. Please log in again.") // Show user-friendly message
                }
            } else {
              self.alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
            }

        }

        // 9) End loading
        isLoading = false
    }

    /// Displays a one-time welcome message with disclaimers & cravings context.
    public func sendWelcomeMessage() {

        if !UserDefaults.standard.bool(forKey: "welcomeMessageSent") {
            Task {
                // A brief delay for a smoother user experience
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s

                messages.append(
                    Message(
                        content: """
                        Hi, Welcome to 🦊 Cravey Chat!

                        ⚠️ Disclaimer:
                        I’m an AI-powered craving analyzer. I cannot diagnose or provide medical treatment. Please consult a healthcare professional for such questions.

                        How can I help process your cravings today?
                        """, // Corrected multiline string
                        isUser: false
                    )
                )

                // Mark that we've shown the welcome message once
                UserDefaults.standard.set(true, forKey: "welcomeMessageSent")
            }
        }
    }

    // MARK: - Private Helpers

    /// Safely appends a new message to the chat log
    private func appendMessage(_ content: String, isUser: Bool) {
        messages.append(
            Message(content: content, isUser: isUser)
        )
    }
}
