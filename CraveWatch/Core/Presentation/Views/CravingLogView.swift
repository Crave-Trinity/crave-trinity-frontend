//
//  CravingLogView.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: The primary watch view for logging cravings.
//               Includes an enlarged text editor, a horizontal Resistance bar,
//               a vertical Intensity bar, and a Log button placed lower on the screen.
import SwiftUI
import SwiftData

struct CravingLogView: View {
    // SwiftData context for local storage
    @Environment(\.modelContext) private var context
    
    // User-entered craving text, increased size
    @State private var cravingDescription: String = ""
    
    // "Resistance" value from 0 to 10, default to 5
    @State private var resistance: Int = 5
    
    // "Intensity" value from 0 to 10, default to 5
    @State private var intensity: Int = 5
    
    // Overlay state for success confirmation
    @State private var showConfirmation: Bool = false
    
    // FocusState for controlling the text editor
    @FocusState private var isTextFieldFocused: Bool
    
    // Connectivity service for sending data to the phone
    @ObservedObject var connectivityService: WatchConnectivityService

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Enlarged text editor
                WatchCraveTextEditor(
                    text: $cravingDescription,
                    primaryPlaceholder: "Craving, Trigger",
                    secondaryPlaceholder: "Hungry, Angry\nLonely, Tired",
                    isFocused: $isTextFieldFocused,
                    characterLimit: 100  // Increased character limit for more input
                )
                .frame(height: 80) // Increase text editor height
                
                // Horizontal Resistance bar (tap to focus for crown input)
                HorizontalResistanceBar(value: $resistance)
                
                // Vertical Intensity bar with numeric label on the left
                HStack(spacing: 8) {
                    // Display the current intensity value
                    VStack(spacing: 2) {
                        Text("\(intensity)")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Intensity")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    // Vertical slider for intensity
                    VerticalIntensityBar(value: $intensity)
                }
                
                // Add spacer to push the button further down
                Spacer().frame(height: 20)
                
                // Log button, moved lower
                Button(action: logCraving) {
                    Text("Log")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .buttonBorderShape(.roundedRectangle)
            }
            .padding(.horizontal, 12)
        }
        .overlay(
            ConfirmationOverlay(isPresented: $showConfirmation)
        )
        .toolbar(isTextFieldFocused ? .hidden : .visible)
    }
    
    /// Creates a new craving and sends it to the phone.
    private func logCraving() {
        guard !cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newCraving = WatchCravingEntity(
            text: cravingDescription.trimmingCharacters(in: .whitespaces),
            intensity: intensity,
            timestamp: Date()
        )
        
        context.insert(newCraving)
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        // Reset the UI values
        cravingDescription = ""
        resistance = 5
        intensity = 5
        showConfirmation = true
        isTextFieldFocused = false
        
        WatchHapticManager.shared.play(.success)
    }
}

/// Overlays a green checkmark for about 1 second after logging.
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
