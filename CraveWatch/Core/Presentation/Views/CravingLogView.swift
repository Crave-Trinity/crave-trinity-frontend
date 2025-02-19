import SwiftUI
import SwiftData

struct CravingLogView: View {
    // SwiftData context
    @Environment(\.modelContext) private var context
    
    // User inputs
    @State private var cravingDescription: String = ""
    @State private var intensity: Int = 5       // vertical slider
    @State private var resistance: Int = 5      // horizontal slider
    
    // Confirmation overlay
    @State private var showConfirmation: Bool = false
    
    // Focus for watch keyboard
    @FocusState private var isTextFieldFocused: Bool
    
    // Connectivity
    @ObservedObject var connectivityService: WatchConnectivityService

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                
                // 1) Top Row: Text box on the left, vertical bar on the right
                HStack(alignment: .top, spacing: 8) {
                    // A. The text editor, bigger
                    WatchCraveTextEditor(
                        text: $cravingDescription,
                        primaryPlaceholder: "Craving, Trigger",
                        secondaryPlaceholder: "Hungry, Angry\nLonely, Tired",
                        isFocused: $isTextFieldFocused,
                        characterLimit: 60
                    )
                    .frame(minHeight: 80, maxHeight: 100)  // Make it a bit taller
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(8)
                    
                    // B. The vertical intensity bar + numeric label
                    VStack(spacing: 4) {
                        // Numeric label for intensity
                        Text("\(intensity)")
                            .font(.title3)
                            .fontWeight(.semibold)
                        // The vertical bar
                        VerticalIntensityBar(value: $intensity)
                    }
                    .frame(minWidth: 50)
                }
                
                // 2) Middle: A labeled horizontal bar for Resistance
                VStack(spacing: 4) {
                    Text("Resistance")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    HorizontalResistanceBar(value: $resistance)
                }
                .padding(.top, 4)
                
                // 3) The Log button at the bottom
                Button(action: logCraving) {
                    Text("Log")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .buttonBorderShape(.roundedRectangle)
            }
            .padding(.horizontal, 12)
        }
        .overlay(
            ConfirmationOverlay(isPresented: $showConfirmation)
        )
        .toolbar(isTextFieldFocused ? .hidden : .visible)
    }
    
    /// Saves a new craving and sends it to phone
    private func logCraving() {
        guard !cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let newCraving = WatchCravingEntity(
            text: cravingDescription.trimmingCharacters(in: .whitespaces),
            intensity: intensity,
            timestamp: Date()
        )
        
        // Insert to SwiftData
        context.insert(newCraving)
        
        // Send to phone
        connectivityService.sendCravingToPhone(craving: newCraving)
        
        // Reset
        cravingDescription = ""
        intensity = 5
        resistance = 5
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
