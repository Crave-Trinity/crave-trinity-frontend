//CraveWatch/Services/WatchHapticManager.swift (CORRECT)
import WatchKit

class WatchHapticManager {
     static let shared = WatchHapticManager()

     enum HapticType {
         case success
         case warning
         case selection
         case notification //ADD
     }

     /// Triggers the specified watchOS haptic feedback.
     func play(_ type: HapticType) {
         switch type {
         case .success:
             WKInterfaceDevice.current().play(.success)
         case .warning:
             WKInterfaceDevice.current().play(.failure)
         case .selection:
             WKInterfaceDevice.current().play(.click)
         case .notification:
             WKInterfaceDevice.current().play(.notification) //CORRECT
         }
     }
}


