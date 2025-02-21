//
//  AnalyticsViewModel.swift
//  CravePhone
//
//  Created by ...
//  Updated by ChatGPT on ...
//

import SwiftUI
import Combine

@MainActor
public final class AnalyticsViewModel: ObservableObject {
    
    private let manager: AnalyticsManager
    
    @Published public var isLoading: Bool = false
    @Published public var basicStats: BasicAnalyticsResult?
    @Published public var alertInfo: AlertInfo?  // Add this if you reference alertInfo

    public init(manager: AnalyticsManager) {
        self.manager = manager
    }

    public func loadAnalytics() async {
        isLoading = true
        do {
            basicStats = try await manager.getBasicStats()
        } catch {
            alertInfo = AlertInfo(title: "Analytics Error", message: error.localizedDescription)
        }
        isLoading = false
    }
}
