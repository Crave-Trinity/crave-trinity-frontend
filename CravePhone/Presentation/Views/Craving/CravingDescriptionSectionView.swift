//
//  CravingDescriptionSectionView.swift
//  CravePhone
//
//  Description:
//    A subview that manages the text input portion of logging a craving,
//    including an optional microphone button (speech-to-text).
//
//  Uncle Bob notes:
//    - Single Responsibility: Only deals with the description + mic recording UI
//    - Open/Closed: Additional placeholders or design changes can be added
//      without changing the rest of the app
//    - Clean Code: Minimal duplication, clear naming
//

import SwiftUI

struct CravingDescriptionSectionView: View {
    // MARK: - Bindings
    @Binding var text: String             // The user's typed or voice-transcribed text
    let isRecordingSpeech: Bool           // Whether speech recognition is active
    let onToggleSpeech: () -> Void        // Callback to start/stop speech
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Craving Description")
                .font(.headline)
                .foregroundColor(.white)
            
            // Our custom TextEditor (with optional mic overlay)
            CraveTextEditor(
                text: $text,
                isRecordingSpeech: isRecordingSpeech,
                onMicTap: onToggleSpeech,
                characterLimit: 300,
                placeholderLines: [
                    .plain("What are you craving?"),
                    .plain("Any triggers?"),
                    .plain("Where are you?"),
                    .plain("Who are you with?")
                ]
            )
        }
        .padding(.vertical, 8)
    }
}
