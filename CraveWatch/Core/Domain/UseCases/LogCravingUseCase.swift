// CraveWatch/Core/Domain/UseCases/LogCravingUseCase.swift
import Foundation
import Combine
import SwiftData

protocol LogCravingUseCaseProtocol {
    func execute(text: String, intensity: Int, resistance: Int) -> AnyPublisher<Void, Error>
}

final class LogCravingUseCase: LogCravingUseCaseProtocol {
    private let connectivityService: WatchConnectivityService

    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }

    func execute(text: String, intensity: Int, resistance: Int) -> AnyPublisher<Void, Error> {
        // Create the entity.
        let newCraving = WatchCravingEntity(text: text, intensity: intensity, resistance: resistance, timestamp: Date())

        // Create the message dictionary.
        let message: [String: Any] = [
            "action": "logCraving",
            "id": String(describing: newCraving.id), // Convert PersistentIdentifier to String
            "text": newCraving.text,
            "intensity": newCraving.intensity,
            "resistance": newCraving.resistance ?? NSNull(),
            "timestamp": newCraving.timestamp.timeIntervalSince1970
        ]

        // Send the craving to the phone.
        connectivityService.sendMessageToPhone(message)

        // Simulate success.
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

