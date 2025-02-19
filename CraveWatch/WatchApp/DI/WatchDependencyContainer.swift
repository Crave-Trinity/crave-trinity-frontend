//
//  WatchDependencyContainer.swift
//  CraveWatch
//
//  Description: Centralizes watch dependencies like the connectivity service,
//               so any view can easily access them.
//

import SwiftUI

final class WatchDependencyContainer: ObservableObject {
    // WatchConnectivityService is the main link to the phone
    @Published var connectivityService = WatchConnectivityService()
    
    // The coordinator manages top-level watch navigation.
    lazy var watchCoordinator = WatchCoordinator(
        connectivityService: connectivityService
    )
    
    init() {
        // Any additional setup can happen here
    }
}
