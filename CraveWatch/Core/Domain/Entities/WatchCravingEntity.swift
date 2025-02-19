
import Foundation
import SwiftData
// Represents a locally stored craving on the watch.
// If phone is unreachable, we keep them here until we can sync.
@Model
final class WatchCravingEntity {
    var id: UUID
    var cravingDescription: String
    var intensity: Int
    var timestamp: Date
    
    init(
        id: UUID = UUID(),
        cravingDescription: String,
        intensity: Int,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.cravingDescription = cravingDescription
        self.intensity = intensity
        self.timestamp = timestamp
    }
}
