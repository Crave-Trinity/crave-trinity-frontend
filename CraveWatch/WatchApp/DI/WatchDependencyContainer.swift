//
//  WatchDependencyContainer.swift
//  CraveWatch
//
//  Created by John H Jung on 2/18/25.
//  Description: A lightweight container that holds references to core services
//               (like WatchConnectivity, domain use cases, etc.) and provides them to the watch coordinator.
//
import Foundation
import WatchConnectivity

@MainActor
class WatchDependencyContainer: ObservableObject {
    
    // MARK: - Services
    let watchConnectivityService: WatchConnectivityService
    
    // MARK: - Coordinator
    let watchCoordinator: WatchCoordinator
    
    init() {
        // Initialize the watch connectivity service.
        self.watchConnectivityService = WatchConnectivityService()
        
        // IMPORTANT: Use the correct argument label. Our WatchCoordinator expects 'connectivityService:'.
        self.watchCoordinator = WatchCoordinator(connectivityService: watchConnectivityService)
        
        // No extra activation call is needed, as WatchConnectivityService activates its session in its init.
    }
}
