//WatchDependencyContainer.swift
import Foundation
import WatchConnectivity

/// A lightweight container that holds references to core services
/// (like WatchConnectivity, domain use cases, etc.).
class WatchDependencyContainer: ObservableObject {

    // MARK: - Services
    let watchConnectivityService: WatchConnectivityService
    
    // MARK: - Coordinator
    let watchCoordinator: WatchCoordinator
    
    init() {
        // Initialize core watch services
        self.watchConnectivityService = WatchConnectivityService()
        
        // Initialize your watch coordinator and pass any services it needs
        self.watchCoordinator = WatchCoordinator(
            watchConnectivityService: watchConnectivityService
        )
        
        // If you need to do any additional setup (e.g., watchConnectivityService.activateSession()), do it here
        self.watchConnectivityService.activateSession()
    }
}

