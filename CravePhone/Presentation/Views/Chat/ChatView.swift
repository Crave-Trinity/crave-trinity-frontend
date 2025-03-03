//
//  ChatView.swift
//  CravePhone/Presentation/Views/Chat
//
//  GOF/SOLID EXPLANATION:
//   - Single Responsibility: Displays chat UI and interacts with ViewModel.
//   - Minimal logic; delegates any real business decisions to the ViewModel.
//   - Leverages SwiftUI for data-binding to @ObservedObject ViewModel.
//
import SwiftUI

struct ChatView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText: String = ""           // local textfield binding
    @FocusState private var isInputFocused: Bool            // track keyboard focus
    
    // MARK: - Init
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // A black background for the entire safe area
            Color.black.ignoresSafeArea()
                
            VStack(spacing: 0) {
                    
                // Scrollable area for messages:
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
                    .onChange(of: viewModel.messages.count, initial: !viewModel.messages.isEmpty) { oldCount, newCount in
                        // If a new message is appended, scroll to bottom
                        if newCount > oldCount, let lastMsg = viewModel.messages.last {
                            withAnimation {
                                scrollProxy.scrollTo(lastMsg.id, anchor: .bottom)
                            }
                        }
                    }
                }
                    
                // Chat Input Bar
                inputBar
            }
                
            // Loading Overlay
            if viewModel.isLoading {
                LoadingOverlay()
            }

            // ADDED: Get Test Token Button (Positioned at the top)
            VStack {
                HStack {
                    Button("Get Test Token") {
                        viewModel.getTestToken()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    Spacer() // Push the button to the leading edge
                }
                Spacer() // Push the button to the top
            }
        }
        // Show alerts
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
        // Send welcome message if needed
        .onAppear {
            viewModel.sendWelcomeMessage()
          //  viewModel.getTestToken() //Alternative way to get token
        }
    }
    
    // MARK: - Subviews
    
    /// The input bar at the bottom
    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider().background(Color.gray.opacity(0.3))
                
            HStack(spacing: 12) {
                // Text field for user message
                TextField("Type a message...", text: $messageText)
                    .padding(12)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .focused($isInputFocused)
                    // Pressing "Send" key on the keyboard
                    .submitLabel(.send)
                    .onSubmit { sendMessage() }
                    
                // Send button
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(
                            messageText.trimmingCharacters(in: .whitespaces).isEmpty
                            ? .gray : .blue
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
    
    /// Sends the user’s typed message to the ViewModel
    private func sendMessage() {
        // 1) Trim the local text
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // 2) Assign to ViewModel’s userInput (the CRUCIAL fix)
        viewModel.userInput = trimmed
        
        // 3) Clear local text
        messageText = ""
        
        // 4) Trigger the async request in the ViewModel
        Task {
            await viewModel.sendMessage()
        }
    }
    
    /// Single message bubble
    struct MessageBubble: View {
        let message: ChatViewModel.Message
        
        var body: some View {
            HStack {
                if message.isUser { Spacer() }
                
                VStack(alignment: message.isUser ? .trailing : .leading) {
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
                
                if !message.isUser { Spacer() }
            }
            .padding(.horizontal, 4)
        }
    }
    
    /// A translucent overlay with a spinner for loading states
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
