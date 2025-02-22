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

    // Callback to go to the next tab
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            AllySupportView()

            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 26)
                    .background(Color.blue)
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
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
    let allies = ["Sponsor", "Friend", "Group Chat", "Therapist"]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reach Out to an Ally")
                .font(.headline)
                .foregroundColor(.white)

            Picker("Select Ally", selection: $selectedAlly) {
                ForEach(allies, id: \.self) { ally in
                    Text(ally).tag(ally)
                }
            }
            .pickerStyle(.navigationLink)

            // Instead of .roundedBorder (unavailable on watchOS)
            // We'll simply use a Rectangle background or no style:
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
