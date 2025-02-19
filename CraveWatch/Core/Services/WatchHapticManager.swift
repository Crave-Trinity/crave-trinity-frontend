// File: CraveWatch/Core/Services/WatchHapticManager.swift
// Project: CraveTrinity
// Directory: ./CraveWatch/Core/Services/
//
// Description: A watch-specific haptic feedback manager that provides
// consistent haptic feedback throughout the watch app.

import WatchKit

/// Manages haptic feedback specifically for the watch interface
final class WatchHapticManager {
    // MARK: - Singleton
    static let shared = WatchHapticManager()
    
    private init() {}
    
    // MARK: - Haptic Types
    enum FeedbackType {
        case success
        case error
        case selection
        case warning
        case intensity(level: Int)
        case custom(pattern: [WKHapticType])
    }
    
    // MARK: - Public Methods
    func play(_ type: FeedbackType) {
        switch type {
        case .success:
            WKInterfaceDevice.current().play(.success)
        case .error:
            WKInterfaceDevice.current().play(.failure)
        case .selection:
            WKInterfaceDevice.current().play(.click)
        case .warning:
            WKInterfaceDevice.current().play(.notification)
        case .intensity(let level):
            playIntensityFeedback(level: level)
        case .custom(let pattern):
            playCustomPattern(pattern)
        }
    }
    
    // MARK: - Private Methods
    private func playIntensityFeedback(level: Int) {
        let normalizedLevel = min(max(level, 1), 10)
        let baseDelay = 0.1
        
        // For higher intensities, add more clicks
        for i in 0..<normalizedLevel {
            DispatchQueue.main.asyncAfter(deadline: .now() + baseDelay * Double(i)) {
                WKInterfaceDevice.current().play(.click)
            }
        }
    }
    
    private func playCustomPattern(_ pattern: [WKHapticType]) {
        guard !pattern.isEmpty else { return }
        
        var delay: TimeInterval = 0
        let baseDelay = 0.15
        
        pattern.forEach { hapticType in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                WKInterfaceDevice.current().play(hapticType)
            }
            delay += baseDelay
        }
    }
    
    // MARK: - Convenience Methods
    func playIntense() {
        play(.intensity(level: 5))
    }
    
    func playProgressComplete() {
        play(.custom(pattern: [.click, .notification, .success]))
    }
    
    func playError() {
        play(.custom(pattern: [.failure, .failure]))
    }
}
