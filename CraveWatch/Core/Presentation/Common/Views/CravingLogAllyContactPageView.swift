//
//  CravingLogAllyContactPageView.swift
//  CraveWatch
//
//  A dedicated subview for "Ally Support" contact or resource links.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogAllyContactPageView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: CravingLogViewModel

    var body: some View {
        VStack(spacing: 12) {
            // The AllySupportView is still here—no "Next" button
            AllySupportView()
        }
        .padding(.horizontal, 10)
        .padding(.top, 6)
    }
}

// MARK: - Example AllySupportView
struct AllySupportView: View {
    // Possibly read from a ViewModel or direct props
    @State private var messageText: String = ""
    @State private var selectedAlly: String = ""

    // Example "allies" list
    let allies = ["Friend", "Family", "Group Chat", "Sponsor"]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reach Out")
                .font(.headline)
                .foregroundColor(.white)

            Picker("Select Ally", selection: $selectedAlly) {
                ForEach(allies, id: \.self) { ally in
                    Text(ally).tag(ally)
                }
            }
            .pickerStyle(.navigationLink)

            // Watch-friendly text field styling
            TextField("Type a short message", text: $messageText)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(Color.white.opacity(0.15))
                .cornerRadius(4)
                .foregroundColor(.white)

            Button("Send") {
                // Simulate sending ally message
                WatchHapticManager.shared.play(.notification)
                print("Sending message: '\(messageText)' to ally: \(selectedAlly)")
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedAlly.isEmpty || messageText.isEmpty)
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
    }
}
