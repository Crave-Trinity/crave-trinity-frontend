//
//  CravingLogView.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A watch view for logging cravings. Includes text input, intensity control,
//               and a confirmation overlay once saved.
//

import SwiftUI
import SwiftData

struct CravingLogView: View {
    // We get the SwiftData context from the environment
    @Environment(\.modelContext) private var context
    
    // A local text state for the craving description
    @State private var cravingDescription: String = ""
    
    // A local state for intensity, default to 5
    @State private var intensity: Int = 5
    
    // A local state to show a "success" overlay
    @State private var showConfirmation: Bool = false
    
    // FANCY FOCUS: The parent can track if the text field is focused
    @FocusState private var isTextFieldFocused: Bool
    
    // We observe the watch connectivity service for phone reachability, etc.
    @ObservedObject var connectivityService: WatchConnectivityService

    var body: some View {
        VStack(spacing: 4) {
            // Custom text editor with fancy FocusState
            WatchCraveTextEditor(
                text: $cravingDescription,
                primaryPlaceholder: "Craving, Trigger",
                secondaryPlaceholder: "Hungry, Angry\nLonely, Tired",
                isFocused: $isTextFieldFocused,
                characterLimit: 50
            )

            SleekIntensityControl(intensity: $intensity, showButtons: false)

            Button(action: {
                logCraving()
            }) {
                HStack{
                    Text("Log")
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                }
            }
            .buttonStyle(.bordered)
            .tint(.blue)
            .buttonBorderShape(.roundedRectangle)
        }
        .padding(.horizontal, 8)
        // Overlay a confirmation checkmark when the craving logs successfully
        .overlay(
            ConfirmationOverlay(isPresented: $showConfirmation)
        )
        // Hide the watch toolbar (if any) when text field is focused
        .toolbar(isTextFieldFocused ? .hidden : .visible)
    }

    /// Saves a new craving to SwiftData and sends it to the phone
    private func logCraving() {
        // Make sure the user typed something
        guard !cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        // Create a new WatchCravingEntity
        let newCraving = WatchCravingEntity(
            text: cravingDescription.trimmingCharacters(in: .whitespaces),
            intensity: intensity,
            timestamp: Date()
        )
        
        // Insert into local SwiftData
        context.insert(newCraving)
        
        // Send to iPhone
        connectivityService.sendCravingToPhone(craving: newCraving)

        // Reset UI state
        cravingDescription = ""
        intensity = 5
        showConfirmation = true
        isTextFieldFocused = false

        // Provide haptic feedback
        WatchHapticManager.shared.play(.success)
    }
}

// A small overlay that shows a green checkmark when the craving logs successfully.
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
                // Hide after 1 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isPresented = false
                }
            }
        }
    }
}
