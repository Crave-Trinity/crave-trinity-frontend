//
//  PhoneApp.swift
//  CravePhone
//
//  PURPOSE:
//    - The @main entry point. We ignore safe areas right at the top-level
//      so everything physically extends behind the notch/home indicator.
//
//  UNCLE BOB / SOLID:
//    - Single Responsibility: Launching the SwiftUI scene with the coordinator.
//
//  LAST UPDATED: <today's date>
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
                    
                CoordinatorHostView(container: container)
            }
            .preferredColorScheme(.dark)
        }
    }
}
