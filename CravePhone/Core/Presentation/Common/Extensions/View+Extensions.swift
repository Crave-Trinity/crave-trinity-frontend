import SwiftUI

public extension View {
    func roundedBorder() -> some View {
        self.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
    }
}

