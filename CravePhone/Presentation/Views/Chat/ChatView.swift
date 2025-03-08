// DIRECTORY/FILENAME: CravePhone/Presentation/Views/Chat/ChatView.swift
// PASTE & RUN (Removed "Get Test Token" button; minimal changes)

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages, id: \.self) { msg in
                    Text(msg)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            HStack {
                TextField("Type a message…", text: $viewModel.userInput)
                    .textFieldStyle(.roundedBorder)
                Button("Send") {
                    Task {
                        await viewModel.sendMessage()
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.black)
        .foregroundColor(.white)
    }
}
