// PhoneWatchConnectivityService.swift
#if os(iOS)
import WatchConnectivity
import Combine

/// PhoneWatchConnectivityService handles phone-to-watch communication
/// and manages watch connectivity state.
class PhoneWatchConnectivityService: NSObject, ObservableObject, WCSessionDelegate {
    
    @Published var watchReachable: Bool = false
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    override init() {
        super.init()
        activateSession()
    }
    
    func activateSession() {
        session?.delegate = self
        session?.activate()
    }
    
    /// Sends a message from the phone to the watch
    func sendMessageToWatch(_ message: [String: Any]) {
        guard let validSession = session, validSession.isReachable else {
            watchReachable = false
            print("🔴 Watch not reachable.")
            return
        }
        
        validSession.sendMessage(message, replyHandler: nil) { error in
            print("🔴 Message failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - WCSessionDelegate Methods
    
    func session(_ session: WCSession,
                 activationDidCompleteWith state: WCSessionActivationState,
                 error: Error?) {
        if let error = error {
            print("🔴 Activation error: \(error.localizedDescription)")
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.watchReachable = session.isReachable
            print("⚠️ watchReachable changed to \(session.isReachable)")
        }
    }
    
    // Required for iOS
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("⚠️ Session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        WCSession.default.activate()
    }
}
#endif
