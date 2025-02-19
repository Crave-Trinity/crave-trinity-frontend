//
//  CravingLogView.swift
//  CraveWatch
//

import SwiftUI
import SwiftData
import WatchKit // for WKInterfaceDevice

struct CravingLogView: View {
    @Environment(\.modelContext) private var context
    
    // Local state
    @State private var cravingDescription: String = ""
    @State private var intensity: Int = 5
    @State private var resistance: Int = 5  // Shared with next screen
    @State private var showConfirmation: Bool = false
    @State private var showAdjustScreen: Bool = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    @ObservedObject var connectivityService: WatchConnectivityService

    var body: some View {
        NavigationStack {
            ScrollView {
                // Dynamically get watch width
                let watchWidth = WKInterfaceDevice.current().screenBounds.width
                
                // Make the text editor ~80% of watch width
                let editorWidth = watchWidth * 0.80
                let editorHeight = editorWidth  // square-ish shape
                
                // Decide on font size for big vs. small watch
                let buttonFontSize: CGFloat = (watchWidth > 180) ? 16 : 14

                VStack(spacing: 10) {
                    
                    // A) Larger text box
                    WatchCraveTextEditor(
                        text: $cravingDescription,
                        primaryPlaceholder: "Craving, Trigger",
                        secondaryPlaceholder: "Hungry, Angry\nLonely, Tired",
                        isFocused: $isTextFieldFocused,
                        characterLimit: 80
                    )
                    .frame(width: editorWidth, height: editorHeight)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                    // B) Thinner "Log" button, same width as text box
                    Button(action: logCraving) {
                        Text("Log")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: buttonFontSize, weight: .bold))
                            .foregroundColor(.white)
                    }
                    // Match the text editor's width, but keep a smaller height
                    .frame(width: editorWidth, height: 30)
                    .background(Color.blue)
                    .cornerRadius(3)
                    
                    // C) “Intensity” button (navigates to both Intensity & Resistance)
                    Button {
                        showAdjustScreen = true
                    } label: {
                        Text("Intensity")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(width: editorWidth, height: 28)
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(3)
                    .padding(.top, 4)
                }
                .overlay(ConfirmationOverlay(isPresented: $showConfirmation))
                .toolbar(isTextFieldFocused ? .hidden : .visible)
                .navigationDestination(isPresented: $showAdjustScreen) {
                    CravingAdjustView(intensity: $intensity, resistance: $resistance)
                }
                .padding(.bottom, 12) // extra bottom padding
            }
        }
    }
    
    private func logCraving() {
        guard !cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newCraving = WatchCravingEntity(
            text: cravingDescription.trimmingCharacters(in: .whitespaces),
            intensity: intensity,
            timestamp: Date()
        )
        context.insert(newCraving)
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        // Reset after logging
        cravingDescription = ""
        intensity = 5
        resistance = 5
        showConfirmation = true
        isTextFieldFocused = false
        
        WatchHapticManager.shared.play(.success)
    }
}

// Confirmation overlay for after logging
struct ConfirmationOverlay: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                }
            }
        }
    }
}
