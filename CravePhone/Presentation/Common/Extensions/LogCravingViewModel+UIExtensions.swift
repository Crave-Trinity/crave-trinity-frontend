//
//  LogCravingViewModel+UIExtensions.swift
//  CravePhone
//
//  Extensions to add required properties for new UI components.
//

import Foundation
import SwiftUI

// MARK: - Bridge properties for UI components
extension LogCravingViewModel {
    // Property for validation in new UI
    var isValid: Bool {
        return !cravingDescription.isEmpty && cravingStrength > 0
    }
}
