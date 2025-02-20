//
//  CravingLogView.swift
//  CraveWatch
//

import SwiftUI
import SwiftData
import WatchKit

struct CravingLogView: View {
    @Environment(\.modelContext) private var context
    
    @State private var intensity: Int = 5
    @State private var resistance: Int = 5
    @State private var showConfirmation: Bool = false
    @State private var showAdjustScreen: Bool = false
    
    @ObservedObject var connectivityService: WatchConnectivityService

    var body: some View {
        NavigationStack {
            // 1) Static background
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                let watchWidth = WKInterfaceDevice.current().screenBounds.width
                let boxWidth = watchWidth * 0.85
                let boxHeight = boxWidth * 0.60
                
                // Buttons
                let buttonFontSize: CGFloat = 16
                let buttonFontWeight: Font.Weight = .semibold
                let buttonHeight: CGFloat = 30
                
                // Middle text color tiers
                let colorCravingTrigger = Color.white.opacity(0.9)  // “Craving” / “Trigger”
                let colorHATL = Color.white.opacity(0.7)            // “Hungry/Angry/Lonely/Tired”
                
                VStack(spacing: 8) {
                    
                    // A) Top "Intensity" button with a 2-stop “premium” gradient
                    Button {
                        showAdjustScreen = true
                    } label: {
                        Text("Intensity")
                            .font(.system(size: buttonFontSize, weight: buttonFontWeight))
                            .foregroundColor(.white)
                            .frame(width: boxWidth, height: buttonHeight)
                            .background(premiumBlueGradient)
                            .cornerRadius(6)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 2, y: 2)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 2) // minimal top spacing

                    // B) Middle box: solid darker gray, subtle shadow
                    ZStack {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color(white: 0.18)) // simpler, “premium” dark gray
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 2)
                        
                        // Centered vertical stack
                        VStack(spacing: 6) {
                            // 1) “Craving” (slightly brighter text)
                            Text("Craving")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(colorCravingTrigger)
                            
                            // 2) “Hungry Angry” row
                            HStack(spacing: 20) {
                                Text("Hungry")
                                Text("Angry")
                            }
                            .font(.system(size: 14))
                            .foregroundColor(colorHATL)
                            
                            // 3) “Lonely Tired” row
                            HStack(spacing: 20) {
                                Text("Lonely")
                                Text("Tired")
                            }
                            .font(.system(size: 14))
                            .foregroundColor(colorHATL)
                            
                            // 4) “Trigger” (slightly brighter text)
                            Text("Trigger")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(colorCravingTrigger)
                        }
                    }
                    .frame(width: boxWidth, height: boxHeight)
                    
                    // C) Bottom "Log" button with same 2-stop gradient
                    Button(action: logCraving) {
                        Text("Log")
                            .font(.system(size: buttonFontSize, weight: buttonFontWeight))
                            .foregroundColor(.white)
                            .frame(width: boxWidth, height: buttonHeight)
                            .background(premiumBlueGradient)
                            .cornerRadius(6)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 2, y: 2)
                    }
                    .buttonStyle(.plain)
                }
                // Confirmation overlay
                .overlay(ConfirmationOverlay(isPresented: $showConfirmation))
                // Navigation to Intensity/Resistance
                .navigationDestination(isPresented: $showAdjustScreen) {
                    CravingIntensityView(intensity: $intensity, resistance: $resistance)
                }
                .padding(.bottom, 8)
            }
        }
    }
    
    private func logCraving() {
        let newCraving = WatchCravingEntity(
            text: "Placeholder text",
            intensity: intensity,
            timestamp: Date()
        )
        context.insert(newCraving)
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        showConfirmation = true
        WatchHapticManager.shared.play(.success)
    }
}

// Same ConfirmationOverlay as before
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

// MARK: - Premium 2-Stop Blue Gradient
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        // Top: a bit brighter
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
        // Bottom: a bit darker
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)
