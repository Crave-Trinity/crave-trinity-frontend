//
//  ChatView.swift
//  CravePhone
//
//  Created by Developer on 3/1/2025.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            // Background
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Messages list
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
                    .onChange(of: viewModel.messages.count) { _ in
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
                
                // Input area
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
                            .onSubmit {
                                sendMessage()
                            }
                        
                        Button {
                            sendMessage()
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : CraveTheme.Colors.accent)
                        }
                        .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.3))
                }
            }
            
            // Loading overlay
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
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let text = messageText
        messageText = ""
        
        Task {
            await viewModel.sendMessage()
        }
    }
    
    // MARK: - Subviews
    
    struct MessageBubble: View {
        let message: ChatViewModel.Message
        
        var body: some View {
            HStack {
                if message.isUser {
                    Spacer()
                }
                
                VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                    Text(message.content)
                        .font(CraveTheme.Typography.body)
                        .foregroundColor(message.isUser ? Color.white : CraveTheme.Colors.primaryText)
                        .padding(12)
                        .background(
                            message.isUser ?
                            CraveTheme.Colors.accent.opacity(0.9) :
                                Color.black.opacity(0.6)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 16,
                                style: .continuous
                            )
                        )
                    
                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 11))
                        .foregroundColor(Color.gray)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal, 4)
                
                if !message.isUser {
                    Spacer()
                }
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
        @State private var showFirstDot = false
        @State private var showSecondDot = false
        @State private var showThirdDot = false
        
        var body: some View {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(CraveTheme.Colors.accent.opacity(0.7))
                        .frame(width: 8, height: 8)
                        .scaleEffect(dotScale(for: index))
                        .animation(
                            Animation
                                .easeInOut(duration: 0.4)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showSecondDot = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    showThirdDot = true
                }
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

// MARK: - Preview
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        // Using mock view model for preview
        let viewModel = ChatViewModel(aiChatUseCase: MockChatUseCase())
        ChatView(viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
    
    // Mock use case for preview
    class MockChatUseCase: AiChatUseCaseProtocol {
        func execute(userQuery: String) async throws -> String {
            return "This is a sample response to: \(userQuery)"
        }
    }
}
