//
//  ChatViewModel.swift
//  CravePhone
//
//  Description:
//     The MVVM ViewModel for the AI chat UI.
//     Uses a shared "AlertInfo" struct from AlertInfo.swift.
//
//  NOTE: We no longer define AlertInfo here.
//
import SwiftUI
import Combine

@MainActor
public final class ChatViewModel: ObservableObject {
    
    // MARK: - Nested Types
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
    
    // Use the master AlertInfo from AlertInfo.swift
    @Published public var alertInfo: AlertInfo?
    
    private let aiChatUseCase: AiChatUseCaseProtocol
    
    // MARK: - Init
    public init(aiChatUseCase: AiChatUseCaseProtocol) {
        self.aiChatUseCase = aiChatUseCase
    }
    
    // MARK: - Public Methods
    public func sendMessage() async {
        let query = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            alertInfo = AlertInfo(title: "Empty Input",
                                  message: "Please type something before sending.")
            return
        }
        
        // 1) Add the user's message to local chat
        appendMessage(query, isUser: true)
        
        // 2) Clear the user input field
        userInput = ""
        
        do {
            // 3) Show a loading spinner
            isLoading = true
            
            // 4) Call the use case (which calls the repository / API client)
            let aiResponse = try await aiChatUseCase.execute(userQuery: query)
            
            // 5) Append the bot's response to the chat
            appendMessage(aiResponse, isUser: false)
            
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        
        // 6) Done loading
        isLoading = false
    }
    
    // MARK: - Private Helpers
    private func appendMessage(_ content: String, isUser: Bool) {
        let newMessage = Message(content: content, isUser: isUser)
        messages.append(newMessage)
    }
}

extension ChatViewModel {
    func sendWelcomeMessage() {
        let message = Message(
            content: "Welcome to CRAVE. How can I help you manage your cravings today?",
            isUser: false
        )
        messages.append(message)
    }
}
