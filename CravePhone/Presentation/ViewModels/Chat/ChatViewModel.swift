//
//  ChatViewModel.swift
//  CravePhone/Presentation/ViewModels/Chat
//
//  GOF/SOLID EXPLANATION:
//   - Mediator pattern: Orchestrates between View (UI) and UseCase (Domain).
//   - Single Responsibility: Maintains chat state & delegates business logic to AiChatUseCase.
//   - Open/Closed: We can add more properties without modifying the existing structure heavily.
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
    @Published public var userInput: String = ""   // <-- Key property for user’s typed text
    @Published public var isLoading: Bool = false
    @Published public var alertInfo: AlertInfo?  // see AlertInfo.swift
    
    // MARK: - Dependencies
    private let aiChatUseCase: AiChatUseCaseProtocol
    
    // MARK: - Init
    public init(aiChatUseCase: AiChatUseCaseProtocol) {
        self.aiChatUseCase = aiChatUseCase
    }
    
    // MARK: - Public Methods
    
    /// Sends user's current `userInput` to the AI, appends responses to `messages`.
    public func sendMessage() async {
        
        let query = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            // If the trimmed query is empty, show an alert:
            alertInfo = AlertInfo(
                title: "Empty Input",
                message: "Please type something before sending."
            )
            return
        }
        
        // Immediately append user’s message to the chat
        appendMessage(query, isUser: true)
        
        // Clear the user input so the field resets
        userInput = ""
        
        do {
            isLoading = true
            
            // Call the Use Case: Validate + fetch AI response
            let aiResponse = try await aiChatUseCase.execute(userQuery: query)
            
            // Append the AI's response
            appendMessage(aiResponse, isUser: false)
            
        } catch {
            print("Error in ChatViewModel.sendMessage(): \(error)")
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    /// Sends a one-time welcome message if not already shown.
    public func sendWelcomeMessage() {
        if !UserDefaults.standard.bool(forKey: "welcomeMessageSent") {
            
            Task {
                // Introduce a brief delay for a smoother user experience
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 sec
                messages.append(
                    Message(
                        content: """
                        Hi, welcome to 🦊 Cravey chat!

                        ⚠️ Important Disclaimer:
                        I’m just an LLM that turns text into math. I do NOT diagnose, treat,
                        or manage any condition. Please consult a healthcare professional for 
                        personal medical guidance.
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
        messages.append(
            Message(content: content, isUser: isUser)
        )
    }
}
