//=================================================================
// ChatViewModel.swift
// CravePhone/Presentation/ViewModels/Chat/ChatViewModel.swift
//=================================================================
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
    @Published public var alertInfo: AlertInfo?  // Shared from Common/AlertInfo.swift

    // MARK: - Dependency
    private let aiChatUseCase: AiChatUseCaseProtocol

    // MARK: - Initialization
    public init(aiChatUseCase: AiChatUseCaseProtocol) {
        self.aiChatUseCase = aiChatUseCase
    }

    // MARK: - Public Methods
    public func sendMessage() async {
        let query = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            alertInfo = AlertInfo(title: "Empty Input", message: "Please type something before sending.")
            return
        }

        // Append user's message
        appendMessage(query, isUser: true)
        userInput = ""

        do {
            isLoading = true
            // Get AI response
            let aiResponse = try await aiChatUseCase.execute(userQuery: query)
            appendMessage(aiResponse, isUser: false)
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }

    public func sendWelcomeMessage() {
        messages.append(
            Message(content: "Welcome to CRAVE. How can I help you manage your cravings today?", isUser: false)
        )
    }

    // MARK: - Private Helpers
    private func appendMessage(_ content: String, isUser: Bool) {
        messages.append(Message(content: content, isUser: isUser))
    }
}

// Note: Any duplicate AlertInfo definitions have been removed—this file now uses the one from Common/AlertInfo.swift.
