//
//  CravingLogView.swift
//  CraveWatch
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
        // 1) Use GeometryReader to adapt layout to watch screen size
        GeometryReader { proxy in
            let screenWidth = proxy.size.width
            
            // 2) Decide how much of the screen the text box and slider should occupy
            //    (Tune these multipliers to your taste)
            let textBoxWidth = screenWidth * 0.60       // ~60% of available width
            let sliderPadding = screenWidth * 0.10      // negative trailing padding
            let sliderOffset = screenWidth * 0.05       // additional offset
            let hStackSpacing = screenWidth * 0.02      // minimal horizontal spacing

            // 3) Use a simple threshold to tweak the button size on bigger screens
            let isLargeWatch = screenWidth > 180        // Rough cutoff for 44mm+ vs. smaller

            VStack(spacing: 4) {
                // Horizontal layout
                HStack(spacing: hStackSpacing) {
                    // Wider text box: scale with screenWidth
                    WatchCraveTextEditor(
                        text: $cravingDescription,
                        primaryPlaceholder: "Craving, Trigger",
                        secondaryPlaceholder: "Hungry, Angry\nLonely, Tired",
                        isFocused: $isTextFieldFocused,
                        characterLimit: 80
                    )
                    .frame(width: textBoxWidth, height: 130)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // Slider near Crown, with dynamic negative padding/offset
                    VerticalIntensityBar(value: $intensity, barWidth: 4)
                        .padding(.trailing, -sliderPadding)
                        .offset(x: -sliderOffset)
                }

                // “Log” button: smaller overall, but bigger text if watch is large
                Button(action: logCraving) {
                    Text("Log")
                        .font(.system(size: isLargeWatch ? 16 : 14, weight: .bold))
                        .foregroundColor(.white)
                        // minimal padding => physically smaller, but still test tap size
                        .padding(.horizontal, isLargeWatch ? 8 : 6)
                        .padding(.vertical, isLargeWatch ? 4 : 2)
                }
                // custom background & shape instead of .bordered style
                .background(Color.blue)
                .cornerRadius(4)
            }
            .overlay(ConfirmationOverlay(isPresented: $showConfirmation))
            // Hide watch toolbar if text field is focused
            .toolbar(isTextFieldFocused ? .hidden : .visible)
        }
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
