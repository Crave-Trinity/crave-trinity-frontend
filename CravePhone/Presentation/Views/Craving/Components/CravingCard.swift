
//
//  CravingCard.swift
//  CravePhone
//
//  Displays a single logged craving, now with Location, People, and Trigger.
//  Renamed "Emotions" label to "Mood" for clarity.
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
            
            // Header: date + badges
            headerSection
            
            // Main Craving Description
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
            
            // Extra info if expanded or featured
            if isExpanded || isFeatured {
                metricsSection
                    .padding(.top, 4)
                    .transition(.move(edge: .top).combined(with: .opacity))
                
                // Mood Section
                if !craving.emotions.isEmpty {
                    moodSection(craving.emotions)
                        .padding(.top, 4)
                }
                
                // Show location if present
                if let location = craving.location, !location.isEmpty {
                    infoRow(title: "Location", value: location)
                }
                
                // Show people if present
                if let people = craving.people, !people.isEmpty {
                    infoRow(title: "With", value: people.joined(separator: ", "))
                }
                
                // Show trigger if present
                if let trigger = craving.trigger, !trigger.isEmpty {
                    infoRow(title: "Trigger", value: trigger)
                }
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
    
    // MARK: - Header
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
            
            // Combine both badges
            HStack(spacing: 8) {
                intensityBadge
                resistanceBadge
            }
            .scaleEffect(isFeatured ? 1.1 : 1.0)
        }
    }
    
    // MARK: - Badges
    private var intensityBadge: some View {
        HStack(spacing: 4) {
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
    
    private var resistanceBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "shield.fill")
                .font(.system(size: 12))
                .foregroundColor(.clear)
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
        .foregroundColor(resistanceLabelColor)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(resistanceColor.opacity(0.2)))
    }
    
    // MARK: - Metrics
    private var metricsSection: some View {
        VStack(spacing: 12) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.2))
            
            HStack {
                metricItem(
                    title: "Intensity",
                    value: "\(Int(craving.intensity))/10",
                    icon: "flame.fill",
                    color: intensityColor
                )
                
                Divider()
                    .frame(height: 30)
                    .background(Color.gray.opacity(0.2))
                
                metricItem(
                    title: "Resistance",
                    value: "\(Int(craving.resistance))/10",
                    icon: "shield.fill",
                    color: resistanceColor
                )
            }
        }
    }
    
    // MARK: - Mood Section
    private func moodSection(_ moods: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mood:")
                .font(CraveTheme.Typography.body.weight(.medium))
                .foregroundColor(CraveTheme.Colors.secondaryText)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(moods, id: \.self) { mood in
                        Text(mood)
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
    
    // MARK: - Simple Info Row
    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(title):")
                .font(CraveTheme.Typography.body.weight(.medium))
                .foregroundColor(CraveTheme.Colors.secondaryText)
            Text(value)
                .font(CraveTheme.Typography.body)
                .foregroundColor(CraveTheme.Colors.primaryText)
            Spacer()
        }
        .padding(.top, 4)
    }
    
    // MARK: - Metric Item
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
    
    // MARK: - Color Logic
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
        case 1...3:  return .gray
        case 4...6:  return .mint
        case 7...8:  return .blue
        default:     return .green
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

