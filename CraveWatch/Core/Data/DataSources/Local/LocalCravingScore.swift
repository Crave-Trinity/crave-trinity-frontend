
//CraveWatch/Core/Data/DataSources/Local/LocalCravingStore.swift
import Foundation
import Combine
import SwiftData

//Simple in-memory storage for demonstration.  Replace with Core Data, UserDefaults, or another persistent store.
class LocalCravingStore {
 // @Published private var cravings: [WatchCravingEntity] = [] //not needed with SwiftData
    private var cravingsSubject = CurrentValueSubject<[WatchCravingEntity], Error>([])
    private var context: ModelContext?
     init() {
         // Load initial data (e.g., from UserDefaults) if needed.
         //loadInitialData() //not needed since we get context in addCraving

     }

    func saveCraving(_ craving: WatchCravingEntity) -> AnyPublisher<Void, Error> {
        // Simulate an asynchronous operation with a delay.
        return Future { [weak self] promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { // Simulate network delay
                guard let self = self else { return }
                guard let context = self.context else {
                    promise(.failure(NSError(domain: "LocalCravingStore", code: 0, userInfo: [NSLocalizedDescriptionKey : "Model Context not set"])))
                    return
                }

                context.insert(craving) //insert into SwiftData

                do {
                    try context.save() //save to SwiftData
                    promise(.success(()))
                } catch {
                    promise(.failure(error)) //send error to sink
                }
            }
        }
        .eraseToAnyPublisher()
    }
     func addCraving(cravingDescription: String, intensity: Int, resistance: Int) async throws { //add resistance
        guard let context = self.context else {
            throw NSError(domain: "LocalCravingStore", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContext not available."])
        }

        let craving = WatchCravingEntity(text: cravingDescription, intensity: intensity, resistance: resistance, timestamp: Date()) //CORRECT
        context.insert(craving)
        try context.save()
     }
    //get the cravings
    func getCravings() -> AnyPublisher<[WatchCravingEntity], Error> {
        return cravingsSubject.eraseToAnyPublisher()
    }
    func fetchAllCravings() async throws -> [WatchCravingEntity] {
        guard let context = self.context else {
            throw NSError(domain: "LocalCravingStore", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContext not available."])
        }
        // Create a fetch descriptor to fetch all cravings.
        let descriptor = FetchDescriptor<WatchCravingEntity>()
        do {
          // Perform the fetch.
          let cravings = try context.fetch(descriptor)
            cravingsSubject.send(cravings) //update
          return cravings
        } catch {
          // Handle errors, perhaps by sending them through a Combine subject.
          print("🔴 Failed to fetch cravings: \(error)")
          throw error // Re-throw the error to be handled upstream.
        }
      }
    func deleteCraving(_ craving: WatchCravingEntity) async throws {
        guard let context = self.context else {
              throw NSError(domain: "LocalCravingStore", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContext not available."])
          }
          context.delete(craving)
          try context.save()
      }
    //set the context
    func setContext(context: ModelContext) {
        self.context = context
    }

}
