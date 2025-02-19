
// WatchConnectivityService
#if os(watchOS)
import WatchConnectivity
import Combine

/// WatchConnectivityService is responsible for handling watch-to-phone communication.
/// It tracks whether the paired iPhone is reachable.
class WatchConnectivityService: NSObject, ObservableObject, WCSessionDelegate {
    
    // Publishes whether the iPhone is reachable from the watch.
    @Published var phoneReachable: Bool = false
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    override init() {
        super.init()
        activateSession()
    }
    
    /// Sets up and activates the WCSession.
    func activateSession() {
        session?.delegate = self
        session?.activate()
    }
    
    /// Sends a message from the watch to the iPhone.
    func sendMessageToPhone(_ message: [String: Any]) {
        guard let validSession = session, validSession.isReachable else {
            phoneReachable = false
            print("🔴 iPhone not reachable.")
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
        // Optional: handle activation success or errors.
        if let error = error {
            print("🔴 Activation error: \(error.localizedDescription)")
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        // Update UI on main thread when reachability changes.
        DispatchQueue.main.async {
            self.phoneReachable = session.isReachable
            print("⚠️ phoneReachable changed to \(session.isReachable)")
        }
    }
    
    // Implement additional delegate methods if needed.
}
#endif
