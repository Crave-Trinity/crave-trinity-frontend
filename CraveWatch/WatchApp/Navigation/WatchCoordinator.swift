//WatchCoordinator.swift

import SwiftUI

/// Manages navigation flows on the watch.
/// This is often optional for watchOS, but if you have multiple screens or flows,
/// a coordinator helps keep logic out of the SwiftUI views.
class WatchCoordinator {
    
    // Example service references
    private let watchConnectivityService: WatchConnectivityService
    
    // Store references to each possible root or subview
    // In reality, you might have multiple subflows: e.g., VitalsView, CravingLogView, etc.
    
    init(watchConnectivityService: WatchConnectivityService) {
        self.watchConnectivityService = watchConnectivityService
    }

    /// The initial view for the watch app.
    /// Could be a `TabView` for watchOS or a single main view that navigates deeper.
    var rootView: some View {
        // For example, an entry point that shows a log screen or a vitals screen
        // Right now, let's just show a placeholder:
        CravingLogView(
            viewModel: CravingLogViewModel(
                watchConnectivityService: watchConnectivityService
            )
        )
    }
}

