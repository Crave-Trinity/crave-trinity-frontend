//
//  CravingEmotionChipsView.swift
//  CravePhone
//
//  PURPOSE:
//    - Display emotion “chips” that the user can toggle on/off to indicate emotional triggers.
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: Manage the emotion selection grid.
//
//  “DESIGNING FOR STEVE JOBS”:
//    - Quick, glanceable emotions. Tapping toggles with minimal friction.
//
//  UPDATED: <today's date>.
//

import SwiftUI

struct CravingEmotionChipsView: View {
    let selectedEmotions: Set<String>
    let onToggleEmotion: (String) -> Void
    
    private let emotionOptions = [
        "Hungry", "Angry", "Lonely", "Tired", "Boredom",
        "Anxiety", "Celebration", "Stress", "Habit", "Social",
        "Sad", "Excitement", "Fear", "Reward", "Comfort"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Emotional Triggers")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            
            Text("What emotions are driving this craving?")
                .font(CraveTheme.Typography.body)
                .foregroundColor(CraveTheme.Colors.secondaryText)
                .padding(.bottom, 4)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                ForEach(emotionOptions, id: \.self) { emotion in
                    EmotionChip(
                        title: emotion,
                        isSelected: selectedEmotions.contains(emotion),
                        onTap: {
                            onToggleEmotion(emotion)
                        }
                    )
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct EmotionChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
            .foregroundColor(
                isSelected
                    ? CraveTheme.Colors.accent
                    : CraveTheme.Colors.primaryText
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected
                            ? CraveTheme.Colors.accent.opacity(0.2)
                            : Color.black.opacity(0.3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected
                                    ? CraveTheme.Colors.accent
                                    : Color.gray.opacity(0.5),
                                lineWidth: 1
                            )
                    )
            )
            .onTapGesture {
                onTap()
            }
    }
}

