//
//  CravingCard.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    Displays a single logged craving in a card layout.
//    Shows the craving description, intensity (with a wave icon), and resistance (with a shield icon).
//    "DESIGNED FOR STEVE JOBS, CODED LIKE UNCLE BOB":
//      - Clear presentation and dynamic visual feedback.
//      - Separation of concerns with self-contained, reusable UI.
//
//  USAGE:
//    Use this view within your CravingListView or similar screens to present each logged craving.
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
            // Header section with timestamp and intensity badge.
            headerSection
            
            // Craving description with expand/collapse functionality.
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
            
            if isExpanded || isFeatured {
                // Metrics section displaying intensity and resistance.
                metricsSection
                    .padding(.top, 4)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Optional emotions section.
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
    
    // MARK: - Header Section
    
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
            intensityBadge
                .scaleEffect(isFeatured ? 1.1 : 1.0)
        }
    }
    
    private var intensityBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .font(.system(size: 12))
            Text("\(Int(craving.intensity))")
                .font(.system(size: 14, weight: .bold))
        }
        .foregroundColor(intensityLabelColor)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(intensityColor.opacity(0.2)))
    }
    
    // MARK: - Metrics Section
    
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
                
                // Resistance metric with shield icon
                metricItem(
                    title: "Resistance",
                    value: "\(Int(craving.resistance))/10",
                    icon: "shield.fill",
                    color: resistanceColor
                )
            }
        }
    }
    
    // MARK: - Emotions Section
    
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
    
    // MARK: - Metric Item Helper
    
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
    
    // MARK: - Dynamic Color Helpers
    
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
    
    private var resistanceColor: Color {
        switch craving.resistance {
        case 1...3: return .red
        case 4...6: return .orange
        case 7...8: return .yellow
        default:    return .green
        }
    }
}

