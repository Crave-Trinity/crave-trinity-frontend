//ViewModels/CravingLogViewModel.swift

import SwiftUI
import SwiftData

struct CravingLogView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: CravingLogViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                
                // Text Input Area
                SleekTextInputArea(text: $viewModel.cravingDescription)
                    .frame(height: 80) // Adjust as desired for your design
                
                // Intensity Control
                SleekIntensityControl(intensity: $viewModel.intensity)
                
                // Log Button
                Button(action: {
                    WatchHapticManager.shared.play(.success)
                    viewModel.logCraving(context: modelContext)
                }) {
                    Text("Log")
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                .controlSize(.mini)
                .disabled(
                    viewModel.cravingDescription
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty
                )
            }
            .padding(.horizontal, 4)
        }
        .overlay(
            Group {
                if viewModel.showConfirmation {
                    SuccessOverlay {
                        viewModel.showConfirmation = false
                    }
                }
            }
        )
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.dismissError() }
        )) {
            Button("OK", role: .cancel) {
                WatchHapticManager.shared.play(.error)
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// MARK: - Sleek Text Input
private struct SleekTextInputArea: View {
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder
            if text.isEmpty {
                VStack(alignment: .center, spacing: 2) {
                    Text("Craving, Trigger")
                        .font(.system(.title3, weight: .semibold))
                        .foregroundColor(.gray.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("Hungry, Angry\nLonely, Tired")
                        .font(.system(.footnote))
                        .foregroundColor(.gray.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 2)
                .frame(maxWidth: .infinity)
            }
            
            // Actual Text Input
            TextField("", text: $text)
                .multilineTextAlignment(.center)  // Center the typed text, too
                .textFieldStyle(.plain)
                .font(.system(.body))
                .foregroundColor(.primary)
                .padding(.top, text.isEmpty ? 36 : 0)
        }
        // Slight background “bubble”
        .padding(6)
        .background(
            Color.gray.opacity(0.1)
                .cornerRadius(8)
        )
    }
}

// MARK: - Sleek Intensity Control
private struct SleekIntensityControl: View {
    @Binding var intensity: Int
    
    var body: some View {
        VStack(spacing: 2) {
            Text("Intensity: \(intensity)")
                .font(.footnote)
                .foregroundColor(.gray)
            
            Slider(
                value: Binding(
                    get: { Double(intensity) },
                    set: { intensity = Int($0) }
                ),
                in: 1...10,
                step: 1
            )
            .tint(.blue)
            .frame(height: 14) // Slimmer slider
            .onChange(of: intensity) { _, newValue in
                WatchHapticManager.shared.play(.intensity(level: newValue))
            }
        }
    }
}

// MARK: - Success Overlay
private struct SuccessOverlay: View {
    var onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.green)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.7))
        .onTapGesture(perform: onDismiss)
        .onAppear {
            WatchHapticManager.shared.playProgressComplete()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onDismiss()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let dummyService = WatchConnectivityService()
    let vm = CravingLogViewModel(connectivityService: dummyService)
    return CravingLogView(viewModel: vm)
        .modelContainer(for: WatchCravingEntity.self, inMemory: true)
}
