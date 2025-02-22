//
//  CravingLogAllyContactPageView.swift
//  CraveWatch
//
//  A dedicated subview for "Ally Support" contact or resource links.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

/// A view that displays the Ally Support interface for the craving log.
/// This view acts as a container for the AllySupportView.
struct CravingLogAllyContactPageView: View {
    // MARK: - Dependencies
    
    /// The view model for the craving log, which may provide additional context or actions.
    @ObservedObject var viewModel: CravingLogViewModel

    // MARK: - View Body
    
    var body: some View {
        // A vertical stack that hosts the ally support subview.
        VStack(spacing: 12) {
            // Embeds the AllySupportView. No navigation button is provided here as the view itself handles its interactions.
            AllySupportView()
        }
        // Apply horizontal and top padding for layout adjustment.
        .padding(.horizontal, 10)
        .padding(.top, 6)
    }
}

// MARK: - AllySupportView
/// A subview that provides a UI for users to reach out for ally support.
/// It allows the user to select an ally contact and send a short message.
struct AllySupportView: View {
    // MARK: - Local State
    
    /// Holds the message text input by the user.
    @State private var messageText: String = ""
    
    /// Holds the selected ally contact from the provided list.
    @State private var selectedAlly: String = ""

    // MARK: - Static Data
    
    /// A sample list of ally options.
    let allies = ["Friend", "Family", "Group Chat", "Sponsor"]

    // MARK: - View Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title for the ally support section.
            Text("Reach Out")
                .font(.headline)
                .foregroundColor(.white)
            
            // A picker for selecting an ally contact.
            Picker("Select Ally", selection: $selectedAlly) {
                ForEach(allies, id: \.self) { ally in
                    Text(ally).tag(ally)
                }
            }
            // Uses a navigation-link style to fit watchOS UI conventions.
            .pickerStyle(.navigationLink)
            
            // A text field for entering a short message.
            TextField("Type a short message", text: $messageText)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(Color.white.opacity(0.15))
                .cornerRadius(4)
                .foregroundColor(.white)
            
            // A button to send the message.
            Button("Send") {
                // Simulate sending the message by playing a haptic notification.
                WatchHapticManager.shared.play(.notification)
                // Log the action for debugging purposes.
                print("Sending message: '\(messageText)' to ally: \(selectedAlly)")
            }
            // Use a prominent button style for visual emphasis.
            .buttonStyle(.borderedProminent)
            // Disable the button if no ally is selected or the message is empty.
            .disabled(selectedAlly.isEmpty || messageText.isEmpty)
        }
        // Set the default text color for all subviews.
        .foregroundColor(.white)
        // Apply padding around the contents.
        .padding()
        // Provide a subtle background with rounded corners.
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
    }
}
