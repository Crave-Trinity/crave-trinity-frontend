//
//  CravingListView.swift
//  CravePhone
//
//  A simple List to display cravings,
//  pinned tab bar courtesy of CRAVETabView.
//

import SwiftUI

public struct CravingListView: View {
    @StateObject private var viewModel: CravingListViewModel
    
    public init(viewModel: CravingListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
            
            List {
                ForEach(viewModel.cravings, id: \.id) { craving in
                    CravingCard(craving: craving)
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 4)
                }
                .onDelete(perform: deleteCraving)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
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
            
            if viewModel.isLoading {
                ProgressView("Loading…")
                    .padding(40)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                    .font(CraveTheme.Typography.body)
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
    
    private func deleteCraving(at offsets: IndexSet) {
        offsets.forEach { index in
            let craving = viewModel.cravings[index]
            Task {
                await viewModel.archiveCraving(craving)
            }
        }
    }
}
