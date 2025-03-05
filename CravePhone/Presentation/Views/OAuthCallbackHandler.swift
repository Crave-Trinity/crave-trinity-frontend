//
//  OAuthCallbackHandler.swift
//  CravePhone/Presentation/Views
//
//  PURPOSE: If using a custom scheme, handle the returning URL from Safari.
//  NOTE: Usually not needed with the latest GoogleSignIn library, but included if your flow requires.
//
//  USAGE:
//   1) In your AppDelegate's openURL function, call `OAuthCallbackHandler.shared.handleOpenURL(url:)`
//   2) Provide user-friendly errors or success states here
//
import SwiftUI

final class OAuthCallbackHandler: ObservableObject {
    static let shared = OAuthCallbackHandler()
    
    @Published var errorMessage: String?
    
    private init() {}
    
    func handleOpenURL(_ url: URL) -> Bool {
        // If your custom scheme is "com.example.oauth:/", parse the fragments or query for tokens
        // Then route them to your view model or store them in Keychain
        // Return true if handled, false otherwise
        return false
    }
}
