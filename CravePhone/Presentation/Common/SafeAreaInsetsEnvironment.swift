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
                .onAppear {
                    updateInsets(proxy: proxy)
                }
                .onChange(of: proxy.safeAreaInsets) { _ in
                    updateInsets(proxy: proxy)
                }
                // The actual content (your real UI) goes *behind* this geometry layer
                .overlay(
                    content
                        .environment(\.safeAreaInsets, newInsets)
                )
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func updateInsets(proxy: GeometryProxy) {
        // proxy.safeAreaInsets is available on iOS 14+, but can be zero if parent is ignoring safe area.
        // If keyWindow is available, we fallback to real device insets from UIKit.
        let swiftUIInsets = proxy.safeAreaInsets
        let fallbackInsets = UIApplication.keyWindow?.safeAreaInsets.swiftUiInsets ?? .init()
        
        // Merge them: If SwiftUI’s geometry gives zero (due to .ignoresSafeArea),
        // we use the fallback from UIKit keyWindow.
        let finalTop = max(swiftUIInsets.top, fallbackInsets.top)
        let finalBottom = max(swiftUIInsets.bottom, fallbackInsets.bottom)
        let finalLeading = max(swiftUIInsets.leading, fallbackInsets.leading)
        let finalTrailing = max(swiftUIInsets.trailing, fallbackInsets.trailing)
        
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
