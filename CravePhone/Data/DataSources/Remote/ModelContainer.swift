//
//  ModelContainer.swift
//  CravePhone
//
//  UNCLE BOB BANGER FINAL VERSION - FULLY FIXED AND COMMENTED
//  This is the definitive implementation of shared SwiftData ModelContainer
//  that correctly includes ALL @Model types in the schema, ensuring proper
//  persistence of ALL data models.
//
//  CLEAN ARCHITECTURE PRINCIPLES APPLIED:
//  - Single Source of Truth: One container for all SwiftData models
//  - Explicit Configuration: Clear settings with verbose comments
//  - Fail-Fast Error Handling: Immediate crash with helpful message if setup fails
//

import SwiftData
import Foundation

/// Shared SwiftData container accessible throughout the app
/// Created once at app launch and used consistently
@MainActor
let sharedModelContainer: ModelContainer = {
    // STEP 1: Define the complete schema with ALL @Model classes
    // CRITICAL: Every single @Model class MUST be included here!
    // If a model is missing, its data will NOT be persisted!
    let schema = Schema([
        CravingEntity.self,      // Persists CravingEntity models
        AnalyticsMetadata.self,  // Persists AnalyticsMetadata models
        AnalyticsDTO.self        // BANGER FIX: Persists AnalyticsDTO - previously missing!
    ])
    
    // STEP 2: Configure persistence settings
    // isStoredInMemoryOnly = false means data is saved to disk
    // Setting this to true would result in data being lost when app closes
    let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false  // PERSISTENCE ENABLED - DO NOT CHANGE!
    )
    
    // STEP 3: Create and return the container
    do {
        // This container will be used throughout the app
        return try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )
    } catch {
        // If this fails, the app cannot function properly
        fatalError("""
        CRITICAL ERROR: Failed to create SwiftData ModelContainer.
        This is a fatal error that prevents the app from functioning.
        Specific error: \(error)
        """)
    }
}()

// MARK: - Usage Instructions
/*
 HOW TO USE THIS CONTAINER:
 
 1. To access this container in a SwiftUI view:
    @Environment(\.modelContext) private var modelContext
 
 2. To access it in a repository or service:
    let modelContext = ModelContext(sharedModelContainer)
 
 3. When adding a NEW @Model class to your app:
    - Add it to the Schema array above
    - Clean and rebuild the project
 
 4. If persistence issues occur:
    - Verify ALL @Model classes are in the Schema array
    - Check that isStoredInMemoryOnly is set to false
    - Ensure consistent use of the same ModelContext
 */
