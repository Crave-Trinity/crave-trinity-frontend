//
// 5) FILE: CravingDescriptionSectionView.swift
//    DIRECTORY: CravePhone/Presentation/Views/Craving
//    DESCRIPTION: Shows the text editor for the craving description,
//                 plus the mic button near the character count.
//

import SwiftUI

struct CravingDescriptionSectionView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    
    private let characterLimit = 300
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("What are you craving?")
                .font(.headline)
            
            // ZStack to overlay the mic + char count in top-right
            ZStack(alignment: .topTrailing) {
                
                // The custom text editor
                CraveTextEditor(
                    text: $viewModel.cravingDescription,
                    placeholder: "Describe your craving...",
                    minHeight: 120
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 1)
                )
                
                // HStack for char count + mic
                HStack(spacing: 8) {
                    Text("\(viewModel.cravingDescription.count)/\(characterLimit)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    CraveSpeechToggleButton { recognizedText in
                        // Decide whether to append or replace
                        // For example, let's just set (replace) for clarity
                        viewModel.cravingDescription = recognizedText
                    }
                }
                .padding(.top, 8)
                .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}
