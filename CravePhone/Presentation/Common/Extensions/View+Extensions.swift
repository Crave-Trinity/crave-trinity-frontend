//=========================================
//  View+Extensions.swift
//  CravePhone
//
//  PURPOSE:
//    - SwiftUI View extensions for backporting onChange to iOS <17.
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: Only view extensions.
//
//  GANG OF FOUR:
//    - "Adapter" bridging older & newer iOS onChange behaviors.
//
//  LAST UPDATED: <today’s date>
//=========================================
import SwiftUI

extension View {
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
            content
                .onChange(of: value) { oldVal, newVal in
                    if oldVal != newVal {
                        previousValue = newVal
                        action(oldVal, newVal)
                    }
                }
        } else {
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
