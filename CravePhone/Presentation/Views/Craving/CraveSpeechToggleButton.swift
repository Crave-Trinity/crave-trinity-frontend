//
// 2) FILE: CraveSpeechToggleButton.swift
//    DIRECTORY: CravePhone/Presentation/Views/Craving
//    DESCRIPTION: A mic button that toggles speech recognition on/off.
//                 Passes recognized text up via onSpeechResult closure.
//

import SwiftUI

struct CraveSpeechToggleButton: View {
    @StateObject private var speechService = SpeechToTextServiceImpl()
    
    // This closure is called whenever new speech text is recognized
    let onSpeechResult: (String) -> Void
    
    var body: some View {
        Button(action: {
            if speechService.isRecording {
                speechService.stopRecording()
            } else {
                speechService.startRecording { recognizedText in
                    // Forward recognized text to parent
                    onSpeechResult(recognizedText)
                }
            }
        }) {
            Image(systemName: speechService.isRecording ? "mic.fill" : "mic")
                .foregroundColor(speechService.isRecording ? .red : .blue)
                .padding(8)
                .background(Circle().fill(Color(.systemGray6)))
        }
        .accessibilityLabel("Toggle Speech Recognition")
        .animation(.easeInOut, value: speechService.isRecording)
    }
}
