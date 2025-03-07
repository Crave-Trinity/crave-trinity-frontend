//
// CravingEmotionChipsView.swift
// /CravePhone/Presentation/Views/Craving/CravingEmotionChipsView.swift
//
// Revised for consistent styling and typography.
// Updated to use CraveTheme values for fonts, spacing, and corner radius in emotion chips.
import SwiftUI

struct CravingEmotionChipsView: View {
    let selectedEmotions: Set<String>
    let onToggleEmotion: (String) -> Void
    
    private let allEmotions = [
        "Hungry", "Angry", "Lonely", "Tired",
        "Happy", "Sad", "Bored", "Anxious"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: CraveTheme.Spacing.medium) {
            // Title using the global subheading style.
            Text("💖 Mood")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            
            VStack(spacing: CraveTheme.Spacing.small) {
                // First row of chips, centered.
                HStack(spacing: CraveTheme.Spacing.small) {
                    Spacer()
                    ForEach(allEmotions.prefix(4), id: \.self) { emotion in
                        emotionChip(for: emotion)
                    }
                    Spacer()
                }
                // Second row of chips, centered.
                HStack(spacing: CraveTheme.Spacing.small) {
                    Spacer()
                    ForEach(allEmotions.suffix(4), id: \.self) { emotion in
                        emotionChip(for: emotion)
                    }
                    Spacer()
                }
            }
        }
        .padding(.vertical, CraveTheme.Spacing.medium)
    }
    
    // MARK: - Emotion Chip Builder
    private func emotionChip(for emotion: String) -> some View {
        Button {
            onToggleEmotion(emotion)
        } label: {
            Text(emotion)
                .font(CraveTheme.Typography.body)
                .foregroundColor(.white)
                .padding(.vertical, CraveTheme.Spacing.small)
                .padding(.horizontal, CraveTheme.Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: CraveTheme.Layout.cornerRadius)
                        .fill(selectedEmotions.contains(emotion)
                            ? CraveTheme.Colors.accent
                            : Color.white.opacity(0.2)
                        )
                )
        }
    }
}
