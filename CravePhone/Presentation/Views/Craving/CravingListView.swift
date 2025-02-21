//
//  CravingListView.swift
//  CravePhone
//
//  Directory: CravePhone/Core/Presentation/Views/Craving/CravingListView.swift
//
//  Description:
//    A simple list of cravings, each row is a CravingCard. Uses a ViewModel to fetch
//    cravings, and refreshable for pull-to-refresh. Adheres to MVVM, SOLID, and
//    Single Responsibility: displaying a list of CravingEntities.
//
//  Created by <Your Name> on <date>.
//  Updated by ChatGPT on <today's date>.
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
                // Main content
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
            // Alerts
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

#if DEBUG
// MARK: - Preview & Mocks
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
