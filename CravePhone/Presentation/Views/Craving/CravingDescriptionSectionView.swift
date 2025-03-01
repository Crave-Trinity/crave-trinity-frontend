/* -----------------------------------------
   CravingDescriptionSectionView.swift
   ----------------------------------------- */
import SwiftUI

struct CravingDescriptionSectionView: View {
    @Binding var text: String
    let isRecordingSpeech: Bool
    let onToggleSpeech: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: geometry.size.height * 0.02) {
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
                Spacer(minLength: 0)
            }
            .padding(.vertical, geometry.size.height * 0.01)
        }
        .frame(minHeight: 100) // Ensures enough height for text input
    }
}

