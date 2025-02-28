//
//  LogCravingViewModel.swift
//  CravePhone
//
//  Description:
//    A ViewModel for logging cravings with:
//      - Craving Strength slider
//      - Confidence to Resist slider
//      - Horizontal “Emotion Chips” (e.g., Hungry, Lonely, Angry, Tired, Sad)
//      - Expandable "Advanced Details" section
//      - One big text field for triggers/notes
//
//  Uncle Bob & Steve Jobs Notes:
//    - Single Responsibility: Manage the logging logic and track user inputs.
//    - Clear property names, short function for logCraving().
//
//  Created by ...
//  Updated by ChatGPT on ...
//
import SwiftUI
import Combine

@MainActor
public final class LogCravingViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let addCravingUseCase: AddCravingUseCaseProtocol
    
    // MARK: - Published Properties (Bound to the View)
    @Published public var cravingDescription: String = ""
    @Published public var cravingStrength: Double = 5.0
    @Published public var confidenceToResist: Double = 5.0
    
    // For the horizontal chips:
    public let allEmotionalStates: [String] = ["Hungry", "Lonely", "Angry", "Tired", "Sad"]
    @Published public var selectedEmotions: Set<String> = []
    
    // Expandable details toggler
    @Published public var showAdvanced: Bool = false
    
    // UI feedback states
    @Published public var alertInfo: AlertInfo?
    @Published public var isLoading: Bool = false
    
    // MARK: - Initializer (DI)
    public init(addCravingUseCase: AddCravingUseCaseProtocol) {
        self.addCravingUseCase = addCravingUseCase
    }
    
    // MARK: - Action: Toggle Emotional State
    public func toggleEmotion(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.remove(emotion)
        } else {
            selectedEmotions.insert(emotion)
        }
    }
    
    // MARK: - Action: Log Craving
    public func logCraving() async {
        // Trim the craving description to avoid extra spaces.
        let trimmed = cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 3 else {
            alertInfo = AlertInfo(title: "Error",
                                  message: "Craving must be at least 3 characters.")
            return
        }
        do {
            isLoading = true
            // Potentially combine multiple fields into one large “description”
            // or pass them as separate fields to your domain layer.
            // For example, you might do:
            let combinedDescription = """
            Craving: \(trimmed)
            Emotions: \(selectedEmotions.joined(separator: ", "))
            Strength: \(Int(cravingStrength))
            Confidence: \(Int(confidenceToResist))
            """
            _ = try await addCravingUseCase.execute(cravingText: combinedDescription)
            
            // Clear fields after successful logging.
            cravingDescription = ""
            selectedEmotions.removeAll()
            // Optionally reset sliders or keep them
            cravingStrength = 5.0
            confidenceToResist = 5.0
            
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }
}

