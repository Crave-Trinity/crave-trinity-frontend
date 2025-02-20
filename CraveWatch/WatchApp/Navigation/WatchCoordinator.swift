//
//  WatchCoordinator.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: Manages top-level watch navigation. Currently returns CravingLogView as the root view.
//

import SwiftUI

final class WatchCoordinator {
    let connectivityService: WatchConnectivityService

    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }
    
    @MainActor
    var rootView: some View {
        let viewModel = CravingLogViewModel(connectivityService: connectivityService)
        return CravingLogView(viewModel: viewModel)
    }
}

