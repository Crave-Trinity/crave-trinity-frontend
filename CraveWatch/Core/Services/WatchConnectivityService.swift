//==============================================================
//  File B: WatchConnectivityService.swift
//  Description:
//    Manages WCSession to send messages from the watch to the iPhone.
//
//  Usage:
//    1. Create an instance (e.g., @StateObject var connectivityService = WatchConnectivityService()).
//    2. Call sendCravingToPhone(craving:) to transmit a new craving.
//    3. The iPhone side must implement WCSessionDelegate to handle incoming messages.
//==============================================================

import Foundation
import WatchConnectivity

class WatchConnectivityService: NSObject, ObservableObject, WCSessionDelegate {
    @Published var phoneReachable: Bool = false
    private var session: WCSession?

    override init() {
        super.init()
        // Ensure WatchConnectivity is supported
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    /// Sends a dictionary to the iPhone, if reachable.
    func sendMessageToPhone(_ message: [String: Any]) {
        guard let session = session, session.isReachable else {
            print("Phone not reachable or WCSession not available.")
            return
        }
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message to phone: \(error.localizedDescription)")
        }
    }
    
    /// Convenience method to send a WatchCravingEntity to the phone.
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
                print("WCSession activation error: \(error.localizedDescription)")
            } else {
                print("WCSession activated with state: \(activationState.rawValue)")
            }
        }
    }
    
    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        Task { @MainActor in
            self.phoneReachable = session.isReachable
        }
    }
}

