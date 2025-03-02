//
//  CravingEmotionChipsView.swift
//  CravePhone
//
//  RESPONSIBILITY: Displays emotional trigger chips neatly organized into two rows of four.
//

import SwiftUI

struct CravingEmotionChipsView: View {
    let selectedEmotions: Set<String>
    let onToggleEmotion: (String) -> Void

    // Refined emotion list (two rows of four)
    private let allEmotions = [
        "Hungry", "Angry", "Lonely", "Tired",
        "Happy", "Sad", "Bored", "Anxious"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("💖 Mood")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText)

            // Two neat rows of four emotion chips each
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    ForEach(allEmotions.prefix(4), id: \.self) { emotion in
                        emotionChip(for: emotion)
                    }
                }
                HStack(spacing: 10) {
                    ForEach(allEmotions.suffix(4), id: \.self) { emotion in
                        emotionChip(for: emotion)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Emotion Chip Builder
    private func emotionChip(for emotion: String) -> some View {
        Button {
            onToggleEmotion(emotion)
        } label: {
            Text(emotion)
                .font(.callout)
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(selectedEmotions.contains(emotion)
                            ? CraveTheme.Colors.accent
                            : Color.white.opacity(0.2)
                        )
                )
        }
    }
}
