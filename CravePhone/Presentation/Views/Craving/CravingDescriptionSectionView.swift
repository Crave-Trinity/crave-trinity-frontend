//
// CravingDescriptionSectionView.swift
// CravePhone/Presentation/Views/Craving
//
// DESCRIPTION:
//   Displays a text editor for the craving description along with a character count.
//   Focus management is handled by the parent view.
//
// ARCHITECTURE (SOLID):
//   Single Responsibility: Only presents and updates the text.
//   Uncle Bob Style: Keep views simple and decoupled.
//
import SwiftUI

struct CravingDescriptionSectionView: View {
    @Binding var text: String  // Bound text value from the parent.
    
    private let characterLimit = 300
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What are you craving?")
                .font(.headline)
            
            // ZStack to overlay the character count on the text editor.
            ZStack(alignment: .topTrailing) {
                // Your custom text editor.
                CraveTextEditor(
                    text: $text,
                    placeholder: "Describe your craving...",
                    minHeight: 120
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 1)
                )
                
                // Display character count.
                Text("\(text.count)/\(characterLimit)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                    .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}
