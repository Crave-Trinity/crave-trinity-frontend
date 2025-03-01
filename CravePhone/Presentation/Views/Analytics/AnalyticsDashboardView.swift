//
//  AnalyticsDashboardView.swift
//  CravePhone
//
//  Description:
//    A SwiftUI screen displaying aggregated craving analytics and insights.
//
//  Uncle Bob + Steve Jobs notes:
//    - Single Responsibility: Displays analytics info from the VM, minimal logic.
//    - Open/Closed: We can add more analytics cards, charts, etc. without changing existing code.
//  GoF & SOLID:
//    - The 'View' depends on an 'AnalyticsViewModel' abstraction for data, no direct DB calls.
//    - Use of SwiftUI's composition for subviews (headerSection, statsSection).
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
                // Use theme’s gradient
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                // Loading or main content
                if viewModel.isLoading {
                    ProgressView("Loading Analytics…")
                        .foregroundColor(CraveTheme.Colors.primaryText)
                        .font(CraveTheme.Typography.subheading)
                } else {
                    ScrollView {
                        VStack(spacing: CraveTheme.Spacing.medium) {
                            headerSection
                            statsSection
                            Spacer(minLength: 50)
                        }
                        .padding(CraveTheme.Spacing.medium)
                    }
                }
            }
            // Force the content to stretch
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                            .foregroundColor(CraveTheme.Colors.primaryText)
                    }
                }
            }
            .alert(item: $viewModel.alertInfo) { info in
                Alert(
                    title: Text(info.title),
                    message: Text(info.message),
                    dismissButton: .default(Text("OK"))
                )
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
        VStack(alignment: .leading, spacing: CraveTheme.Spacing.small) {
            Text("📊 Craving Analytics")
                .font(CraveTheme.Typography.heading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            
            Text("Explore patterns, frequencies, and personal insights.")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, CraveTheme.Spacing.small)
    }
    
    private var statsSection: some View {
        VStack(spacing: CraveTheme.Spacing.small) {
            if let stats = viewModel.basicStats {
                // Example metrics
                Text("Average Intensity: \(String(format: "%.1f", stats.averageIntensity))")
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                Text("Average Resistance: \(String(format: "%.1f", stats.averageResistance))")
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                Text("Total Cravings: \(stats.totalCravings)")
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                // Potential place for charts, distribution data, etc.
                
            } else {
                Text("No analytics available yet.")
                    .font(CraveTheme.Typography.body)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                    .padding()
            }
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(CraveTheme.Layout.cornerRadius)
        .shadow(radius: 4)
    }
}
