//
//  ChatView.swift
//  CravePhone
//
//  Description:
//    A minimalistic chat interface where the user can type a craving-related query,
//    send it to the AI (using the RAG pipeline), and view the response in a chat-like format.
//    This view uses the new iOS 17 onChange API (zero-parameter closure) to scroll automatically to the latest message.
//
//  Uncle Bob & Steve Jobs Notes:
//    - Clear separation of concerns: the ViewModel handles business logic,
//      while the view manages presentation.
//    - The updated onChange modifier now uses a zero-parameter closure, which captures the new state.
//    - Minimal and elegant design for a seamless user experience.
//
import SwiftUI

public struct ChatView: View {
    
    @ObservedObject var viewModel: ChatViewModel
    
    public init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                // Use a sleek gradient background defined in your design system.
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                VStack {
                    // ScrollViewReader enables programmatic scrolling.
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(viewModel.messages) { message in
                                    messageBubble(message)
                                }
                            }
                            .padding()
                        }
                        // Updated onChange modifier (iOS 17+):
                        // Using the zero-parameter version: when the message count changes,
                        // perform the closure without passing old/new values.
                        .onChange(of: viewModel.messages.count) {
                            withAnimation(.easeOut) {
                                if let lastMessageId = viewModel.messages.last?.id {
                                    scrollProxy.scrollTo(lastMessageId, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    // Input area with text field and send button.
                    HStack(spacing: 8) {
                        TextField("Ask about your cravings…", text: $viewModel.userInput)
                            .padding(.horizontal, 12)
                            .frame(minHeight: 40)
                            .background(.thinMaterial)
                            .cornerRadius(8)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: 40, height: 40)
                        } else {
                            Button {
                                Task {
                                    await viewModel.sendMessage()
                                }
                            } label: {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            .navigationBarTitle("AI Insights", displayMode: .inline)
            // Alert for errors and notifications.
            .alert(item: $viewModel.alertInfo) { info in
                Alert(title: Text(info.title),
                      message: Text(info.message),
                      dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Message Bubble View
    /// Renders a chat bubble for each message in the conversation.
    @ViewBuilder
    private func messageBubble(_ message: ChatViewModel.Message) -> some View {
        HStack {
            if message.isUser { Spacer(minLength: 20) }
            Text(message.content)
                .padding(10)
                .background(message.isUser ? Color.blue.opacity(0.7) : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
            if !message.isUser { Spacer(minLength: 20) }
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
        .id(message.id)
    }
}

