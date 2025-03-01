//
//  ModelContainer.swift
//  CravePhone
//
//  Description:
//  Creates the SwiftData container, referencing our model types.
//
import SwiftData
import Foundation

@MainActor
let sharedModelContainer: ModelContainer = {
    // 1) Define the schema from your @Model classes:
    let schema = Schema([
        CravingEntity.self,
        AnalyticsMetadata.self
    ])
    
    // 2) Provide any configuration you need:
    //    isStoredInMemoryOnly = false means "persist on disk".
    let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false
    )
    
    // 3) Build and return the container:
    do {
        return try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

