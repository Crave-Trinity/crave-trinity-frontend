// Core/Domain/UseCases/Analytics/AnalyticsProcessor.swift
import Foundation

@MainActor
public final class AnalyticsProcessor {
    private let configuration: AnalyticsConfiguration
    private let storage: AnalyticsStorage

    // Internal initializer (if this class is only used internally; otherwise, mark it public)
    init(configuration: AnalyticsConfiguration, storage: AnalyticsStorage) {
        self.configuration = configuration
        self.storage = storage
    }

    // Process an event by switching on its eventType (a String)
    public func processEvent(_ event: any AnalyticsEvent) async {
        do {
            // Use event.eventType (a String) for switching.
            switch event.eventType {
            case "interaction":
                try await processInteractionEvent(event)
            case "system":
                try await processSystemEvent(event)
            case "user":
                try await processUserEvent(event)
            default:
                print("Unhandled event type: \(event.eventType)")
            }
        } catch {
            print("Error processing event: \(error)")
        }
    }

    private func processInteractionEvent(_ event: any AnalyticsEvent) async throws {
        // Implementation for interaction events
    }

    private func processSystemEvent(_ event: any AnalyticsEvent) async throws {
        // Implementation for system events
    }

    private func processUserEvent(_ event: any AnalyticsEvent) async throws {
        // Implementation for user events
    }
}

