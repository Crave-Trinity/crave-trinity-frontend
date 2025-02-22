//
//  LocalCravingStore.swift
//  CraveWatch
//
//  A simple in-memory storage implementation for craving records.
//  This is intended for demonstration purposes. In a production environment,
//  you would likely replace this with a more robust solution (e.g., Core Data, UserDefaults, or another persistent store).
//

import Foundation
import Combine
import SwiftData

/// A local store managing `WatchCravingEntity` objects.
/// This store uses SwiftData for persistence and Combine for asynchronous operations.
class LocalCravingStore {
    
    // MARK: - Properties
    
    /// A Combine subject that holds the current list of cravings.
    /// Subscribers can listen for changes (e.g., when new cravings are fetched).
    private var cravingsSubject = CurrentValueSubject<[WatchCravingEntity], Error>([])
    
    /// The SwiftData model context for performing data operations.
    /// This must be set before any data manipulation occurs.
    private var context: ModelContext?
    
    // MARK: - Initialization
    
    /// Initializes the local craving store.
    /// Optionally, you can load initial data here (e.g., from UserDefaults) if needed.
    init() {
        // Initial data loading can be done here if required.
        // e.g., loadInitialData()
    }
    
    // MARK: - Data Manipulation Methods
    
    /// Saves a new craving asynchronously.
    ///
    /// This method simulates an asynchronous operation with a delay to mimic a network or heavy computation delay.
    ///
    /// - Parameter craving: The craving entity to save.
    /// - Returns: A publisher that emits a completion event upon success or an error if the operation fails.
    func saveCraving(_ craving: WatchCravingEntity) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            // Simulate a delay (e.g., network latency or processing time)
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                guard let self = self else { return }
                
                // Ensure that the model context is available.
                guard let context = self.context else {
                    promise(.failure(NSError(domain: "LocalCravingStore",
                                               code: 0,
                                               userInfo: [NSLocalizedDescriptionKey : "Model Context not set"])))
                    return
                }
                
                // Insert the new craving record into the SwiftData context.
                context.insert(craving)
                
                do {
                    // Attempt to persist the changes.
                    try context.save()
                    promise(.success(()))
                } catch {
                    // If saving fails, complete with an error.
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Adds a new craving record using asynchronous Swift concurrency.
    ///
    /// - Parameters:
    ///   - cravingDescription: A textual description of the craving.
    ///   - intensity: The intensity level of the craving.
    ///   - resistance: The resistance value associated with the craving.
    /// - Throws: An error if the model context is unavailable or saving fails.
    func addCraving(cravingDescription: String, intensity: Int, resistance: Int) async throws {
        // Ensure that the model context is available.
        guard let context = self.context else {
            throw NSError(domain: "LocalCravingStore",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "ModelContext not available."])
        }
        
        // Create a new craving entity with the provided details.
        let craving = WatchCravingEntity(
            text: cravingDescription,
            intensity: intensity,
            resistance: resistance,
            timestamp: Date()
        )
        
        // Insert the new entity and persist the changes.
        context.insert(craving)
        try context.save()
    }
    
    /// Provides a publisher to observe the current list of cravings.
    ///
    /// - Returns: A publisher that emits an array of `WatchCravingEntity` objects or an error.
    func getCravings() -> AnyPublisher<[WatchCravingEntity], Error> {
        return cravingsSubject.eraseToAnyPublisher()
    }
    
    /// Fetches all craving records asynchronously.
    ///
    /// This method uses a `FetchDescriptor` to retrieve all cravings from the SwiftData context.
    /// Upon a successful fetch, it updates the `cravingsSubject`.
    ///
    /// - Returns: An array of `WatchCravingEntity` objects.
    /// - Throws: An error if the model context is unavailable or fetching fails.
    func fetchAllCravings() async throws -> [WatchCravingEntity] {
        // Ensure that the model context is available.
        guard let context = self.context else {
            throw NSError(domain: "LocalCravingStore",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "ModelContext not available."])
        }
        
        // Create a fetch descriptor to retrieve all cravings.
        let descriptor = FetchDescriptor<WatchCravingEntity>()
        
        do {
            // Execute the fetch.
            let cravings = try context.fetch(descriptor)
            // Update the Combine subject with the latest data.
            cravingsSubject.send(cravings)
            return cravings
        } catch {
            // Log the error and re-throw for upstream handling.
            print("🔴 Failed to fetch cravings: \(error)")
            throw error
        }
    }
    
    /// Deletes a specified craving record asynchronously.
    ///
    /// - Parameter craving: The craving entity to delete.
    /// - Throws: An error if the model context is unavailable or saving fails after deletion.
    func deleteCraving(_ craving: WatchCravingEntity) async throws {
        // Ensure that the model context is available.
        guard let context = self.context else {
            throw NSError(domain: "LocalCravingStore",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "ModelContext not available."])
        }
        
        // Delete the specified craving and persist the change.
        context.delete(craving)
        try context.save()
    }
    
    // MARK: - Context Management
    
    /// Sets the SwiftData model context used for data operations.
    ///
    /// - Parameter context: The `ModelContext` to be used.
    func setContext(context: ModelContext) {
        self.context = context
    }
}
