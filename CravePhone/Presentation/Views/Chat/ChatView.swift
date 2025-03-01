/* -----------------------------------------
   ChatView.swift
   ----------------------------------------- */
import SwiftUI

public struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel

    public init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    // Background gradient
                    CraveTheme.Colors.primaryGradient
                        .ignoresSafeArea()
                    
                    VStack {
                        // Scrollable chat messages
                        ScrollViewReader { scrollProxy in
                            ScrollView {
                                VStack(spacing: geometry.size.height * 0.01) {
                                    ForEach(viewModel.messages) { message in
                                        messageBubble(message)
                                    }
                                }
                                .padding()
                            }
                            // Updated onChange syntax, non-deprecated
                            .onChange(of: viewModel.messages.count, initial: false) { _, _ in
                                withAnimation(.easeOut) {
                                    if let lastID = viewModel.messages.last?.id {
                                        scrollProxy.scrollTo(lastID, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        
                        // Input area
                        HStack(spacing: geometry.size.width * 0.02) {
                            TextField("Ask about your cravings…", text: $viewModel.userInput)
                                .padding(.horizontal, geometry.size.width * 0.02)
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
                        .padding(.horizontal, geometry.size.width * 0.03)
                        .padding(.bottom, geometry.size.height * 0.02)
                    }
                }
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
    }

    // MARK: - Message Bubble View
    @ViewBuilder
    private func messageBubble(_ message: ChatViewModel.Message) -> some View {
        HStack {
            if message.isUser { Spacer(minLength: 0) }
            Text(message.content)
                .font(CraveTheme.Typography.body)
                .foregroundColor(CraveTheme.Colors.primaryText)
                .padding(10)
                .background(message.isUser
                            ? CraveTheme.Colors.accent.opacity(0.7)
                            : Color.gray.opacity(0.3))
                .cornerRadius(CraveTheme.Layout.cornerRadius)
            if !message.isUser { Spacer(minLength: 0) }
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
        .id(message.id)
    }
}

