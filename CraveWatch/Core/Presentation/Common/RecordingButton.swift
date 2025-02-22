// MARK: - RecordingButton.swift
// A reusable button for recording audio that provides visual feedback based on recording state.

import SwiftUI

/// A customizable button that displays a microphone icon when not recording,
/// and a stop icon when recording. Tapping the button triggers the provided action.
struct RecordingButton: View {
    /// Indicates whether recording is currently active.
    let isRecording: Bool
    
    /// The action to perform when the button is tapped.
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            // Choose an icon based on the recording state.
            Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .resizable() // Make the image scalable.
                .frame(width: 60, height: 60) // Define a fixed size.
                // Use red color for stop icon when recording, green otherwise.
                .foregroundColor(isRecording ? .red : .green)
        }
    }
}
