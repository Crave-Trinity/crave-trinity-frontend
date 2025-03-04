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

@main
struct CRAVEApp: App {
    private let container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Full-bleed background
                Color.black.ignoresSafeArea()

                // Coordinator-driven UI
                CoordinatorHostView(container: container)
            }
            .preferredColorScheme(.dark)
        }
    }
}
