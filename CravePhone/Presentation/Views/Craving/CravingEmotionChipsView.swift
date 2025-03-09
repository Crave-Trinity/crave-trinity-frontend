//
// CravingEmotionChipsView.swift
// /CravePhone/Presentation/Views/Craving/CravingEmotionChipsView.swift
//
// Revised for consistent styling and typography.
// Updated to use a Capsule background with an overlay stroke for unselected chips,
// providing a sleeker look that aligns with other chips in the app.
import SwiftUI

struct CravingEmotionChipsView: View {
    let selectedEmotions: Set<String>
    let onToggleEmotion: (String) -> Void
    
    // List of available mood options
    private let allEmotions = [
        "Hungry", "Angry", "Lonely", "Tired",
        "Happy", "Sad", "Anxious", "Bored"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: CraveTheme.Spacing.medium) {
            // Title for the mood section, using a global subheading style.
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
                // Use a Capsule for a sleek, rounded look
                .background(
                    Capsule()
                        .fill(selectedEmotions.contains(emotion)
                              ? CraveTheme.Colors.accent
                              : Color.white.opacity(0.15)
                        )
                )
                // Overlay a stroke on unselected chips to enhance definition
                .overlay(
                    Capsule()
                        .stroke(
                            selectedEmotions.contains(emotion)
                                ? Color.clear
                                : Color.white.opacity(0.5),
                            lineWidth: 1
                        )
                )
        }
    }
}
