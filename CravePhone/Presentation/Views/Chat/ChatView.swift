//
//  ChatView.swift
//  CravePhone
//
//  Description:
//    Minimalistic chat interface for AI Q&A.
//
//  Uncle Bob & Steve Jobs notes:
//    - Single Responsibility: Renders chat messages, input field, sends to VM.
//    - Open/Closed: We can add advanced chat features or other UI states without rewriting everything.
//  GoF & SOLID:
//    - MVVM: The View depends on ChatViewModel for data & logic.
//    - Clear separation: The bubble rendering is a sub-function, not tangled with VM logic.
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
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                VStack {
                    // Scrollable chat messages
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            VStack(spacing: CraveTheme.Spacing.small) {
                                ForEach(viewModel.messages) { message in
                                    messageBubble(message)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: viewModel.messages.count) {
                            withAnimation(.easeOut) {
                                if let lastMessageId = viewModel.messages.last?.id {
                                    scrollProxy.scrollTo(lastMessageId, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    // Input area
                    HStack(spacing: CraveTheme.Spacing.small) {
                        TextField("Ask about your cravings…", text: $viewModel.userInput)
                            .padding(.horizontal, CraveTheme.Spacing.small)
                            .frame(minHeight: 40)
                            .background(CraveTheme.Colors.textFieldBackground)
                            .cornerRadius(CraveTheme.Layout.cornerRadius)
                            .foregroundColor(CraveTheme.Colors.primaryText)
                            .font(CraveTheme.Typography.body)
                        
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
                                    .padding(8)
                                    .background(CraveTheme.Colors.accent)
                                    .cornerRadius(CraveTheme.Layout.cornerRadius)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            // Force full screen usage
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("AI Insights", displayMode: .inline)
            .alert(item: $viewModel.alertInfo) { info in
                Alert(title: Text(info.title),
                      message: Text(info.message),
                      dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Message Bubble View
    @ViewBuilder
    private func messageBubble(_ message: ChatViewModel.Message) -> some View {
        HStack {
            if message.isUser { Spacer(minLength: CraveTheme.Spacing.small) }
            Text(message.content)
                .font(CraveTheme.Typography.body)
                .foregroundColor(CraveTheme.Colors.primaryText)
                .padding(10)
                .background(message.isUser
                            ? CraveTheme.Colors.accent.opacity(0.7)
                            : Color.gray.opacity(0.3))
                .cornerRadius(CraveTheme.Layout.cornerRadius)
            if !message.isUser { Spacer(minLength: CraveTheme.Spacing.small) }
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
        .id(message.id)
    }
}
