//
//  PhoneApp.swift
//  CravePhone
//
//  PURPOSE:
//    - The @main entry point. We extend the background color everywhere,
//      but let SwiftUI manage safe areas naturally.
//    - This prevents conflicting safe-area calculations that can lead
//      to negative frame dimensions.
//    - UNCLE BOB / STEVE JOBS STYLE: Keep things minimal and let the system do its job.
//
//  NOTE:
//    We removed the custom SafeAreaInsetsEnvironmentReader from the top-level view.
//    If you still need safe area insets in your subviews, consider applying the modifier at a lower level.

import SwiftUI
import SwiftData
import SentrySwiftUI  // Imports both Sentry and SwiftUI instrumentation features

@main
struct CRAVEApp: App {
    private let container = DependencyContainer()
    
    // Initialize Sentry in the app's initializer.
    init() {
        SentrySDK.start { options in
            options.dsn = "https://313df134566da34789fef865938493bc@o4508933259198464.ingest.us.sentry.io/4508936692498432"
            options.debug = true  // Enable debug mode for development. Remove or set to false for production.
            // Optionally, configure additional options:
            // options.environment = "development"
            // options.releaseName = "cravephone@1.0.0"
        }
    }
    
    var body: some Scene {
        WindowGroup {
            // Wrap the root view in a SentryTracedView to monitor performance.
            SentryTracedView("RootView") {
                ZStack {
                    // Full-bleed background
                    Color.black.ignoresSafeArea()
                    
                    // Coordinator-driven UI
                    CoordinatorHostView(container: container)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
