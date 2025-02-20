//
//  WatchDependencyContainer.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: Provides shared dependencies for the watch app, including the connectivity service and coordinator.
//

import SwiftUI

final class WatchDependencyContainer: ObservableObject {
    // Shared connectivity service for watch-to-phone communication.
    @Published var connectivityService: WatchConnectivityService = WatchConnectivityService()
    
    // The watch coordinator is created lazily and uses the connectivity service.
    lazy var watchCoordinator: WatchCoordinator = {
        WatchCoordinator(connectivityService: connectivityService)
    }()
}

