//
//  CravingListView.swift
//  CravePhone
//
//  Description:
//    Displays a List of cravings. Each row is a CravingCard.
//    Adheres to MVVM & SOLID by offloading data fetching to the VM.
//
//  Uncle Bob notes:
//    - Single Responsibility: Just a list + some refresh logic, no data logic in the View.
//    - Open/Closed: We can easily add new sections, custom row styling, etc.
//  GoF & SOLID:
//    - The list is user interface logic; the actual data is from 'CravingListViewModel'.
//    - Follows "Dependency Inversion": The view depends on an abstracted VM, not direct data sources.
//

import SwiftUI

public struct CravingListView: View {
    @StateObject private var viewModel: CravingListViewModel
    
    public init(viewModel: CravingListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            ZStack {
                // Gradient behind the list
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                List {
                    ForEach(viewModel.cravings, id: \.id) { craving in
                        CravingCard(craving: craving)
                            .listRowBackground(Color.clear) // Let the gradient show
                    }
                    .onDelete(perform: deleteCraving)
                }
                .scrollContentBackground(.hidden) // iOS 16+ hides default list bg
                .navigationTitle("Cravings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                            .foregroundColor(CraveTheme.Colors.primaryText)
                    }
                }
                .refreshable {
                    await viewModel.fetchCravings()
                }
                .onAppear {
                    Task { await viewModel.fetchCravings() }
                }
                
                // Loading overlay
                if viewModel.isLoading {
                    ProgressView("Loading…")
                        .padding(40)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                        .font(CraveTheme.Typography.body)
                }
            }
            // Force full screen usage
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert(item: $viewModel.alertInfo) { info in
                Alert(
                    title: Text(info.title),
                    message: Text(info.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func deleteCraving(at offsets: IndexSet) {
        offsets.forEach { index in
            let craving = viewModel.cravings[index]
            Task {
                await viewModel.archiveCraving(craving)
            }
        }
    }
}
