//
//  CravingListViewModel.swift
//  CravePhone
//
//  Created by John H Jung on ...
//  Updated by ChatGPT on ...
//

import SwiftUI
import Combine

@MainActor
public final class CravingListViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let fetchCravingsUseCase: FetchCravingsUseCaseProtocol
    private let archiveCravingUseCase: ArchiveCravingUseCaseProtocol
    
    // MARK: - Published Properties
    @Published public private(set) var cravings: [CravingEntity] = []
    @Published public var alertInfo: AlertInfo?  // <-- Add this line
    @Published public var isLoading: Bool = false

    // MARK: - Init
    public init(fetchCravingsUseCase: FetchCravingsUseCaseProtocol,
                archiveCravingUseCase: ArchiveCravingUseCaseProtocol) {
        self.fetchCravingsUseCase = fetchCravingsUseCase
        self.archiveCravingUseCase = archiveCravingUseCase
    }
    
    // MARK: - Public Methods
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
            await fetchCravings() // Refresh the list
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }
}
