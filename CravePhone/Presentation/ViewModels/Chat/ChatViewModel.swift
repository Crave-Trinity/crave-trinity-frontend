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
    
    // MARK: - Initialization
    public init(aiChatUseCase: AiChatUseCaseProtocol) {
        self.aiChatUseCase = aiChatUseCase
    }
    
    // MARK: - Public Methods
    
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
        
        do {
            // 4) Indicate loading
            isLoading = true
            
            // 5) Ask the AiChatUseCase for a response
            let aiResponse = try await aiChatUseCase.execute(userQuery: query)
            
            // 6) Append the AI's response
            appendMessage(aiResponse, isUser: false)
            
        } catch {
            // 7) Handle any thrown errors
            print("Error in ChatViewModel.sendMessage(): \(error)")
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        
        // 8) End loading
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
                        Hi, welcome to 🦊 Cravey chat!

                        ⚠️ Important Disclaimer:
                        I’m just an LLM that turns text into math. 
                        I do NOT diagnose, treat, or manage. Please consult a healthcare professional 
                        for any personal medical questions or concerns.

                        However, I can still chat about cravings in a general sense. 
                        How can I help you think about cravings today?
                        """,
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
