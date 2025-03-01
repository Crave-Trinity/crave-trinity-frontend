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
    
    // Maps internal properties to UI naming
    var selectedEmotions: Set<String> {
        return Set(Array(_selectedEmotions))
    }
    
    private var _selectedEmotions: [String] {
        get {
            return Array(selectedEmotions)
        }
        set {
            // This is just for compilation, not used since we're using the computed property
        }
    }
}

// MARK: - Bridge methods for ChatViewModel
extension ChatViewModel {
    func sendWelcomeMessage() {
        let message = Message(
            content: "Welcome to CRAVE. How can I help you manage your cravings today?",
            isUser: false
        )
        messages.append(message)
    }
}
