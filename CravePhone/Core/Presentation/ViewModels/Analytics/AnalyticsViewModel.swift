// Core/Presentation/ViewModels/Analytics/AnalyticsViewModel.swift
import SwiftUI
import SwiftData

@MainActor
public final class AnalyticsViewModel: ObservableObject {
    @Published public var isLoading = false
    @Published public var basicStats: BasicAnalyticsResult? // ADDED DECLARATION FOR basicStats
    private let manager: AnalyticsManager  // Receives the manager

    public init(manager: AnalyticsManager) { // Takes AnalyticsManager directly
        self.manager = manager
    }

    // Add your analytics methods here, using self.manager to access AnalyticsManager functionality
    public func loadAnalytics() async {
        isLoading = true
        do {
            basicStats = try await manager.getBasicStats() // Now basicStats is declared and in scope
        } catch {
            print("Failed to load analytics: \(error)")
        }
        isLoading = false
    }
}

