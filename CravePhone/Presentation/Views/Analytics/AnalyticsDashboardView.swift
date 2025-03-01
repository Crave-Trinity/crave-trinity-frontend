/*
 ┌───────────────────────────────────────────────────────────┐
 │  Directory: CravePhone/Views/Analytics                  │
 │  Production-Ready SwiftUI Layout Fix: AnalyticsDashboardView │
 │  Notes:                                                 │
 │   - Tightened vertical spacing.                         │
 │   - Clear section grouping with moderate padding.       │
 └───────────────────────────────────────────────────────────┘
*/

import SwiftUI

public struct AnalyticsDashboardView: View {
    
    @ObservedObject var viewModel: AnalyticsViewModel
    
    public init(viewModel: AnalyticsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("Loading Analytics…")
                        .foregroundColor(CraveTheme.Colors.primaryText)
                        .font(CraveTheme.Typography.subheading)
                } else {
                    ScrollView {
                        VStack(spacing: CraveTheme.Spacing.small) {
                            headerSection
                            statsSection
                            Spacer(minLength: 40)
                        }
                        .padding(.all, CraveTheme.Spacing.medium)
                    }
                }
            }
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
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("📊 Craving Analytics")
                .font(CraveTheme.Typography.heading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            
            Text("Explore patterns, frequencies, and personal insights.")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
    }
    
    private var statsSection: some View {
        VStack(spacing: 8) {
            if let stats = viewModel.basicStats {
                Text("Average Intensity: \(String(format: "%.1f", stats.averageIntensity))")
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                Text("Average Resistance: \(String(format: "%.1f", stats.averageResistance))")
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                Text("Total Cravings: \(stats.totalCravings)")
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
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

