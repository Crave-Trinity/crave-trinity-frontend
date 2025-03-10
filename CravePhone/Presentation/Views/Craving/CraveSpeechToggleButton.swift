//==================================================
// File: CraveSpeechToggleButton.swift
// Directory: CravePhone/Presentation/Views/Craving/CraveSpeechToggleButton.swift
//
// Purpose:
//   A standalone mic button to start/stop speech input.
//   This component is modular and can be reused within different views,
//   such as the dedicated accessory row in the CraveTextEditor.
//==================================================
import SwiftUI

struct CraveSpeechToggleButton: View {
    let isRecording: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: {
            CraveHaptics.shared.lightImpact()
            onToggle()
        }) {
            Image(systemName: isRecording ? "waveform.circle.fill" : "mic.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isRecording ? CraveTheme.Colors.accent : Color.white.opacity(0.8))
                .padding(8)
                .background(
                    Circle().fill(isRecording ? Color.white.opacity(0.2) : Color.black.opacity(0.4))
                )
                .overlay(
                    Circle().stroke(isRecording ? CraveTheme.Colors.accent : .clear, lineWidth: 1.5)
                )
                .scaleEffect(isRecording ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isRecording)
        }
        .accessibilityLabel(isRecording ? "Stop recording" : "Start voice input")
    }
}
