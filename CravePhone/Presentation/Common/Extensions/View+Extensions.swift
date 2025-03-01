//
//  View+Extensions.swift
//  CravePhone
//
//  SwiftUI View extensions for common UI patterns.
//  Includes an onChangeBackport that tracks both old and new values,
//  without triggering deprecation warnings on iOS 17.
//

import SwiftUI

// MARK: - Common Utility Modifiers

extension View {
    
    /// Adds vertical padding of a specified amount.
    func verticalPadding(_ amount: CGFloat) -> some View {
        self.padding(.vertical, amount)
    }
    
    /// Adds horizontal padding of a specified amount.
    func horizontalPadding(_ amount: CGFloat) -> some View {
        self.padding(.horizontal, amount)
    }
    
    /// Applies a card-style background with a given color, corner radius, and shadow.
    func cardStyle(
        backgroundColor: Color = CraveTheme.Colors.cardBackground,
        cornerRadius: CGFloat = CraveTheme.Layout.cardCornerRadius,
        shadowRadius: CGFloat = 4
    ) -> some View {
        self.padding(CraveTheme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .shadow(color: Color.black.opacity(0.15), radius: shadowRadius, x: 0, y: 2)
            )
    }
    
    /// Draws an outline with the specified color, corner radius, and line width.
    func outlined(
        color: Color = Color.gray.opacity(0.3),
        cornerRadius: CGFloat = CraveTheme.Layout.cornerRadius,
        lineWidth: CGFloat = 1
    ) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: lineWidth)
        )
    }
    
    /// Conditionally overlays a view if a condition is true.
    func overlayIf<Content: View>(_ condition: Bool, content: @escaping () -> Content) -> some View {
        self.overlay(
            Group {
                if condition {
                    content()
                }
            }
        )
    }
}

// MARK: - onChangeBackport Extension

extension View {
    
    /// A unified onChange-like modifier that calls `action(oldValue, newValue)`.
    /// - For iOS 17: uses the new `.onChange(of:) { oldValue, newValue in }` signature (no warning).
    /// - For earlier iOS: uses the single-parameter `.onChange(of:) { newValue in }`, which is *not* deprecated there.
    /// - This ensures you can track both old and new values without triggering iOS 17 warnings.
    ///
    /// - Parameters:
    ///   - value: The Equatable value to observe.
    ///   - initial: A placeholder parameter (in case you had code referencing it). Default is `false`.
    ///   - action: Closure that receives `(oldValue, newValue)`.
    @ViewBuilder
    func onChangeBackport<T: Equatable>(
        of value: T,
        initial: Bool = false,
        perform action: @escaping (T, T) -> Void
    ) -> some View {
        if #available(iOS 17.0, *) {
            // On iOS 17+, use the new two-parameter .onChange
            self.modifier(OnChange17Modifier(value: value, action: action))
        } else {
            // iOS <17 fallback: an old approach is not deprecated in those versions
            OldOnChangeWrapper(value: value, action: action) { self }
        }
    }
}

// MARK: - OldOnChangeWrapper
// For iOS <17, we can safely use .onChange(of:) { newValue in ... }
// (no warning on older OS versions)

private struct OldOnChangeWrapper<T: Equatable, Content: View>: View {
    
    let value: T
    let action: (T, T) -> Void
    let content: () -> Content
    
    @State private var previousValue: T
    
    init(
        value: T,
        action: @escaping (T, T) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.value = value
        self.action = action
        self.content = content
        _previousValue = State(initialValue: value)
    }
    
    var body: some View {
        content()
            .modifier(OnChangeLegacyModifier(value: value, action: action, previousValue: $previousValue))
    }
}

/// A custom ViewModifier that does an availability check to avoid warnings in iOS 17
private struct OnChangeLegacyModifier<T: Equatable>: ViewModifier {
    
    let value: T
    let action: (T, T) -> Void
    @Binding var previousValue: T
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            // iOS 17+ => use the new two-parameter approach, so no warnings
            content
                .onChange(of: value) { oldVal, newVal in
                    if oldVal != newVal {
                        previousValue = newVal
                        action(oldVal, newVal)
                    }
                }
        } else {
            // iOS <17 => old single-parameter .onChange is not deprecated
            content
                .onChange(of: value) { newVal in
                    let oldVal = previousValue
                    if oldVal != newVal {
                        previousValue = newVal
                        action(oldVal, newVal)
                    }
                }
        }
    }
}

// MARK: - OnChange17Modifier
// For iOS 17, we can do .onChange(of: value) { oldValue, newValue in ... }

@available(iOS 17.0, *)
private struct OnChange17Modifier<T: Equatable>: ViewModifier {
    
    let value: T
    let action: (T, T) -> Void
    
    @State private var oldValue: T
    
    init(value: T, action: @escaping (T, T) -> Void) {
        self.value = value
        self.action = action
        _oldValue = State(initialValue: value)
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: value) { prevVal, newVal in
                // No warnings in iOS 17 with this new signature
                if prevVal != newVal {
                    oldValue = newVal
                    action(prevVal, newVal)
                }
            }
    }
}
