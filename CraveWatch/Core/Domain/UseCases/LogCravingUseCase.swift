//
//  LogCravingUseCase.swift
//  CraveWatch
//
//  A use case responsible for logging a craving by saving it locally using SwiftData
//  and then sending the log message to the paired phone device.
//  (C) 2030
//

import Foundation
import Combine
import SwiftData

/// Protocol defining the interface for logging a craving.
/// This use case is responsible for both local persistence and phone synchronization.
protocol LogCravingUseCaseProtocol {
    /// Executes the craving logging process.
    ///
    /// - Parameters:
    ///   - text: The textual description of the craving.
    ///   - intensity: The intensity level of the craving.
    ///   - resistance: An optional resistance metric.
    ///   - context: The SwiftData model context used for local persistence.
    /// - Returns: A publisher that emits a completion event upon success or an error if the operation fails.
    func execute(text: String, intensity: Int, resistance: Int?, context: ModelContext) -> AnyPublisher<Void, Error>
}

/// Concrete implementation of LogCravingUseCaseProtocol.
/// This class handles both local data persistence and sending a log message to the paired phone.
final class LogCravingUseCase: LogCravingUseCaseProtocol {
    
    /// Service for handling connectivity with the paired phone.
    private let connectivityService: WatchConnectivityService

    /// Initializes the use case with a connectivity service.
    /// - Parameter connectivityService: The service managing communication with the phone.
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
    }

    /// Executes the craving logging process:
    /// 1. Creates a new craving entity with the provided details.
    /// 2. Inserts the new entity into the local SwiftData context.
    /// 3. Attempts to save the context.
    /// 4. Constructs a message dictionary with the craving details.
    /// 5. Sends the message to the paired phone.
    /// 6. Completes the operation via a Combine publisher.
    ///
    /// - Returns: A publisher that signals completion on success or emits an error if any step fails.
    func execute(
        text: String,
        intensity: Int,
        resistance: Int?,
        context: ModelContext
    ) -> AnyPublisher<Void, Error> {

        // Return a Future publisher to encapsulate the asynchronous logging operation.
        return Future { promise in
            // Step 1: Create a new SwiftData entity for the craving.
            let newCraving = WatchCravingEntity(
                text: text,
                intensity: intensity,
                resistance: resistance,
                timestamp: Date()
            )
            // Step 2: Insert the new craving into the provided context.
            context.insert(newCraving)
            
            do {
                // Step 3: Attempt to save the context to persist the new record.
                try context.save()
            } catch {
                // If saving fails, complete the publisher with a failure.
                return promise(.failure(error))
            }
            
            // Step 4: Construct a message dictionary to send to the phone.
            let message: [String: Any] = [
                "action": "logCraving",
                "id": String(describing: newCraving.id),
                "text": newCraving.text,
                "intensity": newCraving.intensity,
                // Use NSNull if resistance is nil to ensure proper message formatting.
                "resistance": newCraving.resistance ?? NSNull(),
                "timestamp": newCraving.timestamp.timeIntervalSince1970
            ]
            
            // Step 5: Send the message to the paired phone using the connectivity service.
            self.connectivityService.sendMessageToPhone(message)
            
            // Step 6: Complete the publisher successfully.
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}
