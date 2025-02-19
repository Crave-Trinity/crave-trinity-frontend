//
//  WatchDependencyContainer.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: Central place to construct watch dependencies,
//               e.g., the connectivity service and coordinator.
//

import SwiftUI

final class WatchDependencyContainer: ObservableObject {
    // WatchConnectivityService for sending data to phone
    @Published var connectivityService = WatchConnectivityService()
    
    // The watch coordinator handles top-level navigation
    lazy var watchCoordinator = WatchCoordinator(connectivityService: connectivityService)
    
    init() {
        // Any additional setup if needed
    }
}
