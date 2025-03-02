//
//  CravingEmotionChipsView.swift
//  CravePhone
//
//  RESPONSIBILITY: Displays tappable emotion chips.
//

import SwiftUI

struct CravingEmotionChipsView: View {
    let selectedEmotions: Set<String>
    let onToggleEmotion: (String) -> Void

    // Example list; adjust as needed.
    private let allEmotions = [
        "Hungry", "Angry", "Lonely", "Tired", "Boredom", "Anxiety",
        "Celebration", "Stress", "Habit", "Social", "Sad", "Excitement",
        "Fear", "Reward", "Comfort"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Emotional Triggers")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            Text("What emotions are driving this craving?")
                .font(CraveTheme.Typography.body)
                .foregroundColor(CraveTheme.Colors.secondaryText)

            // Wrap the chips
            WrapLayout(spacing: 8) {
                ForEach(allEmotions, id: \.self) { emotion in
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
                                    .fill(
                                        selectedEmotions.contains(emotion)
                                        ? CraveTheme.Colors.accent
                                        : Color.white.opacity(0.2)
                                    )
                            )
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// Very basic flexible layout for chips; you could replace with an HStack if needed.
struct WrapLayout<Content: View>: View {
    let spacing: CGFloat
    let content: () -> Content

    init(spacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            FlowLayout(
                availableWidth: availableWidth,
                spacing: spacing,
                content: content
            )
        }
        .frame(minHeight: 0)
    }
}

struct FlowLayout<Content: View>: View {
    let availableWidth: CGFloat
    let spacing: CGFloat
    let content: () -> Content

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        var x: CGFloat = 0
        var y: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            content()
                .fixedSize()
                .alignmentGuide(.leading) { d in
                    if (abs(x - d.width) > availableWidth) {
                        x = 0
                        y -= (d.height + spacing)
                    }
                    let result = x
                    x -= (d.width + spacing)
                    return result
                }
                .alignmentGuide(.top) { d in
                    let result = y
                    return result
                }
        }
        .padding(.top, -y) // Adjust top padding if needed
        .readSize { size in
            totalHeight = size.height
        }
        .frame(height: totalHeight)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
