//
//  CravingLogTriggerPageView.swift
//  CraveWatch
//
//  Uniform spacing, proportionally sized text box,
//  minimal "Steve Jobs–approved" design.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogTriggerPageView: View {
    @ObservedObject var viewModel: CravingLogViewModel
    @FocusState.Binding var isEditorFocused: Bool
    
    let onNext: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                
                // 1) Title (centered)
                Text("Log Your Craving")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(blueAccent)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // 2) Text Editor (~33% of screen height)
                MinimalWatchCraveTextEditor(
                    text: $viewModel.cravingText,
                    placeholder: "What triggered it?",
                    isFocused: $isEditorFocused,
                    characterLimit: 200
                )
                .modifier(BlueFocusModifier(isFocused: isEditorFocused))
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height * 0.33)
                
                // 3) "Next" Button
                Button(action: onNext) {
                    Text("Next")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(blueGradient)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isLoading)
            }
            // Uniform edge insets
            .padding(.top, 16)
            .padding(.horizontal, 12)
            .padding(.bottom, 16)
        }
    }
    
    // MARK: - Accent Colors & Gradients
    
    private let blueAccent = Color(hue: 0.58, saturation: 0.7, brightness: 0.85)
    
    private var blueGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: 0.58, saturation: 0.6, brightness: 0.88),
                Color(hue: 0.58, saturation: 0.8, brightness: 0.65)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

/// Subtle blue border when focused
private struct BlueFocusModifier: ViewModifier {
    let isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        Color(hue: 0.58, saturation: 0.7, brightness: 0.85)
                            .opacity(isFocused ? 0.4 : 0),
                        lineWidth: 1
                    )
            )
    }
}

