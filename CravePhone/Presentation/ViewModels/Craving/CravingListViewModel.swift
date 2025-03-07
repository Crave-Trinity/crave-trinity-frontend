//
//  CravingListViewModel.swift
//  CravePhone
//
//  Manages list retrieval, refreshing, and archiving of cravings.
//
import SwiftUI
import Foundation

@MainActor
public class CravingListViewModel: ObservableObject {
    @Published public var cravings: [CravingEntity] = []
    @Published public var isLoading: Bool = false
    @Published public var alertInfo: AlertInfo?
    
    private let cravingRepo: CravingRepository
    
    public init(cravingRepo: CravingRepository) {
        self.cravingRepo = cravingRepo
    }
    
    public func fetchCravings() async {
        isLoading = true
        do {
            let activeCravings = try await cravingRepo.fetchActiveCravings()
            cravings = activeCravings
        } catch {
            alertInfo = AlertInfo(
                title: "Error",
                message: "Failed to fetch cravings: \(error.localizedDescription)"
            )
        }
        isLoading = false
    }
    
    public func archiveCraving(_ craving: CravingEntity) async {
        do {
            try await cravingRepo.archiveCraving(craving)
            // Refresh the local list
            cravings.removeAll { $0.id == craving.id }
        } catch {
            alertInfo = AlertInfo(
                title: "Error",
                message: "Could not archive craving: \(error.localizedDescription)"
            )
        }
    }
}
