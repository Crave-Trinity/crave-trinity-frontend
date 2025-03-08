// DIRECTORY/FILENAME: CravePhone/Presentation/Views/Chat/ChatViewModel.swift
// PASTE & RUN (Removed "Get Test Token" button; minimal changes)

import Foundation
import SwiftUI

/// Simple MVVM ViewModel for ChatView.
/// Single Responsibility: Manage chat messages and user input.
@MainActor
final class ChatViewModel: ObservableObject {
    
    private let aiChatUseCase: AiChatUseCaseProtocol
    
    @Published private(set) var messages: [String] = []
    @Published var userInput: String = ""
    
    init(aiChatUseCase: AiChatUseCaseProtocol) {
        self.aiChatUseCase = aiChatUseCase
    }
    
    /// Sends user input to the AI chat and appends the response to `messages`.
    func sendMessage() async {
        guard !userInput.isEmpty else { return }
        
        let inputText = userInput
        messages.append("You: \(inputText)")
        
        do {
            let response = try await aiChatUseCase.sendMessage(inputText)
            messages.append("AI: \(response)")
        } catch {
            messages.append("AI: (Error sending message: \(error.localizedDescription))")
        }
        
        userInput = ""
    }
}

// NOTE: No #Preview or duplicates in this file to avoid "Invalid redeclaration of 'preview'".
