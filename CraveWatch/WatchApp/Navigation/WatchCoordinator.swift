//
//  WatchCoordinator.swift
//  CraveWatch
//
//  Orchestrates the main watch UI flow.
//  (C) 2030
//

import SwiftUI

@MainActor
final class WatchCoordinator {
    let connectivityService: WatchConnectivityService
    
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    // The main watch UI
    var rootView: some View {
        // Typically you'd pass in the container from the environment, but we can
        // do so from the dependency container for demonstration:
        let container = WatchDependencyContainer()
        return CravingLogView(viewModel: container.makeCravingViewModel())
    }
}
