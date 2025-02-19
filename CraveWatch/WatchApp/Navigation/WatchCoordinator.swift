//
//  WatchCoordinator.swift
//  CraveWatch
//
//  Description: Handles watch navigation state and provides a root view.
//

import SwiftUI

final class WatchCoordinator {
    let connectivityService: WatchConnectivityService

    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    // You can choose your initial watch screen here.
    // For now, we show CravingLogView as the root.
    var rootView: some View {
        CravingLogView(connectivityService: connectivityService)
    }
}
