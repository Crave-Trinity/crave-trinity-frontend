//
//  WatchConnectivityService.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A watch-specific service that manages WCSession to send messages (including cravings)
//               to the iPhone. It publishes the phone’s reachability status and provides both a generic
//               and a specialized (for cravings) method for sending messages.
import Foundation
import WatchConnectivity

class WatchConnectivityService: NSObject, ObservableObject, WCSessionDelegate {
    
    // Published property to let others know if the phone is reachable.
    @Published var phoneReachable: Bool = false
    
    private var session: WCSession?
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()  // Activate session upon initialization.
        }
    }
    
    /// Generic method to send any message dictionary to the iPhone.
    /// - Parameter message: The dictionary containing the message data.
    func sendMessageToPhone(_ message: [String: Any]) {
        guard let session = session, session.isReachable else {
            print("🔴 iPhone not reachable or session not available.")
            return
        }
        session.sendMessage(message, replyHandler: nil) { error in
            print("🔴 Failed to send message: \(error.localizedDescription)")
        }
    }
    
    /// Specialized method to send a craving to the iPhone.
    /// - Parameter craving: A WatchCravingEntity instance containing craving data.
    func sendCravingToPhone(craving: WatchCravingEntity) {
        let message: [String: Any] = [
            "action": "logCraving",
            "description": craving.text,   // Use the 'text' property as defined in the entity.
            "intensity": craving.intensity,
            "timestamp": craving.timestamp.timeIntervalSince1970
        ]
        sendMessageToPhone(message)
    }
    
    // MARK: - WCSessionDelegate Methods
    
    // These methods must be nonisolated in Swift 6. We use Task { @MainActor in ... } to ensure main-thread updates.
    nonisolated func session(_ session: WCSession,
                             activationDidCompleteWith activationState: WCSessionActivationState,
                             error: Error?) {
        Task { @MainActor in
            if let error = error {
                print("🔴 Session activation error: \(error.localizedDescription)")
            } else {
                print("✅ WatchConnectivity session activated. State: \(activationState.rawValue)")
            }
        }
    }
    
    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        Task { @MainActor in
            self.phoneReachable = session.isReachable
            print("Reachability changed: \(session.isReachable)")
        }
    }
    
    // Note: sessionDidBecomeInactive and sessionDidDeactivate are not available on watchOS.
}
