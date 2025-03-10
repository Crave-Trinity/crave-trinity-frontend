//==================================================
// File: CraveTextEditorAccessoryRow.swift
// Directory: CravePhone/Presentation/Common/DesignSystem/Components/CraveTextEditorAccessoryRow.swift
//
// Purpose:
//   Create a dedicated accessory view that encapsulates an HStack containing
//   the character count indicator and the speech-to-text mic button.
//   This view isolates the accessory concerns from the core text editor logic,
//   adhering to the Single Responsibility Principle.
//==================================================
import SwiftUI

struct CraveTextEditorAccessoryRow: View {
    @Binding var text: String
    let characterLimit: Int
    let isRecording: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            // Display character count (e.g., "25/300").
            Text("\(text.count)/\(characterLimit)")
                .font(.footnote)
                .foregroundColor(.gray)
            
            Spacer()
            
            // Reuse the standalone speech toggle button.
            CraveSpeechToggleButton(isRecording: isRecording, onToggle: onToggle)
        }
        .padding([.leading, .trailing], 4)
    }
}
