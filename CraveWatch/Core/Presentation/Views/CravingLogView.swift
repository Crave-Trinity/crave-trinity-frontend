//
//  CravingLogView.swift
//  CraveWatch
//

import SwiftUI
import SwiftData

struct CravingLogView: View {
    // MARK: - Environment and Observed State
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    @ObservedObject var viewModel: CravingLogViewModel
    @FocusState private var isEditorFocused: Bool

    // For the Digital Crown → maps to "viewModel.intensity"
    @State private var crownIntensity: Double = 5.0

    // Track which of the three pages (0..2) is showing
    @State private var currentTab: Int = 0

    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $currentTab) {
                // 1) Text input
                VStack(spacing: 8) {
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

                    Button(action: {
                        // Next → Page 1
                        currentTab = 1
                    }) {
                        Text("Next")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 26)
                            .background(premiumBlueGradient)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                    .disabled(viewModel.isLoading)
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, -2)
                .padding(.bottom, 6)
                .padding(.horizontal)
                .frame(width: geometry.size.width)
                .tag(0)

                // 2) Intensity
                VStack(spacing: 12) {
                    IntensityInputView(
                        intensity: $viewModel.intensity,
                        onIntensityChanged: viewModel.intensityChanged
                    )
                    
                    Button(action: {
                        // Next → Page 2
                        currentTab = 2
                    }) {
                        Text("Next")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 26)
                            .background(premiumOrangeGradient)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isLoading)
                    .frame(maxWidth: .infinity)
                }
                .frame(width: geometry.size.width)
                .tag(1)

                // 3) Resistance
                VStack(spacing: 12) {
                    ResistanceInputView(
                        resistance: $viewModel.resistance,
                        onResistanceChanged: viewModel.resistanceChanged
                    )
                    
                    Button(action: {
                        // Log and show confirmation
                        viewModel.logCraving(context: context)
                    }) {
                        Text("Log")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 26)
                            .background(premiumGreenGradient)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isLoading)
                    .frame(maxWidth: .infinity)
                }
                .frame(width: geometry.size.width)
                .tag(2)
            }
            .tabViewStyle(.page)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .scrollIndicators(.hidden)

            // Digital crown sync
            .focusable()
            .digitalCrownRotation($crownIntensity,
                                  from: 1.0, through: 10.0, by: 1.0,
                                  sensitivity: .low,
                                  isContinuous: false,
                                  isHapticFeedbackEnabled: true)
            .onChange(of: crownIntensity) { oldValue, newValue in
                viewModel.intensity = Int(newValue)
            }
            .onAppear {
                crownIntensity = Double(viewModel.intensity)
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .inactive || newPhase == .background {
                    // Optionally reset to the first tab:
                    // currentTab = 0
                }
            }

            // Show progress if loading
            .overlay(alignment: .center) {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            // Confirmation overlay
            .overlay {
                if viewModel.showConfirmation {
                    ConfirmationOverlay(isPresented: $viewModel.showConfirmation)
                }
            }
            // Alert for errors
            .alert("Error",
                   isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { newVal in if !newVal { viewModel.dismissError() } }
                   )
            ) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            // Reset to first tab when confirmation is dismissed using the zero-parameter onChange:
            .onChange(of: viewModel.showConfirmation) {
                if !viewModel.showConfirmation {
                    currentTab = 0
                }
            }
        }
    }
}

// MARK: - Gradients

fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)

fileprivate let premiumOrangeGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.10, saturation: 0.8, brightness: 1.0),
        Color(hue: 0.10, saturation: 0.9, brightness: 0.6)
    ]),
    startPoint: .top,
    endPoint: .bottom
)

fileprivate let premiumGreenGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.35, saturation: 0.8, brightness: 0.7),
        Color(hue: 0.35, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)

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
                // Auto-dismiss the confirmation after 1 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                }
            }
        } else {
            EmptyView()
        }
    }
}

