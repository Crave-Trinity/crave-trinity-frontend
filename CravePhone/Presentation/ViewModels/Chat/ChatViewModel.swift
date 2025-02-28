//
//  ChatViewModel.swift
//  CravePhone
//
//  Description:
//    MVVM ViewModel that calls AiChatUseCase to get RAG/AI responses.
//    Holds a conversation array to display a chat-like UI.
//
import SwiftUI
import Combine

@MainActor
public final class ChatViewModel: ObservableObject {
    
    // Minimal message model
    public struct Message: Identifiable {
        public let id = UUID()
        public let content: String
        public let isUser: Bool
    }
    
    @Published public var messages: [Message] = []
    @Published public var userInput: String = ""
    @Published public var isLoading: Bool = false
    @Published public var alertInfo: AlertInfo?
    
    private let aiChatUseCase: AiChatUseCaseProtocol
    
    public init(aiChatUseCase: AiChatUseCaseProtocol) {
        self.aiChatUseCase = aiChatUseCase
    }
    
    public func sendMessage() async {
        let query = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            alertInfo = AlertInfo(title: "Oops", message: "Please type something first.")
            return
        }
        
        // Append user message to the chat
        let userMessage = Message(content: query, isUser: true)
        messages.append(userMessage)
        userInput = "" // clear
        
        // Call the AI
        do {
            isLoading = true
            let response = try await aiChatUseCase.execute(userQuery: query)
            let botMessage = Message(content: response, isUser: false)
            messages.append(botMessage)
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }
}
