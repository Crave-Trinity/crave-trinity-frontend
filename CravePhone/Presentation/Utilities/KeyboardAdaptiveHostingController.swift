//
//  KeyboardAdaptiveHostingController.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    A custom UIHostingController that automatically adjusts layout for the keyboard.
//    - On iOS 16+: Uses UIKeyboardLayoutGuide.
//    - On older iOS: Falls back to manual notification-based adjustments.
//
//  DESIGN FOR STEVE JOBS, CODE LIKE UNCLE BOB:
//    - Single Responsibility: Only handles the keyboard.
//    - Open for extension, closed for modification.
//    - No duplication of logic across multiple views.
//
import SwiftUI
import UIKit

@available(iOS 13.0, *)
public class KeyboardAdaptiveHostingController<Content: View>: UIHostingController<Content> {

    private var keyboardWillShowObserver: NSObjectProtocol?
    private var keyboardWillHideObserver: NSObjectProtocol?

    public override func viewDidLoad() {
        super.viewDidLoad()

        // iOS 16 and later: Pin bottom of the SwiftUI content to the keyboard layout guide’s top anchor.
        if #available(iOS 16.0, *) {
            let guide = view.keyboardLayoutGuide
            // The first subview is where SwiftUI’s content is hosted.
            if let swiftUIView = view.subviews.first {
                swiftUIView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    swiftUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    swiftUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    swiftUIView.topAnchor.constraint(equalTo: view.topAnchor),
                    swiftUIView.bottomAnchor.constraint(equalTo: guide.topAnchor)
                ])
            }
        } else {
            // Fallback for iOS < 16
            addKeyboardObservers()
        }
    }

    // MARK: - Legacy Fallback
    private func addKeyboardObservers() {
        keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.adjustForKeyboard(notification: notification, isShowing: true)
        }

        keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.adjustForKeyboard(notification: notification, isShowing: false)
        }
    }

    private func adjustForKeyboard(notification: Notification, isShowing: Bool) {
        guard let userInfo = notification.userInfo else { return }

        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.3
        let curveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
                        ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationOptions = UIView.AnimationOptions(rawValue: curveRaw)

        var keyboardHeight: CGFloat = 0
        if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
        }

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: animationOptions,
            animations: {
                if isShowing {
                    // Increase safe area so the content is pushed above the keyboard
                    self.additionalSafeAreaInsets.bottom = keyboardHeight - self.view.safeAreaInsets.bottom
                } else {
                    self.additionalSafeAreaInsets.bottom = 0
                }
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }

    deinit {
        if let observer = keyboardWillShowObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = keyboardWillHideObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
