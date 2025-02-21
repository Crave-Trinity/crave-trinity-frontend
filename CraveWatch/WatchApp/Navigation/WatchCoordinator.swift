//
//  WatchCoordinator.swift
//  CraveWatch
//
//  Created by YourName on SomeDate
//
//  Uncle Bob–approved final version
//

import SwiftUI

@MainActor
final class WatchCoordinator {
    // MARK: - Properties
    
    let connectivityService: WatchConnectivityService

    // MARK: - Initialization
    
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }

    // MARK: - Root View
    
    /// The main entry point for the watch app’s UI.
    var rootView: some View {
        // Return ONLY the CravingLogView now.
        CravingLogView(
            viewModel: WatchDependencyContainer().makeCravingViewModel() // Create a NEW container here.
        )
    }

    // MARK: - Offline Sync Manager
    
    /// Creates and returns a main-actor–isolated OfflineCravingSyncManager.
    func makeOfflineSyncManager() -> OfflineCravingSyncManager {
        OfflineCravingSyncManager(
            localStore: LocalCravingStore(),
            watchConnectivityService: connectivityService
        )
    }
}
