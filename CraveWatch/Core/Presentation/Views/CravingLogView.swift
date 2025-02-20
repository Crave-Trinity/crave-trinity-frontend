//
//  CravingLogView.swift
//  CraveWatch
//
//  Description:
//  A watchOS SwiftUI view that logs cravings with four lines:
//    1) "TRIGGER" (uppercase)
//    2) "Hungry              Angry" (14 spaces)
//    3) "Tap to log craving" (gradient placeholder -> text field on tap)
//    4) "Lonely              Tired" (14 spaces)
//  Then a "Log" button saves the craving to SwiftData and sends it to iPhone.
//
//  Created by [Your Name] on [Date]
//

import SwiftUI
import SwiftData
import WatchKit

struct CravingLogView: View {
    // MARK: - Environment & Observed

    @Environment(\.modelContext) private var context
    @ObservedObject var connectivityService: WatchConnectivityService

    // MARK: - State

    @State private var cravingText: String = ""
    @FocusState private var isCravingFocused: Bool

    @State private var intensity: Int = 5
    @State private var resistance: Int = 5
    
    @State private var showConfirmation: Bool = false
    @State private var showAdjustScreen: Bool = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // Full black background
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 8) {
                    
                    // 1) Top line: "TRIGGER"
                    Text("TRIGGER")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    // 2) Second line: "Hungry              Angry"
                    Text("Hungry              Angry")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                    
                    // 3) Middle placeholder / typed text
                    ZStack {
                        // Slightly lighter gray so gradient text pops
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.gray.opacity(0.25))
                            .frame(height: 60)
                        
                        if isCravingFocused {
                            // Show TextField if focused
                            TextField("Log craving...", text: $cravingText)
                                .focused($isCravingFocused)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .onSubmit { isCravingFocused = false }
                                .frame(height: 30)
                                .padding(.horizontal, 6)
                        } else {
                            if cravingText.isEmpty {
                                // Gradient placeholder text
                                Text("Tap to log craving")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.clear)
                                    .overlay { sexyGradient }
                                    .mask {
                                        Text("Tap to log craving")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                            } else {
                                Text(cravingText)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 6)
                            }
                        }
                    }
                    .onTapGesture {
                        isCravingFocused = true
                    }
                    
                    // 4) Bottom line: "Lonely              Tired"
                    Text("Lonely              Tired")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                    
                    // "Log" button
                    Button(action: logCraving) {
                        Text("Log")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 26)
                            .background(premiumBlueGradient)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 2)
                }
                // Slightly more upward shift for that final polish
                .padding(.top, -6)
                .padding(.bottom,2)
                .overlay(ConfirmationOverlay(isPresented: $showConfirmation))
                .navigationDestination(isPresented: $showAdjustScreen) {
                    CravingIntensityView(intensity: $intensity, resistance: $resistance)
                }
            }
        }
    }
    
    // MARK: - Actions

    private func logCraving() {
        guard !cravingText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newCraving = WatchCravingEntity(
            text: cravingText.trimmingCharacters(in: .whitespaces),
            intensity: intensity,
            timestamp: Date()
        )
        
        context.insert(newCraving)
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        showConfirmation = true
        WatchHapticManager.shared.play(.success)
        
        // Optionally clear the text
        // cravingText = ""
    }
}

// MARK: - Confirmation Overlay
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
        } else {
            EmptyView()
        }
    }
}

// MARK: - "Sexy" Gradient
fileprivate let sexyGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.65, saturation: 0.8, brightness: 0.8),
        Color(hue: 0.75, saturation: 0.9, brightness: 0.6)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

// MARK: - Premium 2-Stop Blue Gradient for the "Log" button
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7), // top
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)  // bottom
    ]),
    startPoint: .top,
    endPoint: .bottom
)

