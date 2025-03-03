//
//  KeyboardAdaptiveHostingView.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    SwiftUI wrapper that uses KeyboardAdaptiveHostingController.
//    This is the SwiftUI "entry point" for a content View that
//    automatically adjusts for the keyboard.
//
//  DESIGN FOR STEVE JOBS, CODE LIKE UNCLE BOB:
//    - Minimal bridging code to keep concerns separate.
//    - Reusable across your entire app.
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
        // Update the rootView whenever our SwiftUI content changes
        uiViewController.rootView = rootView
    }
}
