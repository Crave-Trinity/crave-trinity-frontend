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
    
    @State private var cravingDescription: String = ""
    @State private var intensity: Int = 5  // Starting value
    @State private var showConfirmation: Bool = false
    @FocusState private var isTextFieldFocused: Bool
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
            
            // Show an HStack with the numeric label on the left,
            // and the vertical bar on the right
            HStack(alignment: .center, spacing: 8) {
                // The numeric label "5"
                VStack(spacing: 2) {
                    Text("\(intensity)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Intensity")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                // The new vertical bar
                VerticalIntensityBar(intensity: $intensity)
            }
            .padding(.vertical, 4)
            
            Button("Log") {
                logCraving()
            }
            .buttonStyle(.bordered)
            .tint(.blue)
            .buttonBorderShape(.roundedRectangle)
        }
        .padding(.horizontal, 8)
        .overlay(
            ConfirmationOverlay(isPresented: $showConfirmation)
        )
        .toolbar(isTextFieldFocused ? .hidden : .visible)
    }

    private func logCraving() {
        guard !cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let newCraving = WatchCravingEntity(
            text: cravingDescription.trimmingCharacters(in: .whitespaces),
            intensity: intensity,
            timestamp: Date()
        )
        
        context.insert(newCraving)
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        cravingDescription = ""
        intensity = 5
        showConfirmation = true
        isTextFieldFocused = false
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                }
            }
        }
    }
}
