//
//  CravingLogViewModel.swift
//  CraveWatch
//
//  Description:
//    A ViewModel for watch-based craving logging. It validates user input,
//    creates a SwiftData entity, sends it to the phone, and resets UI on success.
//


import Foundation
import SwiftData
import Combine

@MainActor
final class CravingLogViewModel: ObservableObject {
    
    // MARK: - Published UI State
    
    /// The text the user enters describing the craving.
    @Published var cravingText: String = ""
    
    /// The user-selected intensity (e.g., 1..10).
    @Published var intensity: Int = 5
    
    /// Controls whether a success confirmation is displayed.
    @Published var showConfirmation: Bool = false
    
    /// Stores an optional error message if validation fails.
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    
    /// Service for sending data to the phone (WatchConnectivity).
    private let connectivityService: WatchConnectivityService
    
    // MARK: - Initialization
    
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    // MARK: - Public Methods
    
    /// Logs a craving by creating a `WatchCravingEntity` in SwiftData
    /// and sending it to the phone.
    ///
    /// - Parameter context: The SwiftData `ModelContext` for insertion.
    func logCraving(context: ModelContext) {
        // 1) Trim whitespace
        let trimmedText = cravingText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2) Validate that the user actually typed something
        guard !trimmedText.isEmpty else {
            errorMessage = "Please enter a craving description."
            return
        }
        
        // 3) Create a new SwiftData entity with current date/time
        let newCraving = WatchCravingEntity(
            text: trimmedText,
            intensity: intensity,
            timestamp: Date()
        )
        
        // 4) Insert into SwiftData
        context.insert(newCraving)
        
        // 5) Send the new craving to the phone
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        // 6) Reset UI state
        cravingText = ""
        intensity = 5
        errorMessage = nil
        showConfirmation = true
        
        // 7) Optional haptic feedback on success
        WatchHapticManager.shared.play(.success)
    }
    
    /// Dismisses any error message by setting it to nil.
    func dismissError() {
        errorMessage = nil
    }
}
