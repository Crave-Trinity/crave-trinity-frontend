//
//  IntensityInputViewModel.swift
//  CraveWatch
//
//  A placeholder ViewModel for intensity-specific logic, if needed.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import Combine

@MainActor
class IntensityInputViewModel: ObservableObject {
    // MARK: - Published
    @Published var intensity: Int = 5

    // Any domain-specific validations can go here,
    // e.g., ensuring intensity is within 1...10.
    func setIntensity(_ newIntensity: Int) {
        let clamped = max(1, min(10, newIntensity))
        intensity = clamped
    }
}
