// File: PhoneApp.swift (or CRAVEApp.swift)
// PURPOSE: Application’s main entry point.
// DESIGN: Minimal overhead; forces fresh login on launch (for testing).
// NOTE: Remove token clearing for production.
import SwiftUI
import SwiftData
import SentrySwiftUI

@main
struct CRAVEApp: App {
    private let container = DependencyContainer()
    
    init() {
        SentrySDK.start { options in
            options.dsn = "YOUR_SENTRY_DSN"
            options.debug = true
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SentryTracedView("RootView") {
                ZStack {
                    Color.black.ignoresSafeArea()
                    CoordinatorHostView(container: container)
                }
            }
            .onAppear {
                // Force fresh login every launch (for testing)
                KeychainHelper.clearCraveTokensOnce()
                // For production, comment or remove this line.
            }
            .preferredColorScheme(.dark)
        }
    }
}
