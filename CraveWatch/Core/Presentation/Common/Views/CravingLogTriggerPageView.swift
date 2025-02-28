//
//  CravingLogTriggerPageView.swift
//  CraveWatch
//
//  Final iteration: A clean, centered layout that fills horizontal space.
//  Title is centered at the top, the text editor expands to fill the width,
//  and the "Next" button aligns consistently.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogTriggerPageView: View {
    // MARK: - Dependencies
    
    @ObservedObject var viewModel: CravingLogViewModel

    @FocusState.Binding var isEditorFocused: Bool
    let onNext: () -> Void

    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 12) {
            
            // Title centered at the top
            Text("Log Your Craving")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(blueAccent)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
            
            // Text editor fills the horizontal space minus padding
            MinimalWatchCraveTextEditor(
                text: $viewModel.cravingText,
                placeholder: "What triggered it?",
                isFocused: $isEditorFocused,
                characterLimit: 200
            )
            .modifier(BlueFocusModifier(isFocused: isEditorFocused))
            .frame(maxWidth: .infinity)  // Fill the available width
            .frame(height: 100)          // Increase if you want more vertical room
            
            // "Next" button also expands horizontally
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
            
            Spacer(minLength: 0)
        }
        // Single horizontal padding for the entire column
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
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

