// Theme.swift

import SwiftUI

public struct Theme {
    public struct Colors {
        public static let primary = Color.blue
        public static let secondaryBackground = Color.gray.opacity(0.2)
    }
    
    public struct Layout {
        public static let standardPadding: CGFloat = 16
        public static let cornerRadius: CGFloat = 10
    }
}
