//
//  WatchCoordinator.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: Handles watch navigation state and provides a root view.
//

import SwiftUI

final class WatchCoordinator {
    let connectivityService: WatchConnectivityService

    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    var rootView: some View {
        CravingLogView(connectivityService: connectivityService)
    }
}
