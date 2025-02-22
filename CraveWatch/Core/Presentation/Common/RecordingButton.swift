// MARK: - RecordingButton.swift
// A reusable button for recording audio with visual feedback

import SwiftUI

struct RecordingButton: View {
    let isRecording: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(isRecording ? .red : .green)
        }
    }
}
