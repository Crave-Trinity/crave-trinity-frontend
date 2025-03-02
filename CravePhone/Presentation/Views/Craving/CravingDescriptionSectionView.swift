//
//  CravingDescriptionSectionView.swift
//  CravePhone
//
//  PURPOSE:
//    - Collect textual description of a craving in a large text editor.
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: Just the description subview, no extra logic.
//
//  “DESIGNING FOR STEVE JOBS”:
//    - Minimal friction, placeholders to prompt user input.
//
//  UPDATED: <today's date>.
//

import SwiftUI

struct CravingDescriptionSectionView: View {
    @Binding var text: String
    let isRecordingSpeech: Bool
    let onToggleSpeech: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Describe your craving")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            
            CraveTextEditor(
                text: $text,
                isRecordingSpeech: isRecordingSpeech,
                onMicTap: onToggleSpeech,
                placeholderLines: [
                    .plain("What are you craving?"),
                    .plain("When did it start?"),
                    .plain("Where are you?")
                ]
            )
            .frame(maxWidth: .infinity, minHeight: 120, maxHeight: .infinity)
            
            HStack {
                Spacer()
                Text("\(text.count)/300")
                    .font(.system(size: 12))
                    .foregroundColor(
                        text.count > 280
                            ? .red
                            : text.count > 250
                                ? .orange
                                : CraveTheme.Colors.secondaryText
                    )
                    .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 8)
    }
}

