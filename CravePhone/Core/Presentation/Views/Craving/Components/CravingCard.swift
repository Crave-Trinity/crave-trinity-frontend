//
//  CravingCard.swift
//  CravePhone
//
//  Created by ...
//  Updated by ChatGPT on ...
//

import SwiftUI

public struct CravingCard: View {
    private let craving: CravingEntity
    
    public init(craving: CravingEntity) {
        self.craving = craving
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(craving.text)
                .font(CRAVEDesignSystem.Typography.heading)
                .lineLimit(2)
                .foregroundColor(CRAVEDesignSystem.Colors.textPrimary)
            
            HStack {
                Text(craving.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(CRAVEDesignSystem.Typography.subheading)
                    .foregroundColor(CRAVEDesignSystem.Colors.textSecondary)
                
                Spacer()
                
                if craving.isArchived {
                    Label("Archived", systemImage: "archivebox")
                        .font(CRAVEDesignSystem.Typography.subheading)
                        .foregroundColor(CRAVEDesignSystem.Colors.textSecondary)
                }
            }
        }
        .padding()
        .background(CRAVEDesignSystem.Colors.cardBackground)
        .cornerRadius(CRAVEDesignSystem.Layout.cornerRadius)
        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
    }
}
