//
//  IntensityInputViewModel.swift
//  CraveWatch
//
//  A placeholder ViewModel for intensity-specific logic, if needed.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import Combine

@MainActor
class IntensityInputViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// The current intensity value.
    /// This value is expected to be within the range 1...10.
    @Published var intensity: Int = 5

    // MARK: - Methods
    
    /// Updates the intensity value while ensuring it stays within the valid range (1...10).
    ///
    /// - Parameter newIntensity: The new intensity value.
    func setIntensity(_ newIntensity: Int) {
        // Clamp the new intensity value to be at least 1 and at most 10.
        let clamped = max(1, min(10, newIntensity))
        intensity = clamped
    }
}
