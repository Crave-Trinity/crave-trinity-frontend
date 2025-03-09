//CravePhone/Presentation/Views/Chat/ChatView.swift

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.messages, id: \.self) { msg in
                        Text(msg)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 8)
            }
            
            if viewModel.isLoading {
                ProgressView("Thinking...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
            }
            
            // Input & Send button
            HStack {
                TextField("Type a message…", text: $viewModel.userInput)
                    .textFieldStyle(.roundedBorder)
                
                Button("Send") {
                    Task {
                        await viewModel.sendMessage()
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding(.horizontal)
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.white)
    }
}
