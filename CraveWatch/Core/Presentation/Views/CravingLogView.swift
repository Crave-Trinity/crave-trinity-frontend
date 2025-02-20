//
//  CravingLogView.swift
//  CraveWatch
//
//  Description:
//    Displays a text editor for logging cravings. Ties into CravingLogViewModel
//    to handle SwiftData insertion, phone connectivity, and error/confirmation states.
//
//  Created by [Your Name] on [Date]
//

import SwiftUI
import SwiftData

struct CravingLogView: View {
    // Environment
    @Environment(\.modelContext) private var context
    
    // The ViewModel controlling logic
    @ObservedObject var viewModel: CravingLogViewModel
    
    // Focus state for the text editor
    @FocusState private var isEditorFocused: Bool
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 8) {
                // 1) Top line: TRIGGER
                Text("TRIGGER")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                // 2) Second line: Hungry Angry
                Text("Hungry     Angry")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
                
                // 3) Middle text editor
                WatchCraveTextEditor(
                    text: $viewModel.cravingText,
                    primaryPlaceholder: "Tap to log craving",
                    secondaryPlaceholder: "Max 50 chars",
                    isFocused: $isEditorFocused,
                    characterLimit: 50
                )
                .frame(height: 60)
                
                // 4) Bottom line: Lonely Tired
                Text("Lonely     Tired")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
                
                // 5) Log button
                Button(action: {
                    viewModel.logCraving(context: context)
                }) {
                    Text("Log")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 26)
                        .background(premiumBlueGradient)
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(.top, -2)
            .padding(.bottom, 6)
            
            // Success confirmation overlay
            if viewModel.showConfirmation {
                ConfirmationOverlay(isPresented: $viewModel.showConfirmation)
            }
        }
        // Show error alert if needed
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.dismissError() } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// (Optional) reuse the same ConfirmationOverlay from your existing code
struct ConfirmationOverlay: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                }
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Premium Blue Gradient (same as CravingIntensityView)
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7), // top
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)  // bottom
    ]),
    startPoint: .top,
    endPoint: .bottom
)

