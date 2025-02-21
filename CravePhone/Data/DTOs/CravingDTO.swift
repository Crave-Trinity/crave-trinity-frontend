// Core/Data/DTOs/CravingDTO.swift
import Foundation
import SwiftData

@Model
final class CravingDTO {
    var id: UUID
    var text: String
    var timestamp: Date
    var isArchived: Bool
    
    init(id: UUID = UUID(), text: String, timestamp: Date = Date(), isArchived: Bool = false) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.isArchived = isArchived
    }
}
