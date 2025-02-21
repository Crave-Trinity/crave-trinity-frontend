//CravingRepository.swift
import Foundation

public protocol CravingRepository {
    func fetchAllActiveCravings() async throws -> [CravingEntity]
    func addCraving(_ craving: CravingEntity) async throws
    func archiveCraving(_ craving: CravingEntity) async throws
    func deleteCraving(_ craving: CravingEntity) async throws
}
