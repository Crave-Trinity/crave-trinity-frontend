//
//  LogCravingViewModel+UIExtensions.swift
//  CravePhone
//
//  Extensions to add required UI-centric properties or validations for new UI components.
//  Make sure we do NOT redefine the same properties as the main model.
//

import Foundation
import SwiftUI

extension LogCravingViewModel {
    
    /// Validation property for new UI components.
    /// We rely on the real `cravingDescription` and `cravingStrength`
    /// published in LogCravingViewModel.swift.
    var isValid: Bool {
        return !cravingDescription.isEmpty && cravingStrength > 0
    }
}
