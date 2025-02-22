//
//  WatchCoordinator.swift
//  CraveWatch
//
//  Orchestrates the watch UI flow. We no longer toggle between
//  "audio" and "cravingLog" because CravingLogView already
//  includes the new audio page inside its TabView.
//
//  (C) 2030
//

import SwiftUI

@MainActor
final class WatchCoordinator: ObservableObject {
    
    // MARK: - Dependencies
    let connectivityService: WatchConnectivityService
    let dependencyContainer: WatchDependencyContainer
    
    // MARK: - Initialization
    init(connectivityService: WatchConnectivityService,
         dependencyContainer: WatchDependencyContainer) {
        self.connectivityService = connectivityService
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - Root View
    var rootView: some View {
        // Instead of switching between two views, we return one unified view:
        // CravingLogView now has a TabView containing:
        //  - AudioRecording as page 0
        //  - Trigger, Intensity, Resistance, Ally, UltraCool pages as pages 1-5
        AnyView(
            CravingLogView(
                viewModel: dependencyContainer.makeCravingViewModel()
            )
        )
    }
}
