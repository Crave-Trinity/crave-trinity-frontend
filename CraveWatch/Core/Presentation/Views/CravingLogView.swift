//
//  CravingLogView.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A watch view for logging cravings.
//               Uses the fancy WatchCraveTextEditor and the radical ResistanceBar.
//

import SwiftUI
import SwiftData

struct CravingLogView: View {
    @Environment(\.modelContext) private var context
    
    // Main text state for the craving
    @State private var cravingDescription: String = ""
    
    // Intensity from 0..10, start at 5
    @State private var intensity: Int = 5
    
    // A local state to show success overlay
    @State private var showConfirmation: Bool = false
    
    // Ties into focus for the text editor
    @FocusState private var isTextFieldFocused: Bool
    
    // Connectivity for sending data to iPhone
    @ObservedObject var connectivityService: WatchConnectivityService

    var body: some View {
        VStack(spacing: 6) {
            WatchCraveTextEditor(
                text: $cravingDescription,
                primaryPlaceholder: "Craving, Trigger",
                secondaryPlaceholder: "Hungry, Angry\nLonely, Tired",
                isFocused: $isTextFieldFocused,
                characterLimit: 50
            )
            
            ResistanceBar(intensity: $intensity)
            
            Button(action: {
                logCraving()
            }) {
                HStack {
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
        .overlay(
            ConfirmationOverlay(isPresented: $showConfirmation)
        )
        // Hide watch toolbar if text field is focused
        .toolbar(isTextFieldFocused ? .hidden : .visible)
    }

    /// Creates a new craving, inserts to SwiftData, and sends to phone
    private func logCraving() {
        // Ensure the user typed something
        guard !cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let newCraving = WatchCravingEntity(
            text: cravingDescription.trimmingCharacters(in: .whitespaces),
            intensity: intensity,
            timestamp: Date()
        )
        
        // Insert into local SwiftData
        context.insert(newCraving)
        
        // Notify phone
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        // Reset UI
        cravingDescription = ""
        intensity = 5
        showConfirmation = true
        isTextFieldFocused = false
        
        // Haptic feedback
        WatchHapticManager.shared.play(.success)
    }
}

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
                // Hide after ~1 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                }
            }
        }
    }
}
