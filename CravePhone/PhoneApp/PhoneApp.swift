//
//  PhoneApp.swift
//  CravePhone
//
//  PURPOSE:
//    - The @main entry point. We ignore safe areas at the top-level,
//      so everything physically extends behind the notch/home indicator.
//    - We apply our SafeAreaInsetsEnvironmentReader so subviews can read
//      the real safeAreaInsets from the environment if needed.
//
//  UNCLE BOB / SOLID:
//    - Single Responsibility: Launch the SwiftUI scene with the coordinator.
//

import SwiftUI
import SwiftData

@main
struct CRAVEApp: App {
    
    private let container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // This ensures the background color extends everywhere
                Color.black
                    .ignoresSafeArea()

                // Show the app's coordinator-driven UI
                CoordinatorHostView(container: container)
            }
            // Apply the environment reader so child views can see real safeAreaInsets,
            // even though we're ignoring safe areas at this top level
            .modifier(SafeAreaInsetsEnvironmentReader())
            .preferredColorScheme(.dark)
        }
    }
}
