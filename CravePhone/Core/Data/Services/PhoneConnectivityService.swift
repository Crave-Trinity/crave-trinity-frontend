//
//  PhoneConnectivityService.swift
//  CravePhone
//
//  Description:
//  Manages the WCSession on the iPhone to receive messages from the watch.
//  When the watch sends a "logCraving" message, this service receives it
//  and processes the craving data (e.g., by logging it or updating the UI).
//
//  Usage:
//  1. Instantiate PhoneConnectivityService (e.g., as a @StateObject in your phone app).
//  2. The WCSessionDelegate methods handle session activation and incoming messages.
//  3. Ensure the shared model file (WatchCravingEntity.swift) is visible to the phone target
//     if you need to decode the same data structure.
//
//  Created by [Your Name] on [Date]
//

import Foundation
import WatchConnectivity

class PhoneConnectivityService: NSObject, ObservableObject, WCSessionDelegate {
    // Indicates whether the watch is reachable.
    @Published var watchReachable: Bool = false
    
    private var session: WCSession?

    override init() {
        super.init()
        
        // Check if the device supports WatchConnectivity.
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    // MARK: - WCSessionDelegate

    /// Called when the session completes activation.
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Phone WCSession activation error: \(error.localizedDescription)")
            } else {
                print("Phone WCSession activated with state: \(activationState.rawValue)")
            }
        }
    }
    
    /// Called whenever the session's reachability changes.
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.watchReachable = session.isReachable
        }
    }
    
    /// Called when the phone receives a message from the watch.
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Process the incoming message on the main thread.
        DispatchQueue.main.async {
            // Check for the expected "logCraving" action.
            if let action = message["action"] as? String, action == "logCraving" {
                let description = message["description"] as? String ?? ""
                let intensity = message["intensity"] as? Int ?? 0
                let timestampInterval = message["timestamp"] as? TimeInterval ?? Date().timeIntervalSince1970
                let timestamp = Date(timeIntervalSince1970: timestampInterval)
                
                // For example, log the received craving data.
                print("Received logCraving from watch:")
                print("Description: \(description)")
                print("Intensity: \(intensity)")
                print("Timestamp: \(timestamp)")
                
                // TODO: Insert code to process or store the craving data on the phone side.
            } else {
                print("Received an unknown message from watch: \(message)")
            }
        }
    }
    
    // ===== iOS-Only Required Stubs =====
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Typically no-op on iOS unless you need to handle inactivation.
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Typically no-op on iOS. If needed, you can call session.activate() again.
    }
}

