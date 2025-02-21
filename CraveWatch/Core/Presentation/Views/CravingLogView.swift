// CraveWatch/Core/Presentation/Views/CravingLogView.swift
import SwiftUI
import SwiftData

struct CravingLogView: View {
    // MARK: - Environment and Observed State

    /// The SwiftData model context from the environment.
    @Environment(\.modelContext) private var context
    /// The view model managing the business logic and state for this view.
    @ObservedObject var viewModel: CravingLogViewModel
    /// Focus state for the custom text editor.
    @FocusState private var isEditorFocused: Bool
    /// The scene phase (active, inactive, background) from the environment.
    @Environment(\.scenePhase) private var scenePhase
    
    // State for digital crown rotation
    @State private var crownIntensity: Double = 5.0

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ScrollView { // Add ScrollView for scrollability
                VStack(spacing: 8) {
                    // Conditionally show the resistance input view if needed.
                    if viewModel.isResistanceViewActive {
                        ResistanceInputView(
                            resistance: $viewModel.resistance,
                            onResistanceChanged: viewModel.resistanceChanged
                        )
                    } else {
                        // Main craving logging UI
                        Text("TRIGGER")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)

                        Text("Hungry         Angry")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.85))

                        WatchCraveTextEditor(
                            text: $viewModel.cravingText,
                            primaryPlaceholder: "Log Craving",
                            secondaryPlaceholder: "200 chars",
                            isFocused: $isEditorFocused,
                            characterLimit: 200
                        )
                        .frame(height: 60)

                        Text("Lonely         Tired")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.85))

                        IntensityInputView(
                            intensity: $viewModel.intensity,
                            onIntensityChanged: viewModel.intensityChanged
                        )
                    }

                    // The main button triggers logging or advances to resistance view.
                    Button(action: {
                        if viewModel.isResistanceViewActive {
                            viewModel.logCraving(context: context)
                        } else {
                            viewModel.nextAction()
                        }
                    }) {
                        Text(viewModel.isResistanceViewActive ? "Log" : "Next")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 26)
                            .background(viewModel.isResistanceViewActive ? premiumGreenGradient : premiumBlueGradient)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                    .disabled(viewModel.isLoading)
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, -2)
                .padding(.bottom, 6)
                .padding(.horizontal) // Add horizontal padding
                .frame(width: geometry.size.width) // Use full width
                // Overlay a progress view if loading.
                .overlay(alignment: .center) {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
                // Overlay a confirmation view if needed.
                .overlay {
                    if viewModel.showConfirmation {
                        ConfirmationOverlay(isPresented: $viewModel.showConfirmation)
                    }
                }
                // Alert for errors.
                .alert("Error", isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { newValue in if !newValue { viewModel.dismissError() } }
                )) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
            }
            .scrollIndicators(.hidden)
            .focusable() // Make the ScrollView focusable
            // Bind digitalCrownRotation to a Double, and update viewModel.intensity
            .digitalCrownRotation($crownIntensity, from: 1.0, through: 10.0, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
            .onChange(of: crownIntensity) { oldValue, newValue in
                viewModel.intensity = Int(newValue) // Convert Double back to Int
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .inactive || newPhase == .background {
                    viewModel.isResistanceViewActive = false
                }
            }
            //Important to sync up the crown and viewmodel intensity.
            .onAppear {
                crownIntensity = Double(viewModel.intensity)
            }
        }
    }
}

// MARK: - Confirmation Overlay (No Changes)

/// A simple overlay that confirms a successful action.
struct ConfirmationOverlay: View {
    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            ZStack {
                // Dim the background to focus attention.
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                // Display a confirmation checkmark.
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
            }
            .onAppear {
                // Auto-dismiss the confirmation after 1 second.
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                }
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Premium Blue Gradient (No Changes)

/// A consistent blue gradient for button backgrounds.
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)

// MARK: - Premium Green Gradient (No Changes)

/// A consistent green gradient for button backgrounds.
fileprivate let premiumGreenGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.35, saturation: 0.8, brightness: 0.7),
        Color(hue: 0.35, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)
