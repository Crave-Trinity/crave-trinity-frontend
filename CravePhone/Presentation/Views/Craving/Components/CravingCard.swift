//
//  CravingCard.swift
//  CravePhone
//
//  Uncle Bob & Steve Jobs Style:
//   - Replaced 'craving.text' with 'craving.cravingDescription' to match updated entity.
//   - Clean, minimal card displaying one craving's info.
//

import SwiftUI

public struct CravingCard: View {
    private let craving: CravingEntity
    
    public init(craving: CravingEntity) {
        self.craving = craving
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CraveTheme.Spacing.small) {
            Text(craving.cravingDescription)
                .font(CraveTheme.Typography.heading)
                .lineLimit(2)
                .foregroundColor(CraveTheme.Colors.primaryText)
            
            HStack {
                Text(craving.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.secondaryText)
                
                Spacer()
                
                if craving.isArchived {
                    Label("Archived", systemImage: "archivebox")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }
        }
        .padding(CraveTheme.Spacing.medium)
        .background(CraveTheme.Colors.cardBackground)
        .cornerRadius(CraveTheme.Layout.cornerRadius)
        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
    }
}

