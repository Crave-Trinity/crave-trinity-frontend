/*
 ┌───────────────────────────────────────────────────────┐
 │  Directory: CravePhone/Views/Craving                 │
 │  Production-Ready SwiftUI Layout Fix:                │
 │  CravingEmotionChipsView                             │
 │  Notes:                                              │
 │   - Added proportional horizontal padding.           │
 │   - Maintained simple horizontal scroll.            │
 └───────────────────────────────────────────────────────┘
*/

import SwiftUI

struct CravingEmotionChipsView: View {
    let selectedEmotions: Set<String>
    let onToggleEmotion: (String) -> Void
    
    private let emotions = ["Hungry", "Angry", "Lonely", "Tired", "Sad"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How are you feeling?")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(emotions, id: \.self) { emotion in
                        OutlinedChip(
                            emotion: emotion,
                            isSelected: selectedEmotions.contains(emotion),
                            onTap: { onToggleEmotion(emotion) }
                        )
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.03)
            }
        }
    }
}

fileprivate struct OutlinedChip: View {
    let emotion: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(emotion)
            .font(.subheadline)
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.orange : Color.white.opacity(0.6), lineWidth: 2)
            )
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.orange.opacity(0.15) : Color.clear)
            )
            .foregroundColor(.white)
            .onTapGesture {
                onTap()
            }
    }
}

