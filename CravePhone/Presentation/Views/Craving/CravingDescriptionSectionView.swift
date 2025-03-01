/*
 ┌───────────────────────────────────────────────────────┐
 │  Directory: CravePhone/Views/Craving                 │
 │  Production-Ready SwiftUI Layout Fix:                │
 │  CravingDescriptionSectionView                       │
 │  Notes:                                              │
 │   - GeometryReader removed.                          │
 │   - Standard padding used for consistency.           │
 └───────────────────────────────────────────────────────┘
*/

import SwiftUI

struct CravingDescriptionSectionView: View {
    @Binding var text: String
    let isRecordingSpeech: Bool
    let onToggleSpeech: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Craving Description")
                .font(.headline)
                .foregroundColor(.white)
            
            CraveTextEditor(
                text: $text,
                isRecordingSpeech: isRecordingSpeech,
                onMicTap: onToggleSpeech,
                characterLimit: 300,
                placeholderLines: [
                    .plain("What are you craving?"),
                    .plain("Triggers?"),
                    .plain("Where are you?"),
                    .plain("Who are you with?")
                ]
            )
            .frame(minHeight: 100)
        }
        .padding(.vertical, 8)
    }
}

