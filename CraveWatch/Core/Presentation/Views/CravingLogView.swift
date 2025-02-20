//
//  CravingLogView.swift
//  CraveWatch
//
//  Description:
//  A watchOS SwiftUI view that logs cravings. It shows four lines of text:
//  1) "TRIGGER"
//  2) "HUNGRY ANGRY"
//  3) A tappable gradient placeholder: "TAP TO LOG CRAVING" (switches to a TextField on tap)
//  4) "LONELY TIRED"
//  Lastly, a "Log" button saves the craving.
//
//  NOTE:
//  - Uses overlay+mask to apply a gradient to text. This prevents the "foregroundStyle"
//    compile error on watchOS.
//  - Assumes you have a WatchCravingEntity and a WatchConnectivityService set up.
//  - If your project references "CravingIntensityView" or other classes, make sure
//    those exist. Otherwise, remove those references.
//
//  Created by YOU on [Date].
//

import SwiftUI
import SwiftData
import WatchKit

struct CravingLogView: View {
    // MARK: - Environment & Observed Properties

    /// The SwiftData model context for saving new cravings
    @Environment(\.modelContext) private var context
    
    /// Your custom watch connectivity service
    @ObservedObject var connectivityService: WatchConnectivityService

    // MARK: - Focus & Text Input States

    /// The actual text the user types in
    @State private var cravingText: String = ""
    
    /// A SwiftUI FocusState that determines if the TextField is active
    @FocusState private var isCravingFocused: Bool

    // MARK: - Other View States

    /// Example "intensity" integer for adjusting craving intensity
    @State private var intensity: Int = 5
    
    /// Example "resistance" integer for adjusting craving resistance
    @State private var resistance: Int = 5
    
    /// Controls the overlay that shows a checkmark after logging
    @State private var showConfirmation: Bool = false
    
    /// Example boolean that navigates to an "Intensity" view (if needed)
    @State private var showAdjustScreen: Bool = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // 1) Full black background to keep the watch screen dark
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                // 2) Vertical layout with your 4 lines + Log button
                VStack(spacing: 6) {
                    
                    // A) Top line: "TRIGGER"
                    Text("TRIGGER")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    // B) Second line: "HUNGRY ANGRY"
                    Text("HUNGRY ANGRY")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                    
                    // C) Middle box with placeholder or typed text
                    ZStack {
                        // Rounded background behind the placeholder/field
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 60)  // Adjust as needed for watch screen size
                        
                        // If the user is currently focused on text input, show a TextField
                        if isCravingFocused {
                            TextField("Log craving...", text: $cravingText)
                                .focused($isCravingFocused)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .onSubmit {
                                    // Hide keyboard when user taps "Done" on watch
                                    isCravingFocused = false
                                }
                                .frame(height: 30)
                                .padding(.horizontal, 6)
                        } else {
                            // If not focused, show typed text or placeholder
                            if cravingText.isEmpty {
                                // "TAP TO LOG CRAVING" with a sexy gradient
                                Text("TAP TO LOG CRAVING")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.clear) // make text invisible
                                    .overlay {
                                        // The gradient we want to overlay
                                        sexyGradient
                                    }
                                    .mask {
                                        // Mask the gradient to the shape of our text
                                        Text("TAP TO LOG CRAVING")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                            } else {
                                // Show whatever the user typed
                                Text(cravingText)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 6)
                            }
                        }
                    }
                    // Tapping the box focuses the TextField (watchOS "keyboard")
                    .onTapGesture {
                        isCravingFocused = true
                    }
                    
                    // D) Bottom line: "LONELY TIRED"
                    Text("LONELY TIRED")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                    
                    // E) Log button
                    Button(action: logCraving) {
                        Text("Log")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 26)
                            .background(premiumBlueGradient)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)
                }
                // Add any side overlays, e.g., the checkmark confirmation
                .overlay(ConfirmationOverlay(isPresented: $showConfirmation))
                
                // Example navigation to an "Intensity" screen
                .navigationDestination(isPresented: $showAdjustScreen) {
                    CravingIntensityView(intensity: $intensity, resistance: $resistance)
                }
            }
        }
    }
    
    // MARK: - Actions

    /// Logs the craving to SwiftData and sends it to phone via WatchConnectivity
    private func logCraving() {
        // 1) Make sure there's actually something typed
        guard !cravingText.trimmingCharacters(in: .whitespaces).isEmpty else {
            // If user hasn't typed anything, do nothing or show an alert
            return
        }
        
        // 2) Create a new craving entity
        let newCraving = WatchCravingEntity(
            text: cravingText.trimmingCharacters(in: .whitespaces),
            intensity: intensity,
            timestamp: Date()
        )
        
        // 3) Insert it into the SwiftData context
        context.insert(newCraving)
        
        // 4) Send the new craving to the phone (if desired)
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        // 5) Optionally clear the text after logging
        // cravingText = ""
        
        // 6) Show the checkmark confirmation overlay
        showConfirmation = true
        
        // 7) Trigger a success haptic on watch
        WatchHapticManager.shared.play(.success)
    }
}

// MARK: - Confirmation Overlay
/// An overlay that shows a checkmark for a short time after logging
struct ConfirmationOverlay: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            ZStack {
                // Dark background so the checkmark stands out
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                
                // Checkmark icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
            }
            .onAppear {
                // Hide automatically after 1 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                }
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Example Gradient for the placeholder text
/// A colorful gradient used for "TAP TO LOG CRAVING"
fileprivate let sexyGradient = LinearGradient(
    gradient: Gradient(colors: [
        // Tweak hues/saturation/brightness to get your "sexy" look
        Color(hue: 0.65, saturation: 0.8, brightness: 0.8),
        Color(hue: 0.75, saturation: 0.9, brightness: 0.6)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

// MARK: - Premium 2-Stop Blue Gradient for the Log button
/// A dark-ish blue gradient for your main button background
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        // You can change these color stops to match your brand
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7), // top
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)  // bottom
    ]),
    startPoint: .top,
    endPoint: .bottom
)
