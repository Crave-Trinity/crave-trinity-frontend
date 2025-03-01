//
//  CravingDescriptionSectionView.swift
//  CravePhone
//
//  Description:
//    Subview for the text input portion of logging a craving.
//
//  Uncle Bob & SOLID notes:
//    - Single Responsibility: Only deals with text + mic UI.
//    - Open/Closed: We can add placeholders or advanced logic without changing the rest of the app.
//

import SwiftUI

struct CravingDescriptionSectionView: View {
    @Binding var text: String
    let isRecordingSpeech: Bool
    let onToggleSpeech: () -> Void
    
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
