//
//  LogCravingViewModel+UIExtensions.swift
//  CravePhone
//
//  RESPONSIBILITY:
//   - UI-centric validations or computed properties for LogCravingViewModel.
//

import Foundation

extension LogCravingViewModel {
    
    /// Basic validation: requires non-empty description and a positive strength.
    var isValid: Bool {
        !cravingDescription.isEmpty && cravingStrength > 0
    }
}
