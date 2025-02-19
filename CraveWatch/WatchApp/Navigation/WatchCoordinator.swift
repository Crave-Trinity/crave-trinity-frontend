//
//  WatchCoordinator.swift
//  CraveWatch
//
//  Created by John H Jung on 2/18/25.
//  Description: This coordinator centralizes navigation logic for the watch app.
//               It creates and manages the initial view and future navigation flows.
// Key Fixes:
// • The initializer now uses the argument label 'connectivityService:'.
// • The lazy property is explicitly marked as @MainActor to satisfy main actor isolation.

//
//  WatchCoordinator.swift
//  CraveWatch
//
//  Created by John H Jung on 2/18/25.
//  Description: This coordinator centralizes navigation logic for the watch app.
//               It creates and manages the initial view and future navigation flows.

import SwiftUI
import WatchConnectivity

@MainActor
class WatchCoordinator {
    // MARK: - Dependencies
    private let connectivityService: WatchConnectivityService
    
    // MARK: - State Preservation
    @MainActor private lazy var cravingLogViewModel: CravingLogViewModel = {
        CravingLogViewModel(connectivityService: self.connectivityService)
    }()
    
    // MARK: - Initialization
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    /// Provides the initial view for the watch app.
    var rootView: some View {
        NavigationView {
            CravingLogView(viewModel: self.cravingLogViewModel)
        }
    }
}
