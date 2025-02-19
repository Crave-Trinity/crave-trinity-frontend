//
//  CravingLogView.swift
//  CraveWatch
//
//  Directory: CraveWatch/Core/Presentation/Views
//
//  Description:
//  A refined watchOS view for logging cravings.  Emphasizes simplicity,
//  clarity, and a focused user experience.  Designed for quick,
//  intuitive input.
//

import SwiftUI
import SwiftData

struct CravingLogView: View {
    @Environment(\.modelContext) private var context
    @State private var cravingDescription: String = ""
    @State private var intensity: Int = 5
    @State private var showConfirmation: Bool = false
    @FocusState private var isTextFieldFocused: Bool // Focus state for the text field
    @ObservedObject var connectivityService: WatchConnectivityService

    var body: some View {
        VStack(spacing: 8) {
            // Pass $isTextFieldFocused to WatchCraveTextEditor
            WatchCraveTextEditor(text: $cravingDescription,
                                 placeholder: "Craving, Trigger",
                                 characterLimit: 50)
            .focused($isTextFieldFocused)

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
        .overlay(
            ConfirmationOverlay(isPresented: $showConfirmation)
        )
        .navigationTitle("Log Craving")
        .toolbar(isTextFieldFocused ? .hidden : .visible) // Hide toolbar when editing
    }

    private func logCraving() {
        guard !cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        let newCraving = WatchCravingEntity(text: cravingDescription.trimmingCharacters(in: .whitespaces), intensity: intensity, timestamp: Date())
        context.insert(newCraving)
        connectivityService.sendCravingToPhone(craving: newCraving)

        cravingDescription = ""
        intensity = 5
        showConfirmation = true
        isTextFieldFocused = false // Dismiss keyboard after logging

        WatchHapticManager.shared.play(.success)
    }
}

// Separate, reusable confirmation overlay
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isPresented = false
                }
            }
        }
    }
}
