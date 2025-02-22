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

/// The WatchCoordinator orchestrates the navigation and overall UI flow for the watch app.
/// It consolidates the app’s entry view into a single unified screen.
@MainActor
final class WatchCoordinator: ObservableObject {
    
    // MARK: - Dependencies
    
    /// Service managing connectivity with the paired iOS device.
    let connectivityService: WatchConnectivityService
    
    /// The container for shared dependencies.
    let dependencyContainer: WatchDependencyContainer
    
    // MARK: - Initialization
    
    /// Initializes the WatchCoordinator with its required dependencies.
    /// - Parameters:
    ///   - connectivityService: Manages communication between the watch and its paired device.
    ///   - dependencyContainer: Provides shared resources and factory methods for creating view models.
    init(connectivityService: WatchConnectivityService,
         dependencyContainer: WatchDependencyContainer) {
        self.connectivityService = connectivityService
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - Root View
    
    /// Returns the root view for the watch app's UI.
    /// This unified view encapsulates all the necessary components, including a tab-based layout for audio recording
    /// and other related pages.
    var rootView: some View {
        AnyView(
            CravingLogView(
                viewModel: dependencyContainer.makeCravingViewModel()
            )
        )
    }
}
