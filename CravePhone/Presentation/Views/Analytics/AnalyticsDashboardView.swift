//
//  AnalyticsDashboardView.swift
//  CravePhone
//
//  Description:
//    A SwiftUI screen displaying aggregated craving analytics and insights,
//    reintroduced for the main tab navigation.
//
//  Uncle Bob + Steve Jobs notes:
//    - Clear data flow from the ViewModel (MVVM).
//    - Minimal, Apple-like design with crisp colors and spacing.
//
import SwiftUI

public struct AnalyticsDashboardView: View {
    
    @ObservedObject var viewModel: AnalyticsViewModel
    
    public init(viewModel: AnalyticsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                // Background color or gradient
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("Loading Analytics...")
                        .foregroundColor(.white)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            headerSection
                            statsSection
                            Spacer(minLength: 50)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.loadAnalytics()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                            .foregroundColor(.white)
                    }
                }
            }
            .alert(item: $viewModel.alertInfo) { info in
                Alert(title: Text(info.title),
                      message: Text(info.message),
                      dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            Task {
                await viewModel.loadAnalytics()
            }
        }
    }
    
    // MARK: - Subviews
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("📊 Craving Analytics")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
            Text("Explore patterns, frequencies, and personal insights.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 8)
    }
    
    private var statsSection: some View {
        VStack(spacing: 12) {
            if let stats = viewModel.basicStats {
                // Example UI for average intensity & count
                Text("Average Intensity: \(String(format: "%.1f", stats.averageIntensity))")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Total Cravings: \(stats.totalCravings)")
                    .font(.title2)
                    .foregroundColor(.white)
                
                // Additional metrics or charts
                // e.g., Time-of-day chart or line graph
                // AnalyticsCharts(data: stats.distributionData)
                
            } else {
                Text("No analytics available yet.")
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
