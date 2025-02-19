//
//  WatchCoordinator.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: Manages top-level watch navigation.
//               Currently returns CravingLogView as the root.
//

import SwiftUI

final class WatchCoordinator {
    let connectivityService: WatchConnectivityService

    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    var rootView: some View {
        // Display the CravingLogView as the main screen
        CravingLogView(connectivityService: connectivityService)
    }
}
