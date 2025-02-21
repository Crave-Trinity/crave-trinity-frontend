//  CraveWatch/Core/Presentation/ViewModels/EmergencyTriggerViewModel.swift (CORRECTED)

import Foundation

/// Demonstrates a flow that might trigger an EMS or SOS call from the watch.
/// In reality, you would integrate with watch capabilities or pass this event to the iPhone.
@MainActor
class EmergencyTriggerViewModel: ObservableObject {
    
    @Published var showConfirmation = false
    @Published var showSuccessAlert = false
    
    private let watchConnectivityService: WatchConnectivityService
    
    init(watchConnectivityService: WatchConnectivityService) {
        self.watchConnectivityService = watchConnectivityService
    }
    
    /// Called when user taps "Trigger EMS"
    func requestEmergency() {
        showConfirmation = true
    }
    
    /// Called if user confirms in the confirmation dialog
    func confirmEmergency() {
        let message: [String: Any] = [
            "action": "emsTrigger",
            "timestamp": Date().timeIntervalSince1970
        ]
        
        watchConnectivityService.sendMessageToPhone(message) // Corrected method name
        showConfirmation = false
        showSuccessAlert = true
    }
}
