import SwiftData
import Foundation

@MainActor
let modelConfiguration: ModelConfiguration = {
    let config = ModelConfiguration()

    return config
}()

let sharedModelContainer: ModelContainer = {
    let schema = Schema([
        CravingEntity.self, AnalyticsMetadata.self // Add other entities here if you have more
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

