//
//  ResistanceInputViewModel.swift
//  CraveWatch
//
//  A placeholder ViewModel for "resistance" logic, if needed.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import Combine

@MainActor
class ResistanceInputViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// The current resistance value.
    /// This value is expected to be within the range 0...10.
    @Published var resistance: Int = 5

    // MARK: - Methods
    
    /// Updates the resistance value while ensuring it stays within the valid range (0...10).
    ///
    /// - Parameter newResistance: The new resistance value.
    func setResistance(_ newResistance: Int) {
        // Clamp the new resistance value to be at least 0 and at most 10.
        let clamped = max(0, min(10, newResistance))
        resistance = clamped
    }
}
