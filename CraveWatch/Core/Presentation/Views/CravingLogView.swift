//
//  CravingLogView.swift
//  CraveWatch
//
//  A 4-page flow in a TabView(.page) style:
//    Page 0: AllySupportView  (swipe left from Log to get here)
//    Page 1: Log screen       (starting page)
//    Page 2: Intensity        (Next from Log, or swipe right)
//    Page 3: Resistance       (Next from Intensity, or swipe right)
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

    // We now have 4 pages. Start the user on Page 1 (Log).
    @State private var currentTab: Int = 1

    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $currentTab) {

                // MARK: - PAGE 0: ALLY SUPPORT (Leftmost)
                AllySupportView()
                    .tag(0)

                // MARK: - PAGE 1: LOG CRAVING
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
                        // "Next" → go to Intensity (page 2)
                        currentTab = 2
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
                .tag(1)

                // MARK: - PAGE 2: INTENSITY
                VStack(spacing: 12) {
                    IntensityInputView(
                        intensity: $viewModel.intensity,
                        onIntensityChanged: viewModel.intensityChanged
                    )
                    
                    Button(action: {
                        // "Next" → go to Resistance (page 3)
                        currentTab = 3
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
                .tag(2)

                // MARK: - PAGE 3: RESISTANCE
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
                .tag(3)
            }
            .tabViewStyle(.page)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .scrollIndicators(.hidden)

            // MARK: - Digital crown sync
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
                    // Optionally reset to the Log page:
                    // currentTab = 1
                }
            }

            // MARK: - Overlays
            .overlay(alignment: .center) {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .overlay {
                if viewModel.showConfirmation {
                    ConfirmationOverlay(isPresented: $viewModel.showConfirmation)
                }
            }
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
            // After success checkmark, reset to page 1 (Log)
            .onChange(of: viewModel.showConfirmation) {
                if !viewModel.showConfirmation {
                    currentTab = 1
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
                // Auto-dismiss after 1 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                }
            }
        } else {
            EmptyView()
        }
    }
}

