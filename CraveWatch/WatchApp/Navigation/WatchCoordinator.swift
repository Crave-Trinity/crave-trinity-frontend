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
import SwiftUI
import WatchConnectivity

@MainActor
class WatchCoordinator {
    // MARK: - Dependencies
    private let connectivityService: WatchConnectivityService
    
    // MARK: - State Preservation
    // Marking the lazy property with @MainActor ensures the call to the main actor–isolated initializer is allowed.
    @MainActor private lazy var cravingLogViewModel: CravingLogViewModel = {
        // This initializer call is now performed on the main actor.
        CravingLogViewModel(connectivityService: self.connectivityService)
    }()
    
    // MARK: - Initialization
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    /// Provides the initial view for the watch app.
    var rootView: some View {
        CravingLogView(viewModel: self.cravingLogViewModel)
    }
}
