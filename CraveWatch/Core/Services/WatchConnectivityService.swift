//
//  WatchConnectivityService.swift
//  CraveWatch
//
//  A watch connectivity service that sends and receives messages between the watch and the paired phone.
//  It updates @Published properties to allow the UI to respond to connectivity events.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import WatchConnectivity
import Combine
import SwiftUI

/// A service that manages connectivity between the Apple Watch and the paired phone using WCSession.
/// It can send messages to the phone and receive messages from the phone, updating published properties accordingly.
class WatchConnectivityService: NSObject, WCSessionDelegate, ObservableObject {
    
    // MARK: - Published Properties
    
    /// The most recently received craving from the phone.
    @Published var receivedCraving: WatchCravingEntity?
    
    /// Any connectivity error encountered during activation or message sending.
    @Published var connectivityError: Error?
    
    /// Indicates whether the phone is currently reachable.
    @Published var phoneReachable: Bool = false
    
    // MARK: - Private Properties
    
    /// The WCSession instance used for communication.
    private let session: WCSession
    
    /// A set to hold Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initializes the connectivity service with the specified WCSession (default is .default).
    /// If WCSession is supported, sets itself as the delegate and activates the session.
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        
        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        }
        
        // Observe the isReachable property of the WCSession and update the phoneReachable property accordingly.
        session.publisher(for: \.isReachable)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isReachable in
                self?.phoneReachable = isReachable
            }
            .store(in: &cancellables)
    }
    
    // MARK: - WCSessionDelegate Methods
    
    /// Called when the session activation completes.
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.connectivityError = error
            }
            return
        }
        print("WCSession activated successfully. State: \(activationState.rawValue)")
        DispatchQueue.main.async { [weak self] in
            self?.phoneReachable = session.isReachable
        }
    }
    
    #if os(iOS)
    /// Called when the session becomes inactive (iOS only).
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive")
    }
    
    /// Called when the session is deactivated (iOS only). Reactivates the session.
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated")
        session.activate()
    }
    #endif
    
    // MARK: - Sending Data
    
    /// Sends a message to the paired phone.
    ///
    /// - Parameter message: A dictionary containing the message data.
    /// If the session is not reachable, sets connectivityError accordingly.
    func sendMessageToPhone(_ message: [String: Any]) {
        guard session.isReachable else {
            print("WCSession is not reachable")
            connectivityError = NSError(
                domain: "WatchConnectivityError",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Phone is not reachable."]
            )
            return
        }
        
        session.sendMessage(message, replyHandler: { reply in
            print("Message sent successfully, reply: \(reply)")
        }, errorHandler: { error in
            print("Error sending message: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.connectivityError = error
            }
        })
    }
    
    // MARK: - Receiving Data
    
    /// Called when a message is received without a reply handler.
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Received message data: \(message)")
        
        // Attempt to parse the incoming message and create a WatchCravingEntity.
        if let text = message["text"] as? String,
           let intensity = message["intensity"] as? Int,
           let timestampInterval = message["timestamp"] as? TimeInterval {
            
            let resistance = message["resistance"] as? Int
            let timestamp = Date(timeIntervalSince1970: timestampInterval)
            
            let receivedCraving = WatchCravingEntity(
                text: text,
                intensity: intensity,
                resistance: resistance,
                timestamp: timestamp
            )
            DispatchQueue.main.async {
                self.receivedCraving = receivedCraving
            }
        }
    }
    
    /// Called when a message is received with a reply handler.
    /// Processes the message and responds with a status message.
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void
    ) {
        print("Received message data: \(message)")
        
        // Attempt to parse the message.
        if let text = message["text"] as? String,
           let intensity = message["intensity"] as? Int,
           let timestampInterval = message["timestamp"] as? TimeInterval {
            
            let resistance = message["resistance"] as? Int
            let timestamp = Date(timeIntervalSince1970: timestampInterval)
            
            let receivedCraving = WatchCravingEntity(
                text: text,
                intensity: intensity,
                resistance: resistance,
                timestamp: timestamp
            )
            DispatchQueue.main.async {
                self.receivedCraving = receivedCraving
                // Respond with a success status.
                replyHandler(["status": "Received Craving"])
            }
        } else {
            // If parsing fails, respond with an unknown status.
            replyHandler(["status": "Received unknown message"])
        }
    }
}
