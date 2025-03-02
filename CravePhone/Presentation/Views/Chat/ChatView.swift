//=================================================================
// 7) ChatView.swift
//   CravePhone/Presentation/Views/Chat
//=================================================================
import SwiftUI

struct ChatView: View {
    // MARK: - Properties

    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText: String = ""
    @FocusState private var isInputFocused: Bool

    // MARK: - Initializer

    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background color for the full safe area.
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Scrollable list of messages:
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)  // Unique ID for programmatic scrolling.
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    }
                    // Corrected onChange:  Use a boolean for 'initial'.
                    .onChange(of: viewModel.messages.count, initial: !viewModel.messages.isEmpty) { oldCount, newCount in  //Correct Parameter Order
                        // Only scroll if we have one or more messages AND it's a *new* message.
                        if newCount > oldCount, let last = viewModel.messages.last { //Key Change: Check for new messages
                            withAnimation {
                                scrollProxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // MARK: - Input Bar

                VStack(spacing: 0) {
                    Divider()
                        .background(Color.gray.opacity(0.3))

                    HStack(spacing: 12) {
                        // Text input field:
                        TextField("Type a message...", text: $messageText)
                            .padding(12)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                            .focused($isInputFocused)
                            // The new .submitLabel sets the return key style:
                            .submitLabel(.send)
                            // Triggers sendMessage() if the user taps "Send" on the keyboard:
                            .onSubmit { sendMessage() }

                        // Send button:
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(
                                    messageText.trimmingCharacters(in: .whitespaces).isEmpty
                                    ? .gray
                                    : .blue
                                )
                        }
                        // Disable if there's no text or we're still loading a previous request:
                        .disabled(
                            messageText.trimmingCharacters(in: .whitespaces).isEmpty ||
                            viewModel.isLoading
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.3))
                }
            }

            // If the ViewModel is in a loading state, show an overlay with a spinner:
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        // Show any alerts from the ViewModel:
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
        // Automatically send a welcome message when the view appears:
        .onAppear {
            viewModel.sendWelcomeMessage()
        }
    }

    // MARK: - Methods

    /// Sends the trimmed user message via the ViewModel, then clears `messageText`.
    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messageText = ""

        // Perform the send asynchronously to avoid blocking the main UI thread.
        Task {
            await viewModel.sendMessage()
        }
    }

    // MARK: - Subviews

    /// Displays a single message bubble with content and timestamp.
    /// Aligns user messages to the trailing edge for a chat-like experience.
    struct MessageBubble: View {
        let message: ChatViewModel.Message

        var body: some View {
            HStack {
                if message.isUser {
                    Spacer()
                }
                VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                    Text(message.content)
                        .padding(12)
                        .background(
                            message.isUser
                            ? Color.blue.opacity(0.9)
                            : Color.gray.opacity(0.4)
                        )
                        .cornerRadius(16)

                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                if !message.isUser {
                    Spacer()
                }
            }
            .padding(.horizontal, 4)
        }
    }

    /// Displays a translucent overlay with a progress indicator, used while waiting for async tasks.
    struct LoadingOverlay: View {
        var body: some View {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView("Thinking...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(20)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
