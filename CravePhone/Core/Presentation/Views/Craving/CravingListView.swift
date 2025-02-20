//
//  CravingListView.swift
//  CravePhone
//
//  Description:
//    A simple list of cravings, each row is a CravingCard.
//    Uses navigationTitle("Cravings") and refreshable.
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
                // Main list
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
                    Task { await viewModel.fetchCravings() }
                }
                
                // Loading overlay
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding(40)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                }
            }
            .alert(item: $viewModel.alertInfo) { info in
                Alert(title: Text(info.title),
                      message: Text(info.message),
                      dismissButton: .default(Text("OK")))
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

// MARK: - Preview
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

// Example mocks
fileprivate class MockFetchCravingsUseCase: FetchCravingsUseCaseProtocol {
    func execute() async throws -> [CravingEntity] {
        [
            CravingEntity(text: "Sample Craving #1"),
            CravingEntity(text: "Sample Craving #2")
        ]
    }
}
fileprivate class MockArchiveCravingUseCase: ArchiveCravingUseCaseProtocol {
    func execute(_ craving: CravingEntity) async throws {}
}
#endif
