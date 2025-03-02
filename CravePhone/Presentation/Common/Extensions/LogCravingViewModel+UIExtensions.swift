//
//  LogCravingViewModel+UIExtensions.swift
//  CravePhone
//
//  RESPONSIBILITY: Adds UI-centric validations or computed properties.
//

import Foundation
import SwiftUI

extension LogCravingViewModel {
    var isValid: Bool {
        // Basic validation
        !cravingDescription.isEmpty && cravingStrength > 0
    }
}
