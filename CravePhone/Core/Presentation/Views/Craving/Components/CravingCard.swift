// Core/Presentation/Views/Craving/Components/CravingCard.swift
import SwiftUI

public struct CravingCard: View {
    private let craving: CravingEntity
    
    public init(craving: CravingEntity) {
        self.craving = craving
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(craving.text)
                .font(.headline)
                .lineLimit(2)
            
            HStack {
                Text(craving.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if craving.isArchived {
                    Label("Archived", systemImage: "archivebox")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}
