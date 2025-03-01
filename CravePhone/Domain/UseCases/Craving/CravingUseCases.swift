//
//  CravingUseCases.swift
//  CravePhone
//
//  Uncle Bob & Steve Jobs Style:
//   - Unchanged except for referencing new entity field 'cravingDescription'.
//   - These use cases are optional if you don't call them from the container.
//

import Foundation

public enum PhoneCravingError: LocalizedError {
    case invalidInput
    case storageError

    public var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Craving text must be at least 3 characters long."
        case .storageError:
            return "Failed to store craving."
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
        guard trimmed.count >= 3 else {
            throw PhoneCravingError.invalidInput
        }
        
        let newCraving = CravingEntity(
            cravingDescription: trimmed,
            cravingStrength: 5.0,
            confidenceToResist: 5.0,
            emotions: [],
            timestamp: Date(),
            isArchived: false
        )
        
        do {
            try await cravingRepository.addCraving(newCraving)
        } catch {
            throw PhoneCravingError.storageError
        }
        
        return newCraving
    }
}

public final class FetchCravingsUseCase: FetchCravingsUseCaseProtocol {
    private let cravingRepository: CravingRepository

    public init(cravingRepository: CravingRepository) {
        self.cravingRepository = cravingRepository
    }

    public func execute() async throws -> [CravingEntity] {
        try await cravingRepository.fetchActiveCravings()
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
