//
//  ChatViewModel.swift
//  CravePhone/Presentation/ViewModels/Chat
//
//  PURPOSE:
//   - Orchestrates retrieving & storing the token, sending user messages, and storing chat history.

import SwiftUI
import Combine

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
    @Published public var alertInfo: AlertInfo?
    
    // MARK: - Dependencies
    private let aiChatUseCase: AiChatUseCaseProtocol
    
    // MARK: - Keychain Info
    private let keychainService = "com.yourcompany.CraveTrinity"
    private let keychainAccount = "userAuthToken"
    private var authToken: String?
    
    public init(aiChatUseCase: AiChatUseCaseProtocol) {
        self.aiChatUseCase = aiChatUseCase
    }
    
    // MARK: - Load/Save/Clear
    func loadAuthToken() {
        guard
            let data = KeychainHelper.load(service: keychainService, account: keychainAccount),
            let token = String(data: data, encoding: .utf8)
        else {
            print("Token not found in Keychain")
            return
        }
        authToken = token
        print("Token loaded from Keychain: \(token)")
    }
    
    func saveAuthToken(token: String) {
        guard let data = token.data(using: .utf8) else { return }
        KeychainHelper.save(data: data, service: keychainService, account: keychainAccount)
        authToken = token
        print("Token saved to Keychain")
    }
    
    func clearAuthToken() {
        KeychainHelper.delete(service: keychainService, account: keychainAccount)
        authToken = nil
        print("Token cleared from Keychain")
    }
    
    // MARK: - Public Methods
    
    /// 1) Calls the backend to get a test JWT, 2) saves it in Keychain
    public func getTestToken() {
        Task {
            do {
                let newToken = try await aiChatUseCase.getTestToken()
                saveAuthToken(token: newToken)
                alertInfo = AlertInfo(title: "Success", message: "Test token retrieved.")
            } catch {
                print("Error retrieving test token: \(error)")
                alertInfo = AlertInfo(title: "Error", message: "Failed to get test token: \(error.localizedDescription)")
            }
        }
    }
    
    /// Send the user's typed query as a chat message
    public func sendMessage() async {
        // 1) Basic guard
        let query = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            alertInfo = AlertInfo(title: "Empty Input", message: "Please type something before sending.")
            return
        }
        
        // 2) Append user message locally
        appendMessage(query, isUser: true)
        userInput = ""
        
        // 3) Must have a token
        guard let token = authToken else {
            alertInfo = AlertInfo(title: "Authentication", message: "No token. Tap 'Get Test Token' first.")
            return
        }
        
        // 4) Actually call the AI
        isLoading = true
        do {
            let aiResponse = try await aiChatUseCase.execute(userQuery: query, authToken: token)
            appendMessage(aiResponse, isUser: false)
        } catch {
            print("Error in ChatViewModel.sendMessage(): \(error)")
            // If 401 or expired, clear token
            if let apiError = error as? APIError, apiError == .unauthorized {
                clearAuthToken()
                alertInfo = AlertInfo(
                    title: "Session Expired",
                    message: "Please re-fetch a token (401)."
                )
            } else {
                alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
            }
        }
        isLoading = false
    }
    
    /// Show a one-time welcome message
    public func sendWelcomeMessage() {
        if !UserDefaults.standard.bool(forKey: "welcomeMessageSent") {
            Task {
                try? await Task.sleep(nanoseconds: 200_000_000)
                messages.append(
                    Message(content: """
                        Hi, welcome to Crave Chat!
                        (Disclaimer: I'm an AI craving analyst, not a doc.)
                        """,
                            isUser: false
                    )
                )
                UserDefaults.standard.set(true, forKey: "welcomeMessageSent")
            }
        }
    }
    
    // MARK: - Helpers
    private func appendMessage(_ content: String, isUser: Bool) {
        messages.append(Message(content: content, isUser: isUser))
    }
}
