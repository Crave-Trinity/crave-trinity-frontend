//
//  CravingLogView.swift
//  CraveWatch
//
//  Description:
//    Displays a custom text editor for logging cravings using the sexy gradient
//    placeholder. It ties into CravingLogViewModel to handle logging via SwiftData,
//    sends the craving to the phone, and shows a green checkmark overlay with haptic feedback.
//
//

import SwiftUI
import SwiftData

struct CravingLogView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: CravingLogViewModel
    @FocusState private var isEditorFocused: Bool
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 8) {
                // 1) Top line: TRIGGER
                Text("TRIGGER")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                // 2) Second line: Hungry     Angry
                Text("Hungry                         Angry")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
                
                // 3) Custom text editor with gradient placeholder
                WatchCraveTextEditor(
                    text: $viewModel.cravingText,
                    primaryPlaceholder: "Log Craving",
                    secondaryPlaceholder: "200 chars",
                    isFocused: $isEditorFocused,
                    characterLimit: 200
                )
                .frame(height: 60)
                
                // 4) Bottom line: Lonely     Tired
                Text("Lonely                         Tired")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
                
                // 5) Log button: triggers the log action.
                Button(action: {
                    Task {
                        viewModel.logCraving(context: context)
                    }
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
            
            // Confirmation overlay: shows a green checkmark when logging succeeds.
            if viewModel.showConfirmation {
                ConfirmationOverlay(isPresented: $viewModel.showConfirmation)
            }
        }
        // Error alert: shows if viewModel.errorMessage is set.
        .alert("Error",
               isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.dismissError() } }
               )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// MARK: - Confirmation Overlay
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

// MARK: - Premium Blue Gradient
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)

