//
//  SafeAreaInsetsEnvironment.swift
//  CravePhone
//
//  DESCRIPTION:
//  - This file provides a custom EnvironmentKey and EnvironmentValues extension
//    to read the real safe area insets, even if a parent view has called
//    .ignoresSafeArea().
//
//  UNCLE BOB / GANG OF FOUR / CLEAN ARCHITECTURE:
//  - Single Responsibility: This file deals with environment-based safe area insets only.
//  - Dependency Inversion: Higher-level views can rely on the environment instead
//    of directly interrogating UIKit or keyWindow.
//
//  “DESIGNED FOR STEVE JOBS”:
//  - Minimal friction for SwiftUI devs; just .environment(\.safeAreaInsets, …).
//
//  LAST UPDATED: <today's date>
//

import SwiftUI

// MARK: - Environment Key
private struct SafeAreaInsetsKey: EnvironmentKey {
    static let defaultValue: EdgeInsets = .init()
}

// MARK: - Environment Values Extension
extension EnvironmentValues {
    /// Use `@Environment(\.safeAreaInsets) private var insets` in a View to retrieve the actual device
    /// safe area insets (top, bottom, leading, trailing).
    var safeAreaInsets: EdgeInsets {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}

// MARK: - UIKit Helper
extension UIApplication {
    /// Attempt to find the current key window using scenes, avoiding deprecated APIs.
    static var keyWindow: UIWindow? {
        // We must run on main thread to avoid SwiftUI concurrency crashes
        guard Thread.isMainThread else { return nil }
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

// MARK: - An Optional SwiftUI ViewModifier to update the Environment
/// Usage in your top-level App or root view:
/// ```
/// .modifier(SafeAreaInsetsEnvironmentReader())
/// ```
/// This ensures the environment is updated with the current safe area each time the layout changes.
struct SafeAreaInsetsEnvironmentReader: ViewModifier {
    @Environment(\.safeAreaInsets) private var currentInsets
    @State private var newInsets: EdgeInsets = .init()

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            Color.clear
                // 1) Update insets once on appear
                .onAppear {
                    updateInsets(proxy: proxy)
                }
                // 2) React to changes in proxy.safeAreaInsets
                #if swift(>=5.9)
                // iOS 17+ / Swift 5.9+ approach (two-parameter onChange)
                .onChange(of: proxy.safeAreaInsets, initial: false) { oldValue, newValue in
                    // We could use oldValue & newValue if needed,
                    // but we only need to recalc once any change occurs
                    updateInsets(proxy: proxy)
                }
                #else
                // Fallback for older iOS / Swift versions
                .onChange(of: proxy.safeAreaInsets) { _ in
                    updateInsets(proxy: proxy)
                }
                #endif
                // 3) Overlay the real content, injecting updated safeAreaInsets
                .overlay(
                    content
                        .environment(\.safeAreaInsets, newInsets)
                )
        }
        // Let the container go full bleed, so we can measure insets properly
        .edgesIgnoringSafeArea(.all)
    }

    private func updateInsets(proxy: GeometryProxy) {
        // SwiftUI geometry-based insets
        let swiftUIInsets = proxy.safeAreaInsets

        // UIKit fallback insets (in case SwiftUI returns 0 when ignoring safe area)
        let fallbackInsets = UIApplication.keyWindow?.safeAreaInsets.swiftUiInsets ?? .init()

        // Merge them: if SwiftUI geometry is zero, fallback to UIKit
        let finalTop = max(swiftUIInsets.top, fallbackInsets.top)
        let finalBottom = max(swiftUIInsets.bottom, fallbackInsets.bottom)
        let finalLeading = max(swiftUIInsets.leading, fallbackInsets.leading)
        let finalTrailing = max(swiftUIInsets.trailing, fallbackInsets.trailing)

        // Store merged insets
        newInsets = EdgeInsets(
            top: finalTop,
            leading: finalLeading,
            bottom: finalBottom,
            trailing: finalTrailing
        )
    }
}

// MARK: - UIEdgeInsets -> EdgeInsets
extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        .init(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
