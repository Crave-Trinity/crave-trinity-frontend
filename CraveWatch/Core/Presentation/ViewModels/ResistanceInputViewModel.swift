//
//  ResistanceInputViewModel.swift
//  CraveWatch
//
//  A placeholder ViewModel for "resistance" logic, if needed.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import Combine

@MainActor
class ResistanceInputViewModel: ObservableObject {
    // MARK: - Published
    @Published var resistance: Int = 5

    // Suppose we have a domain rule that resistance must be 0...10
    func setResistance(_ newResistance: Int) {
        let clamped = max(0, min(10, newResistance))
        resistance = clamped
    }
}
