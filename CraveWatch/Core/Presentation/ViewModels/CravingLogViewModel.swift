//
//  CravingLogViewModel.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: Handles watch-based craving logging. Stores data locally in SwiftData
//               and forwards it to the iPhone via WatchConnectivityService.
//
import Foundation
import SwiftData
import Combine

@MainActor
final class CravingLogViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var cravingDescription: String = ""
    @Published var intensity: Int = 5  // Example scale: 1 to 10
    @Published var showConfirmation: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    private let connectivityService: WatchConnectivityService
    
    // MARK: - Initialization
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    // MARK: - Public Methods
    /// Creates a local WatchCravingEntity in SwiftData and sends it to the phone.
    func logCraving(context: ModelContext) {
        // Validate user input
        let trimmed = cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter a craving description."
            return
        }
        
        // Create a new local entity
        let newCraving = WatchCravingEntity(text: trimmed, intensity: intensity, timestamp: Date())
        
        // Insert into the watch's SwiftData store
        context.insert(newCraving)
        // SwiftData typically autosaves, but you could do: try? context.save() if you want explicit saving
        
        // Send to iPhone
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        // Reset UI state
        cravingDescription = ""
        intensity = 5
        showConfirmation = true
        errorMessage = nil
    }
    
    /// Clears any existing error message.
    func dismissError() {
        errorMessage = nil
    }
}
