//
//  View+Extensions.swift
//  CravePhone
//
//  PURPOSE:
//    - SwiftUI View extensions for common patterns.
//    - Holds the single onChangeBackport extension to avoid duplication.
//
//  UNCLE BOB / SOLID:
//    - Single Responsibility: Just view extensions, nothing else.
//
//  GANG OF FOUR:
//    - "Adapter" pattern bridging older iOS onChange with the new iOS17 approach.
//
//  LAST UPDATED: <today’s date>
//

import SwiftUI

extension View {
    /// iOS 17 deprecation fix:
    /// A single, unified onChange-like modifier capturing (oldValue, newValue).
    @ViewBuilder
    func onChangeBackport<T: Equatable>(
        of value: T,
        initial: Bool = false,
        perform action: @escaping (T, T) -> Void
    ) -> some View {
        if #available(iOS 17.0, *) {
            self.modifier(OnChange17Modifier(value: value, action: action))
        } else {
            OldOnChangeWrapper(value: value, action: action) { self }
        }
    }
}

// MARK: - OldOnChangeWrapper (iOS <17)
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

private struct OnChangeLegacyModifier<T: Equatable>: ViewModifier {
    let value: T
    let action: (T, T) -> Void
    @Binding var previousValue: T
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            // iOS 17+ => new .onChange signature with two params
            content
                .onChange(of: value) { oldVal, newVal in
                    if oldVal != newVal {
                        previousValue = newVal
                        action(oldVal, newVal)
                    }
                }
        } else {
            // iOS <17 => single param onChange not deprecated
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
                if prevVal != newVal {
                    oldValue = newVal
                    action(prevVal, newVal)
                }
            }
    }
}
