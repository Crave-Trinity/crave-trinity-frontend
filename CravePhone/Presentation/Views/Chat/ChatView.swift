// ---------------------------------------------------
// FILE: ChatView.swift
// DESCRIPTION: Chat UI with iOS17-friendly onChange using the new two-parameter closure.
// ---------------------------------------------------

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText: String = ""
    @FocusState private var isInputFocused: Bool

    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // Full-screen gradient background
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Main scrollable chat area
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    #if swift(>=5.9)
                    // New API: Use two-parameter closure with initial: false
                    // FIXED: Parameter order corrected to match API (oldValue, newValue)
                    .onChange(of: viewModel.messages.count, initial: false) { oldValue, newValue in
                        if let last = viewModel.messages.last {
                            withAnimation {
                                scrollProxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    #else
                    // Fallback for iOS <17: Use old API which takes one parameter
                    .onChange(of: viewModel.messages.count) { _ in
                        if let last = viewModel.messages.last {
                            withAnimation {
                                scrollProxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    #endif
                }
                
                // Input bar at bottom
                VStack(spacing: 0) {
                    Divider().background(Color.gray.opacity(0.3))
                    
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
                                    messageText.trimmingCharacters(in: .whitespaces).isEmpty
                                    ? .gray
                                    : CraveTheme.Colors.accent
                                )
                        }
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
            
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        // Allow keyboard to push the view up while keeping full vertical usage
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Send Message Function
    
    /// Sends the current message text if it's not empty
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        // First clear the text field
        let textToSend = messageText
        messageText = ""
        
        // Then call the appropriate send method based on your view model implementation
        Task {
            // Option 1: If your model has a property to set before sending
            // viewModel.messageToSend = textToSend
            // await viewModel.sendMessage()
            
            // Option 2: If your model takes the message directly but not as a parameter
            await viewModel.sendMessage()
        }
    }
    
    // MARK: - Subviews
    
    /// Displays a single message bubble with appropriate styling based on sender
    struct MessageBubble: View {
        let message: ChatViewModel.Message
        
        var body: some View {
            HStack {
                if message.isUser { Spacer() }
                VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                    Text(message.content)
                        .padding(12)
                        .background(
                            message.isUser
                            ? CraveTheme.Colors.accent.opacity(0.9)
                            : Color.black.opacity(0.6)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                }
                if !message.isUser { Spacer() }
            }
        }
    }
    
    /// Displays a loading overlay with animated typing indicator
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
    
    /// Animated typing indicator with three bouncing dots
    struct TypingIndicator: View {
        @State private var showFirst = false
        @State private var showSecond = false
        @State private var showThird = false
        
        var body: some View {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(CraveTheme.Colors.accent.opacity(0.7))
                        .frame(width: 8, height: 8)
                        .scaleEffect(scale(for: index))
                        .animation(
                            .easeInOut(duration: 0.4)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                            value: scale(for: index)
                        )
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.6))
            )
            .onAppear {
                showFirst = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { showSecond = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { showThird = true }
            }
        }
        
        /// Returns the scale factor for each dot based on its animation state
        private func scale(for index: Int) -> CGFloat {
            switch index {
            case 0: return showFirst ? 1.5 : 1.0
            case 1: return showSecond ? 1.5 : 1.0
            case 2: return showThird ? 1.5 : 1.0
            default: return 1.0
            }
        }
    }
}
