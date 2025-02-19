// CRAVEApp/App/Views/Craving/CravingListView.swift
import SwiftUI

public struct CravingListView: View {
    @StateObject private var viewModel: CravingListViewModel

    public init(viewModel: CravingListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView { // Embed in NavigationView for title
            List {
                ForEach(viewModel.cravings, id: \.id) { craving in
                    CravingCard(craving: craving) // Using CravingCard for each craving
                }
                .onDelete(perform: deleteCraving)
            }
            .navigationTitle("Cravings") // Set navigation title
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

struct CravingListView_Previews: PreviewProvider {
    static var previews: some View {
        CravingListView(viewModel: CravingListViewModel(fetchCravingsUseCase: MockFetchCravingsUseCase(), archiveCravingUseCase: MockArchiveCravingUseCase()))
            .environmentObject(DependencyContainer())
    }
}

// Mock Use Cases for Preview - Mock FetchCravingsUseCaseProtocol
final class MockFetchCravingsUseCase: FetchCravingsUseCaseProtocol {
    func execute() async throws -> [CravingEntity] {
        [
            CravingEntity(text: "Sample Craving 1"),
            CravingEntity(text: "Another Craving")
        ]
    }
}

// Mock Use Cases for Preview - MockArchiveCravingUseCaseProtocol
final class MockArchiveCravingUseCase: ArchiveCravingUseCaseProtocol {
    func execute(_ craving: CravingEntity) async throws {
        // do nothing
    }
}


