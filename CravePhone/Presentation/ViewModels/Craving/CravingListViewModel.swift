
/* -----------------------------------------
   CravingListViewModel.swift
   ----------------------------------------- */
import SwiftUI
import Combine

@MainActor
public final class CravingListViewModel: ObservableObject {
    
    private let fetchCravingsUseCase: FetchCravingsUseCaseProtocol
    private let archiveCravingUseCase: ArchiveCravingUseCaseProtocol
    
    @Published public private(set) var cravings: [CravingEntity] = []
    @Published public var alertInfo: AlertInfo?
    @Published public var isLoading: Bool = false
    
    public init(fetchCravingsUseCase: FetchCravingsUseCaseProtocol,
                archiveCravingUseCase: ArchiveCravingUseCaseProtocol) {
        self.fetchCravingsUseCase = fetchCravingsUseCase
        self.archiveCravingUseCase = archiveCravingUseCase
    }
    
    public func fetchCravings() async {
        do {
            isLoading = true
            cravings = try await fetchCravingsUseCase.execute()
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }
    
    public func archiveCraving(_ craving: CravingEntity) async {
        do {
            isLoading = true
            try await archiveCravingUseCase.execute(craving)
            await fetchCravings()
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }
}

