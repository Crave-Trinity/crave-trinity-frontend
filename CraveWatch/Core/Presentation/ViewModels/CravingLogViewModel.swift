//
//  CravingLogViewModel.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description:
//    A ViewModel for watch-based craving logging. It validates user input, creates a local
//    SwiftData model (WatchCravingEntity) for the craving, sends it to the iPhone via the
//    connectivity service, and resets UI state on success.
//    All operations run on the main actor to ensure UI safety.
import Foundation
import SwiftData
import Combine

@MainActor
final class CravingLogViewModel: ObservableObject {
    
    // MARK: - Published Properties (UI State)
    /// The text entered by the user describing their craving.
    @Published var cravingDescription: String = ""
    
    /// A numeric value representing the intensity of the craving (e.g., on a scale of 1–10).
    @Published var intensity: Int = 5
    
    /// A flag used to trigger a success alert once a craving is logged.
    @Published var showConfirmation: Bool = false
    
    /// An optional error message string that displays validation or processing errors.
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    /// The connectivity service used to send craving data from the watch to the iPhone.
    private let connectivityService: WatchConnectivityService
    
    // MARK: - Initialization
    /// Initializes the view model with the required connectivity service.
    /// - Parameter connectivityService: The watch connectivity service for message transmission.
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    // MARK: - Public Methods
    /// Logs a craving by validating input, creating a new WatchCravingEntity,
    /// inserting it into the local SwiftData store, and sending it to the iPhone.
    /// - Parameter context: The SwiftData ModelContext used for persisting data on the watch.
    func logCraving(context: ModelContext) {
        // Trim whitespace and newlines from the input.
        let trimmed = cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validate that the user has provided a non-empty description.
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter a craving description."
            return
        }
        
        // Create a new WatchCravingEntity.
        // Note: The initializer expects 'text:' as the parameter label for the description.
        let newCraving = WatchCravingEntity(
            text: trimmed,
            intensity: intensity,
            timestamp: Date()
        )
        
        // Insert the new entity into the local SwiftData store.
        context.insert(newCraving)
        // If you prefer explicit saving, you can call try? context.save() here.
        
        // Send the craving data to the iPhone.
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        // Reset UI state: clear the input, reset intensity, clear errors, and show confirmation.
        cravingDescription = ""
        intensity = 5
        errorMessage = nil
        showConfirmation = true
    }
    
    /// Clears any error message from the view model.
    func dismissError() {
        errorMessage = nil
    }
}
