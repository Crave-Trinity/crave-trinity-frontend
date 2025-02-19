// File: Core/Presentation/ViewModels/Craving/CravingListViewModel.swift

import Foundation
import SwiftUI
import Combine

@MainActor
public final class CravingListViewModel: ObservableObject {
    private let fetchCravingsUseCase: FetchCravingsUseCaseProtocol
    private let archiveCravingUseCase: ArchiveCravingUseCaseProtocol
    
    @Published public private(set) var cravings: [CravingEntity] = []
    @Published public private(set) var errorMessage: String?

    public init(fetchCravingsUseCase: FetchCravingsUseCaseProtocol,
                archiveCravingUseCase: ArchiveCravingUseCaseProtocol) {
        self.fetchCravingsUseCase = fetchCravingsUseCase
        self.archiveCravingUseCase = archiveCravingUseCase
    }
    
    // Renamed method to match your view calls
    public func fetchCravings() async {
        do {
            cravings = try await fetchCravingsUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    public func archiveCraving(_ craving: CravingEntity) async {
        do {
            try await archiveCravingUseCase.execute(craving)
            // Refresh the list after archiving
            await fetchCravings()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

