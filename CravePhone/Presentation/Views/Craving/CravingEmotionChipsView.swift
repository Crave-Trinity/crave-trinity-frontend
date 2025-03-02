//
//  CravingEmotionChipsView.swift
//  CravePhone
//
//  RESPONSIBILITY: Displays emotional trigger chips neatly organized into two rows of four.
//  DESIGN PHILOSOPHY: Simple, centered UI with clear visual hierarchy - following Steve Jobs' principles
//

import SwiftUI

struct CravingEmotionChipsView: View {
    // MARK: - Properties
    
    /// Set of currently selected emotion identifiers
    let selectedEmotions: Set<String>
    
    /// Callback triggered when user toggles an emotion chip
    let onToggleEmotion: (String) -> Void

    // Refined emotion list (two rows of four) - carefully selected for maximum relevance
    private let allEmotions = [
        "Hungry", "Angry", "Lonely", "Tired",
        "Happy", "Sad", "Bored", "Anxious"
    ]

    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title with emoji for visual interest - Jobs appreciated meaningful icons
            Text("💖 Mood")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText)

            // Two neat rows of four emotion chips each - now centered for balance
            // This creates a strong visual focus point as Jobs would prefer
            VStack(spacing: 10) {
                // First row of emotions - centered
                HStack(spacing: 10) {
                    Spacer() // Pushes content to center
                    
                    ForEach(allEmotions.prefix(4), id: \.self) { emotion in
                        emotionChip(for: emotion)
                    }
                    
                    Spacer() // Balances the layout
                }
                
                // Second row of emotions - centered
                HStack(spacing: 10) {
                    Spacer() // Pushes content to center
                    
                    ForEach(allEmotions.suffix(4), id: \.self) { emotion in
                        emotionChip(for: emotion)
                    }
                    
                    Spacer() // Balances the layout
                }
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Emotion Chip Builder
    
    /// Creates a single emotion chip with appropriate styling
    /// - Parameter emotion: The emotion text to display
    /// - Returns: A styled, tappable button representing the emotion state
    private func emotionChip(for emotion: String) -> some View {
        Button {
            // Clean, direct action with no unnecessary complexity
            onToggleEmotion(emotion)
        } label: {
            Text(emotion)
                .font(.callout)
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    // Focused visual distinction between selected and unselected states
                    // Jobs believed in clarity of state through visual design
                    RoundedRectangle(cornerRadius: 16)
                        .fill(selectedEmotions.contains(emotion)
                            ? CraveTheme.Colors.accent  // Selected: vibrant, intentional
                            : Color.white.opacity(0.2)  // Unselected: subtle, recessive
                        )
                )
        }
    }
}

// MARK: - Design Notes
/*
 This implementation follows Steve Jobs' design philosophy by:
 1. Centering the chips for visual balance - creating a focal point
 2. Maintaining clean spacing and consistent padding
 3. Using clear visual distinction for selected vs unselected states
 4. Keeping the interface focused on the essential task
 5. Following "Clean Code" principles with well-organized, self-documenting code
 
 The centered design creates a more balanced, intentional look while maintaining
 the left-aligned header for proper visual hierarchy.
*/
