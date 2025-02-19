// Core/Domain/Interfaces/UseCases/CravingUseCases.swift
import Foundation

public enum CravingError: LocalizedError {
    case invalidInput
    case storageError
    
    public var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Craving text must be at least 3 characters long"
        case .storageError:
            return "Failed to store craving"
        }
    }
}

public protocol AddCravingUseCaseProtocol {
    func execute(cravingText: String) async throws -> CravingEntity
}

public protocol FetchCravingsUseCaseProtocol {
    func execute() async throws -> [CravingEntity]
}

public protocol ArchiveCravingUseCaseProtocol {
    func execute(_ craving: CravingEntity) async throws
}

public final class AddCravingUseCase: AddCravingUseCaseProtocol {
    private let cravingRepository: CravingRepository
    
    public init(cravingRepository: CravingRepository) {
        self.cravingRepository = cravingRepository
    }
    
    public func execute(cravingText: String) async throws -> CravingEntity {
        let trimmed = cravingText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed.count >= 3 else {
            throw CravingError.invalidInput
        }
        
        let newCraving = CravingEntity(text: trimmed)
        try await cravingRepository.addCraving(newCraving)
        return newCraving
    }
}

public final class FetchCravingsUseCase: FetchCravingsUseCaseProtocol {
    private let cravingRepository: CravingRepository
    
    public init(cravingRepository: CravingRepository) {
        self.cravingRepository = cravingRepository
    }
    
    public func execute() async throws -> [CravingEntity] {
        try await cravingRepository.fetchAllActiveCravings()
    }
}

public final class ArchiveCravingUseCase: ArchiveCravingUseCaseProtocol {
    private let cravingRepository: CravingRepository
    
    public init(cravingRepository: CravingRepository) {
        self.cravingRepository = cravingRepository
    }
    
    public func execute(_ craving: CravingEntity) async throws {
        try await cravingRepository.archiveCraving(craving)
    }
}
