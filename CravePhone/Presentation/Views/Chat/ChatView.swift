//
//  ChatView.swift
//  CravePhone
//
//  - Chat interface with manual top/bottom padding.
//  - .onChange uses #if swift(>=5.9) to avoid deprecation in iOS17.

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
            // Full-bleed gradient
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { msg in
                                MessageBubble(message: msg)
                                    .id(msg.id)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    }
                    
                    // iOS 17 fix for .onChange
                    #if swift(>=5.9)
                    .onChange(of: viewModel.messages.count, initial: false) { oldVal, newVal in
                        if let last = viewModel.messages.last {
                            withAnimation {
                                scrollProxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    #else
                    // iOS <17 fallback, not deprecated there
                    .onChange(of: viewModel.messages.count) { _ in
                        if let last = viewModel.messages.last {
                            withAnimation {
                                scrollProxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    #endif
                }
                
                // Input bar
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
                            messageText.trimmingCharacters(in: .whitespaces).isEmpty
                            || viewModel.isLoading
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.3))
                }
            }
            // Manual offset if desired
            .padding(.top, 44)
            .padding(.bottom, 34)
            
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .alert(item: $viewModel.alertInfo) { info in
            Alert(title: Text(info.title),
                  message: Text(info.message),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - Send
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
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
        @State private var show1 = false
        @State private var show2 = false
        @State private var show3 = false
        
        var body: some View {
            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(CraveTheme.Colors.accent.opacity(0.7))
                        .frame(width: 8, height: 8)
                        .scaleEffect(scale(for: i))
                        .animation(
                            .easeInOut(duration: 0.4)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.2),
                            value: scale(for: i)
                        )
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.6))
            )
            .onAppear {
                show1 = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { show2 = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { show3 = true }
            }
        }
        
        private func scale(for i: Int) -> CGFloat {
            switch i {
            case 0: return show1 ? 1.5 : 1.0
            case 1: return show2 ? 1.5 : 1.0
            case 2: return show3 ? 1.5 : 1.0
            default: return 1.0
            }
        }
    }
}
