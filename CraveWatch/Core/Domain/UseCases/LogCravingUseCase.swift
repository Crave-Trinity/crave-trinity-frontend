//
//  LogCravingUseCase.swift
//  CraveWatch
//

import Foundation
import Combine
import SwiftData

protocol LogCravingUseCaseProtocol {
    /// Saves the craving locally (SwiftData) and sends it to the phone.
    func execute(text: String, intensity: Int, resistance: Int?, context: ModelContext) -> AnyPublisher<Void, Error>
}

final class LogCravingUseCase: LogCravingUseCaseProtocol {
    private let connectivityService: WatchConnectivityService

    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }

    /// Perform local save + phone sync. Returns a publisher so the ViewModel can
    /// show loading, success, or errors.
    func execute(
        text: String, 
        intensity: Int,
        resistance: Int?,
        context: ModelContext
    ) -> AnyPublisher<Void, Error> {

        // We'll return a Future that does the local insert & phone message.
        return Future { promise in
            // 1. Insert local SwiftData model
            let newCraving = WatchCravingEntity(
                text: text,
                intensity: intensity,
                resistance: resistance,
                timestamp: Date()
            )

            context.insert(newCraving)

            do {
                // Attempt to save locally
                try context.save()
            } catch {
                // If saving fails, end the publisher with .failure
                return promise(.failure(error))
            }

            // 2. Send message to phone
            let message: [String: Any] = [
                "action": "logCraving",
                "id": String(describing: newCraving.id),
                "text": newCraving.text,
                "intensity": newCraving.intensity,
                "resistance": newCraving.resistance ?? NSNull(),
                "timestamp": newCraving.timestamp.timeIntervalSince1970
            ]

            self.connectivityService.sendMessageToPhone(message)

            // 3. Promise success
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}


