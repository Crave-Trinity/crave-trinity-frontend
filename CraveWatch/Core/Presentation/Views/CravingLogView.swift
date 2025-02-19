//
//  CravingLogView.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description:
//    - A more aggressive side-by-side layout:
//      a bigger text box on the left,
//      a thin vertical slider on the right,
//      firmly left of the crown’s green indicator (larger negative padding),
//      and a smaller "Log" button at the bottom.
//

import SwiftUI
import SwiftData

struct CravingLogView: View {
    @Environment(\.modelContext) private var context
    
    // Craving text & slider value
    @State private var cravingDescription: String = ""
    @State private var intensity: Int = 5
    
    // Confirmation overlay
    @State private var showConfirmation: Bool = false
    
    // Watch keyboard focus
    @FocusState private var isTextFieldFocused: Bool
    
    // Connectivity
    @ObservedObject var connectivityService: WatchConnectivityService

    var body: some View {
        VStack(spacing: 8) {
            
            // 1) Horizontal arrangement
            HStack(spacing: 4) {
                // A) Bigger text box
                WatchCraveTextEditor(
                    text: $cravingDescription,
                    primaryPlaceholder: "Craving, Trigger",
                    secondaryPlaceholder: "Hungry, Angry\nLonely, Tired",
                    isFocused: $isTextFieldFocused,
                    characterLimit: 80
                )
                .frame(width: 120, height: 130) // bigger
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                Spacer(minLength: 0)
                
                // B) Thin vertical slider, pushed further left of the crown
                VerticalIntensityBar(value: $intensity, barWidth: 4)
                    .padding(.trailing, -16) // bigger negative => further left from the crown indicator
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 6)
            
            // 2) Smaller "Log" button
            Button(action: logCraving) {
                Text("Log")
                    .font(.system(size: 12)) // smaller text
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
            }
            .buttonStyle(.bordered)
            .tint(.blue)
            .buttonBorderShape(.roundedRectangle)
        }
        .overlay(ConfirmationOverlay(isPresented: $showConfirmation))
        // Hide watch toolbar if text field is focused
        .toolbar(isTextFieldFocused ? .hidden : .visible)
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
        }
    }
}
