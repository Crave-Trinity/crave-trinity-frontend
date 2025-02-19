//
//  CravingLogViewModel.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A ViewModel for watch-based craving logging.
//               Validates user input, creates a local SwiftData entity,
//               sends it to iPhone, and resets UI on success.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class CravingLogViewModel: ObservableObject {
    
    // MARK: - Published UI State
    @Published var cravingDescription: String = ""
    @Published var intensity: Int = 5
    @Published var showConfirmation: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    private let connectivityService: WatchConnectivityService
    
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    // MARK: - Public Methods
    func logCraving(context: ModelContext) {
        let trimmed = cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter a craving description."
            return
        }
        
        let newCraving = WatchCravingEntity(text: trimmed, intensity: intensity)
        context.insert(newCraving)
        
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        // Reset UI state
        cravingDescription = ""
        intensity = 5
        errorMessage = nil
        showConfirmation = true
    }
    
    func dismissError() {
        errorMessage = nil
    }
}
