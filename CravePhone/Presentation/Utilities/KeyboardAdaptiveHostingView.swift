//
//  KeyboardAdaptiveHostingView.swift
//  CravePhone
//
//  RESPONSIBILITY:
//   - Wraps a SwiftUI View in a UIViewController that adapts for the keyboard.
//   - Utilizes KeyboardAdaptiveHostingController from KeyboardAdaptiveHostingController.swift.
//

import SwiftUI

public struct KeyboardAdaptiveHostingView<Content: View>: UIViewControllerRepresentable {
    
    private let rootView: Content
    
    // MARK: - Initialization
    public init(_ rootView: Content) {
        self.rootView = rootView
    }
    
    // MARK: - UIViewControllerRepresentable
    public func makeUIViewController(context: Context) -> KeyboardAdaptiveHostingController<Content> {
        return KeyboardAdaptiveHostingController(rootView: rootView)
    }
    
    public func updateUIViewController(_ uiViewController: KeyboardAdaptiveHostingController<Content>, context: Context) {
        uiViewController.rootView = rootView
    }
}
