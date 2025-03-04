//
//  CravingCard.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    Displays a single logged craving in a card layout.
//    Shows craving description, intensity (wave/flame icon), and resistance (shield icon).
//    Now includes a second badge (shield) next to the flame at the top.
//
//  "DESIGNED FOR STEVE JOBS, CODED LIKE UNCLE BOB":
//    - Minimal friction, polished look.
//    - Clear, balanced badges for intensity & resistance side by side.
//    - Reverses color logic so that high resistance is a positive color.
//
//  USAGE:
//    Integrate in your CravingListView or any place you show a list of CravingEntities.
//

import SwiftUI

public struct CravingCard: View {
    private let craving: CravingEntity
    private let isFeatured: Bool
    @State private var isExpanded = false
    
    public init(craving: CravingEntity, isFeatured: Bool = false) {
        self.craving = craving
        self.isFeatured = isFeatured
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // HEADER: Now includes BOTH flame and shield at the top.
            headerSection
            
            // MAIN DESCRIPTION: Expand/collapse on tap.
            Text(craving.cravingDescription)
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText)
                .lineLimit(isExpanded ? nil : 2)
                .fixedSize(horizontal: false, vertical: isExpanded)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                    CraveHaptics.shared.lightImpact()
                }
            
            // METRICS + EMOTIONS: Shown if expanded or if isFeatured
            if isExpanded || isFeatured {
                metricsSection
                    .padding(.top, 4)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            let emotions = craving.emotions
            if !emotions.isEmpty {
                emotionsSection(emotions)
                    .padding(.top, 4)
            }
        }
        .padding(CraveTheme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: CraveTheme.Layout.cardCornerRadius)
                .fill(CraveTheme.Colors.cardBackground)
                .shadow(
                    color: isFeatured
                        ? CraveTheme.Colors.accent.opacity(0.3)
                        : Color.black.opacity(0.15),
                    radius: isFeatured ? 8 : 4,
                    x: 0,
                    y: isFeatured ? 4 : 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: CraveTheme.Layout.cardCornerRadius)
                .stroke(
                    isFeatured
                        ? CraveTheme.Colors.accent.opacity(0.5)
                        : Color.white.opacity(0.1),
                    lineWidth: isFeatured ? 2 : 1
                )
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Craving: \(craving.cravingDescription)")
        .accessibilityHint("Double tap to \(isExpanded ? "collapse" : "expand") details")
    }
    
    // MARK: - HEADER: Date + BOTH Badges (Flame + Shield)
    
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(craving.timestamp.formattedDate())
                    .font(CraveTheme.Typography.body.weight(.medium))
                    .foregroundColor(CraveTheme.Colors.secondaryText)
                
                if isExpanded {
                    Text(craving.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(CraveTheme.Typography.body)
                        .foregroundColor(CraveTheme.Colors.secondaryText.opacity(0.7))
                }
            }
            
            Spacer()
            
            // Combine both badges in an HStack
            HStack(spacing: 8) {
                intensityBadge
                resistanceBadge
            }
            .scaleEffect(isFeatured ? 1.1 : 1.0)
        }
    }
    
    // MARK: - BADGES
    
    /// Flame badge for Intensity
    private var intensityBadge: some View {
        HStack(spacing: 4) {
            // The flame symbol has a built-in multicolor style in SF Symbols
            // so we can leverage that for a 3D-ish effect:
            Image(systemName: "flame.fill")
                .font(.system(size: 12))
                .symbolRenderingMode(.multicolor)
            
            Text("\(Int(craving.intensity))")
                .font(.system(size: 14, weight: .bold))
        }
        .foregroundColor(intensityLabelColor)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(intensityColor.opacity(0.2)))
    }
    
    /// Shield badge for Resistance (with more "positive" color logic + custom gradient)
    private var resistanceBadge: some View {
        HStack(spacing: 4) {
            // We'll overlay a gradient to simulate "internal shading."
            // 1) Set the base color to .clear
            // 2) Overlay a gradient
            // 3) Mask it with the same shield shape so the gradient is clipped
            
            Image(systemName: "shield.fill")
                .font(.system(size: 12))
                .foregroundColor(.clear)  // so the main icon is invisible
                .overlay(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                resistanceLabelColor.opacity(0.9),
                                resistanceLabelColor.opacity(0.4)
                            ]
                        ),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .mask(
                    Image(systemName: "shield.fill")
                        .font(.system(size: 12))
                )
            
            Text("\(Int(craving.resistance))")
                .font(.system(size: 14, weight: .bold))
        }
        .foregroundColor(resistanceLabelColor) // Applies to text
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(resistanceColor.opacity(0.2)))
    }
    
    // MARK: - MAIN METRICS SECTION
    
    private var metricsSection: some View {
        VStack(spacing: 12) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.2))
            
            HStack {
                // Intensity metric
                metricItem(
                    title: "Intensity",
                    value: "\(Int(craving.intensity))/10",
                    icon: "flame.fill",
                    color: intensityColor
                )
                
                Divider().frame(height: 30)
                    .background(Color.gray.opacity(0.2))
                
                // Resistance metric
                metricItem(
                    title: "Resistance",
                    value: "\(Int(craving.resistance))/10",
                    icon: "shield.fill",
                    color: resistanceColor
                )
            }
        }
    }
    
    // MARK: - EMOTIONS SECTION
    
    private func emotionsSection(_ emotions: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if !isExpanded && !isFeatured {
                Text("Emotions:")
                    .font(CraveTheme.Typography.body.weight(.medium))
                    .foregroundColor(CraveTheme.Colors.secondaryText)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(emotions, id: \.self) { emotion in
                        Text(emotion)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(CraveTheme.Colors.primaryText)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(Color.gray.opacity(0.3)))
                    }
                }
            }
        }
    }
    
    // MARK: - METRIC ITEM HELPER
    
    private func metricItem(title: String, value: String, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(CraveTheme.Typography.body)
                    .foregroundColor(CraveTheme.Colors.secondaryText)
                Text(value)
                    .font(CraveTheme.Typography.body.weight(.semibold))
                    .foregroundColor(CraveTheme.Colors.primaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - COLOR LOGIC
    
    // Intensity: higher = "hotter" color
    private var intensityColor: Color {
        switch craving.intensity {
        case 1...3:  return .green
        case 4...6:  return .yellow
        case 7...8:  return .orange
        default:     return .red
        }
    }
    private var intensityLabelColor: Color {
        switch craving.intensity {
        case 1...3:  return .green
        case 4...6:  return .yellow
        default:     return .white
        }
    }
    
    // Resistance: higher = more positive color
    // e.g. 1 is "low confidence" -> grayish
    //      10 is "very high confidence" -> bright green or blue
    private var resistanceColor: Color {
        switch craving.resistance {
        case 1...3:  return .gray
        case 4...6:  return .mint       // a fresh, uplifting color
        case 7...8:  return .blue       // even stronger positivity
        default:     return .green      // top-tier positivity
        }
    }
    private var resistanceLabelColor: Color {
        switch craving.resistance {
        case 1...3:  return .gray
        case 4...6:  return .mint
        case 7...8:  return .blue
        default:     return .white
        }
    }
}

