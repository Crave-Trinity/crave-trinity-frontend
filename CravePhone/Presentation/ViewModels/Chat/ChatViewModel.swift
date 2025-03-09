//CravePhone/Presentation/Views/Chat/ChatViewModel.swift

import Foundation
import SwiftUI

/// Simple MVVM ViewModel for ChatView.
/// Single Responsibility: Manage chat messages, user input, and handle calls to AiChatUseCase.
@MainActor
final class ChatViewModel: ObservableObject {
    
    private let aiChatUseCase: AiChatUseCaseProtocol
    
    @Published var messages: [String] = []
    @Published var userInput: String = ""
    @Published var isLoading: Bool = false
    
    init(aiChatUseCase: AiChatUseCaseProtocol) {
        self.aiChatUseCase = aiChatUseCase
    }
    
    /// Sends user input to the AI chat and appends the response to `messages`.
    func sendMessage() async {
        guard !userInput.isEmpty else { return }
        
        let inputText = userInput
        messages.append("You: \(inputText)")
        userInput = ""
        
        isLoading = true
        do {
            let response = try await aiChatUseCase.sendMessage(inputText)
            messages.append("AI: \(response)")
        } catch {
            messages.append("AI: (Error: \(error.localizedDescription))")
        }
        isLoading = false
    }
}
