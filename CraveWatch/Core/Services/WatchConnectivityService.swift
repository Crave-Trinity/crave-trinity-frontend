//
//  WatchConnectivityService.swift
//  CraveWatch
//

import Foundation
import WatchConnectivity
import Combine
import SwiftUI

/// A watch connectivity service that can send messages to the phone
/// and receive messages from the phone, updating @Published properties.
class WatchConnectivityService: NSObject, WCSessionDelegate, ObservableObject {

    @Published var receivedCraving: WatchCravingEntity?
    @Published var connectivityError: Error?
    @Published var phoneReachable: Bool = false

    private let session: WCSession
    private var cancellables = Set<AnyCancellable>()

    init(session: WCSession = .default) {
        self.session = session
        super.init()

        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        }

        // Observe isReachable directly and update our phoneReachable property.
        session.publisher(for: \.isReachable)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isReachable in
                self?.phoneReachable = isReachable
            }
            .store(in: &cancellables)
    }

    // MARK: - WCSessionDelegate

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
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated")
        session.activate()
    }
    #endif

    // MARK: - Sending Data

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
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Received message data: \(message)")

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

    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void
    ) {
        print("Received message data: \(message)")

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
                replyHandler(["status": "Received Craving"])
            }
        } else {
            replyHandler(["status": "Received unknown message"])
        }
    }
}


