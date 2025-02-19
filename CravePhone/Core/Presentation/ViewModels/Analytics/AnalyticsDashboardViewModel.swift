// File: Core/Presentation/ViewModels/Analytics/AnalyticsDashboardViewModel.swift

import Foundation
import SwiftUI
import Combine

@MainActor
public final class AnalyticsDashboardViewModel: ObservableObject {
    private let manager: AnalyticsManager
    
    // Expose only what you need; keep anything else private or internal.
    @Published public private(set) var basicStats: BasicAnalyticsResult?
    @Published public private(set) var errorMessage: String?

    public init(manager: AnalyticsManager) {
        self.manager = manager
    }
    
    public func loadAnalytics() async {
        do {
            let result = try await manager.getBasicStats()
            self.basicStats = result
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
