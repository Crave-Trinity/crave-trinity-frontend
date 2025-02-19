//
//  CravingLogView.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description:
//    - An aggressively side-by-side layout:
//      a narrower text box on the left,
//      a thin vertical slider on the right, pushed further toward the crown,
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
        VStack(spacing: 4) {  // Reduced vertical spacing
            // 1) Horizontal arrangement
            HStack(spacing: 2) { // Tighter horizontal spacing
                // A) Narrower text box
                WatchCraveTextEditor(
                    text: $cravingDescription,
                    primaryPlaceholder: "Craving, Trigger",
                    secondaryPlaceholder: "Hungry, Angry\nLonely, Tired",
                    isFocused: $isTextFieldFocused,
                    characterLimit: 80
                )
                .frame(width: 100, height: 130) // Slightly narrower width
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                // B) Thin vertical slider, pushed toward the crown
                VerticalIntensityBar(value: $intensity, barWidth: 4)
                    .padding(.trailing, -20) // Larger negative padding
                    .offset(x: -4)           // Optional additional shift
            }
            // Remove extra horizontal padding to keep things tight
            .padding(.horizontal, 0)

            // 2) Smaller "Log" button
            Button(action: logCraving) {
                Text("Log")
                    .font(.system(size: 12))
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
