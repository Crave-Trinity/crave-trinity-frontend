

import Foundation
import Combine

/// A simple ViewModel responsible for handling the watch-based craving log flow.
@MainActor
class CravingLogViewModel: ObservableObject {

    // MARK: - Published Properties (bound to the View)
    @Published var cravingDescription: String = ""
    @Published var intensity: Int = 5  // Sample scale from 1–10
    @Published var showConfirmation = false
    @Published var errorMessage: String?

    // MARK: - Dependencies
    private let watchConnectivityService: WatchConnectivityService

    // MARK: - Init
    init(watchConnectivityService: WatchConnectivityService) {
        self.watchConnectivityService = watchConnectivityService
    }

    // MARK: - Methods
    func logCraving() {
        guard !cravingDescription.isEmpty else {
            // Mark error if user attempts to log a blank craving
            errorMessage = "Please enter a craving description."
            return
        }

        // Construct a dictionary to send to the phone
        let message: [String: Any] = [
            "action": "logCraving",
            "description": cravingDescription,
            "intensity": intensity,
            "timestamp": Date().timeIntervalSince1970
        ]

        // Attempt to send data to iPhone
        watchConnectivityService.sendMessageToPhone(message)
        
        // Reset local states (if you'd like) after sending
        cravingDescription = ""
        intensity = 5
        showConfirmation = true
    }
    
    func dismissError() {
        errorMessage = nil
    }
}
