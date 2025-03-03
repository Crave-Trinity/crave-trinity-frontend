//
//  KeyboardAdaptiveHostingView.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    - SwiftUI wrapper that uses a UIHostingController subclass to adapt for keyboard insets.
//    - On iOS 16+, it pins content to the keyboard layout guide.
//    - On older iOS, it adjusts additionalSafeAreaInsets.
//
//  DESIGN FOR STEVE JOBS, CODE LIKE UNCLE BOB:
//    - Single Responsibility: Manage keyboard insets in a bridging controller.
//    - No duplication or leaky abstractions.
//

import SwiftUI
import UIKit

@available(iOS 13.0, *)
public struct KeyboardAdaptiveHostingView<Content: View>: UIViewControllerRepresentable {
    private let rootView: Content
    
    public init(_ rootView: Content) {
        self.rootView = rootView
    }
    
    public func makeUIViewController(context: Context) -> KeyboardAdaptiveHostingController<Content> {
        KeyboardAdaptiveHostingController(rootView: rootView)
    }
    
    public func updateUIViewController(_ uiViewController: KeyboardAdaptiveHostingController<Content>, context: Context) {
        uiViewController.rootView = rootView
    }
}
