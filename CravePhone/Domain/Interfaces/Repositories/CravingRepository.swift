//
//  CravingRepository.swift
//  CravePhone
//
//  Purpose:
//    Abstract away the logic for persisting/fetching CravingEntity objects
//
import Foundation

public protocol CravingRepository {
    func addCraving(_ craving: CravingEntity) async throws
    func fetchActiveCravings() async throws -> [CravingEntity]
    func archiveCraving(_ craving: CravingEntity) async throws
    func deleteCraving(_ craving: CravingEntity) async throws
}
