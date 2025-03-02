//
//  PhoneApp.swift
//  CravePhone
//
//  - The @main entry.
//  - Standard safe area usage here, so each screen can override if needed.
//

import SwiftUI
import SwiftData

@main
struct CRAVEApp: App {
    
    private let container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            CoordinatorHostView(container: container)
                .preferredColorScheme(.dark)
        }
    }
}
