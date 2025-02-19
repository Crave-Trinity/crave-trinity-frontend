// Core/Presentation/Views/Analytics/AnalyticsDashboardView.swift
import SwiftUI
import SwiftData // Import SwiftData here

public struct AnalyticsDashboardView: View {
    @StateObject private var viewModel: AnalyticsDashboardViewModel

    public init(viewModel: AnalyticsDashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack {
            if let stats = viewModel.basicStats {
                Text("Total Cravings: \(stats.totalCravings)")
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.loadAnalytics()
        }
    }
}

// Corrected Preview Provider
struct AnalyticsDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a REAL (but in-memory) DependencyContainer for the preview.
        let previewContainer = DependencyContainer()
        
        // Use the container to create the ViewModel, just like in the real app.
        AnalyticsDashboardView(viewModel: previewContainer.makeAnalyticsDashboardViewModel())
            .environmentObject(previewContainer) // Inject the container into the environment.
    }
}

