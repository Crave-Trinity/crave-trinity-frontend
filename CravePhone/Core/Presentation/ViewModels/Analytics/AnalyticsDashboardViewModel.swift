//
//  AnalyticsDashboardViewModel.swift
//  CravePhone
//
//  Created by ...
//  Updated for unified SOLID approach
//

import Foundation
import SwiftUI

@MainActor
public final class AnalyticsDashboardViewModel: ObservableObject {
    // Dependencies
    private let manager: AnalyticsManager
    
    // Published state
    @Published public var basicStats: BasicAnalyticsResult?
    @Published public var alertInfo: AlertInfo?
    @Published public var isLoading: Bool = false

    public init(manager: AnalyticsManager) {
        self.manager = manager
    }
    
    public func loadAnalytics() async {
        isLoading = true
        do {
            let result = try await manager.getBasicStats()
            basicStats = result
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }
}
