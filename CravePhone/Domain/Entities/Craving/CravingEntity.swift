import SwiftData
import Foundation

@Model
public final class CravingEntity {
    @Attribute(.unique) public var id: UUID
    public var text: String
    public var timestamp: Date
    public var isArchived: Bool

    public init(
        id: UUID = UUID(),
        text: String,
        timestamp: Date = Date(),
        isArchived: Bool = false
    ) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.isArchived = isArchived
    }
}
