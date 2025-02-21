// CraveWatch/Services/WatchConnectivityService.swift (COMPLETE AND CORRECTED)
import Foundation
import WatchConnectivity
import Combine
import SwiftUI

class WatchConnectivityService: NSObject, WCSessionDelegate, ObservableObject {

    @Published var receivedCraving: WatchCravingEntity? // For receiving data (if needed)
    @Published var connectivityError: Error?
    @Published var phoneReachable: Bool = false // Add reachability status

    private let session: WCSession
    private var cancellables = Set<AnyCancellable>()

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }

        // Observe isReachable directly and update our @Published property.
        session.publisher(for: \.isReachable)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isReachable in
                self?.phoneReachable = isReachable
            }
            .store(in: &cancellables)
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.connectivityError = error // Update on main thread
            }
            return
        }
        print("WCSession activated successfully. State: \(activationState.rawValue)")

        //Update reachability status on main thread.
        DispatchQueue.main.async { [weak self] in
            self?.phoneReachable = session.isReachable
        }
    }

    // Implement this method if you support iOS versions prior to 14.
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive")
        // Handle session becoming inactive (e.g., user switched to another app)
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated")
        // Reactivate the session.  This is required if the session is deactivated.
        session.activate()
    }
    #endif


    // MARK: - Sending Data (GENERALIZED)

    func sendMessageToPhone(_ message: [String: Any]) { // More general method
        guard session.isReachable else {
            print("WCSession is not reachable")
            self.connectivityError = NSError(domain: "WatchConnectivityError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Phone is not reachable."])
            return
        }

        session.sendMessage(message, replyHandler: { reply in
            // Handle the reply (if any)
            print("Message sent successfully, reply: \(reply)")
        }, errorHandler: { error in
            print("Error sending message: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.connectivityError = error
            }
        })
    }

    // MARK: - Receiving data from Phone (if needed)
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //process received messages
      print("Received message data: \(message)")
      // Example of how you might handle receiving a craving back:
      if let text = message["text"] as? String,
         let intensity = message["intensity"] as? Int,
         let timestampInterval = message["timestamp"] as? TimeInterval {

          let resistance = message["resistance"] as? Int
          let timestamp = Date(timeIntervalSince1970: timestampInterval)

          let receivedCraving = WatchCravingEntity(text: text, intensity: intensity, resistance: resistance, timestamp: timestamp)

          DispatchQueue.main.async {
              self.receivedCraving = receivedCraving  // Update the @Published property
          }
      }
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
          //process received messages
          print("Received message data: \(message)")
          // Example of how you might handle receiving a craving back:
          if let text = message["text"] as? String,
             let intensity = message["intensity"] as? Int,
             let timestampInterval = message["timestamp"] as? TimeInterval {

              let resistance = message["resistance"] as? Int
              let timestamp = Date(timeIntervalSince1970: timestampInterval)

              let receivedCraving = WatchCravingEntity(text: text, intensity: intensity, resistance: resistance, timestamp: timestamp)

              DispatchQueue.main.async {
                  self.receivedCraving = receivedCraving  // Update the @Published property
                  replyHandler(["status" : "Received Craving"])
              }
          } else {
              replyHandler(["status" : "Received unknown message"])
          }
      }
}
