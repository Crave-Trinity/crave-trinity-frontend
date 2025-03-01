//
//  ChatView.swift
//  CravePhone
//
//  Single Responsibility:
//   - Provide a chat UI with message bubbles, a send field, and optional loading overlay.
//

import SwiftUI

struct ChatView: View {
    // The view model driving the chat UI
    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText: String = ""
    @FocusState private var isInputFocused: Bool

    // Explicit initializer to avoid ambiguity in the synthesized initializer
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // Background using the app's primary gradient
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Messages list with auto scrolling
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    }
                    // Renamed to .onChangeBackport if you rely on passing old/new values
                    .onChangeBackport(of: viewModel.messages.count, initial: false) { _, _ in
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                scrollProxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .onAppear {
                        if viewModel.messages.isEmpty {
                            viewModel.sendWelcomeMessage()
                        }
                    }
                }
                
                // Input area for typing messages
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    HStack(spacing: 12) {
                        TextField("Type a message...", text: $messageText)
                            .padding(12)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(20)
                            .focused($isInputFocused)
                            .submitLabel(.send)
                            .onSubmit { sendMessage() }
                        
                        Button {
                            sendMessage()
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(
                                    messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                    ? .gray
                                    : CraveTheme.Colors.accent
                                )
                        }
                        .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.3))
                }
            }
            
            // Loading overlay if messages are being processed
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    /// Sends the current message if it is non-empty
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        messageText = ""
        Task { await viewModel.sendMessage() }
    }
    
    // MARK: - Subviews
    
    struct MessageBubble: View {
        let message: ChatViewModel.Message
        
        var body: some View {
            HStack {
                if message.isUser { Spacer() }
                
                VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                    Text(message.content)
                        .font(CraveTheme.Typography.body)
                        .foregroundColor(message.isUser ? .white : CraveTheme.Colors.primaryText)
                        .padding(12)
                        .background(
                            message.isUser ?
                                CraveTheme.Colors.accent.opacity(0.9) :
                                Color.black.opacity(0.6)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    
                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal, 4)
                
                if !message.isUser { Spacer() }
            }
        }
    }
    
    struct LoadingOverlay: View {
        var body: some View {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    TypingIndicator()
                        .padding(.bottom, 80)
                        .padding(.horizontal, 30)
                }
            }
        }
    }
    
    struct TypingIndicator: View {
        @State private var showFirstDot: Bool = false
        @State private var showSecondDot: Bool = false
        @State private var showThirdDot: Bool = false
        
        var body: some View {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(CraveTheme.Colors.accent.opacity(0.7))
                        .frame(width: 8, height: 8)
                        .scaleEffect(dotScale(for: index))
                        .animation(
                            Animation.easeInOut(duration: 0.4)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                            value: dotScale(for: index)
                        )
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.6))
            )
            .onAppear {
                showFirstDot = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { showSecondDot = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { showThirdDot = true }
            }
        }
        
        private func dotScale(for index: Int) -> CGFloat {
            switch index {
            case 0: return showFirstDot ? 1.5 : 1.0
            case 1: return showSecondDot ? 1.5 : 1.0
            case 2: return showThirdDot ? 1.5 : 1.0
            default: return 1.0
            }
        }
    }
}
