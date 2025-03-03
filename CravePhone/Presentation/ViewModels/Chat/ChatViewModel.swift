//  ChatViewModel.swift
//  CravePhone/Presentation/ViewModels/Chat
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

    // MARK: - Authentication Properties
    private var authToken: String?
    private let keychainService = "com.yourcompany.CraveTrinity" // Replace with a unique identifier!  VERY IMPORTANT
    private let keychainAccount = "userAuthToken"


    // MARK: - Initialization
    public init(aiChatUseCase: AiChatUseCaseProtocol) {
        self.aiChatUseCase = aiChatUseCase
        // DO NOT loadAuthToken() here. Load it after getting the token.
    }

    // MARK: - Authentication Methods

    // Function to load the token from the Keychain
    func loadAuthToken() {
        guard let tokenData = KeychainHelper.load(service: keychainService, account: keychainAccount),
              let token = String(data: tokenData, encoding: .utf8) else {
            // Handle the case where the token isn't found
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
        print("Token saved successfully") // Add logging
    }

    // Function to clear the token (on logout or 401 error)
    func clearAuthToken() {
        KeychainHelper.delete(service: keychainService, account: keychainAccount)
        self.authToken = nil
        print("Token cleared") // Add logging
    }


    // MARK: - Public Methods
    public func getTestToken() {
        Task {
            do {
                let token = try await aiChatUseCase.getTestToken()
                print("Received token: \(token)")
                saveAuthToken(token: token) // Save to keychain
                loadAuthToken() // *** LOAD THE TOKEN IMMEDIATELY AFTER SAVING ***
                self.alertInfo = AlertInfo(title: "Success", message: "Test token retrieved!")
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
        let query = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            alertInfo = AlertInfo(title: "Empty Input", message: "Please type something before sending.")
            return
        }

        appendMessage(query, isUser: true)
        userInput = ""

        guard let token = authToken else {
            DispatchQueue.main.async {
                self.alertInfo = AlertInfo(title: "Authentication", message: "Not authenticated. Please log in.")
            }
            print("No auth token, cannot send message")
            return
        }
        print("Current auth token: \(token)")

        do {
            isLoading = true
            let aiResponse = try await aiChatUseCase.execute(userQuery: query, authToken: token)
            appendMessage(aiResponse, isUser: false)
        } catch {
            print("Error in ChatViewModel.sendMessage(): \(error)")
            if let apiError = error as? APIError, apiError == .unauthorized {
                 DispatchQueue.main.async {
                    self.clearAuthToken()
                    self.alertInfo = AlertInfo(title: "Authentication", message: "Your session has expired. Please log in again.")
                }
            } else {
              self.alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
            }
        }
        isLoading = false
    }

    /// Displays a one-time welcome message.
    public func sendWelcomeMessage() {
        if !UserDefaults.standard.bool(forKey: "welcomeMessageSent") {
            Task {
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
                messages.append(
                    Message(
                        content: """
                        Hi, Welcome to 🦊 Cravey Chat!

                        ⚠️ Disclaimer:
                        I’m an AI-powered craving analyzer. I cannot diagnose or provide medical treatment. Please consult a healthcare professional for such questions.

                        How can I help process your cravings today?
                        """,
                        isUser: false
                    )
                )
                UserDefaults.standard.set(true, forKey: "welcomeMessageSent")
            }
        }
    }

    // MARK: - Private Helpers
    private func appendMessage(_ content: String, isUser: Bool) {
        messages.append(Message(content: content, isUser: isUser))
    }
}
