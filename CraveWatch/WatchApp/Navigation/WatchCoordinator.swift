//
//  WatchCoordinator.swift
//  CraveWatch
//
//  Created by John H Jung on 2/18/25.
//  Description: This coordinator centralizes navigation logic for the watch app.
//               It creates and manages the initial view and future navigation flows.
//

import SwiftUI
import WatchConnectivity

@MainActor
class WatchCoordinator {
    // MARK: - Dependencies
    private let connectivityService: WatchConnectivityService

    // MARK: - Initialization
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }

    /// Provides the initial view for the watch app.
    var rootView: some View {
        NavigationView {
            // Pass the connectivityService directly to CravingLogView
            CravingLogView(connectivityService: self.connectivityService)
        }
    }
}
