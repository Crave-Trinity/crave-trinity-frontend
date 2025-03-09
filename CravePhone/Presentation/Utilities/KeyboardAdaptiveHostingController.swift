//
//  KeyboardAdaptiveHostingController.swift
//  CravePhone
//
//  RESPONSIBILITY:
//   - A custom UIHostingController that helps avoid keyboard overlap.
//   - On iOS 16+, rely on SwiftUI's built-in avoidance.
//   - On older iOS, adjust safe area insets manually.
//

import SwiftUI
import UIKit

@available(iOS 13.0, *)
public class KeyboardAdaptiveHostingController<Content: View>: UIHostingController<Content> {

    private var keyboardWillShowObserver: NSObjectProtocol?
    private var keyboardWillHideObserver: NSObjectProtocol?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 16.0, *) {
            // SwiftUI handles keyboard avoidance automatically.
        } else {
            addKeyboardObservers()
        }
    }

    // MARK: - Fallback Approach
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
                    let tabBarHeight: CGFloat = 49
                    self.additionalSafeAreaInsets.bottom = max(
                        0,
                        keyboardHeight - self.view.safeAreaInsets.bottom - tabBarHeight
                    )
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
