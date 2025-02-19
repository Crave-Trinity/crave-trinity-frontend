import SwiftUI

public struct CraveButton: View {
    public let title: String
    public let action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .background(CRAVEDesignSystem.Colors.primary)
                .foregroundColor(.white)
                .cornerRadius(CRAVEDesignSystem.Layout.cornerRadius)
        }
    }
}
