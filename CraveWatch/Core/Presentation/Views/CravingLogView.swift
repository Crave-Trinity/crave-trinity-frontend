// File: CraveWatch/Core/Presentation/Views/CravingLogView.swift
// Project: CraveTrinity
// Directory: ./CraveWatch/Core/Presentation/Views/
//
// Description: Primary watch interface for logging cravings with
// haptic feedback and optimized watch UX.

import SwiftUI
import SwiftData

struct CravingLogView: View {
    // MARK: - Environment
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - View Model
    @ObservedObject var viewModel: CravingLogViewModel
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // MARK: - Header
                Text("Log Craving")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.primary)
                    .padding(.top, 8)
                
                // MARK: - Text Input
                WatchCraveTextEditor(
                    text: $viewModel.cravingDescription,
                    placeholder: "Describe your craving...",
                    characterLimit: 280
                )
                .padding(.horizontal, 8)
                
                // MARK: - Intensity Control
                IntensityControl(value: $viewModel.intensity)
                    .padding(.vertical, 8)
                
                // MARK: - Submit Button
                Button(action: {
                    WatchHapticManager.shared.play(.success)
                    viewModel.logCraving(context: modelContext)
                }) {
                    Text("Log")
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(viewModel.cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal, 8)
            }
        }
        // MARK: - Success Overlay
        .overlay(
            Group {
                if viewModel.showConfirmation {
                    SuccessOverlay {
                        viewModel.showConfirmation = false
                    }
                }
            }
        )
        // MARK: - Error Handling
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

// MARK: - Supporting Views
private struct IntensityControl: View {
    @Binding var value: Int
    @State private var rotationValue: Double
    
    init(value: Binding<Int>) {
        self._value = value
        self._rotationValue = State(initialValue: Double(value.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Intensity: \(value)")
                .font(.system(.body, design: .rounded))
            
            // Circular progress indicator
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 4)
                
                Circle()
                    .trim(from: 0, to: CGFloat(value) / 10.0)
                    .stroke(Color.blue, style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    ))
                    .rotationEffect(.degrees(-90))
                
                Text("\(value)")
                    .font(.system(.title2, design: .rounded, weight: .bold))
            }
            .frame(height: 50)
            .focusable(true)
            .digitalCrownRotation(
                $rotationValue,
                from: 1.0,
                through: 10.0,
                by: 1.0,
                sensitivity: .medium,
                isContinuous: false,
                isHapticFeedbackEnabled: true
            )
            .onChange(of: rotationValue) { oldValue, newValue in
                value = Int(newValue.rounded())
                WatchHapticManager.shared.play(.intensity(level: value))
            }
        }
    }
}

private struct SuccessOverlay: View {
    var onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.green)
            
            Text("Logged!")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.7))
        .onTapGesture(perform: onDismiss)
        .onAppear {
            WatchHapticManager.shared.playProgressComplete()
            // Auto-dismiss after 1.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onDismiss()
            }
        }
    }
}

// MARK: - Preview Provider
#Preview {
    let dummyService = WatchConnectivityService()
    let vm = CravingLogViewModel(connectivityService: dummyService)
    return CravingLogView(viewModel: vm)
        .modelContainer(for: WatchCravingEntity.self, inMemory: true)
}
