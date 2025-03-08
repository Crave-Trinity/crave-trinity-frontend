// DIRECTORY/FILENAME: CravePhone/Presentation/Views/Chat/ChatView.swift
// PASTE & RUN (Removed "Get Test Token" button; minimal changes)

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText = ""
    @FocusState private var isInputFocused: Bool
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1) Chat messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.messages) { msg in
                                messageBubble(msg)
                                    .id(msg.id)
                            }
                        }
                        .padding(.top, 12)
                    }
                    .onChange(of: viewModel.messages.count) { _, _ in
                        if let lastID = viewModel.messages.last?.id {
                            withAnimation { proxy.scrollTo(lastID, anchor: .bottom) }
                        }
                    }
                }
                
                // 2) Input bar
                inputBar
            }
            
            // 3) Loading
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView("Thinking...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            viewModel.loadAuthToken()
            viewModel.sendWelcomeMessage()
        }
    }
    
    private var inputBar: some View {
        VStack {
            Divider().background(Color.gray.opacity(0.4))
            HStack {
                TextField("Type a message...", text: $messageText)
                    .focused($isInputFocused)
                    .padding(.horizontal, 12)
                    .frame(minHeight: 36)
                    .onSubmit { sendMessage() }
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 24))
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                          || viewModel.isLoading)
                .padding(.trailing, 12)
            }
            .padding(.vertical, 8)
        }
        .background(Color.gray.opacity(0.1))
    }
    
    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        viewModel.userInput = trimmed
        messageText = ""
        Task { await viewModel.sendMessage() }
    }
    
    private func messageBubble(_ msg: ChatViewModel.Message) -> some View {
        HStack {
            if msg.isUser { Spacer() }
            VStack(alignment: msg.isUser ? .trailing : .leading) {
                Text(msg.content)
                    .padding()
                    .background(msg.isUser ? Color.blue.opacity(0.8) : Color.gray.opacity(0.3))
                    .cornerRadius(12)
                
                Text(msg.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            if !msg.isUser { Spacer() }
        }
        .padding(.horizontal, 8)
    }
}
