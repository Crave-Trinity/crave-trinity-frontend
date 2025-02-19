//
//  CravingLogView.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description:
//    - Large text box at top
//    - A single vertical intensity bar on the right
//      that moves the numeric label up as the fill grows
//    - A small "Log" button at the bottom
//

import SwiftUI
import SwiftData

struct CravingLogView: View {
    @Environment(\.modelContext) private var context
    
    @State private var cravingDescription: String = ""
    @State private var intensity: Int = 5
    
    @State private var showConfirmation: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    
    @ObservedObject var connectivityService: WatchConnectivityService

    var body: some View {
        VStack(spacing: 8) {
            // 1) Big text editor
            WatchCraveTextEditor(
                text: $cravingDescription,
                primaryPlaceholder: "Craving, Trigger",
                secondaryPlaceholder: "Hungry, Angry\nLonely, Tired",
                isFocused: $isTextFieldFocused,
                characterLimit: 80
            )
            .frame(height: 80)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // 2) The bar on the right + label "Intensity"
            HStack(alignment: .center) {
                Spacer()
                
                VStack(spacing: 4) {
                    VerticalIntensityBar(value: $intensity)
                    
                    Text("Intensity")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            
            // 3) The smaller Log button
            Button(action: logCraving) {
                Text("Log")
                    .font(.system(size: 14))
                    .frame(width: 80)
                    .padding(.vertical, 4)
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
    
    private func logCraving() {
        guard !cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newCraving = WatchCravingEntity(
            text: cravingDescription.trimmingCharacters(in: .whitespaces),
            intensity: intensity,
            timestamp: Date()
        )
        context.insert(newCraving)
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        // Reset
        cravingDescription = ""
        intensity = 5
        showConfirmation = true
        isTextFieldFocused = false
        
        WatchHapticManager.shared.play(.success)
    }
}

/// Overlays a green checkmark
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
