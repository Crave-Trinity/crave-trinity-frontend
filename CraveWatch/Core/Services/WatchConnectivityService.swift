//
//  WatchConnectivityService.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: Manages WCSession to send messages to the iPhone.
import Foundation
import WatchConnectivity

class WatchConnectivityService: NSObject, ObservableObject, WCSessionDelegate {
    @Published var phoneReachable: Bool = false
    private var session: WCSession?

    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    /// Sends a message dictionary to the iPhone.
    func sendMessageToPhone(_ message: [String: Any]) {
        guard let session = session, session.isReachable else {
            print("Phone not reachable or session not available.")
            return
        }
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
    /// Convenience method to send a craving.
    func sendCravingToPhone(craving: WatchCravingEntity) {
        let message: [String: Any] = [
            "action": "logCraving",
            "description": craving.text,
            "intensity": craving.intensity,
            "timestamp": craving.timestamp.timeIntervalSince1970
        ]
        sendMessageToPhone(message)
    }
    
    // MARK: - WCSessionDelegate
    
    nonisolated func session(_ session: WCSession,
                             activationDidCompleteWith activationState: WCSessionActivationState,
                             error: Error?) {
        Task { @MainActor in
            if let error = error {
                print("Session activation error: \(error.localizedDescription)")
            } else {
                print("WCSession activated, state: \(activationState.rawValue)")
            }
        }
    }
    
    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        Task { @MainActor in
            self.phoneReachable = session.isReachable
        }
    }
}
