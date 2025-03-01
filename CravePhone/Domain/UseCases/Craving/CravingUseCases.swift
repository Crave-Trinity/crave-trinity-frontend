//
//  CravingUseCases.swift
//  CravePhone
//
//  Created by John H Jung on <date>.
//  Description:
//    Use cases for phone-based craving features.
//    Defines a phone-specific error enum (PhoneCravingError) to avoid conflicts.
//
//  Uncle Bob & SOLID:
//    - Single Responsibility: Each use case has one clear job.
//    - Open/Closed: New use cases can be added without modifying existing ones.
//    - Clean Code: Dependencies are injected and the domain model is used consistently.
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

/// Use case for adding a new craving.
/// This implementation validates input and creates a new CravingEntity,
/// injecting default values for the new properties.
public final class AddCravingUseCase: AddCravingUseCaseProtocol {
    private let cravingRepository: CravingRepository

    public init(cravingRepository: CravingRepository) {
        self.cravingRepository = cravingRepository
    }

    public func execute(cravingText: String) async throws -> CravingEntity {
        let trimmed = cravingText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed.count >= 3 else {
            throw PhoneCravingError.invalidInput
        }
        // Create a new CravingEntity with default values for 'confidenceToResist' and 'cravingStrength'
        let newCraving = CravingEntity(text: trimmed, confidenceToResist: 0.0, cravingStrength: 0.0)
        try await cravingRepository.addCraving(newCraving)
        return newCraving
    }
}

/// Use case for fetching all active cravings.
public final class FetchCravingsUseCase: FetchCravingsUseCaseProtocol {
    private let cravingRepository: CravingRepository

    public init(cravingRepository: CravingRepository) {
        self.cravingRepository = cravingRepository
    }

    public func execute() async throws -> [CravingEntity] {
        try await cravingRepository.fetchAllActiveCravings()
    }
}

/// Use case for archiving a craving.
public final class ArchiveCravingUseCase: ArchiveCravingUseCaseProtocol {
    private let cravingRepository: CravingRepository

    public init(cravingRepository: CravingRepository) {
        self.cravingRepository = cravingRepository
    }

    public func execute(_ craving: CravingEntity) async throws {
        try await cravingRepository.archiveCraving(craving)
    }
}
