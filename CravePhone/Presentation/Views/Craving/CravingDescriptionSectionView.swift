//
//  CravingDescriptionSectionView.swift
//  CravePhone
//
//  Section for capturing craving description with speech input option.
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
            .frame(height: 120)
            
            HStack {
                Spacer()
                
                Text("\(text.count)/300")
                    .font(.system(size: 12))
                    .foregroundColor(
                        text.count > 250 ?
                            (text.count > 280 ? .red : .orange) :
                            CraveTheme.Colors.secondaryText
                    )
                    .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        
        CravingDescriptionSectionView(
            text: .constant("I've been craving chocolate since lunchtime."),
            isRecordingSpeech: false,
            onToggleSpeech: {}
        )
        .padding()
    }
}
