//
//  CravingListView.swift
//  CravePhone
//
//  Created by ...
//  Updated by ChatGPT on ...
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
                // 1) The main list
                List {
                    ForEach(viewModel.cravings, id: \.id) { craving in
                        CravingCard(craving: craving)
                    }
                    .onDelete(perform: deleteCraving)
                }
                .navigationTitle("Cravings")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                .refreshable {
                    await viewModel.fetchCravings()
                }
                .onAppear {
                    Task {
                        await viewModel.fetchCravings()
                    }
                }
                
                // 2) Optional loading overlay
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding(40)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                }
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

// MARK: - PREVIEW
#if DEBUG
struct CravingListView_Previews: PreviewProvider {
    static var previews: some View {
        CravingListView(
            viewModel: CravingListViewModel(
                fetchCravingsUseCase: MockFetchCravingsUseCase(),
                archiveCravingUseCase: MockArchiveCravingUseCase()
            )
        )
    }
}

// MARK: - Mock Classes for Preview

fileprivate class MockFetchCravingsUseCase: FetchCravingsUseCaseProtocol {
    func execute() async throws -> [CravingEntity] {
        [
            CravingEntity(text: "Mock Craving #1"),
            CravingEntity(text: "Mock Craving #2")
        ]
    }
}

fileprivate class MockArchiveCravingUseCase: ArchiveCravingUseCaseProtocol {
    func execute(_ craving: CravingEntity) async throws {
        // No-op
    }
}
#endif
