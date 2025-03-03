//
//  KeyboardAdaptiveHostingView.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    - SwiftUI wrapper that uses KeyboardAdaptiveHostingController.
//    - Embed any View in here if you want it to auto-adjust for the keyboard.
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
