//
//  PhoneApp.swift
//  CravePhone
//
//  PURPOSE:
//    - The @main entry point with minimal overhead.
//    - We wrap the root view in SentryTracedView for performance monitoring.
//
//  NOTE:
//    Remove or comment out the `.onAppear { ... }` block
//    after verifying the token is cleared once on a real device.
//

import SwiftUI
import SwiftData
import SentrySwiftUI

@main
struct CRAVEApp: App {
    private let container = DependencyContainer()
    
    // Initialize Sentry in the app's initializer.
    init() {
        SentrySDK.start { options in
            options.dsn = "https://313df134566da34789fef865938493bc@o4508933259198464.ingest.us.sentry.io/4508936692498432"
            options.debug = true  // Debug mode for development
        }
    }
    
    var body: some Scene {
        WindowGroup {
            // Monitor performance with Sentry
            SentryTracedView("RootView") {
                ZStack {
                    // Full-bleed background
                    Color.black.ignoresSafeArea()
                    
                    // Coordinator-driven UI
                    CoordinatorHostView(container: container)
                }
            }
            .onAppear {
                #if DEBUG
                // Clear your Keychain tokens ONE TIME to fix the messed-up state.
                KeychainHelper.clearCraveTokensOnce()
                
                // IMPORTANT: Remove or comment out after verifying it works.
                #endif
            }
            .preferredColorScheme(.dark)
        }
    }
}
