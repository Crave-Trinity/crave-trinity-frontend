//=================================================================
// 5) ChatViewModel.swift
//   CravePhone/Presentation/ViewModels/Chat/ChatViewModel.swift
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

        // Append user's message *before* making the API call
        appendMessage(query, isUser: true)
        userInput = "" // Clear the input field immediately

        do {
            isLoading = true
            let aiResponse = try await aiChatUseCase.execute(userQuery: query)
            appendMessage(aiResponse, isUser: false) // Append AI response
        } catch {
            print("Error in ChatViewModel: \(error)") // Log the error
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }

    public func sendWelcomeMessage() {
        // Check if welcome message has already been sent (e.g., using UserDefaults)
        if !UserDefaults.standard.bool(forKey: "welcomeMessageSent") {
            // Introduce a slight delay using Task
            Task {
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                messages.append(
                    Message(content: "Welcome to CRAVE. How can I help you manage your cravings today?", isUser: false)
                )
                UserDefaults.standard.set(true, forKey: "welcomeMessageSent") // Set the flag
            }
        }
    }

    // MARK: - Private Helpers
    private func appendMessage(_ content: String, isUser: Bool) {
        messages.append(Message(content: content, isUser: isUser))
    }
}
